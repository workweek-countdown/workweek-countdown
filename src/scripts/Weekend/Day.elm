module Weekend.Day exposing (Day, mon, tue, wed, thu, fri, sat, sun, days, nextDay, dayOfWeekToDay, dayToDayOfWeek, dateToDay)

import Date as D
import Dict as Dict
import List as L
import List.Extra as LE
import Maybe as M

type alias Day = String

mon : Day
mon = "mon"

tue : Day
tue = "tue"

wed : Day
wed = "wed"

thu : Day
thu = "thu"

fri : Day
fri = "fri"

sat : Day
sat = "sat"

sun : Day
sun = "sun"

days : List Day
days =
  [mon, tue, wed, thu, fri, sat, sun]

daysOfWeek : List D.Day
daysOfWeek =
  [D.Mon, D.Tue, D.Wed, D.Thu, D.Fri, D.Sat, D.Sun]

nextDay : Day -> Day
nextDay day =
  let
    nextDay' day days =
      case days of
        today :: tomorrow :: rest ->
          if today == day then tomorrow else nextDay' day (tomorrow :: rest)
        _ -> mon
  in
    nextDay' day days

dayOfWeekToDay : D.Day -> Day
dayOfWeekToDay dayOfWeek =
  LE.elemIndex dayOfWeek daysOfWeek `M.andThen` (\index -> LE.getAt index days) |> M.withDefault mon

dayToDayOfWeek : Day -> D.Day
dayToDayOfWeek day =
  LE.elemIndex day days `M.andThen` (\index -> LE.getAt index daysOfWeek) |> M.withDefault D.Mon

dateToDay : D.Date -> Day
dateToDay date =
  dayOfWeekToDay <| D.dayOfWeek date
