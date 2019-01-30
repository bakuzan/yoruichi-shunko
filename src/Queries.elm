module Queries exposing (calendarView, todoCreate)

import Date
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Json.Decode as Decode
import Models exposing (CalendarMode, Todo, TodoTemplate, Todos, YRIResponse)
import Time
import Utils.Common as Common
import Utils.Date as YRIDate


calendarView : Time.Zone -> Document Query Todos { vars | mode : CalendarMode, date : String }
calendarView zone =
    let
        calendarModeVar =
            Var.required "mode" .mode (Var.enum "CalendarMode" Common.calendarModeToString)

        dateVar =
            Var.required "date" .date Var.string

        todo =
            object Todo
                |> with (field "id" [] int)
                |> with (field "name" [] string)
                |> with (field "date" [] (date zone))
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


todoCreate : Time.Zone -> Document Mutation YRIResponse { vars | template : TodoTemplate }
todoCreate zone =
    let
        yriResponse =
            object YRIResponse
                |> with (field "success" [] bool)
                |> with (field "errorMessages" [] (list string))

        root =
            extract
                (field "todoCreate"
                    [ ( "template", Arg.variable (templateVar zone) )
                    ]
                    yriResponse
                )
    in
    mutationDocument root



-- Variables


templateVar : Time.Zone -> Var.Variable { vars | template : TodoTemplate }
templateVar zone =
    Var.required "template"
        .template
        (Var.object
            "TodoTemplateInput"
            [ Var.field "id" .id Var.int
            , Var.field "name" .name Var.string
            , Var.field "date" (\x -> datePost zone x.date) Var.string
            , Var.field "repeatPattern" .repeatPattern Var.string
            , Var.field "repeatFor" .repeatFor Var.int
            , Var.field "repeatWeekDefinition" .repeatWeekDefinition Var.int
            ]
        )



-- Custom Graphql Types


type DateType
    = DateType


date : Time.Zone -> ValueSpec NonNull DateType Int vars
date zone =
    Decode.string
        |> Decode.andThen
            (\dateStr ->
                case Date.fromIsoString (String.split "T" dateStr |> List.head |> Maybe.withDefault "") of
                    Ok d ->
                        Decode.succeed (YRIDate.dateToMillis zone d)

                    Err errorMessage ->
                        Decode.fail errorMessage
            )
        |> customScalar DateType


datePost : Time.Zone -> Time.Posix -> String
datePost zone posix =
    Date.fromPosix zone posix
        |> Date.format "YYYY-MM-dd"
