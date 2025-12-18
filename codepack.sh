#!/bin/bash
# ----------------------------------------------------------------------------
# codepack - CLI tool to extract folder structure and file contents
# Author: Ɛɔıs3 Solutions
# GitHub: https://github.com/w3spi5
# License: MIT
# Version: 4.2
# Dependencies: Optional external minifiers for maximum compression
# ----------------------------------------------------------------------------

# Ensure script runs with bash, not sh (POSIX shell doesn't support arrays)
if [ -z "$BASH_VERSION" ]; then
    echo "Error: This script requires bash. Please run with: bash $0 $*" >&2
    echo "       Or make it executable: chmod +x $0 && ./$0 $*" >&2
    exit 1
fi

# ====== CONFIGURATION ======
DEFAULT_EXCLUDE_DIRS=(".git" "node_modules" "venv" "__pycache__" ".next" "dist" "build")
DEFAULT_EXCLUDE_FILES=(".env" ".DS_Store")

# ====== MINIFICATION TOOLS DETECTION ======
declare -A MINIFIERS
MINIFIERS_CHECKED=false

check_minifiers() {
    if $MINIFIERS_CHECKED; then return; fi

    command -v terser >/dev/null 2>&1 && MINIFIERS[js]="terser"
    command -v esbuild >/dev/null 2>&1 && MINIFIERS[js]="esbuild"
    command -v pyminify >/dev/null 2>&1 && MINIFIERS[python]="pyminify"
    python3 -c "import python_minifier" 2>/dev/null && MINIFIERS[python]="python_minifier"
    command -v csso >/dev/null 2>&1 && MINIFIERS[css]="csso"
    command -v cleancss >/dev/null 2>&1 && MINIFIERS[css]="cleancss"
    command -v html-minifier-terser >/dev/null 2>&1 && MINIFIERS[html]="html-minifier-terser"
    command -v minify >/dev/null 2>&1 && MINIFIERS[multi]="minify"
    command -v jq >/dev/null 2>&1 && MINIFIERS[json]="jq"

    MINIFIERS_CHECKED=true
}

# ====== EXTERNAL TOOL WRAPPER ======
run_external_minifier() {
    local tool_name="$1"
    local content="$2"
    local temp_file
    temp_file=$(mktemp)

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    echo "$content" > "$temp_file"

    # Timeout de 10 secondes pour éviter les blocages
    case "$tool_name" in
        "terser")
            timeout 10 terser --compress drop_console=true,drop_debugger=true --mangle --format ascii_only=true,beautify=false "$temp_file" 2>/dev/null || echo "$content"
            ;;
        "pyminify")
            timeout 10 pyminify --remove-literal-statements "$temp_file" 2>/dev/null || echo "$content"
            ;;
        "csso")
            timeout 10 csso "$temp_file" 2>/dev/null || echo "$content"
            ;;
        "html-minifier-terser")
            # Limite la taille pour html-minifier-terser qui peut planter sur de gros fichiers
            if [[ ${#content} -gt 30000 ]]; then
                debug_log "Fichier HTML trop gros (${#content} chars), fallback bash"
                echo "$content"
            else
                timeout 10 html-minifier-terser --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype --minify-css --minify-js "$temp_file" 2>/dev/null || echo "$content"
            fi
            ;;
        "jq")
            timeout 10 jq -c . "$temp_file" 2>/dev/null || echo "$content"
            ;;
        *)
            echo "$content"
            ;;
    esac

    rm -f "$temp_file"
}

# ====== MINIFICATION FUNCTIONS ======
minify_javascript() {
    local content="$1"

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    if [[ -n "${MINIFIERS[js]}" ]]; then
        run_external_minifier "${MINIFIERS[js]}" "$content"
    else
        echo "$content" | \
        sed 's|//.*$||g' 2>/dev/null | \
        sed ':a;N;$!ba;s|/\*[^*]*\*\+\([^/*][^*]*\*\+\)*/||g' 2>/dev/null | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' 2>/dev/null | \
        sed '/^[[:space:]]*$/d' 2>/dev/null | \
        tr '\n' ' ' | \
        sed 's/[[:space:]]\+/ /g' 2>/dev/null | \
        sed 's/; /;/g;s/{ /{/g;s/ }/}/g;s/, /,/g' 2>/dev/null || echo "$content"
    fi
}

