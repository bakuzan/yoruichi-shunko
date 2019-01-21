module Utils.Constants exposing (calendarModeOptions)

import Components.RadioButton exposing (RadioOption)
import Msgs


calendarModeOptions : List RadioOption
calendarModeOptions =
    [ { label = "Day"
      , optionValue = "Day"
      , action = Msgs.UpdateCalendarMode "Day"
      , disabled = False
      }
    , { label = "Week"
      , optionValue = "Week"
      , action = Msgs.UpdateCalendarMode "Week"
      , disabled = False
      }
    , { label = "Month"
      , optionValue = "Month"
      , action = Msgs.UpdateCalendarMode "Month"
      , disabled = False
      }
    ]
