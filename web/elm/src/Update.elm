module Update exposing (..)

import Types exposing (Msg(..))
import Model exposing (..)
import Session.Update
import Registration.Update
import Home.Update
import Boards.Update
import Session.Types as SessionTypes
import Home.Model as HomeModel


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
                in
                    { model | currentBoard = currentBoard } ! [ Cmd.map BoardsMsg cmd ]

            SessionMsg (SessionTypes.SignOutSuccess raw) ->
                let
                    ( session, cmd ) =
                        Session.Update.update (SessionTypes.SignOutSuccess raw) model.session
                in
                    { model
                        | session = session
                        , home = HomeModel.initialModel
                    }
                        ! [ Cmd.map SessionMsg cmd ]

            SessionMsg subMsg ->
                let
                    ( session, cmd ) =
                        Session.Update.update subMsg model.session
                in
                    { model | session = session } ! [ Cmd.map SessionMsg cmd ]

            RegistrationMsg subMsg ->
                let
                    ( registration, cmd ) =
                        Registration.Update.update subMsg model.registration
                in
                    { model | registration = registration } ! [ cmd ]

            ToggleBoardsList show ->
                { model | showBoardsList = show } ! []
