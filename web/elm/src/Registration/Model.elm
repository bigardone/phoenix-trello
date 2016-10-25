module Registration.Model exposing (..)


type alias Model =
    { form : FormModel
    , errors : Maybe String
    }


type alias FormModel =
    { firstName : String
    , lastName : String
    , email : String
    , password : String
    , passwordConfirmation : String
    }


initialModel : Model
initialModel =
    { form = FormModel "" "" "" "" ""
    , errors = Nothing
    }
