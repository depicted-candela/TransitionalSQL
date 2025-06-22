        -- Speed Unleashed: Oracle Indexing and Query Insights


--  (ii) Disadvantages and Pitfalls
-- This exercise highlights the performance difference between an idiomatic Oracle approach and a common but inefficient one.

--      Exercise 1: Date Range Scans vs. Function-based Filtering
-- Problem:
-- Following up on the previous pitfall, you need to correct the developer's query to find all orders from 2023. The goal is to write a query that can effectively use 
-- the index on the orderDate column.

-- The inefficient query is SELECT COUNT(*) FROM customerOrders WHERE TO_CHAR(orderDate, 'YYYY') = '2023';.
EXPLAIN PLAN SET STATEMENT_ID = 'INEFFICIENT' FOR
    SELECT COUNT(*) FROM customerOrders WHERE TO_CHAR(orderDate, 'YYYY') = '2023';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(statement_id => 'INEFFICIENT'));
-- Write an efficient, SARGable query that finds all orders within the year 2023 using a date range.
EXPLAIN PLAN SET STATEMENT_ID = 'EFFICIENT' FOR
    SELECT COUNT(*) FROM SPEEDUNLEASH.CUSTOMERORDERS WHERE ORDERDATE >= DATE '2023-01-01' AND ORDERDATE < DATE'2024-01-01';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(statement_id => 'EFFICIENT'));
-- Generate and compare the execution plans for both queries.
-- Analysis: Explain why the second query is vastly superior in performance.
-- Answer: With TO_CHAR(orderDate, 'YYYY') = '2023', the process needs to compute compare all rows with TO_CHAR and 2023. Despite the number of rows and other
-- statistics are dramatically superior (leading to misleadings) with the sargable approach, such second approach is dramatically superior because as the index
-- is previously ordered, the range comparisons does not project first sets of rows selected by the miminum and maximum boundary values