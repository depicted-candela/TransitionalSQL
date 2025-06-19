        -- Oracle Blueprint



--  Type (i): Meanings, Values, Relations, and Advantages

-- These exercises focus on exploring the "what" and "why" of Oracle's schema objects and metadata views, emphasizing the syntax and 
-- advantages, especially when compared to a PostgreSQL background.


--      Exercise 1: Exploring Your Schema with the Data Dictionary
-- Problem:
-- You have just created several objects in your Blueprint schema. Your task is to use Oracle's Data Dictionary views to answer the 
-- following questions. For deeper understanding of the Data Dictionary, consult the Oracle® Database Concepts guide on Data Dictionary 
-- and Dynamic Performance Views.

-- List all objects (and their types) that you own in your current schema.
ALTER SESSION SET CURRENT_SCHEMA = BLUEPRINT;
SELECT * FROM dictionary WHERE TABLE_NAME = 'USER_OBJECTS';
SELECT OBJECT_NAME, OBJECT_TYPE FROM user_objects;
-- Find the names and data types of all columns in the inventory table.
SELECT * FROM DICTIONARY WHERE TABLE_NAME LIKE 'ALL_T%COLUMNS';
SELECT COLUMN_NAME, DATA_TYPE FROM DBA_TAB_COLUMNS WHERE TABLE_NAME = 'INVENTORY';
-- Display the source code for the getProductCount procedure.
SELECT TEXT FROM DBA_SOURCE WHERE NAME = 'GETPRODUCTCOUNT';
-- List all constraints on the inventory table.
SELECT * FROM DBA_CONSTRAINTS 
WHERE TABLE_NAME = 'INVENTORY'; 
-- Bridging from PostgreSQL: In PostgreSQL, you would query the information_schema views (like information_schema.tables, 
-- information_schema.columns) or use psql's backslash commands (\d, \dt, \df). This exercise practices the Oracle way of retrieving this 
-- metadata using its powerful set of USER_*, ALL_*, and DBA_* views.


--      Exercise 2: Creating and Using Core Schema Objects
-- Problem:
-- Create a simple employees table to track who manages which warehouse. Refer to the Get Started Guide on Creating and Managing Schema 
-- Objects for practical examples.
-- Create a sequence named employeeSeq to generate unique employee IDs.
CREATE SEQUENCE BLUEPRINT.employeeSeq INCREMENT BY 1 START WITH 1 ORDER;
-- Create a table named employees with columns for employeeId (PK), employeeName, and managesWarehouseId (FK to warehouses).
CREATE TABLE BLUEPRINT.employees (
    employeeId NUMBER PRIMARY KEY,
    employeeName VARCHAR2(70),
    managesWarehouseId NUMBER(5, 0),
    CONSTRAINT managesWarehouseId FOREIGN KEY(managesWarehouseId) REFERENCES BLUEPRINT.WAREHOUSES(WAREHOUSEID)
);
-- Insert two employees, using the employeeSeq sequence for their IDs.
DECLARE
    warehouse NUMBER(5, 0);
BEGIN
    SELECT WAREHOUSEID INTO warehouse FROM BLUEPRINT.WAREHOUSES ORDER BY WAREHOUSEID DESC FETCH NEXT 1 ROW ONLY;
    INSERT INTO BLUEPRINT.EMPLOYEES(EMPLOYEEID, EMPLOYEENAME, MANAGESWAREHOUSEID) 
    VALUES (BLUEPRINT.employeeSeq.NEXTVAL, 'NACC', warehouse);
    COMMIT;
END;
/
-- Create a view named warehouseManagers that shows the employee name and the name of the warehouse they manage.
CREATE VIEW BLUEPRINT.WAREHOUSEMANAGERS AS
    SELECT EMPLOYEENAME, WAREHOUSENAME FROM BLUEPRINT.EMPLOYEES NATURAL JOIN BLUEPRINT.WAREHOUSES
;
SELECT * FROM BLUEPRINT.WAREHOUSEMANAGERS;
-- As anotherSchema, you need frequent access to Blueprint.products. Create a private synonym named prodList in anotherSchema's schema 
-- that points to Blueprint.products. Then, query your synonym.
ALTER SESSION SET CURRENT_SCHEMA = anotherSchema;
ALTER SESSION SET CURRENT_SCHEMA = blueprint;
CREATE SYNONYM anotherSchema.PRODLIST FOR BLUEPRINT.PRODUCTS;
SELECT * FROM anotherSchema.PRODLIST;
-- Bridging from PostgreSQL: This exercise contrasts Oracle's explicit CREATE SEQUENCE and .NEXTVAL usage with PostgreSQL's SERIAL or 
-- IDENTITY column types. It also introduces the concept of synonyms, which provide a powerful layer of abstraction not commonly used in 
-- PostgreSQL.


--      Exercise 3: Understanding Oracle's Concurrency (MVCC) and Transaction Control
-- Problem:
-- This exercise demonstrates Oracle's Multi-Version Concurrency Control (MVCC) and transaction lifecycle. You will need two separate 
-- database connections/sessions (for example, two SQL Developer worksheets) connected as Blueprint. For detailed concepts, review the 
-- Data Concurrency and Consistency and Transactions chapters from the Oracle Concepts guide.

-- In Session 1: Start a transaction by reducing the quantity of 'PL/SQL Stored Procedure Guide' (productId 101) by 10. Do not commit.
-- In Session 1: Query the inventory table to see the new quantity. You should see the updated value.
DECLARE
    v_product BLUEPRINT.INVENTORY%ROWTYPE;
BEGIN
    UPDATE BLUEPRINT.INVENTORY SET QUANTITYONHAND = QUANTITYONHAND - 10 WHERE PRODUCTID = 101;
    SELECT * INTO v_product FROM BLUEPRINT.INVENTORY WHERE PRODUCTID = 101;
    DBMS_OUTPUT.PUT_LINE('updated but not committed product '||v_product.PRODUCTID||' with quantity as '||v_product.QUANTITYONHAND);
END;
/
-- In Session 2: While Session 1's transaction is still open, query the inventory table for the same product. What quantity do you see 
-- and why?
-- Answer: te value in session 2 is the one without the updated value, but with the original value 
-- In Session 1: Create a SAVEPOINT named before_price_update.
SAVEPOINT before_price_update;
-- In Session 1: Now, update the unitPrice of the same product to 80.00.
-- In Session 1: Realize the price update was a mistake and ROLLBACK to the before_price_update savepoint. Query the inventory and 
-- products tables. What are the current values?
DECLARE 
    v_product BLUEPRINT.PRODUCTS%ROWTYPE;
BEGIN
    UPDATE BLUEPRINT.PRODUCTS SET UNITPRICE = 80 WHERE PRODUCTID = 101;
    SELECT * INTO v_product FROM BLUEPRINT.PRODUCTS WHERE PRODUCTID = 101;
    DBMS_OUTPUT.PUT_LINE('updated but not committed product '||v_product.PRODUCTNAME||' with PRICE as '||v_product.UNITPRICE);
    ROLLBACK TO before_price_update;
END;
/
SELECT * FROM BLUEPRINT.INVENTORY; -- Does not have the original value despite of the Rolling back because of the SAVEPOINT set after of
-- if, then the value was not returned
SELECT * FROM BLUEPRINT.PRODUCTS;  -- THe value was returned to the original value because is bellow the last rolled back SAVEPOINT 
-- In Session 1: COMMIT the transaction.
COMMIT;
-- In Session 2: Query the inventory table again. What quantity do you see now and why?
-- Answer: the updated quantity was successfully changed because it's previous to the last rolled-back savepoint