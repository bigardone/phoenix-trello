module Home.Update exposing (..)

import Task exposing (..)
import Home.Types exposing (..)
import Home.Model exposing (..)
import Home.API exposing (..)


update : Msg -> Model -> String -> ( Model, Cmd Msg )
update msg model jwt =
    case msg of
        FetchBoardsStart ->
            let
                fetch =
                    Task.perform FetchBoardsError FetchBoardsSuccess <| fetchBoards jwt
            in
                { model | fetching = True } ! [ fetch ]

        FetchBoardsSuccess res ->
            { model
                | fetching = False
                , owned_boards = res.owned_boards
                , invited_boards = res.invited_boards
            }
                ! []

        FetchBoardsError error ->
            let
                _ =
                    Debug.log "error" error
            in
                model ! []
