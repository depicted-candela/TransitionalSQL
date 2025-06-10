#!/bin/bash

# run_all_extractions.sh
# This script automatically executes all generated .sh extraction scripts
# within the 'additional' directory's subfolders.

# --- Configuration ---
# Set the base directory where your 'additional' folder is located.
# Ensure this matches the 'base_dir' used in your Python script for book_dirs.
BOOKS_BASE_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional"

# --- Script Logic ---

echo "Starting automatic PDF feature extraction..."
echo "Looking for extraction scripts in: $BOOKS_BASE_DIR"
echo "--------------------------------------------------"

# Check if the base directory exists
if [ ! -d "$BOOKS_BASE_DIR" ]; then
    echo "Error: Directory '$BOOKS_BASE_DIR' not found."
    echo "Please ensure the path is correct and the directory exists."
    exit 1
fi

# Loop through each book directory within the BOOKS_BASE_DIR
for BOOK_DIR in "$BOOKS_BASE_DIR"/*/; do
    # Ensure it's a directory
    if [ -d "$BOOK_DIR" ]; then
        BOOK_NAME=$(basename "$BOOK_DIR")
        EXTRACT_SCRIPT_PATH="${BOOK_DIR}extract_${BOOK_NAME}.sh"

        echo "Processing book: ${BOOK_NAME}"
        echo "  Looking for script: $EXTRACT_SCRIPT_PATH"

        # Check if the extraction script exists and is executable
        if [ -f "$EXTRACT_SCRIPT_PATH" ] && [ -x "$EXTRACT_SCRIPT_PATH" ]; then
            echo "  Executing: $EXTRACT_SCRIPT_PATH"
            # Execute the script from its own directory to ensure relative paths work
            (cd "$BOOK_DIR" && "./extract_${BOOK_NAME}.sh")
            if [ $? -eq 0 ]; then
                echo "  Successfully extracted features for ${BOOK_NAME}."
            else
                echo "  Error: Extraction failed for ${BOOK_NAME}."
            fi
        else
            echo "  Warning: Extraction script '$EXTRACT_SCRIPT_PATH' not found or not executable. Skipping."
            echo "  Please ensure the Python script was run successfully to generate it."
        fi
        echo "--------------------------------------------------"
    fi
done

echo "Automatic PDF feature extraction completed."
echo "Check each book's 'extracted_features' subdirectory for the results."
