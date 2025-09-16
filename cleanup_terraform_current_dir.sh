#!/bin/bash

# Script to delete .terragrunt directories and .terraform.lock.hcl files recursively
# Usage: ./cleanup_terraform.sh [directory]

set -e

# Use provided directory or current directory
TARGET_DIR="${1:-.}"

# Convert to absolute path to avoid issues
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

echo "Starting cleanup in directory: $TARGET_DIR"
echo "This will delete (recursively):"
echo "  - All .terragrunt directories in $TARGET_DIR and subdirectories"
echo "  - All .terraform.lock.hcl files in $TARGET_DIR and subdirectories"
echo ""

# Function to delete terragrunt directories
delete_terragrunt_dirs() {
    echo "Searching for .terragrunt directories..."
    local count=0
    
    # Find and delete .terragrunt directories
    while IFS= read -r -d '' dir; do
        if [ -d "$dir" ]; then
            echo "  Deleting directory: $dir"
            if rm -rf "$dir"; then
                ((count++))
                echo "  Successfully deleted: $dir"
            else
                echo "  Failed to delete: $dir"
            fi
        else
            echo "  Directory not found: $dir"
        fi
    done < <(find "$TARGET_DIR" -type d -name ".terragrunt*" -print0 2>/dev/null)
    
    echo "Deleted $count .terragrunt directories"
}

# Function to delete lock files
delete_lock_files() {
    echo "Searching for .terraform.lock.hcl files..."
    local count=0
    
    # Find and delete .terraform.lock.hcl files
    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            echo "  Deleting file: $file"
            rm -f "$file" && ((count++)) || echo "  Failed to delete: $file"
        fi
    done < <(find "$TARGET_DIR" -type f -name ".terraform.lock.hcl" -print0 2>/dev/null)
    
    echo "Deleted $count .terraform.lock.hcl files"
    return $count
}

# Count items to be deleted first (for reporting)
echo "Scanning for files and directories..."
terragrunt_dirs=$(find "$TARGET_DIR" -type d -name ".terragrunt*" 2>/dev/null | wc -l)
lock_files=$(find "$TARGET_DIR" -type f -name ".terraform.lock.hcl" 2>/dev/null | wc -l)

echo "Found (including subdirectories):"
echo "  - $terragrunt_dirs .terragrunt directories"
echo "  - $lock_files .terraform.lock.hcl files"
echo ""

# Exit if nothing found
if [ "$terragrunt_dirs" -eq 0 ] && [ "$lock_files" -eq 0 ]; then
    echo "No files or directories to delete. Exiting."
    exit 0
fi

# Show what will be deleted (preview)
if [ "$terragrunt_dirs" -gt 0 ]; then
    echo "Terragrunt directories found:"
    find "$TARGET_DIR" -type d -name ".terragrunt*" 2>/dev/null | head -10
    if [ "$terragrunt_dirs" -gt 10 ]; then
        echo "  ... and $((terragrunt_dirs - 10)) more"
    fi
    echo ""
fi

if [ "$lock_files" -gt 0 ]; then
    echo "Lock files found:"
    find "$TARGET_DIR" -type f -name ".terraform.lock.hcl" 2>/dev/null | head -10
    if [ "$lock_files" -gt 10 ]; then
        echo "  ... and $((lock_files - 10)) more"
    fi
    echo ""
fi

# Proceed with deletion automatically
echo "Starting deletion..."

# Delete .terragrunt directories
if [ "$terragrunt_dirs" -gt 0 ]; then
    delete_terragrunt_dirs
fi

# Delete .terraform.lock.hcl files  
if [ "$lock_files" -gt 0 ]; then
    delete_lock_files
fi

echo ""
echo "Cleanup completed!"

# Final verification
echo "Verifying cleanup..."
remaining_dirs=$(find "$TARGET_DIR" -type d -name ".terragrunt*" 2>/dev/null | wc -l)
remaining_files=$(find "$TARGET_DIR" -type f -name ".terraform.lock.hcl" 2>/dev/null | wc -l)

if [ "$remaining_dirs" -eq 0 ] && [ "$remaining_files" -eq 0 ]; then
    echo "✓ Verification: All target files and directories have been removed successfully."
    exit 0
else
    echo "⚠ Warning: Some files/directories may still remain:"
    echo "  - $remaining_dirs .terragrunt directories"
    echo "  - $remaining_files .terraform.lock.hcl files"
    
    if [ "$remaining_dirs" -gt 0 ]; then
        echo "Remaining .terragrunt directories:"
        find "$TARGET_DIR" -type d -name ".terragrunt*" 2>/dev/null
    fi
    
    if [ "$remaining_files" -gt 0 ]; then
        echo "Remaining .terraform.lock.hcl files:"
        find "$TARGET_DIR" -type f -name ".terraform.lock.hcl" 2>/dev/null
    fi
    exit 1
fi