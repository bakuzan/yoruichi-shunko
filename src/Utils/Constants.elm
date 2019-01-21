module Utils.Constants exposing (calendarModeOptions)

import Components.RadioButton exposing (RadioOption)
import Msgs


calendarModeOptions : List RadioOption
calendarModeOptions =
    [ { label = "Day"
      , optionValue = "Day"
      , action = Msgs.UpdateCalendarMode "DAY"
      , disabled = False
      }
    , { label = "Week"
      , optionValue = "Week"
      , action = Msgs.UpdateCalendarMode "WEEK"
      , disabled = False
      }
    , { label = "Month"
      , optionValue = "Month"
      , action = Msgs.UpdateCalendarMode "MONTH"
      , disabled = False
      }
    ]
