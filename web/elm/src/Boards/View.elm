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
                [ class "view-container boards index" ]
                [ contentView sessionModel model ]


contentView : SessionModel.Model -> BoardsModel.Model -> Html Msg
contentView sessionModel model =
    case model.fetching of
        True ->
            div
                [ class "view-container boards show" ]
                [ i
                    [ class "fa fa-spinner fa-spin" ]
                    []
                ]

        False ->
            div
                [ class "view-container boards show" ]
                []
