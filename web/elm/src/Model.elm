module Model exposing (..)

import Routing exposing (..)
import Session.Model exposing (..)
import Registration.Model exposing (..)


type alias Model =
    { route : Route
    , session : Session.Model.Model
    , registration : Registration.Model.Model
    }


initialModel : Routing.Route -> Model
initialModel route =
    { route = route
    , session = Session.Model.initialModel
    , registration = Registration.Model.initialModel
    }
