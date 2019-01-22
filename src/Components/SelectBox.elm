module Components.SelectBox exposing (view)

import Html.Styled exposing (Html, div, label, option, select, text)
import Html.Styled.Attributes exposing (class, name, value)
import Html.Styled.Events exposing (onInput)
import Msgs exposing (Msg)


view : List ( String, String ) -> String -> String -> String -> Html Msg
view options fieldName fieldLabel fieldValue =
    div [ class "has-float-label select-container" ]
        [ select
            [ class "select-box"
            , name fieldName
            , value fieldValue
            , onInput (Msgs.UpdateSelectBox fieldName)
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
