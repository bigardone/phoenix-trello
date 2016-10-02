module Home.Model exposing (..)

import Boards.Model exposing (..)


type alias Model =
    { fetching : Bool
    , owned_boards : List BoardModel
    , invited_boards : List BoardModel
    , showBoardForm : Bool
    }


type alias FetchBoardsModel =
    { owned_boards : List BoardModel
    , invited_boards : List BoardModel
    }


initialModel : Model
initialModel =
    { fetching = True
    , owned_boards = []
    , invited_boards = []
    , showBoardForm = False
    }
