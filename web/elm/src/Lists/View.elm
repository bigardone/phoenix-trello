module Lists.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Lists.Model exposing (..)
import Boards.Types exposing (..)
import Cards.View exposing (..)


listsWrapperView : Maybe (List Model) -> ListForm -> Html Msg
listsWrapperView maybeLists listForm =
    case maybeLists of
        Nothing ->
            text ""

        Just lists ->
            [ addNewListView listForm ]
                |> List.append (List.map listView lists)
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


addNewListView : ListForm -> Html Msg
addNewListView listForm =
    case listForm.show of
        False ->
            addButtonView

        True ->
            listFormView listForm


addButtonView : Html Msg
addButtonView =
    div
        [ class "list add-new"
        , onClick <| ShowListForm True
        ]
        [ div
            [ class "inner" ]
            [ text "Add new list..." ]
        ]


listFormView : ListForm -> Html Msg
listFormView listForm =
    let
        buttonText =
            case listForm.id of
                Nothing ->
                    "Save list"

                Just _ ->
                    "Update list"
    in
        div
            [ class "list form" ]
            [ div
                [ class "inner" ]
                [ Html.form
                    [ id "new_list_form" ]
                    [ input
                        [ rel "name"
                        , id "list_name"
                        , type' "text"
                        , value listForm.name
                        , placeholder "Add a new list..."
                        , required True
                        ]
                        []
                    , formErrorView listForm.error
                    , button
                        [ type' "submit" ]
                        [ text buttonText ]
                    , text " or "
                    , a
                        []
                        [ text "cancel" ]
                    ]
                ]
            ]


formErrorView : Maybe String -> Html Msg
formErrorView maybeError =
    case maybeError of
        Nothing ->
            text ""

        Just error ->
            div
                [ class "error" ]
                [ text error ]
