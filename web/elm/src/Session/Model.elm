module Session.Model exposing (..)


type alias Model =
    { currentUser : Maybe String
    , error : Maybe String
    }


initialModel : Model
initialModel =
    { currentUser = Nothing
    , error = Nothing
    }
