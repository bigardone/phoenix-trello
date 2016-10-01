module Home.API exposing (..)

import Http exposing (..)
import Task exposing (..)
import Home.Model exposing (..)
import Home.Decoder exposing (..)


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
