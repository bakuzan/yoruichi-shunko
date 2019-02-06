module Commands exposing
    ( sendCalendarViewRequest
    , sendTemplateByIdRequest
    , sendTodoCreateRequest
    , sendTodoRemoveRequest
    , sendTodoUpdateRequest
    )

import Date
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder as GraphQLBuilder
import Http
import Json.Decode as Decode
import Models exposing (CalendarMode, Todo, TodoTemplate, TodoTemplateForm, Todos, YRIResponse)
import Msgs exposing (Msg)
import Queries
import Task exposing (Task)
import Time



-- Queries


calendarViewRequest : CalendarMode -> Time.Zone -> Time.Posix -> GraphQLBuilder.Request GraphQLBuilder.Query Todos
calendarViewRequest mode zone posix =
    let
        date =
            Date.fromPosix zone posix
                |> Date.format "YYYY-MM-dd"
    in
    GraphQLBuilder.request { mode = mode, date = date } Queries.calendarView


sendCalendarViewRequest : CalendarMode -> Time.Zone -> Time.Posix -> Cmd Msg
sendCalendarViewRequest mode zone posix =
    sendGraphqlQueryRequest (calendarViewRequest mode zone posix)
        |> Task.attempt Msgs.ReceiveCalendarViewResponse


templateRequest : Int -> GraphQLBuilder.Request GraphQLBuilder.Query TodoTemplate
templateRequest id =
    GraphQLBuilder.request { id = id } Queries.templateById


sendTemplateByIdRequest : Int -> Cmd Msg
sendTemplateByIdRequest id =
    sendGraphqlQueryRequest (templateRequest id)
        |> Task.attempt Msgs.ReceiveTemplateResponse



-- Mutations


todoCreateRequest : Time.Zone -> TodoTemplateForm -> GraphQLBuilder.Request GraphQLBuilder.Mutation YRIResponse
todoCreateRequest zone template =
    GraphQLBuilder.request { template = template } (Queries.todoCreate zone)


sendTodoCreateRequest : Time.Zone -> TodoTemplateForm -> Cmd Msg
sendTodoCreateRequest zone template =
    sendGraphqlMutation (todoCreateRequest zone template)
        |> Task.attempt Msgs.ReceiveTodoMutationResponse


todoUpdateRequest : Time.Zone -> Int -> Bool -> TodoTemplateForm -> GraphQLBuilder.Request GraphQLBuilder.Mutation YRIResponse
todoUpdateRequest zone templateId isInstance template =
    GraphQLBuilder.request { todoTemplateId = templateId, template = template, isInstance = isInstance } (Queries.todoUpdate zone)


sendTodoUpdateRequest : Time.Zone -> Int -> Bool -> TodoTemplateForm -> Cmd Msg
sendTodoUpdateRequest zone templateId isInstance template =
    sendGraphqlMutation (todoUpdateRequest zone templateId isInstance template)
        |> Task.attempt Msgs.ReceiveTodoMutationResponse


todoRemoveRequest : Int -> Bool -> GraphQLBuilder.Request GraphQLBuilder.Mutation YRIResponse
todoRemoveRequest instanceId onlyInstance =
    GraphQLBuilder.request { id = instanceId, onlyInstance = onlyInstance } Queries.todoRemove


sendTodoRemoveRequest : Int -> Bool -> Cmd Msg
sendTodoRemoveRequest instanceId onlyInstance =
    sendGraphqlMutation (todoRemoveRequest instanceId onlyInstance)
        |> Task.attempt Msgs.ReceiveTodoMutationResponse



-- Requester


sendGraphqlQueryRequest : GraphQLBuilder.Request GraphQLBuilder.Query a -> Task GraphQLClient.Error a
sendGraphqlQueryRequest request =
    let
        decoder =
            GraphQLBuilder.responseDataDecoder request
                |> Decode.field "data"
    in
    GraphQLClient.customSendQueryRaw options request
        |> Task.andThen
            (\response ->
                case Decode.decodeString decoder response.body of
                    Err err ->
                        Http.BadPayload "Decode Error" response
                            |> GraphQLClient.HttpError
                            |> Task.fail

                    Ok decodedValue ->
                        Task.succeed decodedValue
            )


sendGraphqlMutation : GraphQLBuilder.Request GraphQLBuilder.Mutation a -> Task GraphQLClient.Error a
sendGraphqlMutation request =
    let
        decoder =
            GraphQLBuilder.responseDataDecoder request
                |> Decode.field "data"
    in
    GraphQLClient.customSendMutationRaw options request
        |> Task.andThen
            (\response ->
                case Decode.decodeString decoder response.body of
                    Err err ->
                        Http.BadPayload "Decode Error" response
                            |> GraphQLClient.HttpError
                            |> Task.fail

                    Ok decodedValue ->
                        Task.succeed decodedValue
            )



-- Helpers


options : GraphQLClient.RequestOptions
options =
    { method = "POST"
    , headers =
        [ Http.header "Accept" "application/json"
        ]
    , url = "/yri-graphql"
    , timeout = Nothing
    , withCredentials = False
    }
