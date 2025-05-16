structure LMS = ListMergeSort;

fun hire fileName = 
let
	val inStream = TextIO.openIn fileName
	 
        fun readLines stream =
          case TextIO.inputLine stream of
               SOME line => line::readLines stream
             | NONE => []

        val lines = readLines inStream;

        fun removeTab str =
                if size str > 0 andalso String.sub(str,size str -1) = #"\n"
                then substring(str, 0, size str - 1)
                else str

        val removeTabs = map removeTab lines
        fun tokenBySpace str = String.tokens (fn c => c = #" ") str
        val tokenLine = map tokenBySpace removeTabs 

        fun convertToInt str = valOf(Int.fromString str)
        fun convIntElement l = map convertToInt l
        fun convIntList l = map convIntElement l
        val intList = convIntList tokenLine

        val m_k = hd intList;
        val a_b = tl intList;

        fun subElement ([x, y]) = x - y
          | subElement (_) = 0 
        fun calculateDiff l = map subElement l
        val diff = calculateDiff a_b   

        val paired = ListPair.zip(diff, a_b)

        fun sort pairedList = LMS.sort (fn ((k1,_),(k2,_))=> k1 < k2) pairedList
        val sortedPair = sort paired
                      
        fun calculateSum ([],_) = 0
          | calculateSum ([a,b]::rest,counter) =
                if counter > 0 then a + calculateSum(rest ,counter - 1)
                               else b + calculateSum(rest ,counter)
        val aCounter = hd m_k
        fun unpair_y (x,y) = y   
        val sortedAB = map unpair_y sortedPair 
        val sum = calculateSum(sortedAB,aCounter)
        
         val _ = TextIO.closeIn inStream
in
        print(Int.toString sum ^ "\n")
end
