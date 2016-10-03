module Boards.Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Boards.Model exposing (..)
import Session.Decoder exposing (..)


boardModelDecoder : Decode.Decoder BoardModel
boardModelDecoder =
    succeed BoardModel
        |: ("id" := string)
        |: (maybe ("user_id" := int))
        |: ("name" := string)
        |: (maybe ("user" := userDecoder))
        |: (maybe ("lists" := (list listModelDecoder)))
        |: (maybe ("members" := (list userDecoder)))


listModelDecoder : Decode.Decoder ListModel
listModelDecoder =
    succeed ListModel
        |: ("id" := int)
        |: ("board_id" := int)
        |: ("name" := string)
        |: ("position" := int)
        |: ("cards" := (list cardModelDecoder))


cardModelDecoder : Decode.Decoder CardModel
cardModelDecoder =
    succeed CardModel
        |: ("id" := int)
        |: ("list_id" := int)
        |: ("name" := string)
        |: (maybe ("description" := string))
        |: ("position" := int)
        |: ("tags" := (list string))
        |: ("comments" := (list commentModelDecoder))
        |: ("members" := (list userDecoder))


commentModelDecoder : Decode.Decoder CommentModel
commentModelDecoder =
    succeed CommentModel
        |: ("id" := int)
        |: ("card_id" := int)
        |: ("user" := userDecoder)
        |: ("text" := string)
        |: ("inserted_at" := string)
