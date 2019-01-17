module View exposing (..)

import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)

import Models exposing (Model)
import Msgs exposing (Msg)

import Components.RadioButton as RadioButton
import Utils.Constants exposing(calendarModeOptions)


view : Model -> Html Msg
view model =
    div 
    [ css 
        [ displayFlex
        , flexDirection column
        , minHeight (calc (vh 100) minus (px 50))
        ] 
    ]
    [ RadioButton.radioGroup "calendar-modes" model.calendarMode calendarModeOptions
    , div 
      []
      [ text "calendar to go here"
      ]
    ]
