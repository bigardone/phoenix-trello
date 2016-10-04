module Home.Types exposing (..)

import Http exposing (..)
import Home.Model exposing (..)
import Boards.Model exposing (..)


type Msg
    = NavigateToHome
    | NavigateToBoardShow String
    | FetchBoardsStart
    | FetchBoardsSuccess FetchBoardsModel
    | FetchBoardsError Http.Error
    | ToggleBoardForm Bool
    | FormNameInput String
    | CreateBoardStart
    | CreateBoardSuccess BoardModel
    | CreateBoardError Http.Error
