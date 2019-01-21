module Msgs exposing (Msg(..))

import Models exposing (YRIDateProperty)
import Time


type Msg
    = NoOp
    | Zone Time.Zone
    | NewTime Time.Posix
    | UpdateCalendarMode String
    | UpdateDate YRIDateProperty Time.Posix
    | DisplayTodoForm Time.Posix
