module Update exposing (..)

import Types exposing (Msg(..))
import Model exposing (..)
import Session.Update
import Registration.Update
import Home.Update
import Boards.Update
import Session.Types as SessionTypes
import Boards.Types as BoardsTypes


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        jwt =
            Maybe.withDefault "" model.session.jwt
    in
        case msg of
            HomeMsg subMsg ->
                let
                    ( home, cmd ) =
                        Home.Update.update subMsg model.home jwt
                in
                    { model | home = home } ! [ Cmd.map HomeMsg cmd ]

            BoardsMsg subMsg ->
                let
                    ( currentBoard, cmd ) =
                        Boards.Update.update subMsg model.currentBoard

                    state =
                        case subMsg of
                            BoardsTypes.JoinChannelSuccess _ ->
                                JoiningBoard
                in
                    { model
                        | currentBoard = currentBoard
                        , state = state
                    }
                        ! [ Cmd.map BoardsMsg cmd ]

            SessionMsg subMsg ->
                let
                    ( session, cmd ) =
                        Session.Update.update subMsg model.session

                    state =
                        case subMsg of
                            SessionTypes.SignInSuccess _ ->
                                JoiningLobby

                            SessionTypes.CurrentUserSuccess _ ->
                                JoiningLobby

                            SessionTypes.SignOutSuccess _ ->
                                LeftLobby

                            _ ->
                                model.state
                in
                    { model
                        | session = session
                        , state = state
                    }
                        ! [ Cmd.map SessionMsg cmd ]

            RegistrationMsg subMsg ->
                let
                    ( registration, cmd ) =
                        Registration.Update.update subMsg model.registration
                in
                    { model | registration = registration } ! [ Cmd.map RegistrationMsg cmd ]

            ToggleBoardsList show ->
                { model | showBoardsList = show } ! []
