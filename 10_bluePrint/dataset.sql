-- Connect as a privileged user (e.g., SYS as SYSDBA) to run this script.
-- Drop users if they exist, to ensure a clean setup
BEGIN
   EXECUTE IMMEDIATE 'DROP USER blueprint CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN RAISE;
        END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP USER anotherSchema CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN RAISE;
        END IF;
END;
/
-- Create the primary user for our exercises
CREATE USER blueprint IDENTIFIED BY Pa_s_sw_rd_1;
ALTER USER blueprint QUOTA UNLIMITED ON users;
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM, UNLIMITED TABLESPACE TO blueprint;
-- Create a second user for demonstrating cross-schema concepts
CREATE USER anotherSchema IDENTIFIED BY Pa_s_sw_rd_2;
ALTER USER anotherSchema QUOTA UNLIMITED ON users;
GRANT CONNECT, RESOURCE TO anotherSchema;
-- Grant DBA privileges to blueprint to query DBA views and manage transactions.
-- In a real-world scenario, you would grant more granular privileges.
GRANT DBA TO blueprint;
-- Connect as the blueprint user to create the objects
CONNECT blueprint/Pa_s_sw_rd_1;
-- Sequences for Primary Keys
CREATE SEQUENCE productSeq START WITH 100 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE warehouseSeq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE inventoryLogSeq START WITH 1 INCREMENT BY 1 NOCACHE;
-- Tables
CREATE TABLE products (
    productId          NUMBER(10) PRIMARY KEY,
    productName        VARCHAR2(100) NOT NULL,
    description        VARCHAR2(500),
    category           VARCHAR2(50),
    unitPrice          NUMBER(8, 2) CHECK (unitPrice > 0)
);
CREATE TABLE warehouses (
    warehouseId        NUMBER(5) PRIMARY KEY,
    warehouseName      VARCHAR2(100) UNIQUE NOT NULL,
    location           VARCHAR2(200)
);
-- This table is central for concurrency and transaction exercises
CREATE TABLE inventory (
    warehouseId        NUMBER(5) NOT NULL,
    productId          NUMBER(10) NOT NULL,
    quantityOnHand     NUMBER(8) DEFAULT 0 NOT NULL,
    lastUpdated        TIMESTAMP WITH LOCAL TIME ZONE DEFAULT SYSTIMESTAMP,
    CONSTRAINT pkInventory PRIMARY KEY (warehouseId, productId),
    CONSTRAINT fkInvWarehouse FOREIGN KEY (warehouseId) REFERENCES warehouses(warehouseId),
    CONSTRAINT fkInvProduct FOREIGN KEY (productId) REFERENCES products(productId)
);
CREATE TABLE inventoryLog (
    logId              NUMBER PRIMARY KEY,
    productId          NUMBER(10),
    changeType         VARCHAR2(20),
    quantityChange     NUMBER(8),
    logTimestamp       DATE
);
-- Populate with data
INSERT INTO warehouses (warehouseId, warehouseName, location) VALUES (warehouseSeq.NEXTVAL, 'Main Warehouse', 'New York');
INSERT INTO warehouses (warehouseId, warehouseName, location) VALUES (warehouseSeq.NEXTVAL, 'West Coast Depot', 'Los Angeles');
INSERT INTO products (productId, productName, description, category, unitPrice) VALUES (productSeq.NEXTVAL, 'Oracle DB License', '1-year enterprise license', 'Software', 4500.00);
INSERT INTO products (productId, productName, description, category, unitPrice) VALUES (productSeq.NEXTVAL, 'PL/SQL Stored Procedure Guide', 'Advanced PL/SQL programming book', 'Books', 75.50);
INSERT INTO products (productId, productName, description, category, unitPrice) VALUES (productSeq.NEXTVAL, 'High-Performance Keyboard', 'Mechanical keyboard for developers', 'Hardware', 150.00);
INSERT INTO inventory (warehouseId, productId, quantityOnHand) VALUES (1, 100, 50);
INSERT INTO inventory (warehouseId, productId, quantityOnHand) VALUES (1, 101, 200);
INSERT INTO inventory (warehouseId, productId, quantityOnHand) VALUES (2, 102, 150);
-- Create objects in the second schema for synonym/privilege examples
CONNECT anotherSchema/Pa_s_sw_rd_2;
CREATE TABLE confidentialData (
    dataId             NUMBER PRIMARY KEY,
    secretInfo         VARCHAR2(100)
);
INSERT INTO confidentialData (dataId, secretInfo) VALUES (1, 'Project Phoenix Details');
GRANT SELECT ON confidentialData TO blueprint;
-- Switch back to the main user
CONNECT blueprint/Pa_s_sw_rd_1;
COMMIT;
-- Create a procedure for a Data Dictionary example
CREATE OR REPLACE PROCEDURE getProductCount(p_category IN VARCHAR2, p_count OUT NUMBER) IS
BEGIN
    SELECT COUNT(*)
    INTO p_count
    FROM products
    WHERE category = p_category;
END;
/