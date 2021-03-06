module Components.Form exposing (view)

import Components.Button as Button
import Components.Checkbox as Checkbox
import Components.ClearableInput as Input
import Components.Datepicker as Datepicker
import Components.RadioButton as RadioButton
import Components.SelectBox as SelectBox
import Css exposing (..)
import Css.Global exposing (children, typeSelector)
import Date
import Html.Styled exposing (Html, div, form, text)
import Html.Styled.Attributes as Attr exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Models exposing (Model, Theme, TodoTemplateForm)
import Msgs exposing (Msg)
import Time as T
import Time.Extra as Time
import Utils.Common as Common
import Utils.Constants exposing (repeatPatternOptions)


view : Model -> Html.Styled.Html Msg
view model =
    let
        values =
            model.todoForm

        isCreate =
            values.id == 0

        date =
            Date.fromPosix model.zone values.date

        dateStr =
            Date.toIsoString date

        dpState =
            { zone = model.zone
            , mode = model.calendarMode
            , isDatepicker = True
            , isOpen = model.displayDatepicker
            , contextMenuActiveFor = 0
            , theme = model.theme
            }

        dpData =
            { today = model.today
            , view = model.calendarViewDate
            , selected = values.date
            , selectedType = Models.FormDate
            , records = []
            }
    in
    Html.Styled.form
        [ class "yri-form"
        , name "todo-form"
        , novalidate True
        , autocomplete False
        , onSubmit Msgs.SubmitTodoForm
        ]
        [ div
            [ class "yri-form__content"
            , css
                [ padding (em 0.33)
                , maxWidth (px 400)
                ]
            ]
            (([ Input.view model.theme "name" "Name" values.name []
              , Datepicker.view dpState dpData [ onInput (Msgs.UpdateDateInput Models.FormDate) ]
              , if isCreate then
                    text ""

                else
                    Checkbox.view model.theme
                        "Apply to this entry only"
                        model.isInstanceForm
                        [ onClick Msgs.ToggleInstanceForm
                        ]
              ]
                ++ (if isCreate || not model.isInstanceForm then
                        templateFields model.theme date values

                    else
                        []
                   )
             )
                ++ formButtons model.theme
            )
        ]


templateFields : Theme -> Date.Date -> TodoTemplateForm -> List (Html.Styled.Html Msg)
templateFields theme date values =
    [ SelectBox.view theme repeatPatternOptions "repeatPattern" "Repeat Frequency" values.repeatPattern
    , if values.repeatPattern /= "None" then
        div []
            [ Input.view theme
                "repeatFor"
                "For"
                (String.fromInt values.repeatFor)
                [ type_ "number"
                , Attr.min "1"
                , Attr.max (Common.repeatForMax values.repeatPattern |> String.fromInt)
                ]
            , if values.repeatPattern == "Weekly" then
                Input.view theme
                    "repeatWeekDefinition"
                    "Every X Weeks"
                    (String.fromInt values.repeatWeekDefinition)
                    [ type_ "number"
                    , Attr.min "1"
                    , Attr.max "52"
                    ]

              else
                text ""
            ]

      else
        text ""
    , div [ css [ padding (em 0.33), margin2 (px 10) (px 0) ] ] [ text (repeatExplanation values date) ]
    ]


formButtons : Theme -> List (Html.Styled.Html Msg)
formButtons theme =
    [ div
        [ css
            [ displayFlex
            , justifyContent center
            , children [ typeSelector "button" [ margin2 (px 0) (px 5) ] ]
            ]
        ]
        [ Button.view { theme = theme, isPrimary = True }
            [ type_ "submit" ]
            [ text "Save" ]
        , Button.viewLink theme
            [ onClick Msgs.CancelTodoForm ]
            [ text "Cancel" ]
        ]
    ]



-- helpers


repeatExplanation : TodoTemplateForm -> Date.Date -> String
repeatExplanation data date =
    let
        weekday =
            Date.format "EEEE" date

        month =
            Date.month date

        day =
            Date.format "ddd" date

        repeatFor =
            String.fromInt data.repeatFor

        weekRepitition =
            String.fromInt data.repeatWeekDefinition
    in
    case data.repeatPattern of
        "None" ->
            "This todo will not repeat."

        "Daily" ->
            "This todo will repeat everyday for "
                ++ repeatFor
                ++ " days."

        "Weekly" ->
            "This todo will repeat every "
                ++ (if weekRepitition == "1" then
                        " week "

                    else
                        weekRepitition
                            ++ " weeks "
                   )
                ++ " on "
                ++ weekday
                ++ " for "
                ++ repeatFor
                ++ " occurences."

        "Monthly" ->
            "This todo will repeat on the "
                ++ day
                ++ " every month for "
                ++ repeatFor
                ++ " months."

        "Quarterly" ->
            "This todo will repeat every quarter (13 weeks) for "
                ++ repeatFor
                ++ " quarters."

        "Yearly" ->
            "This todo will repeat every year on this day for "
                ++ repeatFor
                ++ " years."

        _ ->
            "Invalid Repeat Frequency"
