module Msgs exposing (Msg(..))

import GraphQL.Client.Http as GraphQLClient
import Models exposing (TodoTemplate, Todos, YRIDateProperty, YRIResponse)
import Time


type Msg
    = NoOp
    | Zone Time.Zone
    | NewTime Time.Posix
    | UpdateCalendarMode String
    | UpdateDate YRIDateProperty Time.Posix
    | UpdateCalendarViewDate Bool Time.Posix
    | DisplayTodoForm Time.Posix
    | CancelTodoForm
    | SubmitTodoForm
    | UpdateTextInput String String
    | UpdateDateInput YRIDateProperty String
    | UpdateSelectBox String String
    | OpenDatepicker Time.Posix
    | CloseDatepicker
    | OpenContextMenu Int
    | CloseContextMenu
    | DisplayTodoFormEdit
    | PrepareToDelete
    | ReceiveCalendarViewResponse (Result GraphQLClient.Error Todos)
    | ReceiveTodoMutationResponse (Result GraphQLClient.Error YRIResponse)
    | ReceiveTemplateResponse (Result GraphQLClient.Error TodoTemplate)
