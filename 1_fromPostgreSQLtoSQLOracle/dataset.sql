GRANT CONNECT, RESOURCE TO basic_oracle_uniqueness;
GRANT ALTER SESSION TO basic_oracle_uniqueness;
ALTER USER basic_oracle_uniqueness QUOTA UNLIMITED ON USERS;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE basic_oracle_uniqueness.ProductSales';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE basic_oracle_uniqueness.ProductCatalog';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE basic_oracle_uniqueness.EmployeeRoster';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- Table for demonstrating various data types, NULLs, and for ROWNUM
CREATE TABLE basic_oracle_uniqueness.EmployeeRoster (
    employeeId NUMBER(6) PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50),
    email VARCHAR2(100) UNIQUE,
    phoneNumber VARCHAR2(20),
    hireDate DATE,
    jobTitle VARCHAR2(50),
    salary NUMBER(10, 2),
    commissionRate NUMBER(4, 2),
    managerId NUMBER(6),
    departmentName VARCHAR2(50),
    bio NVARCHAR2(100)
);

-- Table for DUAL, DECODE/CASE, and different timestamp types
CREATE TABLE basic_oracle_uniqueness.ProductCatalog (
    productId NUMBER(5) PRIMARY KEY,
    productName VARCHAR2(100),
    productCategory VARCHAR2(50),
    unitPrice NUMBER(8, 2),
    supplierInfo NVARCHAR2(100),
    lastStockCheck TIMESTAMP(3),
    nextShipmentDue TIMESTAMP(0) WITH TIME ZONE,
    localEntryTime TIMESTAMP WITH LOCAL TIME ZONE,
    notes VARCHAR2(100)
);

-- A smaller table to illustrate ROWNUM behavior more clearly with ORDER BY
CREATE TABLE basic_oracle_uniqueness.ProductSales (
    saleId NUMBER PRIMARY KEY,
    productSold VARCHAR2(50),
    saleAmount NUMBER(10,2),
    saleDate DATE
);

/*
This is a multi-line comment.
These tables are designed for the Oracle SQL transitional course.
The basic_oracle_uniqueness.EmployeeRoster table includes an NVARCHAR2 column 'bio' to store
employee biographies, potentially in multiple languages.
The basic_oracle_uniqueness.ProductCatalog table uses various TIMESTAMP types to track product-related timings.
*/

