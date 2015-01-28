import sys
import os
iterations = int ( sys.argv[4])

def average_per_iteration_group(avg_max_list):
    global iterations; 
    new_avg_max_list = []
#take first iteration values and find the average 
    while ( len(avg_max_list) > 0):
        group = avg_max_list[:iterations]
        avg_max_list = avg_max_list[iterations:]
        new_avg_max_list += [mean_list(group)]
    return new_avg_max_list


def get_avg_max_list(command):
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
    # first line must have the CPU as "all"
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
    return avg_max_values
    

# calculates the mean of results of the same packet size 
# the argument is a list of lists


    
def mean_list(ll):
    mean = [0.0] * len(ll[0])
    for l in ll:
        l = map(float, l)
        for i in range(len(mean)):
            mean[i] += l[i]
    count = len(ll)
    for i in range(len(mean)):
        mean[i] /= count
    return mean

def make_groups(ans):
    groups = []
    group = []
    while ( len(ans) > 0):
        first = ans[0]
        group += [first]
        ans = ans[1:]
        while(len(ans) > 0 and ans[0][0] == first[0]):
            group += [ans[0]]
            ans = ans[1:]
        groups += [group]
        group = []

    return groups

a = open(sys.argv[1], "r")
b = a.readlines();
a.close()



b = [a.split(' ') for a in b]


for i in range(len(b)):
	while b[i].__contains__(''):
		b[i].remove('')

ans = []
i = 5
pkt_size = 0
while i < len(b):
	#print b[i]
	#print b[i+1]
        pkt_size = int(b[i][1]) + 42
	#ans.append([pkt_size, b[i][5], b[i][6], b[i+1][3], b[i+1][4], 1000.0*(pkt_size-8)/(pkt_size+62.0), 1000000.0/((float(b[i][5])+66.0)*8), 1000000.0/((float(b[i+1][3])+66.0)*8 ) ])
	ans.append([pkt_size, b[i][5], b[i][6], b[i+1][3], b[i+1][4], 1000.0*(pkt_size-42)/(pkt_size-42+66), 1000000.0/((float(b[i][5])+66.0)*8), 1000000.0/((float(b[i+1][3])+66.0)*8 ) ])
	i += 8


new_ans = []
ans.sort(key=lambda x : x[0])
groups = make_groups(ans)
for group in groups : 


    new_ans += [mean_list(group)]


ans = new_ans



#extract the max used processor and the average CPU usage from the mpstat file 
command = "grep -v Linux " + sys.argv[2] + "  | grep -v Average  | grep -v iowait | sed '/^$/d' | awk {'print $3 \" \"$12'}"
#print command 

avg_max_values = get_avg_max_list(command)
avg_max_values = average_per_iteration_group(avg_max_values)
#print avg_max_values,len(avg_max_values)



# identifier for gnuplot script 
print sys.argv[3]
print "#pkt_sz\t\tc_th\t\tc_util\t\ts_th\t\ts_util\t\tmax_th\t\tcThKpps\t\tsThKpps\t\tmpAvgCPU\tmpMaxCPU"
count = 0 
for i in ans:
	print "%.1f" %i[0], "\t\t", "%.1f" %i[1], "\t\t", "%.1f" %i[2], "\t\t", "%.1f" %i[3], "\t\t", "%.1f" %i[4], "\t\t", "%.1f" % i[5], "\t\t", "%.1f" % i[6],"\t\t", "%.1f" % i[7],"\t\t", "%.1f"%avg_max_values[count][0],"\t\t", "%.1f"%avg_max_values[count][1]
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
