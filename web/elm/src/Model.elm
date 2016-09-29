module Model exposing (..)

import Routing exposing (..)
import Session.Model
import Registration.Model
import Home.Model


type alias Model =
    { route : Route
    , home : Home.Model.Model
    , session : Session.Model.Model
    , registration : Registration.Model.Model
    }


initialModel : Routing.Route -> Model
initialModel route =
    { route = route
    , home = Home.Model.initialModel
    , session = Session.Model.initialModel
    , registration = Registration.Model.initialModel
    }
