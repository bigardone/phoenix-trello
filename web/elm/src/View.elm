module View exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Types exposing (..)
import Home.Types as HomeTypes
import Session.Types as SessionTypes
import Routing exposing (..)
import Session.View as SessionView
import Registration.View as RegistrationView
import Home.View as HomeView
import Boards.View as BoardsView
import Boards.Model as BoardsModel


view : Model -> Html Types.Msg
view model =
    case model.session.user of
        Nothing ->
            div
                []
                [ page model ]

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
        [ class "main-header"
        , onMouseLeave (ToggleBoardsList False)
        ]
        [ nav
            [ id "boards_nav" ]
            [ ul
                []
                [ li
                    []
                    [ a
                        [ onClick (ToggleBoardsList True) ]
                        [ i
                            [ class "fa fa-columns" ]
                            []
                        , text " Boards"
                        ]
                    , boardsView model
                    ]
                ]
            ]
        , a
            []
            [ span
                [ class "logo"
                , onClick (HomeMsg <| HomeTypes.NavigateToHome)
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


boardsView : Model -> Html Types.Msg
boardsView model =
    case model.showBoardsList of
        True ->
            let
                ownedBoardsHeader =
                    if List.length model.home.owned_boards > 0 then
                        header
                            [ class "title" ]
                            [ i
                                [ class "fa fa-user" ]
                                []
                            , text " Owned boards"
                            ]
                    else
                        text ""

                invitedBoardsHeader =
                    if List.length model.home.invited_boards > 0 then
                        header
                            [ class "title" ]
                            [ i
                                [ class "fa fa-users" ]
                                []
                            , text " Invited boards"
                            ]
                    else
                        text ""
            in
                div
                    [ class "dropdown"
                    , onMouseLeave (ToggleBoardsList False)
                    ]
                    [ ownedBoardsHeader
                    , model.home.owned_boards
                        |> List.map boardView
                        |> ul []
                    , invitedBoardsHeader
                    , model.home.invited_boards
                        |> List.map boardView
                        |> ul []
                    , ul
                        [ class "options" ]
                        [ li
                            []
                            [ a
                                [ onClick (HomeMsg <| HomeTypes.NavigateToHome) ]
                                [ text "View all boards" ]
                            ]
                        ]
                    ]

        False ->
            text ""


boardView : BoardsModel.BoardModel -> Html Msg
boardView board =
    li
        []
        [ a
            [ onClick (HomeMsg <| HomeTypes.NavigateToBoardShow board.id) ]
            [ text board.name ]
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
                [ onClick (SessionMsg <| SessionTypes.SignOut) ]
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

        BoardShowRoute slug ->
            Html.App.map BoardsMsg (BoardsView.view model.session model.currentBoard)

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
