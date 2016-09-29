module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Home.Model exposing (..)
import Home.Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "view-container boards index" ]
        [ text "Home" ]
