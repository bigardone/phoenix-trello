module Session.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Session.Model exposing (..)
import Session.Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "view-container sessions new" ]
        [ main'
            []
            [ header
                []
                [ div
                    [ class "logo" ]
                    []
                ]
            , Html.form
                [ id "sign_in_form", attribute "onSubmit" "" ]
                [ errorView model.error
                , div
                    [ class "field" ]
                    [ input
                        [ defaultValue "john@phoenix-trello.com"
                        , id "user_email"
                        , placeholder "Email"
                        , required True
                        , type' "email"
                        ]
                        []
                    ]
                , div
                    [ class "field" ]
                    [ input
                        [ defaultValue "12345678"
                        , id "user_password"
                        , placeholder "Password"
                        , required True
                        , type' "password"
                        ]
                        []
                    ]
                , button
                    [ type' "submit" ]
                    [ text "Sign in" ]
                ]
            , a
                [ onClick NavigateToRegistration ]
                [ text "Create new account" ]
            ]
        ]


errorView : Maybe String -> Html Msg
errorView maybeError =
    case maybeError of
        Just error ->
            div
                [ class "error" ]
                [ text error ]

        Nothing ->
            text ""
