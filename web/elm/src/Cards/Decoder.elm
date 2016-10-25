module Cards.Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Cards.Model as CardsModel
import Session.Decoder exposing (..)


cardModelDecoder : Decode.Decoder CardsModel.Model
cardModelDecoder =
    succeed CardsModel.Model
        |: ("id" := int)
        |: ("list_id" := int)
        |: ("name" := string)
        |: (maybe ("description" := string))
        |: ("position" := int)
        |: ("tags" := (list string))
        |: ("comments" := (list commentModelDecoder))
        |: ("members" := (list userDecoder))


commentModelDecoder : Decode.Decoder CardsModel.CommentModel
commentModelDecoder =
    succeed CardsModel.CommentModel
        |: ("id" := int)
        |: ("card_id" := int)
        |: ("user" := userDecoder)
        |: ("text" := string)
        |: ("inserted_at" := string)
