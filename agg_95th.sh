#!/bin/bash

# version
version=1
release=26

# the number of experements
measures=20

# array of threads' number
# array=(1 2 4 8 16 32 64 128 256 512)
array=(1 20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320 340 360 380 400 420 440 460 480 500) 

# workload csenario: fnight, routine, update
workload=update

# database: mongo, postgres
db=mongo   

# YCSB: original, modified
yscb=original

# name of directory to collect measurements data
measurement_dir="linear.measurement.$db.$workload.$yscb.v.$version.$release"

# name of the file with results
exp_result_file="results_total.$db.$workload.$yscb.$version.$release.txt"

# name of the file with results
csv_file="results_total.$db.$workload.$yscb.$version.$release.csv"

if [ ! -d "$measurement_dir" ]; then
    mkdir "$measurement_dir"
    echo "$measurement_dir has been created"
else
echo "$measurement_dir is not new"
fi



date >> $measurement_dir/$exp_result_file
echo "database: $db; $yscb; workload: $workload"  >> $measurement_dir/$exp_result_file
for threads in "${array[@]}"
do 
    echo "----------------------------------------------------"
    echo "....executing the script statistics from $threads threads having $measures numbers of the experiments: "
    ./stat95th.sh $db $workload $threads $measures $measurement_dir

    echo "----------------------------------------------------"
    echo "...calculating avarege:"
    ./std_95th.sh $db $threads $workload $measurement_dir >> $measurement_dir/$exp_result_file
done
echo "                                " >> $measurement_dir/$exp_result_file
date >> $measurement_dir/$exp_result_file

# convert txt to csv format
./txt_to_csv_95th.sh $measurement_dir/$exp_result_file $measurement_dir/$csv_file
