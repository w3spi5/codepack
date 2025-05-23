#!/bin/bash
# ----------------------------------------------------------------------------
# x-tractor - CLI tool to extract folder structure and file contents
# Author: Ɛɔıs3 Solutions
# GitHub: https://github.com/w3spi5
# License: MIT
# Version: 2.8.1
# Dependencies: None
# ----------------------------------------------------------------------------
# This script scans a specified directory, generates a structural overview,
# and extracts the content of all files, excluding specified directories and extensions.
# ----------------------------------------------------------------------------
# Usage: ./x-tractor.sh <path/to/directory> [options]
# ----------------------------------------------------------------------------

# ====== CONFIGURATION ======
DEFAULT_EXCLUDE_DIRS=(".git" "node_modules" "venv")
DEFAULT_EXCLUDE_FILES=(".env")

# ====== UTILS ======
show_usage() {
    cat <<EOF
Usage: ./x-tractor.sh <path/to/directory> [options]
Options:
  --exclude <ext1> [<ext2> ...]  Exclude files with specified extensions (optional)
  --include <ext1> [<ext2> ...]  Include ONLY files with specified extensions (optional)
  --compress                     Compress output file with gzip (keeps original file)
Note: You cannot use both --include and --exclude at the same time
Examples:
  ./x-tractor.sh /home/user/Documents
  ./x-tractor.sh /home/user/Documents --exclude pdf jpg
  ./x-tractor.sh /home/user/Documents --include js html css
  ./x-tractor.sh /home/user/Documents --compress
EOF
    exit 1
}

format_number() {
    # Format number with thousands separator (space)
    local num=$1
    local result=""
    local length=${#num}
    local pos=0
    for ((i=length-1; i>=0; i--)); do
        result="${num:i:1}$result"
        pos=$((pos+1))
        if [ $pos -eq 3 ] && [ $i -ne 0 ]; then
            result=" $result"
            pos=0
        fi
    done
    echo "$result"
}

format_file_size() {
    local file_size="$1"
    if [ "$file_size" -lt 1024 ]; then
        echo "${file_size} bytes"
    elif [ "$file_size" -lt 1048576 ]; then
        if command -v bc > /dev/null 2>&1; then
            echo "$(echo "scale=2; $file_size / 1024" | bc) KB"
        else
            echo "$((file_size / 1024)) KB"
        fi
    elif [ "$file_size" -lt 1073741824 ]; then
        if command -v bc > /dev/null 2>&1; then
            echo "$(echo "scale=2; $file_size / 1048576" | bc) MB"
        else
            echo "$((file_size / 1048576)) MB"
        fi
    else
        if command -v bc > /dev/null 2>&1; then
            echo "$(echo "scale=2; $file_size / 1073741824" | bc) GB"
        else
            echo "$((file_size / 1073741824)) GB"
        fi
    fi
}

get_file_size() {
    local file="$1"
    if stat --version >/dev/null 2>&1; then
        stat -c%s "$file"
    else
        stat -f%z "$file"
    fi
}

get_line_count() {
    local file="$1"
    if [ -s "$file" ]; then
        wc -l < "$file"
    else
        echo 0
    fi
}

show_progress() {
    local current=$1
    local total=$2
    local percent=0
    if [ "$total" -gt 0 ]; then
        percent=$((current * 100 / total))
    fi
    local completed=$((percent / 2))
    local remaining=$((50 - completed))
    local progress="["
    for ((i=0; i<completed; i++)); do progress+="="; done
    if [ $completed -lt 50 ]; then
        progress+=">"
        for ((i=0; i<remaining-1; i++)); do progress+=" "; done
    else
        progress+="="
    fi
    progress+="] $percent%"
    echo -ne "\r$progress"
    if [ "$current" -eq "$total" ]; then
        echo -e "\r[==================================================] 100%"
        echo ""
    fi
}

compress_output_file() {
    local input_file="$1"
    local compressed_file="${input_file}.gz"
    echo "Compressing output file to reduce size..."
    gzip -9 -c "$input_file" > "$compressed_file"
    local original_size
    original_size=$(get_file_size "$input_file")
    local compressed_size
    compressed_size=$(get_file_size "$compressed_file")
    local ratio=0
    if [ "$original_size" -gt 0 ]; then
        ratio=$(( (original_size - compressed_size) * 100 / original_size ))
    fi
    echo "✅ Compression complete! Reduced file size by ${ratio}%"
    echo "Original file: $input_file ($(format_file_size "$original_size"))"
    echo "Compressed file: $compressed_file ($(format_file_size "$compressed_size"))"
    echo ""
    echo "To decompress, use one of these commands:"
    echo "  gzip -d \"$compressed_file\"       # This will delete the compressed file"
    echo "  gzip -d -k \"$compressed_file\"    # This will keep both files"
    echo "  gunzip -k \"$compressed_file\"     # Alternative command"
}

# ====== ARGUMENTS & GLOBALS ======
parse_args() {
    exclude_dirs=("${DEFAULT_EXCLUDE_DIRS[@]}")
    exclude_files=("${DEFAULT_EXCLUDE_FILES[@]}")
    exclude_extensions=()
    include_extensions=()
    include_mode=false
    exclude_mode=false
    compress_mode=false

    if [ "$#" -eq 0 ]; then show_usage; fi
    directory="$1"
    shift

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
                while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                    include_extensions+=("$1")
                    shift
                done
                ;;
            --compress)
                compress_mode=true
                shift
                ;;
            --*)
                echo "Unknown option: $1"
                show_usage
                ;;
            *)
                shift
                ;;
        esac
    done

    if [ ! -d "$directory" ]; then
        echo "Error: The specified directory does not exist."
        exit 1
    fi

    output_file="${directory}/xtracted_$(date +%Y%m%d_%H%M%S).txt"
}

