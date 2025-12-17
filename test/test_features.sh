#!/bin/bash
set -e

# Mock clipboard tools to test logic flow
# We create a fake 'pbcopy' in a temporary bin directory and add it to PATH
mkdir -p ./tmp_bin
cat > ./tmp_bin/pbcopy <<EOF
#!/bin/bash
cat > ./tmp_bin/clipboard_content
EOF
chmod +x ./tmp_bin/pbcopy
export PATH="$(pwd)/tmp_bin:$PATH"

echo "Test: Token Estimation"
../codepack.sh ../ > output.txt
if grep -q "tokens)" output.txt; then
    echo "Token estimation found in stats: OK"
else
    echo "ERROR: Token estimation not found in stats"
    exit 1
fi

echo "Test: Clipboard Support (--copy)"
../codepack.sh ../ --copy > output_copy.txt
if [ -f ./tmp_bin/clipboard_content ]; then
    echo "Clipboard content file created: OK"
    # Verify content matches output (roughly, ignoring timestamps if any diffs exist, but here we just check size > 0)
    if [ -s ./tmp_bin/clipboard_content ]; then
         echo "Clipboard content is not empty: OK"
    else
         echo "ERROR: Clipboard content is empty"
         exit 1
    fi
else
    echo "ERROR: Clipboard content file not created (mock pbcopy not called?)"
    exit 1
fi

echo "Test: Binary File Detection"
# Create a dummy binary file (contains null byte)
printf "Hello\0World" > binary_file.bin
# Run codepack on current dir
../codepack.sh . > output_binary.txt 2>&1
if grep -q "Skipping binary file" output_binary.txt || grep -q "binary_file.bin" output_binary.txt; then
    # Wait, grep "binary_file.bin" might appear in tree structure.
    # We want to check if content was skipped.
    # The script prints "Skipping binary file" to stderr.
    # So we captured stderr to output_binary.txt
    if grep -q "Skipping binary file" output_binary.txt; then
         echo "Binary file skipping detected in logs: OK"
    else
         echo "ERROR: Binary file skipping message not found"
         exit 1
    fi
else
    echo "ERROR: Binary file skipping message not found"
    exit 1
fi

# Cleanup
rm -rf ./tmp_bin binary_file.bin output.txt output_copy.txt output_binary.txt

echo "All feature tests passed."
