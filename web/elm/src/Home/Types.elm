module Home.Types exposing (..)

import Http exposing (..)
import Home.Model exposing (..)


type Msg
    = FetchBoardsStart
    | FetchBoardsSuccess FetchBoardsModel
    | FetchBoardsError Http.Error
