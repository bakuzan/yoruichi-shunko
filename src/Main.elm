module Main exposing (init, main)

import Browser
import Html.Styled exposing (toUnstyled)
import Models exposing (Model, initialModel)
import Msgs exposing (Msg)
import Task
import Time
import Update exposing (update)
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Task.perform Msgs.Zone Time.here
    )


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
