module Weekend.EditSettings exposing (editSettingsView)

import List as L
import Set as S
import Date as D
import Html exposing (..)
import Html.Attributes exposing (..)
import Weekend.Model exposing (Model)
import Weekend.Day as WD

editSettingsView : Model -> Html msg
editSettingsView model =
  div [ class "settings" ]
    [ workingDaysView model.settings.workingDays
    ]

workingDaysView : S.Set WD.Day -> Html msg
workingDaysView days =
  let
    possibleDaysViews = L.map (\day -> workingDayView day (S.member day days)) WD.days
  in
    div [ class "settings_working-days" ] possibleDaysViews

workingDayView : WD.Day -> Bool -> Html msg
workingDayView day active =
  label [ class "settings_working-day" ]
    [ input [ type' "checkbox", checked active ] []
    , span [] [ text (toString day) ]
    ]
