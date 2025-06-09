        -- Collections & Records, Bulk Operations for Performance, Dynamic SQL


--  (ii) Disadvantages and Pitfalls

--      Exercise 2.1: Collection Pitfalls - Nulls, Non-Existence, and Type Mismatches
-- Working with collections in Oracle can have subtle pitfalls, especially related to nulls, non-existent elements, and type compatibility.
-- 1. Create a Nested Table variable sparseList of numbers. Populate it with elements at indices 1, 5, and 10, leaving gaps. Attempt to access sparseList(3) directly 
-- without checking for existence. Handle the expected exception (NO_DATA_FOUND or SUBSCRIPT_DOES_NOT_EXIST). Then use the EXISTS method to check if element 3 exists.
DECLARE
    TYPE sparseListT IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    sparseList sparseListT;
    search NUMBER;
BEGIN
    sparseList(1) := 1;
    sparseList(5) := 2;
    sparseList(10) := 3;
    IF sparseList.EXISTS(3) THEN search := sparseList(3);
    ELSE RAISE NO_DATA_FOUND; --SUBSCRIPT_DOES_NOT_EXIST;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Item 3 for the sparse list is: '||search);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Such index does not exist for the table');
END;
/
-- 2. Declare a Nested Table variable nullNestedTable and assign NULL to it (making it atomically null). Attempt to use the COUNT method on nullNestedTable. Handle the 
-- expected exception (COLLECTION_IS_NULL). Use the EXISTS method on the same nullNestedTable (it should not raise an exception).
DECLARE
    TYPE nullNestedTableT IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    nullNestedTable nullNestedTableT;
    recrds NUMBER := nullNestedTable.COUNT;
BEGIN 
    IF recrds = 0 OR nullNestedTable IS NULL THEN RAISE COLLECTION_IS_NULL; END IF; 
    DBMS_OUTPUT.PUT_LINE('The number of records is '||nullNestedTable.COUNT);
EXCEPTION 
    WHEN COLLECTION_IS_NULL THEN DBMS_OUTPUT.PUT_LINE('The collection nullNestedTable is null');
END;
/
-- 3. Declare a Varray variable smallStringArray of size 3. Initialize it with 3 elements. Attempt to EXTEND it to size 4. Handle the expected exception (
-- SUBSCRIPT_OUTSIDE_LIMIT).
DECLARE
    TYPE smallStringArrayT IS VARRAY(3) OF VARCHAR2(20);
    smallStringArray smallStringArrayT := smallStringArrayT();
BEGIN
    smallStringArray.EXTEND;
    smallStringArray.EXTEND;
    smallStringArray.EXTEND;
    smallStringArray.EXTEND;
EXCEPTION
    WHEN SUBSCRIPT_OUTSIDE_LIMIT THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- 4. Declare two Nested Table types, typeA and typeB, with identical structures (e.g., TABLE OF NUMBER). Declare variables ntA of typeA and ntB of typeB. Initialize 
-- ntA. Attempt to assign ntA to ntB. Explain the result.
DECLARE
    TYPE typeA IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE typeB IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    ntA typeA := typeA(1, 2, 3);
    ntB typeB;
BEGIN
    ntB := ntA;
END;
/
-- THe resuls is :
    -- ntB := ntA;
    --        *
    -- ERROR at line 7:
    -- ORA-06550: line 7, column 12:
    -- PLS-00382: expression is of wrong type
    -- ORA-06550: line 7, column 5:
    -- PL/SQL: Statement ignored
-- Rationale: this can't be handled with exceptions because it is a compilation error for uncompatibility of types

-- 5. Create a PL/SQL block to fetch a row from the orderItems table into a record variable declared using orderItems%ROWTYPE. Attempt to insert this record directly 
-- into a table that has a GENERATED ALWAYS column (like orderItems itself). Explain the result.
DECLARE
    orderItems PLSQLMASTERY.ORDERITEMS%ROWTYPE;
BEGIN
    SELECT * INTO orderItems 
    FROM PLSQLMASTERY.ORDERITEMS ORDER BY ORDERITEMID DESC FETCH NEXT 1 ROW ONLY;
    INSERT INTO PLSQLMASTERY.ORDERITEMS(ORDERITEMID, ORDERID, PRODUCTID, QUANTITY, UNITPRICE, ITEMAMOUNT) 
    VALUES(orderItems.ORDERITEMID + 1, orderItems.ORDERID, orderItems.PRODUCTID, orderItems.QUANTITY, orderItems.UNITPRICE, orderItems.ITEMAMOUNT);
END;
/
-- Answer: the error is 
-- Bridge from PostgreSQL: PostgreSQL arrays of the same base type are generally assignable. Oracle collections of different *types* are not, even if structurally 
-- identical.
-- Oracle Specific Context: Refer to these chapters for details on collection behavior and restrictions.
-- Rationale: a virtual table is created as a combination of explicit columns, thus is unmeaningful the insertion of that there
DECLARE -- This works
    orderItems PLSQLMASTERY.ORDERITEMS%ROWTYPE;