minify_python() {
    local content="$1"

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    if [[ -n "${MINIFIERS[python]}" ]]; then
        run_external_minifier "${MINIFIERS[python]}" "$content"
    else
        echo "$content" | \
        sed '1{/^#!/!s/#.*$//};2,$s/#.*$//' 2>/dev/null | \
        sed 's/"""[^"]*"""/pass/g' 2>/dev/null | \
        sed "s/'''[^']*'''/pass/g" 2>/dev/null | \
        sed 's/[[:space:]]*$//' 2>/dev/null | \
        sed '/^[[:space:]]*$/d' 2>/dev/null | \
        sed '/^[[:space:]]*pass[[:space:]]*$/d' 2>/dev/null | \
        sed 's/[[:space:]]*=[[:space:]]*/=/g' 2>/dev/null | \
        sed 's/import[[:space:]]\+/import /g' 2>/dev/null | \
        sed 's/from[[:space:]]\+/from /g' 2>/dev/null || echo "$content"
    fi
}

minify_css() {
    local content="$1"

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    if [[ -n "${MINIFIERS[css]}" ]]; then
        run_external_minifier "${MINIFIERS[css]}" "$content"
    else
        echo "$content" | \
        sed ':a;N;$!ba;s|/\*[^*]*\*\+\([^/*][^*]*\*\+\)*/||g' 2>/dev/null | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' 2>/dev/null | \
        sed '/^[[:space:]]*$/d' 2>/dev/null | \
        tr '\n' ' ' | \
        sed 's/[[:space:]]\+/ /g' 2>/dev/null | \
        sed 's/[[:space:]]*{[[:space:]]*/{/g;s/[[:space:]]*}[[:space:]]*/}/g' 2>/dev/null | \
        sed 's/[[:space:]]*:[[:space:]]*/:/g;s/[[:space:]]*;[[:space:]]*/;/g' 2>/dev/null | \
        sed 's/[[:space:]]*,[[:space:]]*/,/g' 2>/dev/null || echo "$content"
    fi
}

minify_html() {
    local content="$1"

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    if [[ -n "${MINIFIERS[html]}" ]]; then
        run_external_minifier "${MINIFIERS[html]}" "$content"
    else
        echo "$content" | \
        sed ':a;N;$!ba;s|<!--[^>]*-->||g' 2>/dev/null | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' 2>/dev/null | \
        sed '/^[[:space:]]*$/d' 2>/dev/null | \
        tr '\n' ' ' | \
        sed 's/[[:space:]]\+/ /g' 2>/dev/null | \
        sed 's/>[[:space:]]*</></g' 2>/dev/null || echo "$content"
    fi
}

minify_json() {
    local content="$1"

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    if [[ -n "${MINIFIERS[json]}" ]]; then
        run_external_minifier "${MINIFIERS[json]}" "$content"
    else
        echo "$content" | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' 2>/dev/null | \
        sed '/^[[:space:]]*$/d' 2>/dev/null | \
        tr -d '\n\t' | \
        sed 's/[[:space:]]*:[[:space:]]*/:/g' 2>/dev/null | \
        sed 's/[[:space:]]*,[[:space:]]*/,/g' 2>/dev/null | \
        sed 's/[[:space:]]*{[[:space:]]*/{/g' 2>/dev/null | \
        sed 's/[[:space:]]*}[[:space:]]*/}/g' 2>/dev/null || echo "$content"
    fi
}

minify_generic() {
    local content="$1"

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    echo "$content" | \
    sed '/^[[:space:]]*#/d' 2>/dev/null | \
    sed 's/[[:space:]]*#.*$//' 2>/dev/null | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' 2>/dev/null | \
    sed '/^[[:space:]]*$/d' 2>/dev/null | \
    sed 's/[[:space:]]\+/ /g' 2>/dev/null || echo "$content"
}

minify_content() {
    local file="$1"
    local content="$2"
    local file_type
    file_type=$(get_file_type "$file")

    if [[ -z "$content" ]]; then
        echo ""
        return
    fi

    case "$file_type" in
        javascript) minify_javascript "$content" ;;
        css) minify_css "$content" ;;
        html) minify_html "$content" ;;
        python) minify_python "$content" ;;
        json) minify_json "$content" ;;
        *) minify_generic "$content" ;;
    esac
}

