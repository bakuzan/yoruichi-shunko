module Utils.Common exposing (calendarModeToString, setRole, splitList, stringToCalendarMode)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (attribute)
import Models exposing (CalendarMode(..))


setRole : String -> Attribute msg
setRole value =
    attribute "role" value


splitList : Int -> List a -> List (List a)
splitList i list =
    case List.take i list of
        [] ->
            []

        listHead ->
            listHead :: splitList i (List.drop i list)



-- Calendar mode mapping


calendarModeToString : CalendarMode -> String
calendarModeToString mode =
    case mode of
        Day ->
            "Day"

        Week ->
            "Week"

        Month ->
            "Month"


stringToCalendarMode : String -> CalendarMode
stringToCalendarMode str =
    case str of
        "Day" ->
            Day

        "Week" ->
            Week

        "Month" ->
            Month

        _ ->
            Month
