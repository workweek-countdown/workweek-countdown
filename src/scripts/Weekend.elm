module Weekend exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Set as S
import Date as D
import Time as T
import Weekend.Model exposing (Model, Settings, Route(..), Mode(..))
import Weekend.Day as WD exposing (Day)
import Weekend.Counter exposing (counterView)
import Weekend.EditSettings exposing (editSettingsView)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

defaultSettings : Settings
defaultSettings =
  Settings Countdown "en" (S.fromList [WD.mon, WD.tue, WD.wed, WD.thu, WD.fri])

init : (Model, Cmd Msg)
init =
  (Model Counter defaultSettings (D.fromTime 0), Cmd.none)

type Msg
  = ChangeRoute Route
  | ChangeMode Mode
  | TriggerDay Day
  | Tick T.Time

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    ChangeRoute newRoute ->
      ({ model | route = newRoute }, Cmd.none)

    ChangeMode newMode ->
      let
        { settings } = model
        newSettings = { settings | mode = newMode }
      in
        ({ model | settings = newSettings }, Cmd.none)

    TriggerDay day ->
      let
        { settings } = model
        { days } = settings
        newDays = (if S.member day days then S.remove else S.insert) day days
        newSettings = { settings | days = newDays }
      in
        ({ model | settings = newSettings }, Cmd.none)

    Tick newTime ->
      let
        newDate = D.fromTime newTime
      in
        ({ model | date = newDate }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  T.every (10 * T.millisecond) Tick

view : Model -> Html Msg
view model =
  let
    routeView = case model.route of
      Counter -> counterView ChangeMode
      EditSettings -> editSettingsView TriggerDay
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
