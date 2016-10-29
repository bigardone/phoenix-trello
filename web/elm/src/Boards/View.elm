module Boards.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Session.Model as SessionModel exposing (..)
import Boards.Model as BoardsModel exposing (..)
import Boards.Types exposing (..)
import Lists.View exposing (..)


view : SessionModel.Model -> BoardsModel.Model -> Html Msg
view sessionModel model =
    case sessionModel.user of
        Nothing ->
            text ""

        _ ->
            div
                [ class "view-container boards show" ]
                (contentView sessionModel model)


contentView : SessionModel.Model -> BoardsModel.Model -> List (Html Msg)
contentView sessionModel model =
    case ( model.fetching, model.board ) of
        ( True, _ ) ->
            [ i
                [ class "fa fa-spinner fa-spin" ]
                []
            ]

        ( False, Just board ) ->
            [ header
                [ class "view-header" ]
                [ h3
                    []
                    [ text board.name ]
                , membersView model board
                ]
            , div
                [ class "canvas-wrapper" ]
                [ div
                    [ class "canvas" ]
                    [ listsWrapperView model board.lists model.listForm ]
                ]
            ]

        _ ->
            [ text "" ]


membersView : BoardsModel.Model -> BoardsModel.BoardModel -> Html Msg
membersView model board =
    let
        members =
            Maybe.withDefault [] board.members

        connectedUsers =
            model.connectedUsers
    in
        [ addNewMemberList model ]
            |> List.append (List.map (\member -> memberView connectedUsers member) members)
            |> ul
                [ class "board-users" ]


memberView : List Int -> SessionModel.User -> Html Msg
memberView connectedUsers user =
    let
        classes =
            classList
                [ ( "connected", List.any (\member -> member == user.id) connectedUsers )
                ]

        gravatarUrl =
            "http://www.gravatar.com/avatar/" ++ user.email ++ "?s=200"
    in
        li
            [ classes ]
            [ img
                [ class "react-gravatar"
                , src gravatarUrl
                ]
                []
            ]


addNewMemberList : BoardsModel.Model -> Html Msg
addNewMemberList model =
    li
        []
        [ a
            [ class "add-new"
            , onClick (ShowMembersForm True)
            ]
            [ i
                [ class "fa fa-plus" ]
                []
            ]
        , addNewMemberForm model
        ]


addNewMemberForm : BoardsModel.Model -> Html Msg
addNewMemberForm model =
    let
        classes =
            classList
                [ ( "drop-down", True )
                , ( "active", model.membersForm.show )
                ]

        errorContent =
            case model.membersForm.error of
                Nothing ->
                    text ""

                Just error ->
                    div
                        [ class "error" ]
                        [ text error ]
    in
        ul
            [ classes ]
            [ li
                []
                [ Html.form
                    [ onSubmit AddMemberStart ]
                    [ h4
                        []
                        [ text "Add new member" ]
                    , errorContent
                    , input
                        [ type' "email"
                        , value model.membersForm.email
                        , required True
                        , placeholder "Member's email"
                        , onInput HandleMembersFormEmailInput
                        ]
                        []
                    , button
                        [ type' "submit" ]
                        [ text "Add member" ]
                    , text " or "
                    , a
                        [ onClick (ShowMembersForm False) ]
                        [ text "cancel" ]
                    ]
                ]
            ]
