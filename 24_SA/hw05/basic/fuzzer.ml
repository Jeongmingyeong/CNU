(* random pick one from list *)
let random_pick (ls : 'a list) : 'a = 
  Random.int (List.length ls) |> List.nth ls

(* choose one nonterminals from input nonterminal list *)
let choose_one (nonterminals: string list) : string = random_pick nonterminals

(* choose one rule from grammer *)
let choose_rules (cur_nonterminal: string) : string =
  let rules : string list = Grammer.values cur_nonterminal in 
  random_pick rules 

(* expand function: change target to rule from expansion *)
let expand (expansion: string) (target: string) (rule: string) : string =
  let exp = Str.regexp target in 
  (* record expansion history *)
  let _ = Grammer.add_to_eh (target, rule) in
  Str.replace_first exp rule expansion

(* check exist nonterminal in String *)
let exist_nonterminal (s: string) : bool =
  if (List.length (Re.nonterminals s)) = 0 then false else true

(* create string(fuzzer) *)
let rec fuzzer (symbol: string) : string =
  let non_terminals = Re.nonterminals symbol in
  let target_nonterminal = choose_one non_terminals in
  let rule = choose_rules target_nonterminal in
  let change_str = expand symbol target_nonterminal rule in
  if (exist_nonterminal change_str) then fuzzer change_str else change_str
