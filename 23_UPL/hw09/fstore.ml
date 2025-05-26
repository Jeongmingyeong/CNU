type t = (string * (string list * Ast.expr)) list

let empty : t = []

let rec find (s : string) (m : t) : (string list * Ast.expr) =
	match m with
	| [] -> failwith ("[Error] Unbound function: " ^ s)
	| (fst, snd) :: tl ->
		if s = fst then snd
		else find s tl	

let add (s : string) (l : string list) (e : Ast.expr) (m : t) : t =
	let tup = (s, (l, e)) in
	tup::(List.filter (fun (str, _) -> str <> s) m)
