module Boards.Update exposing (..)

import Json.Decode as JD
import Boards.Types exposing (..)
import Boards.Model exposing (..)
import Boards.Decoder exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JoinChannelSuccess raw ->
            case JD.decodeValue boardResponseDecoder raw of
                Ok payload ->
                    { model
                        | fetching = False
                        , board = Just payload.board
                        , state = JoinedBoard
                    }
                        ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        { model | fetching = False } ! []

        UserJoined raw ->
            case JD.decodeValue connectedUsersResponseDecoder raw of
                Ok payload ->
                    { model | connectedUsers = payload.users } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        { model | fetching = False } ! []
