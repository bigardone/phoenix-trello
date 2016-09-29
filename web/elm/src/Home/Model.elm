module Home.Model exposing (..)


type alias Model =
    { fetching : Bool }


initialModel : Model
initialModel =
    { fetching = True }
