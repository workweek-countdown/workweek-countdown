module Weekend.Day exposing (Day, mon, tue, wed, thu, fri, sat, sun, days, dayOfWeekToDay, dayToDayOfWeek)

import Date as D

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

dayOfWeekToDay : D.Day -> Day
dayOfWeekToDay day =
  case day of
    D.Mon -> mon
    D.Tue -> tue
    D.Wed -> wed
    D.Thu -> thu
    D.Fri -> fri
    D.Sat -> sat
    D.Sun -> sun

dayToDayOfWeek : Day -> D.Day
dayToDayOfWeek int =
  case int of
    "mon" -> D.Mon
    "tue" -> D.Tue
    "wed" -> D.Wed
    "thu" -> D.Thu
    "fri" -> D.Fri
    "sat" -> D.Sat
    "sun" -> D.Sun
    _ -> D.Mon
