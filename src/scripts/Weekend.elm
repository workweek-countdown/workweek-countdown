module Weekend exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Date as D
import Time as T
import Date.Extra.Floor as DEF
import Date.Extra.Period as DEP
import Weekend.Countdown exposing (countdownView)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type Mode
  = Countdown

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

shiftToFriday : D.Date -> D.Date
shiftToFriday date =
  let
    newDate = DEP.add DEP.Day 1 date
  in
    case D.dayOfWeek date of
      D.Fri -> date
      _ -> shiftToFriday newDate

weekendStart : D.Date -> D.Date
weekendStart date =
  date
    |> shiftToFriday
    |> DEF.floor DEF.Day
    |> DEP.add DEP.Hour weekendStartHour
    |> DEP.add DEP.Minute weekendStartMinute

view : Model -> Html Msg
view model =
  let
    weekend = weekendStart model.date
  in
    div [ class "layout" ]
      [ div [ class "layout_body" ] [ countdownView model.date weekend ]
      ]
