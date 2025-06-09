        -- Collections & Records, Bulk Operations for Performance, Dynamic SQL


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 3.1: Row-by-Row Processing vs. Bulk Operations
-- Processing data row by row between the SQL and PL/SQL engines is a common, intuitive approach but is highly inefficient for large datasets due to numerous context 
-- switches.
-- Create a PL/SQL anonymous block that declares a loop counter variable i. Loop through the product IDs 3000, 3002, 3005. Implement stock quantity updates for these 
-- products using a standard FOR LOOP that executes an individual UPDATE statement for each product ID inside the loop. Use new quantities (e.g., 60, 350, 40).
-- Create a second PL/SQL anonymous block that achieves the *same update* for the *same list of products and new quantities* using a FORALL statement. Assume the new 
-- quantities are stored in an associative array indexed by the product ID.
-- Conceptually explain which approach is more efficient for a large number of updates (e.g., thousands of rows) and why (mention context switches).
-- Bridge from PostgreSQL: Iterating and running single statements in a loop is inefficient in PostgreSQL too. PostgreSQL relies on client-side batching or using 
-- set-returning functions and UPDATE FROM. Oracle's FORALL is a dedicated PL/SQL feature for server-side bulk DML.
DECLARE
        -- Collection of Product IDs to update (used in the loop example)
        type productIdList IS TABLE OF PLSQLMASTERY.products.productId%TYPE INDEX BY PLS_INTEGER;
        productIdsToUpdate productIdList;

        -- Collection of New Quantities (indexed by Product ID, used in FORALL example)
        type newQuantityMap IS TABLE OF PLSQLMASTERY.products.stockQuantity%TYPE INDEX BY PLS_INTEGER;
        newQuantitiesMap newQuantityMap;

        i PLS_INTEGER;
BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Row-by-Row vs. FORALL ---');
        -- Populate collections for updates
        productIdsToUpdate(1) := 3000; -- Laptop
        productIdsToUpdate(2) := 3002; -- Mouse
        productIdsToUpdate(3) := 3005; -- Desk Chair

        newQuantitiesMap(3000) := 60;
        newQuantitiesMap(3002) := 350;
        newQuantitiesMap(3005) := 40;

        -- Restore initial quantities first for demonstration
        UPDATE PLSQLMASTERY.products SET stockQuantity = 50 WHERE productId = 3000;
        UPDATE PLSQLMASTERY.products SET stockQuantity = 300 WHERE productId = 3002;
        UPDATE PLSQLMASTERY.products SET stockQuantity = 30 WHERE productId = 3005;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Initial quantities: ID 3000=50, ID 3002=300, ID 3005=30');

        -- 1. Row-by-Row Update using FOR LOOP
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Row-by-Row Update ---');
        FOR i IN productIdsToUpdate.FIRST .. productIdsToUpdate.LAST LOOP
                -- This executes a separate UPDATE statement for each element, requiring a context switch
                -- between PL/SQL and SQL engines for every single row.
                UPDATE PLSQLMASTERY.products
                SET stockQuantity = newQuantitiesMap(productIdsToUpdate(i)) -- Assuming newQuantitiesMap has matching data
                WHERE productId = productIdsToUpdate(i);
                -- COMMIT; -- Avoid commit inside loop for performance, but showing row-by-row structure
        END LOOP;
        COMMIT; -- Commit all changes after the loop
END;
/


DECLARE
        -- Collection of Product IDs to update (used in the loop example)
        TYPE productInfoT IS RECORD (id PLSQLMASTERY.products.productId%TYPE, stock PLSQLMASTERY.products.stockQuantity%TYPE);
        type productIdList IS TABLE OF productInfoT INDEX BY PLS_INTEGER;
        productsToUpdate productIdList;
        i PLS_INTEGER;
BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Row-by-Row vs. FORALL ---');
        -- Populate collections for updates
        productsToUpdate(1).id := 3000; -- Laptop
        productsToUpdate(2).id := 3002; -- Mouse
        productsToUpdate(3).id := 3005; -- Desk Chair

        productsToUpdate(1).stock := 60;
        productsToUpdate(2).stock := 350;
        productsToUpdate(3).stock := 40;

        SELECT stockQuantity INTO i FROM PLSQLMASTERY.products WHERE productId = 3000; DBMS_OUTPUT.PUT_LINE('  ID 3000 stock: ' || i);
        SELECT stockQuantity INTO i FROM PLSQLMASTERY.products WHERE productId = 3002; DBMS_OUTPUT.PUT_LINE('  ID 3002 stock: ' || i);
        SELECT stockQuantity INTO i FROM PLSQLMASTERY.products WHERE productId = 3005; DBMS_OUTPUT.PUT_LINE('  ID 3005 stock: ' || i);

        -- Reset quantities for the next example
        UPDATE PLSQLMASTERY.products SET stockQuantity = 50 WHERE productId = 3000;
        UPDATE PLSQLMASTERY.products SET stockQuantity = 300 WHERE productId = 3002;
        UPDATE PLSQLMASTERY.products SET stockQuantity = 30 WHERE productId = 3005;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Quantities reset for FORALL example.');

        FORALL idx IN INDICES OF productsToUpdate
                UPDATE PLSQLMASTERY.PRODUCTS 
                SET STOCKQUANTITY = productsToUpdate(idx).stock
                WHERE PRODUCTID = productsToUpdate(idx).id;

        DBMS_OUTPUT.PUT_LINE('Completed bulk updates.');
        -- SELECT stockQuantity INTO i FROM products WHERE productId = 3000; DBMS_OUTPUT.PUT_LINE('  ID 3000 stock: ' || i);
        -- SELECT stockQuantity INTO i FROM products WHERE productId = 3002; DBMS_OUTPUT.PUT_LINE('  ID 3002 stock: ' || i);
        -- SELECT stockQuantity INTO i FROM products WHERE productId = 3005; DBMS_OUTPUT.PUT_LINE('  ID 3005 stock: ' || i);
END;
/
-- Oracle Specific Context: Refer to these chapters for performance comparisons and the mechanism of bulk SQL.
-- Performance and Scalability - Real-World Performance and Data Processing Techniques
-- Bulk SQL and Bulk Binding - FORALL Statement

--      Exercise 3.2: Manual Dynamic SQL String Building vs. Bind Variables
-- Directly building SQL strings by concatenating application data (even if not malicious) prevents Oracle from effectively caching and reusing the parsed statement, 
-- leading to parsing overhead.
-- Create a PL/SQL anonymous block that declares a loop counter variable i. Loop 100 times. Inside the loop, construct a dynamic 
-- SELECT 1 FROM DUAL WHERE 1 = [loop counter] statement by *concatenating* the loop counter (TO_CHAR(i)) into the string. 
DECLARE
        statemnt VARCHAR2(400) := 'SELECT 1 FROM DUAL WHERE ';
        aaaa INTEGER;
BEGIN
        FOR i IN 1..1000 LOOP
                DBMS_OUTPUT.PUT_LINE('STATEMENT: '||statemnt||TO_CHAR(i)||'='||TO_CHAR(i));
                EXECUTE IMMEDIATE statemnt||TO_CHAR(i)||'='||TO_CHAR(i) INTO aaaa;
                DBMS_OUTPUT.PUT_LINE('The iteration: '||i||'. The number: '||aaaa);
        END LOOP;
END;
/
DECLARE         -- This is highly faster
        statemnt VARCHAR2(400) := 'SELECT 1 FROM DUAL WHERE :id1 = :id2';
        aaaa INTEGER;
BEGIN
        FOR i IN 1..1000 LOOP
                EXECUTE IMMEDIATE statemnt INTO aaaa USING TO_CHAR(i), TO_CHAR(i);
                DBMS_OUTPUT.PUT_LINE('The iteration: '||i||'. The number: '||aaaa);
        END LOOP;
END;
/
-- Execute this statement using EXECUTE IMMEDIATE.
-- Create a second PL/SQL anonymous block that loops 100 times and executes a dynamic SELECT 1 FROM DUAL WHERE 1 = :value statement using EXECUTE IMMEDIATE with a bind 
-- variable (:value) bound to the loop counter.
-- Conceptually explain which approach is likely to have lower parsing overhead and better performance when executed repeatedly with different values, and why (mention 
-- soft parsing and statement caching).
-- Answer: the bind variables enables soft parsing, that is a specialization of parsing juust for binded spaces not possible to done with queries made by concatenation
-- because of their flexibility, the rigid mechanism of bind variables makes easier the process or parsing for the compiler
-- (Conceptual Exercise - No Code Needed)