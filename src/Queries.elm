module Queries exposing (calendarView)

import Date
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Json.Decode as Decode
import Models exposing (CalendarMode, Todo, TodoTemplate, Todos)
import Time
import Utils.Common as Common
import Utils.Date as YRIDate


calendarView : Document Query Todos { vars | mode : CalendarMode, date : String }
calendarView =
    let
        calendarModeVar =
            Var.required "mode" .mode (Var.enum "CalendarMode" Common.calendarModeToString)

        dateVar =
            Var.required "date" .date Var.string

        todo =
            object Todo
                |> with (field "id" [] int)
                |> with (field "name" [] string)
                |> with (field "date" [] string)
                |> with (field "isRepeated" [] bool)
                |> with (field "todoTemplateId" [] int)

        todos =
            list todo

        queryRoot =
            extract
                (field "calendarView"
                    [ ( "mode", Arg.variable calendarModeVar )
                    , ( "date", Arg.variable dateVar )
                    ]
                    todos
                )
    in
    queryDocument queryRoot



-- Custom Graphql Types
-- type DateType
--     = DateType
-- date : Time.Zone -> ValueSpec NonNull DateType Int vars
-- date zone =
--     Decode.string
--         |> Decode.andThen
--             (\dateStr ->
--                 case Date.fromIsoString dateStr of
--                     Ok d ->
--                         Decode.succeed (YRIDate.dateToMillis zone d)
--                     Err errorMessage ->
--                         Decode.fail errorMessage
--             )
--         |> customScalar DateType
