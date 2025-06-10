#!/bin/bash

# Script for universal-connection-pool-developers-guide
# Extracts key features from universal-connection-pool-developers-guide.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/universal-connection-pool-developers-guide/universal-connection-pool-developers-guide.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/universal-connection-pool-developers-guide/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-8)"
pdftk "$PDF_FILE" cat 3-8 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'Preface' (physical pages 9-10)"
pdftk "$PDF_FILE" cat 9-10 output "$OUTPUT_DIR/01_preface.pdf"

echo "Extracting 'Changes in This Release for Oracle Universal Connection Pool Developer's Guide' (physical pages 11-11)"
pdftk "$PDF_FILE" cat 11-11 output "$OUTPUT_DIR/02_changes.pdf"

echo "Extracting '1 Introduction to UCP' (physical pages 12-15)"
pdftk "$PDF_FILE" cat 12-15 output "$OUTPUT_DIR/03_ch01_introduction-to-ucp.pdf"

echo "Extracting '2 Getting Started' (physical pages 16-20)"
pdftk "$PDF_FILE" cat 16-20 output "$OUTPUT_DIR/04_ch02_getting-started.pdf"

echo "Extracting '3 Getting Database Connections in UCP' (physical pages 21-32)"
pdftk "$PDF_FILE" cat 21-32 output "$OUTPUT_DIR/05_ch03_getting-database-connections-in-ucp.pdf"

echo "Extracting '4 Connection Creation Consumer' (physical pages 33-35)"
pdftk "$PDF_FILE" cat 33-35 output "$OUTPUT_DIR/06_ch04_connection-creation-consumer.pdf"

echo "Extracting '5 Optimizing Universal Connection Pool Behavior' (physical pages 36-49)"
pdftk "$PDF_FILE" cat 36-49 output "$OUTPUT_DIR/07_ch05_optimizing-universal-connection-pool-behavior.pdf"

echo "Extracting '6 Labeling Connections in UCP' (physical pages 50-56)"
pdftk "$PDF_FILE" cat 50-56 output "$OUTPUT_DIR/08_ch06_labeling-connections-in-ucp.pdf"

echo "Extracting '7 Controlling Reclaimable Connection Behavior' (physical pages 57-58)"
pdftk "$PDF_FILE" cat 57-58 output "$OUTPUT_DIR/09_ch07_controlling-reclaimable-connection-behavior.pdf"

echo "Extracting '8 Using the Connection Pool Manager' (physical pages 59-64)"
pdftk "$PDF_FILE" cat 59-64 output "$OUTPUT_DIR/10_ch08_using-the-connection-pool-manager.pdf"

echo "Extracting '9 Shared Pool Support for Multitenant Data Sources' (physical pages 65-73)"
pdftk "$PDF_FILE" cat 65-73 output "$OUTPUT_DIR/11_ch09_shared-pool-support-for-multitenant-data-sources.pdf"

echo "Extracting '10 Using Oracle RAC Features' (physical pages 74-95)"
pdftk "$PDF_FILE" cat 74-95 output "$OUTPUT_DIR/12_ch10_using-oracle-rac-features.pdf"

echo "Extracting '11 UCP Asynchronous Extension' (physical pages 96-100)"
pdftk "$PDF_FILE" cat 96-100 output "$OUTPUT_DIR/13_ch11_ucp-asynchronous-extension.pdf"

echo "Extracting '12 Ensuring Application Continuity' (physical pages 101-102)"
pdftk "$PDF_FILE" cat 101-102 output "$OUTPUT_DIR/14_ch12_ensuring-application-continuity.pdf"

echo "Extracting '13 Shared Pool for Sharded Databases' (physical pages 103-113)"
pdftk "$PDF_FILE" cat 103-113 output "$OUTPUT_DIR/15_ch13_shared-pool-for-sharded-databases.pdf"

echo "Extracting '14 Diagnosing a Connection Pool' (physical pages 114-121)"
pdftk "$PDF_FILE" cat 114-121 output "$OUTPUT_DIR/16_ch14_diagnosing-a-connection-pool.pdf"

echo "Extracting 'A Error Codes Reference' (physical pages 122-129)"
pdftk "$PDF_FILE" cat 122-129 output "$OUTPUT_DIR/17_app_a_error_codes_reference.pdf"

echo "Extracting 'B UCP Exception Error Codes' (physical pages 130-133)"
pdftk "$PDF_FILE" cat 130-133 output "$OUTPUT_DIR/18_app_b_ucp_exception_error_codes.pdf"

echo "Extracting 'Index' (physical pages 134-137)"
pdftk "$PDF_FILE" cat 134-137 output "$OUTPUT_DIR/19_index.pdf"