BEGIN
    SELECT * INTO orderItems 
    FROM PLSQLMASTERY.ORDERITEMS ORDER BY ORDERITEMID DESC FETCH NEXT 1 ROW ONLY;
    INSERT INTO PLSQLMASTERY.ORDERITEMS(ORDERITEMID, ORDERID, PRODUCTID, QUANTITY, UNITPRICE) 
    VALUES(orderItems.ORDERITEMID + 1, orderItems.ORDERID, orderItems.PRODUCTID, orderItems.QUANTITY, orderItems.UNITPRICE);
END;
/

--      Exercise 2.2: Bulk Operations Pitfalls - Exception Handling
-- Bulk operations are efficient but require careful exception handling, as a single error within the batch can affect the entire FORALL statement.
-- Create a PL/SQL block that declares an associative array productUpdates (indexed by PLS_INTEGER, value is VARCHAR2) and populates it with new productName values for
-- products, including one value that is too long for the productName column (e.g., for productId 3000, set name to a very long string).
DECLARE
    TYPE aProductNamesT IS TABLE OF VARCHAR2(51 BYTE) INDEX BY PLS_INTEGER;
    TYPE aProductIdsT IS TABLE OF PLSQLMASTERY.PRODUCTS.PRODUCTID%TYPE;
    aProductNames aProductNamesT;
    aProductIds aProductIdsT;
BEGIN
    SELECT PRODUCTID, RPAD(PRODUCTNAME, 51, '-') BULK COLLECT INTO aProductIds, aProductNames FROM PLSQLMASTERY.PRODUCTS;
    BEGIN
        FORALL i IN INDICES OF aProductNames
            UPDATE PLSQLMASTERY.PRODUCTS SET PRODUCTNAME = aProductNames(i) 
            WHERE PRODUCTID = aProductIds(i);
    EXCEPTION
        WHEN 
            OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected errors as: '||SQLERRM);
            RAISE;
    END;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

DECLARE
    TYPE aProductNamesT IS TABLE OF VARCHAR2(51 BYTE) INDEX BY PLS_INTEGER;
    TYPE aProductIdsT IS TABLE OF PLSQLMASTERY.PRODUCTS.PRODUCTID%TYPE;
    aProductNames aProductNamesT;
    aProductIds aProductIdsT;
BEGIN
    SELECT PRODUCTID, RPAD(PRODUCTNAME, 51, '-') BULK COLLECT INTO aProductIds, aProductNames FROM PLSQLMASTERY.PRODUCTS;
    BEGIN
        FORALL i IN INDICES OF aProductNames SAVE EXCEPTIONS
            UPDATE PLSQLMASTERY.PRODUCTS SET PRODUCTNAME = aProductNames(i) 
            WHERE PRODUCTID = aProductIds(i);
    EXCEPTION
        WHEN 
            OTHERS THEN 
                IF SQLCODE = -24381 THEN 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM);
                    DBMS_OUTPUT.PUT_LINE('There errors are '||SQL%BULK_EXCEPTIONS.COUNT);
                    FOR x IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
                        DBMS_OUTPUT.PUT_LINE(SQLERRM(-(SQL%BULK_EXCEPTIONS(x).ERROR_CODE))||' at '||SQL%BULK_EXCEPTIONS(x).ERROR_INDEX);
                    END LOOP;
                ELSE DBMS_OUTPUT.PUT_LINE(SQLERRM);
                END IF;
                RAISE;
    END;
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE = -24381 THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); END IF;
END;
/

-- Use a FORALL statement *without* the SAVE EXCEPTIONS clause to update the productName in the products table based on this collection. Include a simple WHEN OTHERS 
-- exception handler. Observe which updates (before and after the error) are rolled back.
-- Repeat the previous block, but this time use the FORALL ... SAVE EXCEPTIONS clause. Handle the ORA-24381 exception specifically. Inside the handler, loop through 
-- SQL%BULK_EXCEPTIONS to report the index and error code for each failed DML statement within the batch. Check the products table afterwards to see which updates 
-- succeeded and which failed.
-- Oracle Specific Context: Refer to these chapters for details on FORALL exception handling.

--      Exercise 2.3: Dynamic SQL Pitfalls - SQL Injection and String Concatenation
-- Using string concatenation to build dynamic SQL is a major security vulnerability (SQL Injection) and can also cause parsing inefficiencies.

