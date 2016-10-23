module Subscriptions exposing (..)

import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)
import Model exposing (..)
import Session.Model exposing (..)
import Boards.Model exposing (State(..))
import Types exposing (..)
import Home.Types exposing (..)
import Boards.Types exposing (..)


socketUrl : String
socketUrl =
    "ws://localhost:4000/socket/websocket"


socket : Maybe String -> Socket
socket token =
    case token of
        Nothing ->
            Socket.init socketUrl

        Just jwt ->
            Socket.init socketUrl
                |> Socket.withDebug
                |> Socket.withParams [ ( "token", jwt ) ]


lobby : String -> Channel Types.Msg
lobby id =
    Channel.init ("users:" ++ id)
        |> Channel.onJoin (always (HomeMsg <| FetchBoardsStart))
        |> Channel.withDebug


board : String -> Channel Types.Msg
board id =
    Channel.init ("boards:" ++ id)
        |> Channel.onJoin (\raw -> (BoardsMsg <| JoinChannelSuccess raw))
        |> Channel.on "user:joined" (\raw -> (BoardsMsg <| UserJoined raw))
        |> Channel.withDebug


subscriptions : Model.Model -> Sub Types.Msg
subscriptions model =
    let
        token =
            model.session.jwt

        userId =
            case model.session.user of
                Just user ->
                    toString user.id

                Nothing ->
                    ""

        boardId =
            Maybe.withDefault "" model.currentBoard.id

        sessionSub =
            case model.session.state of
                JoiningLobby ->
                    Phoenix.connect (socket token) [ lobby userId ]

                JoinedLobby ->
                    Phoenix.connect (socket token) [ lobby userId ]

                _ ->
                    Sub.none

        boardSub =
            case model.currentBoard.state of
                JoiningBoard ->
                    Phoenix.connect (socket token) [ board boardId ]

                JoinedBoard ->
                    Phoenix.connect (socket token) [ board boardId ]

                _ ->
                    Sub.none
    in
        Sub.batch [ sessionSub, boardSub ]
