module Models exposing (CalendarMode(..), CalendarViewResponse, Model, TemplateRequestResponse, Todo, TodoTemplate, TodoTemplateForm, Todos, YRIDateProperty(..), YRIResponse, dummyTodo, initialModel, todoFormDefaults)

import Time



-- App model


type alias Model =
    { calendarMode : CalendarMode
    , today : Time.Posix
    , zone : Time.Zone
    , calendarViewDate : Time.Posix
    , displayForm : Bool
    , todoForm : TodoTemplateForm
    , displayDatepicker : Bool
    , todos : Todos
    , errorMessage : String
    , contextMenuActiveFor : Int
    , isInstanceForm : Bool
    , deleteActiveFor : Int
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
    , errorMessage = ""
    , contextMenuActiveFor = 0
    , isInstanceForm = True
    , deleteActiveFor = 0
    }



-- Task Model


type alias Todo =
    { id : Int
    , name : String
    , date : Int -- Int -- Date in millis
    , isRepeated : Bool
    , todoTemplateId : Int
    }


dummyTodo : Todo
dummyTodo =
    Todo 0 "" 0 False 0


type alias Todos =
    List Todo


type alias TodoTemplate =
    { id : Int
    , name : String
    , date : Int
    , repeatPattern : String
    , repeatFor : Int
    , repeatWeekDefinition : Int
    }


type alias TodoTemplateForm =
    { id : Int
    , name : String
    , date : Time.Posix
    , repeatPattern : String
    , repeatFor : Int
    , repeatWeekDefinition : Int
    }


todoFormDefaults : TodoTemplateForm
todoFormDefaults =
    TodoTemplateForm 0 "" (Time.millisToPosix 0) "None" 1 1


type alias CalendarViewResponse =
    { todos : Todos
    , errorMessage : String
    }


type alias TemplateRequestResponse =
    { template : TodoTemplateForm
    , errorMessage : String
    }


type alias YRIResponse =
    { success : Bool
    , errorMessages : List String
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
    | FormDate
