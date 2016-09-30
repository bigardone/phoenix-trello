module Session.Model exposing (..)


type alias Model =
    { jwt : Maybe String
    , user : Maybe User
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


type alias AuthResponseModel =
    { jwt : String
    , user : User
    }


initialModel : Model
initialModel =
    { jwt = Nothing
    , user = Nothing
    , form = FormModel "" ""
    , error = Nothing
    }
