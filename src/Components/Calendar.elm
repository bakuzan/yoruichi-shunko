module Components.Calendar exposing (view)

import Html.Styled exposing (Html, button, div, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (class, classList)
import Html.Styled.Events exposing (onClick)
import Models exposing (Model, YRIDateProperty)
import Msgs exposing (Msg)
import Time
import Date exposing (Unit(..), add, fromPosix)
import Utils.Date as YRIDate


view : String -> Time.Zone -> Time.Posix -> Time.Posix -> Html Msg
view mode zone viewDate selectedDate =
    div [ class "calendar" ]
        [ viewControls zone viewDate
        , viewCalendar zone viewDate selectedDate
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
    div [ class "calendar__controls" ]
        [ button 
            [ class "button ripple", onClick (Msgs.UpdateDate Models.CalendarViewDate prevDate) ] 
            [ text "prev" ]
        , div 
            [ class "calendar__month-text" ]
            [ text (Date.format "MMM YYYY" date)
            ]
        , button 
            [ class "button ripple", onClick (Msgs.UpdateDate Models.CalendarViewDate nextDate) ] 
            [ text "next" ]
        ]


viewCalendar : Time.Zone -> Time.Posix -> Time.Posix -> Html Msg
viewCalendar zone viewDate selectedDate =
    div 
    [] 
    [ text "calendar body placeholder" ]
