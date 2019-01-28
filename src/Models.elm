module Models exposing (CalendarMode(..), Model, Todo, TodoTemplate, Todos, YRIDateProperty(..), initialModel, todoFormDefaults)

import Time



-- App model


type alias Model =
    { calendarMode : CalendarMode
    , today : Time.Posix
    , zone : Time.Zone
    , calendarViewDate : Time.Posix
    , displayForm : Bool
    , todoForm : TodoTemplate
    , displayDatepicker : Bool
    , todos : Todos
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
    , todos = []
    }



-- Task Model


type alias Todo =
    { id : Int
    , name : String
    , date : String -- Int -- Date in millis
    , isRepeated : Bool
    , todoTemplateId : Int
    }


type alias Todos =
    List Todo


type alias TodoTemplate =
    { id : Int
    , name : String
    , date : Time.Posix
    , repeatPattern : String
    , repeatFor : Int
    , repeatWeekDefinition : Int
    }


todoFormDefaults : TodoTemplate
todoFormDefaults =
    TodoTemplate 0 "" (Time.millisToPosix 0) "None" 1 1



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
