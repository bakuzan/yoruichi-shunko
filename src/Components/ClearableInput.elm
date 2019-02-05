module Components.ClearableInput exposing (view)

import Components.Button as Button
import Css exposing (..)
import Html.Styled exposing (Html, button, div, input, label, span, text)
import Html.Styled.Attributes exposing (autocomplete, class, css, maxlength, name, placeholder, property, title, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Models exposing (Theme)
import Msgs exposing (Msg)
import Utils.Common as Common
import Utils.Styles as Styles


view : Theme -> String -> String -> String -> List (Html.Styled.Attribute Msg) -> Html Msg
view theme fieldName fieldLabel fieldValue attrs =
    let
        isText =
            fieldName == "name"

        fixRightPadding =
            if isText then
                paddingRight (em 1.5)

            else
                paddingRight (px 0.5)
    in
    div
        [ class "has-float-label input-container clearable-input"
        , css (Styles.containers theme)
        ]
        [ input
            ([ type_ "text"
             , name fieldName
             , placeholder " "
             , maxlength 100
             , value fieldValue
             , autocomplete False
             , onInput (Msgs.UpdateTextInput fieldName)
             , css
                [ displayFlex
                , flex3 (int 1) (int 0) (pct 100)
                , paddingRight (em 1.5)
                , width (pct 100)
                , boxSizing borderBox
                , backgroundColor (hex theme.baseBackground)
                , color (hex theme.baseColour)
                , focus [ borderBottomColor (hex theme.colour) ]
                , fixRightPadding
                ]
             ]
                ++ attrs
            )
            []
        , label [ css [ opacity (int 0) ] ] [ text fieldLabel ]
        , viewClearButton theme fieldName fieldValue
        , if isText then
            span
                [ class "clearable-input-count"
                , css
                    [ position absolute
                    , right (px 10)
                    , bottom (px -5)
                    , top auto
                    , left auto
                    , fontSize (rem 0.5)
                    ]
                ]
                [ text
                    (String.fromInt (String.length fieldValue) ++ "/100")
                ]

          else
            text ""
        ]


viewClearButton : Theme -> String -> String -> Html Msg
viewClearButton theme fieldName str =
    if String.length str == 0 || fieldName /= "name" then
        text ""

    else
        Button.viewIcon "╳"
            { theme = theme, isPrimary = False }
            [ title "Clear"
            , Common.setCustomAttr "aria-label" ("Clear " ++ fieldName)
            , onClick (Msgs.UpdateTextInput fieldName "")
            , css
                [ position relative
                , right (px 30)
                , fontSize (rem 0.8)
                , maxHeight (px 32)
                , marginTop auto
                , marginBottom auto
                , important (backgroundColor inherit)
                ]
            ]
            []
