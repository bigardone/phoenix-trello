module Session.Update exposing (..)

import Navigation
import Task exposing (..)
import Session.Types exposing (Msg(..))
import Session.Model exposing (..)
import Routing exposing (toPath, Route(..))
import Session.API exposing (..)


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

        HandleFormSubmit ->
            model ! [ Task.perform SignInError SignInSuccess <| authUser model ]

        SignInSuccess res ->
            { model
                | jwt = Just res.jwt
                , user = Just res.user
            }
                ! [ Navigation.newUrl (toPath HomeIndexRoute) ]

        SignInError error ->
            { model | error = (Just (toString error)) } ! []
