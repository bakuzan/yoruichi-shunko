port module Main exposing (init, main)

import Browser
import Html.Styled exposing (toUnstyled)
import Models exposing (Flags, Model, Theme, initialModel)
import Msgs exposing (Msg)
import Task
import Time
import Update exposing (update)
import View exposing (view)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags
    , Task.perform Msgs.Zone Time.here
    )


port theme : (Theme -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ theme Msgs.UpdateTheme
        ]


main : Program Flags Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
