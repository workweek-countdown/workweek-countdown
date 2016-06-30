module Weekend.Counter exposing (counterView)

import List as L
import Date as D
import Date.Extra.Floor as DEF
import Date.Extra.Period as DEP
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Mode(..))
import Weekend.Msg exposing (Msg(..))
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

counterView : Model -> Html Msg
counterView model =
  let
    weekend = weekendStart model.date
    modeView = case model.mode of
      Countdown -> countdownView
      Percent -> percentView
  in
    div [ class "counter" ]
      [ modeView model.date weekend
      , modePickerView model.mode
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
