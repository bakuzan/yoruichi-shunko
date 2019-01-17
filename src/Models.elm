module Models exposing (..)


type alias Model =
    { calendarMode: String
    }

initialModel : Model
initialModel = 
    { calendarMode = "WEEK"
    }