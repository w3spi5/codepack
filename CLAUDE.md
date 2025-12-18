# Codepack - Project Instructions for Claude

## Project Overview

**Codepack** is a CLI tool that extracts folder structure and file contents into a single text file, optimized for AI processing (ChatGPT, Claude, etc.).

## Key Features

- **Directory tree generation**: Visual representation of project structure
- **File content extraction**: Concatenates all relevant files into one output
- **Smart exclusions**: Auto-excludes `.git`, `node_modules`, `venv`, `__pycache__`, etc.
- **Minification**: Ultra-aggressive content compression for token optimization
- **Binary detection**: Skips binary files automatically
- **Clipboard support**: Copy output directly to clipboard
- **Gzip compression**: Optional output compression

## Project Structure

```
codepack/
├── codepack.sh          # Main script (Bash)
├── CLAUDE.md            # This file
├── CHANGELOG.md         # Version history
├── README.md            # User documentation
├── LICENSE              # MIT License
├── package.json         # npm package config
├── logo.png             # Project logo
├── test/                # Test scripts
│   ├── test_basic.sh    # Basic functionality tests
│   └── test_features.sh # Feature tests
└── .github/
    └── workflows/
        └── publish.yml  # GitHub Packages workflow
```

## Technical Details

### Requirements
- **Bash 4.0+** (uses arrays, associative arrays)
- NOT compatible with POSIX `sh` (BusyBox ash, dash, etc.)

### External Minifiers (Optional)
- `terser` / `esbuild` - JavaScript
- `pyminify` - Python
- `csso` / `cleancss` - CSS
- `html-minifier-terser` - HTML
- `jq` - JSON

## Development Guidelines

### When modifying `codepack.sh`:
1. Maintain Bash compatibility (arrays, `[[ ]]`, `declare -A`)
2. Keep the guard at the top that checks for `$BASH_VERSION`
3. Test with both `bash codepack.sh` and `./codepack.sh`
4. Update version number in header AND in `main()` function

### Testing
```bash
cd test/
bash test_basic.sh
bash test_features.sh
```

### Output Format
The generated file includes:
1. Directory tree structure
2. File contents with separators
3. Exclusion notes
4. Minification notes (if enabled)

## Common Tasks

### Add new file type for minification
1. Add detection in `get_file_type()` function
2. Create `minify_<type>()` function
3. Add case in `minify_content()` switch

### Add new exclusion directory
Add to `DEFAULT_EXCLUDE_DIRS` array at line 19

### Add new exclusion file
Add to `DEFAULT_EXCLUDE_FILES` array at line 20
