module Utils.Date exposing (dateToMillis, dateToPosix, getDayBeginningInMillis, getFirstOfMonth, getMonday, getMonthLength, getMonthStartWeekDayNumber, getSunday, getWeekForPosix)

import Date exposing (Unit(..))
import Time exposing (Posix, Zone)
import Time.Extra as Time exposing (Interval(..))


dateToPosix : Zone -> Date.Date -> Posix
dateToPosix zone d =
    Time.Parts (Date.year d) (Date.month d) (Date.day d) 0 0 0 0 |> Time.partsToPosix zone


dateToMillis : Zone -> Date.Date -> Int
dateToMillis zone d =
    dateToPosix zone d
        |> Time.posixToMillis


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


getDayBeginningInMillis : Zone -> Time.Posix -> Int
getDayBeginningInMillis zone posix =
    Time.floor Day zone posix
        |> Time.posixToMillis


getMonday : Zone -> Time.Posix -> Time.Posix
getMonday zone posix =
    Time.floor Monday zone posix


getSunday : Zone -> Time.Posix -> Time.Posix
getSunday zone posix =
    Time.ceiling Sunday zone posix


getWeekForPosix : Zone -> Time.Posix -> List Int
getWeekForPosix zone posix =
    let
        start =
            getMonday zone posix

        until =
            getSunday zone posix
    in
    List.map Time.posixToMillis (Time.range Day 1 zone start until ++ [ until ])
