module Weekend.Countdown exposing (countdownView)

import Html exposing (..)
import Html.Attributes exposing (..)
import String as S
import Date as D
import Date.Extra.Core as DEC

countdownView : D.Date -> D.Date -> Html msg
countdownView now weekend =
  let
    left = (D.toTime weekend) - (D.toTime now) |> truncate
    daysLeft = left // DEC.ticksADay
    hoursLeft = left % DEC.ticksADay // DEC.ticksAnHour
    minutesLeft = left % DEC.ticksAnHour // DEC.ticksAMinute
    secondsLeft = left % DEC.ticksAMinute // DEC.ticksASecond
    millisecondsLeft = left % DEC.ticksASecond
  in
    div [ class "countdown" ]
      [ countdownPartView daysLeft 1 1
      , countdownPartView hoursLeft 2 2
      , countdownPartView minutesLeft 2 2
      , countdownPartView secondsLeft 2 2
      , countdownPartView millisecondsLeft 3 2
      ]

countdownPartView : Int -> Int -> Int -> Html msg
countdownPartView left total digitsCount =
  let
    content = left |> toString |> S.padLeft total '0' |> S.left digitsCount
  in
    div [ class "countdown_part" ] [ text content ]
