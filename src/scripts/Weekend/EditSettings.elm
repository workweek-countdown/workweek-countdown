module Weekend.EditSettings exposing (editSettingsView)

import List as L
import Set as S
import Date as D
import String as St
import Maybe as M
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Route(..), WorkingTimeInput(..), Language)
import Weekend.Msg exposing (Msg(..))
import Weekend.Day as WD exposing (Day)
import Weekend.I18n exposing (t)

type alias TimeMsg = Maybe Int -> Msg

type WorkingTimeGroup
  = StartTimeGroup
  | EndTimeGroup

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
  div [ class "settings_working-time" ]
    [ workingTimeGroupView model StartTimeGroup
    , div [ class "settings_working-time-group-split" ] [ text "-" ]
    , workingTimeGroupView model EndTimeGroup
    ]

workingTimeGroupView : Model -> WorkingTimeGroup -> Html Msg
workingTimeGroupView model group =
  let
    { lang, startHour, startMinute, endHour, endMinute, activeWorkingTimeInput } = model

    (title, hourInputType, minuteInputType, hour, minute, changeHour, changeMinute) = case group of
      StartTimeGroup ->
        ( t (lang ++ ".settings.startTime")
        , StartHourInput
        , StartMinuteInput
        , startHour
        , startMinute
        , ChangeStartHour
        , ChangeStartMinute
        )
      EndTimeGroup ->
        ( t (lang ++ ".settings.endTime")
        , EndHourInput
        , EndMinuteInput
        , endHour
        , endMinute
        , ChangeEndHour
        , ChangeEndMinute
        )

    isActiveInput inputType =
      M.withDefault False <| M.map2 (==) activeWorkingTimeInput <| Just inputType

    parseInput handler input =
      case St.toInt input of
        Ok value -> handler <| Just value
        Err _ -> handler Nothing
  in
    div [ class "settings_working-time-group" ]
      [ div [ class "settings_working-time-title" ] [ text title ]
      , div [ class "settings_working-time-fields" ]
          [ workingTimeView hourInputType hour (isValidHour hour) (isActiveInput hourInputType) (parseInput changeHour)
          , div [ class "settings_working-time-separator" ] [ text ":" ]
          , workingTimeView minuteInputType minute (isValidMinute minute) (isActiveInput minuteInputType) (parseInput changeMinute)
          ]
      ]

workingTimeView : WorkingTimeInput -> Maybe Int -> Bool -> Bool -> (String -> Msg) -> Html Msg
workingTimeView inputType val isValid isActive inputHandler =
  let
    valueStr = case val of
      Just value ->
        if isActive then toString value else St.padLeft 2 '0' <| toString value
      Nothing -> ""
    classes = classList [("settings_working-time-field", True), ("m-invalid", not isValid)]
  in
    input
      [ type' "text"
      , classes
      , maxlength 2
      , attribute "inputmode" "numeric"
      , value valueStr
      , onInput inputHandler
      , onFocus (ChangeActiveWorkingTimeInput <| Just inputType)
      , onBlur (ChangeActiveWorkingTimeInput Nothing)
      ] []

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
