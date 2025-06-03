#!/bin/bash

# PDF file to process
pdf_input_file="database-development-guide.pdf"
# Total number of pages in the PDF
total_pages_in_doc=1011

# Array to hold pdftk commands
commands=()

# Define sections to extract: title, physical start page, and filename prefix
# The physical start pages are taken directly from the BookmarkPageNumber in metadata.txt
# Filename prefixes are chosen to match the example's style (00a_, ch01_, appA_, etc.)
declare -a sections_to_extract=(
    "Contents|3|00a_"
    "List of Tables|31|00b_"
    "Preface|34|00c_"
    "Changes in This Release for Oracle Database Development Guide|36|00d_"
    "1 Design Basics|42|ch01_"
    "2 Connection Strategies for Database Applications|55|ch02_"
    "3 Performance and Scalability|63|ch03_"
    "4 Designing Applications for Oracle Real-World Performance|116|ch04_"
    "5 Security|126|ch05_"
    "6 High Availability|133|ch06_"
    "7 Advanced PL/SQL Features|144|ch07_"
    "8 SQL Processing for Application Developers|148|ch08_"
    "9 Using SQL Data Types in Database Applications|199|ch09_"
    "10 Registering Application Data Usage with the Database|226|ch10_"
    "11 Using Regular Expressions in Database Applications|325|ch11_"
    "12 Using Indexes in Database Applications|338|ch12_"
    "13 Maintaining Data Integrity in Database Applications|347|ch13_"
    "14 Coding PL/SQL Subprograms and Packages|392|ch14_"
    "15 Using PL/Scope|435|ch15_"
    "16 Using the PL/SQL Hierarchical Profiler|455|ch16_"
    "17 Using PL/SQL Basic Block Coverage to Maintain Quality|482|ch17_"
    "18 Developing PL/SQL Web Applications|486|ch18_"
    "19 Using Continuous Query Notification (CQN)|518|ch19_"
    "20 Choosing a Programming Environment|570|ch20_"
    "21 Developing Applications with Multiple Programming Languages|612|ch21_"
    "22 Using Oracle Flashback Technology|657|ch22_"
    "23 Developing Applications with the Publish-Subscribe Model|697|ch23_"
    "24 Using the Oracle Database ODBC Driver|705|ch24_"
    "25 Using the Identity Code Package|706|ch25_"
    "26 Microservices Architecture|733|ch26_"
    "27 Oracle Backend for Microservices and AI|742|ch27_"
    "28 Developing Applications with Sagas|746|ch28_"
    "29 Using Lock-Free Reservation|790|ch29_"
    "30 Developing Applications with Oracle XA|804|ch30_"
    "31 Developing Applications with Sessionless Transactions|833|ch31_"
    "32 Understanding Schema Object Dependency|884|ch32_"
    "33 Using Edition-Based Redefinition|905|ch33_"
    "34 Using Transaction Guard|960|ch34_"
    "35 Table DDL Change Notification|976|ch35_"
    "A.1 Appendix: Troubleshooting the Saga Framework|983|appA_"
    "B.1 Appendix: Troubleshooting UTL_HTTP|990|appB_"
    "C.1 Appendix: Recording DML Changes on the Tracked Table|995|appC_"
    "Index|996|index" # Special prefix for index.pdf
)

