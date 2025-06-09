#!/bin/bash

# --- Configuration ---
# Directory to start searching from ('.' is current directory)
START_DIR="."
# Pattern for metadata files
METADATA_PATTERN="metadata.txt"
# Output subdirectory name within each PDF's directory
OUTPUT_SUBDIR="parts"
# Optional: Dry run? Set to "yes" to only print commands without executing them.
DRY_RUN="no"
# Name for the introduction section (pages before first bookmark)
INTRO_SECTION_NAME="Introduction"
# -------------------

# Function to sanitize strings for use in filenames
sanitize_filename() {
  local filename="$1"
  # Replace characters not alphanumeric, space, underscore, hyphen, or dot with underscore
  # Replace spaces with hyphens
  # Convert to lowercase (optional, but good for consistency)
  echo "$filename" | sed 's/[^a-zA-Z0-9 _.-]/_/g' | tr ' ' '-' | tr '[:upper:]' '[:lower:]'
}

# Check if pdftk is installed (unless doing a dry run)
if [[ "$DRY_RUN" != "yes" ]]; then
    if ! command -v pdftk &> /dev/null; then
        echo "Error: pdftk is not installed. Please install it first."
        exit 1
    fi
fi

echo "Starting recursive PDF splitting based on metadata in '$START_DIR'..."

