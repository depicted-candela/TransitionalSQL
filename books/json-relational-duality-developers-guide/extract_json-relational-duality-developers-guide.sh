#!/bin/bash

# Script for json-relational-duality-developers-guide
# Extracts key features from json-relational-duality-developers-guide.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/json-relational-duality-developers-guide/json-relational-duality-developers-guide.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/json-relational-duality-developers-guide/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-4)"
pdftk "$PDF_FILE" cat 3-4 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'List of Examples' (physical pages 5-6)"
pdftk "$PDF_FILE" cat 5-6 output "$OUTPUT_DIR/01_list_of_examples.pdf"

echo "Extracting 'List of Figures' (physical pages 7-7)"
pdftk "$PDF_FILE" cat 7-7 output "$OUTPUT_DIR/02_list_of_figures.pdf"

echo "Extracting 'List of Tables' (physical pages 8-8)"
pdftk "$PDF_FILE" cat 8-8 output "$OUTPUT_DIR/03_list_of_tables.pdf"

echo "Extracting 'Preface' (physical pages 9-11)"
pdftk "$PDF_FILE" cat 9-11 output "$OUTPUT_DIR/04_preface.pdf"

echo "Extracting '1 Overview of JSON-Relational Duality Views' (physical pages 12-25)"
pdftk "$PDF_FILE" cat 12-25 output "$OUTPUT_DIR/05_ch01_overview-of-json-relational-duality-views.pdf"

echo "Extracting '2 Introduction To Car-Racing Duality Views Example' (physical pages 26-37)"
pdftk "$PDF_FILE" cat 26-37 output "$OUTPUT_DIR/06_ch02_introduction-to-car-racing-duality-views-example.pdf"

echo "Extracting '3 Creating Duality Views' (physical pages 38-53)"
pdftk "$PDF_FILE" cat 38-53 output "$OUTPUT_DIR/07_ch03_creating-duality-views.pdf"

echo "Extracting '4 Updatable JSON-Relational Duality Views' (physical pages 54-60)"
pdftk "$PDF_FILE" cat 54-60 output "$OUTPUT_DIR/08_ch04_updatable-json-relational-duality-views.pdf"

echo "Extracting '5 Using JSON-Relational Duality Views' (physical pages 61-107)"
pdftk "$PDF_FILE" cat 61-107 output "$OUTPUT_DIR/09_ch05_using-json-relational-duality-views.pdf"

echo "Extracting '6 Document-Identifier Field for Duality Views' (physical pages 108-110)"
pdftk "$PDF_FILE" cat 108-110 output "$OUTPUT_DIR/10_ch06_document-identifier-field-for-duality-views.pdf"

echo "Extracting '7 Generated Fields, Hidden Fields' (physical pages 111-115)"
pdftk "$PDF_FILE" cat 111-115 output "$OUTPUT_DIR/11_ch07_generated-fields-hidden-fields.pdf"

echo "Extracting '8 Schema Flexibility with JSON Columns in Duality Views' (physical pages 116-129)"
pdftk "$PDF_FILE" cat 116-129 output "$OUTPUT_DIR/12_ch08_schema-flexibility-with-json-columns-in-duality-views.pdf"

echo "Extracting '9 GraphQL Language Used for JSON-Relational Duality Views' (physical pages 130-143)"
pdftk "$PDF_FILE" cat 130-143 output "$OUTPUT_DIR/13_ch09_graphql-language-used-for-json-relational-duality-views.pdf"

echo "Extracting 'Index' (physical pages 144-148)"
pdftk "$PDF_FILE" cat 144-148 output "$OUTPUT_DIR/14_index.pdf"

