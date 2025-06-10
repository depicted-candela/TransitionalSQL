#!/bin/bash

# Script for database-transactional-event-queues-and-advanced-queuing-users-guide
# Extracts key features from database-transactional-event-queues-and-advanced-queuing-users-guide.pdf into separate PDF files.

PDF_FILE="/home/dc/Devs/sql/TransitionalSQL/books/additional/database-transactional-event-queues-and-advanced-queuing-users-guide/database-transactional-event-queues-and-advanced-queuing-users-guide.pdf"
OUTPUT_DIR="/home/dc/Devs/sql/TransitionalSQL/books/additional/database-transactional-event-queues-and-advanced-queuing-users-guide/extracted_features"

echo "Processing $PDF_FILE"
mkdir -p "$OUTPUT_DIR"

# Clean up previous extractions
rm -f "$OUTPUT_DIR"/*.pdf

echo "Extracting 'Contents' (physical pages 3-19)"
pdftk "$PDF_FILE" cat 3-19 output "$OUTPUT_DIR/00_contents.pdf"

echo "Extracting 'List of Examples' (physical pages 20-26)"
pdftk "$PDF_FILE" cat 20-26 output "$OUTPUT_DIR/01_list_of_examples.pdf"

echo "Extracting 'List of Figures' (physical pages 27-27)"
pdftk "$PDF_FILE" cat 27-27 output "$OUTPUT_DIR/02_list_of_figures.pdf"

echo "Extracting 'List of Tables' (physical pages 28-29)"
pdftk "$PDF_FILE" cat 28-29 output "$OUTPUT_DIR/03_list_of_tables.pdf"

echo "Extracting 'Preface' (physical pages 30-31)"
pdftk "$PDF_FILE" cat 30-31 output "$OUTPUT_DIR/04_preface.pdf"

echo "Extracting 'Changes in This Release for Oracle Database Advanced Queuing User's Guide' (physical pages 32-39)"
pdftk "$PDF_FILE" cat 32-39 output "$OUTPUT_DIR/05_changes.pdf"

echo "Extracting '1 Introduction to Transactional Event Queues and Advanced Queuing' (physical pages 40-81)"
pdftk "$PDF_FILE" cat 40-81 output "$OUTPUT_DIR/06_ch01_introduction-to-transactional-event-queues-and-advanced-queuing.pdf"

echo "Extracting '2 Basic Components of Oracle Transactional Event Queues and Advanced Queuing' (physical pages 82-90)"
pdftk "$PDF_FILE" cat 82-90 output "$OUTPUT_DIR/07_ch02_basic-components-of-oracle-transactional-event-queues-and-advanced-queuing.pdf"

echo "Extracting '3 Oracle Transactional Event Queues and Advanced Queuing: Programmatic Interfaces' (physical pages 91-107)"
pdftk "$PDF_FILE" cat 91-107 output "$OUTPUT_DIR/08_ch03_oracle-transactional-event-queues-and-advanced-queuing-programmatic-interfaces.pdf"

echo "Extracting '4 Managing Oracle Transactional Event Queues and Advanced Queuing' (physical pages 108-120)"
pdftk "$PDF_FILE" cat 108-120 output "$OUTPUT_DIR/09_ch04_managing-oracle-transactional-event-queues-and-advanced-queuing.pdf"

echo "Extracting '5 Kafka APIs for Oracle Transactional Event Queues' (physical pages 121-136)"
pdftk "$PDF_FILE" cat 121-136 output "$OUTPUT_DIR/10_ch05_kafka-apis-for-oracle-transactional-event-queues.pdf"

echo "Extracting '6 Java Message Service for Transactional Event Queues and Advanced Queuing' (physical pages 137-269)"
pdftk "$PDF_FILE" cat 137-269 output "$OUTPUT_DIR/11_ch06_java-message-service-for-transactional-event-queues-and-advanced-queuing.pdf"

echo "Extracting '7 Oracle Database Advanced Queuing Operations Using PL/SQL' (physical pages 270-294)"
pdftk "$PDF_FILE" cat 270-294 output "$OUTPUT_DIR/12_ch07_oracle-database-advanced-queuing-operations-using-plsql.pdf"

echo "Extracting '8 Oracle Transactional Event Queues and Advanced Queuing Performance and Scalability' (physical pages 295-322)"
pdftk "$PDF_FILE" cat 295-322 output "$OUTPUT_DIR/13_ch08_oracle-transactional-event-queues-and-advanced-queuing-performance-and-scalability.pdf"

echo "Extracting '9 Oracle Transactional Event Queue and Advanced Queuing Views' (physical pages 323-345)"
pdftk "$PDF_FILE" cat 323-345 output "$OUTPUT_DIR/14_ch09_oracle-transactional-event-queue-and-advanced-queuing-views.pdf"

echo "Extracting '10 Troubleshooting Oracle Database Advanced Queuing' (physical pages 346-348)"
pdftk "$PDF_FILE" cat 346-348 output "$OUTPUT_DIR/15_ch10_troubleshooting-oracle-database-advanced-queuing.pdf"

echo "Extracting '11 Internet Access to Oracle Database Advanced Queuing' (physical pages 349-363)"
pdftk "$PDF_FILE" cat 349-363 output "$OUTPUT_DIR/16_ch11_internet-access-to-oracle-database-advanced-queuing.pdf"

echo "Extracting '12 Oracle Database Advanced Queuing Administrative Interface' (physical pages 364-396)"
pdftk "$PDF_FILE" cat 364-396 output "$OUTPUT_DIR/17_ch12_oracle-database-advanced-queuing-administrative-interface.pdf"

echo "Extracting 'A Nonpersistent Queues' (physical pages 397-399)"
pdftk "$PDF_FILE" cat 397-399 output "$OUTPUT_DIR/18_app_a_nonpersistent_queues.pdf"

echo "Extracting 'B Oracle JMS and Oracle AQ XML Servlet Error Messages' (physical pages 400-417)"
pdftk "$PDF_FILE" cat 400-417 output "$OUTPUT_DIR/19_app_b_oracle_jms_and_oracle_aq_xml_servlet_error_messages.pdf"

echo "Extracting 'C Oracle Messaging Gateway' (physical pages 418-500)"
pdftk "$PDF_FILE" cat 418-500 output "$OUTPUT_DIR/20_app_c_oracle_messaging_gateway.pdf"

echo "Extracting 'D Advanced Queuing Sharded Queues' (physical pages 501-505)"
pdftk "$PDF_FILE" cat 501-505 output "$OUTPUT_DIR/21_app_d_advanced_queuing_sharded_queues.pdf"

echo "Extracting 'Glossary' (physical pages 506-516)"
pdftk "$PDF_FILE" cat 506-516 output "$OUTPUT_DIR/22_glossary.pdf"

echo "Extracting 'Index' (physical pages 517-536)"
pdftk "$PDF_FILE" cat 517-536 output "$OUTPUT_DIR/23_index.pdf"

