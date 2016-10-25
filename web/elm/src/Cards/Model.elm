module Cards.Model exposing (..)

import Session.Model exposing (User)


type alias Model =
    { id : Int
    , list_id : Int
    , name : String
    , description : Maybe String
    , position : Int
    , tags : List String
    , comments : List CommentModel
    , members : List User
    }


type alias CommentModel =
    { id : Int
    , card_id : Int
    , user : User
    , text : String
    , inserted_at : String
    }
