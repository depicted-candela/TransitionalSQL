-- =============================================================================
-- DATASET DEFINITION AND POPULATION
-- =============================================================================

-- Drop existing tables to start fresh (Oracle does not support IF EXISTS in DROP statements)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.orderItems';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.orders';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.employees';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.departments';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.products';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.appSettings';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.customerLog';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.nestedData';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.varrayData';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.recordData';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.dynamicDataTarget';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlmastery.ptfSourceData';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- Sequences for primary keys
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlmastery.employees_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlmastery.orders_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlmastery.products_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE customerlog_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE nesteddata_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE varraydata_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE recorddata_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE dynamicdatatarget_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE ptfsourcedata_seq';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/


-- Departments table
CREATE TABLE plsqlmastery.departments (
    departmentId NUMBER(4) PRIMARY KEY,
    departmentName VARCHAR2(30) NOT NULL UNIQUE,
    location VARCHAR2(20)
);

-- Employees table (simplified HR schema)
CREATE TABLE plsqlmastery.employees (
    employeeId NUMBER(6) PRIMARY KEY,
    firstName VARCHAR2(20),
    lastName VARCHAR2(25) NOT NULL,
    email VARCHAR2(25) NOT NULL UNIQUE,
    phoneNumber VARCHAR2(20),
    hireDate DATE NOT NULL,
    jobId VARCHAR2(10),
    salary NUMBER(8,2),
    commissionPct NUMBER(2,2),
    managerId NUMBER(6),
    departmentId NUMBER(4) REFERENCES plsqlmastery.departments(departmentId)
);

-- Products table
CREATE TABLE plsqlmastery.products (
    productId NUMBER(6) PRIMARY KEY,
    productName VARCHAR2(50) NOT NULL UNIQUE,
    category VARCHAR2(20),
    price NUMBER(10,2) NOT NULL,
    stockQuantity NUMBER(6)
);

-- Orders table
CREATE TABLE plsqlmastery.orders (
    orderId NUMBER(6) PRIMARY KEY,
    customerId NUMBER(6), -- simplified customer ID (not linked to plsqlmastery.employees)
    orderDate DATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'Pending',
    totalAmount NUMBER(10,2) DEFAULT 0
);

-- Order Items table
CREATE TABLE plsqlmastery.orderItems (
    orderItemId NUMBER(10) PRIMARY KEY, -- using sequence, not composite key
    orderId NUMBER(6) REFERENCES plsqlmastery.orders(orderId),
    productId NUMBER(6) REFERENCES plsqlmastery.products(productId),
    quantity NUMBER(6) NOT NULL,
    unitPrice NUMBER(10,2) NOT NULL,
    itemAmount NUMBER(10,2) GENERATED ALWAYS AS (quantity * unitPrice) VIRTUAL -- Virtual column
);

-- Application Settings table (for dynamic DDL/DML examples)
CREATE TABLE plsqlmastery.appSettings (
    settingName VARCHAR2(50) PRIMARY KEY,
    settingValue VARCHAR2(255)
);

-- Customer Log table (for dynamic SQL examples, especially injection)
CREATE TABLE plsqlmastery.customerLog (
    logId NUMBER(10) PRIMARY KEY,
    logTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    customerName VARCHAR2(100),
    actionDetails VARCHAR2(4000)
);

-- Tables for Collections & Records
-- Nested Table type definition
CREATE OR REPLACE TYPE nestedIntegerList IS TABLE OF NUMBER;
/

-- Varray type definition
CREATE OR REPLACE TYPE varrayStringList IS VARRAY(10) OF VARCHAR2(50);
/

-- Record type definition (simplified)
CREATE OR REPLACE TYPE productInfoRec IS OBJECT (
    pId NUMBER,
    pName VARCHAR2(50),
    pPrice NUMBER(10,2)
);
/
-- Nested Table using the Record Type
CREATE OR REPLACE TYPE productInfoList IS TABLE OF productInfoRec;
/

-- Tables using collection types
CREATE TABLE plsqlmastery.nestedData (
    id NUMBER PRIMARY KEY,
    dataList nestedIntegerList
) NESTED TABLE dataList STORE AS plsqlmastery.nestedData_nt;

CREATE TABLE plsqlmastery.varrayData (
    id NUMBER PRIMARY KEY,
    dataArray varrayStringList
);

-- Table for Record type examples
CREATE TABLE plsqlmastery.recordData (
    id NUMBER PRIMARY KEY,
    info productInfoRec -- Column of a user-defined object type
);


