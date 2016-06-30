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
  , startHour : Maybe Int
  , startMinute : Maybe Int
  , endHour : Maybe Int
  , endMinute : Maybe Int
  , date : D.Date
  }
