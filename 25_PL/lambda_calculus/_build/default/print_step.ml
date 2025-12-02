module F = Format

let convert_lambdaabs_to_churchconst (t: Ast.t) : string =
  let rec repeat_s n =
    if n <= 0 then ""
    else "s " ^ repeat_s (n - 1)
  in
  if Ast.equal t (ParserMain.parse "lambda x y -> x") then "tru"
  else if Ast.equal t (ParserMain.parse "lambda x y -> y") then "fls"
  else if Ast.equal t (ParserMain.parse "lambda c t f -> c t f") then "test"
  else if Ast.equal t (ParserMain.parse "lambda b c -> b c fls") then "and"
  else if Ast.equal t (ParserMain.parse "lambda b c -> b tru c") then "or"
  else if Ast.equal t (ParserMain.parse "lambda c -> c fls tru") then "not"
  else if Ast.equal t (ParserMain.parse "lambda f s b -> b f s") then "pair"
  else if Ast.equal t (ParserMain.parse "lambda p -> p tru") then "fst"
  else if Ast.equal t (ParserMain.parse "lambda p -> p fls") then "snd"
  else if Ast.equal t (ParserMain.parse "lambda m n s z -> m s (n s z)") then "add"
  else if Ast.equal t (ParserMain.parse "lambda m n -> m (add n) 0") then "times"
  else if Ast.equal t (ParserMain.parse "lambda m -> m (lambda x -> fls) tru") then "isZero"
  else if Ast.equal t (ParserMain.parse "pair 0 0") then "zz"
  else if Ast.equal t (ParserMain.parse "lambda p -> pair (snd p) (add 1 (snd p))") then "ss"
  else if Ast.equal t (ParserMain.parse "lambda m -> fst (m ss zz)") then "pred"
  else if Ast.equal t (ParserMain.parse "lambda m n -> n (lambda x -> isZero x) m") then "sub"
  else if Ast.equal t (ParserMain.parse "lambda m n -> (lambda x -> isZero x) (sub m n)") then "eq"
  else if Ast.equal t (ParserMain.parse "lambda x -> test (eq x 1) 1 (add x (sum (sub x 1)))") then "sum"
  else if Ast.equal t (ParserMain.parse "lambda f x -> test (eq x 1) 1 (add x (f (sub x 1)))") then "F"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 1 ^ "z")) then "1"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 2 ^ "z")) then "2"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 3 ^ "z")) then "3"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 4 ^ "z")) then "4"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 5 ^ "z")) then "5"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 6 ^ "z")) then "6"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 7 ^ "z")) then "7"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 8 ^ "z")) then "8"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 9 ^ "z")) then "9"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 10 ^ "z")) then "10"
  else if Ast.equal t (ParserMain.parse ("lambda s z -> " ^ repeat_s 11 ^ "z")) then "11"
  else failwith "cannot convert" 

let rec normalize_church (t: Ast.t) : Ast.t =
  let convert = convert_lambdaabs_to_churchconst in
  match t with
  | LambdaAbs (x, body) ->
      begin 
        try
          Ast.ChurchConst (convert t)
        with _ -> Ast.LambdaAbs (x, (normalize_church body))
      end
  | App (t1, t2) -> Ast.App ((normalize_church t1), (normalize_church t2))
  | _ -> t

let print (res : (Ast.t * bool) list) : unit = 
  let _ = List.iteri (fun n ((t : Ast.t), (is_expand : bool)) ->
    if n = 0 then F.printf "%a@." Ast.pp t
    else
      match is_expand with
      | true -> F.printf "= %a@." Ast.pp t 
      | false -> F.printf "->* %a@." Ast.pp t 
    ) res
  in 
  let _ = F.printf "@.=== final form ===@." in
  F.printf "%a@." Ast.pp (normalize_church (List.rev res |> List.hd |> fst))
