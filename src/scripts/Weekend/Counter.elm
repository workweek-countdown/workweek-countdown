module Weekend.Counter exposing (counterView)

import Maybe as M
import List as L
import Set as S
import Date as D
import Date.Extra.Period as DEP
import Date.Extra.TimeUnit as DETU
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Mode(..), defaultEndHour, defaultEndMinute)
import Weekend.Msg exposing (Msg(..))
import Weekend.Day exposing (Day, nextDay, dateToDay)
import Weekend.Countdown exposing (countdownView)
import Weekend.Percent exposing (percentView)

lastWorkingDate : S.Set Day -> D.Date -> D.Date
lastWorkingDate workingDays date =
  let
    next = DEP.add DEP.Day 1 date
    dateDay = dateToDay date
    nextDay = dateToDay next
  in
    if not (S.member nextDay workingDays) && S.member dateDay workingDays then date
    else lastWorkingDate workingDays next

isWeekend : S.Set Day -> Int -> Int -> D.Date -> Bool
isWeekend workingDays endHour endMinute now =
  let
    today = dateToDay now
    hour = D.hour now
    minute = D.minute now
    lastWorkingDay = dateToDay <| lastWorkingDate workingDays now
  in
    not (S.member today workingDays)
    || (lastWorkingDay == today
    && (hour > endHour
    || (hour == endHour && minute >= endMinute)))

weekendStart : S.Set Day -> Int -> Int -> D.Date -> D.Date
weekendStart workingDays endHour endMinute now =
  let
    startOfLastDay = DETU.startOfTime DETU.Day <| lastWorkingDate workingDays now
  in
    DEP.add DEP.Minute endMinute <| DEP.add DEP.Hour endHour <| startOfLastDay

counterView : Model -> Html Msg
counterView model =
  let
    { mode, workingDays, endHour, endMinute, date } = model
    weekend = weekendStart workingDays (M.withDefault defaultEndHour endHour) (M.withDefault defaultEndMinute endMinute) date
    modeView = case mode of
      Countdown -> countdownView
      Percent -> percentView
  in
    div [ class "counter" ]
      [ modeView date weekend
      , modePickerView mode
      ]

modePickerView : Mode -> Html Msg
modePickerView current =
  let
    options = L.map (modePickerOptionView current) [Countdown, Percent]
    otherMode = if current == Countdown then Percent else Countdown
  in
    div [ class "mode-picker", onClick (ChangeMode otherMode) ] options

modePickerOptionView : Mode -> Mode -> Html Msg
modePickerOptionView current mode =
  let
    classes = classList [("mode-picker_option", True), ("m-current", current == mode)]
  in
    div [ classes ] []
