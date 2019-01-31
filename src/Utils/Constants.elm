module Utils.Constants exposing (calendarModeOptions, closeKeys, repeatPatternOptions)

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


repeatPatternOptions : List ( String, String )
repeatPatternOptions =
    [ ( "None", "None" )
    , ( "Daily", "Daily" )
    , ( "Weekly", "Weekly" )
    , ( "Monthly", "Monthly" )
    , ( "Quarterly", "Quarterly" )
    , ( "Yearly", "Yearly" )
    ]



-- Key Codes


enterKey : Int
enterKey =
    13


escapeKey : Int
escapeKey =
    27


spaceKey : Int
spaceKey =
    32


closeKeys : List Int
closeKeys =
    [ enterKey
    , escapeKey
    , spaceKey
    ]