-- Dynamic Data Target table (for dynamic DML/SELECT output)
CREATE TABLE plsqlmastery.dynamicDataTarget (
    id NUMBER PRIMARY KEY,
    stringValue VARCHAR2(100),
    numericValue NUMBER,
    dateValue DATE
);

-- Table for PTF Source Data
CREATE TABLE plsqlmastery.ptfSourceData (
    sourceId NUMBER PRIMARY KEY,
    sourceCategory VARCHAR2(20),
    sourceValue NUMBER,
    sourceDate DATE
);

-- Populate Tables

-- Departments
INSERT INTO plsqlmastery.departments VALUES (10, 'Administration', 'New York');
INSERT INTO plsqlmastery.departments VALUES (20, 'Marketing', 'California');
INSERT INTO plsqlmastery.departments VALUES (30, 'Purchasing', 'Washington');
INSERT INTO plsqlmastery.departments VALUES (40, 'Human Resources', 'Arizona');

-- Employees
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'John', 'Smith', 'jsmith@example.com', '555-1234', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 'MANAGER', 70000, NULL, NULL, 10);
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'Jane', 'Doe', 'jdoe@example.com', '555-5678', TO_DATE('2021-03-10', 'YYYY-MM-DD'), 'ANALYST', 60000, NULL, 1000, 10);
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'Peter', 'Jones', 'pjones@example.com', '555-8765', TO_DATE('2019-07-01', 'YYYY-MM-DD'), 'SALESREP', 55000, 0.1, 1000, 20);
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'Mary', 'Williams', 'mwilliams@example.com', '555-4321', TO_DATE('2022-05-20', 'YYYY-MM-DD'), 'CLERK', 40000, NULL, 1001, 20);
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'David', 'Brown', 'dbrown@example.com', '555-0987', TO_DATE('2018-11-11', 'YYYY-MM-DD'), 'MANAGER', 80000, NULL, NULL, 30);
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'Sarah', 'Davis', 'sdavis@example.com', '555-1122', TO_DATE('2023-02-28', 'YYYY-MM-DD'), 'ANALYST', 65000, NULL, 1004, 30);
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'Michael', 'Garcia', 'mgarcia@example.com', '555-3344', TO_DATE('2020-09-01', 'YYYY-MM-DD'), 'SALESREP', 58000, 0.15, 1004, 20);
INSERT INTO plsqlmastery.employees VALUES (employees_seq.NEXTVAL, 'Emily', 'Rodriguez', 'erodriguez@example.com', '555-5566', TO_DATE('2021-07-18', 'YYYY-MM-DD'), 'CLERK', 42000, NULL, 1005, 40);

-- Products
INSERT INTO plsqlmastery.products VALUES (products_seq.NEXTVAL, 'Laptop 15"', 'Electronics', 1200.00, 50);
INSERT INTO plsqlmastery.products VALUES (products_seq.NEXTVAL, 'Keyboard', 'Accessories', 75.00, 200);
INSERT INTO plsqlmastery.products VALUES (products_seq.NEXTVAL, 'Mouse', 'Accessories', 25.00, 300);
INSERT INTO plsqlmastery.products VALUES (products_seq.NEXTVAL, 'Monitor 27"', 'Electronics', 300.00, 80);
INSERT INTO plsqlmastery.products VALUES (products_seq.NEXTVAL, 'Webcam', 'Accessories', 50.00, 150);
INSERT INTO plsqlmastery.products VALUES (products_seq.NEXTVAL, 'Desk Chair', 'Office Furniture', 150.00, 30);
INSERT INTO plsqlmastery.products VALUES (products_seq.NEXTVAL, 'Notebook', 'Supplies', 5.00, 500);

-- Orders (simplified customer IDs)
INSERT INTO plsqlmastery.orders VALUES (orders_seq.NEXTVAL, 1, SYSDATE - 30, 'Shipped', 0); -- Will update total later
INSERT INTO plsqlmastery.orders VALUES (orders_seq.NEXTVAL, 2, SYSDATE - 20, 'Pending', 0);
INSERT INTO plsqlmastery.orders VALUES (orders_seq.NEXTVAL, 1, SYSDATE - 10, 'Processing', 0);
INSERT INTO plsqlmastery.orders VALUES (orders_seq.NEXTVAL, 3, SYSDATE - 5, 'Pending', 0);
INSERT INTO plsqlmastery.orders VALUES (orders_seq.NEXTVAL, 2, SYSDATE - 2, 'Pending', 0);

