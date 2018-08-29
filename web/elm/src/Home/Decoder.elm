module Home.Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Home.Model exposing (..)
import Boards.Decoder exposing (..)


fetchBoardsResponseDecoder : Decode.Decoder FetchBoardsModel
fetchBoardsResponseDecoder =
    succeed FetchBoardsModel
        |: ("owned_boards" := (list boardModelDecoder))
        |: ("invited_boards" := (list boardModelDecoder))
