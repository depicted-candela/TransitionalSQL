#!/bin/bash

# Script for java-developers-guide
# Extracts key features from java-developers-guide.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/java-developers-guide/java-developers-guide.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/java-developers-guide/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-12)"
pdftk "$PDF_FILE" cat 3-12 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'List of Tables' (physical pages 13-13)"
pdftk "$PDF_FILE" cat 13-13 output "$OUTPUT_DIR/01_list_of_tables.pdf"

echo "Extracting 'Preface' (physical pages 14-15)"
pdftk "$PDF_FILE" cat 14-15 output "$OUTPUT_DIR/02_preface.pdf"

echo "Extracting 'Changes in This Release for Oracle Database Java Developer's Guide' (physical pages 16-16)"
pdftk "$PDF_FILE" cat 16-16 output "$OUTPUT_DIR/03_changes.pdf"

echo "Extracting '1 Introduction to Java in Oracle Database' (physical pages 17-41)"
pdftk "$PDF_FILE" cat 17-41 output "$OUTPUT_DIR/04_ch01_introduction-to-java-in-oracle-database.pdf"

echo "Extracting '2 Java Applications on Oracle Database' (physical pages 42-102)"
pdftk "$PDF_FILE" cat 42-102 output "$OUTPUT_DIR/05_ch02_java-applications-on-oracle-database.pdf"

echo "Extracting '3 Calling Java Methods in Oracle Database' (physical pages 103-116)"
pdftk "$PDF_FILE" cat 103-116 output "$OUTPUT_DIR/06_ch03_calling-java-methods-in-oracle-database.pdf"

echo "Extracting '4 Java Installation and Configuration' (physical pages 117-121)"
pdftk "$PDF_FILE" cat 117-121 output "$OUTPUT_DIR/07_ch04_java-installation-and-configuration.pdf"

echo "Extracting '5 Developing Java Stored Procedures' (physical pages 122-131)"
pdftk "$PDF_FILE" cat 122-131 output "$OUTPUT_DIR/08_ch05_developing-java-stored-procedures.pdf"

echo "Extracting '6 Publishing Java Classes With Call Specifications' (physical pages 132-151)"
pdftk "$PDF_FILE" cat 132-151 output "$OUTPUT_DIR/09_ch06_publishing-java-classes-with-call-specifications.pdf"

echo "Extracting '7 Calling Stored Procedures' (physical pages 152-161)"
pdftk "$PDF_FILE" cat 152-161 output "$OUTPUT_DIR/10_ch07_calling-stored-procedures.pdf"

echo "Extracting '8 Java Stored Procedures Application Example' (physical pages 162-171)"
pdftk "$PDF_FILE" cat 162-171 output "$OUTPUT_DIR/11_ch08_java-stored-procedures-application-example.pdf"

echo "Extracting '9 Oracle Database Java Application Performance' (physical pages 172-180)"
pdftk "$PDF_FILE" cat 172-180 output "$OUTPUT_DIR/12_ch09_oracle-database-java-application-performance.pdf"

echo "Extracting '10 Security for Oracle Database Java Applications' (physical pages 181-208)"
pdftk "$PDF_FILE" cat 181-208 output "$OUTPUT_DIR/13_ch10_security-for-oracle-database-java-applications.pdf"

echo "Extracting '11 Native Oracle JVM Support for JNDI' (physical pages 209-223)"
pdftk "$PDF_FILE" cat 209-223 output "$OUTPUT_DIR/14_ch11_native-oracle-jvm-support-for-jndi.pdf"

echo "Extracting '12 Schema Objects and Oracle JVM Utilities' (physical pages 224-252)"
pdftk "$PDF_FILE" cat 224-252 output "$OUTPUT_DIR/15_ch12_schema-objects-and-oracle-jvm-utilities.pdf"

echo "Extracting '13 Database Web Services' (physical pages 253-260)"
pdftk "$PDF_FILE" cat 253-260 output "$OUTPUT_DIR/16_ch13_database-web-services.pdf"

echo "Extracting 'A DBMS_JAVA Package' (physical pages 261-282)"
pdftk "$PDF_FILE" cat 261-282 output "$OUTPUT_DIR/17_app_a_dbms_java_package.pdf"

echo "Extracting 'B Classpath Extensions and User Classloaded Metadata' (physical pages 283-285)"
pdftk "$PDF_FILE" cat 283-285 output "$OUTPUT_DIR/18_app_b_classpath_extensions_and_user_classloaded_metadata.pdf"

echo "Extracting 'Index' (physical pages 286-291)"
pdftk "$PDF_FILE" cat 286-291 output "$OUTPUT_DIR/19_index.pdf"

