#!/bin/bash

# Leaf Simple DMG Builder
# Creates a DMG with UI app and installation script

set -e

echo "🌿 Leaf Simple DMG Builder"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -d "LeafUi" ] || [ ! -d "LeafCLI" ]; then
    print_error "This script must be run from the leaf project root directory"
    exit 1
fi

# Create build directory
BUILD_DIR="build"
DMG_DIR="$BUILD_DIR/Leaf-Installer"
DMG_NAME="Leaf-Installer.dmg"

print_status "Creating build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build CLI
print_status "Building CLI tool..."
cd LeafCLI
swift build -c release
cd ..

# Create DMG structure
print_status "Creating DMG structure..."
mkdir -p "$DMG_DIR"

# Copy UI App
print_status "Checking for UI app..."

# Check multiple possible locations
UI_APP_FOUND=false

# Check archived app location first (highest priority)
if [ -d "$HOME/Library/Developer/Xcode/Archives" ]; then
    ARCHIVED_APP=$(find "$HOME/Library/Developer/Xcode/Archives" -name "Leaf.app" -type d -path "*/Products/Applications/*" 2>/dev/null | head -1)
    if [ -n "$ARCHIVED_APP" ]; then
        print_status "Copying UI app from archive..."
        cp -R "$ARCHIVED_APP" "$DMG_DIR/"
        UI_APP_FOUND=true
    fi
# Check local build directories
elif [ -d "LeafUi/build/Release/Leaf.app" ]; then
    print_status "Copying UI app from local build..."
    cp -R "LeafUi/build/Release/Leaf.app" "$DMG_DIR/"
    UI_APP_FOUND=true
elif [ -d "LeafUi/DerivedData/LeafUi/Build/Products/Release/Leaf.app" ]; then
    print_status "Copying UI app from local DerivedData..."
    cp -R "LeafUi/DerivedData/LeafUi/Build/Products/Release/Leaf.app" "$DMG_DIR/"
    UI_APP_FOUND=true
# Check system DerivedData location
elif [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
    DERIVED_DATA_APP=$(find "$HOME/Library/Developer/Xcode/DerivedData" -name "Leaf.app" -type d -path "*/Build/Products/Release/*" 2>/dev/null | head -1)
    if [ -n "$DERIVED_DATA_APP" ]; then
        print_status "Copying UI app from system DerivedData..."
        cp -R "$DERIVED_DATA_APP" "$DMG_DIR/"
        UI_APP_FOUND=true
    else
        # Try Debug build if Release not found
        DERIVED_DATA_APP=$(find "$HOME/Library/Developer/Xcode/DerivedData" -name "Leaf.app" -type d -path "*/Build/Products/Debug/*" 2>/dev/null | head -1)
        if [ -n "$DERIVED_DATA_APP" ]; then
            print_status "Copying UI app from system DerivedData (Debug build)..."
            cp -R "$DERIVED_DATA_APP" "$DMG_DIR/"
            UI_APP_FOUND=true
        fi
    fi
fi

if [ "$UI_APP_FOUND" = false ]; then
    print_warning "UI app not found in build directories"
    print_status "Please build the UI app in Xcode first (Product > Build or Product > Archive)"
    print_status "Then run this script again"
    exit 1
fi

# Copy CLI executable
print_status "Copying CLI executable..."
cp "LeafCLI/.build/release/LeafCLI" "$DMG_DIR/leaf"

# Create installation script
print_status "Creating installation script..."
cat > "$DMG_DIR/Install Leaf.command" << 'EOF'
#!/bin/bash

# Leaf Installation Script
# Double-click this file to install Leaf

echo "🌿 Leaf Installer"
echo "=================="

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Install UI App
print_status "Installing Leaf UI app..."
if [ -d "/Applications/Leaf.app" ]; then
    print_warning "Leaf.app already exists. Removing old version..."
    rm -rf "/Applications/Leaf.app"
fi
cp -R "$SCRIPT_DIR/Leaf.app" "/Applications/"
print_status "✅ Leaf UI app installed successfully"

# Install CLI Tool
print_status "Installing Leaf CLI tool..."
if [ -f "$SCRIPT_DIR/leaf" ]; then
    # Create /usr/local/bin if it doesn't exist
    sudo mkdir -p /usr/local/bin
    
    # Copy CLI tool
    sudo cp "$SCRIPT_DIR/leaf" "/usr/local/bin/leaf"
    sudo chmod +x "/usr/local/bin/leaf"
    
    print_status "✅ Leaf CLI tool installed successfully"
else
    print_error "CLI executable not found"
    exit 1
fi

# Create leaf.json if it doesn't exist
if [ ! -f "$HOME/Documents/leaf.json" ]; then
    echo '{"version":"1.0.0","items":[]}' > "$HOME/Documents/leaf.json"
    chmod 644 "$HOME/Documents/leaf.json"
    print_status "✅ Created initial leaf.json file"
fi

print_status "🎉 Leaf installed successfully!"
print_status "You can now:"
print_status "  • Launch Leaf from Applications folder"
print_status "  • Use 'leaf' command in Terminal"
print_status ""
print_status "For CLI help, run: leaf help"

echo ""
echo "Press any key to close this window..."
read -n 1
EOF

chmod +x "$DMG_DIR/Install Leaf.command"

# Create README
print_status "Creating README..."
cat > "$DMG_DIR/README.txt" << 'EOF'
🌿 Leaf - Command Manager

INSTALLATION:
1. Double-click "Install Leaf.command" to install both components
2. Enter your password when prompted

WHAT GETS INSTALLED:
• LeafUi.app → /Applications/
• leaf CLI → /usr/local/bin/

USAGE:
• Launch Leaf from Applications folder
• Use 'leaf' command in Terminal:
  - leaf help    - Show help
  - leaf list    - List all aliases
  - leaf run <alias> - Execute command

For more information, visit: https://github.com/your-repo/leaf
EOF

# Create Applications symlink for drag-and-drop
print_status "Creating Applications symlink..."
ln -s /Applications "$DMG_DIR/Applications"

# Create .dmg
print_status "Creating DMG..."
if command -v create-dmg &> /dev/null; then
    create-dmg \
        --volname "Leaf Installer" \
        --window-pos 200 120 \
        --window-size 600 400 \
        --icon-size 100 \
        --icon "Leaf.app" 175 120 \
        --icon "Install Leaf.command" 175 220 \
        --icon "README.txt" 175 320 \
        --icon "Applications" 425 120 \
        --hide-extension "Applications" \
        --app-drop-link 425 120 \
        "$DMG_NAME" \
        "$DMG_DIR"
else
    hdiutil create -volname "Leaf Installer" -srcfolder "$DMG_DIR" -ov -format UDZO "$DMG_NAME"
fi

# Cleanup
print_status "Cleaning up..."
rm -rf "$BUILD_DIR"

print_status "✅ DMG created successfully: $DMG_NAME"
print_status "Users can now double-click the DMG and run 'Install Leaf.command'" 