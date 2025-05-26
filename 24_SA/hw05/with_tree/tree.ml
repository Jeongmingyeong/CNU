(* about Derivation tree *)
(* Some [] : terminal *)
(* Some [node list] : node list로 치환된 nonterminal *)
(* None : 아직 expand되지 않은 nonterminal *)
type t = Node of string * t list option (* symbol_name, children *)

let root : t = Node ("<start>", None)

let create_children (rule: string) : t list option =
  (* check rule is terminal?(false) non-terminal?(true) *)
  if (Re.check_symbol_is_nonterm rule) then Some [Node (rule, None)] 
  else Some [Node (rule, Some [])]  

(* expand one in tree *)  
let expand_one_step (tree: t) (target: string) (rule: string) : t =
  let check_find = ref false in
  let rec inner_replace (tree': t) : t =
    match tree' with
    | Node (s, None) when (s = target && not !check_find) -> (* cur node match *)
        check_find := true;
        Node (s, (create_children rule))
    | Node (s, Some children) -> (* 현재 node에는 match 되지 않지만, 자식이 있는 경우 *)
        let new_children = List.map (fun child -> inner_replace child) children in
        Node (s, Some new_children)
    | _ -> (* otherwise: 그대로 반환 *)
        tree'
  in inner_replace tree

let cardinal_nonterm (tree: t) : int =
  let rec num_of_nonterm (acc: int) (tree' : t) : int =
    match tree' with
    | Node (s, None) -> acc + (List.length (Re.nonterminals s))
    | Node (s, Some children) ->
        let new_acc = acc + (List.length (Re.nonterminals s)) in
        List.fold_left (fun acc' child -> num_of_nonterm acc' child) new_acc children
  in 
  num_of_nonterm 0 tree

