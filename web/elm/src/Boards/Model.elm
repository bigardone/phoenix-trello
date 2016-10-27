module Boards.Model exposing (..)

import Session.Model exposing (User)
import Lists.Model as Lists


type alias Model =
    { id : Maybe String
    , state : State
    , fetching : Bool
    , board : Maybe BoardModel
    , connectedUsers : List Int
    , membersForm : MembersFormModel
    , listForm : Lists.ListForm
    }


type alias BoardModel =
    { id : String
    , user_id : Maybe Int
    , name : String
    , user : Maybe User
    , lists : Maybe (List Lists.Model)
    , members : Maybe (List User)
    }


type alias MembersFormModel =
    { show : Bool
    , email : String
    , error : Maybe String
    }


type State
    = JoiningBoard
    | JoinedBoard
    | LeavingBoard
    | LeftBoard


type alias BoardResponseModel =
    { board : BoardModel }


type alias ConnectedUsersListResponseModel =
    { users : List Int }


initialMembersFormModel : MembersFormModel
initialMembersFormModel =
    MembersFormModel False "" Nothing


initialModel : Model
initialModel =
    { id = Nothing
    , state = LeftBoard
    , fetching = True
    , board = Nothing
    , connectedUsers = []
    , membersForm = initialMembersFormModel
    , listForm = Lists.initialListForm Nothing
    }


initialBoard : BoardModel
initialBoard =
    { id = ""
    , user_id = Nothing
    , name = ""
    , user = Nothing
    , lists = Nothing
    , members = Nothing
    }
