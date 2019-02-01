module Utils.Common exposing (calendarModeToString, expectError, getUnsuccessfulResponseMessage, onKeyDown, repeatForMax, setCustomAttr, setRole, splitList, stringToCalendarMode)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (attribute)
import Html.Styled.Events exposing (keyCode, on)
import Http
import Json.Decode as D
import Models exposing (CalendarMode(..), YRIResponse)
import Msgs exposing (Msg)


setCustomAttr : String -> String -> Attribute msg
setCustomAttr attr val =
    attribute attr val


setRole : String -> Attribute msg
setRole value =
    setCustomAttr "role" value


splitList : Int -> List a -> List (List a)
splitList i list =
    case List.take i list of
        [] ->
            []

        listHead ->
            listHead :: splitList i (List.drop i list)



-- Calendar mode mapping


calendarModeToString : CalendarMode -> String
calendarModeToString mode =
    case mode of
        Day ->
            "Day"

        Week ->
            "Week"

        Month ->
            "Month"


stringToCalendarMode : String -> CalendarMode
stringToCalendarMode str =
    case str of
        "Day" ->
            Day

        "Week" ->
            Week

        "Month" ->
            Month

        _ ->
            Month



-- Repeat mapping


repeatForMax : String -> Int
repeatForMax pattern =
    case pattern of
        "Daily" ->
            28

        "Weekly" ->
            52

        "Monthly" ->
            12

        "Quarterly" ->
            8

        "Yearly" ->
            4

        _ ->
            0



-- expecting errors


getUnsuccessfulResponseMessage : YRIResponse -> String
getUnsuccessfulResponseMessage res =
    List.head res.errorMessages
        |> Maybe.withDefault ""


expectError : Http.Error -> String
expectError error =
    case error of
        Http.BadUrl url ->
            "Bad Url: " ++ url

        Http.Timeout ->
            "Request timed out"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus err ->
            err.status.message

        _ ->
            "Something went wrong."



-- Custom events


onKeyDown : List Int -> Msg -> Html.Styled.Attribute Msg
onKeyDown keys msg =
    let
        isWatchedKey code =
            if List.any (\x -> x == code) keys then
                D.succeed msg

            else
                D.fail "Ignore"
    in
    on "keydown" (D.andThen isWatchedKey keyCode)
