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

type alias TimeMsg = Maybe Int -> Msg

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
    [ titleView model.lang
    , fieldsView model
    , saveSettingsView model.lang (isValidTime model)
    ]

titleView : Language -> Html Msg
titleView lang =
  let
    content = t <| lang ++ ".settings.title"
  in
    div [ class "settings_title" ] [ text content ]

fieldsView : Model -> Html Msg
fieldsView model =
  div [ class "settings_fields" ]
    [ fieldsPartView (workingDaysView model.lang model.workingDays)
    , fieldsPartView (workingTimesView model)
    ]

fieldsPartView : Html Msg -> Html Msg
fieldsPartView fields =
  div [ class "settings_fields-part" ] [ fields ]

workingTimesView : Model -> Html Msg
workingTimesView model =
  let
    { lang, startHour, startMinute, endHour, endMinute } = model
    startTimeTitle = t <| lang ++ ".settings.startTime"
    endTimeTitle = t <| lang ++ ".settings.endTime"
  in
    div [ class "settings_working-time" ]
      [ workingTimeGroupView startTimeTitle startHour startMinute ChangeStartHour ChangeStartMinute
      , div [ class "settings_working-time-group-split" ] [ text "-" ]
      , workingTimeGroupView endTimeTitle endHour endMinute ChangeEndHour ChangeEndMinute
      ]

workingTimeGroupView : String -> Maybe Int -> Maybe Int -> TimeMsg -> TimeMsg -> Html Msg
workingTimeGroupView title hour minute changeHour changeMinute =
  let
    parseInput handler input =
      case St.toInt input of
        Ok value -> handler <| Just value
        Err _ -> handler Nothing
  in
    div [ class "settings_working-time-group" ]
      [ div [ class "settings_working-time-title" ] [ text title ]
      , div [ class "settings_working-time-fields" ]
          [ workingTimeView hour (isValidHour hour) (parseInput changeHour)
          , text ":"
          , workingTimeView minute (isValidMinute minute) (parseInput changeMinute)
          ]
      ]

workingTimeView : Maybe Int -> Bool -> (String -> Msg) -> Html Msg
workingTimeView value isValid inputHandler =
  let
    valueStr = case value of
      Just val -> toString val
      Nothing -> ""
    classes = classList [("settings_working-time-field", True), ("m-invalid", not isValid)]
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
