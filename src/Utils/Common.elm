module Utils.Common exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (attribute)


setRole : String -> Attribute msg
setRole value =
  attribute "role" value