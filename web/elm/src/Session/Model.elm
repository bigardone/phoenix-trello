module Session.Model exposing (..)


type alias Model =
    { currentUser : Maybe User
    , form : FormModel
    , error : Maybe String
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


initialModel : Model
initialModel =
    { currentUser = Nothing
    , form = FormModel "" ""
    , error = Nothing
    }
