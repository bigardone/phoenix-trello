module Session.Update exposing (..)

import Navigation
import Session.Types exposing (Msg(..))
import Session.Model exposing (..)
import Routing exposing (toPath, Route(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateToRegistration ->
            model ! [ Navigation.newUrl (toPath RegistrationRoute) ]
