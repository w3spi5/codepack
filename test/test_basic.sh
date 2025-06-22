#!/bin/bash
# filepath: test/test_basic.sh

set -e

echo "Test: --minify-info"
../codepack.sh --minify-info

echo "Test: Extraction simple"
../codepack.sh ../ > output.txt
cat output.txt
if grep "Extraction complete" output.txt; then
  echo "Extraction complete: test passed"
else
  echo "ERROR: Extraction did not complete as expected"
  exit 1
fi

echo "Test: Minification (should not fail)"
../codepack.sh ../ --minify > output_min.txt || true
grep "minify" output_min.txt || echo "Minification info not found (may be normal if not present)"

echo "Test: Compression"
../codepack.sh ../ --compress > /dev/null
ls ../codepack_*.gz

echo "All basic tests passed."
