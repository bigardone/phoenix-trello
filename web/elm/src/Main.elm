module Main exposing (..)

import Navigation
import View exposing (view)
import Model exposing (..)
import Types exposing (Msg(..))
import Update exposing (..)
import Routing exposing (Route)
import Routing exposing (..)
import Session.Model exposing (User)


init : Result String Route -> ( Model, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        urlUpdate result (initialModel currentRoute)


urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result

        user =
            model.session.user
    in
        case currentRoute of
            HomeIndexRoute ->
                ( { model | route = currentRoute }, authenticationCheck user )

            _ ->
                ( { model | route = currentRoute }, Cmd.none )


authenticationCheck : Maybe User -> Cmd Msg
authenticationCheck user =
    case user of
        Nothing ->
            Navigation.newUrl (toPath SessionNewRoute)

        Just user ->
            Cmd.none


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
