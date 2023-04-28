type value = NumV of int

type t = (string * value) list

let empty : t = []

let rec find (s : string) (m : t) : value =
	match m with
	| [] -> failwith ("[Error] Free identifier: " ^ s) 
	| hd::tl ->
		let fst, snd = hd in
			if s = fst then snd
			else find s tl 

let add (s : string) (v : value) (m : t) : t =
	let tup = (s, v) in
	tup::(List.filter (fun s -> s = (List.hd m)) m) 

