module Types exposing (..)

import Session.Types
import Registration.Types
import Home.Types


type Msg
    = HomeMsg Home.Types.Msg
    | SessionMsg Session.Types.Msg
    | RegistrationMsg Registration.Types.Msg
