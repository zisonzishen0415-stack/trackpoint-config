#!/bin/bash

INSTALL_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
PROFILES_DIR="$CONFIG_DIR/trackpoint-profiles"
LOG_DIR="$CONFIG_DIR/trackpoint"

echo "========================================="
echo "  TrackPoint Configuration Tool Installer"
echo "========================================="
echo ""

if [ ! -f "trackpoint" ]; then
    echo "Error: 'trackpoint' script not found in current directory"
    echo "Please run this installer from the project directory"
    exit 1
fi

echo "Installing to $INSTALL_DIR/trackpoint..."
cp trackpoint "$INSTALL_DIR/trackpoint"
chmod +x "$INSTALL_DIR/trackpoint"

echo "Creating directories..."
mkdir -p "$PROFILES_DIR"
mkdir -p "$LOG_DIR"

echo ""
echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
echo "Run the tool with:"
echo "  ~/trackpoint"
echo ""
echo "For more information, see README.md"