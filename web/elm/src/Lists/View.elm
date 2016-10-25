module Lists.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Lists.Model exposing (..)
import Boards.Types exposing (..)
import Cards.View exposing (..)


listsWrapperView : Maybe (List Model) -> Html Msg
listsWrapperView maybeLists =
    case maybeLists of
        Nothing ->
            text ""

        Just lists ->
            lists
                |> List.map listView
                |> div
                    [ class "lists-wrapper" ]


listView : Model -> Html Msg
listView list =
    div
        [ id <| toString list.id
        , class "list"
        ]
        [ div
            [ class "inner" ]
            [ headerView list
            , cardsWrapperView list.cards
            ]
        ]


headerView : Model -> Html Msg
headerView list =
    header
        []
        [ h4
            []
            [ text list.name ]
        ]
