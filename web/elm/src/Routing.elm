module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)


type Route
    = SessionRoute
    | RegistrationRoute
    | NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        SessionRoute ->
            "/"

        RegistrationRoute ->
            "/sign-up"

        NotFoundRoute ->
            "/not-found"


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ format SessionRoute (s "")
        , format RegistrationRoute (s "registration")
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
