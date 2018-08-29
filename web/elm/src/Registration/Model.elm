module Registration.Model exposing (..)


type alias Model =
    { form :
        FormModel
        --, errors : SignUpError
    , error : Maybe String
    }


type alias FormModel =
    { firstName : String
    , lastName : String
    , email : String
    , password : String
    , passwordConfirmation : String
    }


type alias SignUpError =
    { firstName : Maybe String
    , lastName : Maybe String
    , email : Maybe String
    , password : Maybe String
    , passwordConfirmation : Maybe String
    }


initialModel : Model
initialModel =
    { form =
        FormModel "" "" "" "" ""
        --, errors = SignUpError Nothing Nothing Nothing Nothing Nothing
    , error = Nothing
    }
