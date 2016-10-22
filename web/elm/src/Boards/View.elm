module Boards.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Session.Model as SessionModel exposing (..)
import Boards.Model as BoardsModel exposing (..)
import Boards.Types exposing (..)


view : SessionModel.Model -> BoardsModel.Model -> Html Msg
view sessionModel model =
    case sessionModel.user of
        Nothing ->
            text ""

        _ ->
            div
                [ class "view-container boards show" ]
                [ contentView sessionModel model ]


contentView : SessionModel.Model -> BoardsModel.Model -> Html Msg
contentView sessionModel model =
    case ( model.fetching, model.board ) of
        ( True, _ ) ->
            i
                [ class "fa fa-spinner fa-spin" ]
                []

        ( False, Just board ) ->
            div
                []
                [ header
                    [ class "view-header" ]
                    [ h3
                        []
                        [ text board.name ]
                    , membersView board
                    ]
                ]

        _ ->
            text ""


membersView : BoardsModel.BoardModel -> Html Msg
membersView board =
    let
        members =
            Maybe.withDefault [] board.members
    in
        members
            |> List.map memberView
            |> ul
                [ class "board-users" ]


memberView : SessionModel.User -> Html Msg
memberView user =
    let
        classes =
            classList
                [ ( "connected", True )
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