# ====== DEBUG UTILITY ======
debug_mode=false

debug_log() {
    if $debug_mode; then
        echo "DEBUG: $1" >&2
    fi
}
show_usage() {
    cat <<EOF
Usage: ./codepack.sh [path/to/directory] [options]
Options:
  --exclude <ext1> [<ext2> ...]  Exclude files with specified extensions
  --include <ext1> [<ext2> ...]  Include ONLY files with specified extensions
  --compress                     Compress output file with gzip
  --copy                         Copy output to system clipboard
  --minify                       Ultra-aggressive minification for AI processing
  --install-minifiers           Install recommended external minification tools
  --minify-info                 Show available minification tools
Examples:
  ./codepack.sh                              # Process current directory
  ./codepack.sh --minify --compress          # Process current directory with minification and compression
  ./codepack.sh /home/user/project --minify  # Process specific directory with minification
  ./codepack.sh --install-minifiers          # Install minification tools
  ./codepack.sh --minify-info                # Show minification tools status
EOF
    exit 1
}

show_minify_info() {
    check_minifiers
    echo "🔧 Minification Tools Status:"
    echo "================================"

    echo "JavaScript/TypeScript:"
    if [[ -n "${MINIFIERS[js]}" ]]; then
        echo "  ✅ ${MINIFIERS[js]} (external)"
    else
        echo "  ⛔ Not installed"
        echo "  📥 Install: npm install -g terser"
    fi

    echo "Python:"
    if [[ -n "${MINIFIERS[python]}" ]]; then
        echo "  ✅ ${MINIFIERS[python]} (external)"
    else
        echo "  ⛔ Not installed"
        echo "  📥 Install: pip3 install pyminify"
    fi

    echo "CSS:"
    if [[ -n "${MINIFIERS[css]}" ]]; then
        echo "  ✅ ${MINIFIERS[css]} (external)"
    else
        echo "  ⛔ Not installed"
        echo "  📥 Install: npm install -g csso-cli"
    fi

    echo "HTML:"
    if [[ -n "${MINIFIERS[html]}" ]]; then
        echo "  ✅ ${MINIFIERS[html]} (external)"
    else
        echo "  ⛔ Not installed"
        echo "  📥 Install: npm install -g html-minifier-terser"
    fi

    echo "JSON:"
    if [[ -n "${MINIFIERS[json]}" ]]; then
        echo "  ✅ jq (system)"
    else
        echo "  ⛔ Not installed"
        echo "  📥 Install: jq (via package manager)"
    fi

    echo
    echo "💡 Run with --install-minifiers to auto-install available tools"
    exit 0
}

install_minifiers() {
    echo "🚀 Installing recommended minifiers for maximum compression..."
    echo

    if command -v npm >/dev/null 2>&1; then
        echo "📦 Installing npm packages globally..."
        npm install -g terser csso-cli clean-css-cli html-minifier-terser 2>/dev/null || {
            echo "⚠️  npm install failed. You may need sudo or proper permissions."
        }
    else
        echo "⚠️  npm not found. Install Node.js first: https://nodejs.org/"
    fi

    if command -v pip3 >/dev/null 2>&1; then
        echo "🐍 Installing Python packages..."
        pip3 install pyminify python-minifier 2>/dev/null || {
            echo "⚠️  pip install failed. You may need --user flag or proper permissions."
        }
    else
        echo "⚠️  pip3 not found. Install Python 3 first."
    fi

    echo "📝 JSON minifier (jq) installation:"
    if command -v jq >/dev/null 2>&1; then
        echo "  ✅ jq is already installed"
    else
        echo "  📥 Install jq manually:"
        echo "     • macOS: brew install jq"
        echo "     • Ubuntu/Debian: sudo apt install jq"
        echo "     • Windows: winget install jqlang.jq"
    fi

    echo
    echo "✅ Installation complete. Re-run your command to use external minifiers."
    echo "💡 Use --minify-info to check installation status."
    exit 0
}

