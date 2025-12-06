let rec interp_expr (e : Ast.expr) ((env, mem) : (Env.t * Memory.t)) : Value.t =
  let open Ast in
  match e with
  | Num n -> Value.NumV n
  | Ref str -> Value.AddrV (Env.find str env)
  | Id str ->
      let address = Env.find str env in 
      Memory.find address mem
  | Bool b -> Value.BoolV b
  | Add (e1, e2) ->
      begin 
        match (interp_expr e1 (env, mem)), (interp_expr e2 (env, mem)) with
        | (Value.NumV n1), (Value.NumV n2) -> Value.NumV (n1 + n2)
        | _, _ -> failwith (Format.asprintf "[Error] Not a number: %a + %a" pp_expr e1 pp_expr e2)
      end
  | Sub (e1, e2) ->
      begin 
        match (interp_expr e1 (env, mem)), (interp_expr e2 (env, mem)) with
        | (Value.NumV n1), (Value.NumV n2) -> Value.NumV (n1 - n2)
        | _, _ -> failwith (Format.asprintf "[Error] Not a number: %a - %a" pp_expr e1 pp_expr e2)
      end
  | Lt (e1, e2) ->
      begin 
        match (interp_expr e1 (env, mem)), (interp_expr e2 (env, mem)) with
        | (Value.NumV n1), (Value.NumV n2) -> Value.BoolV (n1 < n2)
        | _, _ -> failwith (Format.asprintf "[Error] Not a number: %a < %a" pp_expr e1 pp_expr e2)
      end			
  | Gt (e1, e2) ->
      begin 
        match (interp_expr e1 (env, mem)), (interp_expr e2 (env, mem)) with
        | (Value.NumV n1), (Value.NumV n2) -> Value.BoolV (n1 > n2)
        | _, _ -> failwith (Format.asprintf "[Error] Not a number: %a > %a" pp_expr e1 pp_expr e2)
      end	
  | Eq (e1, e2) ->
      let v1 = interp_expr e1 (env, mem) in
      let v2 = interp_expr e2 (env, mem) in
      BoolV (v1 = v2)
  | And (e1, e2) ->
      begin 
        match (interp_expr e1 (env, mem)), (interp_expr e2 (env, mem)) with
        | (Value.BoolV n1), (Value.BoolV n2) -> Value.BoolV (n1 && n2)
        | _, _ -> failwith (Format.asprintf "[Error] Not a boolean: %a && %a" pp_expr e1 pp_expr e2)
      end	 
  | Or (e1, e2) ->
      begin 
        match (interp_expr e1 (env, mem)), (interp_expr e2 (env, mem)) with
        | (Value.BoolV n1), (Value.BoolV n2) -> Value.BoolV (n1 || n2)
        | _, _ -> failwith (Format.asprintf "[Error] Not a boolean: %a || %a" pp_expr e1 pp_expr e2)
      end	


let rec interp_stmt (st : Ast.stmt) ((env, mem) : (Env.t * Memory.t)) : (Env.t * Memory.t) =
  let open Ast in
  match st with
  | DefStmt str -> 
      let update_env = Env.add str (AddrManager.new_addr ()) env in
      (update_env, mem)
  | StoreStmt (e1, e2) ->
      let address = interp_expr e1 (env, mem) in
      begin
        match address with
        | Value.AddrV a -> 
            let value = interp_expr e2 (env, mem) in
            let update_mem = Memory.add a value mem in
            (env, update_mem)
        | _ -> failwith (Format.asprintf "[Error] Not a address: %a" pp_expr e1)
      end
  | LoadStmt (str, e1) -> 
      let address = interp_expr e1 (env, mem) in
      begin
        match address with
        | Value.AddrV a -> 
            let lookup_x : Env.addr = Env.find str env in
            let lookup_a : Value.t = Memory.find a mem in 
            let update_mem = Memory.add lookup_x lookup_a mem in
            (env, update_mem)
        | _ -> failwith (Format.asprintf "[Error] Not a address: %a" pp_expr e1)
      end
  | IfStmt (e1, s1, s2) ->
      let condition = interp_expr e1 (env, mem) in
      begin 
        match condition with
        | Value.BoolV cond -> 
          if cond = true then
            let (_, update_mem) = interp_rec_stmt s1 (env, mem) in
            (env, update_mem)
          else
            let (_, update_mem) = interp_rec_stmt s2 (env, mem) in
            (env, update_mem)
        | _ -> failwith (Format.asprintf "[Error] Not a boolean: %a" pp_expr e1)
      end
  | LoopStmt (e1, s) ->
      let condition = interp_expr e1 (env, mem) in
      begin
        match condition with
        | Value.BoolV cond -> 
          if cond = true then
            let (_, first_mem) = interp_rec_stmt s (env, mem) in
            let (_, update_mem) = interp_stmt st (env, first_mem) in
            (env, update_mem)
          else (env, mem) 
        | _ -> failwith (Format.asprintf "[Error] Not a boolean: %a" pp_expr e1)   
      end
and interp_rec_stmt (l : Ast.stmt list) ((env, mem) : (Env.t * Memory.t)) : (Env.t * Memory.t) =
  match l with
  | [] -> (env, mem)
  | hd::tl -> 
      let (update_env, update_mem) = interp_stmt hd (env, mem) in
      interp_rec_stmt tl (update_env, update_mem)
    

let interp_prog (Program(stmt_list) : Ast.prog) : (Env.t * Memory.t) =
  let _ = AddrManager.init () in 
  interp_rec_stmt stmt_list (Env.empty, Memory.empty)
    