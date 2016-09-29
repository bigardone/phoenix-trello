module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)


type Route
    = HomeIndexRoute
    | SessionNewRoute
    | RegistrationNewRoute
    | NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        HomeIndexRoute ->
            "/"

        SessionNewRoute ->
            "/sign-in"

        RegistrationNewRoute ->
            "/sign-up"

        NotFoundRoute ->
            "/not-found"


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ format HomeIndexRoute (s "")
        , format SessionNewRoute (s "sign-in")
        , format RegistrationNewRoute (s "sign-up")
        ]


hashParser : Navigation.Location -> Result String Route
hashParser location =
    location.pathname
        |> String.dropLeft 1
        |> parse identity routeParser


parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route
routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            NotFoundRoute
