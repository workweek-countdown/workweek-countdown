module Weekend exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import String as S
import Date as D
import Time as T
import Date.Extra.Core as DEC
import Date.Extra.Floor as DEF
import Date.Extra.Period as DEP

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { date : D.Date
  }

init : (Model, Cmd Msg)
init =
  (Model (D.fromTime 0), Cmd.none)

type Msg
  = Tick T.Time

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Tick newTime ->
      let
        newDate = D.fromTime newTime
      in
        ({ model | date = newDate }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  T.every (10 * T.millisecond) Tick

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
  div [ class "layout" ]
    [ div [ class "layout_body" ] [ countdownView model.date ]
    ]

countdownView : D.Date -> Html Msg
countdownView date =
  let
    left = (D.toTime (weekendStart date)) - (D.toTime date) |> truncate
    daysLeft = left // DEC.ticksADay
    hoursLeft = left % DEC.ticksADay // DEC.ticksAnHour
    minutesLeft = left % DEC.ticksAnHour // DEC.ticksAMinute
    secondsLeft = left % DEC.ticksAMinute // DEC.ticksASecond
    millisecondsLeft = left % DEC.ticksASecond
  in
    div [ class "countdown" ]
      [ countdownPartView daysLeft 1
      , countdownPartView hoursLeft 2
      , countdownPartView minutesLeft 2
      , countdownPartView secondsLeft 2
      , countdownPartView millisecondsLeft 3
      ]

countdownPartView : Int -> Int -> Html Msg
countdownPartView left digitsCount =
  let
    content = S.padLeft digitsCount '0' (toString left)
  in
    div [ class "countdown_part" ] [ text content ]
