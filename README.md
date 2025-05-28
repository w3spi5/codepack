# X-TRACTOR v3.2.1

<p align="center">
  <img src="logo.webp" alt="x-tractor Logo" width="500"/>
</p>

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

## Installation

```bash
git clone https://github.com/w3spi5/x-tractor.git
cd x-tractor
chmod +x x-tractor.sh
```

### Install External Minification Tools (Recommended)

For maximum compression (50-70% size reduction), install external tools:

```bash
# Automatic installation
./x-tractor.sh --install-minifiers

# Manual installation
npm install -g terser csso-cli html-minifier-terser  # JavaScript, CSS, HTML
pip3 install pyminify python-minifier                # Python
brew install jq                                       # JSON (macOS)
# sudo apt install jq                                 # JSON (Ubuntu)
go install github.com/tdewolff/minify/v2/cmd/minify@latest  # Multi-format (optional)
```

## Usage

```bash
./x-tractor.sh <path/to/directory> [options]
```

### Options
- `--exclude <ext1> [<ext2> ...]` - Exclude files with specified extensions
- `--include <ext1> [<ext2> ...]` - Include ONLY files with specified extensions
- `--minify` - **Ultra-aggressive minification** (50-70% size reduction with external tools)
- `--compress` - Compress output file with gzip
- `--debug` - **Enable debug mode** for detailed processing information
- `--install-minifiers` - Install recommended external minification tools
- `--minify-info` - Show status of available minification tools

**Note:** You cannot use both `--include` and `--exclude` at the same time

### Examples
```bash
# Process all files in a directory
./x-tractor.sh /home/user/project

# Check available minification tools
./x-tractor.sh --minify-info

# Install minification tools automatically
./x-tractor.sh --install-minifiers

# Ultra-aggressive minification (recommended for AI)
./x-tractor.sh /home/user/project --minify

# Maximum compression: minify + gzip
./x-tractor.sh /home/user/project --minify --compress

# Process only code files with ultra-minification
./x-tractor.sh /home/user/project --include js css html py --minify

# Exclude binary files and minify
./x-tractor.sh /home/user/project --exclude pdf jpg png --minify

# Debug mode for troubleshooting
./x-tractor.sh /home/user/project --debug

# Debug with minification to see processing details
./x-tractor.sh /home/user/project --minify --debug

# Debug with specific file types
./x-tractor.sh /home/user/project --include js py --minify --debug
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
./x-tractor.sh /project --minify --debug

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
- **Standard:** `xtracted_YYYYMMDD_HHMMSS.txt`
- **Compressed:** `xtracted_YYYYMMDD_HHMMSS.txt.gz`

### Smart Features
- **Empty files skipped:** No more useless sections with just headers
- **Processing statistics:** Shows files processed vs. skipped
- **Compression reporting:** Detailed size reduction metrics

## Requirements

### Essential
- Bash shell
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
./x-tractor.sh --minify-info
./x-tractor.sh /small/test/project --minify --debug
```

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install nodejs npm jq python3-pip
npm install -g terser csso-cli html-minifier-terser
pip3 install pyminify python-minifier

# Test your installation with debug mode
./x-tractor.sh --minify-info
./x-tractor.sh /small/test/project --minify --debug
```

### CentOS/RHEL
```bash
sudo yum install nodejs npm jq python3-pip
npm install -g terser csso-cli html-minifier-terser
pip3 install pyminify python-minifier

# Test your installation with debug mode
./x-tractor.sh --minify-info
./x-tractor.sh /small/test/project --minify --debug
```

## How was I inspired to create such a package?

This afternoon in January 2025, I'm using [claude](https://claude.ai/) and I have to continually open new chats because a message informs me that using the same chat window consumes more and more tokens.

In fact, it's true that coming back months later on a 3km long chat window is never very appreciable. And since you have to give Claude the context each time and the manual extraction is boring, that's it! I started coding a program in bash, Claude and o1 helped me fix the bugs and improve the program (even if Claude seems to be a level above), and the result is a project that I am proud of because it meets my expectations exactly and it only took me 3 hours to create all of this.

**UPDATE:** After several iterations and user feedback, I've enhanced the tool with ultra-aggressive minification, external tool integration, and smart file processing. The goal is to achieve **50-70% size reduction** for optimal AI processing while maintaining code functionality. Enjoy and don't hesitate to contribute!

## Contribution

1. Create a branch from `main`
2. Code the functionality
3. Submit a Pull Request

## Roadmap

- ✅ **Debug mode** for advanced troubleshooting ✨ NEW in v3.2.1
- [ ] **Real-time minification** during file processing
- [ ] **Parallel processing** for large codebases
- [ ] **Custom minification rules** configuration
- [ ] **Binary file detection** and smart handling
- [ ] **Language detection** improvements
- [ ] **Plugin system** for custom minifiers

## Changelog

### v3.2.1 (2025-01-28)
- ✨ **NEW:** `--debug` mode for detailed processing information
- 🐛 **FIX:** Debug messages no longer appear without explicit `--debug` flag
- 🔧 **IMPROVED:** Cleaner output in production mode
- 📊 **ENHANCED:** Better troubleshooting capabilities

### v3.2.0 (320)
- 🚀 Ultra-aggressive minification with external tools
- 📦 Advanced compression capabilities
- 🛠️ Smart minification tool detection and installation
- 📊 Processing statistics and empty file detection

## License
This project is under [MIT](LICENSE) license.

## Author
Ɛɔıs3 Solutions

---

**⚡ Pro Tip:** For maximum efficiency with AI tools like Claude, use:
```bash
# For debugging and optimization testing
./x-tractor.sh /your/project --minify --debug --include js py css html

# Silent production mode (clean output)
./x-tractor.sh /your/project --minify --compress --include js py css html
```
This gives you ultra-compressed, AI-optimized code extracts!