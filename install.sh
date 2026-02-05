#!/bin/bash

# 🐑 Sheep It - Installation Script
# Cross-platform installer for macOS, Linux, and Windows (Git Bash/WSL)
#
# Usage: curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/install.sh | bash

set -e

SHEEP_DIR="$HOME/.claude/commands/sheep"
REPO_ZIP_URL="https://github.com/Xavier-IV/sheep-it/archive/refs/heads/master.zip"
REPO_RAW_URL="https://raw.githubusercontent.com/Xavier-IV/sheep-it/master"
ZIP_EXTRACT_DIR="sheep-it-master"

# Command files to install (used for fallback and verification)
COMMAND_FILES=(
    "board.md"
    "config.md"
    "help.md"
    "init.md"
    "it.md"
    "milestone.md"
    "milestones.md"
    "progress.md"
    "release.md"
    "research.md"
    "resume.md"
    "review.md"
    "start.md"
    "status.md"
    "sync.md"
    "task.md"
    "tasks.md"
    "verify.md"
)

# Temporary directory for zip extraction
TEMP_DIR=""

# Cleanup function - removes temp directory on exit
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Set trap to ensure cleanup runs on exit (success or failure)
trap cleanup EXIT

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "windows-wsl"
            else
                echo "linux"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows-gitbash"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

echo ""
echo "🐑 Installing Sheep It..."
echo ""

# Detect and display OS
OS=$(detect_os)
case "$OS" in
    macos)
        echo "✓ Detected: macOS"
        ;;
    linux)
        echo "✓ Detected: Linux"
        ;;
    windows-wsl)
        echo "✓ Detected: Windows (WSL)"
        ;;
    windows-gitbash)
        echo "✓ Detected: Windows (Git Bash)"
        ;;
    *)
        echo "⚠️  Unknown OS, attempting installation anyway..."
        ;;
esac
echo ""

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "✗ curl is required but not installed."
    echo ""
    echo "Install curl first, then run this script again."
    exit 1
fi
echo "✓ curl available"

# Check if unzip is available (for fast installation)
USE_ZIP=false
if command -v unzip &> /dev/null; then
    USE_ZIP=true
    echo "✓ unzip available (fast mode)"
else
    echo "⚠️  unzip not found - using slower individual downloads"
    echo "   Install unzip for faster installation next time"
fi

# Check if gh CLI is installed (warning only, not required for install)
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI (gh) not found - you'll need it to use Sheep It"
    echo ""
    echo "Install it:"
    echo "  macOS:  brew install gh"
    echo "  Linux:  https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  Windows: winget install GitHub.cli"
    echo ""
else
    echo "✓ GitHub CLI available"
fi

# Create commands directory
mkdir -p "$SHEEP_DIR"
echo "✓ Created $SHEEP_DIR"

# Download command files
echo ""

success_count=0
fail_count=0

if [ "$USE_ZIP" = true ]; then
    # Fast mode: Download zip archive and extract
    echo "Downloading commands (zip archive)..."

    # Create temporary directory
    TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'sheep-it')

    ZIP_FILE="${TEMP_DIR}/sheep-it.zip"

    # Download the zip archive
    if curl -fsSL "$REPO_ZIP_URL" -o "$ZIP_FILE" 2>/dev/null; then
        echo "  ✓ Downloaded archive"

        # Extract only the commands directory
        if unzip -q "$ZIP_FILE" "${ZIP_EXTRACT_DIR}/commands/*.md" -d "$TEMP_DIR" 2>/dev/null; then
            echo "  ✓ Extracted commands"

            # Copy command files to installation directory
            for file in "${TEMP_DIR}/${ZIP_EXTRACT_DIR}/commands/"*.md; do
                if [ -f "$file" ]; then
                    filename=$(basename "$file")
                    cp "$file" "${SHEEP_DIR}/${filename}"
                    success_count=$((success_count + 1))
                fi
            done

            echo "  ✓ Installed $success_count command files"
        else
            echo "  ✗ Failed to extract archive, falling back to individual downloads..."
            USE_ZIP=false
        fi
    else
        echo "  ✗ Failed to download archive, falling back to individual downloads..."
        USE_ZIP=false
    fi
fi

# Fallback: Download files individually (if zip failed or unzip unavailable)
if [ "$USE_ZIP" = false ]; then
    echo "Downloading command files individually..."

    for file in "${COMMAND_FILES[@]}"; do
        if curl -fsSL "${REPO_RAW_URL}/commands/${file}" -o "${SHEEP_DIR}/${file}" 2>/dev/null; then
            echo "  ✓ $file"
            success_count=$((success_count + 1))
        else
            echo "  ✗ $file (failed)"
            fail_count=$((fail_count + 1))
        fi
    done
fi

echo ""

if [ $fail_count -eq 0 ]; then
    echo "✓ Installed $success_count command files"
else
    echo "⚠️  Installed $success_count files, $fail_count failed"
fi

echo ""
echo "🎉 Sheep It installed successfully!"
echo ""
echo "Next steps:"
echo ""
echo "  1. Authenticate GitHub CLI (if not already):"
echo "     gh auth login && gh auth refresh -h github.com -s project,read:project"
echo ""
echo "  2. In your project directory, run:"
echo "     /sheep:init"
echo ""
echo "Available commands:"
echo "  /sheep:task   Create issue     /sheep:start   Start issue"
echo "  /sheep:it     Ship it! (PR)    /sheep:help    Show all"
echo ""
echo "🐑 Don't be sheepish, ship it!"
echo ""
