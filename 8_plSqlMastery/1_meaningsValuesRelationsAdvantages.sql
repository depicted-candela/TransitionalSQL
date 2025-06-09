        -- Collections & Records, Bulk Operations for Performance, Dynamic SQL


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 1.1: Oracle Collections - Basic Usage and Differences
-- Oracle offers three types of collections: Associative Arrays, Varrays, and Nested Tables. Using the nestedIntegerList (Nested Table) 
-- and varrayStringList (Varray) types and the productInfoRec (Object Type) and productInfoList (Nested Table of Objects) types from the 
-- dataset, create PL/SQL blocks to:
-- Declare a variable of each type.
-- Initialize each variable using a constructor where applicable. For Associative Arrays, populate with at least 3 key-value pairs (use 
-- PLS_INTEGER index). Demonstrate accessing elements using the correct index syntax for each type.
-- Print the COUNT of elements in each populated collection.
-- For the Associative Array, print the FIRST and LAST index. Use NEXT and PRIOR to navigate a couple of elements.
-- For the Varray, demonstrate EXTEND by adding a NULL element.
-- For the Nested Table (nestedIntegerList), demonstrate DELETE by deleting an element from the middle.
DECLARE
    nestedIntegerList PLSQLMASTERY.nestedIntegerList := PLSQLMASTERY.nestedIntegerList(1, 2, 3);
    varrayStringList PLSQLMASTERY.varrayStringList := PLSQLMASTERY.varrayStringList(
        'Name 1', 'Name 2', 'Name 3', 'Name 4', 'Name 5'
    );
    TYPE productInfoRecTy IS TABLE OF PLSQLMASTERY.productInfoRec;
    productInfoRecT productInfoRecTy := productInfoRecTy(
        PLSQLMASTERY.productInfoRec(1, 'Educative Content', 30.0),
        PLSQLMASTERY.productInfoRec(1, 'Psychology', 20.0),
        PLSQLMASTERY.productInfoRec(1, 'Productivity', 30.0)
    );
    idx NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nested Integer List.');
    FOR x IN 1..nestedIntegerList.COUNT LOOP DBMS_OUTPUT.PUT_LINE('Integer '||x||' is: '||nestedIntegerList(x)); END LOOP;
    DBMS_OUTPUT.PUT_LINE('Varray String List.');
    FOR x IN 1..varrayStringList.COUNT LOOP DBMS_OUTPUT.PUT_LINE('Arranged string '||x||' is: '||varrayStringList(x)); END LOOP;
    DBMS_OUTPUT.PUT_LINE('Product Info Rect.');
    FOR x IN 1..productInfoRecT.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Product '||x||' with properties (id:'||productInfoRecT(x).pId||', name:'||productInfoRecT(x).pName||', pPrice:'||productInfoRecT(x).pPrice||')'
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Size of nestedIntegerList is '||nestedIntegerList.COUNT);
    DBMS_OUTPUT.PUT_LINE('Size of varrayStringList is '||varrayStringList.COUNT);
    DBMS_OUTPUT.PUT_LINE('Size of productInfoRecT is '||productInfoRecT.COUNT);
    idx := varrayStringList.FIRST;
    DBMS_OUTPUT.PUT_LINE('First element of the associative array is '||varrayStringList(idx));
    DBMS_OUTPUT.PUT_LINE('Last element of the associative array is '||varrayStringList(varrayStringList.LAST));
    idx := varrayStringList.NEXT(1);
    DBMS_OUTPUT.PUT_LINE('2 element of the associative array is '||varrayStringList(idx));
    idx := varrayStringList.PRIOR(idx);
    DBMS_OUTPUT.PUT_LINE('1 returned element of the associative array is '||varrayStringList(idx));
    varrayStringList.EXTEND(1);
    DBMS_OUTPUT.PUT_LINE('Varray extended with a trail null element ('||varrayStringList(varrayStringList.LAST)||') now is of size '||varrayStringList.COUNT);
    nestedIntegerList.DELETE(2);
    DBMS_OUTPUT.PUT_LINE('After a deletion of a middle item now the list is.');
    FOR x IN 1..nestedIntegerList.COUNT + 1 LOOP
        IF nestedIntegerList.EXISTS(x) THEN DBMS_OUTPUT.PUT_LINE('Integer at '||x||' is: '||nestedIntegerList(x));
        ELSE DBMS_OUTPUT.PUT_LINE('Integer at '||x||' is: NULL');
        END IF;
    END LOOP;
END;
/

