module Msgs exposing (Msg(..))

import GraphQL.Client.Http as GraphQLClient
import Keyboard.Event exposing (KeyboardEvent)
import Models exposing (Theme, TodoTemplate, Todos, YRIDateProperty, YRIResponse)
import Time


type Msg
    = NoOp
    | Zone Time.Zone
    | NewTime Time.Posix
    | UpdateCalendarMode String
    | UpdateDate YRIDateProperty Time.Posix
    | UpdateCalendarViewDate Bool Time.Posix
    | UpdateCalendarModeViewDay Time.Posix
    | DisplayTodoForm Time.Posix
    | CancelTodoForm
    | SubmitTodoForm
    | UpdateTextInput String String
    | UpdateDateInput YRIDateProperty String
    | UpdateSelectBox String String
    | ToggleInstanceForm
    | OpenDatepicker Time.Posix
    | CloseDatepicker
    | OpenContextMenu Int
    | CloseContextMenu
    | DisplayTodoFormEdit
    | PrepareToDelete
    | CancelDelete
    | SubmitDelete Bool
    | ClearError
    | ReceiveCalendarViewResponse (Result GraphQLClient.Error Todos)
    | ReceiveTodoMutationResponse (Result GraphQLClient.Error YRIResponse)
    | ReceiveTemplateResponse (Result GraphQLClient.Error TodoTemplate)
    | UpdateTheme Theme
    | HandleKeyboardEvent KeyboardEvent
