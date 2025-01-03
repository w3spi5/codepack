# > x-tractor<br>CLI Tool for Folder Structure and File Content Extraction

x-tractor is a powerful CLI tool designed to extract folder structures and file contents while offering the flexibility to exclude specific directories. It's an essential utility for developers, system administrators, and power users who need an efficient solution for file management and data extraction.

## Features

- 📂 Generates comprehensive folder structures
- 📄 Extracts file contents
- 🚫 Easily excludes specified directories
- 🛠️ Lightweight and efficient, even for large datasets
- 🎨 Produces aesthetically pleasing tree-like output
- 🔄 Supports versioning of extracted data

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
./x-tractor.sh <path/to/directory>
```

## Demo

Running x-tractor on its own directory:

```bash
./x-tractor.sh .
```

Terminal output:
```
📁 x-tractor/
├── 📄 LICENSE
├── 📄 README.md
├── 📄 x-tractor.sh
└── 📁 .git/
    ├── 📄 HEAD
    ├── 📁 branches/
    ├── 📁 hooks/
    ├── 📁 refs/
    └── 📄 config

Generated: x-tractor_20250103_145623.txt
File contents have been extracted to: x-tractor_20250103_145623.txt
```

Generated file content (x-tractor_20250103_145623.txt):
```
=== DIRECTORY STRUCTURE ===
📁 x-tractor/
├── 📄 LICENSE
├── 📄 README.md
├── 📄 x-tractor.sh
└── 📁 .git/
    ├── 📄 HEAD
    ├── 📁 branches/
    ├── 📁 hooks/
    ├── 📁 refs/
    └── 📄 config

=== FILE CONTENTS ===
[LICENSE]
MIT License
...

[README.md]
# > x-tractor
CLI Tool for Folder Structure and File Content Extraction
...

[x-tractor.sh]
#!/bin/bash
# x-tractor - Tool for Folder Structure and File Content Extraction
...
```

## Configuration

x-tractor generates a timestamped file containing:

1. A tree-like structure of the analyzed directory
2. Contents of all non-excluded files

## How was I inspired to create such a package?

This afternoon in January 2025, I'm using [claude](https://claude.ai/) and I have to continually open new chats because a message informs me that using the same chat window consumes more and more tokens, then in fact, between For us, it's true that coming back months later on a 3 km long chat is never very appreciable. And since you have to give Claude the context each time and the manual extraction is boring, that's it! I started coding a program in bash, Claude and o1 helped me fix the bugs and improve the program (even if Claude seems to be a level above), and the result is a project that I am proud of because that it meets my expectations exactly and it only took me 3 hours to create all of this. Enjoy and don't hesitate to contribute!

## Contribution

1. Create a branch from `develop`
2. Code the functionality
3. Submit a Pull Request

## License

This project is under [MIT](LICENSE) license.