let add (e1 : Store.value) (e2 : Store.value) : Store.value =
	match e1, e2 with
	| Store.NumV n1, Store.NumV n2 -> Store.NumV (n1 + n2)

let sub (e1 : Store.value) (e2 : Store.value) : Store.value =
	match e1, e2 with
	| Store.NumV n1, Store.NumV n2 -> Store.NumV (n1 - n2)

let interp_def (FunDef (f, arg_list, b) : Ast.fundef) (fm : Fstore.t) : Fstore.t =
	Fstore.add f arg_list b fm

let rec interp_expr (e : Ast.expr) (fm : Fstore.t) (m : Store.t) : Store.value =
	match e with
	| Ast.Num n -> Store.NumV n
	| Ast.Id s -> Store.find s m
	| Ast.Add (e1, e2) -> add (interp_expr e1 fm m) (interp_expr e2 fm m)
	| Ast.Sub (e1, e2) -> sub (interp_expr e1 fm m) (interp_expr e2 fm m)
	| Ast.LetIn (str, e1, e2) ->
		let m' = Store.add str (interp_expr e1 fm m) m in
		interp_expr e2 fm m'
	| Ast.Call (str, e_l) ->
		let (arg_list, b) = Fstore.find str fm in
		if (List.length arg_list) = (List.length e_l) then
			let rec cal_arg (l : string list) (el : Ast.expr list) (local_m : Store.t) =
				match l, el with
				| (hd1::tl1), (hd2::tl2) ->
					let update_mem = Store.add hd1 (interp_expr hd2 fm m) local_m in
					cal_arg tl1 tl2 update_mem
				| _, _ -> local_m
				in 
				let memory = cal_arg arg_list e_l Store.empty in
						interp_expr b fm memory	
		else failwith "[Error] Unmatched the number of arguments" 

let interp_prog (Prog (f_d, e) : Ast.prog) : Store.value =
	let rec interp_rec_def (l : Ast.fundef list) (fm : Fstore.t) : Fstore.t =
		match l with
		| [] -> fm
		| hd::tl ->
			let mem = interp_def hd fm in
			interp_rec_def tl mem 
	in 
	let mem = interp_rec_def f_d Fstore.empty in 
	interp_expr e mem Store.empty
