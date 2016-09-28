module Model exposing (..)

import Routing exposing (..)
import Session.Model exposing (..)


type alias Model =
    { route : Route
    , session : Session.Model.Model
    }


initialModel : Routing.Route -> Model
initialModel route =
    { route = route
    , session = Session.Model.initialModel
    }
