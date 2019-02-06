module View exposing (view)

import Components.Button as Button
import Components.Calendar as Calendar
import Components.DeleteConfirmation as DeleteConfirmation
import Components.Form as Form
import Components.Loader as Loader
import Components.RadioButton as RadioButton
import Css exposing (..)
import Html
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (class, css, title)
import Html.Styled.Events exposing (onClick)
import Models exposing (Model, Theme, YRIDateProperty(..))
import Msgs exposing (Msg)
import Utils.Common as Common
import Utils.Constants exposing (calendarModeOptions)
import Utils.Styles as Styles


view : Model -> Html Msg
view model =
    let
        calendarState =
            { zone = model.zone
            , mode = model.calendarMode
            , isDatepicker = False
            , isOpen = False
            , contextMenuActiveFor = model.contextMenuActiveFor
            , theme = model.theme
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
            [ position relative
            , displayFlex
            , flexDirection column
            , minHeight (calc (vh 100) minus (px 50))
            ]
        ]
        ([ viewError model.theme model.errorMessage
         , Loader.view model.theme model.isLoading
         ]
            ++ (if not model.displayForm && model.deleteActiveFor == 0 then
                    [ div
                        [ css
                            [ displayFlex
                            , padding2 (px 5) (px 10)
                            , alignItems center
                            ]
                        ]
                        [ RadioButton.radioGroup model.theme "calendar-modes" calendarMode calendarModeOptions
                        , div [ css [ padding2 (px 0) (px 10) ] ]
                            [ Button.view { theme = model.theme, isPrimary = True }
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

                else if model.deleteActiveFor /= 0 then
                    [ DeleteConfirmation.view model.theme ]

                else
                    [ Form.view model ]
               )
        )


viewError : Theme -> String -> Html Msg
viewError theme errorMessage =
    if errorMessage == "" then
        text ""

    else
        div
            [ class "yri-error"
            , css
                [ displayFlex
                , position fixed
                , top (px 60)
                , left (pct 50)
                , minWidth (pct 50)
                , height (px 40)
                , transform (translateX (pct -50))
                , zIndex (int 1000)
                , backgroundColor (hex theme.baseBackground)
                , color (hex theme.baseColour)
                , boxShadow4 (px 1) (px 1) (px 10) (px 1)
                ]
            ]
            [ div
                [ css
                    [ displayFlex
                    , justifyContent center
                    , alignItems center
                    , width (px 40)
                    , Styles.icon
                    , backgroundColor (hex "ff0000")
                    , color (hex "ffffff")
                    , fontWeight bold
                    ]
                , Common.setCustomAttr "icon" "!"
                ]
                []
            , div
                [ css
                    [ displayFlex
                    , alignItems center
                    , flex (int 1)
                    , padding2 (px 5) (px 10)
                    ]
                ]
                [ text errorMessage ]
            , Button.viewIcon "╳"
                { theme = theme, isPrimary = False }
                [ onClick Msgs.ClearError
                ]
                []
            ]
