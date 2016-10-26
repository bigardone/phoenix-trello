module Session.Update exposing (..)

import Navigation
import Task exposing (..)
import Session.Types exposing (Msg(..))
import Session.Model exposing (..)
import Routing exposing (toPath, Route(..))
import Session.API exposing (..)
import Ports exposing (..)


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

        SignIn ->
            model ! [ Task.perform SignInError SignInSuccess <| authUser model ]

        SignInSuccess res ->
            let
                cmds =
                    [ saveToken res.jwt
                    , Navigation.newUrl (toPath HomeIndexRoute)
                    ]
            in
                { model
                    | jwt = Just res.jwt
                    , user = Just res.user
                    , form = FormModel "" ""
                    , error = Nothing
                    , state = JoiningLobby
                }
                    ! cmds

        SignInError error ->
            { model | error = (Just (toString error)) } ! []

        CurrentUserSuccess res ->
            { model
                | user = Just res
                , error = Nothing
                , state = JoiningLobby
            }
                ! []

        CurrentUserError error ->
            let
                cmds =
                    [ deleteToken ()
                    , (Navigation.newUrl (toPath SessionNewRoute))
                    ]
            in
                { model | error = (Just (toString error)) } ! cmds

        SignOut ->
            model ! [ Task.perform SignOutError SignOutSuccess <| signOut (Maybe.withDefault "" model.jwt) ]

        SignOutSuccess res ->
            let
                cmds =
                    [ deleteToken ()
                    , Navigation.newUrl (toPath SessionNewRoute)
                    ]
            in
                { model
                    | jwt = Nothing
                    , state = LeftLobby
                    , user = Nothing
                    , form = initialForm
                }
                    ! cmds

        SignOutError error ->
            model ! []
