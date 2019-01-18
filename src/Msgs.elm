module Msgs exposing (Msg(..))

import Time
import Models exposing(YRIDateProperty)


type Msg
    = NoOp
    | Zone Time.Zone
    | NewTime Time.Posix
    | UpdateCalendarMode String
    | UpdateDate YRIDateProperty Time.Posix
