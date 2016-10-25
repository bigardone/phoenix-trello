module Lists.Model exposing (..)

import Cards.Model as CardsModel


type alias Model =
    { id : Int
    , board_id : Int
    , name : String
    , position : Int
    , cards : List CardsModel.Model
    }
