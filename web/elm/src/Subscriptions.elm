module Subscriptions exposing (..)

import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)
import Model exposing (..)
import Session.Model exposing (..)
import Types exposing (..)
import Home.Types exposing (..)


socketUrl : String
socketUrl =
    "ws://localhost:4000/socket/websocket"


socket : Maybe String -> Socket
socket token =
    case token of
        Nothing ->
            Socket.init socketUrl

        Just jwt ->
            Socket.init (socketUrl ++ "?token=" ++ jwt)


lobby : String -> Channel Types.Msg
lobby id =
    Channel.init ("users:" ++ id)
        |> Channel.onJoin (always (HomeMsg <| FetchBoardsStart))
        |> Channel.withDebug


subscriptions : Model.Model -> Sub Types.Msg
subscriptions model =
    let
        token =
            model.session.jwt

        state =
            model.session.state

        userId =
            case model.session.user of
                Just user ->
                    toString user.id

                Nothing ->
                    ""
    in
        case state of
            JoiningLobby ->
                Phoenix.connect (socket token) [ lobby userId ]

            JoinedLobby ->
                Phoenix.connect (socket token) [ lobby userId ]

            _ ->
                Sub.none
