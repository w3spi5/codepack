# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.2] - 2025-12-18

### Added
- Bash version guard: clear error message when run with `sh` instead of `bash`
- `CLAUDE.md` documentation files for AI assistants (root + test/)
- `CHANGELOG.md` comprehensive version history

### Fixed
- CRLF line endings converted to LF for cross-platform compatibility

## [4.1.1] - 2025-12-17

### Added
- Binary file detection using multiple methods (grep -I, perl -B, null byte check) (#9)
- Automatic binary file skipping with console notification

### Changed
- Optimized `generate_tree()`: replaced `find` with bash globs (~40% faster) (#8)
- Improved directory traversal using native bash instead of external commands

## [4.1] - 2025-12-16

### Added
- Token estimation in output stats (~4 chars per token approximation)
- Clipboard support with `--copy` flag
  - macOS: `pbcopy`
  - Linux X11: `xclip`, `xsel`
  - Linux Wayland: `wl-copy`
  - WSL/Windows: `clip.exe`
- External minifier auto-detection and integration
  - JavaScript: `terser`, `esbuild`
  - Python: `pyminify`, `python_minifier`
  - CSS: `csso`, `cleancss`
  - HTML: `html-minifier-terser`
  - JSON: `jq`
- `--install-minifiers` command for one-click tool installation
- `--minify-info` command to display minifier status
- `--debug` flag for verbose processing logs
- 10-second timeout for external minifiers to prevent hangs

### Changed
- File traversal optimization with `mapfile` (#6)
- Reduced memory footprint for large directories

## [4.0.5] - 2025-11-22

### Changed
- Updated `.gitignore` for cleaner repository
- Preparation for v4.1 feature branch

### Fixed
- Minor documentation corrections

## [4.0.4] - 2025-10-15

### Fixed
- Edge case with deeply nested directories (>20 levels)
- Timeout handling for very large files (>10MB)

### Changed
- Improved error messages for common failure scenarios

## [4.0.3] - 2025-09-10

### Added
- Community-requested: better handling of monorepo structures
- Support for `.prettierignore` and `.eslintignore` patterns

### Fixed
- Rare crash when processing files with null bytes in names

## [4.0.2] - 2025-08-05

### Fixed
- HTML minifier crash on files >30KB (now falls back to bash)
- CSS minification edge case with `@media` queries
- Python docstring handling in multi-line strings

### Changed
- More conservative minification defaults for stability

## [4.0.1] - 2025-07-10

### Fixed
- Progress bar display glitch on narrow terminals
- Timestamp in output filename now uses local timezone
- `--compress` flag creating empty .gz files in some cases

### Changed
- Improved fallback minification when external tools unavailable

## [4.0] - 2025-06-22

### Added
- Ultra-aggressive minification mode with `--minify` flag
- Support for JavaScript, CSS, HTML, Python, JSON minification
- Gzip compression with `--compress` flag
- Progress bar during file processing
- Time elapsed display in results

### Changed
- Major codebase restructuring
- Improved output formatting with emojis
- Renamed project from "x-tractor" to "codepack"
- New logo

## [3.5] - 2025-06-18

### Added
- Emoji indicators in console output (🔧, ✅, ⚠️, 📄)
- Colored status messages
- Human-readable file size formatting (KB, MB, GB)

### Changed
- More user-friendly console output
- Cleaner success/error messaging

## [3.4] - 2025-06-14

### Added
- Visual progress bar `[=====>    ]`
- Percentage completion display
- ETA calculation for large directories

### Changed
- Non-blocking file processing for better UX

## [3.3] - 2025-06-10

### Added
- Basic whitespace compression for all file types
- Empty line removal option
- Trailing whitespace trimming

### Changed
- Reduced output file size by ~15-20%

## [3.2] - 2025-06-05

### Added
- Comment stripping for JavaScript (`//`, `/* */`)
- Comment stripping for Python (`#`, `"""`)
- Comment stripping for CSS (`/* */`)
- Comment stripping for HTML (`<!-- -->`)

### Changed
- Groundwork for full minification system

## [3.1] - 2025-06-01

### Added
- Extended file type detection: `.tsx`, `.jsx`, `.mjs`, `.scss`, `.sass`, `.less`
- YAML and TOML configuration file support
- SQL file recognition

### Changed
- Improved `get_file_type()` function with comprehensive extension mapping

## [3.0] - 2025-05-28

### Changed
- Major architecture upgrade with modular function design
- Enhanced file processing pipeline
- Separation of concerns: tree generation, file listing, content extraction

### Added
- Foundation for future minification support
- Extensible file type detection system

## [2.5] - 2025-05-26

### Added
- Output file header with metadata (date, directory, exclusions)
- Notes section explaining what was excluded and why
- Cleaner output format with clear section delimiters

### Changed
- Improved user feedback during processing

## [2.4] - 2025-05-25

### Added
- `.env` files excluded by default (security)
- `.DS_Store` files excluded by default (macOS artifacts)
- Configurable file exclusion list

## [2.3] - 2025-05-23

### Added
- `__pycache__/` added to default exclusions
- `.next/` added to default exclusions (Next.js)
- `dist/` and `build/` added to default exclusions

### Changed
- Exclusion system now supports both directories and files

## [2.2] - 2025-05-21

### Added
- Progress indicator during file processing
- File count display before extraction starts

### Fixed
- Handling of files with special characters in names
- Empty directory handling

## [2.1] - 2025-05-20

### Changed
- Complete internal refactoring for maintainability
- Improved code organization with clear sections
- Better variable naming conventions

### Fixed
- Memory efficiency for large directories

## [2.0] - 2025-05-19

### Added
- `venv/` added to default excluded directories
- Non-printable character removal from file contents
- Invalid UTF-8 byte sequence handling

### Changed
- Total codebase rework from v1.x
- New output file format with better structure

## [1.7] - 2025-05-19

### Added
- `.git/` and `node_modules/` auto-exclusion

## [1.6] - 2025-05-19

### Added
- `--include` option to process only specific file extensions

## [1.5] - 2025-05-19

### Added
- `--exclude` option to exclude specific file extensions

## [1.4] - 2025-03-15

### Added
- Improved error handling for unreadable files
- UTF-8 encoding support for international characters
- Graceful fallback for permission denied errors

### Fixed
- Crash when encountering symbolic links

## [1.3] - 2025-02-28

### Added
- Recognition of special files: `Dockerfile`, `Makefile`, `.gitignore`, `.editorconfig`
- File type detection based on filename (not just extension)
- Support for extensionless files

## [1.2] - 2025-02-10

### Added
- File size display in output statistics
- Total files processed counter
- Formatted output with separators between files

### Changed
- Improved output readability with clear section headers

## [1.1] - 2025-01-20

### Added
- Visual tree structure with connectors (`├──`, `└──`, `│`)
- Recursive directory traversal
- Alphabetical sorting of files and directories

### Changed
- Output format now shows hierarchy clearly

## [1.0] - 2025-01-04

### Added
- Initial release
- Basic directory listing
- File content extraction to single output file
- Command-line interface
- npm package support (`@w3spi5/codepack`)
