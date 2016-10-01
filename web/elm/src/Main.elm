module Main exposing (..)

import Navigation
import Task exposing (..)
import View exposing (view)
import Model exposing (..)
import Types exposing (..)
import Update exposing (..)
import Routing exposing (Route)
import Routing exposing (..)
import Session.Model exposing (User)
import Session.Types exposing (Msg(..))
import Session.API exposing (..)


init : Flags -> Result String Route -> ( Model, Cmd Types.Msg )
init flags result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        urlUpdate result (initialModel flags currentRoute)


urlUpdate : Result String Route -> Model -> ( Model, Cmd Types.Msg )
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

            _ ->
                ( { model | route = currentRoute }, Cmd.none )


authenticationCheck : Session.Model.Model -> Cmd Types.Msg
authenticationCheck session =
    case session.user of
        Nothing ->
            case session.jwt of
                Nothing ->
                    Navigation.newUrl (toPath SessionNewRoute)

                Just jwt ->
                    Cmd.map SessionMsg (Task.perform CurrentUserError CurrentUserSuccess (currentUser jwt))

        Just user ->
            Cmd.none


subscriptions : Model -> Sub Types.Msg
subscriptions model =
    Sub.none


main : Program Flags
main =
    Navigation.programWithFlags Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
