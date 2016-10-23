module Boards.Model exposing (..)

import Session.Model exposing (User)


type alias Model =
    { id : Maybe String
    , state : State
    , fetching : Bool
    , board : Maybe BoardModel
    , connectedUsers : List Int
    , membersForm : MembersFormModel
    }


type alias BoardModel =
    { id : String
    , user_id : Maybe Int
    , name : String
    , user : Maybe User
    , lists : Maybe (List ListModel)
    , members : Maybe (List User)
    }


type alias MembersFormModel =
    { show : Bool
    , email : String
    , error : Maybe String
    }


type alias ListModel =
    { id : Int
    , board_id : Int
    , name : String
    , position : Int
    , cards : List CardModel
    }


type alias CardModel =
    { id : Int
    , list_id : Int
    , name : String
    , description : Maybe String
    , position : Int
    , tags : List String
    , comments : List CommentModel
    , members : List User
    }


type alias CommentModel =
    { id : Int
    , card_id : Int
    , user : User
    , text : String
    , inserted_at : String
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
    }
