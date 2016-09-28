module Registration.Update exposing (..)

import Navigation
import Registration.Types exposing (Msg(..))
import Registration.Model exposing (..)
import Routing exposing (toPath, Route(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateToSession ->
            model ! [ Navigation.newUrl (toPath SessionRoute) ]
