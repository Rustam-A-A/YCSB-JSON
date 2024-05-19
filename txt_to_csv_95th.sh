#!/bin/bash

# Define the input and output files
inputFile=$1 
outputFile=$2

# Create or clear the output file
> "$outputFile"

# Add CSV header
echo "Number of Threads,Average of Average,SD of Average,Average 95thPL,SD of 95thPL,Average Throughput,SD of Throughput,Number of Measures" >> "$outputFile"

# Read the input file line by line
while IFS= read -r line
do
    # Check if the line contains "Number of Threads" and extract data
    if [[ "$line" == Number\ of\ Threads:* ]]; then
        threads=$(echo "$line" | cut -d' ' -f4)
    elif [[ "$line" == Average\ of\ Average:* ]]; then
        latency=$(echo "$line" | cut -d' ' -f4)
    elif [[ "$line" == SD\ of\ Average:* ]]; then
        std_dev=$(echo "$line" | cut -d' ' -f4)
    elif [[ "$line" == Average\ of\ PL:* ]]; then
        latency_95=$(echo "$line" | cut -d' ' -f4)
    elif [[ "$line" == SD\ of\ PL:* ]]; then
        std_dev_95=$(echo "$line" | cut -d' ' -f4)
    elif [[ "$line" == Average\ of\ Throughput:* ]]; then
        throughput=$(echo "$line" | cut -d' ' -f4)
    elif [[ "$line" == SD\ of\ Throughput:* ]]; then
        std_dev_throughput=$(echo "$line" | cut -d' ' -f4)
    elif [[ "$line" == Number\ of\ Measures:* ]]; then
        measures=$(echo "$line" | cut -d' ' -f4)
        # Write the extracted data to the CSV file
        echo "$threads,$latency,$std_dev,$latency_95,$std_dev_95,$throughput,$std_dev_throughput,$measures" >> "$outputFile"
    fi
done < "$inputFile"

echo "CSV file created: $outputFile"