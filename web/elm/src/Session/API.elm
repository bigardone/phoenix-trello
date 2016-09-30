module Session.API exposing (..)

import Http exposing (..)
import Task exposing (..)
import Json.Encode as JE
import Session.Model exposing (..)
import Session.Decoder exposing (..)


authUser : Model -> Task Error AuthResponseModel
authUser model =
    { verb = "POST"
    , headers = [ ( "Content-Type", "application/json" ) ]
    , url = "/api/v1/sessions"
    , body = Http.string <| JE.encode 0 <| userEncoder model.form
    }
        |> Http.send Http.defaultSettings
        |> Http.fromJson authResponseDecoder


userEncoder : FormModel -> JE.Value
userEncoder form =
    JE.object
        [ ( "session"
          , JE.object
                [ ( "email", JE.string form.email )
                , ( "password", JE.string form.password )
                ]
          )
        ]
