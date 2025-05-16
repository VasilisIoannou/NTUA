(* Load the definitions from MLin.sml *)
use "MLin.sml";

type testCase = {
  name           : string,
  exp            : expr,
  expectedType   : typ,
  expectedValue  : value
};

(* Some simple tests. You can extend this list with your own tests. *)
val tests = [
  {
    name          = "Test 1: let z = 42 in if x > 5 then z - 20 else z + 1",
    exp           =
      LetIn ("z", IntLit 42,
        LetIn ("x", IntLit 6,
          ITE(
            Bop (Gt, Var "x", IntLit 5),    
            Bop (Minus, Var "z", IntLit 20),
            Bop (Plus,  Var "z", IntLit 1)
          )
        )
      ),
    expectedType  = Int,
    expectedValue = VInt 22  
  },
  {
    name          = "Test2: let x = 10 in x + 5",
    exp           =
      LetIn ("x", IntLit 10,
        Bop (Plus, Var "x", IntLit 5)
      ),
    expectedType  = Int,
    expectedValue = VInt 15  
  },
  {
    name          = "Test3: let foo = fun x => if x = 0 then 0 else x + 2 in foo 40 - foo 0",
    exp           =
      LetIn ("foo",
        Fun ("x", Int,
          ITE(
            Bop (Eq, Var "x", IntLit 0),
            IntLit 0,
            Bop (Plus, Var "x", IntLit 2)
          )
        ),
        Bop (Minus,
          App (Var "foo", IntLit 40),
          App (Var "foo", IntLit 0)
        )
      ),
    expectedType  = Int,
    expectedValue = VInt 42
  },
  {
    name          = "Test4: let x = true in let z = if x then 10 else 20 in let bar = fun y => 2*y in bar z",
    exp           =
      LetIn ("x", BoolLit true,
        LetIn ("z",
          ITE (Var "x", IntLit 10, IntLit 20),
          LetIn ("bar",
            Fun ("y", Int, Bop (Mult, IntLit 2, Var "y")),
            App (Var "bar", Var "z")
          )
        )
      ),
    expectedType  = Int,
    expectedValue = VInt 20
  }
];

fun assert (name : string) (condition : bool) =
  if condition then
    print (name ^ " -- PASS\n")
  else
    print (name ^ " -- FAIL\n");

(* Run one test: check type, then eval result. *)
fun runTest (t : testCase) : unit =
  let 
    val actualTy  = typeCheck [] (#exp t)
    val actualVal = eval [] (#exp t) 
  in
    assert (#name t ^ " (type)")  (actualTy = #expectedType t);
    assert (#name t ^ " (value)") (actualVal = #expectedValue t)
  end

(* Runs all tests in the batch *)
fun runAllTests () = List.app runTest tests;

(* Finally, run all tests! *)
val _ = runAllTests ();
