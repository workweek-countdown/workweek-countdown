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
      [ countdownPartView daysLeft 1
      , countdownPartView hoursLeft 2
      , countdownPartView minutesLeft 2
      , countdownPartView secondsLeft 2
      , countdownPartView millisecondsLeft 3
      ]

countdownPartView : Int -> Int -> Html msg
countdownPartView left digitsCount =
  let
    content = S.padLeft digitsCount '0' (toString left)
  in
    div [ class "countdown_part" ] [ text content ]
