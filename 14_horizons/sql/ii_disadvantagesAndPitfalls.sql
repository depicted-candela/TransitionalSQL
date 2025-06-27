        -- Oracle Horizons: Connecting with Cutting-Edge Tech


--  Exercise II: Disadvantages and Pitfalls

--      Exercise 2.1: The Pitfall of Inefficient XML Querying
-- Problem

-- A developer needs to find the quantity for partNumber "40" for the order with anbr 'ORD202' from the orderDetails table. They write the following query, which works 
-- but is suboptimal because the EXTRACTVALUE function is deprecated.
-- Inefficient and Deprecated Query
SELECT EXTRACTVALUE(od.detailXML, '/order/items/item/@quantity') AS quantity
FROM HORIZONS.ORDERDETAILS od
WHERE EXTRACTVALUE(od.detailXML, '/order/items/item/@partNumber') = '40' AND EXTRACTVALUE(od.detailXML, '/order/@anbr') = 'ORD202';
-- What is the primary performance pitfall of using this function-per-value approach, especially on documents with many attributes and nodes, compared to the modern 
-- SQL/XML standard functions?
-- Answer: The problem is about design, EXTRACTVALUE only cares for fetching a single row with specific features, not all of them, because the WHERE filtering is based on two
-- conditions, the engine does not know which row to use