#############################      Configurable variables ########################
#
# 	All sizes are ethernet frame sizes 
#
arr[0]=22   #64
arr[1]=86   #128
arr[2]=214  #256
arr[3]=470  #512
arr[4]=982  #1024
arr[5]=1458 #1500

start=0
end=5
interval=1

# no of repetitions per packet 
iter_per_packet=5
if [ $# -ne 1 ]
then
	echo "Test type argument expected"
	echo "1 - Baremetal Multicore "
	echo "2 - Baremetal Single core"
	echo -e "\nEmulated / paravirt / passthrough  : "
	echo "3 - Multicore Host"
	echo "4 - Single core host"
	exit
fi
#
#
#	the specified size will be ethernet payload. Netperf will add 42 byte headers and the net size will 
# 	be same as specified 
#start=`expr $start - 42`
#end=`expr $end - 42`
#
#
#
#	configure these variables as required 
#
netperf_client=netperf

key_file=/home/akshay/benchmarking/kvm/key
#
#
netperf_test_length=10
username=akshay
#
vm_ip_address=192.168.0.10
host_ip_address=172.16.0.41
#
netperf_output_file=netperf_op
mpstat_output_file=mpstat_op
#######################################################################################
#  	pre executiono checks  


#	check if the hostip is same as vm ip
if [ $vm_ip_address ==  $host_ip_address ]
then 
	echo -e "\tWarning : Host IP address and VM ip addresses are same. This is useful only in baremetal tests"
fi

#  	check for file, give error if not found
function checkfile {
	ls  $1   > /dev/null 2>&1
	if [ 0 -ne $? ] 
	then 
		echo -e "\tFile $1 not found. Please ensure the file exists at the specified loction " 
		echo -e "\tExiting"
		exit
	fi
}


# 	check for file, if exists prompt to save
function check_for_previous_output_file { 

	ls $1  > /dev/null 2>&1
	if [ 0 -eq $? ] 
	then 
		echo -e "\tOutput file $1 already exists. Please save it if your wish to"
		echo -e "\tExiting"
		exit
	fi

}

checkfile $key_file
#checkfile $netperf_client


check_for_previous_output_file $netperf_output_file 
check_for_previous_output_file $mpstat_output_file 


echo -e "\n#########		Running netperf UDP_STREAM test on remote server $vm_ip_address\n\n" 

# for each packet size 
for((i=$start;i<=$end;i=i+ $interval))
do
	echo "Test iteration running with ethernet frame size `expr ${arr[$i]} + 42 `"
	echo -e "\tNETPERF COMMAND : $netperf_client  -H $vm_ip_address -l $netperf_test_length -t UDP_STREAM -c -C  -- -m ${arr[$i]} >> $netperf_output_file & "
	echo -e "\tCPU UTILIZATION COMMAND :  ssh -i $key_file $username@$host_ip_address \"mpstat -P ALL $netperf_test_length 1 \" >> $mpstat_output_file"


	# run each pkt size $iter_per_packet times, and take avg while parsing output 
	for((j=0;j< $iter_per_packet;j++))
	do
		echo -e "\tIteration $j\n"
		$netperf_client  -H $vm_ip_address -l $netperf_test_length -t UDP_STREAM -c -C  -- -m ${arr[$i]} >> $netperf_output_file & 
		ssh -i $key_file $username@$host_ip_address "mpstat -P ALL  $netperf_test_length 1 " >> $mpstat_output_file
	done
	
#	wait for the netperf to exit before we start the next iteration 
	while [ `pidof netperf` ] ; do sleep 0.1; done
	echo -e "\n"
done

echo -e "\nTest completed successfully. Netperf test output written to file : $netperf_output_file"
echo -e "\tCPU utilization output written to file : $mpstat_output_file"

echo "Parsing the output of netperf "
# here the $1 is the test type hint ( baremetal , emulated/ paravirt , passthro ) 
python netperf_udp_test_c_C_op_parser.py $netperf_output_file $mpstat_output_file $1 $iter_per_packet > $netperf_output_file"_graph_input"
if [ $? -ne 0 ] ; then echo "Error parsing $netperf_output_file "; echo "Exiting"; exit; fi
echo "Parsed output of netperf : $netperf_output_file""_graph_input"


echo "Exiting "

exit
