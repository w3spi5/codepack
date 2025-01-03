#!/bin/bash
# ----------------------------------------------------------------------------
# x-tractor - CLI tool to extract folder structure and file contents
# Author: Ɛɔıs3 Solutions
# GitHub: https://github.com/w3spi5
# License: MIT
# Version: 1.4
# ----------------------------------------------------------------------------
# This script scans a specified directory, generates a structural overview,
# and extracts the content of all files, excluding specified directories.
# ----------------------------------------------------------------------------
# Check if the user provided a directory path
if [ "$#" -eq 0 ]; then
    echo "Usage: ./x-tractor.sh <path/to/directory>"
    echo "Example (Linux/macOS): ./x-tractor.sh /home/user/Documents"
    echo "Example (Windows using WSL): sh ./x-tractor.sh /mnt/c/Users/Admin/Desktop"
    exit 1
fi
# Retrieve the provided directory path
directory="$1"
# Verify if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: The specified directory does not exist."
    exit 1
fi
# Define directories to exclude from the scan
exclude_dirs=(
    ".git"
    "node_modules"
)
# Generate the output file name
output_file="${directory}/xtracted_$(date +%Y%m%d_%H%M%S).txt"

# Generate exclude pattern
exclude_pattern=$(IFS='|'; echo "${exclude_dirs[*]}")

# Function to generate tree-like structure
generate_tree() {
    local dir="$1"
    local prefix="$2"
    local files=()
    local dirs=()

    # Read directory contents
    while IFS= read -r -d $'\0' path; do
        if [[ -d "$path" ]]; then
            dirs+=("$path")
        else
            # Exclude xtracted_*.txt files from the tree
            if [[ ! $(basename "$path") =~ ^xtracted_.*\.txt$ ]]; then
                files+=("$path")
            fi
        fi
    done < <(find "$dir" -maxdepth 1 -mindepth 1 -print0 | sort -z)

    # Process directories
    local i=0
    for path in "${dirs[@]}"; do
        local name=$(basename "$path")
        if [[ " ${exclude_dirs[@]} " =~ " ${name} " ]]; then
            continue
        fi
        local new_prefix="$prefix│   "
        if [ $((i + 1)) -eq ${#dirs[@]} ] && [ ${#files[@]} -eq 0 ]; then
            echo "${prefix}└── $name/"
            new_prefix="$prefix    "
        else
            echo "${prefix}├── $name/"
        fi
        generate_tree "$path" "$new_prefix"
        ((i++))
    done

    # Process files
    local i=0
    for path in "${files[@]}"; do
        local name=$(basename "$path")
        if [ $((i + 1)) -eq ${#files[@]} ]; then
            echo "${prefix}└── $name"
        else
            echo "${prefix}├── $name"
        fi
        ((i++))
    done
}

# Generate the folder structure and save it
echo "🗂️  Generating folder structure..."
{
    echo "+---------------------------------------------+"
    echo "          --- DIRECTORY STRUCTURE ---          "
    echo "+---------------------------------------------+"
    echo
    echo "$(basename "$directory")/"
    generate_tree "$directory" ""
    echo
    echo "+---------------------------------------------+"
    echo "             --- FILES CONTENT ---             "
    echo "+---------------------------------------------+"
} > "$output_file"

# Function to check if a path should be excluded
should_exclude() {
    local path="$1"
    for dir in "${exclude_dirs[@]}"; do
        if [[ "$path" == *"/$dir"* || "$path" == *"/$dir/"* ]]; then
            return 0
        fi
    done
    return 1
}

# Generate find command with exclusions
find_cmd="find \"$directory\""
for dir in "${exclude_dirs[@]}"; do
    find_cmd+=" -not -path \"*/$dir/*\""
done
find_cmd+=" -type f -print0"

# Loop through files to extract content, ignoring excluded directories
while IFS= read -r -d '' file; do
    if ! should_exclude "$file" && [ "$file" != "$output_file" ] && [[ ! $(basename "$file") =~ ^xtracted_.*\.txt$ ]]; then
        filename=$(basename "$file")
        {
            echo -e "\n+-------------------"
            echo "# $filename"
            echo -e "+--------------------\n"
            cat "$file"
            echo -e "\n"
        } >> "$output_file"
    fi
done < <(eval "$find_cmd")

# Final confirmation
echo "✅ Extraction complete: See the file $output_file"

# End of script
exit 0