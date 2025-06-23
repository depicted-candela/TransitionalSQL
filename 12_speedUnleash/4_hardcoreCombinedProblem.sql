        -- Speed Unleashed: Oracle Indexing and Query Insights


--  (iv) Hardcore Combined Problem
-- This problem integrates indexing, EXPLAIN PLAN, PL/SQL, analytic functions, and hierarchical queries.

--      Exercise 1: Executive Performance Dashboard Query
-- Problem:

-- The executive team at APAC Partners (customerId 8) wants a performance report. They need to identify the top 2 performing product 
-- categories for each of their direct sub-organizations (Sunrise Trading and southern cross) based on total sales revenue 
-- (quantity * unitPrice). The final report must show the sub-organization's name, its category, the total revenue for that category, and 
-- the rank of that category's performance within that sub-organization. The query must be case-insensitive when matching the top-level 
-- company nameAPAC Partners

-- Task:
-- Gather Statistics: Write a PL/SQL anonymous block to ensure the optimizer has the most up-to-date statistics for the customers, products, and customerOrders tables.
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'SPEEDUNLEASH',
        tabname => 'CUSTOMERORDERS',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt => 'FOR ALL COLUMNS SIZE AUTO',
        cascade => TRUE
    );
END;
/
-- For more information on the importance of statistics and the DBMS_STATS package, consult the Oracle® Database SQL Tuning Guide, 
-- Chapter 10, Optimizer Statistics Concepts.

-- Create Optimal Indexes: Based on the query requirements, determine the necessary B-Tree, Composite, and Function-Based indexes to make the query as efficient as 
-- possible. Write the CREATE INDEX statements.
-- While you know B-Tree and Composite indexes from PostgreSQL, pay special attention to Oracle's Function-Based and Bitmap indexes, as they are key to solving 
-- specific performance challenges. Refer to the Oracle® Database Concepts, Chapter 5, Indexes and Index-Organized 
-- Tables for a refresher.

-- Write the Query: Construct a single SQL statement to generate the required report. This will involve:
-- A hierarchical query (CONNECT BY) to find the direct sub-organizations of APAC Partners
WITH hierarchization AS (
    SELECT CUSTOMERID
    FROM SPEEDUNLEASH.CUSTOMERS 
    WHERE MANAGERID = 8
    CONNECT BY PRIOR MANAGERID = CUSTOMERID
), hierarchizedTotalSales AS (
    SELECT CUSTOMERID, CATEGORY, SUM(QUANTITY * UNITPRICE) TOTALSALESREVENUE FROM hierarchization 
    LEFT JOIN SPEEDUNLEASH.CUSTOMERORDERS USING(CUSTOMERID)
    NATURAL JOIN SPEEDUNLEASH.CUSTOMERS
    NATURAL JOIN SPEEDUNLEASH.PRODUCTS
    GROUP BY CUSTOMERID, CATEGORY
)

SELECT CUSTOMERID, CATEGORY FROM (
    SELECT CUSTOMERID, CATEGORY, DENSE_RANK() OVER (PARTITION BY CUSTOMERID ORDER BY TOTALSALESREVENUE) AS CATEGORICALRANKING 
    FROM hierarchizedTotalSales
) WHERE CATEGORICALRANKING < 3 ORDER BY CUSTOMERID, CATEGORICALRANKING;
-- Joins between all three tables.
-- A GROUP BY to aggregate revenue.
-- An analytic function (DENSE_RANK()) to rank the categories within each company.
-- Analyze and Justify: Generate the EXPLAIN PLAN for your final query and add comments to your solution explaining why you chose each 
-- index and how each key part of the execution plan (e.g., joins, scans) reflects your indexing strategy.
-- To understand the output, refer to the Oracle® Database SQL Tuning Guide, Chapter 6, Explaining and Displaying Execution Plans.
