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

editSettingsView : Model -> Html Msg
editSettingsView model =
  div [ class "settings" ]
    [ workingTimesView model
    , workingDaysView model.lang model.workingDays
    , saveSettingsView model.lang
    ]

workingTimesView : Model -> Html Msg
workingTimesView model =
  let
    parseInput handler min max input =
      case St.toInt input of
        Ok value ->
          if value >= min && value <= max then handler value else None
        Err _ -> None
  in
    div [ class "settings_working-time" ]
      [ workingTimeView model.startHour (parseInput ChangeStartHour 0 23)
      , workingTimeView model.startMinute (parseInput ChangeStartMinute 0 59)
      , workingTimeView model.endHour (parseInput ChangeEndHour 0 23)
      , workingTimeView model.endMinute (parseInput ChangeEndMinute 0 59)
      ]

workingTimeView : Int -> (String -> Msg) -> Html Msg
workingTimeView value inputHandler =
  input [ type' "text", defaultValue (toString value), onInput inputHandler ] []

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

saveSettingsView : Language -> Html Msg
saveSettingsView lang =
  let
    content = t <| lang ++ ".settings.save"
  in
    div [ class "settings_save", onClick (SaveSettingsAndChangeRoute Counter) ] [ text content ]
