module Types exposing (..)

import Session.Types
import Registration.Types
import Home.Types
import Boards.Types


type Msg
    = HomeMsg Home.Types.Msg
    | BoardsMsg Boards.Types.Msg
    | SessionMsg Session.Types.Msg
    | RegistrationMsg Registration.Types.Msg
    | ToggleBoardsList Bool


type alias Flags =
    { jwt : Maybe String }
