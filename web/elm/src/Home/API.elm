module Home.API exposing (..)

import Http exposing (..)
import Task exposing (..)
import Json.Encode as JE
import Home.Model exposing (..)
import Boards.Model exposing (..)
import Home.Decoder exposing (..)
import Boards.Decoder exposing (..)


fetchBoards : String -> Task Error FetchBoardsModel
fetchBoards jwt =
    { verb = "GET"
    , headers =
        [ ( "Content-Type", "application/json" )
        , ( "Authorization", jwt )
        ]
    , url = "/api/v1/boards"
    , body = Http.empty
    }
        |> Http.send Http.defaultSettings
        |> Http.fromJson fetchBoardsResponseDecoder


createBoard : String -> BoardFormModel -> Task Error BoardModel
createBoard jwt model =
    { verb = "POST"
    , headers =
        [ ( "Content-Type", "application/json" )
        , ( "Authorization", jwt )
        ]
    , url = "/api/v1/boards"
    , body = Http.string <| JE.encode 0 <| boardEncoder model
    }
        |> Http.send Http.defaultSettings
        |> Http.fromJson boardModelDecoder


boardEncoder : BoardFormModel -> JE.Value
boardEncoder form =
    JE.object
        [ ( "board"
          , JE.object
                [ ( "name", JE.string form.name )
                ]
          )
        ]
