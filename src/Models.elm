module Models exposing (..)

import Time


type alias Model =
    { calendarMode : String
    , today : Time.Posix
    , zone : Time.Zone
    , calendarViewDate : Time.Posix
    }


initialModel : Model
initialModel =
    { calendarMode = "WEEK"
    , today = Time.millisToPosix 0
    , zone = Time.utc
    , calendarViewDate = Time.millisToPosix 0
    }

type YRIDateProperty
  = Today
  | CalendarViewDate