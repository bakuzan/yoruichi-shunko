module View exposing (..)

import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)

import Models exposing (Model)
import Msgs exposing (Msg)


view : Model -> Html Msg
view model =
    div 
    [ css 
        [ displayFlex
        , justifyContent center
        , alignItems center
        , height (vh 100)
        , margin auto
        ] 
    ]
    [ text "App skeleton created placeholder"]
