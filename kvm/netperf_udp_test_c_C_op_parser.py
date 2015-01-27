import sys
import os

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




#extract the max used processor and the average CPU usage from the mpstat file 
command = "grep -v Linux " + sys.argv[2] + "  | grep -v Average  | grep -v iowait | sed '/^$/d' | awk {'print $3 \" \"$12'}"
print command 
pip = os.popen(command)
lines = pip.readlines();
pip.close()
avg_max_values = []
g = lambda x: (x[0], 100.0 - float(x[1]))
lc = 0 ; 
while (True):
    avg = 0 
    maximum = 0 
    line = lines[lc]
    line = g(line.split())
    if ( not line[0].__contains__("all")):
        print "Error parsing the mp_stat output  at line : " + line

    avg = line[1]
    lc += 1 
    while (lc < len ( lines) and not lines[lc].__contains__("all") ):
        line = lines[lc]
        line = g(line.split())
        if ( maximum < line[1]):
            maximum = line[1]
        lc += 1 
    avg_max_values += [(avg, maximum)]
    if ( lc == len(lines)):
        break;

    

# identifier for gnuplot script 
print sys.argv[3]
print "#pkt_sz\tc_th\tc_util\ts_th\ts_util\tmax_th\tc_th_kpps\ts_th_kpps\tmpAvgCPU\tmpMaxCPU"
count = 0 
for i in ans:
	print i[0], "\t", i[1], "\t", i[2], "\t", i[3], "\t", i[4], "\t", "%.2f" % i[5], "\t", "%.2f" % i[6],"\t\t", "%.2f" % i[7],"\t\t", "%.2f"%avg_max_values[count][0],"\t\t", "%.2f"%avg_max_values[count][1]
        count += 1

print "\n\n"
print "#pkt_sz : Ethernet frame size\n\
#c_th : Client throughput\n\
#s_th : Server throughput\n\
#c_util : Client CPU utilization \n\
#s_util : Server CPU utilization \n\
#max_th : Max theoretical throughput\n\
#c_th_kpps : Client throughput in kilo packets per second ( needs to be verified )\n\
#s_th_kpps : Server throughput in kilo packets per second ( needs to be verified )\n\
#mpAvgCPU  : Average CPU utilization measured by mpstat on the host\n\
#mpMaxCPU  : The CPU utilization of maximum utilized CPU core "
