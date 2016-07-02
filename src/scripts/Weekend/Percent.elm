module Weekend.Percent exposing (percentView)

import Html exposing (..)
import Html.Attributes exposing (..)
import String as S
import Date as D
import Date.Extra.Core as DEC

digitsCount : Int
digitsCount = 9

percentView : Int -> D.Date -> D.Date -> Html msg
percentView workingDaysCount now weekend =
  let
    left = (D.toTime weekend) - (D.toTime now)
    percent = left / (toFloat <| workingDaysCount * DEC.ticksADay) * 100
    content = percent |> toString |> S.left digitsCount |> S.padRight digitsCount '0'
  in
    div [ class "percent" ] [ text content ]
