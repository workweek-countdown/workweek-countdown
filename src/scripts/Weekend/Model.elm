module Weekend.Model exposing (Model, Settings, Route(..), Mode(..))

import Set as S
import Date as D
import Weekend.Day as WD

type Route
  = Counter
  | EditSettings

type Mode
  = Countdown
  | Percent

type alias Settings =
  { mode : Mode
  , workingDays : S.Set WD.Day
  }

type alias Model =
  { route : Route
  , settings : Settings
  , date : D.Date
  }
