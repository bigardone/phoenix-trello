module Phoenix.Message exposing (..)

import Phoenix.Push as Push exposing (Push)
import Json.Encode as JE
import Json.Decode as JD exposing (Value, (:=))


type alias Message =
    { topic : String
    , event : String
    , payload : Value
    , ref : Maybe Int
    }


type alias Topic =
    String


type alias Event =
    String


type alias Ref =
    Int


init : Topic -> Event -> Message
init topic event =
    Message topic event (JE.object []) Nothing


payload : Value -> Message -> Message
payload payload' message =
    { message | payload = payload' }


ref : Ref -> Message -> Message
ref ref' message =
    { message | ref = Just ref' }


fromPush : Push msg -> Message
fromPush push =
    init push.topic push.event
        |> payload push.payload


encode : Message -> String
encode { topic, event, payload, ref } =
    JE.object
        [ ( "topic", JE.string topic )
        , ( "event", JE.string event )
        , ( "ref", Maybe.map (JE.int) ref |> (Maybe.withDefault JE.null) )
        , ( "payload", payload )
        ]
        |> JE.encode 0


decode : String -> Result String Message
decode msg =
    let
        decoder =
            JD.object4 Message
                ("topic" := JD.string)
                ("event" := JD.string)
                ("payload" := JD.value)
                ("ref" := JD.oneOf [ JD.map Just JD.int, JD.null Nothing ])
    in
        JD.decodeString decoder msg
