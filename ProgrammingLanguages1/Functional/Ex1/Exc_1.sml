

fun rain fileName = 
let
	val inStream = TextIO.openIn fileName
        val firstLine = valOf(TextIO.inputLine inStream)
        val size = valOf(Int.fromString firstLine)
	
	val secondLine  = valOf( TextIO.inputLine inStream)
        val tokenizeBySpace = String.tokens (fn c => c = #" ") secondLine 
        val hillList = List.map(fn str => valOf(Int.fromString str))tokenizeBySpace
        val _ = TextIO.closeIn inStream

        fun nth([],_) = 0
          | nth (head::tail,0) = head
          | nth (head::tail,n : int) = nth(tail, n-1)

        fun endHill (size : int, hills: int list) =
           if size < 2 then ~1
           else if nth(hills,size-1) <= nth(hills,size - 2) then endHill(size -1, hills)
           else size - 1   

       fun helpFunc([],_,_) = 0
         | helpFunc([_],_,_) = 0
         | helpFunc(hills : int list,comp : int,n : int) =
           let
             val nthHill = nth(hills, n);
             val lastHill = endHill(size, hills);
           in
                if n >= lastHill then 0
                else if comp  > nthHill   then comp - nthHill + helpFunc(hills,comp,n+1) 
                else helpFunc(hills,nthHill,n+1)
           end
          
in
       helpFunc(hillList, hd hillList,0)
end

val res_1 = rain "ex_1.txt";
val res_2 = rain "ex_2.txt";
