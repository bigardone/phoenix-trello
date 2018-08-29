module Session.Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Session.Model exposing (..)


userDecoder : Decode.Decoder User
userDecoder =
    succeed User
        |: ("id" := int)
        |: ("first_name" := string)
        |: ("last_name" := string)
        |: ("email" := string)


formModelDecoder : Decode.Decoder FormModel
formModelDecoder =
    succeed FormModel
        |: ("email" := string)
        |: ("password" := string)


authResponseDecoder : Decode.Decoder AuthResponseModel
authResponseDecoder =
    succeed AuthResponseModel
        |: ("jwt" := string)
        |: ("user" := userDecoder)


signOutResponseDecoder : Decode.Decoder SignOutResponseModel
signOutResponseDecoder =
    succeed SignOutResponseModel
        |: ("ok" := bool)


userResponseDecoder : Decode.Decoder UserResponseModel
userResponseDecoder =
    succeed UserResponseModel
        |: ("user" := userDecoder)
