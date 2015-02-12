import sys
import os

a = open("plotcmd", "w")
sizes  = [64,128, 256, 512, 1024, 1500]
files = map(str, sizes)


cmd = "set term png size 2000, 1200\n"
cmd += "set output \"Varied_bandwidth.png\"\n"
cmd += "set key outside\n plot "
#cm = "{0} using 4:2 title 'Sender Throughput(Mib/S) {0}B' with linespoints, "
cm = "{0} using 4:3 title 'Receiver Throughput {0}B' with linespoints,"

for filename in files : 
	filename = "\""+filename+"\""
	c = cm
	cmd+=c.format(filename)

cmd=cmd[:-1]+";"
a.write(cmd)
a.close()	
os.system("gnuplot < plotcmd")
