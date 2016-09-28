module Model exposing (..)

import Routing exposing (..)


type alias Model =
    { route : Route }


initialModel : Routing.Route -> Model
initialModel route =
    { route = route }
