no=`cat /proc/cpuinfo | grep processor | wc -l`
no=`expr $no - 1`
for (( c=1; c<=3; c++ )); do echo 0 | tee /sys/devices/system/cpu/cpu$c/online; done
