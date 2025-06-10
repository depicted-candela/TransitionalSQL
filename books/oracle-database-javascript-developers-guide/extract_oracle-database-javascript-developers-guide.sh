#!/bin/bash

# Script for oracle-database-javascript-developers-guide
# Extracts key features from oracle-database-javascript-developers-guide.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/oracle-database-javascript-developers-guide/oracle-database-javascript-developers-guide.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/oracle-database-javascript-developers-guide/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-7)"
pdftk "$PDF_FILE" cat 3-7 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'List of Examples' (physical pages 8-10)"
pdftk "$PDF_FILE" cat 8-10 output "$OUTPUT_DIR/01_list_of_examples.pdf"

echo "Extracting 'List of Figures' (physical pages 11-11)"
pdftk "$PDF_FILE" cat 11-11 output "$OUTPUT_DIR/02_list_of_figures.pdf"

echo "Extracting 'List of Tables' (physical pages 12-12)"
pdftk "$PDF_FILE" cat 12-12 output "$OUTPUT_DIR/03_list_of_tables.pdf"

echo "Extracting '1 Changes in This Release for JavaScript Developer's Guide' (physical pages 13-14)"
pdftk "$PDF_FILE" cat 13-14 output "$OUTPUT_DIR/04_ch01_changes-in-this-release-for-javascript-developer-s-guide.pdf"

echo "Extracting '2 Introduction to Oracle Database Multilingual Engine for JavaScript' (physical pages 15-25)"
pdftk "$PDF_FILE" cat 15-25 output "$OUTPUT_DIR/05_ch02_introduction-to-oracle-database-multilingual-engine-for-javascript.pdf"

echo "Extracting '3 MLE JavaScript Modules and Environments' (physical pages 26-46)"
pdftk "$PDF_FILE" cat 26-46 output "$OUTPUT_DIR/06_ch03_mle-javascript-modules-and-environments.pdf"

echo "Extracting '4 Overview of Dynamic MLE Execution' (physical pages 47-53)"
pdftk "$PDF_FILE" cat 47-53 output "$OUTPUT_DIR/07_ch04_overview-of-dynamic-mle-execution.pdf"

echo "Extracting '5 Overview of Importing MLE JavaScript Modules' (physical pages 54-61)"
pdftk "$PDF_FILE" cat 54-61 output "$OUTPUT_DIR/08_ch05_overview-of-importing-mle-javascript-modules.pdf"

echo "Extracting '6 MLE JavaScript Functions' (physical pages 62-78)"
pdftk "$PDF_FILE" cat 62-78 output "$OUTPUT_DIR/09_ch06_mle-javascript-functions.pdf"

echo "Extracting '7 Calling PL/SQL and SQL from the MLE JavaScript SQL Driver' (physical pages 79-125)"
pdftk "$PDF_FILE" cat 79-125 output "$OUTPUT_DIR/10_ch07_calling-plsql-and-sql-from-the-mle-javascript-sql-driver.pdf"

echo "Extracting '8 Working with SODA Collections in MLE JavaScript Code' (physical pages 126-156)"
pdftk "$PDF_FILE" cat 126-156 output "$OUTPUT_DIR/11_ch08_working-with-soda-collections-in-mle-javascript-code.pdf"

echo "Extracting '9 Post-Execution Debugging of MLE JavaScript Modules' (physical pages 157-172)"
pdftk "$PDF_FILE" cat 157-172 output "$OUTPUT_DIR/12_ch09_post-execution-debugging-of-mle-javascript-modules.pdf"

echo "Extracting '10 MLE Security' (physical pages 173-193)"
pdftk "$PDF_FILE" cat 173-193 output "$OUTPUT_DIR/13_ch10_mle-security.pdf"

echo "Extracting 'A MLE Type Conversions' (physical pages 194-201)"
pdftk "$PDF_FILE" cat 194-201 output "$OUTPUT_DIR/14_app_a_mle_type_conversions.pdf"

echo "Extracting 'Index' (physical pages 202-204)"
pdftk "$PDF_FILE" cat 202-204 output "$OUTPUT_DIR/15_index.pdf"

