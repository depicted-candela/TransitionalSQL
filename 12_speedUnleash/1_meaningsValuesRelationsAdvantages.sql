        -- Speed Unleashed: Oracle Indexing and Query Insights


--  (i) Meanings, Values, Relations, and Advantages
-- These exercises focus on the what and why of Oracle's indexing and plan analysis tools, contrasting with PostgreSQL where relevant.

--      Exercise 1: The Foundation - From Full Scan to B-Tree Index
-- Problem:
-- You are tasked with retrieving all orders for a specific productId. First, analyze the performance of this query without any indexes. Then, create a standard B-Tree 
-- index on the productId column in the customerOrders table and analyze the plan again.
-- Generate the execution plan for this query.
EXPLAIN PLAN FOR
SELECT * FROM SPEEDUNLEASH.CUSTOMERORDERS WHERE PRODUCTID = 2;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Create a standard B-Tree index named idxOrderProduct on the productId column.
DROP INDEX CUSTOMERORDERS.idxProductForOrder;
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS('SPEEDUNLEASH', 'CUSTOMERORDERS');
END;
/
CREATE INDEX idxProductForOrder ON SPEEDUNLEASH.customerOrders(productId);
-- Step 4: Generate the plan again
EXPLAIN PLAN FOR
SELECT * FROM SPEEDUNLEASH.customerOrders WHERE productId = 2;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Generate the execution plan for the same query again.
-- Analysis: Describe the key differences between the two plans. What operations changed, and why is the second plan more efficient for retrieving a small subset of 
-- data?
-- Answer: the difference is of methodology, without index implementation a full scan is performed with 2 steps of 3981 rows each of them and a total of 242 CPU costs
-- with indexes the methodology is TABLE ACCESS BY INDEX ROWID BATCHED and INDEX RANGE SCAN using 3981 rows for each step and a total of 198 CPU costs

--      Exercise 2: Low Cardinality Power - The Bitmap Index
-- Problem:

-- Queries filtering on orderStatus are common for reporting. Since orderStatus has very few distinct values (low cardinality), a Bitmap index is a potential 
-- optimization.
-- Write a query to count orders for each status where the status is either 'SHIPPED' or 'PENDING'.
SELECT ORDERSTATUS, COUNT(*) FROM SPEEDUNLEASH.CUSTOMERORDERS WHERE ORDERSTATUS IN ('SHIPPED', 'PENDING') GROUP BY ORDERSTATUS;
EXPLAIN PLAN FOR
SELECT ORDERSTATUS, COUNT(*) FROM SPEEDUNLEASH.CUSTOMERORDERS WHERE ORDERSTATUS IN ('SHIPPED', 'PENDING') GROUP BY ORDERSTATUS;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Create a Bitmap index named idxOrderStatusBitmap on the orderStatus column.
DROP INDEX idxOrderStatusBitmap;
CREATE BITMAP INDEX idxOrderStatusBitmap ON SPEEDUNLEASH.CUSTOMERORDERS(ORDERSTATUS);
-- Generate the execution plan for the query.
EXPLAIN PLAN FOR
SELECT ORDERSTATUS, COUNT(*) FROM SPEEDUNLEASH.CUSTOMERORDERS WHERE ORDERSTATUS IN ('SHIPPED', 'PENDING') GROUP BY ORDERSTATUS;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Analysis: Identify the BITMAP operations in the plan and explain why a Bitmap index is advantageous for this type of query and data.
-- Answer: for this query the BITMAP index is 93.98% faster than the naïve approach

--      Exercise 3: Indexing an Expression - The Function-Based Index
-- Problem:
-- Your application often needs to search for customers by name, but the search must be case-insensitive. The customerName column, however, contains mixed-case data. A 
-- normal index on customerName would be useless for a query with WHERE UPPER(customerName) = '...'.
-- Create a function-based index that stores the uppercase version of customerName.
EXPLAIN PLAN FOR
SELECT CUSTOMERID, CUSTOMERNAME FROM SPEEDUNLEASH.CUSTOMERS WHERE UPPER(CUSTOMERNAME) = 'SUNRISE TRADING';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX idxCustUpperName;
CREATE INDEX idxCustUpperName ON SPEEDUNLEASH.CUSTOMERS(UPPER(CUSTOMERNAME));
-- Write a query to find the customerId for sunrise trading (note the lowercase).

-- Generate and analyze the execution plan to confirm the new index is used.
EXPLAIN PLAN FOR
SELECT CUSTOMERID, CUSTOMERNAME FROM SPEEDUNLEASH.CUSTOMERS WHERE UPPER(CUSTOMERNAME) = 'SUNRISE TRADING';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Answer: instead of TABLE ACCESS FULL is used TABLE ACCESS BY INDEX ROWID BATCHED with INDEX RANGE SCAN with a very few cost enhancement of 1 CPU cost

--      Exercise 4: The Composite Index and the Leading Column Rule
-- Problem:
-- A common query pattern is to look up all orders for a specific customer that occurred after a certain date.
EXPLAIN PLAN FOR
SELECT *
FROM SPEEDUNLEASH.CUSTOMERORDERS
WHERE CUSTOMERID = 4 AND ORDERDATE > TO_DATE('2022-01-10', 'YYYY-MM-DD');
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Create a composite (multi-column) index on (customerId, orderDate) on the customerOrders table.

BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'SPEEDUNLEASH',         -- Your schema name, in uppercase
        tabname => 'CUSTOMERORDERS',       -- Your table name, in uppercase
        cascade => TRUE,                   -- Also analyze indexes
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
    );
END;
/

SELECT
    column_name,
    num_distinct AS cardinality,
    num_nulls,
    last_analyzed
FROM
    user_tab_columns
WHERE
    table_name = 'CUSTOMERORDERS'; -- Use your table name, in uppercase

DROP INDEX idxCustomerIdOrderDate;
CREATE INDEX idxCustomerIdOrderDate ON SPEEDUNLEASH.CUSTOMERORDERS(CUSTOMERID, ORDERDATE);

-- Generate the execution plan for a query that filters by both customerId and orderDate.
EXPLAIN PLAN SET STATEMENT_ID = 'BOTH' FOR
SELECT orderId FROM customerOrders
WHERE customerId = 9 AND orderDate > DATE '2023-01-01';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(statement_id => 'BOTH'));

-- Generate the execution plan for a query that filters only by customerId.
EXPLAIN PLAN SET STATEMENT_ID = 'CUSTOMER_ID' FOR
SELECT *
FROM SPEEDUNLEASH.CUSTOMERORDERS
WHERE CUSTOMERID = 9;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(statement_id => 'CUSTOMER_ID'));

-- Generate the execution plan for a query that filters only by orderDate.
EXPLAIN PLAN SET STATEMENT_ID = 'ORDERDATE' FOR
SELECT *
FROM SPEEDUNLEASH.CUSTOMERORDERS
WHERE ORDERDATE > TO_DATE('2022-01-10', 'YYYY-MM-DD');
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(statement_id => 'ORDERDATE'));

-- Analysis: Explain why the index was used in plans 2 and 3, but likely not in plan 4.
-- Answer: the hierarchy of composed indexes starts with exact equalities, then ranges and then patterns like REGEXP or LIKE, where if there exists multiple
-- same type comparisons, what prioritize them is higher cardinalities, because the 4th plan starts without the starting hierarchized column, such hierarchies
-- for speed are broken, then the index does not apply