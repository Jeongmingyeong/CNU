let nonterminal_re: Str.regexp = Str.regexp "<[^<>]*>"

(* random pick one from list *)
let random_pick (ls : 'a list) : 'a = 
  Random.int (List.length ls) |> List.nth ls

(* type: Str.split_result *)
(* Text of string : 구분자가 아닌 string(= terminals) *)
(* Delim of string : 구분자 string(= nonterminals) *)

(* Str.split_result list를 입력으로 받아 nonterminal list 반환 함수 *)
let get_nonterminals (split_list: Str.split_result list) : string list =
  List.fold_left (fun acc e ->
    match e with
    | Str.Text _ -> acc
    | Str.Delim s -> acc @ [s]) [] split_list

(* get nonterminal *)
let nonterminals (expansions: string) : string list =
  Str.full_split nonterminal_re expansions |> get_nonterminals

(* choose one nonterminals from input nonterminal list *)
let choose_one (nonterminals: string list) : string = random_pick nonterminals

(* choose one rule from grammer *)
let choose_rules (cur_nonterminal: string) : string =
  let rules : string list = Grammer.values cur_nonterminal in 
  random_pick rules 

(* expand function: change target to rule from expansion *)
let expand (expansion: string) (target: string) (rule: string) : string =
  let exp = Str.regexp target in 
  Str.replace_first exp rule expansion

(* check exist nonterminal in String *)
let exist_nonterminal (s: string) : bool =
  if (List.length (nonterminals s)) = 0 then false else true


(* create string(fuzzer) *)
let rec fuzzer (symbol: string) : string =
  let non_terminals = nonterminals symbol in
  let target_nonterminal = choose_one non_terminals in
  let rule = choose_rules target_nonterminal in
  let change_str = expand symbol target_nonterminal rule in
  if (exist_nonterminal change_str) then fuzzer change_str else change_str

