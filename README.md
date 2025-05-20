# X-TRACTOR

<p align="center">
  <img src="logo.webp" alt="x-tractor Logo" width="500"/>
</p>

CLI tool to extract folder structure and file contents with customizable extension filtering.

It's an essential utility for developers, system administrators, and power users who need an efficient solution for file management and data extraction.

## Features

- 📂 Generate a complete directory structure overview
- 📄 Extract the content of all files in a directory tree
- 🚫 Automatically exclude specific directories from scanning (`.git`, `node_modules`, `venv`)
- Filter files by extension with `--exclude` option
- Include only specific file types with `--include` option
- 🛠️ Lightweight and efficient, even for large datasets
- 🎨 Produces aesthetically pleasing tree-like output
- 🔄 Supports versioning of extracted data

## Functionality Checklist

- [x] **Directory Structure Generation**
  - [x] Tree-like visualization of folders and files
  - [x] Proper indentation and branch lines
  - [x] Marking of excluded directories and files
  - [x] Non-recursive exploration of excluded directories

- [x] **Content Extraction**
  - [x] Multi-file content extraction in a single operation
  - [x] Proper file content formatting with headers
  - [x] Automatic character encoding fixes
  - [x] Filtering of non-printable characters

- [x] **Filtering Options**
  - [x] Automatic exclusion of system directories (.git, node_modules, venv)
  - [x] Automatic exclusion of sensitive files (.env)
  - [x] Extension-based inclusion with `--include` option
  - [x] Extension-based exclusion with `--exclude` option

- [x] **User Experience**
  - [x] Progress bar with percentage display
  - [x] File counter with thousands separator
  - [x] Formatted file size display (bytes, KB, MB)
  - [x] Clear completion messages
  - [x] Timestamped output files

## Use Cases

- Project documentation
- Codebase analysis
- System audits
- Backup preparation
- Development project snapshots

## Installation

```bash
git clone https://github.com/w3spi5/x-tractor.git
cd x-tractor
chmod +x x-tractor.sh
```

## Usage

```bash
./x-tractor.sh <path/to/directory> [options]
```

### Options
- `--exclude <ext1> [<ext2> ...]` - Exclude files with specified extensions (optional)
- `--include <ext1> [<ext2> ...]` - Include ONLY files with specified extensions (optional)

Note: You cannot use both `--include` and `--exclude` at the same time

### Examples
```bash
# Process all files in a directory
./x-tractor.sh /home/user/project

# Exclude PDF and JPG files
./x-tractor.sh /home/user/project --exclude pdf jpg

# Include only JavaScript, HTML and CSS files
./x-tractor.sh /home/user/project --include js html css
```

## Output
The script generates a single text timestamped file containing:
1. A tree-like representation of the directory structure
2. The content of all files (respecting the extension filters)

Output file is saved in the target directory as `xtracted_YYYYMMDD_HHMMSS.txt`

## Requirements
- Bash shell
- find command

## How was I inspired to create such a package?

This afternoon in January 2025, I'm using [claude](https://claude.ai/) and I have to continually open new chats because a message informs me that using the same chat window consumes more and more tokens.<br>CLI
In fact, it's true that coming back months later on a 3km long chat window is never very appreciable.<br>
And since you have to give Claude the context each time and the manual extraction is boring, that's it! I started coding a program in bash, Claude and o1 helped me fix the bugs and improve the program (even if Claude seems to be a level above), and the result is a project that I am proud of because that it meets my expectations exactly and it only took me 3 hours to create all of this. Enjoy and don't hesitate to contribute!<br>
(and 7 to create release and package...)

## Contribution

1. Create a branch from `develop`
2. Code the functionality
3. Submit a Pull Request

## License
This project is under [MIT](LICENSE) license.

## Author
Ɛɔıs3 Solutions