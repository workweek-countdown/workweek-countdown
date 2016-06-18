module Weekend.EditSettings exposing (editSettingsView)

import List as L
import Set as S
import Date as D
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model)
import Weekend.Day as WD exposing (Day)
import Weekend.I18n exposing (t)

editSettingsView : (Day -> msg) -> Model -> Html msg
editSettingsView triggerDay model =
  div [ class "settings" ]
    [ workingDaysView model.settings.lang triggerDay model.settings.days
    ]

workingDaysView : String -> (Day -> msg) -> S.Set Day -> Html msg
workingDaysView lang triggerDay days =
  let
    dayView = \day -> workingDayView lang triggerDay day (S.member day days)
    possibleDaysViews = L.map dayView WD.days
  in
    div [ class "settings_working-days" ] possibleDaysViews

workingDayView : String -> (Day -> msg) -> Day -> Bool -> Html msg
workingDayView lang triggerDay day active =
  let
    dayName = t <| lang ++ ".days." ++ day
    classes = classList [("settings_working-day", True), ("m-active", active)]
  in
    div [ classes, onClick (triggerDay day) ] [ text dayName ]
