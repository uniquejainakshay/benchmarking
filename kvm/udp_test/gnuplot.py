import sys
import os
a = open(sys.argv[1], "r")
b = a.readline()
b = int(b)
a.close()

a = open("plotcmd", "w")

filename = sys.argv[1]
filename = str(filename)
filename = "\""+filename+"\""

if b == 1:
	#Multicore Bare-Metal Test
	cmd = "set term png size 2000, 1200\n"
	cmd += "set output \"Throughput_multicore.png\"\n"
	cmd += "set key outside\n"
	cmd += "plot "+filename+" using 1:6 title 'Theoritical Maximum(Mib/S)' with lines, "
	cmd += filename+" using 1:4 title 'Multicore Host' with linespoints; \n"

	cmd += "set term png size 2000, 1200\n"
	cmd += "set output \"CPU_multicore.png\" \n"
	cmd += "set key outside \n"
	cmd += "plot "+filename+" using 1:5 title 'Guest utilization [netperf]' with linespoints, "
	cmd += filename+" using 1:9 title 'Avg. Host CPU utilization [mpstat]' with linespoints, "
	cmd += filename+" using 1:10 title 'Max. Host CPU utilization [mpstat]' with linespoints;"

	a.write(cmd)
	
elif b == 2:
	#Multicore Bare-Metal Test
	cmd = "set term png size 2000, 1200\n"
	cmd += "set output \"Throughput_singlecore.png\"\n"
	cmd += "set key outside\n"
	cmd += "plot "+filename+" using 1:6 title 'Theoritical Maximum(Mib/S)' with lines, "
	cmd += filename+" using 1:4 title 'Single-core Host' with linespoints; \n"

	cmd += "set term png size 2000, 1200\n"
	cmd += "set output \"CPU_singlecore.png\" \n"
	cmd += "set key outside \n"
	cmd += "plot "+filename+" using 1:5 title 'Guest utilization [netperf]' with linespoints, "
	cmd += filename+" using 1:9 title 'Avg. Host CPU utilization [mpstat]' with linespoints, "
	cmd += filename+" using 1:10 title 'Max. Host CPU utilization [mpstat]' with linespoints;"

	a.write(cmd)

	
elif b == 3:
	#Multicore Host
	cmd = "set term png size 2000, 1200\n"
	cmd += "set output \"Throughput_multicore.png\"\n"
	cmd += "set key outside\n"
	cmd += "plot "+filename+" using 1:6 title 'Theoritical Maximum(Mib/S)' with lines, "
	cmd += filename+" using 1:4 title 'VM on Multicore Host' with linespoints; \n"

	cmd += "set term png size 2000, 1200\n"
	cmd += "set output \"CPU_multicore.png\" \n"
	cmd += "set key outside \n"
	cmd += "plot "+filename+" using 1:5 title 'Guest utilization [netperf]' with linespoints, "
	cmd += filename+" using 1:9 title 'Avg. Host CPU utilization [mpstat]' with linespoints, "
	cmd += filename+" using 1:10 title 'Max. Host CPU utilization [mpstat]' with linespoints;"

	a.write(cmd)


	
elif b == 4:
	#single-core Tests
	cmd = "set term png size 2000, 1200\n"
	cmd += "set output \"Throughput_singlecore.png\"\n"
	cmd += "set key outside\n"
	cmd += "plot "+filename+" using 1:6 title 'Theoritical Maximum(Mib/S)' with lines, "
	cmd += filename+" using 1:4 title 'VM on single-core Host' with linespoints; \n"

	cmd += "set term png size 2000, 1200\n"
	cmd += "set output \"CPU_singlecore.png\" \n"
	cmd += "set key outside \n"
	cmd += "plot "+filename+" using 1:5 title 'Guest utilization [netperf]' with linespoints, "
	cmd += filename+" using 1:9 title 'Avg. Host CPU utilization [mpstat]' with linespoints, "
	cmd += filename+" using 1:10 title 'Max. Host CPU utilization [mpstat]' with linespoints;"

	a.write(cmd)
	
else:
	print "Invalid Mode"			
	
a.close()	
os.system("gnuplot < plotcmd")
