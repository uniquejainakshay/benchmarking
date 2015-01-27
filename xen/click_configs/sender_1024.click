// send fake reply to host
// ARPFaker(10.237.23.251, 34:17:eb:c1:c7:c4, 10.237.23.243 ,00:15:17:15:5d:75 ) -> ToDevice;
// send fake reply to receiver 
 //ARPFaker(10.237.23.244, 00:15:17:15:5d:76, 10.237.23.243 ,00:15:17:15:5d:75 ) -> ToDevice;


	 

InfiniteSource(DATA \<34 17 eb a6 21 c5  34 17 eb c1 c7 c4  08 00
45 00 03 f2  00 00 00 00  40 11 35 16  0a ed 17 fb
0a ed 17 db  13 69 13 69  00 20 00 00  55 44 50 20
70 61 63 6b  ab ab ab ab  ab ab ab ab  ab ab ab ab

ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab

ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab

ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab


ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab
ab ab ab ab  ab ab ab ab  ab ab ab ab  ab ab ab ab

ab ab  
65 74 21 0a>, LIMIT -1, STOP false)

->  CheckIPHeader(14, CHECKSUM false) ->  ToDevice;


// old checksum d6 41 
//FromDevice -> CheckIPHeader(14) -> IPPrint-> Discard; 


