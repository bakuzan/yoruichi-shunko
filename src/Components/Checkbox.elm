module Components.Checkbox exposing (view)

import Html.Styled exposing (Attribute, Html, div, input, label, span, text)
import Html.Styled.Attributes exposing (class, type_)
import Msgs exposing (Msg)


view : String -> List (Attribute Msg) -> Html Msg
view checkboxLabel inputProps =
    div [ class "input-container" ]
        [ label [ class "tickbox" ]
            [ input ([ type_ "checkbox" ] ++ inputProps) []
            , span [] [ text checkboxLabel ]
            ]
        ]
