module Session.Model exposing (..)


type alias Model =
    { jwt : Maybe String
    , user : Maybe User
    , form : FormModel
    , error : Maybe String
    , state : State
    }


type alias User =
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    }


type alias FormModel =
    { email : String
    , password : String
    }


type alias AuthResponseModel =
    { jwt : String
    , user : User
    }


type alias UserResponseModel =
    { user : User }


type alias SignOutResponseModel =
    { ok : Bool }


type State
    = JoiningLobby
    | JoinedLobby
    | LeavingLobby
    | LeftLobby


initialForm : FormModel
initialForm =
    FormModel "john@phoenix-trello.com" "12345678"


initialModel : Maybe String -> Model
initialModel jwt =
    { jwt = jwt
    , user = Nothing
    , form = initialForm
    , error = Nothing
    , state = LeftLobby
    }
