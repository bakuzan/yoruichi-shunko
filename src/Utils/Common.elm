module Utils.Common exposing (calendarModeToString, repeatForMax, setCustomAttr, setRole, splitList, stringToCalendarMode)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (attribute)
import Models exposing (CalendarMode(..))


setCustomAttr : String -> String -> Attribute msg
setCustomAttr attr val =
    attribute attr val


setRole : String -> Attribute msg
setRole value =
    setCustomAttr "role" value


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



-- Repeat mapping


repeatForMax : String -> Int
repeatForMax pattern =
    case pattern of
        "Daily" ->
            28

        "Weekly" ->
            52

        "Monthly" ->
            12

        "Quarterly" ->
            8

        "Yearly" ->
            4

        _ ->
            0