--      Exercise 1.2: Bulk Operations - BULK COLLECT and FORALL
-- Efficient data processing between SQL and PL/SQL is crucial. Oracle provides BULK COLLECT and FORALL for this.
-- 1. Create a PL/SQL block to fetch the employeeId and lastName of all employees from the employees table into two separate associative arrays (empIds, empNames) 
-- using BULK COLLECT. Print the count of elements fetched.
DECLARE
    TYPE vEmployeeIdT IS TABLE OF PLSQLMASTERY.EMPLOYEES.EMPLOYEEID%TYPE INDEX BY PLS_INTEGER;
    TYPE vLastNameT IS TABLE OF PLSQLMASTERY.EMPLOYEES.LASTNAME%TYPE INDEX BY PLS_INTEGER;
    CURSOR employeesC IS (SELECT * FROM PLSQLMASTERY.EMPLOYEES);
    empIds vEmployeeIdT;
    empNames vLastNameT;
BEGIN
    SELECT EMPLOYEEID, LASTNAME BULK COLLECT INTO empIds, empNames FROM PLSQLMASTERY.EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE('Elements fetched are: '||empIds.COUNT);
END;
/
-- 2. Create another PL/SQL block to fetch the productName and price of all products with a stockQuantity less than 100 into a Nested Table of productInfoRec objects (
-- lowStockProducts) using BULK COLLECT. Print the name and price of the first three fetched products.
DECLARE
    TYPE vProductInfoT IS TABLE OF PLSQLMASTERY.productInfoRec INDEX BY PLS_INTEGER;
    vProductInfo vProductInfoT;
BEGIN
    SELECT PLSQLMASTERY.productInfoRec(PRODUCTID, PRODUCTNAME, PRICE) BULK COLLECT INTO vProductInfo 
    FROM PLSQLMASTERY.PRODUCTS;
    DBMS_OUTPUT.PUT_LINE('First three fetched products');
    FOR x IN 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE('Item '||x||' as name:'||vProductInfo(x).pName||' and price:'||vProductInfo(x).pPrice);
    END LOOP;
END;
/
-- 3. Create a PL/SQL block that declares an associative array reorderQuantities (indexed by PLS_INTEGER, value is NUMBER) and populates it with new stock quantities 
-- for products that need reordering (e.g., productId 3001 needs 250, productId 3004 needs 180). Use a FORALL statement to update the stockQuantity in the products 
-- table based on this collection. Print the total number of rows updated using SQL%ROWCOUNT.
SET AUTOCOMMIT OFF;
SET SERVEROUTPUT ON;
DECLARE
    TYPE productInfoR IS RECORD (
        id PLSQLMASTERY.PRODUCTS.PRODUCTID%TYPE,
        quantity PLSQLMASTERY.PRODUCTS.STOCKQUANTITY%TYPE
    );
    TYPE reorderQuantitiesT IS TABLE OF productInfoR INDEX BY PLS_INTEGER;
    reorderQuantities reorderQuantitiesT;
    totalUpdatedRows NUMBER;
BEGIN
    reorderQuantities(1).id := 3001;
    reorderQuantities(1).quantity := 250;
    reorderQuantities(2).id := 3004;
    reorderQuantities(2).quantity := 180;
    SAVEPOINT notUpdated;
    FORALL i IN INDICES OF reorderQuantities
        UPDATE PLSQLMASTERY.PRODUCTS
        SET STOCKQUANTITY = reorderQuantities(i).quantity
        WHERE PRODUCTID = reorderQuantities(i).id;
    totalUpdatedRows := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Counted lines are ' || totalUpdatedRows);
    COMMIT;
END;
/
-- 4. Create a PL/SQL block that declares a Nested Table orderItemsToDelete (of NUMBER) and populate it with orderItemIds that are part of order 2004. Use a FORALL 
-- statement to delete these items from the orderItems table. Print the total number of items deleted.
DECLARE
    TYPE orderItemsToDeleteT IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    orderItemsToDelete orderItemsToDeleteT;
BEGIN
    SELECT ORDERITEMID BULK COLLECT INTO orderItemsToDelete
    FROM PLSQLMASTERY.ORDERITEMS WHERE ORDERID = 2004;
    FORALL i IN INDICES OF orderItemsToDelete
        DELETE PLSQLMASTERY.ORDERITEMS
        WHERE ORDERITEMID = orderItemsToDelete(i);
    COMMIT;
END;
/
-- Bridge from PostgreSQL: PostgreSQL arrays are single-dimensional, and bulk operations typically involve optimizing client-side libraries or using functions that 
-- return sets. Oracle's BULK COLLECT and FORALL are explicit server-side mechanisms for efficiently moving data collections between the SQL and PL/SQL engines. 
-- Demonstrate this efficiency gain conceptually by showing the concise code.

