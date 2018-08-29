module Lists.Decoder exposing (..)

import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Lists.Model as ListsModel
import Cards.Decoder exposing (..)


type alias ListReponse =
    { list : ListsModel.Model }


listModelDecoder : JD.Decoder ListsModel.Model
listModelDecoder =
    succeed ListsModel.Model
        |: ("id" := int)
        |: ("board_id" := int)
        |: ("name" := string)
        |: ("position" := int)
        |: ("cards" := (list cardModelDecoder))


listResponseDecoder : JD.Decoder ListReponse
listResponseDecoder =
    succeed ListReponse
        |: ("list" := listModelDecoder)