format_number() {
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

estimate_tokens() {
    local file_size="$1"
    # Estimation brute: 1 token ≈ 4 caractères
    echo "$((file_size / 4))"
}

format_file_size() {
    local file_size="$1"
    if [ "$file_size" -lt 1024 ]; then
        echo "${file_size} bytes"
    elif [ "$file_size" -lt 1048576 ]; then
        echo "$((file_size / 1024)) KB"
    elif [ "$file_size" -lt 1073741824 ]; then
        echo "$((file_size / 1048576)) MB"
    else
        echo "$((file_size / 1073741824)) GB"
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

    if [ "$current" -eq "$total" ]; then
        echo -e "\r[==================================================] 100%"
        echo ""
    else
        echo -ne "\r$progress"
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
    echo "To decompress, use: gzip -d -k \"$compressed_file\""
}

get_file_type() {
    local file="$1"
    local filename
    filename=$(basename "$file")
    local extension="${file##*.}"
    extension="${extension,,}"

    case "$filename" in
        .gitignore|.dockerignore|.eslintignore|.prettierignore|.npmignore) echo "ignore" ;;
        Dockerfile|dockerfile) echo "dockerfile" ;;
        Makefile|makefile) echo "makefile" ;;
        README|readme) echo "text" ;;
        LICENSE|license) echo "text" ;;
        .env*) echo "env" ;;
        .editorconfig) echo "text" ;;
        .htaccess) echo "text" ;;
        *)
            case "$extension" in
                js|jsx|ts|tsx|mjs) echo "javascript" ;;
                css|scss|sass|less) echo "css" ;;
                html|htm|xhtml) echo "html" ;;
                py|pyw) echo "python" ;;
                json) echo "json" ;;
                sh|bash) echo "shell" ;;
                java) echo "java" ;;
                c|cpp|cc|cxx|h|hpp) echo "c" ;;
                php) echo "php" ;;
                rb|ruby) echo "ruby" ;;
                go) echo "go" ;;
                rs|rust) echo "rust" ;;
                xml|xsl|xsd) echo "xml" ;;
                sql) echo "sql" ;;
                yml|yaml) echo "yaml" ;;
                toml) echo "toml" ;;
                ini|conf|config) echo "config" ;;
                md|markdown) echo "markdown" ;;
                txt) echo "text" ;;
                *) echo "text" ;;
            esac
            ;;
    esac
}

copy_to_clipboard() {
    local file="$1"
    if command -v pbcopy >/dev/null 2>&1; then
        cat "$file" | pbcopy
        echo "📋 Copied to clipboard (pbcopy)!"
    elif command -v wl-copy >/dev/null 2>&1; then
        cat "$file" | wl-copy
        echo "📋 Copied to clipboard (wl-copy)!"
    elif command -v xclip >/dev/null 2>&1; then
        cat "$file" | xclip -selection clipboard
        echo "📋 Copied to clipboard (xclip)!"
    elif command -v xsel >/dev/null 2>&1; then
        cat "$file" | xsel --clipboard --input
        echo "📋 Copied to clipboard (xsel)!"
    elif command -v clip.exe >/dev/null 2>&1; then
        cat "$file" | clip.exe
        echo "📋 Copied to clipboard (clip.exe)!"
    else
        echo "⚠️  Clipboard tool not found. Please install xclip, xsel, wl-copy or use macOS/WSL."
    fi
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
    minify_mode=false
    copy_mode=false
    debug_mode=false

    # Traitement des commandes spéciales sans argument de répertoire
    if [[ "$1" == "--install-minifiers" ]]; then
        install_minifiers
    elif [[ "$1" == "--minify-info" ]]; then
        show_minify_info
    fi

    # Déterminer le répertoire à traiter
    if [ "$#" -eq 0 ] || [[ "$1" =~ ^-- ]]; then
        # Aucun argument ou le premier argument est une option : utiliser le répertoire courant
        directory="."
    else
        # Le premier argument est le répertoire
        directory="$1"
        shift
    fi

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
            --copy)
                copy_mode=true
                shift
                ;;
            --minify)
                minify_mode=true
                shift
                ;;
            --debug)
                debug_mode=true
                shift
                ;;
            --install-minifiers)
                install_minifiers
                ;;
            --minify-info)
                show_minify_info
                ;;
            --*)
                echo "Unknown option: $1"
                echo "Available options: --minify, --compress, --exclude, --include, --debug, --install-minifiers, --minify-info"
                exit 1
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

    output_file="${directory}/codepack_$(date +%Y%m%d_%H%M%S).txt"
}

