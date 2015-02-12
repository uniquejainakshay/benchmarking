#############################      Configurable variables ########################
#
# 	All sizes are ethernet frame sizes 
#
#arr[0]=22   #64
#arr[1]=86   #128
#arr[2]=214  #256
#arr[3]=470  #512
#arr[4]=982  #1024
#arr[5]=1458 #1500

arr=(22 86 214 470 982 1458 )

start=0
end=5
##  ######################################### 		bandwidth control 

bw_limits=(10 100 1000 2000 4000 8000 10000)


##############################################################################################


# no of repetitions per packet 
min_iter=4
max_iter=5




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
#
netperf_client=netperf
key_file=/home/akshay/benchmarking/benchmarking/kvm/key
#
#
netperf_test_length=5
username=akshay
#
vm_ip_address=192.168.0.50
host_ip_address=172.16.0.43
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

#checkfile $key_file
#checkfile $netperf_client


#check_for_previous_output_file $netperf_output_file 
#check_for_previous_output_file $mpstat_output_file 


######	################################	commands  ##################################

# netperf command



###   remote mpstat command
#remote_mpstat_command="ssh -i $key_file $username@$host_ip_address \"mpstat -P ALL  $netperf_test_length 1 \" >> $mpstat_output_file"

echo -e "\t#avgCpu\t#maxCpu" > $mpstat_output_file

#####################################################################################################################################
echo -e "\n#########		Running netperf TCP_STREAM test on remote server $vm_ip_address\n\n" 
# for each bandwidth limit 
for i in "${bw_limits[@]}"
do
	# for each packet size 
	for j in "${arr[@]}"
	do
		float=`echo "(1000000 * $i) / ($j* 80)" | bc -l    `
		burst_size=${float%.*}
		echo "Test iteration running with ethernet frame size `expr $j + 42 `"
		echo -e "\tCPU UTILIZATION COMMAND : $remote_mpstat_command"  
		echo -e "\tNetperf command : $netperf_client -H $vm_ip_address -l $netperf_test_length -b $burst_size  -w 100 -i $max_iter,$min_iter -t TCP_STREAM -c -C  -- -m $j >> $netperf_output_file"

		$netperf_client -H $vm_ip_address -l $netperf_test_length -b $burst_size -w 100 -t TCP_STREAM -c -C  -- -m $j >> $netperf_output_file & 

		ssh -i $key_file $username@$host_ip_address mpstat -P ALL  $netperf_test_length 1  > mptemp
		avgCpu=`grep -v "Average" mptemp | grep -v Linux  | grep -v CPU | grep all | awk '{print 100-$13}'`
		maxCpu=`cat mptemp | grep -v Average | grep -v Linux | grep -v all | grep -v CPU | grep -v "^[0-9a-zA-Z]*$" |  awk '{print $13}' | sort -n | head -1`
		echo -e "\t$avgCpu\t$maxCpu" >> $mpstat_output_file

#	wait for the netperf to exit before we start the next iteration 
		while [ `pidof netperf` ] ; do sleep 0.1; done
		echo -e "\n"
	done
done


echo -e "#pktSz\t#thpt\t\t#lCPUtil\t#mmCPUtil" > ntemp
grep -v "^[a-zA-Z]\+" $netperf_output_file | grep -v "^$" | grep -v "!" | awk '{print $3+42"\t"$5"\t\t"$6"\t"$7}' >> ntemp
pr -mts ntemp bw_base $mpstat_output_file > gtemp

header=`head -1 gtemp`

for i in ${arr[@]}
do
	j=`expr $i + 42`
	echo $header > $j
	grep "^$j" gtemp >> $j
done


exit
