# codepack v4

<!-- Badges: build, version, license -->
<p align="center">
  <a href="https://github.com/w3spi5/codepack/actions">
    <img src="https://github.com/w3spi5/codepack/actions/workflows/publish.yml/badge.svg" alt="Build Status"/>
  </a>
  <a href="https://github.com/w3spi5/codepack/releases">
    <img src="https://img.shields.io/github/v/release/w3spi5/codepack?label=release" alt="Latest Release"/>
  </a>
  <a href="https://github.com/w3spi5/codepack/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/w3spi5/codepack" alt="License"/>
  </a>
</p>

<p align="center">
  <img src="logo.png" alt="codepack Logo" height="250"/>
</p>

[See latest releases](https://github.com/w3spi5/codepack/releases)

Ultra-efficient CLI tool to extract folder structure and file contents with advanced minification for AI processing.

It's an essential utility for developers, system administrators, and power users who need an efficient solution for file management, data extraction, and AI-ready code preparation.

## Features

- 📂 Generate a complete directory structure overview
- 📄 Extract the content of all files in a directory tree
- 🚫 Automatically exclude specific directories from scanning (`.git`, `node_modules`, `venv`, `__pycache__`, `.next`, `dist`, `build`)
- 🔧 Filter files by extension with `--exclude` option
- 🎯 Include only specific file types with `--include` option
- ⚡ **ULTRA-AGGRESSIVE:** Advanced minification with `--minify` option (50-70% size reduction)
- 🛠️ **SMART:** External minification tools integration for maximum compression
- 📦 Compress output files with `--compress` option
- 🔍 **DEBUG MODE:** Advanced debugging with `--debug` option for troubleshooting
- 🗂️ **INTELLIGENT:** Skip empty files automatically (no more useless sections)
- 🔄 Support for special files (`.gitignore`, `Dockerfile`, `README`, etc.)
- 🎨 Produces aesthetically pleasing tree-like output
- 🔄 Supports versioning of extracted data
- ✅ Automated tests and continuous integration with GitHub Actions
- ✨ **NEW:** **DEFAULT CURRENT DIRECTORY:** Simply run `./codepack` to process current directory

## Functionality Checklist

- ✅ **Directory Structure Generation**

  - Tree-like visualization of folders and files
  - Proper indentation and branch lines
  - Marking of excluded directories and files
  - Non-recursive exploration of excluded directories

- ✅ **Content Extraction**

  - Multi-file content extraction in a single operation
  - Proper file content formatting with headers
  - Automatic character encoding fixes
  - Filtering of non-printable characters
  - Intelligent empty file detection and skipping

- ✅ **Filtering Options**

  - Automatic exclusion of system directories (`.git`, `node_modules`, `venv`, `__pycache__`, `.next`, `dist`, `build`)
  - Automatic exclusion of sensitive files (`.env`, `.DS_Store`)
  - Extension-based inclusion with `--include` option
  - Extension-based exclusion with `--exclude` option

- ✅ **Ultra-Aggressive Content Optimization**

  - Smart minification with `--minify` option (50-70% reduction)
  - External minification tools integration (terser, pyminify, csso, etc.)
  - Language-aware ultra-aggressive comment removal
  - Advanced whitespace optimization
  - Special file types support (`.gitignore`, `Dockerfile`, `YAML`, etc.)
  - Python ultra-minification (removes excess spaces around operators)
  - AI-optimized content formatting

- ✅ **Tool Management**

  - `--install-minifiers` command for automatic tool installation
  - `--minify-info` command to check available tools
  - Intelligent fallback to bash minification
  - External tool detection and configuration

- ✅ **Compression & Output**

  - Gzip compression with `--compress` option
  - File size reduction statistics
  - Compression ratio reporting
  - Processing statistics (files processed vs skipped)

- ✅ **User Experience**

  - Progress bar with percentage display
  - File counter with thousands separator
  - Formatted file size display (bytes, KB, MB)
  - Clear completion messages
  - Timestamped output files
  - Detailed minification tool status reporting
  - **Default current directory processing** - no path required

- ✅ **Debugging & Troubleshooting**

  - Debug mode with `--debug` option
  - Detailed file processing information
  - Content length tracking
  - Minification process monitoring
  - Smart debug output (only when requested)

## Use Cases

- Project documentation
- Codebase analysis
- System audits
- Backup preparation
- Development project snapshots
- **AI code analysis and processing** (optimized for Claude, GPT, etc.)
- **Large codebase compression for sharing**
- **Ultra-compact code preparation for AI tools**
- **Quick current directory analysis** (just run `./codepack`)

## Installation

```bash
git clone https://github.com/w3spi5/codepack.git
cd codepack
chmod +x codepack.sh
```

### Install External Minification Tools (Recommended)

For maximum compression (50-70% size reduction), install external tools:

```bash
# Automatic installation
./codepack.sh --install-minifiers

# Manual installation
npm install -g terser csso-cli html-minifier-terser  # JavaScript, CSS, HTML
pip3 install pyminify python-minifier                # Python
brew install jq                                       # JSON (macOS)
# sudo apt install jq                                 # JSON (Ubuntu)
go install github.com/tdewolff/minify/v2/cmd/minify@latest  # Multi-format (optional)
```

## Usage

```bash
./codepack.sh [path/to/directory] [options]
```

**NEW:** The directory path is now **optional**! If no directory is specified, codepack will process the current directory.

### Options
- `--exclude <ext1> [<ext2> ...]` - Exclude files with specified extensions
- `--include <ext1> [<ext2> ...]` - Include ONLY files with specified extensions
- `--minify` - **Ultra-aggressive minification** (50-70% size reduction with external tools)
- `--compress` - Compress output file with gzip
- `--debug` - **Enable debug mode** for detailed processing information
- `--install-minifiers` - Install recommended external minification tools
- `--minify-info` - Show status of available minification tools

**Note:** You cannot use both `--include` and `--exclude` at the same time

## Automated Testing

This project now includes automated tests to ensure reliability and stability.

- Basic and advanced tests are located in the `test/` folder.
- To run all tests locally:
  ```bash
  cd test
  ./test_basic.sh
  ```
- Tests are also executed automatically on every push and pull request via GitHub Actions.

See the [test/](test/) folder for details.

## Continuous Integration

Every push and pull request triggers a GitHub Actions workflow that:

- Runs minimal and advanced tests (see `.github/workflows/publish.yml`)
- Verifies that the CLI works with `--minify-info` and other options
- Ensures code quality before publishing to npm or GitHub Packages

You can check the build status at the top of this README.

## How to publish

To publish this package to GitHub Packages or npm:

1. Add your npm or GitHub token as a repository secret named `NPM_TOKEN` (see GitHub > Settings > Secrets and variables > Actions).
2. The `.npmrc` file is already configured for GitHub Packages.
3. The publish step is automated in the GitHub Actions workflow.

**Never commit your token in the code or repository.**

### Examples

#### Current Directory Processing
```bash
# Process current directory (no path needed!)
./codepack.sh

# Current directory with ultra-minification (recommended for AI)
./codepack.sh --minify

# Current directory with maximum compression
./codepack.sh --minify --compress

# Current directory with specific file types only
./codepack.sh --include js css html py --minify

# Current directory excluding binary files
./codepack.sh --exclude pdf jpg png --minify

# Current directory with debug mode
./codepack.sh --debug

# Current directory with minification and debug
./codepack.sh --minify --debug
```

#### Specific Directory Processing
```bash
# Process specific directory
./codepack.sh /home/user/project

# Ultra-aggressive minification on specific directory
./codepack.sh /home/user/project --minify

# Maximum compression on specific directory
./codepack.sh /home/user/project --minify --compress

# Process only code files with ultra-minification
./codepack.sh /home/user/project --include js css html py --minify

# Exclude binary files and minify
./codepack.sh /home/user/project --exclude pdf jpg png --minify

# Debug mode for troubleshooting specific directory
./codepack.sh /home/user/project --debug

# Debug with minification to see processing details
./codepack.sh /home/user/project --minify --debug

# Debug with specific file types
./codepack.sh /home/user/project --include js py --minify --debug
```

#### Tool Management
```bash
# Check available minification tools
./codepack.sh --minify-info

# Install minification tools automatically
./codepack.sh --install-minifiers
```

#### Quick Workflow Examples
```bash
# Quick analysis of current project (most common use case)
./codepack.sh --minify

# Share current project with AI tools (ultra-compact)
./codepack.sh --minify --compress

# Debug current project processing
./codepack.sh --debug --minify

# Process only code files in current directory
./codepack.sh --include js py css html --minify
```

## Ultra-Aggressive Minification

The `--minify` option provides **intelligent ultra-aggressive optimization** with **external tool integration**:

### Supported External Tools

#### JavaScript/TypeScript
- **terser** (recommended) - Ultra-aggressive JS minification
- **esbuild** - Fast alternative minifier
- **Expected reduction:** 60-80%

#### Python
- **pyminify** - Specialized Python minifier
- **python-minifier** - Advanced Python optimization
- **Expected reduction:** 50-70%

#### CSS
- **csso-cli** - Advanced CSS optimizer
- **clean-css-cli** - Alternative CSS minifier
- **Expected reduction:** 70-85%

#### HTML
- **html-minifier-terser** - Comprehensive HTML minification
- **Expected reduction:** 40-60%

#### JSON
- **jq** - Native JSON compactor
- **Expected reduction:** 30-50%

#### Multi-format
- **minify** (Go tool) - Universal minifier for multiple formats

### Supported File Types

#### Programming Languages
- **JavaScript/TypeScript** (`.js`, `.jsx`, `.ts`, `.tsx`, `.mjs`)
- **Python** (`.py`, `.pyw`) - **Ultra-aggressive space removal**
- **CSS/Preprocessors** (`.css`, `.scss`, `.sass`, `.less`)
- **HTML** (`.html`, `.htm`, `.xhtml`)
- **Java/C/C++** (`.java`, `.c`, `.cpp`, `.h`, `.hpp`)
- **Shell Scripts** (`.sh`, `.bash`)
- **PHP** (`.php`)
- **Ruby** (`.rb`, `.ruby`)
- **Go** (`.go`)
- **Rust** (`.rs`)
- **XML** (`.xml`, `.xsl`, `.xsd`)
- **SQL** (`.sql`)

#### Configuration & Special Files
- **Ignore files** (`.gitignore`, `.dockerignore`, `.eslintignore`, etc.)
- **Dockerfile** (preserves functionality)
- **YAML** (`.yml`, `.yaml`) - preserves indentation
- **TOML** (`.toml`)
- **Config files** (`.ini`, `.conf`, `.config`)
- **Markdown** (`.md`) - light optimization for AI readability
- **Makefile**
- **README**, **LICENSE** files

### Minification Features

#### Ultra-Aggressive Optimizations
- ✅ **Comments removal** (all types: `//`, `/* */`, `#`, `<!--`, `--`)
- ✅ **Whitespace compression** (preserving syntax)
- ✅ **Empty lines elimination**
- ✅ **Operator spacing optimization** (`a = b` → `a=b`)
- ✅ **Parentheses/brackets spacing** (`( a , b )` → `(a,b)`)
- ✅ **Import statement cleanup** (`import   module` → `import module`)
- ✅ **String quote spacing** (`' string '` → `'string'`)

#### Language-Specific Intelligence
- **Python:** Preserves critical indentation, removes docstrings
- **CSS:** Optimizes selectors and property spacing
- **HTML:** Removes optional tags and attributes
- **JavaScript:** Console.log removal, variable mangling (with terser)
- **JSON:** Complete whitespace removal
- **YAML:** Preserves indentation hierarchy

### Performance Results
- **With external tools:** 50-70% size reduction
- **Bash fallback only:** 30-40% size reduction
- **Empty files:** Automatically skipped (no pollution)

## Debug Mode

The `--debug` option provides **detailed processing information** for troubleshooting and monitoring:

### Debug Features
- **File processing tracking:** Shows current file being processed
- **Content analysis:** Reports file sizes and content length
- **Minification monitoring:** Tracks minification start/completion
- **Processing statistics:** Real-time processing information
- **Error diagnosis:** Helps identify problematic files

### Debug Output Example
```bash
./codepack.sh --minify --debug

DEBUG: Processing file 1/55: ./src/app.js
DEBUG: Reading content from: app.js
DEBUG: Content length: 2847
DEBUG: Starting minification for: app.js
DEBUG: Minification complete for: app.js
DEBUG: Writing to output: app.js
```

### When to Use Debug Mode
- ✅ **Troubleshooting:** When extraction fails or behaves unexpectedly
- ✅ **Performance analysis:** Monitor processing of large codebases
- ✅ **Minification testing:** Verify minification is working correctly
- ✅ **File investigation:** Identify problematic or empty files
- ✅ **Process monitoring:** Track progress on large projects

**Note:** Debug mode significantly increases output verbosity - use only when needed.

## Compression Feature

The `--compress` option uses gzip compression:

- Creates a `.gz` compressed version alongside the original file
- Reports compression statistics and size reduction percentage
- Provides decompression instructions
- **Best practice:** Combine with `--minify` for maximum reduction

## Output

The script generates a timestamped file containing:
1. **Directory Structure:** Tree-like representation with excluded items marked
2. **File Contents:** All processed files with clear headers
3. **Statistics:** Processing summary and compression ratios

### Output Files
- **Standard:** `codepack_YYYYMMDD_HHMMSS.txt`
- **Compressed:** `codepack_YYYYMMDD_HHMMSS.txt.gz`

### Example Output

```
$ ./codepack.sh

🔧 codepack v4
Automatically excluding directories: '.git', 'node_modules', 'venv', '__pycache__', '.next', 'dist', 'build'
Automatically excluding files: '.env', '.DS_Store'
No filtering - processing all file types

🗂️  Generation in progress, please wait ...
Found 11 files to process

[==================================================] 100%

📝 Processed 8 files (skipped 3 empty files)
✅ Extraction complete
📄 Output: "./codepack_20250622_215837.txt"
📊 Stats: 1 920 lines, 85 KB
📁 All file types were processed.

🎯 Ready for AI analysis! Use --minify-info to check available tools.
```

### Smart Features
- **Empty files skipped:** No more useless sections with just headers
- **Processing statistics:** Shows files processed vs. skipped
- **Compression reporting:** Detailed size reduction metrics
- **Default current directory:** No need to specify path for current directory

## Requirements

### Essential
- Bash shell (required for running tests in `test/`)
- `find` command
- `sed`, `tr`, `wc` (standard Unix tools)

### Optional (for maximum compression)
- **Node.js + npm** (for JavaScript/CSS/HTML tools)
- **Python 3 + pip** (for Python minifiers)
- **jq** (for JSON minification)
- **Go** (for multi-format minify tool)
- **gzip** (for compression feature)

## Tool Installation Guide

### macOS
```bash
# Package managers
brew install node jq
npm install -g terser csso-cli html-minifier-terser
pip3 install pyminify python-minifier

# Test your installation with debug mode
./codepack.sh --minify-info
./codepack.sh --minify --debug
```

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install nodejs npm jq python3-pip
npm install -g terser csso-cli html-minifier-terser
pip3 install pyminify python-minifier

# Test your installation with debug mode
./codepack.sh --minify-info
./codepack.sh --minify --debug
```

### CentOS/RHEL
```bash
sudo yum install nodejs npm jq python3-pip
npm install -g terser csso-cli html-minifier-terser
pip3 install pyminify python-minifier

# Test your installation with debug mode
./codepack.sh --minify-info
./codepack.sh --minify --debug
```

## How was I inspired to create such a package?

This afternoon in January 2025, I'm using [claude](https://claude.ai/) and I have to continually open new chats because a message informs me that using the same chat window consumes more and more tokens.

In fact, it's true that coming back months later on a 3km long chat window is never very appreciable. And since you have to give Claude the context each time and the manual extraction is boring, that's it! I started coding a program in bash, Claude and o1 helped me fix the bugs and improve the program (even if Claude seems to be a level above), and the result is a project that I am proud of because it meets my expectations exactly and it only took me 3 hours to create all of this.

**UPDATE:** After several iterations and user feedback, I've enhanced the tool with ultra-aggressive minification, external tool integration, and smart file processing. The goal is to achieve **50-70% size reduction** for optimal AI processing while maintaining code functionality. The latest update includes **default current directory processing** - simply run `./codepack` without specifying a path! Enjoy and don't hesitate to contribute!

## FAQ

### Q: The script does not run, what should I do?
- Make sure you gave execution rights: `chmod +x codepack.sh`
- Run: `./codepack.sh --minify-info` to test your environment

### Q: I don't have some minification tools, is it blocking?
- No, the script works without them, but compression will be less efficient. Use `--install-minifiers` to install everything automatically.

### Q: How to decompress a `.gz` file?
- Use: `gzip -d codepack_YYYYMMDD_HHMMSS.txt.gz`

### Q: Can I run codepack without specifying a directory?
- **Yes!** Simply run `./codepack.sh` and it will process the current directory by default. You can also combine it with options like `./codepack.sh --minify`.

### Q: What's the difference between `./codepack.sh` and `./codepack.sh .`?
- They are equivalent! Both process the current directory. The new version makes the directory path optional for convenience.

### Q: How do I run the tests?
- Go to the `test/` folder and run the scripts: `./test_basic.sh`

## Contribution

1. Create a branch from `main`
2. Code the functionality
3. Submit a Pull Request

## Roadmap

- ✅ **Default current directory processing** ✨ NEW in v4
- ✅ **Debug mode** for advanced troubleshooting ✨ NEW in v3.2.1
- [ ] **Real-time minification** during file processing
- [ ] **Parallel processing** for large codebases
- [ ] **Custom minification rules** configuration
- [ ] **Binary file detection** and smart handling
- [ ] **Language detection** improvements
- [ ] **Plugin system** for custom minifiers

## Changelog

### v4.1 (2025-06-22)
- ✨ **NEW:** **Default current directory processing** - run `./codepack` without specifying a path
- 🔧 **IMPROVED:** Simplified usage - directory path is now optional
- 📚 **ENHANCED:** Updated documentation with current directory examples
- 🎯 **OPTIMIZED:** Better argument parsing for optional directory

## v4.0 (2025-06-10)
- 🚀 **NEW LOGO and package name**

## v3.2.1 (2025-05-29)

### 🚀 New Features
- ✨ **NEW:** `--debug` mode for detailed processing information
- 🐛 **FIX:** Debug messages no longer appear without explicit `--debug` flag
- **Debug Mode**: Added optional `--debug` flag for detailed processing information and troubleshooting
- **Enhanced Progress Tracking**: Improved progress bar with file count display (current/total)
- **Intelligent File Processing**: Smart detection and skipping of empty files to reduce output pollution
- **External Tool Timeout Protection**: Added 10-second timeout for external minifiers to prevent hanging
- **Large File Handling**: Automatic fallback for HTML files over 30KB to prevent html-minifier-terser crashes

### 🔧 Improvements
- 🔧 **IMPROVED:** Cleaner output in production mode
- **Robust Error Handling**: All sed operations now include fallback mechanisms and error protection
- **Memory Management**: Better cleanup of temporary files and resources
- **Processing Statistics**: Detailed reports on processed vs skipped files
- **Minification Reliability**: Enhanced minification functions with comprehensive error handling for edge cases
- **Tool Detection**: Improved external minifier detection and configuration

### 🛠️ Bug Fixes
- 📊 **ENHANCED:** Better troubleshooting capabilities
- **Fixed Progress Bar**: Progress now correctly displays 0-100% instead of stopping at intermediate percentages
- **Fixed Argument Parsing**: Resolved issues with corrupted command-line arguments
- **Fixed Empty Content Handling**: All minification functions now properly handle empty or whitespace-only content
- **Fixed External Tool Integration**: Improved stability when using terser, pyminify, csso, html-minifier-terser, and jq
- **Fixed Resource Cleanup**: Proper cleanup of temporary files and moviepy resources

## v3.2.0 (2025-05-10)
- 🚀 Ultra-aggressive minification with external tools
- 📦 Advanced compression capabilities
- 🛠️ Smart minification tool detection and installation
- 📊 Processing statistics and empty file detection

## Version 3.1.0

### 🚀 New Features
- **Ultra-Aggressive Minification**: Complete rewrite of minification engine with 50-70% size reduction
- **External Tool Integration**: Support for terser, pyminify, csso-cli, html-minifier-terser, and jq
- **Intelligent Fallback System**: Automatic fallback to bash minification when external tools unavailable
- **Multi-Language Support**: Enhanced support for 20+ file types including Python, JavaScript, CSS, HTML, JSON, YAML, XML, and more
- **Tool Management Commands**: Added `--install-minifiers` and `--minify-info` commands

### 🔧 Improvements
- **Advanced File Type Detection**: Intelligent detection of file types based on content and extensions
- **Modular Architecture**: Completely refactored codebase with separate functions for each file type
- **Enhanced Configuration**: Improved handling of special files like Dockerfile, .gitignore, Makefile
- **Better Resource Management**: Optimized memory usage and file handling

### 🛠️ Bug Fixes
- **Fixed Minification Stability**: Resolved crashes with complex file contents
- **Fixed Character Encoding**: Better handling of non-ASCII characters
- **Fixed Large File Processing**: Improved performance with files over 10MB

## Version 3.0.0

### 🚀 New Features
- **Compression Support**: Added `--compress` option for gzip compression of output files
- **File Filtering System**: Added `--include` and `--exclude` options for fine-grained file selection
- **Progress Indicators**: Added visual progress bars with percentage completion
- **Processing Statistics**: Comprehensive reporting of processed files, sizes, and compression ratios
- **Minification Framework**: Initial implementation of code minification capabilities

### 🔧 Improvements
- **Enhanced Directory Tree**: Improved tree visualization with better formatting and excluded item marking
- **File Size Reporting**: Added file size calculations and formatting (bytes, KB, MB, GB)
- **Error Handling**: Comprehensive error handling and validation
- **User Experience**: Better command-line interface with detailed help and examples

### 🛠️ Bug Fixes
- **Fixed Directory Exclusion**: Proper handling of nested excluded directories
- **Fixed File Permissions**: Better handling of read-only and protected files
- **Fixed Output Formatting**: Consistent formatting across different file types

## Version 2.5.0

### 🚀 New Features
- **Automatic Directory Exclusion**: Smart exclusion of common build/cache directories (`.git`, `node_modules`, `venv`, `__pycache__`, `.next`, `dist`, `build`)
- **Sensitive File Protection**: Automatic exclusion of sensitive files (`.env`, `.DS_Store`)
- **Enhanced Output Format**: Improved output structure with clear file headers and separators
- **Timestamped Output**: Output files include timestamp for version control

### 🔧 Improvements
- **Better File Detection**: Improved file type detection and handling
- **Enhanced Tree Generation**: More accurate directory tree representation
- **Cleaner Output**: Reduced noise in output files by filtering irrelevant content

### 🛠️ Bug Fixes
- **Fixed Tree Structure**: Corrected issues with nested directory visualization
- **Fixed File Reading**: Better handling of binary and special files
- **Fixed Path Resolution**: Improved path handling across different operating systems

## Version 2.0.0

### 🚀 New Features
- **Directory Structure Visualization**: Added comprehensive tree-like directory structure generation
- **Dual-Section Output**: Separated directory structure and file contents into distinct sections
- **File Content Extraction**: Complete file content extraction with proper formatting
- **Command-Line Interface**: Professional CLI with argument parsing and validation

### 🔧 Improvements
- **Modular Code Structure**: Refactored codebase into logical functions and sections
- **Better Documentation**: Comprehensive inline documentation and comments
- **Enhanced Error Messages**: More descriptive error messages and validation

### 🛠️ Bug Fixes
- **Fixed File Reading**: Resolved issues with special characters and encoding
- **Fixed Directory Traversal**: Improved handling of symlinks and special directories
- **Fixed Output Generation**: Consistent output formatting across all file types

## Version 1.8.0

### 🚀 New Features
- **Recursive Directory Processing**: Full recursive traversal of directory structures
- **Multiple File Support**: Ability to process multiple files in a single operation
- **Basic File Filtering**: Initial implementation of file type filtering

### 🔧 Improvements
- **Performance Optimization**: Faster file processing and reduced memory usage
- **Better File Handling**: Improved handling of large files and directories

### 🛠️ Bug Fixes
- **Fixed Memory Issues**: Resolved memory leaks with large directory structures
- **Fixed File Encoding**: Better handling of different character encodings

## Version 1.5.0

### 🚀 New Features
- **Initial Release**: Basic file extraction functionality
- **Single File Processing**: Extract content from individual files
- **Simple Output Format**: Basic text output with file names and content
- **Cross-Platform Support**: Compatible with Unix-like systems (Linux, macOS, BSD)

### 🔧 Core Features
- **File Content Reading**: Basic file reading capabilities
- **Text Output**: Simple text-based output format
- **Error Handling**: Basic error detection and reporting
- **Shell Script Foundation**: Robust bash script architecture

## Migration Notes

### From v3.1.x to v3.2.x
- ✅ No breaking changes
- ✅ New `--debug` flag is optional and does not affect existing workflows

### From v3.0.x to v3.1.x
- ✅ No breaking changes
- ✅ New minification features are optional and activated only with `--minify` flag
- ✅ External tools are optional; script works with built-in fallbacks

### From v2.x to v3.0.x
- ✅ Output format enhanced but remains backward compatible
- ✅ New filtering options are optional
- ✅ Existing scripts will continue to work without modifications

### From v1.x to v2.x
- ⚠️ Significant output format changes
- ⚠️ Directory structure section added
- ⚠️ May require updates to scripts that parse output

## License
This project is under [MIT](LICENSE) license.

## Author
Ɛɔıs3 Solutions

---

**⚡ Pro Tip:** For maximum efficiency with AI tools like Claude, use:
```bash
# Quick current directory analysis (most common)
./codepack --minify

# For debugging and optimization testing
./codepack --minify --debug --include js py css html

# Silent production mode for specific directory (clean output)
./codepack /your/project --minify --compress --include js py css html
```
This gives you ultra-compressed, AI-optimized code extracts with minimal effort!
