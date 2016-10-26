module Registration.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Registration.Model exposing (..)
import Registration.Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "view-container registrations new" ]
        [ main'
            []
            [ header
                []
                [ div
                    [ class "logo" ]
                    []
                ]
            , Html.form
                [ id "sign_in_form"
                , onSubmit SignUp
                ]
                [ errorView model.error
                , div
                    [ class "field" ]
                    [ input
                        [ id "user_first_name"
                        , placeholder "First name"
                        , required True
                        , type' "text"
                        , onInput HandleFirstNameInput
                        , value model.form.firstName
                        ]
                        []
                    ]
                , div
                    [ class "field" ]
                    [ input
                        [ id "user_last_name"
                        , placeholder "Last name"
                        , required True
                        , type' "text"
                        , onInput HandlePLastNameInput
                        , value model.form.lastName
                        ]
                        []
                    ]
                , div
                    [ class "field" ]
                    [ input
                        [ id "user_email"
                        , placeholder "Email"
                        , required True
                        , type' "email"
                        , onInput HandleEmailInput
                        , value model.form.email
                        ]
                        []
                    ]
                , div
                    [ class "field" ]
                    [ input
                        [ id "user_password"
                        , placeholder "Password"
                        , required True
                        , type' "password"
                        , onInput HandlePasswordInput
                        , value model.form.password
                        ]
                        []
                    ]
                , div
                    [ class "field" ]
                    [ input
                        [ id "user_password_confirmation"
                        , placeholder "Confirm password"
                        , required True
                        , type' "password"
                        , onInput HandlePasswordConfirmationInput
                        , value model.form.passwordConfirmation
                        ]
                        []
                    ]
                , button
                    [ type' "submit" ]
                    [ text "Sign up" ]
                ]
            , a
                [ onClick NavigateToSession ]
                [ text "Sign in" ]
            ]
        ]


errorView : Maybe String -> Html Msg
errorView maybeErrors =
    case maybeErrors of
        Just error ->
            div
                [ class "error" ]
                [ text error ]

        Nothing ->
            text ""
