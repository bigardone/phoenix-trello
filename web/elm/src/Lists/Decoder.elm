module Lists.Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Lists.Model as ListsModel
import Cards.Decoder exposing (..)


listModelDecoder : Decode.Decoder ListsModel.Model
listModelDecoder =
    succeed ListsModel.Model
        |: ("id" := int)
        |: ("board_id" := int)
        |: ("name" := string)
        |: ("position" := int)
        |: ("cards" := (list cardModelDecoder))
