module F = Format

type t = 
  | Var of string
  | LambdaAbs of string * t
  | App of t * t
  | ChurchConst of string

let rec pp fmt t =
  match t with
    | Var x | ChurchConst x -> F.fprintf fmt "%s" x
    | LambdaAbs (x, t1) -> F.fprintf fmt "(λ%s.%a)" x pp t1
    | App (t1, t2) -> F.fprintf fmt "(%a %a)" pp t1 pp t2

let rec equal (a : t) (b : t) : bool =
  match a, b with
  | Var x, Var y -> x = y
  | LambdaAbs (x1, t1), LambdaAbs (x2, t2) ->
      x1 = x2 && equal t1 t2
  | App (f1, a1), App (f2, a2) ->
      equal f1 f2 && equal a1 a2
  | ChurchConst s1, ChurchConst s2 -> s1 = s2
  | _, _ -> false

