module Types exposing (..)

import Session.Types exposing (..)
import Registration.Types exposing (..)


type Msg
    = SessionMsg Session.Types.Msg
    | RegistrationMsg Registration.Types.Msg
