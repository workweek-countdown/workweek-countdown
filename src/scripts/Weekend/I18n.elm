module Weekend.I18n exposing (t)

import Dict as D
import Maybe as M
import String as S

type Tree
  = Node (D.Dict String Tree)
  | Leaf String

missing : List String -> String
missing path = "Translation missing: " ++ (toString path)

t : String -> String
t path = t' tree <| S.split "." path

t' : Tree -> List String -> String
t' tree path =
  case tree of
    Node dict ->
      case path of
        [] -> missing []
        head :: rest ->
          M.withDefault (missing (head :: rest)) <| M.map2 t' (D.get head dict) (Just rest)
    Leaf str ->
      case path of
        [] -> str
        _ -> missing path

node : List (String, Tree) -> Tree
node =
  D.fromList >> Node

leaf : String -> Tree
leaf = Leaf

tree : Tree
tree =
  node
    [ ("en", node
      [ ("days", node
        [ ("mon", leaf "Monday")
        , ("tue", leaf "Tuesday")
        , ("wed", leaf "Wednesday")
        , ("thu", leaf "Thursday")
        , ("fri", leaf "Friday")
        , ("sat", leaf "Saturday")
        , ("sun", leaf "Sunday")
        ] )
      , ("settings", node
        [ ("save", leaf "Save")
        ] )
      ] )
    ]
