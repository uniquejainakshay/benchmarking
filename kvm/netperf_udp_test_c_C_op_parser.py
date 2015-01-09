import sys

a = open(sys.argv[1], "r")
b = a.readlines();
a.close()

b = [a.split(' ') for a in b]


for i in range(len(b)):
	while b[i].__contains__(''):
		b[i].remove('')

ans = []
i = 5
pkt_size = 50.0		
while i < len(b):
	#print b[i]
	#print b[i+1]
        pkt_size = int(b[i][1]) + 42
	ans.append([pkt_size, b[i][5], b[i][6], b[i+1][3], b[i+1][4], 1000.0*(pkt_size-8)/(pkt_size+62.0), 1000000.0/((float(b[i][5])+66.0)*8), 1000000.0/((float(b[i+1][3])+66.0)*8 ) ])
	i += 8

print "#pkt_sz\tc_th\tc_util\ts_th\ts_util\tmax_th\tc_th_kpps s_th_kpps"
for i in ans:
	print i[0], "\t", i[1], "\t", i[2], "\t", i[3], "\t", i[4], "\t", "%.2f" % i[5], "\t", "%.2f" % i[6], "%.2f" % i[7]

print "\n\n"
print "#pkt_sz : Ethernet frame size\n\
#c_th : Client throughput\n\
#s_th : Server throughput\n\
#c_util : Client CPU utilization \n\
#s_util : Server CPU utilization \n\
#max_th : Max theoretical throughput\n\
#c_th_kpps : Client throughput in kilo packets per second ( needs to be verified )\n\
#s_th_kpps : Server throughput in kilo packets per second ( needs to be verified ) "
