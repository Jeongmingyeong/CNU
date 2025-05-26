let b1 = ref []
let b2 = ref []
let b3 = ref []
let b4 = ref []

let set_list () : unit =
  let total_ls = Generate_prefix.generate_pairs () in
  let _ = b1 := List.nth total_ls 0 in
  let _ = b2 := List.nth total_ls 1 in
  let _ = b3 := List.nth total_ls 2 in
  b4 := List.nth total_ls 3

let gen_input () : string =
  let fi = Random.int (List.length !b1) |> List.nth !b1 in
  (* Format.printf "b1: %d@." (List.length !b1); *)
  let se = Random.int (List.length !b2) |> List.nth !b2 in
  (* Format.printf "b2: %d@." (List.length !b2); *)
  let th = Random.int (List.length !b3) |> List.nth !b3 in
  (* Format.printf "b3: %d@." (List.length !b3); *)
  let fo = Random.int (List.length !b4) |> List.nth !b4 in
  (* Format.printf "b4: %d@." (List.length !b4); *)
  (fi ^ se ^ th ^ fo)

let () = set_list ()

