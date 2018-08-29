module Home.Model exposing (..)

import Boards.Model exposing (..)


type alias Model =
    { fetching : Bool
    , owned_boards : List BoardModel
    , invited_boards : List BoardModel
    , showBoardForm : Bool
    , form : BoardFormModel
    }


type alias FetchBoardsModel =
    { owned_boards : List BoardModel
    , invited_boards : List BoardModel
    }


type alias BoardFormModel =
    { name : String }


initialModel : Model
initialModel =
    { fetching = True
    , owned_boards = []
    , invited_boards = []
    , showBoardForm = False
    , form = { name = "" }
    }
