module Utils.Common exposing (setRole, splitList)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (attribute)


setRole : String -> Attribute msg
setRole value =
    attribute "role" value


splitList : Int -> List a -> List (List a)
splitList i list =
    case List.take i list of
        [] ->
            []

        listHead ->
            listHead :: splitList i (List.drop i list)
