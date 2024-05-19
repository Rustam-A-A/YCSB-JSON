#!/bin/bash

# Specify the file containing the numbers

# database
db=$1

# number of threads
t=$2

# workload 
workload=$3

# directory
measurement_dir=$4

# File to read measures
file="$measurement_dir/$db.op_$workload.total_info.threads_$t.txt"



# Read numbers into an array
#readarray -t numbers < <(grep '^\[SCAN\], AverageLatency(us)' "$file" | awk -F', ' '{print $3}')

if [ $workload == "fnight" ]; then
    readarray -t numbers_95th < <(grep '^\[SCAN\], 95thPercentileLatency(us)' "$file" | awk -F', ' '{print $3}')
    readarray -t numbers_aver < <(grep '^\[SCAN\], AverageLatency(us)' "$file" | awk -F', ' '{print $3}')
    readarray -t numbers_opers < <(grep '^\[OVERALL\], Throughput(ops/sec)' "$file" | awk -F', ' '{print $3}')
elif [ $workload == "routine" ]; then
    readarray -t numbers_95th < <(grep '^\[READ\], 95thPercentileLatency(us)' "$file" | awk -F', ' '{print $3}')
    readarray -t numbers_aver < <(grep '^\[READ\], AverageLatency(us)' "$file" | awk -F', ' '{print $3}')
    readarray -t numbers_opers < <(grep '^\[OVERALL\], Throughput(ops/sec)' "$file" | awk -F', ' '{print $3}')
elif [ $workload == "update" ]; then
    readarray -t numbers_95th < <(grep '^\[UPDATE\], 95thPercentileLatency(us)' "$file" | awk -F', ' '{print $3}')
    readarray -t numbers_aver < <(grep '^\[UPDATE\], AverageLatency(us)' "$file" | awk -F', ' '{print $3}')
    readarray -t numbers_opers < <(grep '^\[OVERALL\], Throughput(ops/sec)' "$file" | awk -F', ' '{print $3}')    
else    
    echo "== unknown workload =="
fi

# Calculate the average of the average
sum_average=0
count_average=0

for num in "${numbers_aver[@]}"; do
    sum_average=$(echo "$sum_average + $num" | bc)
    ((count_average++))
done


if [ $count_average -gt 0 ]; then
    average_average=$(echo "scale=2; $sum_average / $count_average" | bc)
else
    echo "No numbers found in the file."
    exit 1
fi

# Calculate the standard deviation of the average
sum_sq_diff_average=0
for num in "${numbers_aver[@]}"; do
    diff=$(echo "$num - $average_average" | bc)
    sq_diff=$(echo "$diff^2" | bc)
    sum_sq_diff_average=$(echo "$sum_sq_diff_average + $sq_diff" | bc)
done


if [ $count_average -gt 1 ]; then
    variance=$(echo "scale=2; $sum_sq_diff_average / ($count_average - 1)" | bc)
    std_dev_average=$(echo "scale=2; sqrt($variance)" | bc)
else
    echo "Not enough data to calculate standard deviation."
    exit 1
fi






# Calculate the average of the 95th percentile
sum_95th=0
count_95th=0

for num in "${numbers_95th[@]}"; do
    sum_95th=$(echo "$sum_95th + $num" | bc)
    ((count_95th++))
done


if [ $count_95th -gt 0 ]; then
    average_95th=$(echo "scale=2; $sum_95th / $count_95th" | bc)
else
    echo "No numbers found in the file."
    exit 1
fi

# Calculate the standard deviation of the 95th percentile
sum_sq_diff=0
for num in "${numbers_95th[@]}"; do
    diff=$(echo "$num - $average_95th" | bc)
    sq_diff=$(echo "$diff^2" | bc)
    sum_sq_diff=$(echo "$sum_sq_diff + $sq_diff" | bc)
done


if [ $count_95th -gt 1 ]; then
    variance=$(echo "scale=2; $sum_sq_diff / ($count_95th - 1)" | bc)
    std_dev=$(echo "scale=2; sqrt($variance)" | bc)
else
    echo "Not enough data to calculate standard deviation."
    exit 1
fi

# Calculate the average of the throughput
sum_opers=0
count_opers=0

for num in "${numbers_opers[@]}"; do
    sum_opers=$(echo "$sum_opers + $num" | bc)
    ((count_opers++))
done


if [ $count_opers -gt 0 ]; then
    average_opers=$(echo "scale=2; $sum_opers / $count_opers" | bc)
else
    echo "No numbers found in the file."
    exit 1
fi

# Calculate the standard deviation of the throughput
sum_sq_diff_opers=0
for num in "${numbers_opers[@]}"; do
    diff=$(echo "$num - $average_opers" | bc)
    sq_diff=$(echo "$diff^2" | bc)
    sum_sq_diff_opers=$(echo "$sum_sq_diff_opers + $sq_diff" | bc)
done


if [ $count_opers -gt 1 ]; then
    variance=$(echo "scale=2; $sum_sq_diff_opers / ($count_opers - 1)" | bc)
    std_dev_opers=$(echo "scale=2; sqrt($variance)" | bc)
else
    echo "Not enough data to calculate standard deviation."
    exit 1
fi





# Print results
echo "------------------------------------"
echo "Number of Threads: $t"
echo "Average of Average: $average_average"
echo "SD of Average: $std_dev_average"
echo "Average of PL: $average_95th"
echo "SD of PL: $std_dev"
echo "Average of Throughput: $average_opers"
echo "SD of Throughput: $std_dev_opers"
echo "Number of Measures: $count_95th"
