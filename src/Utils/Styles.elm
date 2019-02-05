module Utils.Styles exposing (appearance, containers, content, icon)

import Css exposing (..)
import Models exposing (Theme)


icon : Css.Style
icon =
    before
        [ property "content" "attr(icon)"
        ]


content : String -> Css.Style
content str =
    property "content" ("'" ++ str ++ "'")


appearance : String -> Css.Style
appearance str =
    Css.batch
        [ property "-webkit-appearance" str
        , property "appearance" str
        ]


containers : Theme -> List Css.Style
containers theme =
    [ position relative
    , displayFlex
    , flex (int 1)
    , padding (px 5)
    , minHeight (px 35)
    , boxSizing contentBox
    , focus
        [ borderBottomColor (hex theme.colour)
        ]
    ]
