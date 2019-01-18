module Utils.Date exposing (..)

import Time exposing (Zone, Posix)
import Time.Extra as Time
import Date


dateToPosix : Zone -> Date.Date -> Posix
dateToPosix zone d =
  Time.Parts (Date.year d) (Date.month d) (Date.day d) 0 0 0 0 |> Time.partsToPosix zone