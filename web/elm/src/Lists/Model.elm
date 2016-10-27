module Lists.Model exposing (..)

import Cards.Model as CardsModel


type alias Model =
    { id : Int
    , board_id : Int
    , name : String
    , position : Int
    , cards : List CardsModel.Model
    }


type alias ListForm =
    { id : Maybe Int
    , name : String
    , error : Maybe String
    , show : Bool
    }


initialListForm : Maybe Int -> ListForm
initialListForm maybeId =
    { id = maybeId
    , name = ""
    , error = Nothing
    , show = False
    }