# Find all metadata files recursively, handling filenames with spaces or special characters
find "$START_DIR" -type f -name "$METADATA_PATTERN" -print0 | while IFS= read -r -d '' metadata_file; do

  # Determine the original PDF file path
  pdf_dir=$(dirname "$metadata_file")
  # Find the first .pdf file in the same directory. Assumes there's one main PDF.
  pdf_file=$(find "$pdf_dir" -maxdepth 1 -type f -name "*.pdf" -print -quit)

  if [[ -z "$pdf_file" ]]; then
      echo "Warning: No corresponding PDF file found in directory \"$pdf_dir\" for metadata \"$metadata_file\". Skipping."
      continue # Go to the next metadata file
  fi

  echo "Processing metadata: \"$metadata_file\" for PDF: \"$pdf_file\""

  # Create the output subdirectory
  output_dir="${pdf_dir}/${OUTPUT_SUBDIR}"
  if [[ "$DRY_RUN" != "yes" ]]; then
      mkdir -p "$output_dir"
  fi

  # Extract all bookmarks (page|level|title) and sort by page number
  # Correct awk to correctly capture fields across lines and only print complete blocks
  mapfile -t all_bookmarks < <(
    awk '
    # Variables to store data for the *current* bookmark block
    BEGIN { current_page = ""; current_level = ""; current_title = ""; }

    # When a BookmarkBegin is encountered
    /BookmarkBegin/ {
        # This signifies the END of the PREVIOUS bookmark block.
        # If we collected a complete bookmark entry from the previous block, print it.
        # Check if page, level, and title were all captured in the previous block.
        if (current_page != "" && current_level != "" && current_title != "") {
            printf "%05d|%s|%s\n", current_page, current_level, current_title;
        }
        # Reset variables for the NEW bookmark block that starts here.
        current_page = "";
        current_level = "";
        current_title = "";
    }

    # Capture BookmarkPageNumber (should be field 2)
    /BookmarkPageNumber:/ { current_page = $2; }

    # Capture BookmarkLevel (should be field 2)
    /BookmarkLevel:/ { current_level = $2; }

    # Capture BookmarkTitle (rest of the line after "BookmarkTitle: ")
    /BookmarkTitle:/ {
        title_line = $0;
        sub(/^BookmarkTitle: +/, "", title_line); # Remove the prefix and spaces
        current_title = title_line; # Store the rest as the title
    }

    # At the very end of the file, print the data from the last collected bookmark block
    END {
        if (current_page != "" && current_level != "" && current_title != "") {
            printf "%05d|%s|%s\n", current_page, current_level, current_title;
        }
    }
    ' "$metadata_file" | sort -n # Sort numerically by page number (first field)
  )

  # Get total pages
  total_pages=$(grep 'NumberOfPages:' "$metadata_file" | head -1 | sed 's/NumberOfPages: //g; s/^[[:space:]]*//; s/[[:space:]]*$//')

  if [[ -z "$total_pages" || "$total_pages" -le 0 ]]; then
      echo "Error: Could not determine total pages from metadata \"$metadata_file\". Skipping."
      continue
  fi

  echo "Successfully parsed ${#all_bookmarks[@]} bookmark entries and found $total_pages total pages."

  # Array to store the sections to be extracted: (prefix|sanitized_title|start_page|end_page)
  sections_to_extract=()

  # Counters for sequential prefixes
  front_matter_counter=0 # For 00a, 00b, ...
  part_counter=0 # For part01, part02, ...
  chapter_counter=0 # For ch01, ch02, ...

  # --- Identify Sections based on Level 1 Bookmarks ---

  # Process potential pages before the first bookmark
  if [[ ${#all_bookmarks[@]} -gt 0 ]]; then
      IFS='|' read -r first_bookmark_page first_bookmark_level first_bookmark_title <<< "${all_bookmarks[0]}"
      # Check if the first bookmark page is valid and not page 1
      if [[ -n "$first_bookmark_page" && "$first_bookmark_page" -gt 1 ]]; then
          front_matter_counter=$((front_matter_counter + 1))
          # Use letter suffix for ordering within front matter
          # printf "\\$(printf '%03o' $((96 + front_matter_counter)))" converts 1->a, 2->b etc.
          prefix=$(printf "%02d%s_" 0 "$(printf "\\$(printf '%03o' $((96 + front_matter_counter)))")")
          section_name="$INTRO_SECTION_NAME"
          start_page=1
          end_page=$((first_bookmark_page - 1))
           # Ensure end_page is valid
          if [[ "$end_page" -ge "$start_page" ]]; then
              sections_to_extract+=("${prefix}|$(sanitize_filename "$section_name")|${start_page}|${end_page}")
              echo "  Identified section: \"$section_name\" (pages $start_page-$end_page)"
          else
              echo "  Warning: Calculated invalid page range ($start_page-$end_page) for Introduction. Skipping."
          fi
      fi
  fi

  # Iterate through all bookmarks to define sections starting at Level 1 bookmarks
  for i in "${!all_bookmarks[@]}"; do
    current_line="${all_bookmarks[i]}"
    IFS='|' read -r current_page current_level current_title <<< "$current_line"

    # Only Level 1 bookmarks define the start of a major section for splitting
    if [[ "$current_level" -ne 1 ]]; then
        continue # Skip non-Level 1 bookmarks when defining section starts
    fi

    # This is a Level 1 bookmark - it starts a new section
    start_page="$current_page"

    # Determine the end page for the current Level 1 section
    # Find the start page of the *next* Level 1 bookmark in the sorted list
    next_level1_page=$((total_pages + 1)) # Initialize to a value beyond total pages
    for (( j = i + 1; j < ${#all_bookmarks[@]}; j++ )); do
        next_line="${all_bookmarks[j]}"
        IFS='|' read -r next_page next_level next_title <<< "$next_line"
        if [[ "$next_level" -eq 1 ]]; then
            next_level1_page="$next_page"
            break # Found the next Level 1 start page
        fi
    done

    # The current section ends one page before the start of the next Level 1 bookmark
    # Or at the total pages if this is the last Level 1 bookmark
    end_page=$((next_level1_page - 1))

     # Ensure end_page is not less than start_page
    if [[ "$end_page" -lt "$start_page" ]]; then
        # If end page is less than start page, it means the next level 1 starts on the same page
        # as this one, or the calculated end page somehow went backwards.
        # Treat this case cautiously - it might be a single-page title or an anomaly.
        # For now, we'll set end_page to start_page. pdftk handles single pages fine.
         end_page="$start_page"
         # echo "  Note: Adjusted end page for \"$current_title\" to match start page $start_page." # Uncomment for verbose debugging
    fi

    # Cap end_page at total pages
    if [[ "$end_page" -gt "$total_pages" ]]; then
        end_page="$total_pages"
    fi

    # Ensure start_page is valid before proceeding
    if [[ -z "$start_page" || "$start_page" -le 0 || "$start_page" -gt "$total_pages" ]]; then
        echo "  Warning: Invalid start page $start_page for bookmark \"$current_title\" (Level $current_level). Skipping this section."
        continue
    fi


    # --- Determine filename prefix and name based on the section type ---
    section_name="$current_title"
    sanitized_section_name_base=$(sanitize_filename "$section_name") # Sanitize the title for pattern matching
    prefix="" # Reset prefix for each section

    # Logic for assigning prefixes based on common Oracle doc patterns
    # Order matters: Be more specific first (like "List of...") then general (like "Part", "Chapter")

    # Front matter sections (Contents, Lists, Preface, Changes) - use sequential 00a, 00b etc.
    if [[ "$sanitized_section_name_base" == "contents" ]]; then
         front_matter_counter=$((front_matter_counter + 1))
         prefix=$(printf "%02d%s_" 0 "$(printf "\\$(printf '%03o' $((96 + front_matter_counter)))")")
         section_name="table-of-contents" # Consistent internal name
    elif [[ "$sanitized_section_name_base" == "list-of-examples" ]]; then
         front_matter_counter=$((front_matter_counter + 1))
         prefix=$(printf "%02d%s_" 0 "$(printf "\\$(printf '%03o' $((96 + front_matter_counter)))")")
         section_name="list-of-examples"
    elif [[ "$sanitized_section_name_base" == "list-of-figures" ]]; then
         front_matter_counter=$((front_matter_counter + 1))
         prefix=$(printf "%02d%s_" 0 "$(printf "\\$(printf '%03o' $((96 + front_matter_counter)))")")
         section_name="list-of-figures"
     elif [[ "$sanitized_section_name_base" == "list-of-tables" ]]; then
         front_matter_counter=$((front_matter_counter + 1))
         prefix=$(printf "%02d%s_" 0 "$(printf "\\$(printf '%03o' $((96 + front_matter_counter)))")")
         section_name="list-of-tables"
    elif [[ "$sanitized_section_name_base" == "preface" ]]; then
        front_matter_counter=$((front_matter_counter + 1))
        prefix=$(printf "%02d%s_" 0 "$(printf "\\$(printf '%03o' $((96 + front_matter_counter)))")")

    # Handle "Changes in This Release..." type sections - assign next front matter prefix
    # Check if the raw title contains "Changes in This Release" *anywhere*
    elif [[ "$current_title" =~ Changes\ in\ This\ Release ]]; then
         front_matter_counter=$((front_matter_counter + 1))
         prefix=$(printf "%02d%s_" 0 "$(printf "\\$(printf '%03o' $((96 + front_matter_counter)))")")
         # Use a more specific name based on the book title or just a generic "changes"
         book_name=$(basename "$pdf_dir")
         section_name=$(sanitize_filename "${book_name}_changes")


    # Main content sections (Parts, Chapters) - use partXX and chXX prefixes
    # Need to match the exact structure including number/roman numeral at the start
    elif [[ "$current_title" =~ ^Part\ +([IVXLCDM]+)\ +(.+)$ ]]; then # Match Roman numerals for Parts
         part_roman="${BASH_REMATCH[1]}"
         part_counter=$((part_counter + 1)) # Simple sequential counter for parts
         prefix=$(printf "part%02d_" "$part_counter")
         # The section name will be the sanitized full title (e.g., part-i-initialization-parameters)
         section_name="$sanitized_section_name_base"
         # If this section is only one page long, assume it's a title page and append _title
         if [[ "$start_page" -eq "$end_page" ]]; then
              section_name="${section_name}_title"
         fi

    elif [[ "$current_title" =~ ^([0-9]+)\ +(.+)$ ]]; then # Match number for Chapters
         chapter_num="${BASH_REMATCH[1]}"
         chapter_title_part="${BASH_REMATCH[2]}"
         # Pad chapter number to two digits
         padded_chapter_num=$(printf "%02d" "$chapter_num")
         prefix="ch${padded_chapter_num}_"
         # Use the rest of the title (after the number) for the name
         section_name=$(sanitize_filename "$chapter_title_part")

    # Back matter sections (Appendices, Glossary, Index) - use appendixX, glossary, index prefixes
    elif [[ "$current_title" =~ ^Appendix\ +([A-Z])\ +(.+)$ ]]; then # Match "Appendix X " pattern
        appendix_letter="${BASH_REMATCH[1]}"
        appendix_title_part="${BASH_REMATCH[2]}"
        prefix="appendix${appendix_letter}_" # Use letter directly as it's unique A, B, C...
        # Use the rest of the title (after "Appendix X ") for the name
        section_name=$(sanitize_filename "$appendix_title_part")

    elif [[ "$sanitized_section_name_base" == "glossary" ]]; then
         prefix="glossary_"
         section_name="glossary" # Consistent name for the glossary file

    elif [[ "$sanitized_section_name_base" == "index" ]]; then
         prefix="index_"
         section_name="index" # Consistent name for the index file

    # Fallback for any other Level 1 bookmarks not explicitly handled
    else
        # Assign a generic prefix and use the sanitized title as the name
        # Re-using the front_matter_counter here for lack of a better category
        front_matter_counter=$((front_matter_counter + 1))
        prefix=$(printf "misc%02d_" "$front_matter_counter")
        echo "  Warning: Unhandled Level 1 bookmark pattern: \"$current_title\" on page $start_page. Using generic prefix: ${prefix}"
        section_name="$sanitized_section_name_base" # Use the original sanitized name as is
    fi

    # Add the identified section and its range to the list of sections to extract
    sections_to_extract+=("${prefix}|${section_name}|${start_page}|${end_page}")
    echo "  Identified section: \"$current_title\" (Level $current_level), Pages: $start_page-$end_page, Filename Prefix: ${prefix}, Generated Name: ${section_name}"


  done # End loop through all_bookmarks to define sections

  # --- Execute pdftk for each identified section ---
  echo "Extracting ${#sections_to_extract[@]} sections from \"$pdf_file\" into \"$output_dir\"..."
  for section_info in "${sections_to_extract[@]}"; do
    IFS='|' read -r prefix sanitized_title start_page end_page <<< "$section_info"

    output_filename="${output_dir}/${prefix}${sanitized_title}.pdf" # Final filename structure
    page_range="${start_page}-${end_page}"

    # Double-check page range validity before calling pdftk
    if [[ "$start_page" -le 0 || "$end_page" -le 0 || "$start_page" -gt "$total_pages" || "$end_page" -gt "$total_pages" || "$start_page" -gt "$end_page" ]]; then
        echo "    Error: Invalid page range ($page_range) for section \"${prefix}${sanitized_title}\". Skipping pdftk call."
        continue # Skip extraction for this section
    fi

    echo "    Extracting: \"${prefix}${sanitized_title}.pdf\" (pages ${page_range}) to \"$output_filename\""

    if [[ "$DRY_RUN" == "yes" ]]; then
        echo "    (Dry run) pdftk \"$pdf_file\" cat \"$page_range\" output \"$output_filename\""
    else
        # Execute pdftk. Filter out common "Outputting book" messages from stderr.
        # Keep other stderr output for actual errors.
        # Added '> /dev/null' to suppress pdftk stdout entirely, keep stderr filtering.
        if ! pdftk "$pdf_file" cat "$page_range" output "$output_filename" > /dev/null 2> >(grep -v "Outputting book" >&2); then
            echo "    Error splitting PDF \"$pdf_file\" for range \"$page_range\". pdftk may have failed."
            # Script will continue to the next section even if one fails.
        fi
    fi

  done # End loop through sections_to_extract

  echo "Finished processing PDF: \"$pdf_file\""
  echo "-----------------------------------"

done # End of file loop

echo "Finished processing all PDF files with metadata."
