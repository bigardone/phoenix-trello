module Home.Types exposing (..)

import Http exposing (..)
import Home.Model exposing (..)


type Msg
    = NavigateToHome
    | FetchBoardsStart
    | FetchBoardsSuccess FetchBoardsModel
    | FetchBoardsError Http.Error
    | ToggleBoardForm Bool
