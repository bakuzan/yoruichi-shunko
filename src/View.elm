module View exposing (view)

import Components.Calendar as Calendar
import Components.Form as Form
import Components.RadioButton as RadioButton
import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
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
        ([]
            ++ (if not model.displayForm then
                    [ RadioButton.radioGroup "calendar-modes" calendarMode calendarModeOptions
                    , div
                        []
                        [ Calendar.view calendarState calendarData
                        ]
                    ]

                else
                    [ Form.view model ]
               )
        )