# ====== FILTERS ======
is_binary() {
    local file="$1"

    # Treat empty files as non-binary (safe to process)
    if [ ! -s "$file" ]; then
        return 1
    fi

    # Method 1: use grep -I (ignore binary)
    # Returns 0 (success) if text file (matches empty string)
    # Returns 1 (failure) if binary file (treated as empty content)
    # Returns 2 (error) if -I is not supported
    if grep -I -q "" "$file" 2>/dev/null; then
        return 1 # Text
    else
        local exit_code=$?
        if [ $exit_code -eq 1 ]; then
            return 0 # Binary (grep -I ran and found no match)
        fi
    fi

    # Method 2: use Perl if available (reliable and portable)
    if command -v perl >/dev/null 2>&1; then
        if perl -e 'exit((-B $ARGV[0]) ? 0 : 1)' "$file" 2>/dev/null; then
            return 0 # Binary
        else
            return 1 # Text
        fi
    fi

    # Method 3: Check for null bytes (fallback)
    # LC_ALL=C ensures byte-based processing
    if LC_ALL=C grep -q '[^[:print:][:space:]]' <(head -c 1000 "$file") 2>/dev/null; then
         # This is aggressive (detects any non-printable), maybe too aggressive?
         # Better to check for null bytes specifically using tr
         if head -c 1000 "$file" | tr -d '\0' | [ $(wc -c) -lt $(head -c 1000 "$file" | wc -c) ]; then
             return 0 # Binary (null bytes detected)
         fi
    fi

    return 1 # Assume text if uncertain
}

