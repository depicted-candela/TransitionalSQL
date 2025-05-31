        -- Exercise Block 3: Set Operators (Practice in Oracle)


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 3.1.1: Oracle Set Operators - MINUS, INTERSECT, UNION
-- Problem:
-- a. List all productId and productName from ProductCatalogA that are *not* present with the exact same productId and productName in ProductCatalogB. Use the
-- Oracle-specific MINUS operator. Explain its relation to PostgreSQL's EXCEPT.
SELECT PRODUCTID, PRODUCTNAME FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PRODUCTCATALOGA
        MINUS -- This is the same to PostgreSQL's EXCEPT.
SELECT PRODUCTID, PRODUCTNAME FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PRODUCTCATALOGB;
-- b. List all productId and productName that are common to *both* ProductCatalogA and ProductCatalogB (i.e., productId and productName are identical in both). 
-- Use INTERSECT.
SELECT PRODUCTID, PRODUCTNAME FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PRODUCTCATALOGA
        INTERSECT
SELECT PRODUCTID, PRODUCTNAME FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PRODUCTCATALOGB;
-- c. List all unique productId and productName combinations present in *either* ProductCatalogA *or* ProductCatalogB (or both). Use UNION.
SELECT PRODUCTID, PRODUCTNAME FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PRODUCTCATALOGA
        UNION
SELECT PRODUCTID, PRODUCTNAME FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PRODUCTCATALOGB;
-- d. What are the requirements for the SELECT lists regarding number of columns and data types when using these set operators in Oracle?
-- Answer: both sets of properties must be the same (where 'both' means: number of columns and data taypes) in the two sets to be operated.
-- THe column names are defined in the result table with the column names of the first declared set in the set operation, thus names in
-- both tables does not need to be the same


--  (ii) Disadvantages and Pitfalls

--      Exercise 3.2.1: Set Operator Pitfalls in Oracle
-- Problem:
-- a. A developer wants to combine all rows from ProductCatalogA and ProductCatalogB, including duplicates if a product appears in both with identical details. 
-- They use UNION. What is the pitfall? What should they use?
-- Answer: UNION gets all the not repeated elements in both sets, this operations requires nested comparisons to know if something already exists in the
-- joined SET
-- b. If MINUS or INTERSECT is used on queries selecting CLOB columns, what happens? What is the general limitation for LOB types with set operators?
-- Answer: LOB types are not prone to be operated with SET operations because they could be too complex to be compared and thus comparisons for such objects
-- could be highly energy consumers, thus ORACLE does not have them developed despite could exists solutions for such complex set operations
-- c. Consider (SELECT departmentId FROM Employees WHERE departmentId = 10) MINUS (SELECT departmentId FROM Employees WHERE departmentId = 20);. 
-- What is the result and why? 
-- Answer: the result is SELECT departmentId FROM Employees WHERE departmentId = 10 because there is not exists common elements between the result of both
-- queries
-- What if it was (SELECT departmentId FROM Employees WHERE departmentId = 10) MINUS (SELECT departmentId FROM Employees WHERE departmentId = 10);?
-- Answer: is the empty query
-- d. The order of operations for multiple set operators (e.g., Q1 UNION Q2 MINUS Q3) can be ambiguous without parentheses. How does Oracle evaluate them by 
-- default? Why is using parentheses good practice?
-- Answer: the default order is top to bottom and left to right, parenthesis are used similar to normal arithmetic to order operands and operators. But
-- similar to arithmetic where multiplication goes before to addition, INTERSECT goes before to the other SET operators


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 3.3.1: Finding Disjoint Sets - MINUS vs. Multiple NOT IN/NOT EXISTS
-- Problem: You need to identify all departmentIds that have employees listed in the Employees table but are *not* present in a predefined list of 'approved' 
-- department IDs (e.g., 20, 40).
-- Less Efficient/More Complex Common Solution: A developer might use SELECT DISTINCT departmentId FROM Employees WHERE departmentId NOT IN (20, 40). While this 
-- works for simple lists, consider if the "approved list" came from another table and had many values, or involved multiple columns for exclusion. The use of 
-- NOT IN can also have pitfalls with NULL values in the subquery/list.
-- Explain potential issues with NOT IN especially if the subquery for NOT IN could return NULL.
-- Show how MINUS offers a clear and robust alternative, especially if the "approved list" is also derived from a query.
CREATE TABLE ESSENTIAL_FUNCTIONS_DMLBASICS.ApprovedDepartments (departmentId NUMBER PRIMARY KEY);
INSERT INTO ESSENTIAL_FUNCTIONS_DMLBASICS.ApprovedDepartments (departmentId) VALUES (20);
INSERT INTO ESSENTIAL_FUNCTIONS_DMLBASICS.ApprovedDepartments (departmentId) VALUES (40);
COMMIT;
SELECT DISTINCT departmentId -- Less efficient way
FROM Employees
WHERE departmentId IS NOT NULL
  AND departmentId NOT IN (SELECT departmentId FROM ApprovedDepartments);
-- Performant and safe way
SELECT DEPARTMENTID FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE DEPARTMENTID IS NOT NULL
        MINUS
SELECT DEPARTMENTID FROM ESSENTIAL_FUNCTIONS_DMLBASICS.ApprovedDepartments WHERE DEPARTMENTID IS NOT NULL;
DROP TABLE ESSENTIAL_FUNCTIONS_DMLBASICS.ApprovedDepartments;
COMMIT;