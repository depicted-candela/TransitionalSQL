        -- 1 Large OBjects


--  (i) Meanings, Values, Relations, and Advantages
--      Exercise 1.1.1: Oracle LOBs vs. PostgreSQL Large Objects
-- Problem:
-- Explain the key differences between Oracle's CLOB/BLOB types and PostgreSQL's TEXT/BYTEA types, particularly concerning typical size limits, storage 
-- mechanisms (inline vs. out-of-line), and dedicated manipulation packages/APIs.
--  Answer: CLOB AND TEXT are different because the first have largest and configurable maximum memory for a single object while the second have fixed 
-- limits, also it have an Oracle's dedicated package (DBMS_LOB) to search and operate on it. THe same happens for BLOB and BYTEA but for binary files. 
-- Another important difference is that because LOB files can be extremally large, they aren't stored direcly in the table for fast operations, instead 
-- they are linked to the spaces where they are, could be largest petabyes disks and external storages
-- What is a "LOB Locator" in Oracle, and why is it beneficial for LOB manipulation?
-- Answer: It's like a pointer to avoid overheading projecting tables with massive data in their LOB columns
-- Write a PL/SQL anonymous block that: 
-- a. Declares a CLOB variable and initializes it with the ProductDescription of 'SuperPhone X'. 
-- b. Appends the string "Product subject to availability." to this CLOB variable using DBMS_LOB.APPEND. 
-- c. Prints the length of the modified CLOB and the first 200 characters. 
-- d. Retrieves the ProductImage BLOB for 'SuperPhone X' into a BLOB variable and prints its length using DBMS_LOB.GETLENGTH. 
SET SERVEROUTPUT ON;
DECLARE
        vDescription CLOB := 'SuperPhone X';
        vToAppend CLOB := 'Product subject to availability';
        vProductImage BLOB;
BEGIN
        DBMS_LOB.APPEND(vDescription, vToAppend);
        DBMS_OUTPUT.PUT_LINE('The length of the modified CLOB is: ' || DBMS_LOB.GETLENGTH(vDescription));
        SELECT PRODUCTIMAGE INTO vProductImage
        FROM CONQUERINGCOMPLEXITIES.PRODUCTS WHERE PRODUCTID = 1;
        DBMS_OUTPUT.PUT_LINE('The length of the BLOB image: ' || DBMS_LOB.GETLENGTH(vProductImage));
EXCEPTION
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Some errors as: ' || SQLERRM);
END;
/

--  (ii) Disadvantages and Pitfalls (LOBs)
--      Exercise 1.2.1: LOB Performance and Management Traps
-- Problem:
-- A developer needs to check if any product description (CLOB) contains the word "warranty". They write a PL/SQL loop, fetch each ProductDescription into
-- a CLOB variable, and use DBMS_LOB.INSTR. What are two potential performance issues with this approach for a table with many products and large 
-- descriptions?
-- Answer: the loop is verbose compared to a custom filter prone to be indexed -thus completely slow in comparison-, besides of that the heavy overloading
-- of too big CLOB characters will make even more slow the query;
-- SELECT * FROM CONQUERINGCOMPLEXITIES.PRODUCTS WHERE CONTAINS(ProductDescription, 'warranty') > 0; -- returns """ORA-30600: Oracle Text error
-- DRG-10599: column is not indexed https://docs.oracle.com/error-help/db/ora-30600/
-- Oracle Text component failed. More information about the specific failure is available in the errors that follow"""
-- Showing that as expected, an index must be specified to make this query performant to avoid query overloading
-- What happens if you forget to call DBMS_LOB.FREETEMPORARY for temporary LOBs created in a session, especially within loops or long-running procedures?
-- They're persistently stored in the session as the session exists, consuming memory and could create accidents in badly written queries but they're just
-- stored in specific sessions, thus the problems will be solved closing the session
-- Why is it generally a bad idea to store small, frequently accessed text (e.g., status codes, short flags under 50 characters) in CLOB columns?
-- Because is like purchasing a mansion for a single person without friends: too much enery for nothing


--  (iii) Contrasting with Inefficient Common Solutions (LOBs)
--      Exercise 1.3.1: Building a Large Log Entry: Inefficient vs. Efficient
-- Scenario: You need to construct a large log message by concatenating several pieces of diagnostic information. The final log can exceed standard 
-- VARCHAR2 limits.
-- Inefficient Approach (Conceptual): A developer might repeatedly fetch a CLOB log, use the || operator to append new VARCHAR2 info, and update the CLOB 
-- back to the table in each step.
-- Problem: Explain at least two major inefficiencies in the conceptual approach above for appending to a CLOB in a loop.
-- Answer: such loop requires fetching the same variable as many times as exist messages to append, this not only requires the repeated fetching of rows
-- prone to be giant, but also its location in a variable indicated in the declaration of the function, with this we make unncessary steps solved with 
-- a single procedure without loops fetching data deespite the loop could iterate in the messages to append in the column fetched and store in a declared
-- variable just once
-- Write a PL/SQL block demonstrating an efficient way to append three distinct VARCHAR2 messages to the ProductDescription of 'Oracle Master Guide 23ai'. 
-- Use a single transaction and DBMS_LOB procedures. The messages are:
-- "Update 1: Now includes a new chapter on AI features in DB."
-- "Update 2: Companion website with code samples available."
-- "Update 3: Special discount for bulk purchases."
SET SERVEROUTPUT ON;
DECLARE
        v_pdescription  CLOB;
        product_name VARCHAR2(100 BYTE) := 'Oracle Master Guide 23ai';
        update_1 VARCHAR2(60) := 'Update 1: Now includes a new chapter on AI features in DB.';
        update_2 VARCHAR2(60) := 'Update 2: Companion website with code samples available.';
        update_3 VARCHAR2(60) := 'Update 3: Special discount for bulk purchases.';
BEGIN
        SELECT PRODUCTDESCRIPTION INTO v_pdescription 
        FROM CONQUERINGCOMPLEXITIES.PRODUCTS
        WHERE PRODUCTNAME = product_name
        FOR UPDATE;
        DBMS_LOB.WRITEAPPEND(v_pdescription, LENGTH(update_1), update_1);
        DBMS_LOB.WRITEAPPEND(v_pdescription, LENGTH(update_2), update_2);
        DBMS_LOB.WRITEAPPEND(v_pdescription, LENGTH(update_3), update_3);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('All updates were added');
        SELECT PRODUCTDESCRIPTION INTO v_pdescription 
        FROM CONQUERINGCOMPLEXITIES.PRODUCTS
        WHERE PRODUCTNAME = product_name;
        DBMS_OUTPUT.PUT_LINE('The result is:' || v_pdescription);
END;
/