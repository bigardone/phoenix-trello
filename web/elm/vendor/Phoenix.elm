effect module Phoenix where { command = MyCmd, subscription = MySub } exposing (connect, push)

{-| An Elm client for [Phoenix](http://www.phoenixframework.org) Channels.

This package makes it easy to connect to Phoenix Channels, but in a more declarative manner than the Phoenix Socket Javascript library. Simply provide a `Socket` and a list of `Channel`s you want to join and this library handles the tedious parts like opening a connection, joining channels, reconnecting after a network error and registering event handlers.


#Connect with Phoenix
@docs connect

# Push messages
@docs push
-}

import Json.Encode as Encode exposing (Value)
import WebSocket.LowLevel as WS
import Dict exposing (Dict)
import Task exposing (Task)
import Process
import Phoenix.Message as Message exposing (Message)
import Phoenix.Channel as Channel
import Phoenix.ChannelHelpers as ChannelHelpers
import Phoenix.Socket as Socket
import Phoenix.SocketHelpers as SocketHelpers
import Phoenix.Helpers as Helpers exposing ((&>), (<&>))
import Phoenix.Push as Push exposing (Push)


-- SUBSCRIPTIONS


type MySub msg
    = Connect Socket (List (Channel msg))


{-| Declare a socket you want to connect to and the channels you want to join. The effect manager will open the socket connection, join the channels. See `Phoenix.Socket` and `Phoenix.Channel` for more configuration and behaviour details.

    import Phoenix.Socket as Socket
    import Phoenix.Channel as Channel

    type Msg = NewMsg Value | ...

    socket =
        Socket.init "ws://localhost:4000/socket/websocket"

    channel =
        Channel.init "room:lobby"
            -- register a handler for messages
            -- with a "new_msg" event
            |> Channel.on "new_msg" NewMsg

    subscriptions model =
        connect socket [channel]

**Note**: An empty channel list keeps the socket connection open.
-}
connect : Socket -> List (Channel msg) -> Sub msg
connect socket channels =
    subscription (Connect socket channels)



-- COMMANDS


type MyCmd msg
    = Send Endpoint (Push msg)


{-| Pushes a `Push` message to a particular socket address. The address has to be the same as with which you initalized the `Socket` in the `connect` subscription.

    payload =
        Json.Encode.object [("msg", "Hello Phoenix")]

    message =
        Push.init "room:lobby" "new_msg"
            |> Push.withPayload payload

    push "ws://localhost:4000/socket/websocket" message


**Note**: The message will be queued until you successfully joined a channel to the topic of the message.
-}
push : String -> Push msg -> Cmd msg
push endpoint push' =
    command (Send endpoint push')


cmdMap : (a -> b) -> MyCmd a -> MyCmd b
cmdMap func cmd =
    case cmd of
        Send endpoint push' ->
            Send endpoint (Push.map func push')



-- SUB MAP


subMap : (a -> b) -> MySub a -> MySub b
subMap func sub =
    case sub of
        Connect socket channels ->
            Connect socket (List.map (ChannelHelpers.map func) channels)


type alias Message =
    Message.Message


type alias Channel msg =
    Channel.Channel msg


type alias Socket =
    Socket.Socket



-- INTERNALS


type alias State msg =
    { sockets : SocketsDict
    , channels : ChannelsDict msg
    , selfCallbacks : Dict Ref (SelfCallback msg)
    , channelQueues : ChannelQueuesDict msg
    }


type alias SocketsDict =
    Dict Endpoint Socket


type alias ChannelsDict msg =
    Dict Endpoint (Dict Topic (Channel msg))


type alias SubsDict msg =
    Dict Endpoint (EndpointSubsDict msg)


type alias EndpointSubsDict msg =
    Dict Topic (Dict Event (List (Callback msg)))


type alias ChannelQueuesDict msg =
    Dict Endpoint (Dict Topic (List ( Message, Maybe (SelfCallback msg) )))


type alias Callback msg =
    Value -> msg


type alias Endpoint =
    String


type alias Topic =
    String


type alias Event =
    String


type alias Ref =
    Int



-- INIT


init : Task Never (State msg)
init =
    Task.succeed (State Dict.empty Dict.empty Dict.empty Dict.empty)



-- HANDLE APP MESSAGES


onEffects :
    Platform.Router msg (Msg msg)
    -> List (MyCmd msg)
    -> List (MySub msg)
    -> State msg
    -> Task Never (State msg)
onEffects router cmds subs state =
    let
        definedSockets =
            buildSocketsDict subs

        definedChannels =
            buildChannelsDict subs Dict.empty

        updateState newState =
            let
                getNewChannels =
                    handleChannelsUpdate router definedChannels newState.channels

                getNewSockets =
                    handleSocketsUpdate router definedSockets newState.sockets
            in
                Task.map2 (\newSockets newChannels -> { newState | sockets = newSockets, channels = newChannels })
                    getNewSockets
                    getNewChannels
    in
        sendPushsHelp cmds state <&> \newState -> updateState newState



-- BUILD SOCKETS


buildSocketsDict : List (MySub msg) -> SocketsDict
buildSocketsDict subs =
    let
        insert sub dict =
            case sub of
                Connect socket _ ->
                    Dict.insert socket.endpoint socket dict
    in
        List.foldl insert Dict.empty subs



-- BUILD CHANNELS


buildChannelsDict : List (MySub msg) -> ChannelsDict msg -> ChannelsDict msg
buildChannelsDict subs dict =
    case subs of
        [] ->
            dict

        (Connect { endpoint } channels) :: rest ->
            let
                build channel dict' =
                    buildChannelsDict rest (Helpers.insertIn endpoint channel.topic channel dict')
            in
                List.foldl build dict channels


sendPushsHelp : List (MyCmd msg) -> State msg -> Task x (State msg)
sendPushsHelp cmds state =
    case cmds of
        [] ->
            Task.succeed state

        (Send endpoint push) :: rest ->
            let
                message =
                    Message.fromPush push
            in
                pushSocket endpoint message (Just <| PushResponse push) state
                    <&> sendPushsHelp rest


handleSocketsUpdate : Platform.Router msg (Msg msg) -> SocketsDict -> SocketsDict -> Task Never (SocketsDict)
handleSocketsUpdate router definedSockets stateSockets =
    let
        -- leftStep: endpoints where we have to open a new socket connection
        leftStep endpoint definedSocket getNewSockets =
            getNewSockets
                <&> \newSockets ->
                        attemptOpen router 0 definedSocket
                            <&> \pid ->
                                    Task.succeed (Dict.insert endpoint (SocketHelpers.opening 0 pid definedSocket) newSockets)

        -- we update the authentication parameters
        bothStep endpoint definedSocket stateSocket getNewSockets =
            Task.map (Dict.insert endpoint <| SocketHelpers.updateParams definedSocket.params stateSocket) getNewSockets

        rightStep endpoint stateSocket getNewSockets =
            SocketHelpers.close stateSocket &> getNewSockets
    in
        Dict.merge leftStep bothStep rightStep definedSockets stateSockets (Task.succeed Dict.empty)


handleChannelsUpdate : Platform.Router msg (Msg msg) -> ChannelsDict msg -> ChannelsDict msg -> Task Never (ChannelsDict msg)
handleChannelsUpdate router definedChannels stateChannels =
    let
        leftStep endpoint definedEndpointChannels getNewChannels =
            let
                sendJoin =
                    Dict.values definedEndpointChannels
                        |> List.foldl (\channel task -> task &> sendJoinChannel router endpoint channel)
                            (Task.succeed ())

                insert newChannels =
                    Task.succeed (Dict.insert endpoint definedEndpointChannels newChannels)
            in
                sendJoin &> getNewChannels <&> insert

        bothStep endpoint definedEndpointChannels stateEndpointChannels getNewChannels =
            let
                getEndpointChannels =
                    handleEndpointChannelsUpdate router endpoint definedEndpointChannels stateEndpointChannels
            in
                Task.map2 (\endpointChannels newChannels -> Dict.insert endpoint endpointChannels newChannels)
                    getEndpointChannels
                    getNewChannels

        rightStep endpoint stateEndpointChannels getNewChannels =
            let
                sendLeave =
                    Dict.values stateEndpointChannels
                        |> List.foldl (\channel task -> task &> sendLeaveChannel router endpoint channel)
                            (Task.succeed ())
            in
                sendLeave &> getNewChannels
    in
        Dict.merge leftStep bothStep rightStep definedChannels stateChannels (Task.succeed Dict.empty)


handleEndpointChannelsUpdate : Platform.Router msg (Msg msg) -> Endpoint -> Dict Topic (Channel msg) -> Dict Topic (Channel msg) -> Task Never (Dict Topic (Channel msg))
handleEndpointChannelsUpdate router endpoint definedChannels stateChannels =
    let
        leftStep topic defined getNewChannels =
            (sendJoinChannel router endpoint defined) &> Task.map (Dict.insert topic defined) getNewChannels

        bothStep topic defined state getNewChannels =
            let
                channel =
                    state
                        |> ChannelHelpers.updatePayload defined.payload
                        |> ChannelHelpers.updateOn defined.on
            in
                Task.map (Dict.insert topic channel) getNewChannels

        rightStep topic state getNewChannels =
            (sendLeaveChannel router endpoint state) &> getNewChannels
    in
        Dict.merge leftStep bothStep rightStep definedChannels stateChannels (Task.succeed Dict.empty)


sendLeaveChannel : Platform.Router msg (Msg msg) -> Endpoint -> Channel msg -> Task Never ()
sendLeaveChannel router endpoint channel =
    case channel.state of
        Channel.Joined ->
            Platform.sendToSelf router (LeaveChannel endpoint channel)

        _ ->
            Task.succeed ()


sendJoinChannel : Platform.Router msg (Msg msg) -> Endpoint -> Channel msg -> Task Never ()
sendJoinChannel router endpoint channel =
    Platform.sendToSelf router (JoinChannel endpoint channel)



-- STATE UPDATE HELPERS


updateSocket : Endpoint -> Socket -> State msg -> State msg
updateSocket endpoint socket state =
    { state | sockets = Dict.insert endpoint socket state.sockets }


updateChannels : ChannelsDict msg -> State msg -> State msg
updateChannels channels state =
    { state | channels = channels }


updateSelfCallbacks : Dict Ref (SelfCallback msg) -> State msg -> State msg
updateSelfCallbacks selfCallbacks state =
    { state | selfCallbacks = selfCallbacks }


removeChannelQueue : Endpoint -> Topic -> State msg -> State msg
removeChannelQueue endpoint topic state =
    { state | channelQueues = Helpers.removeIn endpoint topic state.channelQueues }


insertSocket : Endpoint -> Socket -> State msg -> State msg
insertSocket endpoint socket state =
    { state
        | sockets = Dict.insert endpoint socket state.sockets
    }


insertSelfCallback : Ref -> Maybe (SelfCallback msg) -> State msg -> State msg
insertSelfCallback ref maybeSelfCb state =
    case maybeSelfCb of
        Nothing ->
            state

        Just selfCb ->
            { state
                | selfCallbacks = Dict.insert ref selfCb state.selfCallbacks
            }



-- HANDLE INTERN MESSAGES


type alias SelfCallback msg =
    Message -> Msg msg


type Msg msg
    = Receive Endpoint Message
    | Die String { code : Int, reason : String, wasClean : Bool }
    | GoodOpen String WS.WebSocket
    | BadOpen String WS.BadOpen
    | Register
    | JoinChannel Endpoint (Channel msg)
    | LeaveChannel Endpoint (Channel msg)
    | ChannelLeaveReply Endpoint (Channel msg) Message
    | ChannelJoinReply Endpoint Topic Channel.State Message
    | GoodJoin Endpoint Topic
    | SendHeartbeat Endpoint
    | PushResponse (Push msg) Message


onSelfMsg : Platform.Router msg (Msg msg) -> Msg msg -> State msg -> Task Never (State msg)
onSelfMsg router selfMsg state =
    case selfMsg of
        GoodOpen endpoint ws ->
            case SocketHelpers.get endpoint state.sockets of
                Just socket ->
                    let
                        _ =
                            if socket.debug then
                                Debug.log "WebSocket connected with " endpoint
                            else
                                endpoint

                        state' =
                            insertSocket endpoint (SocketHelpers.connected ws socket) state
                    in
                        (heartbeat router endpoint state')
                            <&> \newState ->
                                    rejoinAllChannels endpoint newState

                Nothing ->
                    let
                        socket =
                            Socket.init endpoint
                                |> SocketHelpers.connected ws
                    in
                        Platform.sendToSelf router (GoodOpen endpoint ws)
                            &> Task.succeed (updateSocket endpoint socket state)

        BadOpen endpoint details ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just socket ->
                    let
                        _ =
                            if socket.debug then
                                Debug.log ("WebSocket couldn't connect with " ++ endpoint) details
                            else
                                details

                        backoffIteration =
                            case socket.connection of
                                Socket.Opening n _ ->
                                    n + 1

                                _ ->
                                    0

                        backoff =
                            socket.reconnectTimer backoffIteration

                        newState pid =
                            (updateSocket endpoint (SocketHelpers.opening backoffIteration pid socket)) state
                    in
                        attemptOpen router backoff socket
                            |> Task.map newState

        Die endpoint details ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just socket ->
                    let
                        backoffIteration =
                            case socket.connection of
                                Socket.Opening n _ ->
                                    n + 1

                                _ ->
                                    0

                        backoff =
                            socket.reconnectTimer backoffIteration

                        -- update channels because of disconnect
                        getNewState =
                            handleChannelDisconnect router endpoint state

                        finalNewState pid =
                            Task.map (updateSocket endpoint (SocketHelpers.opening backoffIteration pid socket)) getNewState
                    in
                        attemptOpen router backoff socket
                            `Task.andThen` finalNewState

        Receive endpoint message ->
            dispatchMessage router endpoint message state.channels
                &> ((handleSelfcallback router endpoint message state.selfCallbacks)
                        |> Task.map (\selfCbs -> updateSelfCallbacks selfCbs state)
                   )
                <&> handlePhoenixMessage router endpoint message

        ChannelJoinReply endpoint topic oldState message ->
            (handleChannelJoinReply router endpoint topic message oldState state.channels)
                |> Task.map (\newChannels -> updateChannels newChannels state)

        JoinChannel endpoint channel ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just socket ->
                    case socket.connection of
                        Socket.Connected _ _ ->
                            pushSocket' endpoint (ChannelHelpers.joinMessage channel) (Just <| ChannelJoinReply endpoint channel.topic channel.state) state

                        -- Nothing to do GoodOpen will handle the join
                        _ ->
                            Task.succeed state

        LeaveChannel endpoint channel ->
            case Dict.get endpoint state.sockets of
                Nothing ->
                    Task.succeed state

                Just socket ->
                    case channel.state of
                        Channel.Joined ->
                            pushSocket' endpoint (ChannelHelpers.leaveMessage channel) (Just <| ChannelLeaveReply endpoint channel) state

                        _ ->
                            Task.succeed state

        ChannelLeaveReply endpoint channel message ->
            case Helpers.decodeReplyPayload message.payload of
                Nothing ->
                    Task.succeed state

                Just reply ->
                    case reply of
                        Err error ->
                            case channel.onLeaveError of
                                Nothing ->
                                    Task.succeed state

                                Just onLeaveError ->
                                    Platform.sendToApp router (onLeaveError error) &> Task.succeed state

                        Ok ok ->
                            case channel.onLeave of
                                Nothing ->
                                    Task.succeed state

                                Just onLeave ->
                                    Platform.sendToApp router (onLeave ok) &> Task.succeed state

        SendHeartbeat endpoint ->
            (heartbeat router endpoint state)

        GoodJoin endpoint topic ->
            case Helpers.getIn endpoint topic state.channelQueues of
                Nothing ->
                    Task.succeed state

                Just queuedMessages ->
                    processQueue endpoint queuedMessages state
                        |> Task.map (removeChannelQueue endpoint topic)

        PushResponse push' message ->
            case Helpers.decodeReplyPayload message.payload of
                Nothing ->
                    Task.succeed state

                Just reply ->
                    case reply of
                        Err error ->
                            case push'.onError of
                                Nothing ->
                                    Task.succeed state

                                Just onError ->
                                    Platform.sendToApp router (onError error) &> Task.succeed state

                        Ok ok ->
                            case push'.onOk of
                                Nothing ->
                                    Task.succeed state

                                Just onOk ->
                                    Platform.sendToApp router (onOk ok) &> Task.succeed state

        _ ->
            Task.succeed state


handleSelfcallback : Platform.Router msg (Msg msg) -> Endpoint -> Message -> Dict Ref (SelfCallback msg) -> Task x (Dict Ref (SelfCallback msg))
handleSelfcallback router endpoint message selfCallbacks =
    case message.ref of
        Nothing ->
            Task.succeed selfCallbacks

        Just ref ->
            case Dict.get ref selfCallbacks of
                Nothing ->
                    Task.succeed selfCallbacks

                Just selfCb ->
                    Platform.sendToSelf router (selfCb message)
                        &> Task.succeed (Dict.remove ref selfCallbacks)


processQueue : Endpoint -> List ( Message, Maybe (SelfCallback msg) ) -> State msg -> Task x (State msg)
processQueue endpoint messages state =
    case messages of
        [] ->
            Task.succeed state

        ( message, maybeSelfCb ) :: rest ->
            pushSocket endpoint message maybeSelfCb state
                <&> processQueue endpoint rest


handlePhoenixMessage : Platform.Router msg (Msg msg) -> Endpoint -> Message -> State msg -> Task x (State msg)
handlePhoenixMessage router endpoint message state =
    case message.event of
        "phx_error" ->
            case Helpers.getIn endpoint message.topic state.channels of
                Nothing ->
                    Task.succeed state

                Just channel ->
                    let
                        newChannel =
                            ChannelHelpers.updateState Channel.Errored channel

                        sendToApp =
                            case channel.onError of
                                Nothing ->
                                    Task.succeed ()

                                Just onError ->
                                    Platform.sendToApp router onError
                    in
                        sendToApp &> sendJoinHelper endpoint [ newChannel ] state

        -- TODO do we have to do something here?
        "phx_close" ->
            Task.succeed state

        _ ->
            Task.succeed state


dispatchMessage : Platform.Router msg (Msg msg) -> Endpoint -> Message -> ChannelsDict msg -> Task x ()
dispatchMessage router endpoint message channels =
    case getEventCb endpoint message channels of
        Nothing ->
            Task.succeed ()

        Just cb ->
            Platform.sendToApp router (cb message.payload)


getEventCb : Endpoint -> Message -> ChannelsDict msg -> Maybe (Callback msg)
getEventCb endpoint message channels =
    case Helpers.getIn endpoint message.topic channels of
        Nothing ->
            Nothing

        Just channel ->
            Dict.get message.event channel.on


handleChannelJoinReply : Platform.Router msg (Msg msg) -> Endpoint -> Topic -> Message -> Channel.State -> ChannelsDict msg -> Task x (ChannelsDict msg)
handleChannelJoinReply router endpoint topic message prevState channels =
    let
        maybeChannel =
            ChannelHelpers.get endpoint topic channels

        maybePayload =
            Helpers.decodeReplyPayload message.payload

        newChannels state =
            Task.succeed (ChannelHelpers.insertState endpoint topic state channels)

        handlePayload channel payload =
            case payload of
                Err response ->
                    case channel.onJoinError of
                        Nothing ->
                            newChannels Channel.Errored

                        Just onError ->
                            Platform.sendToApp router (onError response) &> newChannels Channel.Errored

                Ok response ->
                    let
                        join =
                            Platform.sendToSelf router (GoodJoin endpoint topic)
                                &> newChannels Channel.Joined
                    in
                        case prevState of
                            Channel.Disconnected ->
                                case channel.onRejoin of
                                    Nothing ->
                                        join

                                    Just onRejoin ->
                                        Platform.sendToApp router (onRejoin response) &> join

                            _ ->
                                case channel.onJoin of
                                    Nothing ->
                                        join

                                    Just onJoin ->
                                        Platform.sendToApp router (onJoin response) &> join
    in
        Maybe.map2 handlePayload maybeChannel maybePayload
            |> Maybe.withDefault (Task.succeed channels)


handleChannelDisconnect : Platform.Router msg (Msg msg) -> Endpoint -> State msg -> Task x (State msg)
handleChannelDisconnect router endpoint state =
    case Dict.get endpoint state.channels of
        Nothing ->
            Task.succeed state

        Just endpointChannels ->
            let
                notifyApp channel =
                    case channel.state of
                        Channel.Joined ->
                            case channel.onDisconnect of
                                Nothing ->
                                    Task.succeed ()

                                Just onDisconnect ->
                                    Platform.sendToApp router onDisconnect

                        _ ->
                            Task.succeed ()

                notify =
                    Dict.foldl (\_ channel task -> task &> notifyApp channel) (Task.succeed ()) endpointChannels

                updateChannel _ channel =
                    case channel.state of
                        Channel.Errored ->
                            channel

                        _ ->
                            ChannelHelpers.updateState Channel.Disconnected channel

                updatedEndpointChannels =
                    Dict.map updateChannel endpointChannels
            in
                notify
                    &> Task.succeed
                        ({ state
                            | channels = Dict.insert endpoint updatedEndpointChannels state.channels
                         }
                        )


heartbeat : Platform.Router msg (Msg msg) -> Endpoint -> State msg -> Task x (State msg)
heartbeat router endpoint state =
    case Dict.get endpoint state.sockets of
        Just socket ->
            if socket.withoutHeartbeat then
                Task.succeed state
            else
                (Process.spawn (Process.sleep socket.heartbeatIntervall &> (Platform.sendToSelf router (SendHeartbeat endpoint))))
                    &> pushSocket' endpoint heartbeatMessage Nothing state

        Nothing ->
            Task.succeed state


heartbeatMessage : Message
heartbeatMessage =
    Message.init "phoenix" "heartbeat"


rejoinAllChannels : Endpoint -> State msg -> Task x (State msg)
rejoinAllChannels endpoint state =
    case Dict.get endpoint state.channels of
        Nothing ->
            Task.succeed state

        Just endpointChannels ->
            sendJoinHelper endpoint (Dict.values endpointChannels) state


sendJoinHelper : Endpoint -> List (Channel msg) -> State msg -> Task x (State msg)
sendJoinHelper endpoint channels state =
    case channels of
        [] ->
            Task.succeed state

        channel :: rest ->
            let
                selfCb =
                    ChannelJoinReply endpoint channel.topic channel.state

                message =
                    ChannelHelpers.joinMessage channel

                newChannel =
                    ChannelHelpers.updateState Channel.Joining channel

                newChannels =
                    Helpers.insertIn endpoint channel.topic newChannel state.channels
            in
                pushSocket' endpoint message (Just selfCb) (updateChannels newChannels state)
                    <&> \newState -> sendJoinHelper endpoint rest newState



-- PUSH MESSAGES


{-| pushes a message to a certain socket. Ignores if the sending failes.
-}
pushSocket' : Endpoint -> Message -> Maybe (SelfCallback msg) -> State msg -> Task x (State msg)
pushSocket' endpoint message maybeSelfCb state =
    case Dict.get endpoint state.sockets of
        Nothing ->
            Task.succeed state

        Just socket ->
            SocketHelpers.push message socket
                <&> \maybeRef ->
                        case maybeRef of
                            Nothing ->
                                Task.succeed state

                            Just ref ->
                                insertSocket endpoint (SocketHelpers.increaseRef socket) state
                                    |> insertSelfCallback ref maybeSelfCb
                                    |> Task.succeed


{-| pushes a message to a certain socket. Queues the message if the channel is not joined.
-}
pushSocket : Endpoint -> Message -> Maybe (SelfCallback msg) -> State msg -> Task x (State msg)
pushSocket endpoint message selfCb state =
    let
        queuedState =
            Task.succeed
                { state
                    | channelQueues = Helpers.updateIn endpoint message.topic (Helpers.add ( message, selfCb )) state.channelQueues
                }

        afterSocketPush socket maybeRef =
            case maybeRef of
                Nothing ->
                    queuedState

                Just ref ->
                    insertSocket endpoint (SocketHelpers.increaseRef socket) state
                        |> insertSelfCallback ref selfCb
                        |> Task.succeed
    in
        case Dict.get endpoint state.sockets of
            Nothing ->
                queuedState

            Just socket ->
                case ChannelHelpers.get endpoint message.topic state.channels of
                    Nothing ->
                        queuedState

                    Just channel ->
                        case channel.state of
                            Channel.Joined ->
                                SocketHelpers.push message socket
                                    <&> afterSocketPush socket

                            _ ->
                                queuedState



-- OPENING WEBSOCKETS WITH EXPONENTIAL BACKOFF


attemptOpen : Platform.Router msg (Msg msg) -> Float -> Socket -> Task x Process.Id
attemptOpen router backoff socket =
    let
        goodOpen ws =
            Platform.sendToSelf router (GoodOpen socket.endpoint ws)

        badOpen details =
            Platform.sendToSelf router (BadOpen socket.endpoint details)

        actuallyAttemptOpen =
            (open socket router `Task.andThen` goodOpen)
                `Task.onError` badOpen
    in
        Process.spawn (after backoff &> actuallyAttemptOpen)


open : Socket -> Platform.Router msg (Msg msg) -> Task WS.BadOpen WS.WebSocket
open socket router =
    let
        onMessage _ msg =
            case Message.decode msg of
                Ok message ->
                    Platform.sendToSelf router (Receive socket.endpoint <| SocketHelpers.debugLogMessage socket message)

                -- TODO proper error handling
                Err err ->
                    Task.succeed ()
    in
        SocketHelpers.open socket
            { onMessage = onMessage
            , onClose = \details -> Platform.sendToSelf router (Die socket.endpoint details)
            }


after : Float -> Task x ()
after backoff =
    if backoff < 1 then
        Task.succeed ()
    else
        Process.sleep backoff
