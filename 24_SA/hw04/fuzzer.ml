(* index list: ascii 접근을 위함. (ocaml 에서 random range는 5.2부터 지원) *)
(* 접근하려고 하는 32번부터 126번까지 숫자를 저장 *)
let index_list = 
  let rec inner acc k = 
    if (k > 126) then acc
    else inner (List.append acc [k]) (k+1)
  in
  inner [] 32

let num_of_index = List.length index_list

(* replace "\n" to " " *)
let rep_new_line (r: string) : string =
  String.fold_left (fun res c -> if (c = '\n') then res ^ " " else res ^ (String.make 1 c)) "" r

(* command 실행 결과 중 true distance와 실행 결과 정보 가져오는 함수 *)
let get_print_info (print_res : string) : string list =
  let split_str = rep_new_line print_res |> String.split_on_char ' ' |> List.filter (fun s -> s <> "\t") in
  let b1_t_d = List.nth split_str 3 in
  let b2_t_d = List.nth split_str 9 in
  let b3_t_d = List.nth split_str 15 in
  let b4_t_d = List.nth split_str 21 in
  let result = List.nth split_str 24 in (* this is "It's" or "Assertion" *)
  [b1_t_d; b2_t_d; b3_t_d; b4_t_d; result]

(* random 한 문자 생성하는 함수 *)
let get_random_char () : string =
  Random.int num_of_index |> List.nth index_list |> Char.chr |> Char.escaped 
  
(* 8글자 random string 생성 *)
let rec random_string (res: string) : string =
  if ((String.length res) >= 8) then res
  else
    let new_char = get_random_char () in
    random_string (res ^ new_char)

(* 이웃 string 생성하는 함수 *)
(* 8글자 string에서 각 자리별 random하게 변화 => 총 8개 neighbor *)
let rec neighbor_string (original_string : string) (res_ls : string list) : string list =
  let rec mutation (s: string) (idx: int) : string =
    let left_str = String.sub s 0 idx in
    let change_char = get_random_char () in
    let start = idx + 1 in
    let right_str = String.sub s start ((String.length s) - start) in
    left_str ^ change_char ^ right_str
  in
  let res = List.append res_ls [mutation original_string (List.length res_ls)] in
  if ((List.length res) = (String.length original_string)) then res
  else neighbor_string original_string res

(* distance normalize *)
let dist_norm (dist: int) (k : float) : float =
  let dist = Float.of_int dist in
  dist /. (dist +. k)

(* calculate distance function *)
let calc_dist (run_result: string) : float =
  let print_info_without_result = get_print_info run_result |> List.rev |> List.tl in
  List.fold_left (fun acc d -> acc +. (dist_norm (int_of_string d) 0.5)) 0.0 print_info_without_result

(* choose new input string *)
(* dist_list -> new_string *)
let choose_new_str (dist_ls : (float * string) list) : string =
  let rec choose (ls: (float * string) list) (res: string) (d: float) : string = 
    match ls with
    | [] -> res
    | (dist, input)::others ->
        if dist < d then choose others input dist
        else choose others res d
  in choose dist_ls "" (Float.max_float)

(* check crash or not *)
let check_crash (res: string) : bool =
  let l = get_print_info res in
  (* let r = List.nth l 4 in *)
  (* Format.printf "%s@." r; *)
  if ((List.nth l 4) <> "It's") then true else false 



