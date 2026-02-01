#!/bin/bash

# 🐑 Sheep It - Uninstall Script
# Cross-platform uninstaller for macOS, Linux, and Windows (Git Bash/WSL)
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/uninstall.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/uninstall.sh | bash -s -- --yes
#
# Options:
#   -y, --yes    Skip confirmation prompt (for non-interactive use)

set -e

SHEEP_DIR="$HOME/.claude/commands/sheep"
SKIP_CONFIRM=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        -y|--yes)
            SKIP_CONFIRM=true
            shift
            ;;
    esac
done

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
echo "🐑 Sheep It Uninstaller"
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
        echo "⚠️  Unknown OS, attempting uninstall anyway..."
        ;;
esac
echo ""

# Check if Sheep It is installed
if [ ! -d "$SHEEP_DIR" ]; then
    echo "ℹ️  Sheep It is not installed."
    echo ""
    echo "   Directory not found: $SHEEP_DIR"
    echo ""
    echo "Nothing to uninstall. Goodbye! 👋"
    echo ""
    exit 0
fi

# Show what will be removed
echo "The following will be removed:"
echo ""
echo "  📁 $SHEEP_DIR"

# List files in the directory
if [ -d "$SHEEP_DIR" ]; then
    file_count=$(find "$SHEEP_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo ""
    echo "  Contains $file_count file(s):"
    for file in "$SHEEP_DIR"/*; do
        if [ -f "$file" ]; then
            echo "    • $(basename "$file")"
        fi
    done
fi

echo ""

# Confirm before deletion (unless --yes flag is passed)
if [ "$SKIP_CONFIRM" = false ]; then
    # Check if we can read from terminal
    if [ -t 0 ]; then
        # Running directly (stdin is terminal)
        read -p "Are you sure you want to uninstall Sheep It? [y/N] " -n 1 -r
        echo ""
    elif (exec < /dev/tty) 2>/dev/null; then
        # Running via curl | bash (stdin is piped, but tty is available)
        read -p "Are you sure you want to uninstall Sheep It? [y/N] " -n 1 -r < /dev/tty
        echo ""
    else
        # Non-interactive environment (no tty available)
        echo "⚠️  Cannot prompt for confirmation (no terminal available)."
        echo ""
        echo "To uninstall non-interactively, run:"
        echo "  curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/uninstall.sh | bash -s -- --yes"
        echo ""
        exit 1
    fi

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Uninstall cancelled. Sheep It remains installed."
        echo ""
        echo "🐑 Baaa-ck to work!"
        echo ""
        exit 0
    fi
fi

echo ""
echo "Removing Sheep It..."

# Remove the directory
rm -rf "$SHEEP_DIR"

echo ""
echo "✓ Removed $SHEEP_DIR"
echo ""
echo "🎉 Sheep It has been uninstalled successfully!"
echo ""
echo "Thanks for using Sheep It! 🐑"
echo ""
echo "If you change your mind, reinstall with:"
echo "  curl -fsSL https://raw.githubusercontent.com/Xavier-IV/sheep-it/master/install.sh | bash"
echo ""
echo "👋 Goodbye and happy coding!"
echo ""
