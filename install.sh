#!/bin/bash

# 🐑 Sheep It - Installation Script
# GitHub-native project flow for Claude Code

set -e

SHEEP_DIR="$HOME/.claude/commands/sheep"
REPO_URL="https://github.com/Xavier-IV/sheep-it"

echo "🐑 Installing Sheep It..."
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI (gh) is required but not installed."
    echo ""
    echo "Install it first:"
    echo "  macOS:  brew install gh"
    echo "  Linux:  https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo ""
    echo "Then run: gh auth login"
    exit 1
fi

# Check if gh is authenticated
if ! gh auth status &> /dev/null; then
    echo "⚠️  GitHub CLI is not authenticated."
    echo ""
    echo "Run: gh auth login"
    exit 1
fi

echo "✓ GitHub CLI authenticated"

# Create commands directory if it doesn't exist
mkdir -p "$HOME/.claude/commands"

# Remove old installation if exists
if [ -d "$SHEEP_DIR" ]; then
    echo "✓ Removing old installation..."
    rm -rf "$SHEEP_DIR"
fi

# Clone and install
echo "✓ Downloading Sheep It..."
TEMP_DIR=$(mktemp -d)
git clone --quiet "$REPO_URL" "$TEMP_DIR/sheep-it"

# Copy commands to Claude Code
mkdir -p "$SHEEP_DIR"
cp "$TEMP_DIR/sheep-it/commands/"*.md "$SHEEP_DIR/"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✓ Installed to $SHEEP_DIR"
echo ""
echo "🎉 Sheep It installed successfully!"
echo ""
echo "Available commands:"
echo "  /sheep:init        Create/setup project"
echo "  /sheep:task        Create issue"
echo "  /sheep:tasks       List issues"
echo "  /sheep:milestone   Create milestone"
echo "  /sheep:milestones  List milestones"
echo "  /sheep:progress    Show progress"
echo "  /sheep:board       View project board"
echo "  /sheep:start       Start working on issue"
echo "  /sheep:it          🐑 Ship it! (create PR)"
echo "  /sheep:release     Create release"
echo "  /sheep:help        Show help"
echo ""
echo "Get started:"
echo "  cd your-project"
echo "  /sheep:init"
echo ""
echo "🐑 Don't be sheepish, ship it!"
