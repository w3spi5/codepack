#!/bin/bash

# Create a dummy file
echo "This is a test file with some content to simulate reading." > dummy_file.txt

ITERATIONS=1000

echo "Benchmarking original method (cat | sed | tr)..."
start_time=$(date +%s%N)
for ((i=0; i<ITERATIONS; i++)); do
    content=$(cat "dummy_file.txt" 2>/dev/null | sed 's// /g' 2>/dev/null | tr -cd '\11\12\15\40-\176' 2>/dev/null || echo "")
done
end_time=$(date +%s%N)
duration=$((end_time - start_time))
echo "Original method took: $((duration/1000000)) ms"

echo "Benchmarking optimized method (tr < file)..."
start_time=$(date +%s%N)
for ((i=0; i<ITERATIONS; i++)); do
    content=$(tr -cd '\11\12\15\40-\176' < "dummy_file.txt" 2>/dev/null || echo "")
done
end_time=$(date +%s%N)
duration=$((end_time - start_time))
echo "Optimized method took: $((duration/1000000)) ms"

rm dummy_file.txt
