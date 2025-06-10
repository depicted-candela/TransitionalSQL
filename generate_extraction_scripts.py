import os
import re

def sanitize_filename(title):
    # Remove any character that is not alphanumeric, underscore, hyphen, or dot
    s_title = re.sub(r'[^a-zA-Z0-9_.-]', '', title)
    # Replace multiple consecutive underscores with a single one
    s_title = re.sub(r'_{2,}', '_', s_title)
    # Remove leading/trailing underscores
    s_title = s_title.strip('_')
    # Truncate to a reasonable length to avoid filesystem limits, while maintaining readability
    max_len = 150 
    if len(s_title) > max_len:
        s_title = s_title[:max_len]
    if not s_title: # Ensure filename is not empty after sanitization
        s_title = "unnamed_section"
    return s_title

def parse_metadata(metadata_path):
    bookmarks = []
    num_pages = 0
    with open(metadata_path, 'r') as f:
        lines = f.readlines()

    current_bookmark = {}
    for line in lines:
        line = line.strip()
        # The metadata.txt often contains non-bookmark info at the end, stop when we see a new InfoBegin
        if line.startswith('InfoBegin') and 'ModDate' in line:
            if current_bookmark: # Append any pending bookmark before breaking
                bookmarks.append(current_bookmark)
            break 
        
        if line.startswith('NumberOfPages:'):
            num_pages = int(line.split(':')[1].strip())
        elif line.startswith('BookmarkBegin'):
            if current_bookmark and 'title' in current_bookmark and 'level' in current_bookmark and 'page' in current_bookmark:
                bookmarks.append(current_bookmark)
            current_bookmark = {}
        elif line.startswith('BookmarkTitle:'):
            current_bookmark['title'] = line.split('BookmarkTitle:')[1].strip()
        elif line.startswith('BookmarkLevel:'):
            current_bookmark['level'] = int(line.split('BookmarkLevel:')[1].strip())
        elif line.startswith('BookmarkPageNumber:'):
            current_bookmark['page'] = int(line.split('BookmarkPageNumber:')[1].strip())
    
    if current_bookmark and 'title' in current_bookmark and 'level' in current_bookmark and 'page' in current_bookmark:
        bookmarks.append(current_bookmark)

    return bookmarks, num_pages

def generate_extraction_script(book_dir_name, pdf_file_name, bookmarks, total_pages):
    script_content = []
    script_content.append("#!/bin/bash")
    script_content.append("set -e") # Exit immediately if a command exits with a non-zero status
    script_content.append("")
    script_content.append(f"PDF_FILE=\"{pdf_file_name}\"")
    script_content.append("OUTPUT_DIR=\"extracted_features\"")
    script_content.append("mkdir -p \"$OUTPUT_DIR\"")
    script_content.append("")
    script_content.append("echo \"Starting extraction for $PDF_FILE...\"")
    script_content.append("")

    # Define common meta-sections to exclude from being treated as content features
    # These are usually navigation aids or introductory sections that span few pages
    # and don't represent a 'feature' in terms of substantial content.
    excluded_content_titles = [
        "Contents", "List of Examples", "List of Figures", "List of Tables", "Preface"
    ]

    features_to_extract = []
    for bm in bookmarks:
        # We consider only Level 1 bookmarks as primary "features"
        # and explicitly exclude the meta-sections as defined.
        if bm['level'] == 1 and bm['title'] not in excluded_content_titles:
            features_to_extract.append(bm)
    
    # Sort features by page number to ensure correct processing order
    features_to_extract.sort(key=lambda x: x['page'])

    for i, feature in enumerate(features_to_extract):
        start_page = feature['page']
        if i + 1 < len(features_to_extract):
            # End page is one page before the next feature starts
            end_page = features_to_extract[i+1]['page'] - 1
        else:
            # Last feature ends at the total number of pages in the PDF
            end_page = total_pages
        
        # Ensure that end_page is not less than start_page,
        # which can happen for single-page sections or malformed bookmarks.
        if end_page < start_page:
            end_page = start_page

        sanitized_title = sanitize_filename(feature['title'])
        # Add page numbers to avoid naming conflicts and provide context
        output_filename = f"{sanitized_title}_p{start_page}-{end_page}.pdf"
        
        script_content.append(f"echo \"Extracting '{feature['title']}' (pages {start_page}-{end_page})...\"")
        script_content.append(f"pdftk \"$PDF_FILE\" cat {start_page}-{end_page} output \"$OUTPUT_DIR/{output_filename}\"")
        script_content.append("")
    
    script_content.append("echo \"Extraction complete for $PDF_FILE.\"")
    return "\n".join(script_content)

# Define the base path where the 'additional' directory is located
# Adjust this path if your script is in a different location relative to 'additional'
base_path = os.path.join(os.path.dirname(__file__), "books", "additional")
root_dir = os.path.abspath(base_path)

print(f"Scanning directory: {root_dir}")

for item in os.listdir(root_dir):
    book_dir_path = os.path.join(root_dir, item)
    if os.path.isdir(book_dir_path):
        pdf_name = ""
        metadata_path = os.path.join(book_dir_path, "metadata.txt")

        if not os.path.exists(metadata_path):
            print(f"Skipping {item}: metadata.txt not found. Please ensure it's in the directory.")
            continue

        # Find the PDF file in the directory
        for f in os.listdir(book_dir_path):
            if f.endswith(".pdf"):
                pdf_name = f
                break
        
        if not pdf_name:
            print(f"Skipping {item}: No PDF file found in the directory.")
            continue
        
        # We pass the PDF filename relative to the book_dir_path for the shell script
        # as the shell script will be executed from within that directory.
        
        print(f"Processing: {item} (PDF: {pdf_name})")
        bookmarks, total_pages = parse_metadata(metadata_path)
        extraction_script_content = generate_extraction_script(item, pdf_name, bookmarks, total_pages)

        script_filename = os.path.join(book_dir_path, f"extract_{item}.sh")
        with open(script_filename, 'w') as f:
            f.write(extraction_script_content)
        os.chmod(script_filename, 0o755) # Make the script executable
        print(f"Generated extraction script: {script_filename}")
        print("--------------------------------------------------")

print("\nAll extraction scripts generated.")
print("To extract features for a specific book, navigate to its directory and run its 'extract_*.sh' script.")
print("Example: cd books/additional/database-reference && ./extract_database-reference.sh")
print("This will create a new 'extracted_features' subdirectory containing the PDF features.")
