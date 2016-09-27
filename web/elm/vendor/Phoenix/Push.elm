module Phoenix.Push exposing (Push, init, withPayload, onOk, onError, map)

{-| A message to push informations to a channel.

# Definition
@docs Push

# Helpers
@docs init, withPayload, onOk, onError, map
-}

import Json.Encode exposing (Value)


{-| The message abstraction

**Note**: You should use the helper functions to construct a Push message.
-}
type alias Push msg =
    { topic : String
    , event : String
    , payload : Value
    , onOk : Maybe (Value -> msg)
    , onError : Maybe (Value -> msg)
    }


type alias Topic =
    String


type alias Event =
    String


{-| Initialize a message with a topic and an event.

    init "room:lobby" "new_msg"
-}
init : Topic -> Event -> Push msg
init topic event =
    Push topic event (Json.Encode.object []) Nothing Nothing


{-| Attach a payload to a message

    payload =
        Json.Encode.object [("msg", "Hello Phoenix")]

    init "room:lobby" "new_msg"
        |> withPayload
-}
withPayload : Value -> Push msg -> Push msg
withPayload payload push =
    { push | payload = payload }


{-| Callback if the server replies with an "ok" status.

    type Msg = MessageArrived | ...

    payload =
        Json.Encode.object [("msg", "Hello Phoenix")]

    init "room:lobby" "new_msg"
        |> withPayload
        |> onOk (\_ -> MessageArrived)
-}
onOk : (Value -> msg) -> Push msg -> Push msg
onOk cb push =
    { push | onOk = Just cb }


{-| Callback if the server replies with an "error" status.

    type Msg = MessageFailed Value | ...

    payload =
        Json.Encode.object [("msg", "Hello Phoenix")]

    init "room:lobby" "new_msg"
        |> withPayload
        |> onError MessageFailed
-}
onError : (Value -> msg) -> Push msg -> Push msg
onError cb push =
    { push | onError = Just cb }


{-| Applies the function on the onOk and onError callback
-}
map : (a -> b) -> Push a -> Push b
map func push =
    let
        f =
            Maybe.map ((<<) func)
    in
        { push | onOk = f push.onOk, onError = f push.onError }
