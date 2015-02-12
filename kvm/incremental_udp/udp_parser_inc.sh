# parses netperf output for udp test incremental 

grep "^[0-9]\+" $1 > temp 


cat temp | while read p
do
	if [ `echo $p | wc -w ` == 8 ];
	then echo $p >> sent 
	fi
done 


cat temp | while read p
do
	if [ `echo $p | wc -w ` == 6 ];
	then echo $p >> recvd
	fi
done 
 
cat sent | awk '{print $2+42"\t"$6}' > sent1
cat recvd | awk '{print $4}' > recvd1

echo -e "#pktSz\t#sent\t#recvd\t#bw_base" > graph
pr -mts sent1 recvd1  bw_base >> graph

rm temp sent recvd sent1 recvd1

mv graph t 

pr -mts t mpstat_op > graph 
rm t 
header=`cat graph | head -1`
arr=(64 128 256 512 1024 1500 ) 

for i in ${arr[@]}
do
	echo $header > $i
	grep "^$i" graph >> $i
done

exit
