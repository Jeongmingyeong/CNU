let finish_step1 = ref false
let finish_step2 = ref false

(* random pick one from list *)
let random_pick (ls : 'a list) : 'a = 
  Random.int (List.length ls) |> List.nth ls

(* pick one based on derivation tree *)
let max_cost_pick (ls: string list) (exp_cost: (string * int) list) : string =
  if (List.exists (fun e -> List.length (Re.nonterminals e) = 0) ls) then (* terminal로만 바뀜*)
      random_pick ls
  else
    let rec find_max (term: string) (max_cost : int) (valid_terms: string list) : string =
      match valid_terms with 
      | [] -> term
      | hd::others ->
          let cost = try List.assoc hd exp_cost with Not_found -> 0 in
          if cost > max_cost then
            find_max hd cost others
          else
            find_max term max_cost others
    in
    find_max "" (-1) ls

let min_cost_pick (cur_nonterm: string) (rules: string list) : string =
  match cur_nonterm with
  | "<start>" -> "<string>"
  | "<string>" -> "<letter>"
  | "<letter>" -> Random.int 2 |> List.nth ["<other>"; "<plus>"] 
  | "<plus>" -> "+"
  | "<percent>" -> "%<hexdigit><hexdigit>"
  | _ -> random_pick rules 

(* choose one nonterminals from input nonterminal list *)
let choose_one (nonterminals: string list) : string = random_pick nonterminals

(* choose one rule from grammer *)
let choose_rules 
  (cur_nonterminal: string) (exp_cost: (string * int) list) : string =
    let rules : string list = Grammer.values cur_nonterminal in 
    if (not !finish_step1) then (* 논터미널 개수 증가하는 방향으로 expansion *)
      max_cost_pick rules exp_cost
    else if (!finish_step1 && (not !finish_step2)) then (* random expansion *)
      random_pick rules 
    else (* 논터미널 개수가 감소하는 방향으로 expansion *)
      min_cost_pick cur_nonterminal rules

(* expand function: change target to rule from expansion *)
let expand 
  (expansion: string) (target: string) (rule: string) (tree: Tree.t) : string * Tree.t =
  let exp = Str.regexp target in 
  (* record expansion history *)
  let _ = Grammer.add_to_eh (target, rule) in
  let change_str = Str.replace_first exp rule expansion in
  let change_tree = Tree.expand_one_step tree target rule in
  change_str, change_tree

(* check exist nonterminal in String *)
let exist_nonterminal (s: string) : bool =
  if (List.length (Re.nonterminals s)) = 0 then false else true

(* create string(fuzzer) *)
let fuzzer (symbol': string) (min': int) (max': int) : string =
  let expansion_cost = Grammer.expansion_cost in
  let root = Tree.root in
  finish_step1 := false;
  finish_step2 := false;
  let rec inner (symbol: string) (tree: Tree.t) : string =
    let non_terminals = Re.nonterminals symbol in
    let target_nonterminal = choose_one non_terminals in
    let rule = choose_rules target_nonterminal expansion_cost in
    let change_str, change_tree = expand symbol target_nonterminal rule tree in
    if (List.length (Re.nonterminals change_str)) >= min' then
      finish_step1 := true;
    if (List.length (Re.nonterminals change_str)) >= max' then
      finish_step2 := true;
    if (exist_nonterminal change_str) then inner change_str change_tree else change_str
  in inner symbol' root

