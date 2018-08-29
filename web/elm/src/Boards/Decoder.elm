module Boards.Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Model exposing (ErrorModel)
import Boards.Model exposing (..)
import Session.Decoder exposing (..)
import Lists.Decoder exposing (..)


boardModelDecoder : Decode.Decoder BoardModel
boardModelDecoder =
    succeed BoardModel
        |: ("id" := string)
        |: (maybe ("user_id" := int))
        |: ("name" := string)
        |: (maybe ("user" := userDecoder))
        |: (maybe ("lists" := (list listModelDecoder)))
        |: (maybe ("members" := (list userDecoder)))


boardResponseDecoder : Decode.Decoder BoardResponseModel
boardResponseDecoder =
    succeed BoardResponseModel
        |: ("board" := boardModelDecoder)


connectedUsersResponseDecoder : Decode.Decoder ConnectedUsersListResponseModel
connectedUsersResponseDecoder =
    succeed ConnectedUsersListResponseModel
        |: ("users" := list int)


errorResponseDecoder : Decode.Decoder ErrorModel
errorResponseDecoder =
    succeed ErrorModel
        |: ("error" := string)
