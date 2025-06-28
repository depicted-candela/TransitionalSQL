        -- Future of Oracle: SQL Innovations in 23ai



--  (ii) Disadvantages and Pitfalls


--          Group 1: DDL and DML Enhancements

--      Problem 1: RETURNING INTO with Multiple Rows
-- Description: Write a PL/SQL anonymous block. Attempt to delete all employees from the 'Sales' department and use RETURNING employeeId INTO ... to capture the ID of 
-- the deleted employee into a single NUMBER variable. Execute the block and analyze the error. Then, provide the corrected solution that handles multiple returned 
-- rows.
DECLARE -- singular: incorrect for multiple rows
    TYPE employeeIdsT IS TABLE OF FUTURE.EMPLOYEES.EMPLOYEEID%TYPE;
    employeeIds employeeIdsT;
BEGIN
    SAVEPOINT disadvantages_1_1;
    DELETE FROM FUTURE.EMPLOYEES WHERE EMPLOYEEID IN (SELECT EMPLOYEEID FROM FUTURE.EMPLOYEES NATURAL JOIN FUTURE.DEPARTMENTS) RETURNING EMPLOYEEID INTO employeeIds;
END;
/

DECLARE -- plural: correct
    TYPE employeeIdsT IS TABLE OF FUTURE.EMPLOYEES.EMPLOYEEID%TYPE;
    employeeIds employeeIdsT;
BEGIN
    SAVEPOINT disadvantages_1_1;
    DELETE FROM FUTURE.EMPLOYEES WHERE EMPLOYEEID IN (
        SELECT EMPLOYEEID FROM FUTURE.EMPLOYEES NATURAL JOIN FUTURE.DEPARTMENTS
    ) RETURNING EMPLOYEEID BULK COLLECT INTO employeeIds;
END;
/

--          Group 2: Querying Conveniences

--      Problem 1: Logical Processing Order Pitfall
-- Description: Try to filter the results of an aggregate query using the GROUP BY alias in the WHERE clause. For example, calculate total sales by region and only 
-- show regions where the aliased totalSales is greater than 3000. Why does this fail? How do you correctly filter on an aggregate result?
SELECT REGION regionalSales, SUM(SALESAMOUNT) TOTALSALES FROM FUTURE.REGIONALSALES GROUP BY REGION WHERE TOTALSALES > 3000;
-- The error is: ORA-03048: SQL reserved word 'WHERE' is not syntactically valid following '...REGIONALSALES GROUP BY REGION ' https://docs.oracle.com/error-help/db/ora-03048/
-- An unexpected keyword was encountered in the SQL statement at or near the position printed in the error message. One of the following occurred: 1. You had a typo in your SQL statement. 2. Unsupported syntax was encountered for a clause in the statement. 3. An unsupported clause was encountered in the statement. 4. A string was terminated prematurely leading to the rest of the string to be interpreted as keywords. For example, an apostrophe in the string may be causing it to end prematurely
-- Error at Line: 1 Column: 98