module Weekend.Percent exposing (percentView)

import Html exposing (..)
import Html.Attributes exposing (..)
import String as S
import Date as D
import Date.Extra.Core as DEC

percentView : D.Date -> D.Date -> Html msg
percentView now weekend =
  let
    left = (D.toTime weekend) - (D.toTime now)
    percent = left / (toFloat DEC.ticksAWeek) * 100
    content = percent |> toString |> S.left 9 |> S.padRight 9 '0'
  in
    div [ class "percent" ] [ text content ]
