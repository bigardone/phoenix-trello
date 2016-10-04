module Boards.View exposing (..)

import Html exposing (..)
import Session.Model as SessionModel exposing (..)
import Boards.Model exposing (..)
import Boards.Types exposing (..)


view : SessionModel.Model -> Maybe BoardModel -> Html Msg
view session model =
    case model of
        Nothing ->
            text ""

        Just board ->
            div
                []
                []
