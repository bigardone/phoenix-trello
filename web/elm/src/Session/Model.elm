module Session.Model exposing (..)


type alias Model =
    { currentUser : Maybe User
    , error : Maybe String
    }


type alias User =
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    }


initialModel : Model
initialModel =
    { currentUser = Nothing
    , error = Nothing
    }
