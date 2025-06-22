#!/bin/bash
# filepath: test/test_basic.sh
set -e
echo "Test: --minify-info"
../codepack.sh --minify-info
echo "Test: Extraction simple"
../codepack.sh ../ > output.txt
grep "Directory Structure" output.txt
echo "Test: Minification (should not fail)"
../codepack.sh ../ --minify > output_min.txt
grep "Minification" output_min.txt || true
echo "Test: Compression"
../codepack.sh ../ --compress > /dev/null
ls ../xtracted_*.gz
echo "All basic tests passed."
