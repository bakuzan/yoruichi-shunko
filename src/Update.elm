module Update exposing (update)

import Commands
import Date
import GraphQL.Client.Http as GraphqlClient
import Http
import Models exposing (CalendarViewResponse, Model, TemplateRequestResponse, Todo, TodoTemplate, TodoTemplateForm, Todos, dummyTodo, todoFormDefaults)
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

                cmd =
                    Commands.sendCalendarViewRequest mode model.zone model.calendarViewDate
            in
            ( { model | calendarMode = mode }, cmd )

        Msgs.UpdateCalendarViewDate isPicker posix ->
            let
                sendCmd =
                    if isPicker then
                        Cmd.none

                    else
                        Commands.sendCalendarViewRequest model.calendarMode model.zone posix
            in
            ( { model | calendarViewDate = posix }, sendCmd )

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

        Msgs.DisplayTodoFormEdit ->
            let
                loadedTodo =
                    loadActiveTodo model.contextMenuActiveFor model.todos

                getTemplateCmd =
                    Commands.sendTemplateByIdRequest loadedTodo.todoTemplateId
            in
            ( { model
                | displayForm = True
              }
            , getTemplateCmd
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
                isCreate =
                    model.todoForm.id == 0

                loadedTodo =
                    if isCreate then
                        dummyTodo

                    else
                        loadActiveTodo model.todoForm.id model.todos

                submitCmd =
                    if isCreate then
                        Commands.sendTodoCreateRequest model.zone model.todoForm

                    else
                        Commands.sendTodoUpdateRequest
                            model.zone
                            loadedTodo.todoTemplateId
                            model.isInstanceForm
                            model.todoForm
            in
            ( { model
                | displayForm = False
                , todoForm = todoFormDefaults
                , isInstanceForm = True
              }
            , submitCmd
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

        Msgs.ToggleInstanceForm ->
            ( { model | isInstanceForm = not model.isInstanceForm }, Cmd.none )

        -- Context Menu Control
        Msgs.OpenContextMenu todoId ->
            ( { model | contextMenuActiveFor = todoId }, Cmd.none )

        Msgs.CloseContextMenu ->
            ( { model | contextMenuActiveFor = 0 }, Cmd.none )

        -- Delete handling
        Msgs.PrepareToDelete ->
            ( { model
                | contextMenuActiveFor = 0
                , deleteActiveFor = model.contextMenuActiveFor
              }
            , Cmd.none
            )

        Msgs.CancelDelete ->
            ( { model
                | deleteActiveFor = 0
              }
            , Cmd.none
            )

        Msgs.SubmitDelete instanceOnly ->
            ( { model
                | deleteActiveFor = 0
              }
            , Cmd.none
              -- TODO HANDLING OF DELETE
            )

        -- Receive Api Responses
        Msgs.ReceiveCalendarViewResponse response ->
            let
                result : CalendarViewResponse
                result =
                    case response of
                        Ok todos ->
                            { todos = todos, errorMessage = "" }

                        Err error ->
                            let
                                logger =
                                    Debug.log "Calendar View Error => " error
                            in
                            case error of
                                GraphqlClient.HttpError err ->
                                    { todos = [], errorMessage = Common.expectError err }

                                _ ->
                                    { todos = [], errorMessage = "Something went wrong fetching the calendar" }
            in
            ( { model
                | todos = result.todos
                , errorMessage = result.errorMessage
              }
            , Cmd.none
            )

        Msgs.ReceiveTodoMutationResponse response ->
            let
                newModelAndCmd =
                    case response of
                        Ok res ->
                            if res.success then
                                ( model
                                , Commands.sendCalendarViewRequest model.calendarMode model.zone model.calendarViewDate
                                )

                            else
                                ( { model
                                    | errorMessage = Common.getUnsuccessfulResponseMessage res
                                  }
                                , Cmd.none
                                )

                        Err error ->
                            let
                                logger =
                                    Debug.log "Calendar View Error => " error
                            in
                            case error of
                                GraphqlClient.HttpError err ->
                                    ( { model
                                        | errorMessage = Common.expectError err
                                      }
                                    , Cmd.none
                                    )

                                _ ->
                                    ( { model
                                        | errorMessage = "Something went wrong fetching the calendar"
                                      }
                                    , Cmd.none
                                    )
            in
            newModelAndCmd

        Msgs.ReceiveTemplateResponse response ->
            let
                result : TemplateRequestResponse
                result =
                    case response of
                        Ok template ->
                            { template = mapTemplateToForm (loadActiveTodo model.contextMenuActiveFor model.todos) template, errorMessage = "" }

                        Err error ->
                            let
                                logger =
                                    Debug.log "Template request Error => " error
                            in
                            case error of
                                GraphqlClient.HttpError err ->
                                    { template = todoFormDefaults, errorMessage = Common.expectError err }

                                _ ->
                                    { template = todoFormDefaults, errorMessage = "Something went wrong fetching the calendar" }
            in
            ( { model
                | todoForm = result.template
                , contextMenuActiveFor = 0
                , errorMessage = result.errorMessage
              }
            , Cmd.none
            )

        -- Time basics
        Msgs.Zone zone ->
            ( { model | zone = zone }, Task.perform Msgs.NewTime Time.now )

        Msgs.NewTime posix ->
            ( { model
                | today = posix
                , calendarViewDate = posix
              }
            , Commands.sendCalendarViewRequest model.calendarMode model.zone posix
            )

        _ ->
            ( model, Cmd.none )



-- helpers


loadActiveTodo : Int -> Todos -> Todo
loadActiveTodo id todos =
    List.filter (\x -> x.id == id) todos
        |> List.head
        |> Maybe.withDefault dummyTodo


mapTemplateToForm : Todo -> TodoTemplate -> TodoTemplateForm
mapTemplateToForm to te =
    { id = to.id
    , name = te.name
    , date = Time.millisToPosix to.date
    , repeatPattern = te.repeatPattern
    , repeatFor = te.repeatFor
    , repeatWeekDefinition = te.repeatWeekDefinition
    }