# This array includes all bookmarks that define section boundaries.
# Part titles are included here to correctly determine the end page of the preceding section.
declare -a all_boundary_bookmarks=(
    "Contents|3"
    "List of Tables|31"
    "Preface|34"
    "Changes in This Release for Oracle Database Development Guide|36"
    "Part I Database Development Fundamentals|41"
    "1 Design Basics|42"
    "2 Connection Strategies for Database Applications|55"
    "3 Performance and Scalability|63"
    "4 Designing Applications for Oracle Real-World Performance|116"
    "5 Security|126"
    "6 High Availability|133"
    "7 Advanced PL/SQL Features|144"
    "Part II SQL for Application Developers|147"
    "8 SQL Processing for Application Developers|148"
    "9 Using SQL Data Types in Database Applications|199"
    "10 Registering Application Data Usage with the Database|226"
    "11 Using Regular Expressions in Database Applications|325"
    "12 Using Indexes in Database Applications|338"
    "13 Maintaining Data Integrity in Database Applications|347"
    "Part III PL/SQL for Application Developers|391"
    "14 Coding PL/SQL Subprograms and Packages|392"
    "15 Using PL/Scope|435"
    "16 Using the PL/SQL Hierarchical Profiler|455"
    "17 Using PL/SQL Basic Block Coverage to Maintain Quality|482"
    "18 Developing PL/SQL Web Applications|486"
    "19 Using Continuous Query Notification (CQN)|518"
    "Part IV Advanced Topics for Application Developers|569"
    "20 Choosing a Programming Environment|570"
    "21 Developing Applications with Multiple Programming Languages|612"
    "22 Using Oracle Flashback Technology|657"
    "23 Developing Applications with the Publish-Subscribe Model|697"
    "24 Using the Oracle Database ODBC Driver|705"
    "25 Using the Identity Code Package|706"
    "26 Microservices Architecture|733"
    "27 Oracle Backend for Microservices and AI|742"
    "28 Developing Applications with Sagas|746"
    "29 Using Lock-Free Reservation|790"
    "30 Developing Applications with Oracle XA|804"
    "31 Developing Applications with Sessionless Transactions|833"
    "32 Understanding Schema Object Dependency|884"
    "33 Using Edition-Based Redefinition|905"
    "34 Using Transaction Guard|960"
    "35 Table DDL Change Notification|976"
    "A.1 Appendix: Troubleshooting the Saga Framework|983"
    "B.1 Appendix: Troubleshooting UTL_HTTP|990"
    "C.1 Appendix: Recording DML Changes on the Tracked Table|995"
    "Index|996"
    "EndOfDocument|$((total_pages_in_doc + 1))" # Sentinel for end of document
)

# Function to generate a sanitized filename part from a title
generate_sanitized_core_name() {
    local original_title="$1"
    local core_name="$original_title"

    # Remove chapter/appendix numbering like "1 ", "A.1 " etc.
    core_name=$(echo "$core_name" | sed -E 's/^[A-Za-z0-9](\.[0-9]+)*\s+//')
    core_name=$(echo "$core_name" | sed -E 's/^[0-9]+\s+//') # For simple "1 "

    # Specific title cleanups
    if [[ "$original_title" == *"Changes in This Release"* ]]; then
        core_name="changes_in_this_release"
    elif [[ "$core_name" == *"Appendix: "* ]]; then
        core_name=$(echo "$core_name" | sed 's/Appendix: //')
    fi
    
    # General sanitization: replace spaces and special characters with underscores, convert to lowercase
    sanitized_core_name=$(echo "$core_name" | \
        sed 's/[:\/\\()?*"]/ /g' | \
        tr '[:upper:]' '[:lower:]' | \
        tr -s ' ' '_' | \
        sed 's/_*$//g' | sed 's/^_*//g' | \
        sed 's/__*/_/g')
    
    echo "$sanitized_core_name"
}


for section_entry in "${sections_to_extract[@]}"; do
    IFS='|' read -r title start_page_num prefix_str <<< "$section_entry"

    end_page_num=$total_pages_in_doc # Default for the very last section

    # Find the start page of the next boundary *after* current section's start page
    for boundary_entry in "${all_boundary_bookmarks[@]}"; do
        IFS='|' read -r _ next_boundary_start_page <<< "$boundary_entry"
        if (( next_boundary_start_page > start_page_num )); then
            end_page_num=$((next_boundary_start_page - 1))
            break
        fi
    done
    
    # Ensure end_page is not less than start_page
    if (( end_page_num < start_page_num )); then
        end_page_num=$start_page_num
    fi

    sanitized_title_part=$(generate_sanitized_core_name "$title")
    
    output_file=""
    if [[ "$prefix_str" == "index" && "$sanitized_title_part" == "index" ]]; then
        output_file="index.pdf"
    else
        output_file="${prefix_str}${sanitized_title_part}.pdf"
    fi
    
    commands+=("pdftk \"$pdf_input_file\" cat $start_page_num-$end_page_num output \"$output_file\"")
done

# Output all commands
for cmd in "${commands[@]}"; do
    echo "$cmd"
done
