module Utils.Date exposing (dateToPosix, getFirstOfMonth, getMonthLength, getMonthStartWeekDayNumber)

import Date exposing (Unit(..))
import Time exposing (Posix, Zone)
import Time.Extra as Time exposing (Interval(..))


dateToPosix : Zone -> Date.Date -> Posix
dateToPosix zone d =
    Time.Parts (Date.year d) (Date.month d) (Date.day d) 0 0 0 0 |> Time.partsToPosix zone


getMonthLength : Zone -> Date.Date -> Int
getMonthLength zone date =
    let
        d =
            getFirstOfMonth zone date

        nd =
            Date.add Months 1 d
    in
    Time.diff Day
        zone
        (Time.partsToPosix zone (Time.Parts (Date.year d) (Date.month d) (Date.day d) 0 0 0 0))
        (Time.partsToPosix zone (Time.Parts (Date.year nd) (Date.month nd) (Date.day nd) 0 0 0 0))


getMonthStartWeekDayNumber : Zone -> Date.Date -> Int
getMonthStartWeekDayNumber zone date =
    getFirstOfMonth zone date
        |> Date.weekdayNumber


getFirstOfMonth : Zone -> Date.Date -> Date.Date
getFirstOfMonth zone date =
    Time.Parts (Date.year date) (Date.month date) 1 0 0 0 0
        |> Time.partsToPosix zone
        |> Date.fromPosix zone
