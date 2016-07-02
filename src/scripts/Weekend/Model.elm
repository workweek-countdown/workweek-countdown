module Weekend.Model exposing (Model, Route(..), Mode(..), Language, defaultModel, defaultStartHour, defaultStartMinute, defaultEndHour, defaultEndMinute)

import Set as S
import Date as D
import Weekend.Day as WD exposing (Day)

type Route
  = Counter
  | EditSettings

type Mode
  = Countdown
  | Percent

type alias Language = String

type alias Model =
  { route : Route
  , mode : Mode
  , lang: Language
  , workingDays : S.Set Day
  , startHour : Maybe Int
  , startMinute : Maybe Int
  , endHour : Maybe Int
  , endMinute : Maybe Int
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
  , workingDays = (S.fromList [WD.mon, WD.tue, WD.wed, WD.thu, WD.fri])
  , startHour = Just defaultStartHour
  , startMinute = Just defaultStartMinute
  , endHour = Just defaultEndHour
  , endMinute = Just defaultEndMinute
  , date = (D.fromTime 0)
  }
