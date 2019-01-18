module Components.Calendar exposing (view)

import Components.Button as Button
import Css exposing (..)
import Date exposing (Unit(..), add, fromPosix)
import Html.Styled exposing (Html, button, div, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (class, classList, css)
import Html.Styled.Events exposing (onClick)
import Models exposing (Model, YRIDateProperty(..))
import Msgs exposing (Msg)
import Time exposing (Month(..))
import Utils.Common as Common
import Utils.Date as YRIDate


view : String -> Time.Zone -> Time.Posix -> Time.Posix -> Html Msg
view mode zone viewDate selectedDate =
    div
        [ class "yri-calendar"
        , css
            [ displayFlex
            , flexDirection column
            , padding (em 0.33)
            ]
        ]
        [ viewControls zone viewDate
        , table
            [ class "yri-calendar__table" ]
            [ viewDayNameHeader
            , viewCalendarBody zone viewDate selectedDate
            ]
        ]


viewControls : Time.Zone -> Time.Posix -> Html Msg
viewControls zone viewDate =
    let
        date =
            fromPosix zone viewDate

        nextDate =
            Date.add Months 1 date
                |> YRIDate.dateToPosix zone

        prevDate =
            Date.add Months -1 date
                |> YRIDate.dateToPosix zone
    in
    div
        [ class "yri-calendar__controls"
        , css
            [ displayFlex
            , justifyContent spaceAround
            , padding (em 0.33)
            ]
        ]
        [ Button.view
            [ onClick (Msgs.UpdateDate CalendarViewDate prevDate)
            ]
            [ text "prev" ]
        , div
            [ class "yri-calendar__month-text" ]
            [ text (Date.format "MMM YYYY" date) ]
        , Button.view
            [ onClick (Msgs.UpdateDate CalendarViewDate nextDate)
            ]
            [ text "next" ]
        ]


viewDayNameHeader : Html Msg
viewDayNameHeader =
    let
        from =
            Date.fromCalendarDate 2019 Jan 7

        until =
            Date.fromCalendarDate 2019 Jan 14

        viewHeaderCell day =
            th []
                [ text (Date.format "EE" day)
                ]
    in
    thead []
        [ tr []
            ([] ++ List.map viewHeaderCell (Date.range Date.Day 1 from until))
        ]


viewCalendarBody : Time.Zone -> Time.Posix -> Time.Posix -> Html Msg
viewCalendarBody zone viewDate selectedDate =
    let
        date =
            Date.fromPosix zone viewDate

        days =
            getMonthDays zone date

        squaresInRows =
            Common.splitList 7 days
    in
    tbody []
        ([]
            ++ List.map viewCalendarWeek squaresInRows
        )


viewCalendarWeek : List Int -> Html Msg
viewCalendarWeek squares =
    let
        len =
            List.length squares

        squaresWithDummies =
            squares ++ populateArrayForDummies (7 - len)
    in
    tr
        [ class "yri-calendar__week yri-week"
        , classList [ ( "yri-week--active", False ) ]
        ]
        ([]
            ++ List.map viewDay squaresWithDummies
        )


viewDay : Int -> Html Msg
viewDay num =
    let
        isDummy =
            num == 0
    in
    td
        [ css
            [ width (em 3)
            , height (em 3)
            , textAlign center
            , verticalAlign middle
            ]
        , class "yri-week__day yri-day"
        , classList
            [ ( "yri-day--dummy", isDummy )
            , ( "yri-day--active", False )
            , ( "yri-day--is-today", False )
            ]
        ]
        [ text
            (if not isDummy then
                String.fromInt num

             else
                ""
            )
        ]



-- Helper functions


getMonthDays : Time.Zone -> Date.Date -> List Int
getMonthDays zone date =
    let
        monthLength =
            YRIDate.getMonthLength zone date

        startingWeekdayNum =
            YRIDate.getMonthStartWeekDayNumber zone date

        dummyDays =
            populateArrayForDummies (startingWeekdayNum - 1)

        squares =
            dummyDays ++ List.range 1 monthLength

        logger =
            Debug.log "Dumb" dummyDays
    in
    squares


populateArrayForDummies : Int -> List Int
populateArrayForDummies len =
    if len == 0 then
        []

    else
        List.map (\x -> 0) (List.range 1 len)
