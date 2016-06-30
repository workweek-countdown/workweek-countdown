module Weekend.Msg exposing (Msg(..))

import Time as T
import Weekend.Model exposing (Route(..), Mode(..))
import Weekend.Settings exposing (Settings)
import Weekend.Day exposing (Day)

type Msg
  = None
  | ChangeRoute Route
  | ChangeMode Mode
  | TriggerWorkingDay Day
  | ChangeStartHour (Maybe Int)
  | ChangeEndHour (Maybe Int)
  | ChangeStartMinute (Maybe Int)
  | ChangeEndMinute (Maybe Int)
  | ApplySettings Settings
  | SaveSettings
  | SaveSettingsAndChangeRoute Route
  | Tick T.Time
