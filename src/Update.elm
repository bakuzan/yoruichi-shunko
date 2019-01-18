module Update exposing (update)

import Models exposing (Model)
import Msgs exposing (Msg)
import Task
import Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.UpdateCalendarMode mode ->
            ( { model | calendarMode = mode }, Cmd.none )

        Msgs.UpdateDate prop posix ->
           let
             updatedModel = 
                case prop of
                  Models.CalendarViewDate -> { model | calendarViewDate = posix }
                  _ -> model
               
           in
           ( updatedModel, Cmd.none )

        -- Time basics
        Msgs.Zone zone ->
            ( { model | zone = zone }, Task.perform Msgs.NewTime Time.now )

        Msgs.NewTime posix ->
            ( { model | today = posix, calendarViewDate = posix }, Cmd.none )

        _ ->
            ( model, Cmd.none )
