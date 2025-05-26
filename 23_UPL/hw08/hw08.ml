let add (e1 : Store.value) (e2 : Store.value) : Store.value =
	match e1, e2 with
	| Store.NumV n1, Store.NumV n2 -> Store.NumV (n1 + n2)

let sub (e1 : Store.value) (e2 : Store.value) : Store.value =
	match e1, e2 with
	| Store.NumV n1, Store.NumV n2 -> Store.NumV (n1 - n2)

let rec interp (e : Ast.expr) (s : Store.t) : Store.value = 
	match e with
	| Ast.Num n -> Store.NumV n
	| Ast.Id str -> Store.find str s
	| Ast.Add (e1, e2) -> add (interp e1 s) (interp e2 s)
	| Ast.Sub (e1, e2) -> sub (interp e1 s) (interp e2 s)
	| Ast.LetIn (str, e1, e2) -> 
		let m = Store.add str (interp e1 s) s in
		interp e2 m
