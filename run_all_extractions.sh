#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting batch extraction of PDF features from all books..."
echo "This script will navigate into each book's directory, run its extraction script,"
echo "and create an 'extracted_features' subdirectory containing the PDF features."
echo "----------------------------------------------------------------------------"

# Define the base path to the 'additional' directory
# Ensure this matches your directory structure relative to where this script is run
BOOKS_ADDITIONAL_DIR="./books/additional"

# Check if the directory exists
if [ ! -d "$BOOKS_ADDITIONAL_DIR" ]; then
    echo "Error: The directory '$BOOKS_ADDITIONAL_DIR' does not exist."
    echo "Please ensure this script is run from the parent directory of 'books/additional'."
    exit 1
fi

# Iterate over each subdirectory within the BOOKS_ADDITIONAL_DIR
for book_dir in "$BOOKS_ADDITIONAL_DIR"/*/; do
    # Check if it's actually a directory
    if [ -d "$book_dir" ]; then
        book_name=$(basename "$book_dir")
        extraction_script="${book_dir}extract_${book_name}.sh"

        echo "Processing book: ${book_name}"
        echo "Looking for extraction script: ${extraction_script}"

        # Check if the extraction script exists and is executable
        if [ -x "$extraction_script" ]; then
            (
                # Change to the book's directory to run its script
                cd "$book_dir" || { echo "Failed to change directory to $book_dir"; exit 1; }
                echo "Executing: ./${book_dir##*/}extract_${book_name}.sh from $(pwd)"
                "./extract_${book_name}.sh"
            )
            echo "Finished processing ${book_name}"
        else
            echo "Warning: Extraction script not found or not executable for ${book_name}."
            echo "Please ensure 'generate_extraction_scripts.py' was run successfully first."
        fi
        echo "----------------------------------------------------------------------------"
    fi
done

echo "Batch extraction complete for all books."
echo "Check each book's directory for a new 'extracted_features' folder."