-- 1. Create a PL/SQL procedure getLogEntryVulnerable that takes logId (NUMBER) and customerName (VARCHAR2) as input. Build a dynamic SELECT ... INTO statement for 
-- customerLog by *directly concatenating* the inputs into the WHERE clause. Select actionDetails into an OUT parameter. Print the constructed query string before 
-- executing it.
-- 2. Test getLogEntryVulnerable with a valid logId (e.g., from the initial dataset) and customerName (e.g., 'Alice').
-- 3. Test getLogEntryVulnerable with a malicious customerName input designed for SQL Injection, such as ' OR 1=1 --. Observe the printed query and the result. Explain 
-- why this is vulnerable.
-- 4. Create a *safe* version of the procedure getLogEntrySafe that uses EXECUTE IMMEDIATE with bind variables (:logId, :custName) for the logId and customerName 
-- inputs. Print the query string (it should show placeholders). Test it with the same malicious input. Observe the printed query and the result. Explain why this 
-- approach prevents injection.
CREATE OR REPLACE PROCEDURE PLSQLMASTERY.getLogEntryVulnerable (
    pLogId IN PLSQLMASTERY.CUSTOMERLOG.LOGID%TYPE, 
    pCustName IN PLSQLMASTERY.CUSTOMERLOG.CUSTOMERNAME%TYPE,
    details OUT NOCOPY PLSQLMASTERY.CUSTOMERLOG.ACTIONDETAILS%TYPE
) AUTHID DEFINER IS statemnt VARCHAR2(32767);
BEGIN
    BEGIN
        statemnt := 'SELECT ACTIONDETAILS FROM PLSQLMASTERY.CUSTOMERLOG WHERE LOGID = '||pLogId||' AND CUSTOMERNAME = '''||pCustName;
        DBMS_OUTPUT.PUT_LINE('STATEMENT: '||statemnt);
        EXECUTE IMMEDIATE statemnt INTO details;
    END;
END;
/

DECLARE     -- Malicious 1=1 sql injection
    pLogId PLSQLMASTERY.CUSTOMERLOG.LOGID%TYPE := 4001;
    pCustName PLSQLMASTERY.CUSTOMERLOG.CUSTOMERNAME%TYPE := 'Bob'' OR 1=1';
    details PLSQLMASTERY.CUSTOMERLOG.ACTIONDETAILS%TYPE;
BEGIN
    PLSQLMASTERY.GETLOGENTRYVULNERABLE(pLogId, pCustName, details);
    DBMS_OUTPUT.PUT_LINE('Details: '||details);
END;
/

CREATE OR REPLACE PROCEDURE PLSQLMASTERY.getLogEntryVulnerable (
    pLogId IN PLSQLMASTERY.CUSTOMERLOG.LOGID%TYPE, 
    pCustName IN PLSQLMASTERY.CUSTOMERLOG.CUSTOMERNAME%TYPE,
    details OUT NOCOPY PLSQLMASTERY.CUSTOMERLOG.ACTIONDETAILS%TYPE
) AUTHID DEFINER IS statemnt VARCHAR2(32767);
BEGIN
    BEGIN
        statemnt := 'SELECT ACTIONDETAILS FROM PLSQLMASTERY.CUSTOMERLOG WHERE LOGID = :logId AND CUSTOMERNAME = :pCustName';
        DBMS_OUTPUT.PUT_LINE('STATEMENT: '||statemnt);
        EXECUTE IMMEDIATE statemnt INTO details USING pLogId, pCustName;
    END;
END;
/
DECLARE     -- Clean solution
    pLogId PLSQLMASTERY.CUSTOMERLOG.LOGID%TYPE := 4001;
    pCustName PLSQLMASTERY.CUSTOMERLOG.CUSTOMERNAME%TYPE := 'Bob';
    details PLSQLMASTERY.CUSTOMERLOG.ACTIONDETAILS%TYPE;
BEGIN
    PLSQLMASTERY.GETLOGENTRYVULNERABLE(pLogId, pCustName, details);
    DBMS_OUTPUT.PUT_LINE('Details: '||details);
END;
/

--      Exercise 2.4: DBMS_SQL vs EXECUTE IMMEDIATE - When to Use Which (Conceptual)
-- Both EXECUTE IMMEDIATE (Native Dynamic SQL) and DBMS_SQL can run dynamic SQL. Understand their conceptual differences and when each is appropriate in Oracle DB 23ai.
-- Describe a scenario where you *must* use DBMS_SQL instead of EXECUTE IMMEDIATE. (Hint: Think about compile-time knowledge of the SQL structure).
-- Answer: when the scenario is prone to be massively used by multiple operations, DBMS_SQL is appropriate because gives multiple structures for input and storing data
-- through fine grained accessors, for fine grained fetching with meaningful logs with appropriate details through cursors, these types of flexible tools are not
-- available in Native Dynamic SQL
-- Describe a scenario where you *must* use Native Dynamic SQL (EXECUTE IMMEDIATE or OPEN FOR ... USING) instead of DBMS_SQL. (Hint: Think about processing fetched 
-- data).
-- Answer: when the scenario is straightforward and won't be used in multiple underlying procedures this is the best approach
-- Describe a scenario where you might prefer EXECUTE IMMEDIATE over DBMS_SQL for simplicity and potentially better performance (for simple cases).
-- ANswer: updating a single column based for a highly simple filter
-- (Conceptual Exercise - No Code Needed)

-- Oracle Specific Context: Refer to these chapters for an overview of Dynamic SQL options.