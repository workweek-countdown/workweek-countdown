module Weekend exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List as L
import Date as D
import Time as T
import Date.Extra.Floor as DEF
import Date.Extra.Period as DEP
import Weekend.Countdown exposing (countdownView)
import Weekend.Percent exposing (percentView)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type Mode
  = Countdown
  | Percent

type alias Model =
  { mode : Mode
  , date : D.Date
  }

init : (Model, Cmd Msg)
init =
  (Model Countdown (D.fromTime 0), Cmd.none)

type Msg
  = ChangeMode Mode
  | Tick T.Time

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    ChangeMode newMode ->
      ({ model | mode = newMode }, Cmd.none)

    Tick newTime ->
      let
        newDate = D.fromTime newTime
      in
        ({ model | date = newDate }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  T.every T.millisecond Tick

weekendStartHour : Int
weekendStartHour = 19

weekendStartMinute : Int
weekendStartMinute = 0

shiftToNextFriday : D.Date -> D.Date
shiftToNextFriday date =
  let
    newDate = DEP.add DEP.Day 1 date
  in
    case D.dayOfWeek date of
      D.Fri ->
        let
          hour = D.hour date
          minute = D.minute date
        in
          if hour > weekendStartHour || (hour == weekendStartHour && minute > weekendStartMinute) then
            DEP.add DEP.Day 7 date
          else
            date
      _ -> shiftToNextFriday newDate

weekendStart : D.Date -> D.Date
weekendStart date =
  date
    |> shiftToNextFriday
    |> DEF.floor DEF.Day
    |> DEP.add DEP.Hour weekendStartHour
    |> DEP.add DEP.Minute weekendStartMinute

view : Model -> Html Msg
view model =
  let
    weekend = weekendStart model.date

    modeView = case model.mode of
      Countdown -> countdownView
      Percent -> percentView
  in
    div [ class "layout" ]
      [ div [ class "layout_body" ]
        [ modePickerView model.mode
        , modeView model.date weekend ]
      ]

modePickerView : Mode -> Html Msg
modePickerView current =
  let
    options = L.map(modePickerOptionView current) [Countdown, Percent]
  in
    div [ class "mode-picker" ] options

modePickerOptionView : Mode -> Mode -> Html Msg
modePickerOptionView current mode =
  let
    classes = classList [("mode-picker_option", True), ("m-current", current == mode)]
  in
    div [ classes, onClick (ChangeMode mode) ]
      [ text (toString mode) ]
