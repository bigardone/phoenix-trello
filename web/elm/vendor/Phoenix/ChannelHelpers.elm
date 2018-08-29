module Phoenix.ChannelHelpers exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Value, (:=))
import Phoenix.Helpers as Helpers
import Phoenix.Channel exposing (..)
import Phoenix.Message as Message exposing (Message)


type alias Endpoint =
    String


type alias Topic =
    String


type alias Event =
    String


map : (a -> b) -> Channel a -> Channel b
map func chan =
    let
        f =
            Maybe.map ((<<) func)
    in
        { chan
            | onJoin = f chan.onJoin
            , onJoinError = f chan.onJoinError
            , onError = Maybe.map func chan.onError
            , onDisconnect = Maybe.map func chan.onDisconnect
            , onRejoin = f chan.onRejoin
            , onLeave = f chan.onLeave
            , onLeaveError = f chan.onLeaveError
            , on = Dict.map (\_ a -> func << a) chan.on
        }


joinMessage : Channel msg -> Message
joinMessage { topic, payload } =
    let
        base =
            Message.init topic "phx_join"
    in
        case payload of
            Nothing ->
                base

            Just payload' ->
                Message.payload payload' base


leaveMessage : Channel msg -> Message
leaveMessage { topic } =
    Message.init topic "phx_leave"



-- GETTER, SETTER, UPDATER


type alias ChannelsDict msg =
    Dict Endpoint (Dict Topic (Channel msg))


get : Endpoint -> Topic -> ChannelsDict msg -> Maybe (Channel msg)
get endpoint topic channelsDict =
    Helpers.getIn endpoint topic channelsDict


getState : Endpoint -> Topic -> ChannelsDict msg -> Maybe State
getState endpoint topic channelsDict =
    get endpoint topic channelsDict
        |> Maybe.map (\{ state } -> state)


{-|  Inserts the state, identity if channel for given endpoint topic doesn't exist
-}
insertState : Endpoint -> Topic -> State -> ChannelsDict msg -> ChannelsDict msg
insertState endpoint topic state dict =
    let
        update =
            Maybe.map (updateState state)
    in
        Helpers.updateIn endpoint topic update dict


updateState : State -> Channel msg -> Channel msg
updateState state channel =
    if channel.debug then
        let
            _ =
                Debug.log ("Channel \"" ++ channel.topic ++ "\"") state
        in
            { channel | state = state }
    else
        { channel | state = state }


updatePayload : Maybe Value -> Channel msg -> Channel msg
updatePayload payload channel =
    { channel | payload = payload }


updateOn : Dict Topic (Value -> msg) -> Channel msg -> Channel msg
updateOn on channel =
    { channel | on = on }
