module Weekend.Model exposing (Model, Route(..), Mode(..), Language)

import Set as S
import Date as D
import Weekend.Day exposing (Day)

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
  , startHour : Int
  , startMinute : Int
  , endHour : Int
  , endMinute : Int
  , date : D.Date
  }
