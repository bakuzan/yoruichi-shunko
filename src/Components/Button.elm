module Components.Button exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)
import Msgs exposing (Msg)


view : List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg
view attrs children =
    button
        ([ class "yri-button button ripple" ] ++ attrs)
        children
