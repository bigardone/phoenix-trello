module Boards.Types exposing (..)

import Json.Encode as JE


type Msg
    = JoinChannelSuccess JE.Value
    | UserJoined JE.Value
    | ShowMembersForm Bool
    | HandleMembersFormEmailInput String
    | AddMemberStart
    | AddMemberSuccess JE.Value
    | AddMemberError JE.Value
    | MemberAdded JE.Value
    | ShowListForm Bool
