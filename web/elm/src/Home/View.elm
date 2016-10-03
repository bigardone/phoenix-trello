module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Home.Model as HomeModel exposing (..)
import Session.Model as SessionModel exposing (..)
import Boards.Model as BoardsModel exposing (..)
import Home.Types exposing (..)


view : SessionModel.Model -> HomeModel.Model -> Html Msg
view sessionModel model =
    case sessionModel.user of
        Nothing ->
            text ""

        _ ->
            div
                [ class "view-container boards index" ]
                [ ownedBoardsView model
                , invitedBoardsView model
                ]


ownedBoardsView : HomeModel.Model -> Html Msg
ownedBoardsView model =
    let
        fetching =
            model.fetching

        iconClasses =
            classList
                [ ( "fa", True )
                , ( "fa-user", (fetching == False) )
                , ( "fa-spinner", fetching )
                , ( "fa-spin", fetching )
                ]

        boards =
            case fetching of
                True ->
                    []

                False ->
                    [ boardForm model ]
                        |> List.append (List.map boardCardView model.owned_boards)
    in
        section
            []
            [ header
                [ class "view-header" ]
                [ h3
                    []
                    [ i
                        [ iconClasses ]
                        []
                    , text " My boards"
                    ]
                ]
            , div
                [ class "boards-wrapper" ]
                boards
            ]


boardCardView : BoardModel -> Html Msg
boardCardView board =
    div
        [ id board.id
        , class "board"
        ]
        [ div
            [ class "inner" ]
            [ h4
                []
                [ text board.name ]
            ]
        ]


boardForm : HomeModel.Model -> Html Msg
boardForm model =
    case model.showBoardForm of
        False ->
            div
                [ class "board add-new"
                , onClick (ToggleBoardForm True)
                ]
                [ div
                    [ class "inner" ]
                    [ a
                        [ id "add_new_board" ]
                        [ text "Add new board..." ]
                    ]
                ]

        True ->
            div
                [ class "board form" ]
                [ div
                    [ class "inner" ]
                    [ h4
                        []
                        [ text "New board" ]
                    , Html.form
                        [ id "new_board_form"
                        , onSubmit CreateBoardStart
                        ]
                        [ input
                            [ id "board_name"
                            , type' "text"
                            , placeholder "Board name"
                            , required True
                            , value model.form.name
                            , autofocus True
                            , onInput FormNameInput
                            ]
                            []
                        , formErrorsView model
                        , button
                            [ type' "submit" ]
                            [ text "Create board" ]
                        , text " or "
                        , a
                            [ onClick (ToggleBoardForm False) ]
                            [ text "cancel" ]
                        ]
                    ]
                ]


formErrorsView : HomeModel.Model -> Html Msg
formErrorsView model =
    text ""


invitedBoardsView : HomeModel.Model -> Html Msg
invitedBoardsView model =
    case List.length model.invited_boards > 0 of
        True ->
            let
                fetching =
                    model.fetching

                boards =
                    case fetching of
                        True ->
                            []

                        False ->
                            model.invited_boards
                                |> List.map boardCardView
            in
                section
                    []
                    [ header
                        [ class "view-header" ]
                        [ h3
                            []
                            [ i
                                [ class "fa fa-users" ]
                                []
                            , text " Other boards"
                            ]
                        ]
                    , div
                        [ class "boards-wrapper" ]
                        boards
                    ]

        False ->
            text ""
