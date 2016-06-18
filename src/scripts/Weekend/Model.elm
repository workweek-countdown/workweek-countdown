module Weekend.Model exposing (Model, Route(..), Mode(..))

import Set as S
import Date as D
import Weekend.Day exposing (Day)

type Route
  = Counter
  | EditSettings

type Mode
  = Countdown
  | Percent

type alias Model =
  { route : Route
  , mode : Mode
  , lang: String
  , workingDays : S.Set Day
  , startHour : Int
  , startMinute : Int
  , endHour : Int
  , endMinute : Int
  , date : D.Date
  }
