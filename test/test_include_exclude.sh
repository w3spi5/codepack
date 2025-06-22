#!/bin/bash
# filepath: test/test_include_exclude.sh

set -e

echo "Test: --include option"
../codepack.sh ../ --include md > output_include.txt
grep "README.md" output_include.txt

echo "Test: --exclude option"
../codepack.sh ../ --exclude md > output_exclude.txt
! grep "README.md" output_exclude.txt && echo "README.md correctly excluded"

echo "All include/exclude tests passed."
