#!/bin/bash

# Script for oracle-database-sql-firewall-users-guide
# Extracts key features from oracle-database-sql-firewall-users-guide.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/oracle-database-sql-firewall-users-guide/oracle-database-sql-firewall-users-guide.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/oracle-database-sql-firewall-users-guide/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-6)"
pdftk "$PDF_FILE" cat 3-6 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'Preface' (physical pages 7-8)"
pdftk "$PDF_FILE" cat 7-8 output "$OUTPUT_DIR/01_preface.pdf"

echo "Extracting 'Changes in This Release for Oracle Database SQL Firewall Guide' (physical pages 9-10)"
pdftk "$PDF_FILE" cat 9-10 output "$OUTPUT_DIR/02_changes.pdf"

echo "Extracting '1 Overview of Oracle SQL Firewall' (physical pages 11-15)"
pdftk "$PDF_FILE" cat 11-15 output "$OUTPUT_DIR/03_ch01_overview-of-oracle-sql-firewall.pdf"

echo "Extracting '2 Configuring Oracle SQL Firewall' (physical pages 16-50)"
pdftk "$PDF_FILE" cat 16-50 output "$OUTPUT_DIR/04_ch02_configuring-oracle-sql-firewall.pdf"

echo "Extracting '3 How Oracle SQL Firewall Works with Other Oracle Features' (physical pages 51-56)"
pdftk "$PDF_FILE" cat 51-56 output "$OUTPUT_DIR/05_ch03_how-oracle-sql-firewall-works-with-other-oracle-features.pdf"

echo "Extracting '4 Oracle SQL Firewall Data Dictionary Views and Example Queries' (physical pages 57-58)"
pdftk "$PDF_FILE" cat 57-58 output "$OUTPUT_DIR/06_ch04_oracle-sql-firewall-data-dictionary-views-and-example-queries.pdf"

echo "Extracting 'Appendix: SQL Firewall Database Views and DBMS Package' (physical pages 59-87)"
pdftk "$PDF_FILE" cat 59-87 output "$OUTPUT_DIR/07_app_sql-firewall-database-views-and-dbms-package.pdf"

echo "Extracting 'Glossary' (physical pages 88-88)"
pdftk "$PDF_FILE" cat 88-88 output "$OUTPUT_DIR/08_glossary.pdf"

echo "Extracting 'Index' (physical pages 89-91)"
pdftk "$PDF_FILE" cat 89-91 output "$OUTPUT_DIR/09_index.pdf"

