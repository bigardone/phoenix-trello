module Registration.API exposing (..)

import Http exposing (..)
import Task exposing (..)
import Json.Encode as JE
import Registration.Model exposing (..)
import Session.Model as SessionModel
import Session.Decoder exposing (..)


signUpUser : Model -> Task Error SessionModel.AuthResponseModel
signUpUser model =
    { verb = "POST"
    , headers = [ ( "Content-Type", "application/json" ) ]
    , url = "/api/v1/registrations"
    , body = Http.string <| JE.encode 0 <| userEncoder model.form
    }
        |> Http.send Http.defaultSettings
        |> Http.fromJson authResponseDecoder


userEncoder : FormModel -> JE.Value
userEncoder form =
    JE.object
        [ ( "user"
          , JE.object
                [ ( "first_name", JE.string form.firstName )
                , ( "last_name", JE.string form.lastName )
                , ( "email", JE.string form.email )
                , ( "password", JE.string form.password )
                , ( "password_confirmation", JE.string form.passwordConfirmation )
                ]
          )
        ]
