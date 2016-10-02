module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Home.Model as HomeModel exposing (..)
import Session.Model as SessionModel exposing (..)
import Home.Types exposing (..)


view : SessionModel.Model -> HomeModel.Model -> Html Msg
view sessionModel model =
    case sessionModel.user of
        Nothing ->
            text ""

        _ ->
            div
                [ class "view-container boards index" ]
                [ ownedBoardsView model ]


ownedBoardsView : HomeModel.Model -> Html Msg
ownedBoardsView model =
    let
        fetching =
            model.fetching

        iconClasses =
            classList
                [ ( "fa", True )
                , ( "fa-user", (fetching == False) )
                , ( "fa-spinner", fetching )
                , ( "fa-spin", fetching )
                ]
    in
        section
            []
            [ header
                [ class "view-header" ]
                [ h3
                    []
                    [ i
                        [ iconClasses ]
                        []
                    , text " My boards"
                    ]
                ]
            ]