-- Populate basic_oracle_uniqueness.EmployeeRoster
INSERT INTO basic_oracle_uniqueness.EmployeeRoster (employeeId, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionRate, managerId, departmentName, bio)
VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', TO_DATE('2003-06-17', 'YYYY-MM-DD'), 'President', 24000, NULL, NULL, 'Executive', N'Oversees all operations. スティーブン');
INSERT INTO basic_oracle_uniqueness.EmployeeRoster (employeeId, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionRate, managerId, departmentName, bio)
VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('2005-09-21', 'YYYY-MM-DD'), 'Administration VP', 17000, NULL, 100, 'Administration', N'Manages admin staff.');
INSERT INTO basic_oracle_uniqueness.EmployeeRoster (employeeId, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionRate, managerId, departmentName, bio)
VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('2001-01-13', 'YYYY-MM-DD'), 'Administration VP', 17000, 0.15, 100, 'Administration', N'Also an Admin VP. レックス');
INSERT INTO basic_oracle_uniqueness.EmployeeRoster (employeeId, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionRate, managerId, departmentName, bio)
VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('2006-01-03', 'YYYY-MM-DD'), 'Programmer', 9000, 0.10, 102, 'IT', N'Develops software. αλέξανδρος');
INSERT INTO basic_oracle_uniqueness.EmployeeRoster (employeeId, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionRate, managerId, departmentName, bio)
VALUES (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', TO_DATE('2007-05-21', 'YYYY-MM-DD'), 'Programmer', 6000, 0.10, 103, 'IT', NULL);
INSERT INTO basic_oracle_uniqueness.EmployeeRoster (employeeId, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionRate, managerId, departmentName, bio)
VALUES (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', TO_DATE('2007-02-07', 'YYYY-MM-DD'), 'Finance Manager', 12000, 0.20, 101, 'Finance', N'Financial planning.');
INSERT INTO basic_oracle_uniqueness.EmployeeRoster (employeeId, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionRate, managerId, departmentName, bio)
VALUES (114, 'Den', 'Raphaely', 'DRAPHEALY', '515.127.4561', TO_DATE('2002-12-07', 'YYYY-MM-DD'), 'Purchasing Manager', 11000, NULL, 100, 'Purchasing', N'Procurement.');

-- Populate basic_oracle_uniqueness.ProductCatalog
-- Setting session time zone for predictable TIMESTAMP WITH LOCAL TIME ZONE insertion for demo
-- The user basicOracleUniqueness needs 'ALTER SESSION' privilege for this.
ALTER SESSION SET TIME_ZONE = 'America/New_York';

INSERT INTO basic_oracle_uniqueness.ProductCatalog (productId, productName, productCategory, unitPrice, supplierInfo, lastStockCheck, nextShipmentDue, localEntryTime, notes)
VALUES (1, 'Oracle Database 19c', 'Software', 5000, N'Oracle Corp. USA', TIMESTAMP '2023-10-01 10:00:00.123', TIMESTAMP '2023-11-15 09:00:00 -05:00', SYSTIMESTAMP, 'Enterprise Edition');
INSERT INTO basic_oracle_uniqueness.ProductCatalog (productId, productName, productCategory, unitPrice, supplierInfo, lastStockCheck, nextShipmentDue, localEntryTime, notes)
VALUES (2, 'PostgreSQL 15', 'Software', 0, N'PG Global Dev Group', TIMESTAMP '2023-10-05 11:30:00.456', TIMESTAMP '2023-10-20 14:00:00 +02:00', SYSTIMESTAMP - INTERVAL '1' DAY, NULL);
INSERT INTO basic_oracle_uniqueness.ProductCatalog (productId, productName, productCategory, unitPrice, supplierInfo, lastStockCheck, nextShipmentDue, localEntryTime, notes)
VALUES (3, 'SQL Developer Tool', 'Utility', 100, N'DevTools Inc. (Canada)', TIMESTAMP '2023-09-20 15:00:00.789', NULL, SYSTIMESTAMP - INTERVAL '2' DAY, 'Cross-RDBMS');
INSERT INTO basic_oracle_uniqueness.ProductCatalog (productId, productName, productCategory, unitPrice, supplierInfo, lastStockCheck, nextShipmentDue, localEntryTime, notes)
VALUES (4, 'Advanced Java Book', 'Book', 75, N'Tech Books GmbH (Germany) - Bücher', TIMESTAMP '2023-10-10 08:00:00.000', FROM_TZ(TIMESTAMP '2023-11-01 10:00:00.000', 'UTC'), SYSTIMESTAMP - INTERVAL '3' DAY, 'Includes Oracle examples');
INSERT INTO basic_oracle_uniqueness.ProductCatalog (productId, productName, productCategory, unitPrice, supplierInfo, lastStockCheck, nextShipmentDue, localEntryTime, notes)
VALUES (5, 'Unicode Keyboard', 'Hardware', 50, N' 全球配件 (Global Accessories)', TIMESTAMP '2023-10-12 16:45:00.999', NULL, SYSTIMESTAMP - INTERVAL '4' DAY, 'Supports various languages');

-- Populate basic_oracle_uniqueness.ProductSales
INSERT INTO basic_oracle_uniqueness.ProductSales (saleId, productSold, saleAmount, saleDate) VALUES (1, 'Product A', 100.50, TO_DATE('2023-01-15', 'YYYY-MM-DD'));
INSERT INTO basic_oracle_uniqueness.ProductSales (saleId, productSold, saleAmount, saleDate) VALUES (2, 'Product B', 250.00, TO_DATE('2023-01-10', 'YYYY-MM-DD'));
INSERT INTO basic_oracle_uniqueness.ProductSales (saleId, productSold, saleAmount, saleDate) VALUES (3, 'Product C', 75.25, TO_DATE('2023-02-01', 'YYYY-MM-DD'));
INSERT INTO basic_oracle_uniqueness.ProductSales (saleId, productSold, saleAmount, saleDate) VALUES (4, 'Product A', 100.50, TO_DATE('2023-02-05', 'YYYY-MM-DD'));
INSERT INTO basic_oracle_uniqueness.ProductSales (saleId, productSold, saleAmount, saleDate) VALUES (5, 'Product D', 500.00, TO_DATE('2023-02-10', 'YYYY-MM-DD'));

COMMIT;