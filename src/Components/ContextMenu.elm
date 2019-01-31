module Components.ContextMenu exposing (view)

import Components.Button as Button
import Css exposing (..)
import Html.Styled exposing (Html, button, div, li, text, ul)
import Html.Styled.Attributes exposing (class, css, tabindex, title)
import Html.Styled.Events exposing (onClick)
import Msgs exposing (Msg)
import Utils.Common as Common
import Utils.Constants as Constants
import Utils.Styles as Styles


view : Bool -> Html Msg
view active =
    if not active then
        text ""

    else
        let
            itemCss =
                [ padding (px 2)
                ]
        in
        div
            [ class "context-menu"
            , css
                [ position absolute
                , boxShadow4 (px 1) (px 2) (px 5) (px 1)
                , zIndex (int 1)
                ]
            ]
            [ ul
                [ class "list column one"
                , css
                    [ listStyleType none
                    , padding (px 0)
                    , margin (px 0)
                    , zIndex (int 10)
                    ]
                ]
                [ li [ css itemCss ]
                    [ Button.view
                        [ onClick Msgs.DisplayTodoFormEdit
                        , css [ Styles.icon ]
                        , Common.setCustomAttr "icon" "✎"
                        , Common.setCustomAttr "aria-label" "Edit"
                        , title "Edit"
                        ]
                        []
                    ]
                , li [ css itemCss ]
                    [ Button.view
                        [ onClick Msgs.PrepareToDelete
                        , css [ Styles.icon ]
                        , Common.setCustomAttr "icon" "╳"
                        , Common.setCustomAttr "aria-label" "Delete"
                        , title "Delete"
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
                , Common.onKeyDown Constants.closeKeys Msgs.CloseContextMenu
                ]
                []
            ]
