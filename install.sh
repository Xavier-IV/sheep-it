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

# Temporary directory for zip extraction (set only by this script)
TEMP_DIR=""

# Secure cleanup function with multiple safety checks
# This is critical - we MUST NOT accidentally delete user data
safe_cleanup() {
    # Guard 1: Must be non-empty
    if [ -z "$TEMP_DIR" ]; then
        return 0
    fi

    # Guard 2: Must exist and be a directory
    if [ ! -d "$TEMP_DIR" ]; then
        return 0
    fi

    # Guard 3: Must NOT be a symlink (prevent symlink attacks)
    if [ -L "$TEMP_DIR" ]; then
        echo "Warning: Temp directory is a symlink, skipping cleanup for safety" >&2
        return 0
    fi

    # Guard 4: Blocklist - NEVER delete these patterns regardless of other checks
    case "$TEMP_DIR" in
        /|/home|/home/*|/Users|/Users/*|/root|/root/*|\
        /etc|/etc/*|/usr|/usr/*|/var|/var/*|/bin|/bin/*|\
        /sbin|/sbin/*|/lib|/lib/*|/opt|/opt/*|/System|/System/*|\
        /Applications|/Applications/*|/Library|/Library/*|\
        "$HOME"|"$HOME"/*|"${HOME}"|"${HOME}"/*)
            # Exception: allow /var/tmp and /var/folders (macOS temp)
            case "$TEMP_DIR" in
                /var/tmp/*|/var/folders/*)
                    # Allowed, continue to next checks
                    ;;
                *)
                    echo "Warning: Refusing to delete path in protected location: $TEMP_DIR" >&2
                    return 0
                    ;;
            esac
            ;;
    esac

    # Guard 5: Allowlist - path MUST start with a known temp directory
    local allowed=false
    local resolved_tmpdir="${TMPDIR:-/tmp}"
    # Remove trailing slash for consistent comparison
    resolved_tmpdir="${resolved_tmpdir%/}"

    case "$TEMP_DIR" in
        /tmp/*|/var/tmp/*|/var/folders/*/*/*/*)
            allowed=true
            ;;
        "${resolved_tmpdir}"/*)
            allowed=true
            ;;
    esac

    if [ "$allowed" = false ]; then
        echo "Warning: Temp directory not in expected location, skipping cleanup: $TEMP_DIR" >&2
        return 0
    fi

    # Guard 6: Directory basename MUST match our exact pattern
    local dirname
    dirname=$(basename "$TEMP_DIR")
    case "$dirname" in
        sheep-it-install.??????)
            # Matches exactly: sheep-it-install. followed by 6 characters
            ;;
        *)
            echo "Warning: Temp directory name doesn't match expected pattern, skipping cleanup: $dirname" >&2
            return 0
            ;;
    esac

    # Guard 7: Verify our marker file exists (proves we created this directory)
    if [ ! -f "$TEMP_DIR/.sheep-it-install-marker" ]; then
        echo "Warning: Marker file not found, skipping cleanup for safety" >&2
        return 0
    fi

    # All guards passed - safe to delete
    rm -rf "$TEMP_DIR"
}

# Set trap to ensure cleanup runs on exit (success or failure)
trap safe_cleanup EXIT

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

    # Create temporary directory with explicit naming
    TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/sheep-it-install.XXXXXX")

    # Create marker file to prove we created this directory (security measure)
    touch "$TEMP_DIR/.sheep-it-install-marker"

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
