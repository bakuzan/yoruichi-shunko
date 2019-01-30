module Components.Calendar exposing (CalendarData, CalendarState, view)

import Components.Button as Button
import Css exposing (..)
import Css.Global
import Date exposing (Unit(..), add, fromPosix)
import Html.Styled exposing (Html, button, div, li, table, tbody, td, text, th, thead, tr, ul)
import Html.Styled.Attributes exposing (class, classList, css, disabled, id)
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
    , isOpen : Bool
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
    let
        datepickerCss =
            if not state.isDatepicker then
                [ width (pct 100) ]

            else
                [ position absolute
                , bottom (px 0)
                , left (px 0)
                , transform (translateY (pct 100))
                ]

        tableStyle =
            [ tableLayout fixed
            , width (pct 100)
            ]
    in
    div
        [ class "yri-calendar"
        , css
            ([ displayFlex
             , flexDirection column
             , padding (px 5)
             , zIndex (int 25)
             , boxSizing borderBox
             ]
                ++ datepickerCss
            )
        ]
        [ viewControls state data.view
        , if state.isDatepicker || state.mode /= Models.Day then
            table
                [ class "yri-calendar__table", css tableStyle ]
                [ viewDayNameHeader state
                , viewCalendarBody state data
                ]

          else
            table
                [ class "yri-calendar__table", css tableStyle ]
                [ thead []
                    [ tr []
                        [ th []
                            [ text (Date.format "EEEE" (Date.fromPosix state.zone data.view))
                            ]
                        ]
                    ]
                , tbody []
                    [ tr []
                        [ viewDay state data (Time.posixToMillis data.view)
                        ]
                    ]
                ]
        ]


viewControls : CalendarState -> Time.Posix -> Html Msg
viewControls state viewDate =
    let
        logger =
            Debug.log "View Date" (Date.fromPosix state.zone viewDate |> Date.format "dd MMM YYYY")

        startOfWeek =
            YRIDate.getMonday state.zone viewDate

        endOfWeek =
            YRIDate.getSunday state.zone viewDate

        dateFormat =
            if not state.isDatepicker && state.mode /= Models.Month then
                "dd MMM YYYY"

            else
                "MMM YYYY"

        displayDate =
            if not state.isDatepicker && state.mode == Models.Week then
                Date.format dateFormat (Date.fromPosix state.zone startOfWeek)
                    ++ " - "
                    ++ Date.format dateFormat (Date.fromPosix state.zone endOfWeek)

            else
                Date.format dateFormat (Date.fromPosix state.zone viewDate)

        ( prevDate, nextDate ) =
            getNextPrevDates state viewDate

        btnCss =
            [ padding2 (px 2) (px 16)
            , before
                [ property "content" "attr(icon)"
                ]
            ]
    in
    div
        [ class "yri-calendar__controls"
        , css
            [ displayFlex
            , justifyContent spaceBetween
            , alignItems center
            , padding (px 5)
            ]
        ]
        [ Button.view
            [ css btnCss
            , class "yri-calendar__shift-button button-icon"
            , Common.setCustomAttr "aria-label" "Previous"
            , Common.setCustomAttr "icon" "‹"
            , onClick (Msgs.UpdateCalendarViewDate state.isDatepicker prevDate)
            ]
            []
        , div
            [ class "yri-calendar__month-text" ]
            [ text displayDate ]
        , Button.view
            [ css btnCss
            , class "yri-calendar__shift-button"
            , Common.setCustomAttr "aria-label" "Next"
            , Common.setCustomAttr "icon" "›"
            , onClick (Msgs.UpdateCalendarViewDate state.isDatepicker nextDate)
            ]
            []
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
            th [ css ([ padding2 (px 0) (px 5) ] ++ cssForTh) ]
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

        aDateInTheWeek =
            List.filter (\x -> x /= 0) squares
                |> List.head
                |> Maybe.withDefault 0
                |> Time.millisToPosix

        fullWeekOfSquares =
            if not state.isDatepicker && isWeekView then
                YRIDate.getWeekForPosix state.zone aDateInTheWeek

            else
                squares ++ populateArrayForDummies (7 - len)
    in
    if not isWeekView || state.isDatepicker || isActive then
        tr
            [ class "yri-calendar__week yri-week"
            , classList [ ( "yri-week--active", isActive ) ]
            ]
            ([]
                ++ List.map (viewDay state data) fullWeekOfSquares
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

        asDate =
            Date.fromPosix state.zone asPosix

        cssForTd =
            if state.isDatepicker then
                [ textAlign center, verticalAlign middle ]

            else
                [ position relative, verticalAlign baseline ]

        dayPadding =
            padding2 (px 10) (px 5)

        showMonth =
            not state.isDatepicker && state.mode == Models.Week

        numDisplay =
            [ text
                (if not isDummy then
                    if showMonth then
                        Date.format "dd MMM" asDate

                    else
                        String.fromInt (asDate |> Date.day)

                 else
                    " "
                )
            ]

        todosForToday =
            List.filter (\t -> t.date == millis) data.records
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
        , id (String.fromInt millis)
        , class "yri-week__day yri-day"
        , classList
            [ ( "yri-day--dummy", isDummy )
            , ( "yri-day--active", isSelected )
            , ( "yri-day--is-today", isToday )
            ]
        ]
        [ if state.mode == Models.Day then
            text ""

          else if not state.isDatepicker then
            div
                [ css
                    [ dayPadding
                    ]
                ]
                numDisplay

          else
            Button.view
                [ css
                    [ dayPadding
                    , width (pct 100)
                    , height (pct 100)
                    ]
                , disabled isDummy
                , onClick (Msgs.UpdateDate data.selectedType asPosix)
                ]
                numDisplay
        , if not state.isDatepicker && not isDummy then
            div
                [ class "yri-day__content"
                , css
                    [ dayPadding
                    , paddingBottom (px 5)
                    ]
                ]
                [ ul
                    [ class "list column one"
                    , css
                        [ listStyleType none
                        , padding (px 5)
                        , paddingBottom (px 25)
                        , margin2 (px 8) (px 0)
                        ]
                    ]
                    ([] ++ List.map viewTodo todosForToday)
                , div
                    [ css
                        [ displayFlex
                        , justifyContent flexEnd
                        , position absolute
                        , bottom (px 0)
                        , left (px 0)
                        , right (px 0)
                        , padding (px 2)
                        ]
                    ]
                    [ Button.viewLink
                        [ css
                            [ visibility hidden
                            ]
                        , onClick (Msgs.DisplayTodoForm asPosix)
                        ]
                        [ text "Add" ]
                    ]
                ]

          else
            text ""
        ]


viewTodo : Todo -> Html Msg
viewTodo todo =
    li [ class "list__item todo", css [ padding2 (px 5) (px 0) ] ]
        [ div [] [ text todo.name ]
        , div [] []
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


getNextPrevDates : CalendarState -> Time.Posix -> ( Time.Posix, Time.Posix )
getNextPrevDates state viewDate =
    let
        offset =
            if state.isDatepicker || state.mode /= Models.Week then
                1

            else
                7

        interval =
            if state.isDatepicker then
                Months

            else
                case state.mode of
                    Models.Day ->
                        Days

                    Models.Week ->
                        Days

                    Models.Month ->
                        Months

        date =
            Date.fromPosix state.zone viewDate

        nextDate =
            Date.add interval offset date
                |> YRIDate.dateToPosix state.zone

        prevDate =
            Date.add interval -offset date
                |> YRIDate.dateToPosix state.zone
    in
    ( prevDate, nextDate )
