module Registration.Model exposing (..)


type alias Model =
    { form : FormModel
    , errors : Maybe String
    }


type alias FormModel =
    { firstName : Maybe String
    , lastName : Maybe String
    , email : Maybe String
    , password : Maybe String
    , passwordConfirmation : Maybe String
    }


initialModel : Model
initialModel =
    { form = FormModel Nothing Nothing Nothing Nothing Nothing
    , errors = Nothing
    }
