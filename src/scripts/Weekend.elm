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
  { route = Counter
  , mode = Countdown
  , lang = "en"
  , workingDays = (S.fromList [WD.mon, WD.tue, WD.wed, WD.thu, WD.fri])
  , startHour = 9
  , startMinute = 0
  , endHour = 18
  , endMinute = 0
  , date = (D.fromTime 0)
  }

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
        { workingDays } = model
        newWorkingDays = if S.member day workingDays then
          if S.size workingDays == 1 then workingDays else S.remove day workingDays
        else
          S.insert day workingDays
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
    (newRoute, mod) = case route of
      Counter -> (EditSettings, "edit-settings")
      EditSettings -> (Counter, "counter")
    classes = classList [("settings-trigger", True), ("m-" ++ mod, True)]
  in
    div [ class classes, onClick (ChangeRoute newRoute) ] []
