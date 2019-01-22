module Models exposing (CalendarMode(..), Model, Todo, TodoForm, YRIDateProperty(..), initialModel, todoFormDefaults)

import Time



-- App model


type alias Model =
    { calendarMode : CalendarMode
    , today : Time.Posix
    , zone : Time.Zone
    , calendarViewDate : Time.Posix
    , displayForm : Bool
    , todoForm : TodoForm
    , displayDatepicker : Bool
    }


initialModel : Model
initialModel =
    { calendarMode = Week
    , today = Time.millisToPosix 0
    , zone = Time.utc
    , calendarViewDate = Time.millisToPosix 0
    , displayForm = False
    , todoForm = todoFormDefaults
    , displayDatepicker = False
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
    , repeatPattern : String
    , repeatFor : Int
    , repeatWeekDefinition : Int
    }


todoFormDefaults : TodoForm
todoFormDefaults =
    TodoForm 0 "" (Time.millisToPosix 0) "None" 1 1



-- Custom Types


type CalendarMode
    = Day
    | Week
    | Month


type YRIDateProperty
    = Ignored
    | Today
    | CalendarViewDate
    | FormDate
