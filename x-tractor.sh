#!/bin/bash
# ----------------------------------------------------------------------------
# x-tractor - CLI tool to extract folder structure and file contents
# Author: Ɛɔıs3 Solutions
# GitHub: https://github.com/w3spi5
# License: MIT
# Version: 2.0
# Requirements: Bash shell, find command
# Dependencies: None
# ----------------------------------------------------------------------------
# This script scans a specified directory, generates a structural overview,
# and extracts the content of all files, excluding specified directories and extensions.
# ----------------------------------------------------------------------------

# Function to display usage information
show_usage() {
    echo "Usage: ./x-tractor.sh <path/to/directory> [options]"
    echo "Options:"
    echo "  --exclude <ext1> [<ext2> ...]  Exclude files with specified extensions (optional)"
    echo "  --include <ext1> [<ext2> ...]  Include ONLY files with specified extensions (optional)"
    echo "Note: You cannot use both --include and --exclude at the same time"
    echo "Examples:"
    echo "  ./x-tractor.sh /home/user/Documents"
    echo "  ./x-tractor.sh /home/user/Documents --exclude pdf jpg"
    echo "  ./x-tractor.sh /home/user/Documents --include js html css"
    exit 1
}

# Check if the user provided a directory path
if [ "$#" -eq 0 ]; then
    show_usage
fi

# Retrieve the provided directory path
directory="$1"
shift

# Verify if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: The specified directory does not exist."
    exit 1
fi

# Define directories to exclude from the scan (always excluded)
exclude_dirs=(
    ".git"
    "node_modules"
    "venv"
)

# Create a nice message about excluded directories
excluded_dirs_msg=$(printf "'%s', " "${exclude_dirs[@]}")
excluded_dirs_msg=${excluded_dirs_msg%, }  # Remove trailing comma and space
echo "Automatically excluding directories: ${excluded_dirs_msg}"

# Parse arguments for excluded/included extensions
exclude_extensions=()
include_extensions=()
include_mode=false
exclude_mode=false

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --exclude)
            if $include_mode; then
                echo "Error: Cannot use both --include and --exclude options at the same time."
                show_usage
            fi
            exclude_mode=true
            shift
            # Collect all extensions until next option or end of arguments
            while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                exclude_extensions+=("$1")
                shift
            done
            ;;
        --include)
            if $exclude_mode; then
                echo "Error: Cannot use both --include and --exclude options at the same time."
                show_usage
            fi
            include_mode=true
            shift
            # Collect all extensions until next option or end of arguments
            while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                include_extensions+=("$1")
                shift
            done
            ;;
        --*)
            echo "Unknown option: $1"
            show_usage
            ;;
        *)
            # Ignore additional arguments
            shift
            ;;
    esac
done

# Display processing mode
if [ ${#exclude_extensions[@]} -gt 0 ]; then
    echo "Excluded extensions: ${exclude_extensions[*]}"
elif [ ${#include_extensions[@]} -gt 0 ]; then
    echo "Including ONLY extensions: ${include_extensions[*]}"
else
    echo "No filtering - processing all file types"
fi

# Generate the output file name
output_file="${directory}/xtracted_$(date +%Y%m%d_%H%M%S).txt"

# Function to check if a file should be processed based on its extension
should_process_file() {
    local file="$1"
    local extension="${file##*.}"
    
    # If the file has no extension and we're in include mode with specified extensions
    if [ "$extension" = "$file" ] && $include_mode; then
        return 1
    fi
    
    # In include mode, only process files with the specified extensions
    if $include_mode; then
        for ext in "${include_extensions[@]}"; do
            if [ "$extension" = "$ext" ]; then
                return 0
            fi
        done
        return 1
    fi
    
    # In exclude mode, don't process files with the specified extensions
    if $exclude_mode; then
        for ext in "${exclude_extensions[@]}"; do
            if [ "$extension" = "$ext" ]; then
                return 1
            fi
        done
    fi
    
    # By default, process the file
    return 0
}

# Function to generate tree-like structure
generate_tree() {
    local dir="$1"
    local prefix="$2"
    local files=()
    local dirs=()

    # Read directory contents
    while IFS= read -r -d '' path; do
        if [[ -d "$path" ]]; then
            dirs+=("$path")
        else
            # Exclude xtracted_*.txt files from the tree
            if [[ ! $(basename "$path") =~ ^xtracted_.*\.txt$ ]]; then
                # Check if we should process the file based on extension
                if should_process_file "$path"; then
                    files+=("$path")
                fi
            fi
        fi
    done < <(find "$dir" -maxdepth 1 -mindepth 1 -print0 | sort -z)

    # Process directories
    local i=0
    for path in "${dirs[@]}"; do
        local name
        name=$(basename "$path")
        local skip_dir=0
        for exdir in "${exclude_dirs[@]}"; do
            if [[ "$name" == "$exdir" ]]; then
                skip_dir=1
                break
            fi
        done
        if [[ $skip_dir -eq 1 ]]; then
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
        local name
        name=$(basename "$path")
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
    echo
    echo "NOTE: Directories '.git', 'node_modules', and 'venv' are automatically excluded from analysis."
} > "$output_file"

# Function to check if a path should be excluded
should_exclude_dir() {
    local path="$1"
    for dir in "${exclude_dirs[@]}"; do
        if [[ "$path" == *"/$dir"* || "$path" == *"/$dir/"* ]]; then
            return 0
        fi
    done
    return 1
}

# Generate find command with directory exclusions
find_cmd="find \"$directory\""
for dir in "${exclude_dirs[@]}"; do
    find_cmd+=" -not -path \"*/$dir/*\""
done
find_cmd+=" -type f -print0"

# Loop through files to extract content, ignoring excluded directories and extensions
while IFS= read -r -d '' file; do
    if ! should_exclude_dir "$file" && [ "$file" != "$output_file" ] && 
       [[ ! $(basename "$file") =~ ^xtracted_.*\.txt$ ]] && 
       should_process_file "$file"; then
        filename=$(basename "$file")
        {
            echo -e "\n+-------------------"
            echo "# $filename"
            echo -e "+--------------------\n"
            # Filter out non-printable characters and replace � with a space
            tr -d '\000-\011\013-\037\177' < "$file" | tr '�' ''
            echo -e "\n"
        } >> "$output_file"
    fi
done < <(eval "$find_cmd")

# Final confirmation
echo "✅ Extraction complete: See the file $output_file"
if $exclude_mode; then
    echo "Files with extensions ${exclude_extensions[*]} were excluded from the output."
elif $include_mode; then
    echo "Only files with extensions ${include_extensions[*]} were included in the output."
else
    echo "All file types were included in the output."
fi

# End of script
exit 0