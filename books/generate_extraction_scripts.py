import os
import re
from collections import defaultdict

def parse_metadata(metadata_path):
    """Parses metadata.txt and returns bookmarks and total pages."""
    bookmarks = []
    total_pages = 0

    with open(metadata_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract Bookmarks
    bookmark_blocks = re.findall(r'BookmarkBegin\n(.*?)(?=BookmarkBegin|$)', content, re.DOTALL)
    for block in bookmark_blocks:
        bookmark_info = {}
        for line in block.strip().split('\n'):
            if ':' in line:
                key, value = line.split(':', 1)
                bookmark_info[key.strip()] = value.strip()
        bookmarks.append(bookmark_info)

    # Extract total number of pages
    num_pages_match = re.search(r'NumberOfPages:\s*(\d+)', content)
    if num_pages_match:
        total_pages = int(num_pages_match.group(1))

    return bookmarks, total_pages

def clean_title_for_filename(title, level, is_part_title=False):
    """Cleans a bookmark title for use as a filename."""
    original_title = title
    # Remove characters that are problematic in filenames or common in metadata but not useful
    title = title.replace('$', '').replace('/', '').replace('\\', '').replace(':', '')
    # Replace non-alphanumeric (and non-underscore) with hyphens, convert to lowercase
    title = re.sub(r'[^a-z0-9_]+', '-', title.lower())
    title = title.strip('-') # Remove leading/trailing hyphens

    if is_part_title:
        # Example: "Part I Initialization Parameters" -> "part01_initialization_parameters_title"
        match = re.match(r'(part-([ivxlcdm]+))-?(.*)', title)
        if match:
            part_roman = match.group(2)
            # Simple conversion for common roman numerals. Extend if needed for larger numbers.
            roman_to_int = {'i':1, 'ii':2, 'iii':3, 'iv':4, 'v':5,
                            'vi':6, 'vii':7, 'viii':8, 'ix':9, 'x':10,
                            'xi':11, 'xii':12, 'xiii':13, 'xiv':14, 'xv':15,
                            'xvi':16, 'xvii':17, 'xviii':18, 'xix':19, 'xx':20}
            int_val = 0
            prev_val = 0
            for char in part_roman:
                val = roman_to_int.get(char, 0) # Use .get with 0 for safety
                if val == 0: # If character is not a valid roman numeral part
                    int_val = 0 # Invalidate roman numeral processing
                    break
                if val > prev_val:
                    int_val += val - 2 * prev_val
                else:
                    int_val += val
                prev_val = val
            part_number = str(int_val).zfill(2) if int_val > 0 else part_roman # Use original roman if conversion failed

            clean_part_title = match.group(3).strip('-')
            if not clean_part_title: # Handle cases like "Part I" only
                return f"part{part_number}_title"
            return f"part{part_number}_{clean_part_title}_title"
        return re.sub(r'[^a-z0-9_]+', '-', original_title.lower()).strip('-') + "_title" # Fallback if part regex fails

    # Common initial sections
    if original_title == "Contents": return "contents"
    if original_title == "Preface": return "preface"
    if original_title.startswith("List of "): return f"list_of_{title.replace('list-of-', '')}"
    
    # "Changes in This Release" which can sometimes be the first chapter (level 1)
    if "changes-in-this-release" in title or "changes-in-oracle-database" in title:
        # Try to extract chapter number if present (e.g., "1-changes-in-this-release-")
        match = re.match(r'(\d+)-?(.*)', title)
        if match:
            chapter_num = match.group(1).zfill(2)
            rest_of_title = match.group(2).replace('changes-in-this-release-for-oracle-database-reference', 'changes').strip('-') # Specific to database-reference
            return f"ch{chapter_num}_{rest_of_title or 'changes'}"
        return f"changes" # Default if no specific chapter number found, sequential prefix will order

    # Chapters (level 1 after initial sections)
    match_chapter = re.match(r'(\d+)-?(.*)', title) # e.g., "1-introduction-to-java" or "2-basic-elements-of-oracle-sql"
    if match_chapter:
        chapter_num = match_chapter.group(1).zfill(2)
        chapter_name = match_chapter.group(2).strip('-')
        if not chapter_name: # Handle case where it's just "1"
            return f"ch{chapter_num}"
        return f"ch{chapter_num}_{chapter_name}"

    # Appendices
    if re.match(r'^[a-z]-', title): # e.g., "a-nonpersistent-queues"
        return f"app_{title.replace('-', '_')}"
    elif "appendix" in title: # Fallback for "Appendix: ..."
        return f"app_{title.replace('appendix-', '').replace('appendix', '').strip('-')}"

    # Glossary and Index
    if title == 'glossary': return "glossary"
    if title == 'index': return "index"

    # Default fallback for other cases
    return title

def get_features_for_extraction(bookmarks, total_pages, file_type):
    """
    Identifies features for extraction, including start and end physical pages.
    Each feature is a top-level conceptual unit.
    """
    features = []
    
    # Pre-define some special initial sections for consistent ordering
    initial_section_order = {
        "Contents": 0,
        "List of Examples": 1,
        "List of Figures": 2,
        "List of Tables": 3,
        "Preface": 4,
    }

    # Collect all top-level bookmarks for proper ordering and range calculation
    top_level_bookmarks = []
    for bm in bookmarks:
        bm_level = int(bm['BookmarkLevel'])
        bm_title = bm['BookmarkTitle'].strip()
        bm_page = int(bm['BookmarkPageNumber'])

        is_part_title = file_type == "database-reference" and bm_title.startswith("Part ") and bm_level == 1

        # Check if it's one of the initial special sections
        if bm_title in initial_section_order and bm_level == 1:
            top_level_bookmarks.append({
                'title_raw': bm_title,
                'page': bm_page,
                'level': bm_level,
                'is_part_title': is_part_title,
                'initial_order': initial_section_order[bm_title]
            })
        # Check if it's a regular level 1 chapter/appendix/glossary/index
        elif bm_level == 1:
            top_level_bookmarks.append({
                'title_raw': bm_title,
                'page': bm_page,
                'level': bm_level,
                'is_part_title': is_part_title,
                'initial_order': float('inf') # Will be sorted later based on page number
            })
        # Special cases for Level 2 bookmarks acting as top-level chapters (e.g., initial chapter in some docs)
        elif bm_level == 2:
            if (file_type == 'java-developers-guide' and bm_title == 'Introduction to Java in Oracle Database') or \
               (file_type == 'oracle-database-javascript-developers-guide' and bm_title == 'Changes in This Release for JavaScript Developer\'s Guide') or \
               (file_type == 'json-relational-duality-developers-guide' and bm_title == '1 Overview of JSON-Relational Duality Views'):
                top_level_bookmarks.append({
                    'title_raw': bm_title,
                    'page': bm_page,
                    'level': bm_level,
                    'is_part_title': False,
                    'initial_order': float('inf') # Needs to be ordered before regular chapters
                })


    # Sort these top-level bookmarks first by the pre-defined initial order, then by page number
    top_level_bookmarks.sort(key=lambda x: (x['initial_order'], x['page']))

    # Now determine page ranges and assign final order for output
    final_features_list = []
    assigned_order_counter = 0
    for i, current_bm_info in enumerate(top_level_bookmarks):
        start_page = current_bm_info['page']
        end_page = total_pages + 1 # Default to end of document (exclusive)

        title_raw = current_bm_info['title_raw']
        is_part_title = current_bm_info['is_part_title']

        # Determine end page for the current feature
        if is_part_title:
            end_page = start_page + 1 # Part titles are typically single pages
        else:
            # Find the start page of the next top-level bookmark
            for j in range(i + 1, len(top_level_bookmarks)):
                next_start_page = top_level_bookmarks[j]['page']
                if next_start_page > start_page: # Ensure next bookmark is actually after current
                    end_page = next_start_page
                    break
        
        clean_title_base = clean_title_for_filename(title_raw, current_bm_info['level'], is_part_title)
        
        final_features_list.append({
            'title_raw': title_raw,
            'title_clean': clean_title_base,
            'start_page_physical': start_page,
            'end_page_physical': end_page, # This is exclusive
            'order': assigned_order_counter
        })
        assigned_order_counter += 1

    return final_features_list


def generate_sh_script(book_dir_name, output_root_dir):
    book_full_path = os.path.join(output_root_dir, book_dir_name)
    pdf_filename = ""
    metadata_filename = "metadata.txt" # Assuming consistent metadata filename
    
    for f in os.listdir(book_full_path):
        if f.endswith('.pdf'):
            pdf_filename = f
            break
            
    if not pdf_filename:
        print(f"Error: PDF file not found in {book_full_path}")
        return

    pdf_path = os.path.join(book_full_path, pdf_filename)
    metadata_path = os.path.join(book_full_path, metadata_filename)
    output_dir = os.path.join(book_full_path, "extracted_features")

    bookmarks, total_pages = parse_metadata(metadata_path)
    features_to_extract = get_features_for_extraction(bookmarks, total_pages, book_dir_name)

    script_content = f"""#!/bin/bash

# Script for {book_dir_name}
# Extracts key features from {pdf_filename} into separate PDF files.

PDF_FILE="{pdf_path}"
OUTPUT_DIR="{output_dir}"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

"""
    # Keep track of generated filenames to prevent overwrites and ensure uniqueness by full path
    generated_output_paths = set()

    feature_counter = 0
    for feature in features_to_extract:
        start_p = feature['start_page_physical']
        end_p_inclusive = feature['end_page_physical'] - 1 
        
        # Ensure end_p_inclusive does not exceed total_pages
        if end_p_inclusive > total_pages:
            end_p_inclusive = total_pages
        
        # Handle cases where the determined range might be invalid (e.g., 0 pages or start > end)
        if start_p <= 0 or start_p > end_p_inclusive:
            print(f"Warning: Skipping {feature['title_clean']} (raw: {feature['title_raw']}) due to invalid page range ({start_p}-{end_p_inclusive}).")
            continue

        base_filename = feature['title_clean']
        
        # Use a sequential number prefix for ordering
        unique_filename_base = f"{str(feature_counter).zfill(2)}_{base_filename}"
        unique_filename = f"{unique_filename_base}.pdf"

        # Check for potential filename collisions (even with sequential prefix, if base_filename is very generic)
        # This is more of a failsafe, as the sequential prefix should handle uniqueness well enough for this case.
        if unique_filename in generated_output_paths:
            import hashlib
            hash_suffix = hashlib.md5(f"{base_filename}-{start_p}-{end_p_inclusive}".encode()).hexdigest()[:4]
            unique_filename = f"{unique_filename_base}_{hash_suffix}.pdf"
        
        generated_output_paths.add(unique_filename)

        script_content += f"echo \"Extracting '{feature['title_raw']}' (physical pages {start_p}-{end_p_inclusive})\"\n"
        script_content += f"pdftk \"$PDF_FILE\" cat {start_p}-{end_p_inclusive} output \"$OUTPUT_DIR/{unique_filename}\"\n\n"
        feature_counter += 1

    # Save the script
    script_path = os.path.join(book_full_path, f"extract_{book_dir_name}.sh")
    with open(script_path, 'w', encoding='utf-8') as f:
        f.write(script_content)
    os.chmod(script_path, 0o755) # Make executable
    print(f"Generated {script_path}")

# Main execution loop
if __name__ == "__main__":
    base_dir = os.path.expanduser("~/Devs/sql/TransitionalSQL/books/additional")
    
    # List of book directories
    book_dirs = [
        "database-reference",
        "database-transactional-event-queues-and-advanced-queuing-users-guide",
        "java-developers-guide",
        "json-relational-duality-developers-guide",
        "oracle-database-javascript-developers-guide",
        "oracle-database-sql-firewall-users-guide",
        "securefiles-and-large-objects-developers-guide",
        "sql-language-reference",
        "universal-connection-pool-developers-guide"
    ]

    for b_dir in book_dirs:
        generate_sh_script(b_dir, base_dir)

print("\nAll shell scripts generated successfully.")
print("To run the extraction, navigate to each book's directory and execute its script. For example:")
print(f"  cd {base_dir}/database-reference")
print(f"  ./extract_database-reference.sh")
print("\nEach book's extracted features will be saved in a new 'extracted_features' subdirectory.")
