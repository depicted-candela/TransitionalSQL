        -- The Performance Symphony


--  1. Meanings, Values, Relations, and Advantages

--      Exercise 1.1: The Power of SARGable Predicates
-- Problem:
-- Your PostgreSQL experience has taught you that functions on indexed columns can hinder performance. Oracle behaves similarly.
-- Write a query to find all employees hired in the year 2022. Use the TO_CHAR function on the hireDate column in your WHERE clause.
-- Generate the execution plan for this query using DBMS_XPLAN. Observe the access path.
EXPLAIN PLAN SET STATEMENT_ID = 'INEFFICIENT' FOR
SELECT * FROM PERFORMANCESYMPHONY.EMPLOYEES WHERE TO_CHAR(HIREDATE, 'YYYY') = '2022';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'INEFFICIENT'));
-- Rewrite the query to be SARGable by using a date range with the BETWEEN operator or >= and < operators, avoiding any function on the hireDate column.
-- Generate the execution plan for the SARGable query and compare it to the first plan. Note the difference in the access path and cost.
EXPLAIN PLAN SET STATEMENT_ID = 'EFFICIENT' FOR
SELECT * FROM PERFORMANCESYMPHONY.EMPLOYEES WHERE HIREDATE BETWEEN DATE '2022-01-01' AND DATE '2022-12-12';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'EFFICIENT'));
-- Answer: despite the method (TABLE ACCESS FULL) and cost (7) are the same, they're different in their necessary rows and bytes where the SARGable query requires
-- less rows and bytes
-- Focus: This exercise reinforces a universal SQL tuning principle within the Oracle context, contrasting an inefficient function-based predicate with an efficient, 
-- index-friendly range scan. Read more about performance design in the Database Performance Tuning Guide, Chapter 2.

--      Exercise 1.2: The Importance of Table Statistics
-- Problem:
-- Oracle's Cost-Based Optimizer (CBO) relies entirely on statistics to make intelligent decisions. Without them, its choices can be suboptimal.
-- Create a new table productSales and populate it with a significant number of rows. Do not gather statistics yet. Create an index on the productId.
CREATE TABLE performanceSymphony.productSales (
    saleId        NUMBER(10) NOT NULL,
    productId     NUMBER(6) NOT NULL,
    customerId    NUMBER(8) NOT NULL,
    saleDate      DATE NOT NULL,
    quantitySold  NUMBER(4) NOT NULL,
    saleAmount    NUMBER(10, 2),
    channel       VARCHAR2(20)
);
-- Add a primary key constraint on the saleId column
ALTER TABLE performanceSymphony.productSales
ADD CONSTRAINT pk_productSales PRIMARY KEY (saleId);
-- Step 2: Populate the productSales table with a large volume of data (1,000,000 rows).
-- Note: This PL/SQL block may take a few minutes to execute depending on your system.
PROMPT Populating productSales table...
DECLARE
  l_channel VARCHAR2(20);
BEGIN
    FOR i IN 1..1000000 LOOP
        -- Assign a channel based on the loop counter to create a predictable distribution
        CASE MOD(i, 4)
            WHEN 0 THEN l_channel := 'Online';
            WHEN 1 THEN l_channel := 'Retail';
            WHEN 2 THEN l_channel := 'Direct';
            ELSE l_channel := 'Partner';
        END CASE;
        INSERT INTO performanceSymphony.productSales (
        saleId, productId, customerId, saleDate, quantitySold, saleAmount, channel
        ) VALUES (
        i, -- saleId
        TRUNC(DBMS_RANDOM.VALUE(1, 5000)), -- productId (random product from 1-4999)
        TRUNC(DBMS_RANDOM.VALUE(1, 100000)), -- customerId (random customer from 1-99999)
        TO_DATE('2021-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 1460)), -- A random date within a 4-year span
        TRUNC(DBMS_RANDOM.VALUE(1, 6)), -- quantitySold (1 to 5)
        ROUND(DBMS_RANDOM.VALUE(10, 2000), 2), -- saleAmount
        l_channel
        );
        -- Commit every 50,000 rows to manage UNDO tablespace and prevent excessive resource usage.
        IF MOD(i, 50000) = 0 THEN
        COMMIT;
        END IF;
    END LOOP;

    COMMIT; -- Final commit for any remaining rows
END;
/
CREATE INDEX performanceSymphony_product ON PERFORMANCESYMPHONY.PRODUCTSALES(PRODUCTID);
-- Write a query to find sales for a single, specific productId.
SELECT * FROM PERFORMANCESYMPHONY.PRODUCTSALES WHERE PRODUCTID = 3113;
-- Generate the EXPLAIN PLAN. Observe the optimizer's estimated number of rows (Rows column) and the access path chosen.
EXPLAIN PLAN SET STATEMENT_ID = 'PRODUCTUAL' FOR
SELECT * FROM PERFORMANCESYMPHONY.PRODUCTSALES WHERE PRODUCTID = 3113;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'PRODUCTUAL'));
-- Now, gather statistics for the table using DBMS_STATS.GATHER_TABLE_STATS.
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'PERFORMANCESYMPHONY',
        tabname => 'PRODUCTSALES'
    );
END;
/
-- Generate the EXPLAIN PLAN for the exact same query again. Compare the new plan's cardinality estimate and access path to the previous one.
EXPLAIN PLAN SET STATEMENT_ID = 'PRODUCTUAL_GATHERED' FOR
SELECT * FROM PERFORMANCESYMPHONY.PRODUCTSALES WHERE PRODUCTID = 3113;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'PRODUCTUAL_GATHERED'));
-- Analysis: with updated statistics the costs and rows were reduced in a small proportion, the necessary bytes were dramatically reduced 
-- Focus: This exercise demonstrates the fundamental value of the DBMS_STATS package. It shows how providing the CBO with accurate data distribution information is the 
-- most direct way to get efficient query plans. For a deep dive into statistics, see the SQL Tuning Guide, Chapter 10.

--      Exercise 1.3: Diagnosing with the 23ai SQL Analysis Report
-- Problem:
-- You have been given a query written by a junior developer that is performing poorly. The query is intended to join employees and departments but has a logical flaw. 
-- Use the new SQL Analysis Report feature to get an automatic diagnosis.

-- Execute the following flawed query, which unintentionally creates a Cartesian product.
-- Use DBMS_XPLAN.DISPLAY_CURSOR to view the execution plan and the SQL Analysis Report that Oracle generates for the last executed statement.
-- Interpret the report's findings and explain its recommendation.
-- -- The flawed query
EXPLAIN PLAN SET STATEMENT_ID = 'FLAWED_QUERY' FOR
SELECT e.lastName, d.departmentName
FROM employees e, departments d
WHERE e.departmentId = 90; -- Missing join condition!
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'FLAWED_QUERY'));

-- The detected antipattern is 
-- SQL Analysis Report

--             1 - SEL$1
            
--  - The query block has 1 cartesian product which may be expensive. Consider adding join conditions or removing the disconnected tables or views.
          
-- Focus: This exercise introduces a powerful Oracle 23ai feature. The SQL Analysis Report automates the diagnosis of common SQL anti-patterns, providing clear, 
-- actionable feedback directly in the plan output. This is a significant time-saver for both new and experienced developers. Learn more in the SQL Tuning Guide, 
-- Chapter 19 and the New Features Guide.
