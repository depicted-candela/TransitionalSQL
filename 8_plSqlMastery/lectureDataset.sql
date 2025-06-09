-- Minimalist Dataset for Lecture Examples
-- Only includes tables/columns needed for direct lecture examples

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureDepartments';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureEmployees';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureProducts';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureCustomerLog';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureNestedData';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureVarrayData';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureRecordData';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE  plsqlmastery_lecture.lectureDynamicTarget';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE  plsqlmastery_lecture.lectureEmployeesSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE  plsqlmastery_lecture.lectureProductsSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE  plsqlmastery_lecture.lectureCustomerLogSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE  plsqlmastery_lecture.lectureNestedDataSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE  plsqlmastery_lecture.lectureVarrayDataSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE  plsqlmastery_lecture.lectureRecordDataSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE  plsqlmastery_lecture.lectureDynamicTargetSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/

CREATE SEQUENCE  plsqlmastery_lecture.lectureEmployeesSeq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE  plsqlmastery_lecture.lectureProductsSeq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE  plsqlmastery_lecture.lectureCustomerLogSeq START WITH 2000 INCREMENT BY 1;
CREATE SEQUENCE  plsqlmastery_lecture.lectureNestedDataSeq START WITH 3000 INCREMENT BY 1;
CREATE SEQUENCE  plsqlmastery_lecture.lectureVarrayDataSeq START WITH 4000 INCREMENT BY 1;
CREATE SEQUENCE  plsqlmastery_lecture.lectureRecordDataSeq START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE  plsqlmastery_lecture.lectureDynamicTargetSeq START WITH 6000 INCREMENT BY 1;


CREATE TABLE  plsqlmastery_lecture.lectureDepartments ( departmentId NUMBER PRIMARY KEY, departmentName VARCHAR2(30) );
INSERT INTO  plsqlmastery_lecture.lectureDepartments VALUES (10, 'IT');
INSERT INTO  plsqlmastery_lecture.lectureDepartments VALUES (20, 'Sales');
COMMIT;

CREATE TABLE  plsqlmastery_lecture.lectureEmployees ( employeeId NUMBER PRIMARY KEY, lastName VARCHAR2(25), salary NUMBER(8,2), departmentId NUMBER REFERENCES  plsqlmastery_lecture.lectureDepartments(departmentId));
INSERT INTO  plsqlmastery_lecture.lectureEmployees VALUES ( plsqlmastery_lecture.lectureEmployeesSeq.NEXTVAL, 'King', 24000, 10);
INSERT INTO  plsqlmastery_lecture.lectureEmployees VALUES ( plsqlmastery_lecture.lectureEmployeesSeq.NEXTVAL, 'Khoo', 3100, 20);
INSERT INTO  plsqlmastery_lecture.lectureEmployees VALUES ( plsqlmastery_lecture.lectureEmployeesSeq.NEXTVAL, 'Kochhar', 17000, 10);
INSERT INTO  plsqlmastery_lecture.lectureEmployees VALUES ( plsqlmastery_lecture.lectureEmployeesSeq.NEXTVAL, 'Raphaely', 11000, 20);
COMMIT;


CREATE TABLE  plsqlmastery_lecture.lectureProducts ( productId NUMBER PRIMARY KEY, productName VARCHAR2(50), price NUMBER(10,2), stockQuantity NUMBER );
INSERT INTO  plsqlmastery_lecture.lectureProducts VALUES ( plsqlmastery_lecture.lectureProductsSeq.NEXTVAL, 'Laptop', 1200.00, 50);
INSERT INTO  plsqlmastery_lecture.lectureProducts VALUES ( plsqlmastery_lecture.lectureProductsSeq.NEXTVAL, 'Keyboard', 75.00, 200);
INSERT INTO  plsqlmastery_lecture.lectureProducts VALUES ( plsqlmastery_lecture.lectureProductsSeq.NEXTVAL, 'Monitor', 300.00, 80);
INSERT INTO  plsqlmastery_lecture.lectureProducts VALUES ( plsqlmastery_lecture.lectureProductsSeq.NEXTVAL, 'Mouse', 25.00, 300);
COMMIT;


CREATE TABLE  plsqlmastery_lecture.lectureCustomerLog ( logId NUMBER PRIMARY KEY, logTimestamp TIMESTAMP, customerName VARCHAR2(100), actionDetails VARCHAR2(4000));
COMMIT; -- Empty for now

-- Define Types for Collection/Record Tables

-- Nested Table Type
CREATE OR REPLACE TYPE plsqlmastery_lecture.lectureIntegerList IS TABLE OF NUMBER;
/
CREATE TABLE plsqlmastery_lecture.lectureNestedData ( id NUMBER PRIMARY KEY, dataList plsqlmastery_lecture.lectureIntegerList ) NESTED TABLE dataList STORE AS lectureNestedDataNt;
INSERT INTO plsqlmastery_lecture.lectureNestedData VALUES (plsqlmastery_lecture.lectureNestedDataSeq.NEXTVAL, plsqlmastery_lecture.lectureIntegerList(10, 20, 30));
INSERT INTO plsqlmastery_lecture.lectureNestedData VALUES (plsqlmastery_lecture.lectureNestedDataSeq.NEXTVAL, plsqlmastery_lecture.lectureIntegerList(1, 5, 10, 15));
COMMIT;

-- Varray Type
CREATE OR REPLACE TYPE plsqlmastery_lecture.lectureStringArray IS VARRAY(5) OF VARCHAR2(50);
/
CREATE TABLE plsqlmastery_lecture.lectureVarrayData ( id NUMBER PRIMARY KEY, dataArray plsqlmastery_lecture.lectureStringArray );
INSERT INTO plsqlmastery_lecture.lectureVarrayData VALUES (plsqlmastery_lecture.lectureVarrayDataSeq.NEXTVAL, plsqlmastery_lecture.lectureStringArray('Apple', 'Banana', 'Cherry'));
INSERT INTO plsqlmastery_lecture.lectureVarrayData VALUES (plsqlmastery_lecture.lectureVarrayDataSeq.NEXTVAL, plsqlmastery_lecture.lectureStringArray('Red', 'Green', 'Blue', 'Yellow'));
COMMIT;

-- Record Type (Object Type)
CREATE OR REPLACE TYPE plsqlmastery_lecture.lectureProductRec IS OBJECT ( prodId NUMBER, prodName VARCHAR2(50), prodPrice NUMBER(10,2) );
/
CREATE TABLE plsqlmastery_lecture.lectureRecordData ( id NUMBER PRIMARY KEY, prodInfo plsqlmastery_lecture.lectureProductRec );
INSERT INTO plsqlmastery_lecture.lectureRecordData VALUES (plsqlmastery_lecture.lectureRecordDataSeq.NEXTVAL, plsqlmastery_lecture.lectureProductRec(1000, 'Laptop', 1200.00));
INSERT INTO plsqlmastery_lecture.lectureRecordData VALUES (plsqlmastery_lecture.lectureRecordDataSeq.NEXTVAL, plsqlmastery_lecture.lectureProductRec(1003, 'Mouse', 25.00));
COMMIT;

-- Dynamic Data Target table
CREATE TABLE plsqlmastery_lecture.lectureDynamicTarget ( id NUMBER PRIMARY KEY, stringValue VARCHAR2(100), numericValue NUMBER );
COMMIT;