module Model exposing (..)

import Routing exposing (..)
import Session.Model
import Registration.Model
import Home.Model
import Boards.Model
import Types exposing (..)


type alias Model =
    { route : Route
    , home : Home.Model.Model
    , currentBoard : Boards.Model.Model
    , session : Session.Model.Model
    , registration : Registration.Model.Model
    , showBoardsList : Bool
    }


type alias ErrorModel =
    { error : String }


initialModel : Flags -> Routing.Route -> Model
initialModel flags route =
    { route = route
    , home = Home.Model.initialModel
    , currentBoard = Boards.Model.initialModel
    , session = Session.Model.initialModel flags.jwt
    , registration = Registration.Model.initialModel
    , showBoardsList = False
    }
