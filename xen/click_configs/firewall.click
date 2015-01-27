define($MAC 00:00:00:00:00:55);
in    :: FromDevice(); 
out   :: ToDevice();
dropc :: Counter(); // counts packets
ethh    :: StoreEtherAddress($MAC, 6); // changes src mac

// Filter element
filter :: IPFilter(
allow src host 10.0.0.1 && udp, 
allow src host 10.0.0.2 && udp,
drop all);

c :: Classifier(
12/0806 20/0001, // ARP Requests goes to output 0
12/0806 20/0002, // ARP Replies to output 1
12/0800, // ICMP Requests to output 2
-); // without a match to output 3

in -> c;

c[0] -> Print("ARP Request") -> d;
c[1] -> Print("ARP Reply") -> d;
c[2] -> Print("ICMP Request") -> d;
c[3] -> Print("IP Packet") -> CheckIPHeader(14) -> filter;

filter[0] -> ethh -> out; // allows
filter[1] -> dropc -> Discard(); // drops
