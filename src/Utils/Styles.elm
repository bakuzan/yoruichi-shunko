module Utils.Styles exposing (icon)

import Css exposing (before, property)


icon : Css.Style
icon =
    before
        [ property "content" "attr(icon)"
        ]
