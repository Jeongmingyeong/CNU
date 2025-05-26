let grammer: (string * (string list)) list = [
  ("<start>", ["<string>"]);
  ("<string>", ["<letter>"; "<letter><string>"]);
  ("<letter>", ["<plus>"; "<percent>"; "<other>"]);
  ("<plus>", ["+"]);
  ("<percent>", ["%<hexdigit><hexdigit>"]);
  ("<hexdigit>", ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"]);
  ("<other>", ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"])
]

let symbol_cost : (string * int) list = [
  ("<start>", 4);      (* <start> -> <string> -> <letter> -> <plus> -> "+" *)
  ("<string>", 3);     (* <string> -> <letter> -> <plus> -> "+" *)
  ("<letter>", 2);     (* <letter> -> <plus> -> "+" *)
  ("<plus>", 1);       (* <plus> -> "+" *)
  ("<percent>", 3);    (* <percent> -> %<hexdigit> -> "0" and <hexdigit> -> "0" *)
  ("<hexdigit>", 1);   (* <hexdigit> -> "0" *)
  ("<other>", 1);      (* <other> -> "0" *)
]

let calc_expansion_cost (symbols: string list) : int =
  List.fold_left (fun acc s -> acc + (List.assoc s symbol_cost)) 0 symbols 

let expansion_cost : (string * int) list =
  List.fold_left (fun acc (_, rhs) ->
    List.fold_left (fun acc' (symbol : string) ->
      try
        let _ = Str.search_forward Re.nonterminal_re symbol 0 in
        let symbols : string list = Re.nonterminals symbol in
        let exp_cost : int = calc_expansion_cost symbols in 
        acc' @ [(symbol, exp_cost)]
      with Not_found -> acc'
    ) acc rhs
  ) [] grammer

(* for expansion_history *)
module EhPair = struct
  type t = string * string (* from symbol, to symbol *)
  let compare = compare
end

module EhPairSet = Set.Make(EhPair)

let expansion_history = ref EhPairSet.empty
let init_eh () = expansion_history := EhPairSet.empty

let add_to_eh (elt : string * string) : unit =
  let new_set = EhPairSet.add elt !expansion_history in 
  expansion_history := new_set

let get_eh () = !expansion_history 

(* # of total expansion pair *)
let total_pair = List.fold_left (fun acc (_, rhs) ->
  acc + (List.length rhs)
) 0 grammer

(* find values mapping from key *)
let values (key: string) : string list = List.assoc key grammer
