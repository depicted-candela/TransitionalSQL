#!/bin/bash

# Script for database-reference
# Extracts key features from database-reference.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/database-reference/database-reference.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/database-reference/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-91)"
pdftk "$PDF_FILE" cat 3-91 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'Preface' (physical pages 92-93)"
pdftk "$PDF_FILE" cat 92-93 output "$OUTPUT_DIR/01_preface.pdf"

echo "Extracting '1 Changes in This Release for Oracle Database Reference' (physical pages 94-102)"
pdftk "$PDF_FILE" cat 94-102 output "$OUTPUT_DIR/02_ch01_changes.pdf"

echo "Extracting 'Part I Initialization Parameters' (physical pages 103-103)"
pdftk "$PDF_FILE" cat 103-103 output "$OUTPUT_DIR/03_part01_initialization-parameters_title.pdf"

echo "Extracting 'Part II Static Data Dictionary Views' (physical pages 505-505)"
pdftk "$PDF_FILE" cat 505-505 output "$OUTPUT_DIR/04_part02_static-data-dictionary-views_title.pdf"

echo "Extracting 'Part III Dynamic Performance Views' (physical pages 1904-1904)"
pdftk "$PDF_FILE" cat 1904-1904 output "$OUTPUT_DIR/05_part03_dynamic-performance-views_title.pdf"

echo "Extracting 'Part IV Appendixes' (physical pages 2640-2640)"
pdftk "$PDF_FILE" cat 2640-2640 output "$OUTPUT_DIR/06_part04_appendixes_title.pdf"

echo "Extracting 'A Database Limits' (physical pages 2641-2647)"
pdftk "$PDF_FILE" cat 2641-2647 output "$OUTPUT_DIR/07_app_a_database_limits.pdf"

echo "Extracting 'B SQL Scripts' (physical pages 2648-2653)"
pdftk "$PDF_FILE" cat 2648-2653 output "$OUTPUT_DIR/08_app_b_sql_scripts.pdf"

echo "Extracting 'C Oracle Wait Events' (physical pages 2654-2711)"
pdftk "$PDF_FILE" cat 2654-2711 output "$OUTPUT_DIR/09_app_c_oracle_wait_events.pdf"

echo "Extracting 'D Oracle Enqueue Names' (physical pages 2712-2714)"
pdftk "$PDF_FILE" cat 2712-2714 output "$OUTPUT_DIR/10_app_d_oracle_enqueue_names.pdf"

echo "Extracting 'E Statistics Descriptions' (physical pages 2715-2751)"
pdftk "$PDF_FILE" cat 2715-2751 output "$OUTPUT_DIR/11_app_e_statistics_descriptions.pdf"

echo "Extracting 'F Background Processes' (physical pages 2752-2773)"
pdftk "$PDF_FILE" cat 2752-2773 output "$OUTPUT_DIR/12_app_f_background_processes.pdf"

echo "Extracting 'Index' (physical pages 2774-2830)"
pdftk "$PDF_FILE" cat 2774-2830 output "$OUTPUT_DIR/13_index.pdf"

