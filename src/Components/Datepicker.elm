module Components.Datepicker exposing (view)

import Components.Button as Button
import Components.Calendar as Calendar exposing (CalendarData, CalendarState)
import Components.ClearableInput as ClearableInput
import Css exposing (..)
import Css.Global exposing (children, typeSelector)
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

        hidePseudos =
            [ display none
            , Styles.appearance "none"
            ]
    in
    div
        [ class "yri-datepicker"
        , css
            [ position relative
            , displayFlex
            , alignItems center
            , children
                [ typeSelector ".input-container"
                    [ flex3 (int 1) (int 0) (pct 100)
                    , maxWidth (calc (pct 100) minus (px 10))
                    ]
                ]
            ]
        ]
        ([ ClearableInput.view state.theme
            "date"
            "Date"
            dateStr
            ([ type_ "date"
             , css
                [ paddingRight (px 35)
                , pseudoElement "-webkit-calendar-picker-indicator" hidePseudos
                , pseudoElement "-webkit-inner-spin-button" hidePseudos
                , pseudoElement "-webkit-clear-button" hidePseudos
                ]
             ]
                ++ attrs
            )
         , Button.viewIcon
            "\u{D83D}\u{DCC5}"
            { theme = state.theme, isPrimary = False }
            [ css
                [ position relative
                , right (px 40)
                , fontSize (rem 0.8)
                , maxHeight (px 32)
                ]
            , Common.setCustomAttr "aria-label" "Open Datepicker"
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
