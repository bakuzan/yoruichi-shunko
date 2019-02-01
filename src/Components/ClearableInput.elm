module Components.ClearableInput exposing (view)

import Html.Styled exposing (Html, button, div, input, label, span, text)
import Html.Styled.Attributes exposing (autocomplete, class, css, maxlength, name, placeholder, property, title, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Msgs exposing (Msg)
import Utils.Common as Common
import Utils.Styles as Styles


view : String -> String -> String -> List (Html.Styled.Attribute Msg) -> Html Msg
view fieldName fieldLabel fieldValue attrs =
    div [ class "has-float-label input-container clearable-input" ]
        [ input
            ([ type_ "text"
             , name fieldName
             , placeholder " "
             , maxlength 100
             , value fieldValue
             , autocomplete False
             , onInput (Msgs.UpdateTextInput fieldName)
             ]
                ++ attrs
            )
            []
        , label [] [ text fieldLabel ]
        , viewClearButton fieldName fieldValue
        , span [ class "clearable-input-count" ]
            [ text (String.fromInt (String.length fieldValue) ++ "/100")
            ]
        ]


viewClearButton : String -> String -> Html Msg
viewClearButton fieldName str =
    if String.length str == 0 then
        text ""

    else
        button
            [ type_ "button"
            , class "button-icon small clear-input"
            , title "Clear"
            , css [ Styles.icon ]
            , Common.setCustomAttr "icon" "╳"
            , Common.setCustomAttr "aria-label" ("Clear " ++ fieldName)
            , onClick (Msgs.UpdateTextInput fieldName "")
            ]
            []
