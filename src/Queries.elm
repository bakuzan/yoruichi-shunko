module Queries exposing (calendarView, templateById, todoCreate)

import Date
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Json.Decode as Decode
import Models exposing (CalendarMode, Todo, TodoTemplate, TodoTemplateForm, Todos, YRIResponse)
import Time
import Utils.Common as Common
import Utils.Date as YRIDate



-- Queries


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
                |> with (field "date" [] int)
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


templateById : Document Query TodoTemplate { vars | id : Int }
templateById =
    let
        idVar =
            Var.required "id" .id Var.int

        todoTemplate =
            object TodoTemplate
                |> with (field "id" [] int)
                |> with (field "name" [] string)
                |> with (field "date" [] int)
                |> with (field "repeatPattern" [] string)
                |> with (field "repeatFor" [] int)
                |> with (field "repeatWeekDefinition" [] int)

        queryRoot =
            extract
                (field "todoTemplateById"
                    [ ( "id", Arg.variable idVar )
                    ]
                    todoTemplate
                )
    in
    queryDocument queryRoot



-- Mutations


todoCreate : Time.Zone -> Document Mutation YRIResponse { vars | template : TodoTemplateForm }
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


templateVar : Time.Zone -> Var.Variable { vars | template : TodoTemplateForm }
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



-- Helpers


datePost : Time.Zone -> Time.Posix -> String
datePost zone posix =
    Date.fromPosix zone posix
        |> Date.format "YYYY-MM-dd"
