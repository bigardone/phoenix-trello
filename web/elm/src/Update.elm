module Update exposing (..)

import Types exposing (Msg(..))
import Model exposing (..)
import Session.Update
import Registration.Update
import Home.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "model" model
    in
        case msg of
            HomeMsg subMsg ->
                let
                    ( home, cmd ) =
                        Home.Update.update subMsg model.home
                in
                    { model | home = home } ! [ Cmd.map HomeMsg cmd ]

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
                    { model | registration = registration } ! [ Cmd.map RegistrationMsg cmd ]
