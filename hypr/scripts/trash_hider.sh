#!/bin/bash

# Script to copy specific desktop files and add Hidden=true entry

# Source directory
SOURCE_DIR="/usr/share/applications"
# Destination directory
DEST_DIR="$HOME/.local/share/applications"

# Array of desktop files to process (add your files here)
DESKTOP_FILES=(
    "avahi-discover.desktop"
    "bssh.desktop"
    "btop.desktop"
    "bvnc.desktop"
    "electron37.desktop"
    "foot-server.desktop"
    "foot.desktop"
    "footclient.desktop"
    "qv4l2.desktop"
    "qvidcap.desktop"
    "uuctl.desktop"
    "vim.desktop"
    "xgps.desktop"
    "xgpsspeed.desktop"
    "linguist.desktop"
    "designer.desktop"
    "assistant.desktop"
    "qdbusviewer.desktop"
    "cmake-gui.desktop"
    "lstopo.desktop"
)

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# Counter for statistics
processed=0
skipped=0
errors=0

echo "Processing specific desktop files from $SOURCE_DIR to $DEST_DIR"
echo "=============================================================="

# Process each desktop file in the array
for desktop_file in "${DESKTOP_FILES[@]}"; do
    source_file="$SOURCE_DIR/$desktop_file"
    dest_file="$DEST_DIR/$desktop_file"
    
    echo "Processing: $desktop_file"
    
    # Check if source file exists
    if [ ! -f "$source_file" ]; then
        echo "  ❌ Error: $desktop_file not found in source directory"
        ((errors++))
        continue
    fi
    
    # Check if file already exists in destination
    if [ -f "$dest_file" ]; then
        echo "  ⚠️  Skipped: $desktop_file already exists in destination"
        ((skipped++))
        continue
    fi
    
    # Copy the file
    if cp "$source_file" "$dest_file"; then
        # Check if [Desktop Entry] section exists
        if grep -q "\[Desktop Entry\]" "$dest_file"; then
            # Add Hidden=true after [Desktop Entry] section
            if sed -i '/\[Desktop Entry\]/a Hidden=true' "$dest_file"; then
                echo "  ✅ Success: Copied and added Hidden=true to $desktop_file"
                ((processed++))
            else
                echo "  ❌ Error: Failed to modify $desktop_file"
                ((errors++))
                # Clean up the copied file if modification failed
                rm -f "$dest_file"
            fi
        else
            echo "  ⚠️  Warning: [Desktop Entry] section not found. File copied but not modified."
            ((processed++))
        fi
    else
        echo "  ❌ Error: Failed to copy $desktop_file"
        ((errors++))
    fi
done

echo ""
echo "=============================================================="
echo "Operation completed:"
echo "  ✅ Successfully processed: $processed files"
echo "  ⚠️  Skipped (already exist): $skipped files"
echo "  ❌ Errors: $errors files"
