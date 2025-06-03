        -- PL/SQL Fundamentals


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 3.1: Inefficient Conditional Salary Update
-- Problem: An employee's salary needs to be updated based on their jobTitle.
-- 'Clerk': +5%
-- 'Developer': +7%
-- 'Sales Manager': +10%
-- Inefficient Solution Approach: Write separate UPDATE statements for each jobTitle within individual IF conditions in PL/SQL.
SET SERVEROUTPUT ON;

-- Setup: Create a copy for safe updates
DROP TABLE IF EXISTS PLSQLAWAKENING.employeesTemp;
CREATE TABLE PLSQLAWAKENING.employeesTemp AS SELECT * FROM PLSQLAWAKENING.employees;
COMMIT;

-- Inefficient PL/SQL approach
DECLARE
    empId PLSQLAWAKENING.employeesTemp.employeeId%TYPE;
    empJob PLSQLAWAKENING.employeesTemp.jobTitle%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inefficient Conditional Update (using multiple IFs and UPDATEs) ---');
    FOR empRec IN (SELECT employeeId, jobTitle FROM PLSQLAWAKENING.employeesTemp WHERE jobTitle IN ('Clerk', 'Developer', 'Sales Manager')) LOOP
        empId := empRec.employeeId;
        empJob := empRec.jobTitle;
        IF empJob = 'Clerk' THEN
            UPDATE PLSQLAWAKENING.employeesTemp SET salary = salary * 1.05 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Clerk salary for ' || empId);
        ELSIF empJob = 'Developer' THEN
            UPDATE PLSQLAWAKENING.employeesTemp SET salary = salary * 1.07 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Developer salary for ' || empId);
        ELSIF empJob = 'Sales Manager' THEN
            UPDATE PLSQLAWAKENING.employeesTemp SET salary = salary * 1.10 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Sales Manager salary for ' || empId);
        END IF;
    END LOOP;

    COMMIT; -- Revert changes made by inefficient approach
    DBMS_OUTPUT.PUT_LINE('Inefficient COMMITTED.');
END;
/

-- Re-populate employeesTemp for the efficient approach or use original table
DROP TABLE PLSQLAWAKENING.employeesTemp;
CREATE TABLE PLSQLAWAKENING.employeesTemp AS SELECT * FROM PLSQLAWAKENING.employees;
COMMIT;

-- Efficient Oracle-idiomatic Solution: Use a single UPDATE statement with a CASE expression directly in the SQL.
UPDATE PLSQLAWAKENING.EMPLOYEESTEMP         -- Obviously less verbose and efficiency enhanced
SET SALARY = CASE 
    WHEN JOBTITLE = 'Sales Manager' THEN SALARY * 1.1 
    WHEN JOBTITLE = 'Developer' THEN SALARY * 1.07 
    WHEN JOBTITLE = 'Clerk' THEN SALARY * 1.05 
END;
COMMIT;
DROP TABLE PLSQLAWAKENING.EMPLOYEESTEMP;

-- Demonstrate both approaches. Explain why the second is better.
-- Contrast Focus: The inefficient PL/SQL approach involves multiple context switches between PL/SQL and SQL engines if done iteratively for many employees, or 
-- multiple separate DML statements. The efficient SQL approach performs the conditional logic within a single SQL statement, reducing overhead and often 
-- allowing for better optimization by the SQL engine.

--      Exercise 3.2: Inefficient Row-by-Row Processing vs. SQL JOIN
-- Problem: You need to find the departmentName for each employee in the employees table and print employeeId, lastName, and departmentName.
-- Inefficient Solution Approach (Common for procedural thinkers): Loop through each employee, and inside the loop, execute a separate SELECT statement to fetch 
-- the department name for that employee's departmentId. 
SET SERVEROUTPUT ON;
-- Inefficient PL/SQL row-by-row approach
DECLARE
    deptName departments.departmentName%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inefficient Row-by-Row Department Lookup ---');
    FOR empRec IN (SELECT employeeId, lastName, departmentId FROM employees ORDER BY employeeId) LOOP
        BEGIN -- Inner block for individual SELECT INTO exception handling
            SELECT departmentName
            INTO deptName
            FROM departments
            WHERE departmentId = empRec.departmentId;

            DBMS_OUTPUT.PUT_LINE(
                'EmpID: ' || empRec.employeeId ||
                ', Name: ' || empRec.lastName ||
                ', Dept: ' || deptName
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE(
                    'EmpID: ' || empRec.employeeId ||
                    ', Name: ' || empRec.lastName ||
                    ', Dept: NOT FOUND'
                );
        END;
    END LOOP;
END;
/
-- Efficient Oracle-idiomatic Solution: Use a single SQL SELECT statement with a JOIN between employees and departments. (If PL/SQL is strictly required for some other
-- processing, fetch all necessary data in one go using a cursor FOR loop on the joined query).
SET SERVEROUTPUT ON;
BEGIN
    FOR empRec IN (SELECT EMPLOYEEID, LASTNAME, DEPARTMENTNAME 
    FROM PLSQLAWAKENING.EMPLOYEES
    NATURAL JOIN PLSQLAWAKENING.DEPARTMENTS) LOOP
        DBMS_OUTPUT.PUT_LINE(
                'EmpID: ' || empRec.employeeId ||
                ', Name: ' || empRec.lastName ||
                ', Dept: ' || empRec.departmentName
            );
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- Obviously betteer using joins instead of the N+1 problem presented with the iterative approach
