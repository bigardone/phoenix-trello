module Registration.Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Registration.Model exposing (..)


type alias SignUpErrorResponse =
    { errors : SignUpError }


signUpErrorResponseDecoder : Decode.Decoder SignUpErrorResponse
signUpErrorResponseDecoder =
    succeed SignUpErrorResponse
        |: ("errors" := signUpErrorDecoder)


signUpErrorDecoder : Decode.Decoder SignUpError
signUpErrorDecoder =
    succeed SignUpError
        |: (maybe ("first_name" := string))
        |: (maybe ("last_name" := string))
        |: (maybe ("email" := string))
        |: (maybe ("password" := string))
        |: (maybe ("password_confirmation" := string))
