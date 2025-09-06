# Leaf - Command & Text Snippet Manager

A macOS tool for storing and quickly accessing text snippets and shell commands. Save those long commands you can't remember, complex scripts you use rarely, or any text you find yourself retyping.

## What it does

- Store text snippets and shell commands with optional aliases
- Access them through a simple GUI or command line
- Execute commands directly from the CLI with real-time output
- Import/export your data as JSON

## Installation

### Download from GitHub Releases (Recommended)

 DMG packages are provided in the GitHub Releases section, containing all available versions. This is the easiest way to install Leaf, as it bundles both the CLI tool and the GUI application.

### Build from source

You'll need Xcode and Swift installed.

1. Clone this repo
2. Build the CLI:
   ```bash
   cd LeafCLI
   swift build -c release
   ```
3. Install the CLI binary:
   ```bash
   # Copy to /usr/local/bin (requires sudo)
   sudo cp .build/release/LeafCLI /usr/local/bin/leaf
   
   # Or add to your PATH
   export PATH="$PATH:$(pwd)/.build/release"
   ```
4. Build the GUI in Xcode:
   - Open `LeafUi/LeafUi.xcodeproj`
   - Build and run

### Create installer (optional)

```bash
chmod +x create-simple-dmg.sh
./create-simple-dmg.sh
```

## Usage

### GUI
Launch the app, add items with the + button, copy with the clipboard icon.

### CLI

```bash
# List all items
leaf list

# Show a specific item
leaf show my-alias

# Execute a command
leaf run my-alias

# Get help
leaf help
```

### Examples

Store a git command:
```bash
# Add item with data: "git log --oneline --graph --decorate --all"
# and alias: "git-graph"
```

Then run it:
```bash
leaf run git-graph
```

Store a deployment script:
```bash
# Data: "docker build -t myapp . && docker push myapp && kubectl rollout restart deployment/myapp"
# Alias: "deploy"
```
Then run it:
```bash
leaf run deploy
```

## Data format

```json
{
  "version": "1.0.0",
  "items": [
    {
      "id": "uuid-here",
      "data": "your command or text",
      "alias": "optional-alias"
    }
  ]
}
```

## Import/Export

Use the GUI to export your data as JSON, then import it elsewhere. The CLI doesn't have import/export functionality.

## Known issues

1. **No CLI import/export**: Only the GUI can import/export data
2. **Basic error handling**: Commands that fail will show exit codes but limited debugging info

## Development

The project has two main parts:
- `LeafCLI/`: Swift Package Manager CLI tool
- `LeafUi/`: SwiftUI macOS app

### Branch Structure

- **main**: This is the release branch containing stable, production-ready code
- **develop**: Development branch for ongoing work before pushing to main for release

## License

MIT License - see LICENSE file.
