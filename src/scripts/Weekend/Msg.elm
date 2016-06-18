module Weekend.Msg exposing (Msg(..))

import Time as T
import Weekend.Model exposing (Route(..), Mode(..))
import Weekend.Day exposing (Day)

type Msg
  = None
  | ChangeRoute Route
  | ChangeMode Mode
  | TriggerWorkingDay Day
  | ChangeStartHour Int
  | ChangeEndHour Int
  | ChangeStartMinute Int
  | ChangeEndMinute Int
  | Tick T.Time
