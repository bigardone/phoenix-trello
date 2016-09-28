module View exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Model exposing (..)
import Types exposing (..)
import Routing exposing (..)
import Session.View as SessionView exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        SessionRoute ->
            Html.App.map SessionMsg (SessionView.view model.session)

        _ ->
            notFoundView


notFoundView : Html Msg
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
