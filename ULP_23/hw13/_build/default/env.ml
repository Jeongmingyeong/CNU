type addr = int
type t = (string * addr) list

let empty : t = []

(* add : string -> addr -> t -> t *)
let add (s : string) (a : addr) (m : t) : t =
  let tup = (s, a) in
  tup::(List.filter (fun (str, _) -> str <> s) m)

(* find : string -> t -> addr *)
let rec find (s : string) (m : t) : addr =
  match m with
  | [] -> failwith ("[Error] Free identifier: " ^ s) 
  | hd::tl ->
    let fst, snd = hd in
      if s = fst then snd
      else find s tl 


(* let rec find (s : string) (m : t) : value =
  match m with
  | [] -> failwith ("[Error] Free identifier: " ^ s) 
  | hd::tl ->
    let fst, snd = hd in
      if s = fst then snd
      else find s tl 

let add (s : string) (v : value) (m : t) : t =
  let tup = (s, v) in
  tup::(List.filter (fun (str, _) -> str <> s) m)  *)