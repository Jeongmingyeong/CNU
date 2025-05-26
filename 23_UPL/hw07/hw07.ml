module F = Format

let add (e1 : Value.t) (e2 : Value.t) : Value.t = 
	match e1, e2 with
	|NumV n1, NumV n2 -> NumV (n1 + n2)

let sub (e1 : Value.t) (e2 : Value.t) : Value.t =
	match e1, e2 with
	|NumV n1, NumV n2 -> NumV (n1 - n2)

let rec interp (e : Ast.expr) :Value.t =
	match e with
	| Ast.Num n -> NumV n
	| Ast.Add (e1, e2) -> add (interp e1) (interp e2)
	| Ast.Sub (e1, e2) -> sub (interp e1) (interp e2)

