module Registration.Types exposing (..)

import Http exposing (..)


type Msg
    = NavigateToSession
    | HandleFirstNameInput String
    | HandlePLastNameInput String
    | HandleEmailInput String
    | HandlePasswordInput String
    | HandlePasswordConfirmationInput String
    | SignUp
    | SignUpError Http.Error
