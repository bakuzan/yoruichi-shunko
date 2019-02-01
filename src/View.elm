module View exposing (view)

import Components.Button as Button
import Components.Calendar as Calendar
import Components.Form as Form
import Components.RadioButton as RadioButton
import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, title)
import Html.Styled.Events exposing (onClick)
import Models exposing (Model, YRIDateProperty(..))
import Msgs exposing (Msg)
import Utils.Common as Common
import Utils.Constants exposing (calendarModeOptions)


view : Model -> Html Msg
view model =
    let
        calendarState =
            { zone = model.zone
            , mode = model.calendarMode
            , isDatepicker = False
            , isOpen = False
            , contextMenuActiveFor = model.contextMenuActiveFor
            }

        calendarData =
            { today = model.today
            , view = model.calendarViewDate
            , selected = model.calendarViewDate
            , selectedType = Ignored
            , records = model.todos
            }

        calendarMode =
            Common.calendarModeToString model.calendarMode
    in
    div
        [ css
            [ displayFlex
            , flexDirection column
            , minHeight (calc (vh 100) minus (px 50))
            ]
        ]
        ([ if model.errorMessage == "" then
            text ""

           else
            div
                [ class "yri-error"
                , css
                    [ position fixed
                    , top (px 60)
                    , left (pct 50)
                    , transform (translateX (pct -50))
                    ]
                ]
                [ text model.errorMessage ]
         ]
            ++ (if not model.displayForm then
                    [ div
                        [ css
                            [ displayFlex
                            , padding2 (px 5) (px 10)
                            ]
                        ]
                        [ RadioButton.radioGroup "calendar-modes" calendarMode calendarModeOptions
                        , div [ css [ padding2 (px 0) (px 10) ] ]
                            [ Button.view
                                [ Common.setCustomAttr "aria-label" "Jump to today"
                                , title "Jump to today"
                                , onClick (Msgs.UpdateCalendarViewDate False model.today)
                                ]
                                [ text "Today" ]
                            ]
                        ]
                    , div
                        []
                        [ Calendar.view calendarState calendarData
                        ]
                    ]

                else
                    [ Form.view model ]
               )
        )
