#!/bin/bash

#Hello

# database
db=$1

# workload="fnight"
workload=$2

# the first parameter is the number of the threads
t=$3

# the second parameter is the number of the measures
n=$4

# directory to collect measurements
measurement_dir=$5

# records in database
#$recordcount=15585

for (( i=1; i<$n+1; i++ ))
do
   echo "Iteration number $i"

   if [ $workload == "fnight" ]; then
      grep '^\[SCAN\], 95thPercentileLatency(us)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
      grep '^\[SCAN\], AverageLatency(us)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
      grep '^\[OVERALL\], Throughput(ops/sec)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
   elif [ $workload == "routine" ]; then
      grep '^\[READ\], 95thPercentileLatency(us)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
      grep '^\[READ\], AverageLatency(us)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
      grep '^\[OVERALL\], Throughput(ops/sec)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
   elif [ $workload == "update" ]; then
      grep '^\[UPDATE\], 95thPercentileLatency(us)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
      grep '^\[UPDATE\], AverageLatency(us)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
      grep '^\[OVERALL\], Throughput(ops/sec)' $measurement_dir/$db.op_$workload.threads_$t.mes_$i.dat >> $measurement_dir/$db.op_$workload.total_info.threads_$t.txt
   else
      echo "== unknown workload =="
   fi

done
