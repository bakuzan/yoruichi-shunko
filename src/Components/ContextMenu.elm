module Components.ContextMenu exposing (view)

import Components.Button as Button
import Css exposing (..)
import Html.Styled exposing (Html, button, div, li, text, ul)
import Html.Styled.Attributes exposing (class, css, tabindex)
import Html.Styled.Events exposing (onClick)
import Msgs exposing (Msg)
import Utils.Common as Common


view : Bool -> Html Msg
view active =
    if not active then
        text ""

    else
        div
            [ class "context-menu"
            , css
                [ position absolute
                , right (pct 100)
                , boxShadow4 (px 1) (px 2) (px 5) (px 1)
                , zIndex (int 1)
                ]
            ]
            [ ul [ class "list column one", css [ zIndex (int 10) ] ]
                [ li []
                    [ Button.view
                        [ onClick Msgs.DisplayTodoFormEdit
                        , Common.setCustomAttr "icon" "✎"
                        ]
                        []
                    ]
                , li []
                    [ Button.view
                        [ onClick Msgs.PrepareToDelete
                        , Common.setCustomAttr "icon" "╳"
                        ]
                        []
                    ]
                ]
            , div
                [ css
                    [ position fixed
                    , top (px 0)
                    , bottom (px 0)
                    , left (px 0)
                    , right (px 0)
                    , zIndex (int -1)
                    ]
                , class "context-menu-backdrop"
                , Common.setRole "button"
                , tabindex 0
                , onClick Msgs.CloseContextMenu
                ]
                []
            ]
