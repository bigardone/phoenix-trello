module Update exposing (..)

import Types exposing (Msg(..))
import Model exposing (..)
import Session.Update exposing (..)
import Registration.Update exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
