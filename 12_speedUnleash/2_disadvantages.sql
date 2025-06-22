        -- Speed Unleashed: Oracle Indexing and Query Insights


--  (ii) Disadvantages and Pitfalls
-- These exercises focus on when indexes can hurt performance or behave unexpectedly.

--      Exercise 1: The DML Overhead Pitfall
-- Problem:
-- You have a table that undergoes heavy bulk updates. Demonstrate the conceptual cost of having too many indexes.
-- Create three additional (and somewhat redundant) indexes on the customerOrders table: one on quantity, one on unitPrice, and a composite on (orderStatus, orderDate).
CREATE INDEX idx_redundantQuantity ON SPEEDUNLEASH.CUSTOMERORDERS(QUANTITY);
CREATE INDEX idx_redundantUnitPrice ON SPEEDUNLEASH.CUSTOMERORDERS(UNITPRICE);
CREATE INDEX idx_redundantOrderStatusOrderDate ON SPEEDUNLEASH.CUSTOMERORDERS(ORDERSTATUS, ORDERDATE);
-- Write an UPDATE statement that modifies the quantity and unitPrice for all 'PENDING' orders.
DECLARE
        TYPE orderIdsT IS TABLE OF SPEEDUNLEASH.CUSTOMERORDERS.ORDERID%TYPE INDEX BY PLS_INTEGER;
        orderIds orderIdsT;
BEGIN
        SELECT ORDERID BULK COLLECT INTO orderIds FROM SPEEDUNLEASH.CUSTOMERORDERS WHERE ORDERSTATUS = 'PENDING';
        FORALL i IN 1..orderIds.COUNT
                UPDATE SPEEDUNLEASH.CUSTOMERORDERS SET QUANTITY = QUANTITY * 1.1, UNITPRICE = UNITPRICE * 0.9 
                WHERE ORDERID = orderIds(i);
END;
/
-- Analysis: You don't need to run the UPDATE. Instead, explain step-by-step what Oracle must do behind the scenes when this single UPDATE statement is executed, 
-- considering all the indexes now on the table (PK_orderId, idxOrderProduct, idxOrderStatusBitmap, idxCustOrderDate, and the three new ones).
-- Answer: the process start by collecting the expected rows into a table to iterate along, then for each iteration is fetched the value to update and 
-- In this scenario is unmeaningful to have 3 indexes where they can be compressed by a single hierarchical composited index if they're really queries by such columns
-- With the three additional wont be even more unmeaningful but heavy slow becuase each index must computed with every updating, powering the necessary time and energy
-- completing the task

--      Exercise 2: The Non-SARGable Predicate Pitfall
-- Problem:
-- A developer needs to find all orders placed in the year 2023. They write a query using TO_CHAR(orderDate, 'YYYY') = '2023'. An index exists on orderDate. Explain 
-- why the index will not be used.
-- Answer: because the necessary filter must be fine grained and functional with TO_CHAR, a simple filter with orderDate is not useful.
-- Ensure an index exists on orderDate in the customerOrders table.
DROP INDEX idx_forOrderedDate;

DROP INDEX idx_forOrderedDate;
CREATE INDEX idx_forOrderedDate ON SPEEDUNLEASH.CUSTOMERORDERS(ORDERDATE);
-- DROP INDEX idx_forOrderedYear;
-- Generate the execution plan for the developer's query: SELECT COUNT(*) FROM customerOrders WHERE TO_CHAR(orderDate, 'YYYY') = '2023';.
SELECT COUNT(*) FROM SPEEDUNLEASH.customerOrders WHERE TO_CHAR(orderDate, 'YYYY') = '2023';
-- Analysis: Explain why the plan shows a TABLE ACCESS FULL and why this is inefficient.
EXPLAIN PLAN FOR SELECT COUNT(*) FROM SPEEDUNLEASH.customerOrders WHERE TO_CHAR(orderDate, 'YYYY') = '2023';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX idx_forOrderedYear;
CREATE INDEX idx_forOrderedYear ON SPEEDUNLEASH.CUSTOMERORDERS(TO_CHAR(ORDERDATE, 'YYYY'));
-- DROP INDEX idx_forOrderedYear;
EXPLAIN PLAN FOR SELECT COUNT(*) FROM SPEEDUNLEASH.customerOrders WHERE TO_CHAR(orderDate, 'YYYY') = '2023';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM USER_INDEXES WHERE TABLE_OWNER = 'SPEEDUNLEASH';