module Weekend.Counter exposing (counterView)

import Maybe as M
import List as L
import List.Extra as LE
import Set as S
import Date as D
import Date.Extra.Period as DEP
import Date.Extra.TimeUnit as DETU
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Mode(..), Language, defaultEndHour, defaultEndMinute)
import Weekend.Msg exposing (Msg(..))
import Weekend.Day exposing (Day, days, nextDay, dateToDay)
import Weekend.I18n exposing (t)
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

workingDaysInARow : S.Set Day -> D.Date -> Int
workingDaysInARow workingDays now =
  let
    isWorkingDay = flip S.member <| workingDays
    today = dateToDay now
    (before, after) = LE.break ((==) today) <| L.concat <| L.repeat 3 days
    beforeCount = L.length <| LE.takeWhileEnd isWorkingDay before
    afterCount = L.length <| LE.takeWhile isWorkingDay after
  in
    beforeCount + afterCount

counterView : Model -> Html Msg
counterView model =
  let
    { mode, lang, workingDays, date } = model
    endHour = M.withDefault defaultEndHour model.endHour
    endMinute = M.withDefault defaultEndHour model.endMinute
    weekend = weekendStart workingDays endHour endMinute date
    modeView = case mode of
      Countdown -> countdownView
      Percent -> percentView <| workingDaysInARow workingDays date
    mainView = if isWeekend workingDays endHour endMinute date then
      weekendView lang
    else
      modeView date weekend
  in
    div [ class "counter" ]
      [ mainView
      , modePickerView mode
      ]

weekendView : Language -> Html Msg
weekendView lang =
  let
    content = t <| lang ++ ".counter.weekend"
  in
    div [ class "counter_weekend" ] [ text content ]

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
