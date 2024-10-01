#!/bin/bash

# Function to get current timestamp in milliseconds
get_timestamp() {
    python -c 'import time; print(int(time.time() * 1000))'
}

# Function to get memory usage in KB for a specific process
get_memory_usage() {
    ps -p $1 -o rss= | tr -d ' '
}

# Function to get CPU usage percentage
get_cpu_usage() {
    top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | cut -d% -f1
}

# Start time
start_time=$(get_timestamp)

# Output file
output_file="build_profile_$(date +%Y%m%d_%H%M%S).log"

# Run Maven build in the background
mvn clean install &
maven_pid=$!

# Log header
echo "Timestamp,Elapsed Time (ms),Memory Usage (KB),CPU Usage (%)" > "$output_file"

# Monitor resources
while kill -0 $maven_pid 2>/dev/null; do
    current_time=$(get_timestamp)
    elapsed_time=$((current_time - start_time))
    memory_usage=$(get_memory_usage $maven_pid)
    cpu_usage=$(get_cpu_usage)
    
    echo "$current_time,$elapsed_time,$memory_usage,$cpu_usage" >> "$output_file"
    
    sleep 0.1  # 100ms interval
done

echo "Build process completed. Results saved in $output_file"