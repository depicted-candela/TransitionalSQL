        -- Future of Oracle: SQL Innovations in 23ai



--  (iii) Contrasting with Inefficient Common Solutions


--          Group 1: DDL and DML Enhancements

--      Problem 1: Inefficient Update vs. UPDATE FROM
-- Description: A policy change requires that the salary of every employee in the 'Engineering' department be updated to match the salary of employee 
-- 'Charlie Williams' (ID 103).
DECLARE
    vTargetSalary future.employees.salary%TYPE;
BEGIN
    -- Step 1: Query the database to get the value
    SELECT salary INTO vTargetSalary
    FROM future.employees
    WHERE employeeId = 103;
    -- Step 2: Use the fetched value in a separate UPDATE
    UPDATE future.employees
    SET salary = vTargetSalary
    WHERE departmentId = 20;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' engineering salaries updated.');
    ROLLBACK; -- Reset for next example
END;
/
-- First, solve this using a less efficient, two-step PL/SQL approach: a SELECT to get Charlie's salary into a variable, followed by an UPDATE.
-- Then, solve it using a more efficient, but correlated, UPDATE statement with a subquery in the SET clause.
UPDATE FUTURE.EMPLOYEES 
SET SALARY = (SELECT E2.SALARY FROM FUTURE.EMPLOYEES E2 WHERE E2.EMPLOYEEID = 103)
WHERE DEPARTMENTID = 20;
ROLLBACK;


--          Group 3: Advanced Data Types and Functions

--      Problem 1: Pre-23ai BOOLEAN vs. Native BOOLEAN
-- Description: Imagine the projectTasks table was designed in Oracle 19c. The isCompleted column would likely be 
-- isCompleted_legacy CHAR(1) CHECK (isCompleted_legacy IN ('Y', 'N')).
-- Step 1: Add and populate the legacy column
ALTER TABLE future.projectTasks ADD (isCompletedLegacy CHAR(1));
UPDATE future.projectTasks SET isCompletedLegacy = CASE WHEN isCompleted THEN 'Y' ELSE 'N' END;
COMMIT;

-- Step 2: Query using the less clear, legacy method
SELECT *
FROM future.projectTasks
WHERE isCompletedLegacy = 'Y';
-- Add this legacy column to the table and populate it.
-- Write a query to find completed tasks using the legacy column.
-- Compare the clarity and syntax with the native BOOLEAN query from the previous section.
SELECT * FROM FUTURE.PROJECTTASKS WHERE ISCOMPLETED; -- Extremally cleaner and faster