module Weekend.Day exposing (Day, mon, tue, wed, thu, fri, sat, sun, days, dayOfWeekToDay, dayToDayOfWeek)

import Date as D

type alias Day = Int

mon : Day
mon = 0

tue : Day
tue = 1

wed : Day
wed = 2

thu : Day
thu = 3

fri : Day
fri = 4

sat : Day
sat = 5

sun : Day
sun = 6

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
    0 -> D.Mon
    1 -> D.Tue
    2 -> D.Wed
    3 -> D.Thu
    4 -> D.Fri
    5 -> D.Sat
    _ -> D.Sun
