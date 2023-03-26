let rec len l =
  match l with
  | [] -> 0
  | _::tl -> 1 + (len tl)

let rec rev l =
  match l with
  | [] -> []
  | hd::tl -> (rev tl) @ [hd]

let rec map f l =
  match l with 
  | [] -> []
  | hd::tl -> (f hd) :: (map f tl)

let rec fold_right f a l =
  match l with
  | [] -> a
  | hd::tl -> f (hd, (fold_right f a tl))

