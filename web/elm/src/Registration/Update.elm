module Registration.Update exposing (..)

import Navigation
import Http exposing (Error)
import Task exposing (..)
import Registration.Types as RegistrationTypes
import Session.Types as SessionTypes
import Types exposing (..)
import Registration.Model exposing (..)
import Routing exposing (toPath, Route(..))
import Registration.API exposing (..)


update : RegistrationTypes.Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RegistrationTypes.NavigateToSession ->
            model ! [ Navigation.newUrl (toPath SessionNewRoute) ]

        RegistrationTypes.HandleFirstNameInput value ->
            let
                form =
                    model.form
            in
                { model | form = { form | firstName = value } } ! []

        RegistrationTypes.HandlePLastNameInput value ->
            let
                form =
                    model.form
            in
                { model | form = { form | lastName = value } } ! []

        RegistrationTypes.HandleEmailInput value ->
            let
                form =
                    model.form
            in
                { model | form = { form | email = value } } ! []

        RegistrationTypes.HandlePasswordInput value ->
            let
                form =
                    model.form
            in
                { model | form = { form | password = value } } ! []

        RegistrationTypes.HandlePasswordConfirmationInput value ->
            let
                form =
                    model.form
            in
                { model | form = { form | passwordConfirmation = value } } ! []

        RegistrationTypes.SignUp ->
            model ! [ Task.perform (\payload -> RegistrationMsg <| (RegistrationTypes.SignUpError payload)) (\payload -> SessionMsg <| (SessionTypes.SignInSuccess payload)) <| signUpUser model ]

        RegistrationTypes.SignUpError err ->
            case err of
                Http.BadResponse code raw ->
                    { model | error = Just raw } ! []

                _ ->
                    let
                        _ =
                            Debug.log "SignUpError" err
                    in
                        model ! []
