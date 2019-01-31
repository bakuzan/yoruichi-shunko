module Components.Datepicker exposing (view)

import Components.Button as Button
import Components.Calendar as Calendar exposing (CalendarData, CalendarState)
import Components.ClearableInput as ClearableInput
import Css exposing (..)
import Date
import Html.Styled exposing (Html, button, div, input, label, span, text)
import Html.Styled.Attributes exposing (autocomplete, class, css, maxlength, name, placeholder, property, tabindex, title, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Json.Decode as Json
import Msgs exposing (Msg)
import Time exposing (Posix)
import Utils.Common as Common
import Utils.Constants as Constants
import Utils.Styles as Styles


view : CalendarState -> CalendarData -> List (Html.Styled.Attribute Msg) -> Html Msg
view state data attrs =
    let
        dateStr =
            Date.fromPosix state.zone data.selected |> Date.format "YYYY-MM-dd"
    in
    div [ class "yri-datepicker", css [ position relative ] ]
        ([ ClearableInput.view "date" "Date" dateStr ([ type_ "date" ] ++ attrs)
         , Button.view
            [ css [ Styles.icon ]
            , class "button-icon"
            , Common.setCustomAttr "aria-label" "Open Datepicker"
            , Common.setCustomAttr "icon" "\u{D83D}\u{DCC5}"
            , onClick (Msgs.OpenDatepicker data.selected)
            ]
            []
         ]
            ++ (if state.isOpen then
                    [ Calendar.view state data
                    , div
                        [ css
                            [ position fixed
                            , top (px 0)
                            , bottom (px 0)
                            , left (px 0)
                            , right (px 0)
                            , zIndex (int 10)
                            ]
                        , Common.setRole "button"
                        , tabindex 0
                        , onClick Msgs.CloseDatepicker
                        , Common.onKeyDown Constants.closeKeys Msgs.CloseDatepicker
                        ]
                        []
                    ]

                else
                    [ text "" ]
               )
        )
