module Lists.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Lists.Model exposing (..)
import Boards.Model as BoardsModel
import Boards.Types exposing (..)
import Cards.View exposing (..)


listsWrapperView : BoardsModel.Model -> Maybe (List Model) -> ListForm -> Html Msg
listsWrapperView boardModel maybeLists listForm =
    case maybeLists of
        Nothing ->
            text ""

        Just lists ->
            [ addNewListView listForm ]
                |> List.append (List.map (\list -> listView boardModel.listForm list) lists)
                |> div
                    [ class "lists-wrapper" ]


listView : ListForm -> Model -> Html Msg
listView listForm list =
    div
        [ id <| toString list.id
        , class "list"
        ]
        [ div
            [ class "inner" ]
            [ headerView listForm list
            , cardsWrapperView list.cards
            ]
        ]


headerView : ListForm -> Model -> Html Msg
headerView listForm list =
    case ( Maybe.withDefault 0 listForm.id == list.id, listForm.show ) of
        ( True, True ) ->
            listFormView listForm

        _ ->
            header
                [ onClick (EditList list) ]
                [ h4
                    []
                    [ text list.name ]
                ]


addNewListView : ListForm -> Html Msg
addNewListView listForm =
    case ( listForm.show, listForm.id ) of
        ( True, Nothing ) ->
            listFormView listForm

        _ ->
            addButtonView


addButtonView : Html Msg
addButtonView =
    div
        [ class "list add-new"
        , onClick <| ShowListForm
        ]
        [ div
            [ class "inner" ]
            [ text "Add new list..." ]
        ]


listFormView : ListForm -> Html Msg
listFormView listForm =
    let
        ( buttonText, namePlaceholder ) =
            case listForm.id of
                Nothing ->
                    ( "Save list", "Add a new list..." )

                Just _ ->
                    ( "Update list", "Name" )
    in
        div
            [ class "list form" ]
            [ div
                [ class "inner" ]
                [ Html.form
                    [ id "new_list_form"
                    , onSubmit SaveListStart
                    ]
                    [ input
                        [ rel "name"
                        , id "list_name"
                        , type' "text"
                        , value listForm.name'
                        , placeholder namePlaceholder
                        , required True
                        , onInput HandleListFormNameInput
                        ]
                        []
                    , formErrorView listForm.error
                    , button
                        [ type' "submit" ]
                        [ text buttonText ]
                    , text " or "
                    , a
                        [ onClick <| HideListForm ]
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
