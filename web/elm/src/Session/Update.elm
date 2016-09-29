module Session.Update exposing (..)

import Navigation
import Session.Types exposing (Msg(..))
import Session.Model exposing (..)
import Routing exposing (toPath, Route(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateToRegistration ->
            model ! [ Navigation.newUrl (toPath RegistrationNewRoute) ]

        HandleEmailInput email ->
            let
                form =
                    model.form
            in
                { model | form = { form | email = email } } ! []

        HandlePasswordInput password ->
            let
                form =
                    model.form
            in
                { model | form = { form | password = password } } ! []
