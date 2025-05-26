type op =
  | ADD
  | SUB
  | MUL
  | DIV

type value =
  | Err
  | Int of int
  | Float of float

type expr =
  | E of op * expr * expr
  | V of value

let rec eval e =
  match e with
  | V n -> n
  | E (op, n1, n2) ->
      match op with
      | ADD ->
        begin 
	  match (eval n1), (eval n2) with
	  | _, Err
	  | Err, _ -> Err
	  | Int i1, Int i2 -> Int (i1 + i2)
	  | Int i1, Float f1 -> Float ((float_of_int i1) +. f1)
	  | Float f1, Int i1 -> Float (f1 +. (float_of_int i1))
	  | Float f1, Float f2 -> Float (f1 +. f2)
	end
      | SUB ->
        begin 
	  match (eval n1), (eval n2) with
	  | _, Err
	  | Err, _ -> Err
	  | Int i1, Int i2 -> Int (i1 - i2)
	  | Int i1, Float f1 -> Float ((float_of_int i1) -. f1)
	  | Float f1, Int i1 -> Float (f1 -. (float_of_int i1))
	  | Float f1, Float f2 -> Float (f1 -. f2)
	end
      | MUL ->
        begin
	  match (eval n1), (eval n2) with
	  | _, Err
	  | Err, _ -> Err
	  | Int i1, Int i2 -> Int (i1 * i2)
	  | Int i1, Float f1 -> Float ((float_of_int i1) *. f1)
	  | Float f1, Int i1 -> Float (f1 *. (float_of_int i1))
	  | Float f1, Float f2 -> Float (f1 *. f2)
	end
      | DIV ->
        begin
	  match (eval n1), (eval n2) with
	  | _, Err
	  | Err, _ 
	  | _,(Int 0)
	  | _, (Float 0.0) -> Err
	  | Int i1, Int i2 -> Int (i1 / i2)
	  | Int i1, Float f1 -> Float ((float_of_int i1) /. f1)
	  | Float f1, Int i1 -> Float (f1 /. (float_of_int i1))
	  | Float f1, Float f2 -> Float (f1 /. f2)
	end
