type op = ADD | SUB | MUL | DIV

type value = 
  | Int of int
  | Float of float
  | Err

type expr = 
  | E of op * expr * expr
  | V of value

type state =
  | Q0 | Q1 | Q2 | Q3 | Q4 | Q5

let transfer (s : state) (c : char) =
    match s, c with
    | Q0, '0'..'9' -> Q1
    | Q1, '+' -> Q2
    | Q1, '-' -> Q3
    | Q1, '*' -> Q4
    | Q1, '/' -> Q5
    | Q1, '0'..'9' | Q2, '0'..'9' | Q3, '0'..'9'
    | Q4, '0'..'9' | Q5, '0'..'9' -> Q1
    | _, _ -> failwith "rejected"

let lex (s:string) =
    let char_list = List.of_seq (String.to_seq s) in
	let rec lex_list (s : state) (l :char list) =
	    match s, l with
	    | Q0, [] -> failwith "rejected"
	    | Q1, [] -> true
	    | _, hd::tl -> lex_list (transfer s hd) tl
	    | _, [] -> failwith "rejected"
	in
	lex_list Q0 char_list

let c2s (c : char) : string = String.make 1 c

let tokenize (s:string) : string list =
    let c_list = List.of_seq (String.to_seq s) in
    let rec tokenize' char_list state str str_list =
        match char_list, state with
        | [], Q0 -> failwith "rejected"
        | [], Q1 -> str_list @ [str]
        | hd::tl, Q0 -> tokenize' tl (transfer state hd) (c2s hd) str_list
        | hd::tl, _ -> 
            if state = (transfer state hd) then 
            tokenize' tl (transfer state hd) (str ^ (c2s hd)) str_list
            else tokenize' tl (transfer state hd) (c2s hd) (str_list @ [str])
        | [], _ -> failwith "rejected"
        in tokenize' c_list Q0 "" []

let i2s (s : string) = int_of_string s

let lex_to_expr (s : string) : expr =
    let token_list = tokenize s in
	let rec lex_to_expr' (l : string list) =
	    match l with
	    | hd::"+"::tl -> E(ADD, V(Int (i2s hd)), (lex_to_expr' tl))
	    | hd::"-"::tl -> E(SUB, V(Int (i2s hd)), (lex_to_expr' tl))
	    | hd::"*"::tl -> E(MUL, V(Int (i2s hd)), (lex_to_expr' tl))
	    | hd::"/"::tl -> E(MUL, V(Int (i2s hd)), (lex_to_expr' tl))
	    | hd::_ -> V(Int (i2s hd))
        | [] -> failwith "rejected"
	in lex_to_expr' token_list
	    
