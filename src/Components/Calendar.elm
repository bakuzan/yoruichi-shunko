module Components.Calendar exposing (view)

import Components.Button as Button
import Css exposing (..)
import Css.Global
import Date exposing (Unit(..), add, fromPosix)
import Html.Styled exposing (Html, button, div, table, tbody, td, text, th, thead, tr, ul)
import Html.Styled.Attributes exposing (class, classList, css, disabled)
import Html.Styled.Events exposing (onClick)
import Models exposing (CalendarMode, Model, Todo, YRIDateProperty(..))
import Msgs exposing (Msg)
import Time exposing (Month(..))
import Time.Extra as Time exposing (Interval(..))
import Utils.Common as Common
import Utils.Date as YRIDate


type alias CalendarState =
    { zone : Time.Zone
    , mode : CalendarMode
    , isDatepicker : Bool
    }


type alias CalendarData =
    { today : Time.Posix
    , view : Time.Posix
    , selected : Time.Posix
    , selectedType : YRIDateProperty
    , records : List Todo
    }


view : CalendarState -> CalendarData -> Html Msg
view state data =
    div
        [ class "yri-calendar"
        , css
            [ displayFlex
            , flexDirection column
            , padding (em 0.33)
            ]
        ]
        [ viewControls state data.view
        , table
            [ class "yri-calendar__table" ]
            [ viewDayNameHeader state
            , viewCalendarBody state data
            ]
        ]


viewControls : CalendarState -> Time.Posix -> Html Msg
viewControls state viewDate =
    let
        logger =
            Debug.log "View Date" (Date.fromPosix state.zone viewDate |> Date.format "DD MMM YYYY")

        date =
            fromPosix state.zone viewDate

        offset =
            if state.mode /= Models.Week then
                1

            else
                7

        interval =
            case state.mode of
                Models.Day ->
                    Days

                Models.Week ->
                    Days

                Models.Month ->
                    Months

        nextDate =
            Date.add interval offset date
                |> YRIDate.dateToPosix state.zone

        prevDate =
            Date.add interval -offset date
                |> YRIDate.dateToPosix state.zone
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


viewDayNameHeader : CalendarState -> Html Msg
viewDayNameHeader state =
    let
        from =
            Date.fromCalendarDate 2019 Jan 7

        until =
            Date.fromCalendarDate 2019 Jan 14

        cssForTh =
            if state.isDatepicker then
                []

            else
                [ textAlign left ]

        viewHeaderCell day =
            th [ css cssForTh ]
                [ text (Date.format "EE" day)
                ]
    in
    thead []
        [ tr []
            ([] ++ List.map viewHeaderCell (Date.range Date.Day 1 from until))
        ]


viewCalendarBody : CalendarState -> CalendarData -> Html Msg
viewCalendarBody state data =
    let
        date =
            Date.fromPosix state.zone data.view

        days =
            getMonthDays state.zone date

        squaresInRows =
            Common.splitList 7 days

        logger =
            Debug.log "Week/Month" squaresInRows
    in
    tbody []
        ([]
            ++ List.map (viewCalendarWeek state data) squaresInRows
        )


viewCalendarWeek : CalendarState -> CalendarData -> List Int -> Html Msg
viewCalendarWeek state data squares =
    let
        len =
            List.length squares

        squaresWithDummies =
            squares ++ populateArrayForDummies (7 - len)

        isWeekView =
            state.mode == Models.Week

        isActive =
            List.any
                (\x ->
                    if state.isDatepicker then
                        False

                    else
                        x == YRIDate.getDayBeginningInMillis state.zone data.view
                )
                squares
    in
    if not isWeekView || isActive then
        tr
            [ class "yri-calendar__week yri-week"
            , classList [ ( "yri-week--active", isActive ) ]
            ]
            ([]
                ++ List.map (viewDay state data) squaresWithDummies
            )

    else
        text ""


viewDay : CalendarState -> CalendarData -> Int -> Html Msg
viewDay state data millis =
    let
        isDummy =
            millis == 0

        isToday =
            millis == YRIDate.getDayBeginningInMillis state.zone data.today

        isSelected =
            state.isDatepicker
                && millis
                == YRIDate.getDayBeginningInMillis state.zone data.selected

        asPosix =
            Time.millisToPosix millis

        cssForTd =
            if state.isDatepicker then
                [ textAlign center, verticalAlign middle ]

            else
                [ width (em 3), height (em 3) ]

        dayPadding =
            padding2 (px 0) (em 0.66)

        numDisplay =
            [ text
                (if not isDummy then
                    String.fromInt (Date.fromPosix state.zone asPosix |> Date.day)

                 else
                    ""
                )
            ]
    in
    td
        [ css
            (cssForTd
                ++ [ border3 (px 1) solid transparent
                   , hover
                        [ Css.Global.descendants
                            [ Css.Global.class "button-link" [ visibility visible ]
                            ]
                        ]
                   ]
            )
        , class "yri-week__day yri-day"
        , classList
            [ ( "yri-day--dummy", isDummy )
            , ( "yri-day--active", isSelected )
            , ( "yri-day--is-today", isToday )
            ]
        ]
        [ if not state.isDatepicker then
            div [ css [ dayPadding ] ] numDisplay

          else
            Button.view
                [ css [ dayPadding ]
                , disabled isDummy
                , onClick (Msgs.UpdateDate data.selectedType asPosix)
                ]
                numDisplay
        , if not state.isDatepicker && not isDummy then
            div
                [ class "yri-day__content"
                , css
                    [ dayPadding
                    , paddingBottom (em 0.66)
                    ]
                ]
                [ ul [ class "list column one" ] []
                , div
                    [ css
                        [ displayFlex
                        , justifyContent flexEnd
                        ]
                    ]
                    [ Button.viewLink
                        [ css [ visibility hidden ]
                        , onClick (Msgs.DisplayTodoForm asPosix)
                        ]
                        [ text "Add" ]
                    ]
                ]

          else
            text ""
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

        start =
            Time.Parts (Date.year date) (Date.month date) 1 0 0 0 0
                |> Time.partsToPosix zone

        until =
            Time.Parts (Date.year date) (Date.month date) monthLength 0 0 0 0
                |> Time.partsToPosix zone

        daysInMillis =
            Time.range Day 1 zone start until
                |> (\l -> l ++ [ until ])
                |> List.map Time.posixToMillis

        squares =
            dummyDays ++ daysInMillis
    in
    squares


populateArrayForDummies : Int -> List Int
populateArrayForDummies len =
    if len == 0 then
        []

    else
        List.map (\x -> 0) (List.range 1 len)
