import sys
import os

a = open("plotcmd", "w")

filename = "\"graph_input\""

cmd = "set term png size 2000, 1200\n"
cmd += "set output \"Throughput.png\"\n"
cmd += "set key outside\n"
cmd += "plot "+filename+" using 1:7 title 'Theoritical Maximum(Mib/S)' with linespoints, "
cmd += filename+" using 1:2 title 'Throughput ' with linespoints; \n"

cmd += "set term png size 2000, 1200\n"
cmd += "set output \"CPU.png\" \n"
cmd += "set key outside \n"
cmd += "plot "+filename+" using 1:4 title 'Guest utilization [netperf]' with linespoints, "
cmd += filename+" using 1:5 title 'Avg. Host CPU utilization [mpstat]' with linespoints, "
cmd += filename+" using 1:6 title 'Max. Host CPU utilization [mpstat]' with linespoints;"

a.write(cmd)
	
a.close()	
os.system("gnuplot < plotcmd")
