#############################      Configurable variables ########################
#
# 	All sizes are ethernet frame sizes 
#
start=1250
end=1300
interval=50
#
#
#	the specified size will be ethernet payload. Netperf will add 42 byte headers and the net size will 
# 	be same as specified 
start=`expr $start - 42`
end=`expr $end - 42`
#
#
#
#	configure these variables as required 
#
netperf_client=/home/compile/Downloads/netperf-2.5.0/src/netperf
key_file=/home/compile/Desktop/benchmarking/kvm/key
#
#
netperf_test_length=2
username=shashank
#
vm_ip_address=10.237.23.184
host_ip_address=10.237.23.184
#
netperf_output_file=netperf_op
mpstat_output_file=mpstat_op
#######################################################################################


################  	pre executiono checks  


#	check if the hostip is same as vm ip
if [ $vm_ip_address ==  $host_ip_address ]
then 
	echo -e "\tWarning : Host IP address and VM ip addresses are same "
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
checkfile $netperf_client


check_for_previous_output_file $netperf_output_file 
check_for_previous_output_file $mpstat_output_file 


echo -e "\n#########		Running netperf UDP_STREAM test on remote server $vm_ip_address\n\n" 


for((i=$start;i<=$end;i=i+ $interval))
do
	echo "Test iteration running with ethernet frame size `expr $i + 42 `"
	echo -e "\tNETPERF COMMAND : $netperf_client  -H $vm_ip_address -l $netperf_test_length -t UDP_STREAM -c -C  -- -m $i >> $netperf_output_file & "
	echo -e "\tCPU UTILIZATION COMMAND :  ssh -i $key_file $username@$host_ip_address \"mpstat -P ALL $netperf_test_length 1 \" >> $mpstat_output_file"

	$netperf_client  -H $vm_ip_address -l $netperf_test_length -t UDP_STREAM -c -C  -- -m $i >> $netperf_output_file & 
	ssh -i $key_file $username@$host_ip_address "mpstat -P ALL  $netperf_test_length 1 " >> $mpstat_output_file
	
#	wait for the netperf to exit before we start the next iteration 
	while [ `pidof netperf` ] ; do sleep 0.1; done
	echo -e "\n"
done

echo -e "\nTest completed successfully. Netperf test output written to file : $netperf_output_file"
echo -e "\tCPU utilization output written to file : $mpstat_output_file"

echo "Parsing the output of netperf "
python netperf_udp_test_c_C_op_parser.py $netperf_output_file > $netperf_output_file"_graph_input"
if [ $? -ne 0 ] ; then echo "Error parsing $netperf_output_file "; echo "Exiting"; exit; fi
echo "Parsed output of netperf : $netperf_output_file _graph_input"


echo "Exiting "

exit
