module Phoenix.Socket exposing (Socket, Connection(..), init, heartbeatIntervallSeconds, withoutHeartbeat, reconnectTimer, withParams, withDebug)

{-| A socket declares to which endpoint a socket connection should be established.

# Definition
@docs Socket, Connection

# Helpers
@docs init, withParams, heartbeatIntervallSeconds, withoutHeartbeat, reconnectTimer, withDebug
-}

import Process
import Time exposing (Time)
import WebSocket.LowLevel as WS


{-| Representation of a Socket connection

**Note**: You should use the helper functions to construct a socket.
-}
type alias Socket =
    { endpoint : String
    , params : List ( String, String )
    , heartbeatIntervall : Time
    , withoutHeartbeat : Bool
    , connection : Connection
    , reconnectTimer : Int -> Float
    , debug : Bool
    }


{-| The underlying low-level socket connection. This is completely handled by the effect manager.
-}
type Connection
    = Closed
    | Opening Int Process.Id
    | Connected WS.WebSocket Int


{-| Initialize a Socket connection with an endpoint.

    init "ws://localhost:4000/socket/websocket"
-}
init : String -> Socket
init endpoint =
    { endpoint = endpoint
    , params = []
    , heartbeatIntervall = 30 * Time.second
    , withoutHeartbeat = False
    , connection = Closed
    , reconnectTimer = defaultReconnectTimer
    , debug = False
    }


{-| Attach parameters to the socket connecton. You can use this to do authentication on the socket level. This will be the first argument (as a map) in your `connect/2` callback on the server.

    init "ws://localhost:4000/socket/websocket"
        |> withParams [("token", "GYMXZwXzKFzfxyGntVkYt7uAJnscVnFJ")]
-}
withParams : List ( String, String ) -> Socket -> Socket
withParams params socket =
    { socket | params = params }


{-| The client regularly sends a heartbeat to the server. With this function you can specify the intervall in which the heartbeats are send. By default it's 30 seconds.

    init "ws://localhost:4000/socket/websocket"
        |> heartbeatIntervallSeconds 60
-}
heartbeatIntervallSeconds : Int -> Socket -> Socket
heartbeatIntervallSeconds intervall socket =
    { socket | heartbeatIntervall = (toFloat intervall) * Time.second }


{-| The client regularly sends a heartbeat to the sever. With this function you can disable the heartbeat.

    init "ws://localhost:4000/socket/websocket"
        |> withoutHeartbeat
-}
withoutHeartbeat : Socket -> Socket
withoutHeartbeat socket =
    { socket | withoutHeartbeat = True }


{-| The effect manager will try to establish a socket connection. If it fails it will try again with a specified backoff. By default the effect manager will use the following exponential backoff strategy:

    defaultReconnectTimer failedAttempts =
        if backoff < 1 then
            0
        else
            toFloat (10 * 2 ^ failedAttempts)

With this function you can specify a custom strategy.
-}
reconnectTimer : (Int -> Time) -> Socket -> Socket
reconnectTimer timerFunc socket =
    { socket | reconnectTimer = timerFunc }


{-| Enable debug logs for the socket. Every incoming and outgoing message will be printed.
-}
withDebug : Socket -> Socket
withDebug socket =
    { socket | debug = True }


defaultReconnectTimer : Int -> Time
defaultReconnectTimer failedAttempts =
    if failedAttempts < 1 then
        0
    else
        toFloat (10 * 2 ^ failedAttempts)
