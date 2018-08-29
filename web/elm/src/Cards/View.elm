module Cards.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Cards.Model exposing (..)
import Boards.Types exposing (..)


cardsWrapperView : List Model -> Html Msg
cardsWrapperView cards =
    case cards of
        [] ->
            text ""

        _ ->
            cards
                |> List.map cardView
                |> div
                    [ class "cards-wrapper" ]


cardView : Model -> Html Msg
cardView card =
    div
        [ id <| toString card.id
        , class "card"
        ]
        [ div
            [ class "card-content" ]
            [ text card.name ]
        ]
