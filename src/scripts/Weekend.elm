port module Weekend exposing (main)

import Set as S
import Date as D
import Time as T
import Platform.Sub as Sub
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Route(..), Mode(..))
import Weekend.Settings exposing (Settings, fromModel, applySettings)
import Weekend.Msg exposing (Msg(..))
import Weekend.Day as WD
import Weekend.Counter exposing (counterView)
import Weekend.EditSettings exposing (editSettingsView)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

defaultModel : Model
defaultModel =
  Model Counter Countdown "en" (S.fromList [WD.mon, WD.tue, WD.wed, WD.thu, WD.fri]) 9 0 18 0 (D.fromTime 0)

init : (Model, Cmd Msg)
init =
  (defaultModel, loadSettings ())

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    None ->
      (model, Cmd.none)

    ChangeRoute newRoute ->
      ({ model | route = newRoute }, Cmd.none)

    ChangeMode newMode ->
      let
        newModel = { model | mode = newMode }
      in
        (newModel, saveSettings (fromModel newModel))

    TriggerWorkingDay day ->
      let
        newWorkingDays = (if S.member day model.workingDays then S.remove else S.insert) day model.workingDays
      in
        ({ model | workingDays = newWorkingDays }, Cmd.none)

    ChangeStartHour newStartHour ->
      ({ model | startHour = newStartHour }, Cmd.none)

    ChangeEndHour newEndHour ->
      ({ model | endHour = newEndHour }, Cmd.none)

    ChangeStartMinute newStartMinute ->
      ({ model | startMinute = newStartMinute }, Cmd.none)

    ChangeEndMinute newEndMinute ->
      ({ model | endMinute = newEndMinute }, Cmd.none)

    ApplySettings settings ->
      (applySettings model settings, Cmd.none)

    SaveSettings ->
      (model, saveSettings (fromModel model))

    Tick newTime ->
      let
        newDate = D.fromTime newTime
      in
        ({ model | date = newDate }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ T.every (10 * T.millisecond) Tick
    , settings ApplySettings
    ]

port loadSettings : () -> Cmd msg
port saveSettings : Settings -> Cmd msg
port settings : (Settings -> msg) -> Sub msg

view : Model -> Html Msg
view model =
  let
    routeView = case model.route of
      Counter -> counterView
      EditSettings -> editSettingsView
  in
    div [ class "layout" ]
      [ div [ class "layout_body" ]
        [ routeView model
        , settingsTriggerView model.route
        ]
      ]

settingsTriggerView : Route -> Html Msg
settingsTriggerView route =
  let
    (newRoute, content) = case route of
      Counter -> (EditSettings, "settings")
      EditSettings -> (Counter, "close")
  in
    div [ class "settings-trigger", onClick (ChangeRoute newRoute) ]
      [ text content ]