-- Oracle Specific Context: Refer to these chapters for details on bulk operations.

-- Bulk SQL and Bulk Binding
-- Building Scalable Applications - About Bulk SQL

--      Exercise 1.3: Dynamic SQL - EXECUTE IMMEDIATE for DDL and DML
-- Sometimes the exact SQL statement is not known until runtime. Oracle provides EXECUTE IMMEDIATE and DBMS_SQL for this. Focus on EXECUTE IMMEDIATE here.
-- Create a PL/SQL block that takes a table name (VARCHAR2) as input and dynamically drops that table using EXECUTE IMMEDIATE. Use the IF EXISTS clause (23ai feature)
-- within the dynamic SQL string. Test it by trying to drop a table that exists (dynamicDataTarget) and one that doesn't (nonExistentTable).
DECLARE
    schma VARCHAR2(50) := 'PLSQLMASTERY';
    dynamicDataTarget VARCHAR2(50) := 'DYNAMICDATATARGET';
    nonExistentTable VARCHAR2(50) := 'NONEXISTENTTABLE';
    statemnt VARCHAR2(100);
    table_count SMALLINT;
BEGIN
    SELECT COUNT(*) INTO table_count FROM ALL_TABLES 
    WHERE TABLE_NAME = dynamicDataTarget AND OWNER = schma;
    IF table_count > 0 THEN 
        statemnt := 'DROP TABLE '||schma||'.'||dynamicDataTarget;
        EXECUTE IMMEDIATE statemnt;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Table '||dynamicDataTarget||' not found');
    END IF;
    SELECT COUNT(*) INTO table_count FROM ALL_TABLES 
    WHERE TABLE_NAME = nonExistentTable AND OWNER = schma;
    IF table_count > 0 THEN 
        statemnt := 'DROP TABLE '||schma||'.'||nonExistentTable;
        EXECUTE IMMEDIATE statemnt;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Table '||nonExistentTable||' not found');
    END IF;
END;
/
-- Create a PL/SQL block that takes a customerName (VARCHAR2) and actionDetails (VARCHAR2) as input and dynamically inserts a row into the customerLog table using 
-- EXECUTE IMMEDIATE. Use bind variables (:1, :2) in the dynamic string and the USING clause. Demonstrate inserting a log entry.
DECLARE
    schma VARCHAR2(50) := 'PLSQLMASTERY';
    tble VARCHAR2(50) := 'CUSTOMERLOG';
    cName VARCHAR2(50) := 'Nicolás';
    action VARCHAR2(50) := 'Started the system';
    statemnt VARCHAR2(200) := 'INSERT INTO '||schma||'.'||tble||'(LOGID, LOGTIMESTAMP, CUSTOMERNAME, ACTIONDETAILS) VALUES(PlSQLMASTERY.CUSTOMERLOG_SEQ.NEXTVAL, SYSTIMESTAMP, :1, :2)';
BEGIN
    EXECUTE IMMEDIATE statemnt USING cName, action;
    COMMIT;
END;
/
-- Create a PL/SQL block that takes an employeeId (NUMBER) and a newSalary (NUMBER) as input and dynamically updates the salary for that employee in the employees 
-- table using EXECUTE IMMEDIATE. Use bind variables (:newSal, :empId) in the dynamic string (demonstrating named binds) and the USING clause. Demonstrate updating an 
-- employee's salary. Print the old and new salary using a subsequent static SELECT INTO.
DECLARE
    schma VARCHAR2(50) := 'PLSQLMASTERY';
    tble VARCHAR2(50) := 'EMPLOYEES';
    id NUMBER := 1000;
    newSalary NUMBER := 70001;
    statemnt VARCHAR2(200) := 'UPDATE '||schma||'.'||tble||' SET SALARY = :1 WHERE EMPLOYEEID = :2';
BEGIN
    EXECUTE IMMEDIATE statemnt USING newSalary, id;
    COMMIT;
END;
/
-- Bridge from PostgreSQL: In PostgreSQL, you might use EXECUTE format(...) or prepare statements with dynamic parameters. EXECUTE IMMEDIATE is Oracle's standard way 
-- for simple dynamic SQL, using bind variables via the USING clause, which is similar in concept to prepared statements. Demonstrate the Oracle syntax and bind 
-- variable usage.

-- Oracle Specific Context: Refer to these chapters for details on Native Dynamic SQL.