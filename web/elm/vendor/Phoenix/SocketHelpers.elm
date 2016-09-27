module Phoenix.SocketHelpers exposing (..)

import Dict exposing (Dict)
import Process
import String
import Task exposing (Task)
import WebSocket.LowLevel as WS
import Phoenix.Message as Message exposing (Message)
import Phoenix.Socket as Socket exposing (..)


type alias Endpoint =
    String


type alias Ref =
    Int



-- MODIFY


opening : Int -> Process.Id -> Socket -> Socket
opening backoff pid socket =
    { socket | connection = Opening backoff pid }


connected : WS.WebSocket -> Socket -> Socket
connected ws socket =
    { socket | connection = Connected ws 0 }


increaseRef : Socket -> Socket
increaseRef socket =
    case socket.connection of
        Connected ws ref ->
            { socket | connection = Connected ws (ref + 1) }

        _ ->
            socket


updateParams : List ( String, String ) -> Socket -> Socket
updateParams params socket =
    { socket | params = params }



-- PUSH


push : Message -> Socket -> Task x (Maybe Ref)
push message socket =
    case socket.connection of
        Connected ws ref ->
            let
                message' =
                    if socket.debug then
                        Debug.log "Send" (Message.ref ref message)
                    else
                        Message.ref ref message
            in
                WS.send ws (Message.encode message')
                    |> Task.map
                        (\maybeBadSend ->
                            (case maybeBadSend of
                                Nothing ->
                                    Just ref

                                Just badSend ->
                                    if socket.debug then
                                        let
                                            _ =
                                                Debug.log "BadSend" badSend
                                        in
                                            Nothing
                                    else
                                        Nothing
                            )
                        )

        _ ->
            Task.succeed (Nothing)



-- OPEN CONNECTIONs


open : Socket -> WS.Settings -> Task WS.BadOpen WS.WebSocket
open socket settings =
    let
        endpoint =
            socket.endpoint

        query =
            socket.params
                |> List.map (\( key, val ) -> key ++ "=" ++ val)
                |> String.join "&"

        url =
            if String.contains "?" endpoint then
                endpoint ++ "&" ++ query
            else
                endpoint ++ "?" ++ query
    in
        WS.open url settings


after : Float -> Task x ()
after backoff =
    if backoff < 1 then
        Task.succeed ()
    else
        Process.sleep backoff



-- CLOSE CONNECTIONS


close : Socket -> Task x ()
close { connection } =
    case connection of
        Opening _ pid ->
            Process.kill pid

        Connected socket _ ->
            WS.close socket

        Closed ->
            Task.succeed ()



-- HELPERS


get : Endpoint -> Dict Endpoint Socket -> Maybe Socket
get endpoint dict =
    Dict.get endpoint dict


getRef : Endpoint -> Dict Endpoint Socket -> Maybe Ref
getRef endpoint dict =
    get endpoint dict `Maybe.andThen` ref


ref : Socket -> Maybe Ref
ref socket =
    case socket.connection of
        Connected _ ref' ->
            Just ref'

        _ ->
            Nothing


debugLogMessage : Socket -> a -> a
debugLogMessage socket msg =
    if socket.debug then
        Debug.log "Received" msg
    else
        msg
