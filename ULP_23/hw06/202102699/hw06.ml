type op =
	| ADD | SUB | MUL | DIV

type value =
	| Int of int
	| Float of float
	| Err

type expr =
	| E of op * expr * expr
	| V of value

type token =
	| TL of string
	| TO of string

let rec to_token (l : string list) =
	match l with
	| [] -> []
	| hd::tl ->
		begin
		match Stdlib.int_of_string_opt hd with
		| None -> List.map (fun x -> TO x) [hd] @ to_token tl
		| Some _ -> List.map (fun x -> TL x) [hd] @ to_token tl
		end 

let to_postfix (l : token list) =
	let st = Stack.create () in
	let first = List.hd l in
	let other_list = List.tl l in
	let _ = Stack.push first st in
	let rec to_postfix' (l' : token list) =
		match l' with
		| [] -> st
		| TL hd1::tl ->
			let op = Stack.pop st in
			let _ = Stack.push (TL hd1) st in
			let _ = Stack.push op st in
			to_postfix' tl
		| TO hd2::tl ->
			let _ = Stack.push (TO hd2) st in
			to_postfix' tl
	in let sq = Stack.to_seq (to_postfix' other_list) in
	let lst = List.of_seq sq in
	List.rev lst			

let i2s (s : string) = int_of_string s

let parse (l : token list) =
	let st = Stack.create () in
	let rec parse' (l' : token list) =
		match l' with
		| [] -> st
		| TL hd1::tl -> 
			let _ = Stack.push (V (Int (i2s hd1))) st in
			parse' tl
		| TO hd2::tl ->
			let _ =
				let second = Stack.pop st in
				let first = Stack.pop st in
				begin
				match hd2 with
				| "+" -> Stack.push (E (ADD, first, second)) st
				| "-" -> Stack.push (E (SUB, first, second)) st
				| "*" -> Stack.push (E (MUL, first, second)) st
				| "/" -> Stack.push (E (DIV, first, second)) st
				| _ -> failwith "rejected"
				end
			in parse' tl
	in let sq = Stack.to_seq (parse' l) in
	let lst = List.of_seq sq in
	List.hd lst
