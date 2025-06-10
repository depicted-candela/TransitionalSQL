#!/bin/bash

# Script for securefiles-and-large-objects-developers-guide
# Extracts key features from securefiles-and-large-objects-developers-guide.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/securefiles-and-large-objects-developers-guide/securefiles-and-large-objects-developers-guide.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/securefiles-and-large-objects-developers-guide/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-14)"
pdftk "$PDF_FILE" cat 3-14 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'Preface' (physical pages 15-16)"
pdftk "$PDF_FILE" cat 15-16 output "$OUTPUT_DIR/01_preface.pdf"

echo "Extracting 'Changes in Oracle Database' (physical pages 17-20)"
pdftk "$PDF_FILE" cat 17-20 output "$OUTPUT_DIR/02_changes.pdf"

echo "Extracting '1 Introduction to Large Objects and SecureFiles' (physical pages 21-28)"
pdftk "$PDF_FILE" cat 21-28 output "$OUTPUT_DIR/03_ch01_introduction-to-large-objects-and-securefiles.pdf"

echo "Extracting '2 Persistent LOBs' (physical pages 29-44)"
pdftk "$PDF_FILE" cat 29-44 output "$OUTPUT_DIR/04_ch02_persistent-lobs.pdf"

echo "Extracting '3 Temporary LOBs' (physical pages 45-54)"
pdftk "$PDF_FILE" cat 45-54 output "$OUTPUT_DIR/05_ch03_temporary-lobs.pdf"

echo "Extracting '4 Value LOBs' (physical pages 55-68)"
pdftk "$PDF_FILE" cat 55-68 output "$OUTPUT_DIR/06_ch04_value-lobs.pdf"

echo "Extracting '5 BFILEs' (physical pages 69-96)"
pdftk "$PDF_FILE" cat 69-96 output "$OUTPUT_DIR/07_ch05_bfiles.pdf"

echo "Extracting '6 SQL Semantics for LOBs' (physical pages 97-104)"
pdftk "$PDF_FILE" cat 97-104 output "$OUTPUT_DIR/08_ch06_sql-semantics-for-lobs.pdf"

echo "Extracting '7 PL/SQL Semantics for LOBs' (physical pages 105-117)"
pdftk "$PDF_FILE" cat 105-117 output "$OUTPUT_DIR/09_ch07_plsql-semantics-for-lobs.pdf"

echo "Extracting '8 Data Interface for LOBs' (physical pages 118-137)"
pdftk "$PDF_FILE" cat 118-137 output "$OUTPUT_DIR/10_ch08_data-interface-for-lobs.pdf"

echo "Extracting '9 Locator Interface for LOBs' (physical pages 138-175)"
pdftk "$PDF_FILE" cat 138-175 output "$OUTPUT_DIR/11_ch09_locator-interface-for-lobs.pdf"

echo "Extracting '10 Distributed LOBs' (physical pages 176-193)"
pdftk "$PDF_FILE" cat 176-193 output "$OUTPUT_DIR/12_ch10_distributed-lobs.pdf"

echo "Extracting '11 Performance Guidelines' (physical pages 194-202)"
pdftk "$PDF_FILE" cat 194-202 output "$OUTPUT_DIR/13_ch11_performance-guidelines.pdf"

echo "Extracting '12 Persistent LOBs: Advanced DDL' (physical pages 203-231)"
pdftk "$PDF_FILE" cat 203-231 output "$OUTPUT_DIR/14_ch12_persistent-lobs-advanced-ddl.pdf"

echo "Extracting '13 Advanced Design Considerations' (physical pages 232-248)"
pdftk "$PDF_FILE" cat 232-248 output "$OUTPUT_DIR/15_ch13_advanced-design-considerations.pdf"

echo "Extracting '14 Managing LOBs: Database Administration' (physical pages 249-260)"
pdftk "$PDF_FILE" cat 249-260 output "$OUTPUT_DIR/16_ch14_managing-lobs-database-administration.pdf"

echo "Extracting '15 Migrating Columns to SecureFile LOBs' (physical pages 261-277)"
pdftk "$PDF_FILE" cat 261-277 output "$OUTPUT_DIR/17_ch15_migrating-columns-to-securefile-lobs.pdf"

echo "Extracting '16 Automatic SecureFiles Shrink' (physical pages 278-285)"
pdftk "$PDF_FILE" cat 278-285 output "$OUTPUT_DIR/18_ch16_automatic-securefiles-shrink.pdf"

echo "Extracting '17 Introducing the Database File System' (physical pages 286-289)"
pdftk "$PDF_FILE" cat 286-289 output "$OUTPUT_DIR/19_ch17_introducing-the-database-file-system.pdf"

echo "Extracting '18 Using DBFS' (physical pages 290-321)"
pdftk "$PDF_FILE" cat 290-321 output "$OUTPUT_DIR/20_ch18_using-dbfs.pdf"

echo "Extracting '19 DBFS SecureFiles Store' (physical pages 322-331)"
pdftk "$PDF_FILE" cat 322-331 output "$OUTPUT_DIR/21_ch19_dbfs-securefiles-store.pdf"

echo "Extracting '20 DBFS Hierarchical Store' (physical pages 332-346)"
pdftk "$PDF_FILE" cat 332-346 output "$OUTPUT_DIR/22_ch20_dbfs-hierarchical-store.pdf"

echo "Extracting '21 Database File System Links' (physical pages 347-353)"
pdftk "$PDF_FILE" cat 347-353 output "$OUTPUT_DIR/23_ch21_database-file-system-links.pdf"

echo "Extracting '22 DBFS Content API' (physical pages 354-374)"
pdftk "$PDF_FILE" cat 354-374 output "$OUTPUT_DIR/24_ch22_dbfs-content-api.pdf"

echo "Extracting '23 Creating Your Own DBFS Store' (physical pages 375-403)"
pdftk "$PDF_FILE" cat 375-403 output "$OUTPUT_DIR/25_ch23_creating-your-own-dbfs-store.pdf"

echo "Extracting '24 DBFS Access Using OFS' (physical pages 404-413)"
pdftk "$PDF_FILE" cat 404-413 output "$OUTPUT_DIR/26_ch24_dbfs-access-using-ofs.pdf"

echo "Extracting 'A Comparing the LOB Interfaces' (physical pages 414-417)"
pdftk "$PDF_FILE" cat 414-417 output "$OUTPUT_DIR/27_app_a_comparing_the_lob_interfaces.pdf"

