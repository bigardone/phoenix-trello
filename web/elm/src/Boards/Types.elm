module Boards.Types exposing (..)

import Json.Encode as JE


type Msg
    = JoinChannelSuccess JE.Value
