type t = (Env.addr * Value.t) list

let empty : t = []

(* add : Env.addr -> Value.t -> t -> t *)
let add (a : Env.addr) (v : Value.t) (m : t) : t =
  let tup = (a, v) in
  tup::(List.filter (fun (addr, _) -> addr <> a) m)

(* rec : Env.addr -> t -> Value.t *)
let rec find (a : Env.addr) (m : t) : Value.t =
	match m with
  | [] -> failwith ("[Error] Free address: " ^ (string_of_int a)) 
  | hd::tl ->
    let fst, snd = hd in
      if a = fst then snd
      else find a tl 



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