-- Order Items
-- Order 2000
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2000, 3000, 1, 1200.00);
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2000, 3001, 1, 75.00);
-- Order 2001
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2001, 3003, 2, 300.00);
-- Order 2002
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2002, 3000, 1, 1200.00);
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2002, 3001, 2, 75.00);
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2002, 3002, 1, 25.00);
-- Order 2003
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2003, 3006, 10, 5.00);
-- Order 2004
INSERT INTO plsqlmastery.orderItems VALUES (orderItems_seq.NEXTVAL, 2004, 3004, 1, 50.00);

-- Update order totals based on order items (manual for simplicity here)
UPDATE plsqlmastery.orders SET totalAmount = (SELECT SUM(itemAmount) FROM plsqlmastery.orderItems WHERE orderId = 2000) WHERE orderId = 2000;
UPDATE plsqlmastery.orders SET totalAmount = (SELECT SUM(itemAmount) FROM plsqlmastery.orderItems WHERE orderId = 2001) WHERE orderId = 2001;
UPDATE plsqlmastery.orders SET totalAmount = (SELECT SUM(itemAmount) FROM plsqlmastery.orderItems WHERE orderId = 2002) WHERE orderId = 2002;
UPDATE plsqlmastery.orders SET totalAmount = (SELECT SUM(itemAmount) FROM plsqlmastery.orderItems WHERE orderId = 2003) WHERE orderId = 2003;
UPDATE plsqlmastery.orders SET totalAmount = (SELECT SUM(itemAmount) FROM plsqlmastery.orderItems WHERE orderId = 2004) WHERE orderId = 2004;


-- App Settings (example)
INSERT INTO plsqlmastery.appSettings VALUES ('minimumStockForReorder', '50');

-- Customer Log (example entries for injection scenarios)
INSERT INTO plsqlmastery.customerLog VALUES (customerLog_seq.NEXTVAL, SYSTIMESTAMP, 'Alice', 'Logged in from IP 192.168.1.100');
INSERT INTO plsqlmastery.customerLog VALUES (customerLog_seq.NEXTVAL, SYSTIMESTAMP, 'Bob', 'Viewed order 2001');


-- Populate Nested/Varray/Record Data tables with some initial values
INSERT INTO plsqlmastery.nestedData VALUES (nestedData_seq.NEXTVAL, nestedIntegerList(10, 20, 30, 40, 50));
INSERT INTO plsqlmastery.nestedData VALUES (nestedData_seq.NEXTVAL, nestedIntegerList(1, 3, 5, 7, 9));
INSERT INTO plsqlmastery.nestedData VALUES (nestedData_seq.NEXTVAL, NULL); -- Example null collection

INSERT INTO plsqlmastery.varrayData VALUES (varrayData_seq.NEXTVAL, varrayStringList('Apple', 'Banana', 'Cherry'));
INSERT INTO plsqlmastery.varrayData VALUES (varrayData_seq.NEXTVAL, varrayStringList('Red', 'Green', 'Blue', 'Yellow'));
INSERT INTO plsqlmastery.varrayData VALUES (varrayData_seq.NEXTVAL, varrayStringList()); -- Example empty varray
INSERT INTO plsqlmastery.varrayData VALUES (varrayData_seq.NEXTVAL, NULL); -- Example null varray

INSERT INTO plsqlmastery.recordData VALUES (recordData_seq.NEXTVAL, productInfoRec(3000, 'Laptop 15"', 1200.00));
INSERT INTO plsqlmastery.recordData VALUES (recordData_seq.NEXTVAL, productInfoRec(3006, 'Notebook', 5.00));
INSERT INTO plsqlmastery.recordData VALUES (recordData_seq.NEXTVAL, NULL); -- Example null object column


-- Populate PTF Source Data
INSERT INTO plsqlmastery.ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'A', 100, SYSDATE - 10);
INSERT INTO plsqlmastery.ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'A', 150, SYSDATE - 5);
INSERT INTO plsqlmastery.ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'B', 200, SYSDATE - 8);
INSERT INTO plsqlmastery.ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'C', 50, SYSDATE - 15);
INSERT INTO plsqlmastery.ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'A', 120, SYSDATE - 3);
INSERT INTO plsqlmastery.ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'B', 220, SYSDATE - 2);

COMMIT;

-- Enable DBMS_OUTPUT for results
SET SERVEROUTPUT ON SIZE UNLIMITED;