module Components.Checkbox exposing (view)

import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div, input, label, span, text)
import Html.Styled.Attributes as Attr exposing (class, css, type_)
import Models exposing (Theme)
import Msgs exposing (Msg)
import Utils.Styles as Styles


view : Theme -> String -> Bool -> List (Attribute Msg) -> Html Msg
view theme checkboxLabel isChecked inputProps =
    let
        ifChecked =
            if isChecked then
                [ before
                    [ color (hex "0f0")
                    , Styles.content "☑"
                    ]
                ]

            else
                [ before
                    [ color (hex "000")
                    , Styles.content "☐"
                    ]
                ]
    in
    div [ css (Styles.containers theme) ]
        [ label
            [ css
                [ displayFlex
                , justifyContent flexStart
                , alignItems center
                , padding (px 2)
                , cursor pointer
                ]
            ]
            [ input
                ([ type_ "checkbox"
                 , Attr.checked isChecked
                 , css
                    ([ Styles.appearance "none"
                     , position relative
                     , displayFlex
                     , justifyContent center
                     , alignItems center
                     , width (px 20)
                     , height (px 20)
                     , margin2 (px 0) (px 5)
                     , property "transition" "all 0.3s"
                     , before
                        [ property "transition" "all 0.3s"
                        , cursor pointer
                        , zIndex (int 1)
                        , fontSize (em 2)
                        ]
                     ]
                        ++ ifChecked
                    )
                 ]
                    ++ inputProps
                )
                []
            , span [] [ text checkboxLabel ]
            ]
        ]
