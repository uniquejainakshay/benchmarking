// send fake reply to host
//ARPFaker(10.237.23.251, 34:17:eb:c1:c7:c4, 10.237.23.244 ,00:15:17:15:5d:76 ) -> ToDevice;
// send fake reply to sender
//ARPFaker(10.237.23.243, 00:15:17:15:5d:75, 10.237.23.244 ,00:15:17:15:5d:76 ) -> ToDevice;
//Script(set x 0,print $x
FromDevice -> CheckIPHeader(14) ->  IPPrint -> Discard;
