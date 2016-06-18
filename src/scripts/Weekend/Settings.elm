module Weekend.Settings exposing (Settings, fromModel, applySettings)

import Set as S
import Weekend.Model exposing (Model, Mode(..), Language)
import Weekend.Day exposing (Day)

type alias Settings =
  { mode : String
  , lang: Language
  , workingDays : List Day
  , startHour : Int
  , startMinute : Int
  , endHour : Int
  , endMinute : Int
  }

fromModel : Model -> Settings
fromModel model =
  { mode = toString model.mode
  , lang = model.lang
  , workingDays = S.toList model.workingDays
  , startHour = model.startHour
  , startMinute = model.startMinute
  , endHour = model.endHour
  , endMinute = model.endMinute
  }

applySettings : Model -> Settings -> Model
applySettings model settings =
  { model
  | mode = modeFromString settings.mode
  , lang = settings.lang
  , workingDays = S.fromList settings.workingDays
  , startHour = settings.startHour
  , startMinute = settings.startMinute
  , endHour = settings.endHour
  , endMinute = settings.endMinute
  }

modeFromString : String -> Mode
modeFromString mode =
  case mode of
    "Countdown" -> Countdown
    "Percent" -> Percent
    _ -> Countdown
