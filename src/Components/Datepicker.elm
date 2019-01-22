module Components.Datepicker exposing (view)

import Components.Calendar as Calendar exposing (CalendarData, CalendarState)
import Components.ClearableInput as ClearableInput
import Date
import Html.Styled exposing (Html, button, div, input, label, span, text)
import Html.Styled.Attributes exposing (autocomplete, class, maxlength, name, placeholder, property, title, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Msgs exposing (Msg)
import Time exposing (Posix)
import Utils.Common as Common


view : CalendarState -> CalendarData -> List (Html.Styled.Attribute Msg) -> Html Msg
view state data attrs =
    let
        dateStr =
            Date.fromPosix state.zone data.selected |> Date.format "YYYY-MM-DD"
    in
    div [ class "yri-datepicker" ]
        [ ClearableInput.view "date" "Date" dateStr ([ type_ "date" ] ++ attrs)
        , button
            [ type_ "button"
            , class "button-icon ripple"
            , Common.setCustomAttr "icon" ""
            , onClick (Msgs.OpenDatepicker data.selected)
            ]
            []
        , if state.isOpen then
            Calendar.view state data

          else
            text ""
        ]
