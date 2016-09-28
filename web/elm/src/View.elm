module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ text "Hello, Trello!" ]
