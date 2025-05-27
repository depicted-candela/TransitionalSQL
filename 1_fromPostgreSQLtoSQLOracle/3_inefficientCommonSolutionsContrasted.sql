        -- 1. From PostgreSQL to SQL ORACLE with ORACLE DB


--  3 Contrasting with Ineﬀicient Common Solutions

--      4.1 Exercise 3.1: Suboptimal Logic vs. Oracle SQL Eﬀiciency
-- 1. Client-Side NULL Handling: A developer fetches firstName and commissionRate
-- from EmployeeRoster. In their application code (e.g., Java/Python), they loop
-- through results: if commissionRate is null, they display ”$0.00”, otherwise
-- they display the actual rate.
-- • Show the eﬀicient Oracle SQL way to produce a commissionDisplay col-
-- umn directly using an Oracle NULL handling function.
SELECT FIRSTNAME, NVL2(COMMISSIONRATE, CONCAT('$', TO_CHAR(COMMISSIONRATE)), '$.00') 
FROM EMPLOYEEROSTER;
-- • What is the loss of advantage (e.g., performance, network traﬀic) with the
-- client-side approach?
-- Answer: Because SQL is made for performance and client applications are for meaningful
-- data representation, they does not need lots of data, instead meaningful reduced data.
-- Making giants reductions of data in the client-side means dont use the right technologies
-- for the right scenarios

-- 2. Client-Side Conditional Logic: For each product in ProductCatalog, if productCategory
-- is ’Software’, display ’Digital Good’. If ’Hardware’, display ’Physical Good’. Oth-
-- erwise, ’Misc Good’. This logic is currently in client code.
-- • Demonstrate the eﬀicient Oracle SQL way using a CASE expression.
SELECT PRODUCTCATEGORY, DECODE(PRODUCTCATEGORY, 'Software', 'Digital Good', 'Hardware', 'Physical Good', 'Misc Good') DECODING 
FROM PRODUCTCATALOG;
-- • Why is performing this categorization in SQL generally better than in client
-- code for reporting?
-- ANswer: here is less verbose and faster for giant datasets

--      4.2 Exercise 3.2: Ineﬀicient ROWNUM Usage and DUAL Misconceptions
--  1. Ineﬀicient DUAL Usage: A process needs to log the current timestamp and the
-- current user performing an action. The developer writes:
-- Get timestamp
-- SELECT SYSTIMESTAMP FROM DUAL; -- Result captured by app
-- Get user
-- SELECT USER FROM DUAL; -- Result captured by app
-- SELECT USER, SYSTIMESTAMP FROM DUAL;
-- Show the eﬀicient way. What Oracle value is lost by the ineﬀicient approach?

-- 2. Incorrect Top-N with ROWNUM: To find the 3 cheapest products *that are not
-- free* from ProductCatalog, a developer writes:
SELECT productName, unitPrice
FROM ProductCatalog
WHERE unitPrice > 0 AND ROWNUM <= 3 -- Attempt to filter non-free first, then take top 3
ORDER BY unitPrice ASC;
-- Explain why this is not guaranteed to give the 3 overall cheapest non-free prod-
-- ucts. Present the eﬀicient, correct Oracle-idiomatic way;
SELECT * FROM (
    SELECT productName, unitPrice
    FROM ProductCatalog
    WHERE unitPrice > 0
    ORDER BY unitPrice ASC
) WHERE ROWNUM <= 3;