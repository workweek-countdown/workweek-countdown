module Weekend.Counter exposing (counterView)

import List as L
import Date as D
import Date.Extra.Floor as DEF
import Date.Extra.Period as DEP
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Settings, Mode(..))
import Weekend.Countdown exposing (countdownView)
import Weekend.Percent exposing (percentView)

weekendStartHour : Int
weekendStartHour = 19

weekendStartMinute : Int
weekendStartMinute = 0

shiftToNextFriday : D.Date -> D.Date
shiftToNextFriday date =
  let
    newDate = DEP.add DEP.Day 1 date
  in
    case D.dayOfWeek date of
      D.Fri ->
        let
          hour = D.hour date
          minute = D.minute date
        in
          if hour > weekendStartHour || (hour == weekendStartHour && minute > weekendStartMinute) then
            DEP.add DEP.Day 7 date
          else
            date
      _ -> shiftToNextFriday newDate

weekendStart : D.Date -> D.Date
weekendStart date =
  date
    |> shiftToNextFriday
    |> DEF.floor DEF.Day
    |> DEP.add DEP.Hour weekendStartHour
    |> DEP.add DEP.Minute weekendStartMinute

counterView : (Mode -> msg) -> Model -> Html msg
counterView changeMode model =
  let
    weekend = weekendStart model.date
    modeView = case model.settings.mode of
      Countdown -> countdownView
      Percent -> percentView
  in
    div [ class "counter" ]
      [ modeView model.date weekend
      , modePickerView changeMode model.settings.mode
      ]

modePickerView : (Mode -> msg) -> Mode -> Html msg
modePickerView changeMode current =
  let
    options = L.map (modePickerOptionView changeMode current) [Countdown, Percent]
  in
    div [ class "mode-picker" ] options

modePickerOptionView : (Mode -> msg) -> Mode -> Mode -> Html msg
modePickerOptionView changeMode current mode =
  let
    classes = classList [("mode-picker_option", True), ("m-current", current == mode)]
  in
    div [ classes, onClick (changeMode mode) ]
      [ text (toString mode) ]
