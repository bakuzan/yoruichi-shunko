module Models exposing (CalendarMode(..), CalendarViewResponse, Flags, Model, TemplateRequestResponse, Theme, Todo, TodoTemplate, TodoTemplateForm, Todos, YRIDateProperty(..), YRIResponse, dummyTodo, initialModel, todoFormDefaults)

import Time



-- App flags


type alias Flags =
    { theme : Theme
    }


type alias Theme =
    { baseBackground : String
    , baseBackgroundHover : String
    , baseColour : String
    , colour : String
    , contrast : String
    , anchorColour : String
    , anchorColourHover : String
    , primaryBackground : String
    , primaryBackgroundHover : String
    , primaryColour : String
    }



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
    , isLoading : Bool
    , theme : Theme
    }


initialModel : Flags -> Model
initialModel flags =
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
    , isLoading = False
    , theme = flags.theme
    }



-- Task Model


type alias Todo =
    { id : Int
    , name : String
    , date : Int -- Date in millis
    , isRepeated : Bool
    , isLast : Bool
    , todoTemplateId : Int
    }


dummyTodo : Todo
dummyTodo =
    Todo 0 "" 0 False False 0


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
