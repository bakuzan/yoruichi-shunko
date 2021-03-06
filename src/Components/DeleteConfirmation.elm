module Components.DeleteConfirmation exposing (view)

import Components.Button as Button
import Css exposing (..)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Models exposing (Theme)
import Msgs exposing (Msg)
import Utils.Common as Common
import Utils.Styles as Styles


view : Theme -> Html.Styled.Html Msg
view theme =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , padding (px 15)
            ]
        ]
        [ div [ css [ padding2 (px 0) (px 10) ] ]
            [ text "Please confirm which deletion mode you would like to follow." ]
        , div
            [ css
                [ displayFlex
                , padding2 (px 10) (px 0)
                ]
            ]
            [ padded [ Button.view { theme = theme, isPrimary = False } [ onClick (Msgs.SubmitDelete False) ] [ text "Entire Series" ] ]
            , padded [ Button.view { theme = theme, isPrimary = False } [ onClick (Msgs.SubmitDelete True) ] [ text "Instance Only" ] ]
            , padded [ Button.viewLink theme [ onClick Msgs.CancelDelete ] [ text "Cancel" ] ]
            ]
        ]


padded : List (Html Msg) -> Html Msg
padded children =
    div [ css [ padding (px 10) ] ] children
