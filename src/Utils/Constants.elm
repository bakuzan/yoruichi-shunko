module Utils.Constants exposing (..)

import Msgs

import Components.RadioButton exposing (RadioOption)

calendarModeOptions : List RadioOption
calendarModeOptions =
  [ 
    { 
      label = "Day", 
      optionValue = "DAY", 
      action = Msgs.UpdateCalendarMode "DAY", 
      disabled = False 
    }
  , { 
      label = "Week", 
      optionValue = "WEEK",
      action = Msgs.UpdateCalendarMode "WEEK", 
      disabled = False 
    }
  , { 
      label = "Month", 
      optionValue = "MONTH",
      action = Msgs.UpdateCalendarMode "MONTH", 
      disabled = False 
    }
  ]