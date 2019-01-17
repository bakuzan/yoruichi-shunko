module Components.RadioButton exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)

import Msgs exposing (Msg)
import Utils.Common as Common


type alias RadioOption =
  { label: String
  , optionValue: String
  , action: Msg
  , disabled: Bool
  }


radioGroup : String -> String -> List RadioOption -> Html Msg
radioGroup groupName groupValue options =
  let
    option =
      radioOption groupName groupValue

  in
  div [class "radio-group", Common.setRole "radiogroup"]
      ([] ++ List.map option options)


radioOption : String -> String -> RadioOption -> Html Msg
radioOption groupName groupValue option =
  let
    action =
      option.action

    optionValue =
      option.optionValue

  in
  label [class "radio", Common.setRole "radio"]
        [ input [ type_ "radio"
                , name groupName
                , value optionValue
                , checked (optionValue == groupValue)
                , disabled option.disabled
                , onClick action 
                ] []
        , span [] [text option.label]
        ]