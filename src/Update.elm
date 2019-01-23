module Update exposing (update)

import Date
import Models exposing (Model, todoFormDefaults)
import Msgs exposing (Msg)
import Task
import Time
import Utils.Common as Common
import Utils.Date as YRIDate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        todoForm =
            model.todoForm
    in
    case msg of
        Msgs.UpdateCalendarMode modeStr ->
            let
                mode =
                    Common.stringToCalendarMode modeStr
            in
            ( { model | calendarMode = mode }, Cmd.none )

        Msgs.UpdateCalendarViewDate isPicker posix ->
            ( { model | calendarViewDate = posix }, Cmd.none )

        Msgs.UpdateDate prop posix ->
            let
                updatedModel =
                    case prop of
                        Models.FormDate ->
                            { model
                                | todoForm =
                                    { todoForm
                                        | date = posix
                                    }
                                , displayDatepicker = False
                                , calendarViewDate = model.today
                            }

                        _ ->
                            model
            in
            ( updatedModel, Cmd.none )

        Msgs.OpenDatepicker selected ->
            ( { model | displayDatepicker = True, calendarViewDate = selected }, Cmd.none )

        Msgs.CloseDatepicker ->
            ( { model | displayDatepicker = False, calendarViewDate = model.today }, Cmd.none )

        -- Todo Form Handling
        Msgs.DisplayTodoForm posix ->
            ( { model
                | displayForm = True
                , todoForm = { todoForm | date = posix }
              }
            , Cmd.none
            )

        Msgs.CancelTodoForm ->
            ( { model
                | displayForm = False
                , todoForm = todoFormDefaults
              }
            , Cmd.none
            )

        Msgs.SubmitTodoForm ->
            let
                -- TODO handle submission
                logger =
                    Debug.log "Submitted Form! - Not Implemented Yet" model.todoForm
            in
            ( { model
                | displayForm = False
                , todoForm = todoFormDefaults
              }
            , Cmd.none
            )

        -- Form inputs
        Msgs.UpdateTextInput name value ->
            let
                updatedModel =
                    case name of
                        "name" ->
                            { model | todoForm = { todoForm | name = value } }

                        "repeatFor" ->
                            { model
                                | todoForm =
                                    { todoForm
                                        | repeatFor = String.toInt value |> Maybe.withDefault 0
                                    }
                            }

                        "repeatWeekDefinition" ->
                            { model
                                | todoForm =
                                    { todoForm
                                        | repeatWeekDefinition = String.toInt value |> Maybe.withDefault 0
                                    }
                            }

                        _ ->
                            model
            in
            ( updatedModel, Cmd.none )

        Msgs.UpdateDateInput prop value ->
            let
                posix =
                    Date.fromIsoString value
                        |> Result.withDefault (Time.millisToPosix 0 |> Date.fromPosix model.zone)
                        |> YRIDate.dateToPosix model.zone

                updatedModel =
                    case prop of
                        Models.FormDate ->
                            { model
                                | todoForm =
                                    { todoForm
                                        | date = posix
                                    }
                            }

                        _ ->
                            model
            in
            ( updatedModel, Cmd.none )

        Msgs.UpdateSelectBox name value ->
            let
                repeatMax =
                    Common.repeatForMax value

                resolvedRepeatFor =
                    if repeatMax < todoForm.repeatFor then
                        repeatMax

                    else
                        todoForm.repeatFor

                updatedModel =
                    case name of
                        "repeatPattern" ->
                            { model
                                | todoForm =
                                    { todoForm
                                        | repeatPattern = value
                                        , repeatFor = resolvedRepeatFor
                                    }
                            }

                        _ ->
                            model
            in
            ( updatedModel, Cmd.none )

        -- Time basics
        Msgs.Zone zone ->
            ( { model | zone = zone }, Task.perform Msgs.NewTime Time.now )

        Msgs.NewTime posix ->
            ( { model
                | today = posix
                , calendarViewDate = posix
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
