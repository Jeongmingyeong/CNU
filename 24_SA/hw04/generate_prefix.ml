let start_c = ref ' '

let rec gen (k: int) (acc: string list) : string list =
  let char_idx1 = Char.code !start_c + k in
  let char_idx2 = Char.code '~' - k in
  let char_idx3 = Char.code '}' - k in
  (* Format.printf "char_idx1: %d@." char_idx1; *)
  (* Format.printf "char_idx2: %d@." char_idx2; *)
  (* Format.printf "char_idx3: %d@." char_idx3; *)

  (* 조건에 따라 결과 리스트에 추가 *)
  let acc =
    if char_idx1 <= 126 && char_idx2 >= 32 then
      let c1 = Char.chr char_idx1 in
      let c2 = Char.chr char_idx2 in
      (Char.escaped c1 ^ Char.escaped c2) :: acc
    else acc
  in

  let acc =
    if char_idx1 <= 126 && char_idx3 >= 32 then
      let c1 = Char.chr char_idx1 in
      let c3 = Char.chr char_idx3 in
      (Char.escaped c1 ^ Char.escaped c3) :: acc
    else acc
  in

  (* 조건이 더 이상 만족하지 않으면 재귀 종료 *)
  if char_idx1 > 126 || char_idx2 < 32 || char_idx3 < 32 then acc
  else gen (k + 1) acc

(* crash 나는 글자 쌍 생성 *)
let generate_pairs () : (string list) list =
  let _ = start_c := '[' in
  let b1 = gen 0 [] in
  (* Format.printf "@."; *)
  (* List.iter (fun s -> Format.printf "%s " s) b1; *)
  (* Format.printf "@."; *)
  let _ = start_c := 'M' in
  let b2 = gen 0 [] in
  (* Format.printf "@."; *)
  (* List.iter (fun s -> Format.printf "%s " s) b2; *)
  (* Format.printf "@."; *)
  let _ = start_c := 'E' in
  let b3 = gen 0 [] in
  (* Format.printf "@."; *)
  (* List.iter (fun s -> Format.printf "%s " s) b3; *)
  (* Format.printf "@."; *)
  let _ = start_c := 'c' in
  let b4 = gen 0 [] in
  (* Format.printf "@."; *)
  (* List.iter (fun s -> Format.printf "%s " s) b4; *)
  (* Format.printf "@."; *)
  [b1; b2; b3; b4]

(* 결과 출력 *)
(* let g () = *)
(*   let pairs = generate_pairs () in *)
(*   List.iter print_endline pairs *)

