module Model exposing (..)

import Routing exposing (..)
import Session.Model
import Registration.Model
import Home.Model
import Types exposing (..)


type alias Model =
    { route : Route
    , home : Home.Model.Model
    , session : Session.Model.Model
    , registration : Registration.Model.Model
    }


initialModel : Flags -> Routing.Route -> Model
initialModel flags route =
    { route = route
    , home = Home.Model.initialModel
    , session = Session.Model.initialModel flags.jwt
    , registration = Registration.Model.initialModel
    }
