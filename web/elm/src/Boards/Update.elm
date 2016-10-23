module Boards.Update exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Phoenix exposing (..)
import Phoenix.Push as Push
import Boards.Types exposing (..)
import Boards.Model exposing (..)
import Boards.Decoder exposing (..)
import Subscriptions exposing (socketUrl)


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

        ShowMembersForm show ->
            { model | membersForm = MembersFormModel show "" Nothing } ! []

        HandleMembersFormEmailInput value ->
            let
                membersForm =
                    model.membersForm
            in
                { model
                    | membersForm =
                        { membersForm
                            | email = value
                        }
                }
                    ! []

        AddMemberStart ->
            model ! [ addMember model ]

        AddMemberSuccess _ ->
            { model | membersForm = initialMembersFormModel } ! []

        AddMemberError raw ->
            let
                _ =
                    Debug.log "AddMemberError" raw
            in
                model ! []


addMember : Model -> Cmd Msg
addMember model =
    case model.board of
        Nothing ->
            Cmd.none

        Just board ->
            let
                payload =
                    JE.object
                        [ ( "email", JE.string model.membersForm.email ) ]

                channel =
                    "boards:" ++ board.id

                push =
                    Push.init channel "members:add"
                        |> Push.withPayload payload
                        |> Push.onOk AddMemberSuccess
                        |> Push.onError AddMemberError
            in
                Phoenix.push socketUrl push
