let rec interp (e : Ast.expr) (s : Store.t) : Store.value = 
	match e with
	| Ast.Num n -> Store.NumV n
	| Ast.Id str -> Store.find str s
	| Ast.Add (e1, e2) ->
		begin 
			match (interp e1 s), (interp e2 s) with
			| (Store.NumV n1), (Store.NumV n2) -> Store.NumV (n1 + n2)
			| _, _ -> failwith (Format.asprintf "[Error] Not a number: %a + %a" Ast.pp e1 Ast.pp e2)
		end
	| Ast.Sub (e1, e2) ->
		begin
			match (interp e1 s), (interp e2 s) with
			| (Store.NumV n1), (Store.NumV n2) -> Store.NumV (n1 - n2)
			| _, _ -> failwith (Format.asprintf "[Error] Not a number: %a + %a" Ast.pp e1 Ast.pp e2)
		end
	| Ast.LetIn (str, e1, e2) -> 
		let m = Store.add str (interp e1 s) s in
		interp e2 m 
	| Ast.Lambda (param, body) -> Store.ClosureV (param, body, s)
	| Ast.App (e1, e2) ->
		begin 
			match (interp e1 s) with
			| Store.ClosureV (str, e, mem) ->
				let v = interp e2 s in
				let new_mem = Store.add str v mem in
				interp e new_mem
			| _ -> failwith (Format.asprintf "[Error] Not a function: %a" Ast.pp e1)
		end
	| Ast.LessThan (e1, e2) ->
		begin 
			match (interp e1 s), (interp e2 s) with
			| (Store.NumV n1), (Store.NumV n2) -> 
				 if n1 < n2 then interp Ast.true_encoding s
				 else interp Ast.false_encoding s
			| _, _ -> failwith (Format.asprintf "[Error] Not a number: %a < %a" Ast.pp e1 Ast.pp e2)
		end			
