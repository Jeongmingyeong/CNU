(* About regular expression *)
let nonterminal_re: Str.regexp = Str.regexp "<[^<>]*>"

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
