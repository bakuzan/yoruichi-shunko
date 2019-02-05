module Components.Loader exposing (view)

import Css exposing (..)
import Css.Animations as Ani exposing (keyframes)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)
import Msgs exposing (Msg)


view : Bool -> Html Msg
view show =
    let
        frames =
            keyframes
                [ ( 0
                  , [ Ani.property "opacity" "1"
                    , Ani.property "transform" "translateY(0)"
                    ]
                  )
                , ( 100
                  , [ Ani.property "opacity" "0"
                    , Ani.property "transform" "translateY(-1rem)"
                    ]
                  )
                ]

        bouncerStyle =
            [ width (rem 1)
            , height (rem 1)
            , margin2 (rem 3) (rem 0.2)
            , borderRadius (pct 50)
            , backgroundColor (hex "8385aa")
            , property "animation" "0.6s infinite alternate"
            , animationName frames
            , nthChild "2" [ animationDelay (ms 200) ]
            , nthChild "3" [ animationDelay (ms 400) ]
            ]
    in
    if show then
        div
            [ css
                [ displayFlex
                , justifyContent center
                , position absolute
                , top (px 0)
                , right (px 0)
                , transform (translateY (pct -25))
                ]
            ]
            [ div [ css bouncerStyle ] []
            , div [ css bouncerStyle ] []
            , div [ css bouncerStyle ] []
            ]

    else
        text ""
