in 	:: FromDevice();
out 	:: ToDevice();

filter	:: IPFilter(
	allow src host 10.0.10.4 && udp, 
	drop all);

in -> filter;


filter[0] -> out; 
filter[1] -> IPPrint("drop") -> Discard(BURST 1024);

