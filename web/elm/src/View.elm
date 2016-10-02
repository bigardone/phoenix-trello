module View exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Types exposing (..)
import Home.Types exposing (..)
import Session.Types exposing (..)
import Routing exposing (..)
import Session.View as SessionView
import Registration.View as RegistrationView
import Home.View as HomeView


view : Model -> Html Types.Msg
view model =
    case model.session.user of
        Nothing ->
            div
                []
                [ page model
                , hr [] []
                , text (toString model)
                ]

        Just user ->
            div
                [ id "authentication_container"
                , class "application-container"
                ]
                [ headerView model
                , div
                    [ class "main-container" ]
                    [ page model ]
                ]


headerView : Model -> Html Types.Msg
headerView model =
    header
        [ class "main-header" ]
        [ nav
            [ id "boards_nav" ]
            [ ul
                []
                [ li
                    []
                    [ a
                        []
                        [ i
                            [ class "fa fa-columns" ]
                            []
                        , text " Boards"
                        ]
                    ]
                ]
            ]
        , a
            []
            [ span
                [ class "logo"
                , onClick (HomeMsg <| NavigateToHome)
                ]
                []
            ]
        , nav
            [ class "right" ]
            [ ul
                []
                [ li
                    []
                    [ currentUserView model ]
                , li
                    []
                    [ signOutView model ]
                ]
            ]
        ]


currentUserView : Model -> Html Types.Msg
currentUserView model =
    case model.session.user of
        Just user ->
            let
                fullName =
                    user.first_name ++ " " ++ user.last_name

                gravatarUrl =
                    "http://www.gravatar.com/avatar/" ++ user.email ++ "?s=200"
            in
                a
                    [ class "current-user" ]
                    [ img
                        [ class "react-gravatar"
                        , src gravatarUrl
                        ]
                        []
                    , text fullName
                    ]

        Nothing ->
            text ""


signOutView : Model -> Html Types.Msg
signOutView model =
    case model.session.user of
        Just user ->
            a
                [ onClick (SessionMsg <| SignOut) ]
                [ i
                    [ class "fa fa-sign-out" ]
                    []
                , text " Sign out"
                ]

        Nothing ->
            text ""


page : Model -> Html Types.Msg
page model =
    case model.route of
        HomeIndexRoute ->
            Html.App.map HomeMsg (HomeView.view model.session model.home)

        SessionNewRoute ->
            Html.App.map SessionMsg (SessionView.view model.session)

        RegistrationNewRoute ->
            Html.App.map RegistrationMsg (RegistrationView.view model.registration)

        _ ->
            notFoundView


notFoundView : Html Types.Msg
notFoundView =
    div
        [ id "error_index" ]
        [ div
            [ class "warning" ]
            [ span
                [ class "fa-stack" ]
                [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
            , h4 [] [ text "404" ]
            ]
        ]
