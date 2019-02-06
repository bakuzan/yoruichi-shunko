module Utils.Styles exposing (appearance, containers, content, icon)

import Css exposing (..)
import Css.Global exposing (children, typeSelector)
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
    floatLabel
        ++ [ position relative
           , displayFlex
           , alignItems center
           , flex (int 1)
           , padding (px 5)
           , minHeight (px 35)
           , boxSizing contentBox
           , focus
                [ important (borderBottomColor (hex theme.colour))
                ]
           ]


floatLabel : List Css.Style
floatLabel =
    [ displayFlex
    , position relative
    , children
        [ typeSelector "label"
            [ position absolute
            , left (px 5)
            , top (px 1)
            , cursor text_
            , fontSize (em 0.75)
            , opacity (int 1)
            , property "transition" "all 0.2s"
            ]
        , typeSelector "select" ([ appearance "none" ] ++ controlFloatLabelStyle ++ [ marginBottom (px 0) ])
        , typeSelector "input" controlFloatLabelStyle
        ]
    ]


controlFloatLabelStyle : List Css.Style
controlFloatLabelStyle =
    [ fontSize inherit
    , paddingBottom (px 0)
    , paddingLeft (em 0.5)
    , paddingTop (em 1)
    , marginBottom (px 2)
    , property "border" "none"
    , borderRadius (px 0)
    , borderBottom3 (px 2) solid (rgba 0 0 0 0.1)
    , pseudoElement "-webkit-input-placeholder"
        [ opacity (int 1)
        , property "transition" "all 0.2s"
        ]
    , pseudoClass "placeholder-shown:not(:focus) + label"
        [ opacity (int 0)
        , fontSize (em 1.3)
        , property "opacity" "0.5"
        , pointerEvents none
        , top (em 0.25)
        , left (em 0.5)
        ]
    , focus
        [ outline none
        ]
    ]
