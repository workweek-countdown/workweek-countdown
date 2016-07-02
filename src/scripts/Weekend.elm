port module Weekend exposing (main)

import List as L
import Set as S
import Date as D
import Time as T
import Platform.Sub as Sub
import Update.Extra.Infix exposing ((:>))
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Weekend.Model exposing (Model, Route(..), Mode(..), defaultModel)
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
        workingDaysCount = S.size workingDays
        newWorkingDays = if S.member day workingDays then
          if workingDaysCount == 1 then workingDays else S.remove day workingDays
        else
          if workingDaysCount == (L.length WD.days) - 1 then workingDays else S.insert day workingDays
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

    SaveSettingsAndChangeRoute route ->
      model ! []
        :> update SaveSettings
        :> update (ChangeRoute route)

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
    div [ classes, onClick (ChangeRoute newRoute) ] []
