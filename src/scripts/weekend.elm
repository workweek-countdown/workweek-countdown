module Weekend exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Date as D
import Time as T

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { time : T.Time
  }

init : (Model, Cmd Msg)
init =
  (Model 0, Cmd.none)

type Msg
  = Tick T.Time

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Tick newTime ->
      ({ model | time = newTime }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  T.every (10 * T.millisecond) Tick

millisecondsInWeek : T.Time
millisecondsInWeek = 604800000

weekendStartHour : Float
weekendStartHour = 19

weekendStartMinute : Float
weekendStartMinute = 0

daysTillFriday : D.Day -> Int
daysTillFriday day =
  case day of
    D.Thu -> 1
    D.Fri -> 1
    _ -> 8

weekendStart : T.Time -> T.Time
weekendStart time =
  let
    totalWeeks = time / millisecondsInWeek |> floor |> toFloat
    daysLeft = time |> D.fromTime |> D.dayOfWeek |> daysTillFriday |> toFloat
  in
    totalWeeks * millisecondsInWeek
      + daysLeft * 24 * T.hour
      + weekendStartHour * T.hour
      + weekendStartMinute * T.minute

tillWeekend : T.Time -> T.Time
tillWeekend time =
  (weekendStart time) - time

view : Model -> Html Msg
view model =
  div [ class "layout" ]
    [ div [ class "layout_body" ] [ countdownView model.time ]
    ]

countdownView : T.Time -> Html Msg
countdownView time =
  let
    left = tillWeekend time |> truncate
    daysLeft = left // (truncate (24 * T.hour))
    hoursLeft = left % (truncate (24 * T.hour)) // (truncate T.hour)
    minutesLeft = left % (truncate T.hour) // (truncate T.minute)
    secondsLeft = left % (truncate T.minute) // (truncate T.second)
    millisecondsLeft = left % (truncate T.second)
  in
    div [ class "countdown" ]
      [ countdownPartView daysLeft
      , countdownPartView hoursLeft
      , countdownPartView minutesLeft
      , countdownPartView secondsLeft
      , countdownPartView millisecondsLeft
      ]

countdownPartView : Int -> Html Msg
countdownPartView left =
  div [ class "countdown_part" ] [ text (toString left) ]
