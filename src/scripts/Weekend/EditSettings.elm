module Weekend.EditSettings exposing (editSettingsView)

import List as L
import Set as S
import Date as D
import String as St
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Route(..), Language)
import Weekend.Msg exposing (Msg(..))
import Weekend.Day as WD exposing (Day)
import Weekend.I18n exposing (t)

timeValidator : Int -> Int -> Maybe Int -> Bool
timeValidator min max value =
  case value of
    Just val -> val >= min && val < max
    Nothing -> False

isValidHour : Maybe Int -> Bool
isValidHour =
  timeValidator 0 24

isValidMinute : Maybe Int -> Bool
isValidMinute =
  timeValidator 0 60

isValidTime : Model -> Bool
isValidTime model =
  let
    { startHour, startMinute, endHour, endMinute } = model
  in
    (isValidHour startHour) && (isValidMinute startMinute) && (isValidHour endHour) && (isValidMinute endMinute)

editSettingsView : Model -> Html Msg
editSettingsView model =
  div [ class "settings" ]
    [ workingTimesView model
    , workingDaysView model.lang model.workingDays
    , saveSettingsView model.lang (isValidTime model)
    ]

workingTimesView : Model -> Html Msg
workingTimesView model =
  let
    { startHour, startMinute, endHour, endMinute } = model

    parseInput handler input =
      case St.toInt input of
        Ok value -> handler <| Just value
        Err _ -> handler Nothing
  in
    div [ class "settings_working-time" ]
      [ workingTimeView startHour (isValidHour startHour) (parseInput ChangeStartHour)
      , workingTimeView startMinute (isValidMinute startMinute) (parseInput ChangeStartMinute)
      , workingTimeView endHour (isValidHour endHour) (parseInput ChangeEndHour)
      , workingTimeView endMinute (isValidMinute endMinute) (parseInput ChangeEndMinute)
      ]

workingTimeView : Maybe Int -> Bool -> (String -> Msg) -> Html Msg
workingTimeView value isValid inputHandler =
  let
    valueStr = case value of
      Just val -> toString val
      Nothing -> ""
    classes = classList [("settings_working-time-input", True), ("m-invalid", not isValid)]
  in
    input [ type' "text", classes, defaultValue valueStr, onInput inputHandler ] []

workingDaysView : Language -> S.Set Day -> Html Msg
workingDaysView lang days =
  let
    dayView = \day -> workingDayView lang day (S.member day days)
    possibleDaysViews = L.map dayView WD.days
  in
    div [ class "settings_working-days" ] possibleDaysViews

workingDayView : Language -> Day -> Bool -> Html Msg
workingDayView lang day active =
  let
    dayName = t <| lang ++ ".days." ++ day
    classes = classList [("settings_working-day", True), ("m-active", active)]
  in
    div [ classes, onClick (TriggerWorkingDay day) ] [ text dayName ]

saveSettingsView : Language -> Bool -> Html Msg
saveSettingsView lang isValid =
  let
    content = t <| lang ++ ".settings.save"
    classes = classList [("settings_save", True), ("m-invalid", not isValid)]
    clickHandler = if isValid then SaveSettingsAndChangeRoute Counter else None
  in
    div [ classes, onClick clickHandler ] [ text content ]