should_process_file() {
    local file="$1"
    local extension="${file##*.}"
    if [ "$extension" = "$file" ] && $include_mode; then
        return 1
    fi
    if $exclude_mode; then
        for ext in "${exclude_extensions[@]}"; do
            clean_ext="${ext#.}"
            if [ "$extension" = "$clean_ext" ]; then return 1; fi
        done
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
    if [[ "$file" == "$output_file" || "$filename" =~ ^codepack_.*\.txt$ ]]; then return 0; fi
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

    # Use bash globs to list all files/dirs (except . and ..) sorted alphabetically
    # faster than find + sort or ls in a recursive loop and portable (Bash 3.2+)
    local saved_nullglob=$(shopt -p nullglob)
    local saved_dotglob=$(shopt -p dotglob)
    shopt -s nullglob dotglob

    local entries=("$dir"/*)

    eval "$saved_nullglob"
    eval "$saved_dotglob"

    for path in "${entries[@]}"; do
        local name
        name=$(basename "$path")
        if [[ -d "$path" ]]; then
            local skip_dir=0
            for exdir in "${exclude_dirs[@]}"; do
                if [[ "$name" == "$exdir" ]]; then
                    excluded_dirs+=("$path")
                    skip_dir=1
                    break
                fi
            done
            if [[ $skip_dir -eq 0 ]]; then dirs+=("$path"); fi
        elif [[ -f "$path" ]]; then
            local exclude=0
            if [[ "$path" == "$output_file" || "$name" =~ ^codepack_.*\.txt$ ]]; then continue; fi
            for exclude_file in "${exclude_files[@]}"; do
                if [[ "$name" == "$exclude_file" ]]; then
                    excluded_files+=("$path")
                    exclude=1
                    break
                fi
            done
            if [[ $exclude -eq 0 ]]; then
                if should_process_file "$path"; then files+=("$path"); fi
            fi
        fi
    done

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
            echo "${prefix}└── $name/ (excluded)"
        else
            echo "${prefix}├── $name/ (excluded)"
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
            echo "${prefix}└── $name (excluded)"
        else
            echo "${prefix}├── $name (excluded)"
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
        if [[ "$filename" =~ ^codepack_.*\.txt$ ]]; then exclude=1; fi
        if [[ $exclude -eq 0 ]] && should_process_file "$file"; then
            echo "$file"
        fi
    done < <(eval "$find_cmd" 2>/dev/null)
}

count_files_to_process() {
    list_files_to_process "$1" | wc -l
}

# ====== EXTRACTION ======
extract_files_content() {
    local files=("$@")
    local total_files="${#files[@]}"
    local current_file=0
    local processed_files=0

    for file in "${files[@]}"; do
        current_file=$((current_file + 1))

        debug_log "Processing file $current_file/$total_files: $file" >&2

        # Redundant checks removed - files are already filtered by list_files_to_process
        local filename
        filename=$(basename "$file")

        debug_log "Reading content from: $filename" >&2

        if is_binary "$file"; then
             echo "Skipping binary file: $filename" >&2
             show_progress "$current_file" "$total_files"
             continue
        fi

        # Read file content and clean invalid characters
        local content=""
        if [[ -r "$file" && -s "$file" ]]; then
            content=$(cat "$file" 2>/dev/null | sed 's// /g' 2>/dev/null | tr -cd '\11\12\15\40-\176' 2>/dev/null || echo "")
        fi

        debug_log "Content length: ${#content}" >&2

        # Apply ultra-aggressive minification if enabled
        if $minify_mode && [[ -n "$content" ]]; then
            debug_log "Starting minification for: $filename" >&2
            content=$(minify_content "$file" "$content" 2>/dev/null || echo "$content")
            debug_log "Minification complete for: $filename" >&2
        fi

        # Check if content is empty or only whitespace after processing
        local cleaned_content=""
        if [[ -n "$content" ]]; then
            cleaned_content=$(echo "$content" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' 2>/dev/null | sed '/^[[:space:]]*$/d' 2>/dev/null)
        fi

        # Only write to output if file has actual content
        if [[ -n "$cleaned_content" ]]; then
            debug_log "Writing to output: $filename" >&2
            {
                echo -e "\n+-------------------"
                echo "# $filename"
                echo -e "+--------------------\n"
                echo "$content"
                echo -e "\n"
            } >> "$output_file" 2>/dev/null
            processed_files=$((processed_files + 1))
        fi

        show_progress "$current_file" "$total_files"
    done

    # Report how many files were actually processed vs total found
    if [ "$processed_files" -lt "$total_files" ]; then
        local skipped_files=$((total_files - processed_files))
        echo "📝 Processed $processed_files files (skipped $skipped_files empty files)"
    fi
}

# ====== MAIN FUNCTION ======
main() {
    local start_time
    start_time=$(date +%s)
    parse_args "$@"
    check_minifiers

    echo ""
    echo "🔧 codepack v4.2"
    echo "Automatically excluding directories: $(printf "'%s', " "${exclude_dirs[@]}" | sed 's/, $//')"
    echo "Automatically excluding files: $(printf "'%s', " "${exclude_files[@]}" | sed 's/, $//')"

    if [ ${#exclude_extensions[@]} -gt 0 ]; then
        echo "Excluded extensions: ${exclude_extensions[*]}"
    elif [ ${#include_extensions[@]} -gt 0 ]; then
        echo "Including ONLY extensions: ${include_extensions[*]}"
    else
        echo "No filtering - processing all file types"
    fi

    if $minify_mode; then
        echo ""
        echo "🚀 Ultra-aggressive minification enabled:"
        local minifier_count=0
        [[ -n "${MINIFIERS[js]}" ]] && echo "  ✅ JavaScript: ${MINIFIERS[js]}" && ((minifier_count++))
        [[ -n "${MINIFIERS[python]}" ]] && echo "  ✅ Python: ${MINIFIERS[python]}" && ((minifier_count++))
        [[ -n "${MINIFIERS[css]}" ]] && echo "  ✅ CSS: ${MINIFIERS[css]}" && ((minifier_count++))
        [[ -n "${MINIFIERS[html]}" ]] && echo "  ✅ HTML: ${MINIFIERS[html]}" && ((minifier_count++))
        [[ -n "${MINIFIERS[json]}" ]] && echo "  ✅ JSON: jq" && ((minifier_count++))
        [[ -n "${MINIFIERS[multi]}" ]] && echo "  ✅ Multi-format: ${MINIFIERS[multi]}" && ((minifier_count++))

        if [ "$minifier_count" -eq 0 ]; then
            echo "  ⚠️  Using fallback bash minification only"
            echo "  💡 Run with --install-minifiers for better compression"
        else
            echo "  🎯 Expected compression: 50-70% size reduction"
        fi
    fi

    if $compress_mode; then
        echo "📦 Compression enabled - will generate compressed .gz file"
    fi

    if $debug_mode; then
        echo "🔍 Debug mode enabled - showing detailed processing information"
    fi

    echo ""
    echo "🗂️  Generation in progress, please wait ..."

    # Capture files list once to avoid double traversal
    mapfile -t files < <(list_files_to_process "$directory")
    total_files=${#files[@]}
    formatted_total=$(format_number "$total_files")
    echo "Found $formatted_total files to process"
    echo ""

    if [ "$total_files" -eq 0 ]; then
        echo "No files to process in this directory (after exclusions)."
        exit 0
    fi

    # Generate header
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
        echo "NOTE: Directories $(printf "'%s', " "${exclude_dirs[@]}" | sed 's/, $//') are automatically excluded."
        echo "NOTE: Files $(printf "'%s', " "${exclude_files[@]}" | sed 's/, $//') are automatically excluded."
        if $minify_mode; then
            local estimated_reduction="30-50%"
            if [ "$minifier_count" -gt 3 ]; then
                estimated_reduction="50-70%"
            elif [ "$minifier_count" -gt 0 ]; then
                estimated_reduction="30-50%"
            else
                estimated_reduction="15-25%"
            fi
            echo "NOTE: Content has been ultra-minified for AI processing - estimated reduction: $estimated_reduction"
            if [ "$minifier_count" -gt 0 ]; then
                echo "NOTE: Using $minifier_count external minification tools for maximum compression."
            fi
        fi
    } > "$output_file"

    extract_files_content "${files[@]}"

    if [ ! -f "$output_file" ]; then
        echo "Error: Output file was not generated."
        exit 1
    fi

    # Display results
    local final_size
    final_size=$(get_file_size "$output_file")
    local line_count
    line_count=$(get_line_count "$output_file")

    local end_time
    end_time=$(date +%s)
    local elapsed=$((end_time - start_time))
    local time_str=""
    if [ "$elapsed" -lt 30 ]; then
        time_str="only $elapsed seconds !!"
    elif [ "$elapsed" -ge 3600 ]; then
        local hours=$((elapsed / 3600))
        local mins=$(( (elapsed % 3600) / 60 ))
        local secs=$((elapsed % 60))
        time_str="${hours}h"
        [ $mins -gt 0 ] && time_str="${time_str}${mins}min"
        [ $secs -gt 0 ] && time_str="${time_str}${secs}s"
    elif [ "$elapsed" -ge 60 ]; then
        local mins=$((elapsed / 60))
        local secs=$((elapsed % 60))
        time_str="${mins}min"
        [ $secs -gt 0 ] && time_str="${time_str}${secs}s"
    else
        time_str="${elapsed}s"
    fi

    echo "✅ Extraction complete"
    echo "📄 Output: \"$output_file\""
    local estimated_tokens=$(estimate_tokens "$final_size")
    echo "📊 Stats: $(format_number "$line_count") lines, $(format_file_size "$final_size") (~$(format_number "$estimated_tokens") tokens), in $time_str"

    if $exclude_mode; then
        echo "🚫 Files with extensions ${exclude_extensions[*]} were excluded."
    elif $include_mode; then
        echo "✅ Only files with extensions ${include_extensions[*]} were included."
    else
        echo "📁 All file types were processed."
    fi

    if $minify_mode; then
        local minifier_count=0
        [[ -n "${MINIFIERS[js]}" ]] && ((minifier_count++))
        [[ -n "${MINIFIERS[python]}" ]] && ((minifier_count++))
        [[ -n "${MINIFIERS[css]}" ]] && ((minifier_count++))
        [[ -n "${MINIFIERS[html]}" ]] && ((minifier_count++))
        [[ -n "${MINIFIERS[json]}" ]] && ((minifier_count++))
        [[ -n "${MINIFIERS[multi]}" ]] && ((minifier_count++))

        echo "🚀 Ultra-aggressive minification applied for optimal AI processing."
        if [ "$minifier_count" -gt 0 ]; then
            echo "⚡ Used $minifier_count external minification tools."
        else
            echo "💡 Install external tools with --install-minifiers for better compression."
        fi
    fi

    if $copy_mode; then
        echo ""
        copy_to_clipboard "$output_file"
    fi

    if $compress_mode; then
        echo ""
        compress_output_file "$output_file"
    fi

    echo ""
    echo "🎯 Ready for AI analysis! Use --minify-info to check available tools."
    exit 0
}

main "$@"
