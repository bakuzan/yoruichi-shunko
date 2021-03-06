module Components.SelectBox exposing (view)

import Css exposing (..)
import Html.Styled exposing (Html, div, label, option, select, text)
import Html.Styled.Attributes exposing (class, css, name, value)
import Html.Styled.Events exposing (onInput)
import Models exposing (Theme)
import Msgs exposing (Msg)
import Utils.Styles as Styles


view : Theme -> List ( String, String ) -> String -> String -> String -> Html Msg
view theme options fieldName fieldLabel fieldValue =
    div
        [ class "yri-select-container"
        , css
            (Styles.containers theme
                ++ [ after
                        [ Styles.content "⌵"
                        , position absolute
                        , top (pct 50)
                        , right (px 5)
                        , transform (translateY (pct -50))
                        , fontWeight bold
                        , pointerEvents none
                        ]
                   ]
            )
        ]
        [ select
            [ class "yri-select-box"
            , name fieldName
            , value fieldValue
            , onInput (Msgs.UpdateSelectBox fieldName)
            , css
                [ width (pct 100)
                , backgroundColor (hex theme.baseBackground)
                , color (hex theme.baseColour)
                , focus [ borderBottomColor (hex theme.colour) ]
                ]
            ]
            ([]
                ++ List.map viewOption options
            )
        , label []
            [ text fieldLabel
            ]
        ]


viewOption : ( String, String ) -> Html Msg
viewOption op =
    option
        [ value (Tuple.second op) ]
        [ text (Tuple.first op) ]
