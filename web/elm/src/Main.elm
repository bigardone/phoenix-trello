module Main exposing (..)

import Navigation
import Task exposing (..)
import View exposing (view)
import Model exposing (..)
import Types exposing (..)
import Update exposing (..)
import Routing exposing (Route)
import Routing exposing (..)
import Session.Model as SessionModel
import Session.Types as SessionTypes
import Session.API exposing (..)
import Subscriptions exposing (..)


init : Flags -> Result String Route -> ( Model, Cmd Msg )
init flags result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        urlUpdate result (initialModel flags currentRoute)


urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result

        session =
            model.session
    in
        case currentRoute of
            HomeIndexRoute ->
                ( { model | route = currentRoute }, authenticationCheck session )

            BoardShowRoute slug ->
                let
                    boardModel =
                        model.currentBoard

                    newCurrentBoard =
                        { boardModel
                            | id = Just slug
                        }
                in
                    { model
                        | route = currentRoute
                        , currentBoard = newCurrentBoard
                        , state = JoiningBoard
                    }
                        ! [ authenticationCheck session ]

            _ ->
                { model | route = currentRoute } ! []


authenticationCheck : SessionModel.Model -> Cmd Msg
authenticationCheck session =
    case session.user of
        Nothing ->
            case session.jwt of
                Nothing ->
                    Navigation.newUrl (toPath SessionNewRoute)

                Just jwt ->
                    Cmd.map SessionMsg <| Task.perform SessionTypes.CurrentUserError SessionTypes.CurrentUserSuccess (currentUser jwt)

        Just user ->
            Cmd.none


main : Program Flags
main =
    Navigation.programWithFlags Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
