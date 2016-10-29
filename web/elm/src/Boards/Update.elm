module Boards.Update exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Phoenix exposing (..)
import Phoenix.Push as Push
import Boards.Types exposing (..)
import Boards.Model exposing (..)
import Boards.Decoder exposing (..)
import Session.Decoder exposing (userResponseDecoder)
import Lists.Decoder exposing (listResponseDecoder)
import Subscriptions exposing (socketUrl)
import Lists.Model exposing (initialListForm)


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
            case JD.decodeValue errorResponseDecoder raw of
                Ok payload ->
                    let
                        membersForm =
                            model.membersForm
                    in
                        { model | membersForm = { membersForm | error = Just payload.error } } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "AddMemberError" raw
                    in
                        model ! []

        MemberAdded raw ->
            case JD.decodeValue userResponseDecoder raw of
                Ok payload ->
                    let
                        ( board, members ) =
                            case model.board of
                                Nothing ->
                                    ( initialBoard, [ payload.user ] )

                                Just board ->
                                    ( board, payload.user :: (Maybe.withDefault [] board.members) )

                        newBoard =
                            { board | members = Just members }
                    in
                        { model | board = Just newBoard } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "MemberAdded" raw
                    in
                        model ! []

        ShowListForm ->
            let
                listForm =
                    initialListForm Nothing
            in
                { model | listForm = { listForm | show = True } } ! []

        HideListForm ->
            { model | listForm = initialListForm Nothing } ! []

        HandleListFormNameInput value ->
            let
                listForm =
                    model.listForm
            in
                { model | listForm = { listForm | name' = value } } ! []

        SaveListStart ->
            model ! [ saveList model ]

        SaveListSuccess _ ->
            { model | listForm = initialListForm Nothing } ! []

        SaveListError raw ->
            case JD.decodeValue errorResponseDecoder raw of
                Ok payload ->
                    let
                        listForm =
                            model.listForm
                    in
                        { model | listForm = { listForm | error = Just payload.error } } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "SaveListError" raw
                    in
                        model ! []

        ListCreated raw ->
            case JD.decodeValue listResponseDecoder raw of
                Ok payload ->
                    case model.board of
                        Nothing ->
                            model ! []

                        Just board ->
                            let
                                newList =
                                    payload.list

                                lists =
                                    [ newList ]
                                        |> List.append (Maybe.withDefault [] board.lists)

                                newCurrentBoard =
                                    { board | lists = Just lists }
                            in
                                { model | board = Just newCurrentBoard } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "ListCreated" raw
                    in
                        model ! []

        EditList list ->
            let
                listForm =
                    initialListForm (Just list.id)
            in
                { model
                    | listForm =
                        { listForm
                            | name' = list.name
                            , show = True
                        }
                }
                    ! []

        UpdateBoard raw ->
            case JD.decodeValue boardResponseDecoder raw of
                Ok payload ->
                    { model | board = Just payload.board } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        { model | fetching = False } ! []


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


saveList : Model -> Cmd Msg
saveList model =
    case model.board of
        Nothing ->
            Cmd.none

        Just board ->
            let
                listForm =
                    model.listForm

                payload =
                    JE.object
                        [ ( "list"
                          , JE.object
                                [ ( "id", JE.int (Maybe.withDefault 0 listForm.id) )
                                , ( "name", JE.string listForm.name' )
                                ]
                          )
                        ]

                channel =
                    "boards:" ++ board.id

                topic =
                    case listForm.id of
                        Nothing ->
                            "lists:create"

                        Just listId ->
                            "list:update"

                push =
                    Push.init channel topic
                        |> Push.withPayload payload
                        |> Push.onOk SaveListSuccess
                        |> Push.onError SaveListError
            in
                Phoenix.push socketUrl push
