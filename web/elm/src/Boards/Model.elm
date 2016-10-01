module Boards.Model exposing (..)

import Session.Model exposing (User)


type alias BoardModel =
    { id : String
    , name : String
    , user : User
    , lists : List ListModel
    , members : List User
    }


type alias ListModel =
    { id : Int
    , board_id : Int
    , name : String
    , position : Int
    , cards : List CardModel
    }


type alias CardModel =
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
