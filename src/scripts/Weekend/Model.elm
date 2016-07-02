module Weekend.Model exposing (Model, Route(..), Mode(..), WorkingTimeInput(..), Language, defaultModel, defaultStartHour, defaultStartMinute, defaultEndHour, defaultEndMinute)

import Set as S
import Date as D
import Weekend.Day as WD exposing (Day)

type Route
  = Counter
  | EditSettings

type Mode
  = Countdown
  | Percent

type WorkingTimeInput
  = StartHourInput
  | StartMinuteInput
  | EndHourInput
  | EndMinuteInput

type alias Language = String

type alias Model =
  { route : Route
  , mode : Mode
  , lang: Language
  , firstStart : Bool
  , workingDays : S.Set Day
  , startHour : Maybe Int
  , startMinute : Maybe Int
  , endHour : Maybe Int
  , endMinute : Maybe Int
  , activeWorkingTimeInput : Maybe WorkingTimeInput
  , date : D.Date
  }

defaultStartHour : Int
defaultStartHour = 9

defaultStartMinute : Int
defaultStartMinute = 0

defaultEndHour : Int
defaultEndHour = 18

defaultEndMinute : Int
defaultEndMinute = 0

defaultModel : Model
defaultModel =
  { route = Counter
  , mode = Countdown
  , lang = "en"
  , firstStart = True
  , workingDays = S.fromList [WD.mon, WD.tue, WD.wed, WD.thu, WD.fri]
  , startHour = Just defaultStartHour
  , startMinute = Just defaultStartMinute
  , endHour = Just defaultEndHour
  , endMinute = Just defaultEndMinute
  , activeWorkingTimeInput = Nothing
  , date = D.fromTime 0
  }
