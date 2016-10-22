module Subscriptions exposing (..)

import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Socket as Socket exposing (Socket)
import Model exposing (..)
import Types exposing (..)
import Home.Types as HomeTypes
import Boards.Types as BoardsTypes


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


lobby : String -> Channel Msg
lobby id =
    Channel.init ("users:" ++ id)
        |> Channel.onJoin (always (HomeMsg <| HomeTypes.FetchBoardsStart))
        |> Channel.withDebug


board : String -> Channel Msg
board id =
    Channel.init ("boards:" ++ id)
        |> Channel.onJoin (\res -> (BoardsMsg <| BoardsTypes.JoinChannelSuccess res))
        |> Channel.withDebug


subscriptions : Model -> Sub Msg
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
    in
        case model.state of
            JoiningLobby ->
                Phoenix.connect (socket token) [ lobby userId ]

            JoinedLobby ->
                Phoenix.connect (socket token) [ lobby userId ]

            JoiningBoard ->
                Phoenix.connect (socket token) [ board boardId, lobby userId ]

            JoinedBoard ->
                Phoenix.connect (socket token) [ board boardId, lobby userId ]

            _ ->
                Sub.none
