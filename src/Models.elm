module Models exposing (CalendarMode(..), Model, Todo, YRIDateProperty(..), initialModel)

import Time



-- App model


type alias Model =
    { calendarMode : CalendarMode
    , today : Time.Posix
    , zone : Time.Zone
    , calendarViewDate : Time.Posix
    , displayForm : Bool
    , todoForm : TodoForm
    }


initialModel : Model
initialModel =
    { calendarMode = Week
    , today = Time.millisToPosix 0
    , zone = Time.utc
    , calendarViewDate = Time.millisToPosix 0
    , displayForm = False
    , todoForm = TodoForm 0 "" (Time.millisToPosix 0)
    }



-- Task Model
-- TODO fill in todo model


type alias Todo =
    { id : Int
    , name : String
    , date : Int -- Date in millis
    }


type alias TodoForm =
    { id : Int
    , name : String
    , date : Time.Posix
    }



-- Custom Types


type CalendarMode
    = Day
    | Week
    | Month


type YRIDateProperty
    = Ignored
    | Today
    | CalendarViewDate
