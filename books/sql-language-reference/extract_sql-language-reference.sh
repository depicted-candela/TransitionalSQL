#!/bin/bash

# Script for sql-language-reference
# Extracts key features from sql-language-reference.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/sql-language-reference/sql-language-reference.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/sql-language-reference/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-27)"
pdftk "$PDF_FILE" cat 3-27 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'Preface' (physical pages 28-29)"
pdftk "$PDF_FILE" cat 28-29 output "$OUTPUT_DIR/01_preface.pdf"

echo "Extracting 'Changes in This Release for Oracle Database SQL Language Reference' (physical pages 30-33)"
pdftk "$PDF_FILE" cat 30-33 output "$OUTPUT_DIR/02_changes.pdf"

echo "Extracting '1 Introduction to Oracle SQL' (physical pages 34-37)"
pdftk "$PDF_FILE" cat 34-37 output "$OUTPUT_DIR/03_ch01_introduction-to-oracle-sql.pdf"

echo "Extracting '2 Basic Elements of Oracle SQL' (physical pages 38-193)"
pdftk "$PDF_FILE" cat 38-193 output "$OUTPUT_DIR/04_ch02_basic-elements-of-oracle-sql.pdf"

echo "Extracting '3 Pseudocolumns' (physical pages 194-206)"
pdftk "$PDF_FILE" cat 194-206 output "$OUTPUT_DIR/05_ch03_pseudocolumns.pdf"

echo "Extracting '4 Operators' (physical pages 207-269)"
pdftk "$PDF_FILE" cat 207-269 output "$OUTPUT_DIR/06_ch04_operators.pdf"

echo "Extracting '5 Expressions' (physical pages 270-314)"
pdftk "$PDF_FILE" cat 270-314 output "$OUTPUT_DIR/07_ch05_expressions.pdf"

echo "Extracting '6 Conditions' (physical pages 315-357)"
pdftk "$PDF_FILE" cat 315-357 output "$OUTPUT_DIR/08_ch06_conditions.pdf"

echo "Extracting '7 Functions' (physical pages 358-881)"
pdftk "$PDF_FILE" cat 358-881 output "$OUTPUT_DIR/09_ch07_functions.pdf"

echo "Extracting '8 Common SQL DDL Clauses' (physical pages 882-945)"
pdftk "$PDF_FILE" cat 882-945 output "$OUTPUT_DIR/10_ch08_common-sql-ddl-clauses.pdf"

echo "Extracting '9 SQL Queries and Subqueries' (physical pages 946-964)"
pdftk "$PDF_FILE" cat 946-964 output "$OUTPUT_DIR/11_ch09_sql-queries-and-subqueries.pdf"

echo "Extracting '10 SQL Statements: ADMINISTER KEY MANAGEMENT to ALTER JSON RELATIONAL DUALITY VIEW' (physical pages 965-1145)"
pdftk "$PDF_FILE" cat 965-1145 output "$OUTPUT_DIR/12_ch10_sql-statements-administer-key-management-to-alter-json-relational-duality-view.pdf"

echo "Extracting '11 SQL Statements: ALTER LIBRARY to ALTER SESSION' (physical pages 1146-1267)"
pdftk "$PDF_FILE" cat 1146-1267 output "$OUTPUT_DIR/13_ch11_sql-statements-alter-library-to-alter-session.pdf"

echo "Extracting '12 SQL Statements: ALTER SYNONYM to COMMENT' (physical pages 1268-1513)"
pdftk "$PDF_FILE" cat 1268-1513 output "$OUTPUT_DIR/14_ch12_sql-statements-alter-synonym-to-comment.pdf"

echo "Extracting '13 SQL Statements: COMMIT to CREATE JSON RELATIONAL DUALITY VIEW' (physical pages 1514-1701)"
pdftk "$PDF_FILE" cat 1514-1701 output "$OUTPUT_DIR/15_ch13_sql-statements-commit-to-create-json-relational-duality-view.pdf"

echo "Extracting '14 SQL Statements: CREATE LIBRARY to CREATE SCHEMA' (physical pages 1702-1844)"
pdftk "$PDF_FILE" cat 1702-1844 output "$OUTPUT_DIR/16_ch14_sql-statements-create-library-to-create-schema.pdf"

echo "Extracting '15 SQL Statements: CREATE SEQUENCE to DROP CLUSTER' (physical pages 1845-2086)"
pdftk "$PDF_FILE" cat 1845-2086 output "$OUTPUT_DIR/17_ch15_sql-statements-create-sequence-to-drop-cluster.pdf"

echo "Extracting '16 SQL Statements: DROP CONTEXT to DROP JAVA' (physical pages 2087-2106)"
pdftk "$PDF_FILE" cat 2087-2106 output "$OUTPUT_DIR/18_ch16_sql-statements-drop-context-to-drop-java.pdf"

echo "Extracting '17 SQL Statements: DROP LIBRARY to DROP SYNONYM' (physical pages 2107-2130)"
pdftk "$PDF_FILE" cat 2107-2130 output "$OUTPUT_DIR/19_ch17_sql-statements-drop-library-to-drop-synonym.pdf"

echo "Extracting '18 SQL Statements: DROP TABLE to LOCK TABLE' (physical pages 2131-2223)"
pdftk "$PDF_FILE" cat 2131-2223 output "$OUTPUT_DIR/20_ch18_sql-statements-drop-table-to-lock-table.pdf"

echo "Extracting '19 SQL Statements: MERGE to UPDATE' (physical pages 2224-2387)"
pdftk "$PDF_FILE" cat 2224-2387 output "$OUTPUT_DIR/21_ch19_sql-statements-merge-to-update.pdf"

echo "Extracting 'A How to Read Syntax Diagrams' (physical pages 2388-2392)"
pdftk "$PDF_FILE" cat 2388-2392 output "$OUTPUT_DIR/22_app_a_how_to_read_syntax_diagrams.pdf"

echo "Extracting 'B Automatic and Manual Locking Mechanisms During SQL Operations' (physical pages 2393-2399)"
pdftk "$PDF_FILE" cat 2393-2399 output "$OUTPUT_DIR/23_app_b_automatic_and_manual_locking_mechanisms_during_sql_operations.pdf"

echo "Extracting 'C Oracle and Standard SQL' (physical pages 2400-2433)"
pdftk "$PDF_FILE" cat 2400-2433 output "$OUTPUT_DIR/24_app_c_oracle_and_standard_sql.pdf"

echo "Extracting 'D Oracle Regular Expression Support' (physical pages 2434-2437)"
pdftk "$PDF_FILE" cat 2434-2437 output "$OUTPUT_DIR/25_app_d_oracle_regular_expression_support.pdf"

echo "Extracting 'E Oracle SQL Reserved Words and Keywords' (physical pages 2438-2441)"
pdftk "$PDF_FILE" cat 2438-2441 output "$OUTPUT_DIR/26_app_e_oracle_sql_reserved_words_and_keywords.pdf"

echo "Extracting 'F Extended Examples' (physical pages 2442-2452)"
pdftk "$PDF_FILE" cat 2442-2452 output "$OUTPUT_DIR/27_app_f_extended_examples.pdf"

echo "Extracting 'Index' (physical pages 2453-2506)"
pdftk "$PDF_FILE" cat 2453-2506 output "$OUTPUT_DIR/28_index.pdf"

