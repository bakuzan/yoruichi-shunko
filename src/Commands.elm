module Commands exposing (calendarViewRequest)

import Date
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder as GraphQLBuilder
import Models exposing (CalendarMode, Todo)
import Msgs exposing (Msg)
import Queries
import Task exposing (Task)
import Time



-- Requester


sendGraphqlQueryRequest : GraphQLBuilder.Request GraphQLBuilder.Query a -> Task GraphQLClient.Error a
sendGraphqlQueryRequest request =
    GraphQLClient.customSendQuery
        { method = "POST"
        , headers = []
        , url = "/yri/graphql"
        , timeout = Nothing
        , withCredentials = False
        }
        request



-- Queries


calendarViewRequest : CalendarMode -> Time.Zone -> Time.Posix -> Cmd Msg
calendarViewRequest mode zone posix =
    let
        date =
            Date.fromPosix zone posix
                |> Date.format "YYYY-MM-DD"
    in
    sendGraphqlQueryRequest (GraphQLBuilder.request { mode = mode, date = date } Queries.calendarView)
        |> Task.attempt Msgs.ReceiveCalendarViewResponse
