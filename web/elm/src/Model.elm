module Model exposing (..)

import Routing exposing (..)
import Session.Model
import Registration.Model
import Home.Model as HomeModel
import Boards.Model as BoardsModel
import Types exposing (..)


type alias Model =
    { route : Route
    , state : State
    , home : HomeModel.Model
    , currentBoard : BoardsModel.Model
    , session : Session.Model.Model
    , registration : Registration.Model.Model
    , showBoardsList : Bool
    }


type State
    = JoiningLobby
    | JoinedLobby
    | LeavingLobby
    | LeftLobby
    | JoiningBoard
    | JoinedBoard
    | LeavingBoard
    | LeftBoard


initialModel : Flags -> Routing.Route -> Model
initialModel flags route =
    { route = route
    , state = LeftLobby
    , home = HomeModel.initialModel
    , currentBoard = BoardsModel.initialModel
    , session = Session.Model.initialModel flags.jwt
    , registration = Registration.Model.initialModel
    , showBoardsList = False
    }
