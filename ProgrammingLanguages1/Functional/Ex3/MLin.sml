(* Binary operators *)
datatype bop = Plus | Minus | Mult
             | Or | And | Xor
             | Eq | Lt | Gt

(* Types *)
datatype typ = Bool                                (* Boolean Type *)
             | Int                                 (* Integer Type *)
             | Arrow of typ * typ                  (* Function Type *)

(* Expressions *)
datatype expr = IntLit of int                      (* Integer Literals *)
              | BoolLit of bool                    (* Boolean Literals *)
              | Bop of bop * expr * expr           (* Binary Operators *)
              | ITE of expr * expr * expr          (* If-then-else expressions *)
              | LetIn of string * expr * expr      (* Let-in expressions *)
              | Var of string                      (* Variables *)
              | Fun of string * typ * expr         (* Anonymous Functions *)
              | App of expr * expr                 (* Function Applications *)

(* Environments as association lists *)
type 'a env = (string * 'a) list

(* Values *)
datatype value = VInt of int                       (* Integer Values *)
               | VBool of bool                     (* Boolean Values *)
               | VClo of value env * string * expr (* Closures *)

exception TypeError of string
exception RunTimeError of string
exception Unimplemented of string

(* Interface for environments *)

(* This function should return an empty env (i think) *)
fun empty () : 'a env = []

(* The look up function should go though every element of env until it finds the
* value x and returns its SOME value or returns NONE
* the value is of type VINT, VBool or Vclo (as defined above)*)
fun lookup (x : string) [] = NONE
  | lookup (x : string) ((name,value)::e : 'a env) : 'a option =
        if x = name then SOME value else lookup x e 

(* The insert function is used to insert values into the env *)
fun insert (x : string) (v : 'a) (e : 'a env) : 'a env =
  (x,v) :: e (* Note here that by not checking we allow shadowing (like in SML) *)
         
(* Type checker *)
(* The type checker should go though every node of the AST and check if there
* expression are of the correct datatype *)
fun typeCheck (e : typ env) (exp : expr) : typ =
  case exp of
    IntLit _ => Int
  | BoolLit _ => Bool
  | Bop(bop,expr1,expr2) => 
    let
      val t1 = typeCheck e expr1
      val t2 = typeCheck e expr2 
    in
      case bop of
           (Plus | Minus | Mult) =>
              if t1 = Int andalso t2 = Int then Int
              else raise TypeError ("Expected Integers for arithmetic equations")
         | (Lt| Gt| Eq) =>
              if t1 = Int andalso t2 = Int then Bool
              else raise TypeError ("Expected Integers for arithmetic equations")
         | (And| Or| Xor) =>
              if t1 = Bool andalso t2 = Bool then Bool
              else raise TypeError ("Expected Integers for arithmetic equations")
end
  | ITE (cond,expr1,expr2) =>
      let
        val vCond = typeCheck e cond
        val t1 = typeCheck e expr1
        val t2 = typeCheck e expr2
      in
        if vCond = Bool andalso t1 = t2 then t1 else raise TypeError "The expretions must be of the same type" 
      end
  (* In the LetIn I need to create the new enviroment that the second expretion
  * will be checked in *)
  | LetIn (name,expr1,expr2) =>
    let
      val t1 = typeCheck e expr1
      val newEnv = insert name t1 e
      val t2 = typeCheck newEnv expr2
    in
      t2
    end
  (*For the Var I need to look up the enc and return the type of the Var *)
  | Var name =>
    let
      val t = lookup name e
    in
      case t of
       SOME typ => typ
     | NONE => raise TypeError ("Unbound varaible: " ^ name)
    end
  (* Fun example: x : int => x+1 *)
  (* I have to create a new enviroment with the new parameters and check the new
  * expr *)
  (* The Fun returns an Arrow type of parameter Type -> return type *)
  | Fun (param,paramType,expr) =>
    let
      val newEnv = insert param paramType e
      val bodyType = typeCheck newEnv expr
    in
      Arrow(paramType,bodyType)
    end
  (* The Application of the function take 2 expretions: 
  * e1 -> The function name ( By doing a typeCheck on the function name should
  * return the Arrow of the function
  * e2 -> The argument expretion
  * The Type checker needs to check that the return of the rrow matches the
  * return of the body *)
  | App (arrow,body) =>
      let
        val t1 = typeCheck e arrow
        val t2 = typeCheck e body
      in
        case t1 of
             Arrow(argType,returnType) => 
                if argType = t2 then returnType
                else raise TypeError ("Unexpected argument type")
            | _ => raise TypeError("Expected a function")
      end

  
(* Interpreter *)
(* The eval should go though every node of the AST and evaluate the result 
*  according to the semantics defined above. It should return the final solution *)
fun eval (e: value env) (exp : expr) : value =
  case exp of
       IntLit n => VInt n
     | BoolLit b => VBool b
     | Bop (bop,expr1,expr2) =>
       let
         val v1 = eval e expr1
         val v2 = eval e expr2 
       in
         case (bop, v1, v2) of
              (Plus, VInt n1,VInt n2)  => VInt  (n1 + n2)
            | (Minus, VInt n1,VInt n2) => VInt  (n1 - n2)
            | (Mult, VInt n1,VInt n2)  => VInt  (n1 * n2)
            | (Gt,VInt n1, VInt n2)    => VBool (n1 > n2)
            | (Lt,VInt n1, VInt n2)    => VBool (n1 < n2)
            | (Eq,VInt n1, VInt n2)    => VBool (n1 = n2)
            | (And,VBool b1, VBool b2) => VBool (b1 andalso b2)
            | (Or, VBool b1, VBool b2) => VBool (b1 orelse b2)
            | (Xor,VBool b1, VBool b2) => VBool (b1 <> b2)
       end
     | ITE(cond,expr1,expr2) =>
         let
            val vCond  = eval e cond
          in
            if vCond = VBool true then eval e expr1 else eval e expr2
          end
     | LetIn(name,expr1,expr2) =>
         let
            val value = eval e expr1
            val newEnv= insert name value e
         in
            eval newEnv expr2
         end
    | Var name => 
        (case lookup name e of
             SOME v => v
           | NONE   => raise RunTimeError("Unbound variable"))
    | Fun (param,_,body) =>
        VClo(e,param,body)
    | App(funExpr,argExpr) =>
      case eval e funExpr of
           VClo(savedEnv,param,body) =>
            let       
              val vArg = eval e argExpr
              val newEnv = insert param vArg savedEnv
            in
              eval newEnv body
            end
          | _ => raise RunTimeError ("Expected funtion")



