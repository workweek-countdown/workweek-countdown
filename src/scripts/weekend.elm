module Weekend exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Date as D
import Time as T
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
    case D.dayOfWeek newDate of
      D.Fri -> newDate
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
    delta = DEP.diff date (weekendStart date)
  in
    div [ class "countdown" ]
      [ countdownPartView (delta.day + 1)
      , countdownPartView (23 - delta.hour)
      , countdownPartView (59 - delta.minute)
      , countdownPartView (59 - delta.second)
      , countdownPartView (1000 - delta.millisecond)
      ]

countdownPartView : Int -> Html Msg
countdownPartView left =
  div [ class "countdown_part" ] [ text (toString left) ]
