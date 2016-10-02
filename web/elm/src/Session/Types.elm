module Session.Types exposing (..)

import Http exposing (..)
import Session.Model exposing (..)


type Msg
    = NavigateToRegistration
    | HandleEmailInput String
    | HandlePasswordInput String
    | SignIn
    | SignInSuccess AuthResponseModel
    | SignInError Http.Error
    | CurrentUserSuccess User
    | CurrentUserError Http.Error
    | SignOut
    | SignOutSuccess SignOutResponseModel
    | SignOutError Http.Error