# ====== FILTERS ======
should_process_file() {
    local file="$1"
    local extension="${file##*.}"
    if [ "$extension" = "$file" ] && $include_mode; then
        return 1
    fi
    if $include_mode; then
        for ext in "${include_extensions[@]}"; do
            if [ "$extension" = "$ext" ]; then return 0; fi
        done
        return 1
    fi
    if $exclude_mode; then
        for ext in "${exclude_extensions[@]}"; do
            if [ "$extension" = "$ext" ]; then return 1; fi
        done
    fi
    return 0
}

should_exclude_file() {
    local file="$1"
    local filename
    filename=$(basename "$file")
    for exclude_file in "${exclude_files[@]}"; do
        if [[ "$filename" == "$exclude_file" ]]; then return 0; fi
    done
    if [[ "$file" == "$output_file" || "$filename" =~ ^xtracted_.*\.txt$ ]]; then return 0; fi
    return 1
}

should_exclude_dir() {
    local path="$1"
    for dir in "${exclude_dirs[@]}"; do
        if [[ "$path" == *"/$dir"* || "$path" == *"/$dir/"* ]]; then return 0; fi
    done
    return 1
}

# ====== TREE GENERATION ======
generate_tree() {
    local dir="$1"
    local prefix="$2"
    local files=()
    local dirs=()
    local excluded_dirs=()
    local excluded_files=()
    while IFS= read -r -d '' path; do
        if [[ -d "$path" ]]; then
            local name
            name=$(basename "$path")
            local skip_dir=0
            for exdir in "${exclude_dirs[@]}"; do
                if [[ "$name" == "$exdir" ]]; then
                    excluded_dirs+=("$path")
                    skip_dir=1
                    break
                fi
            done
            if [[ $skip_dir -eq 0 ]]; then dirs+=("$path"); fi
        else
            local filename
            filename=$(basename "$path")
            local exclude=0
            if [[ "$path" == "$output_file" || "$filename" =~ ^xtracted_.*\.txt$ ]]; then continue; fi
            for exclude_file in "${exclude_files[@]}"; do
                if [[ "$filename" == "$exclude_file" ]]; then
                    excluded_files+=("$path")
                    exclude=1
                    break
                fi
            done
            if [[ $exclude -eq 0 ]]; then
                if should_process_file "$path"; then files+=("$path"); fi
            fi
        fi
    done < <(find "$dir" -maxdepth 1 -mindepth 1 -print0 | sort -z)
    local total_items=$((${#dirs[@]} + ${#excluded_dirs[@]} + ${#files[@]} + ${#excluded_files[@]}))
    local items_processed=0
    for path in "${dirs[@]}"; do
        local name
        name=$(basename "$path")
        items_processed=$((items_processed + 1))
        local new_prefix="$prefix│   "
        if [ $items_processed -eq $total_items ]; then
            echo "${prefix}└── $name/"
            new_prefix="$prefix    "
        else
            echo "${prefix}├── $name/"
        fi
        generate_tree "$path" "$new_prefix"
    done
    for path in "${excluded_dirs[@]}"; do
        local name
        name=$(basename "$path")
        items_processed=$((items_processed + 1))
        if [ $items_processed -eq $total_items ]; then
            echo "${prefix}└── $name/ (excluded by default)"
        else
            echo "${prefix}├── $name/ (excluded by default)"
        fi
    done
    for path in "${files[@]}"; do
        local name
        name=$(basename "$path")
        items_processed=$((items_processed + 1))
        if [ $items_processed -eq $total_items ]; then
            echo "${prefix}└── $name"
        else
            echo "${prefix}├── $name"
        fi
    done
    for path in "${excluded_files[@]}"; do
        local name
        name=$(basename "$path")
        items_processed=$((items_processed + 1))
        if [ $items_processed -eq $total_items ]; then
            echo "${prefix}└── $name (excluded by default)"
        else
            echo "${prefix}├── $name (excluded by default)"
        fi
    done
}

# ====== FILE LISTING & COUNT ======
list_files_to_process() {
    local dir="$1"
    local find_cmd="find \"$dir\""
    for exclude_dir in "${exclude_dirs[@]}"; do
        find_cmd+=" -not -path \"*/$exclude_dir/*\""
    done
    find_cmd+=" -type f -print0"
    while IFS= read -r -d '' file; do
        local filename
        filename=$(basename "$file")
        local exclude=0
        for exclude_file in "${exclude_files[@]}"; do
            if [[ "$filename" == "$exclude_file" ]]; then exclude=1; break; fi
        done
        if [[ "$filename" =~ ^xtracted_.*\.txt$ ]]; then exclude=1; fi
        if [[ $exclude -eq 0 ]] && should_process_file "$file"; then
            echo "$file"
        fi
    done < <(eval "$find_cmd")
}

count_files_to_process() {
    list_files_to_process "$1" | wc -l
}

# ====== EXTRACTION ======
extract_files_content() {
    local files=("$@")
    local total_files="${#files[@]}"
    local current_file=0
    for file in "${files[@]}"; do
        if ! should_exclude_dir "$file" && ! should_exclude_file "$file" && should_process_file "$file"; then
            local filename
            filename=$(basename "$file")
            {
                echo -e "\n+-------------------"
                echo "# $filename"
                echo -e "+--------------------\n"
                sed 's/�/ /g' < "$file" | tr -cd '\11\12\15\40-\176'
                echo -e "\n"
            } >> "$output_file"
            current_file=$((current_file + 1))
            show_progress "$current_file" "$total_files"
        fi
    done
    echo -e "\r[==================================================] 100%"
}

# ====== MAIN ======
main() {
    parse_args "$@"
    echo ""
    echo "Automatically excluding directories: $(printf "'%s', " "${exclude_dirs[@]}" | sed 's/, $//')"
    echo "Automatically excluding files: $(printf "'%s', " "${exclude_files[@]}" | sed 's/, $//')"
    if [ ${#exclude_extensions[@]} -gt 0 ]; then
        echo "Excluded extensions: ${exclude_extensions[*]}"
    elif [ ${#include_extensions[@]} -gt 0 ]; then
        echo "Including ONLY extensions: ${include_extensions[*]}"
    else
        echo "No filtering - processing all file types"
    fi
    if $compress_mode; then
        echo "Compression enabled - will generate compressed .gz file"
    fi
    echo ""
    echo "🗂️  Generation in progress, please wait ..."
    total_files=$(count_files_to_process "$directory")
    formatted_total=$(format_number "$total_files")
    echo "Found $formatted_total files to process"
    echo ""
    if [ "$total_files" -eq 0 ]; then
        echo "Aucun fichier à traiter dans ce dossier (après exclusions éventuelles)."
        exit 0
    fi
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
        echo "NOTE: Files '.env' are automatically excluded from analysis."
    } > "$output_file"
    mapfile -t files < <(list_files_to_process "$directory")
    extract_files_content "${files[@]}"
    if [ ! -f "$output_file" ]; then
        echo "Erreur : le fichier de sortie n'a pas été généré."
        exit 1
    fi
    echo "✅ Extraction complete"
    echo "See the file \"$output_file\" ($(format_number "$(get_line_count "$output_file")") lines, $(format_file_size "$(get_file_size "$output_file")"))"
    if $exclude_mode; then
        echo "Files with extensions ${exclude_extensions[*]} were excluded from the output."
    elif $include_mode; then
        echo "Only files with extensions ${include_extensions[*]} were included in the output."
    else
        echo "All file types were included in the output."
    fi
    if $compress_mode; then
        echo ""
        compress_output_file "$output_file"
    fi
    exit 0
}

main "$@"