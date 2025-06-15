#!/bin/bash

# ==============================================================================
# extract_chapters.sh (Corrected Version)
#
# Description:
#   Extracts chapters from a PDF file based on a JSON list of chapter titles.
#   It uses pdftk to dump PDF metadata to find the start and end pages for
#   each chapter and then extracts them into separate PDF files.
#
# Dependencies:
#   - pdftk-java: The PDF Toolkit (https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
#   - jq: Command-line JSON processor (https://stedolan.github.io/jq/)
#
# Usage:
#   ./extract_chapters.sh <source_pdf_file> <chapters_json_file> <output_directory>
#
# ==============================================================================

# --- 1. PRE-FLIGHT CHECKS ---

command -v pdftk >/dev/null 2>&1 || { echo >&2 "Error: 'pdftk' is not installed. Please install it to continue. Aborting."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "Error: 'jq' is not installed. Please install it to continue. Aborting."; exit 1; }

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source.pdf> <chapters.json> <output_directory>"
    exit 1
fi

SOURCE_PDF="$1"
CHAPTERS_JSON="$2"
OUTPUT_DIR="$3"

if [ ! -f "$SOURCE_PDF" ]; then
    echo "Error: Source PDF file not found at '$SOURCE_PDF'"
    exit 1
fi
if [ ! -f "$CHAPTERS_JSON" ]; then
    echo "Error: Chapters JSON file not found at '$CHAPTERS_JSON'"
    exit 1
fi

# --- 2. SETUP ---

mkdir -p "$OUTPUT_DIR"
METADATA_FILE=$(mktemp)
trap 'rm -f "$METADATA_FILE"' EXIT

echo "Dumping metadata from '$SOURCE_PDF'..."
if ! pdftk "$SOURCE_PDF" dump_data_utf8 > "$METADATA_FILE"; then
    echo "Error: Failed to dump metadata from '$SOURCE_PDF'. Check if the file is valid."
    exit 1
fi

TOTAL_PAGES=$(grep "NumberOfPages" "$METADATA_FILE" | awk '{print $2}')
if [ -z "$TOTAL_PAGES" ]; then
    echo "Error: Could not determine the total number of pages from metadata."
    exit 1
fi
echo "PDF has $TOTAL_PAGES pages."

mapfile -t chapters < <(jq -r '.[]' "$CHAPTERS_JSON")
num_chapters=${#chapters[@]}
echo "Found $num_chapters chapters to extract from '$CHAPTERS_JSON'."
echo "---"

# --- 3. EXTRACTION LOOP ---

for i in $(seq 0 $((num_chapters - 1))); do
    current_title="${chapters[$i]}"
    chapter_num=$((i + 1))
    
    echo "Processing Chapter $chapter_num of $num_chapters: \"$current_title\""

    # --- CORRECTED LOGIC USING AWK ---
    # This awk script is more robust. It finds the line that exactly matches the
    # target title, sets a flag, and then grabs the page number from the
    # *next* "BookmarkPageNumber" line it finds. This is reliable even with special characters.
    start_page=$(awk -v title="BookmarkTitle: $current_title" '
        $0 == title {found=1; next}
        found && /BookmarkPageNumber:/ {print $2; exit}
    ' "$METADATA_FILE")
    
    if [ -z "$start_page" ]; then
        echo "  -> WARNING: Could not find metadata for chapter title. Skipping."
        echo "---"
        continue
    fi
    
    # Determine the end page
    if [ $i -lt $((num_chapters - 1)) ]; then
        next_title="${chapters[$i+1]}"
        next_start_page=$(awk -v title="BookmarkTitle: $next_title" '
            $0 == title {found=1; next}
            found && /BookmarkPageNumber:/ {print $2; exit}
        ' "$METADATA_FILE")
        
        if [ -z "$next_start_page" ]; then
            echo "  -> WARNING: Could not find start of next chapter. Using total pages as end."
            end_page=$TOTAL_PAGES
        else
            end_page=$((next_start_page - 1))
        fi
    else
        # This is the last chapter, so extract until the end of the document.
        end_page=$TOTAL_PAGES
    fi

    # Add a sanity check to prevent invalid page ranges (e.g., page 94-93)
    if [ "$end_page" -lt "$start_page" ]; then
        echo "  -> INFO: Calculated end page ($end_page) is before start page ($start_page). Setting end page to start page for single-page extraction."
        end_page=$start_page
    fi

    # Sanitize the chapter title to create a valid filename
    sanitized_title=$(echo "$current_title" | sed -e 's/ /_/g' -e 's/[^a-zA-Z0-9._-]/_/g')
    padded_num=$(printf "%02d" $chapter_num)
    output_filename="${OUTPUT_DIR}/${padded_num}_${sanitized_title}.pdf"

    echo "  -> Extracting pages $start_page-$end_page into '$output_filename'"
    
    if pdftk "$SOURCE_PDF" cat "$start_page-$end_page" output "$output_filename"; then
        echo "  -> Done."
    else
        echo "  -> ERROR: pdftk failed to extract chapter. Check for invalid page range or file permissions."
    fi
    echo "---"
done

echo "Extraction complete. All files saved in '$OUTPUT_DIR'."
