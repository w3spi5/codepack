# Test Directory - Instructions for Claude

## Purpose

This directory contains test scripts for validating codepack functionality.

## Test Files

### `test_basic.sh`
Basic functionality tests:
- `--minify-info` command
- Simple extraction
- Minification (non-failing)
- Compression (`--compress`)

### `test_features.sh`
Advanced feature tests:
- Token estimation in stats output
- Clipboard support (`--copy`) with mocked `pbcopy`
- Binary file detection and skipping

## Running Tests

```bash
cd test/
bash test_basic.sh
bash test_features.sh
```

## Test Requirements

- **Bash 4.0+**
- Tests must be run from the `test/` directory
- Tests create temporary files that are cleaned up automatically

## Adding New Tests

1. Create test in appropriate file (basic vs feature)
2. Use `set -e` for fail-fast behavior
3. Echo test name before running
4. Clean up temporary files at end
5. Exit with code 1 on failure

## Notes

- `test_features.sh` creates a mock `pbcopy` for clipboard testing
- Binary detection test creates a file with null bytes
- All tests should pass before releasing a new version
