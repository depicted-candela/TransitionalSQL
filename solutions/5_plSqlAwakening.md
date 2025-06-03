<head>
    <link rel="stylesheet" href="../styles/exercises.css">
</head>

<div class="container">

# PL/SQL Awakening: Foundations of Oracle Programming - Solutions

Welcome, PostgreSQL voyager, to the realm of Oracle's PL/SQL! These exercises, now with their solutions, are your compass and sextant for navigating the foundational currents of Oracle's procedural language. Your existing SQL strength is a mighty ship, and these practices will hoist the Oracle sails.

_With solutions clear, your path is made,_
_No PL/SQL puzzle leaves you swayed!_

## Learning Objectives

By reviewing these solutions and working through the exercises, you should be able to:

*   Confirm your understanding of the basic block structure of PL/SQL (`DECLARE`, `BEGIN`, `EXCEPTION`, `END`).
*   Verify your ability to declare and use scalar variables, constants, and anchor them using `%TYPE` and `%ROWTYPE`.
*   Check your implementation of conditional logic using `IF-THEN-ELSIF-ELSE` and `CASE` statements/expressions.
*   Assess your control over program flow with iterative constructs: basic `LOOP`, `WHILE` loop, and `FOR` loop.
*   Validate your integration of SQL (`SELECT INTO`, DML) within PL/SQL blocks.
*   Confirm effective use of `DBMS_OUTPUT.PUT_LINE` for basic debugging and displaying information.
*   Reinforce Oracle-specific nuances, especially when contrasting with your PostgreSQL background.
*   Identify and understand solutions to potential pitfalls in PL/SQL code.
*   Appreciate the conceptual benefit of Oracle 23ai features like the SQL Transpiler for PL/SQL functions used in SQL.

## Prerequisites & Setup

To make these exercises a breeze,
A bit of knowledge, if you please!

*   **Foundational SQL:** Solid understanding of SQL concepts from "The Original PostgreSQL Course Sequence" (especially Basic and Intermediate SQL).
*   **Oracle Core Syntax:** Familiarity with concepts from the "Key Differences & Core Syntax" and "Date Functions" sections of the "Server Programming with Oracle (DB 23ai) PL/SQL: A Transition Guide for PostgreSQL Users" course.
*   **Oracle Environment:** Access to an Oracle DB 23ai instance (Oracle Live SQL is a great option for many of these, or a local/cloud instance).

### Dataset Guidance

A practice ground, so neat and trim,
For every PL/SQL whim!

The Oracle SQL script below defines and populates the necessary tables for these exercises. It's crucial to run this script in your Oracle environment *before* you attempt the exercises or review the solutions.

<div class="oracle-specific">
<strong>Setup Tip:</strong> You can typically run this script in SQL Developer by opening a new SQL worksheet, pasting the code, and clicking the "Run Script" button (often an icon with a green play button and a page). For SQL*Plus, save it as a `.sql` file and run it using `@dataset.sql`. For Oracle Live SQL, paste it into a SQL Worksheet and click "Run". Ensure `SERVEROUTPUT` is enabled to see `DBMS_OUTPUT.PUT_LINE` results.
</div>

The primary tables you'll be working with are:

*   `departments`: Stores department information.
*   `employees`: Stores employee details, including their department, salary, and hire date. The `isActive` column uses the new Oracle 23ai `BOOLEAN` type.
*   `jobGrades`: Defines salary ranges for different job grades.
*   `products`: Contains product information, including stock levels.
*   `salesLog`: A simple table for logging messages, useful for tracking DML operations or debugging.
*   `salesOrders` and `orderItems`: For order-related scenarios.

Relationships are established via foreign keys (e.g., `employees.departmentId` references `departments.departmentId`).

## Exercise Structure Overview

The path to mastery, clear and bright,
Four types of tests, to shed new light!

These exercises are structured to build your understanding progressively:

1.  **Meanings, Values, Relations, and Advantages:** Focus on the core definition and benefits of each concept, especially Oracle's unique take.
2.  **Disadvantages and Pitfalls:** Explore common mistakes and limitations.
3.  **Contrasting with Inefficient Common Solutions:** Compare elegant Oracle solutions with less optimal, often more verbose, alternatives.
4.  **Hardcore Combined Problem:** A capstone challenge integrating multiple concepts.

## Solutions to PL/SQL Fundamentals Exercises

Below are the solutions to the exercises. Compare them with your attempts to solidify your understanding.

---

### (i) Meanings, Values, Relations, and Advantages - Solutions

#### Solution for Exercise 1.1: Understanding PL/SQL Block Structure
```sql
SET SERVEROUTPUT ON;

DECLARE
    greeting VARCHAR2(50);
BEGIN
    greeting := 'Hello, Oracle PL/SQL!';
    DBMS_OUTPUT.PUT_LINE(greeting);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 1.2: Using Scalar Variables, %TYPE, and %ROWTYPE
```sql
SET SERVEROUTPUT ON;

DECLARE
    empLastName employees.lastName%TYPE;
    empRecord employees%ROWTYPE;
    vEmployeeId1 NUMBER := 101;
    vEmployeeId2 NUMBER := 102;
BEGIN
    -- Fetch lastName for employee 101
    SELECT lastName
    INTO empLastName
    FROM employees
    WHERE employeeId = vEmployeeId1;

    DBMS_OUTPUT.PUT_LINE('Last name of employee ' || vEmployeeId1 || ': ' || empLastName);

    -- Fetch entire row for employee 102
    SELECT *
    INTO empRecord
    FROM employees
    WHERE employeeId = vEmployeeId2;

    DBMS_OUTPUT.PUT_LINE('Details for employee ' || vEmployeeId2 || ':');
    DBMS_OUTPUT.PUT_LINE('  First Name: ' || empRecord.firstName);
    DBMS_OUTPUT.PUT_LINE('  Salary: ' || empRecord.salary);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 1.3: Conditional Logic with IF-THEN-ELSIF-ELSE and CASE
```sql
SET SERVEROUTPUT ON;

DECLARE
    empSalary employees.salary%TYPE;
    empId NUMBER := 103;
    salaryCategory VARCHAR2(20);
BEGIN
    SELECT salary
    INTO empSalary
    FROM employees
    WHERE employeeId = empId;

    DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' salary: ' || empSalary);

    -- Using IF-THEN-ELSIF-ELSE
    DBMS_OUTPUT.PUT_LINE('--- Using IF-THEN-ELSIF-ELSE ---');
    IF empSalary > 75000 THEN
        DBMS_OUTPUT.PUT_LINE('Category: High Earner');
    ELSIF empSalary > 65000 THEN -- No need to check <= 75000 due to IF structure
        DBMS_OUTPUT.PUT_LINE('Category: Mid Earner');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Category: Standard Earner');
    END IF;

    -- Using CASE Statement
    DBMS_OUTPUT.PUT_LINE('--- Using CASE Statement ---');
    CASE
        WHEN empSalary > 75000 THEN
            salaryCategory := 'High Earner';
        WHEN empSalary > 65000 THEN
            salaryCategory := 'Mid Earner';
        ELSE
            salaryCategory := 'Standard Earner';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('Category: ' || salaryCategory);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 1.4: Iterative Control with Basic LOOP, WHILE, and FOR
```sql
SET SERVEROUTPUT ON;

DECLARE
    counter NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Basic LOOP ---');
    counter := 1;
    LOOP
        DBMS_OUTPUT.PUT_LINE(counter);
        EXIT WHEN counter >= 3;
        counter := counter + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- WHILE LOOP ---');
    counter := 1;
    WHILE counter <= 3 LOOP
        DBMS_OUTPUT.PUT_LINE(counter);
        counter := counter + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Numeric FOR LOOP ---');
    FOR i IN 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/
```

#### Solution for Exercise 1.5: SQL within PL/SQL (SELECT INTO, DML, DBMS_OUTPUT)
```sql
SET SERVEROUTPUT ON;

DECLARE
    deptName departments.departmentName%TYPE;
    vDepartmentId NUMBER := 20;
    logMessageContent VARCHAR2(200);
BEGIN
    -- 1. SELECT INTO
    SELECT departmentName
    INTO deptName
    FROM departments
    WHERE departmentId = vDepartmentId;

    -- 2. DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Retrieved Department: ' || deptName);

    -- 3. INSERT
    logMessageContent := 'Department lookup successful: ' || deptName;
    INSERT INTO salesLog (logMessage) VALUES (logMessageContent);
    DBMS_OUTPUT.PUT_LINE('Log entry inserted.');

    -- 4. UPDATE
    UPDATE departments
    SET location = 'MANCHESTER'
    WHERE departmentId = vDepartmentId;
    DBMS_OUTPUT.PUT_LINE('Department ' || vDepartmentId || ' location updated to MANCHESTER.');
    
    -- 5. DELETE
    DELETE FROM salesLog WHERE logMessage = logMessageContent;
    DBMS_OUTPUT.PUT_LINE('Log entry deleted.');

    -- Rollback changes for subsequent runs of this script to work consistently
    ROLLBACK; 
    DBMS_OUTPUT.PUT_LINE('Changes rolled back for script re-runnability.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Department ' || vDepartmentId || ' not found.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK; -- Rollback in case of other errors
END;
/
```

---

### (ii) Disadvantages and Pitfalls - Solutions

#### Solution for Exercise 2.1: PL/SQL Block - Unhandled Exceptions Pitfall
**Solution (Initial - to show error):**
```sql
SET SERVEROUTPUT ON;

DECLARE
    empSalary employees.salary%TYPE;
BEGIN
    SELECT salary
    INTO empSalary
    FROM employees
    WHERE employeeId = 999; -- This employee does not exist

    DBMS_OUTPUT.PUT_LINE('Salary: ' || empSalary);
END;
/
-- Expected ORA-01403: no data found
```

**Solution (Modified - with EXCEPTION block):**
```sql
SET SERVEROUTPUT ON;

DECLARE
    empSalary employees.salary%TYPE;
BEGIN
    SELECT salary
    INTO empSalary
    FROM employees
    WHERE employeeId = 999; -- This employee does not exist

    DBMS_OUTPUT.PUT_LINE('Salary: ' || empSalary); -- This line won't be reached
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pitfall: Employee with ID 999 not found. NO_DATA_FOUND raised.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 2.2: Variables & Constants - %TYPE/%ROWTYPE and Dropped Columns
```sql
SET SERVEROUTPUT ON;

-- Step 1: Create temporary table
CREATE TABLE tempEmployees AS
SELECT employeeId, firstName, lastName, salary FROM employees WHERE 1=2; 

INSERT INTO tempEmployees (employeeId, firstName, lastName, salary)
SELECT employeeId, firstName, lastName, salary FROM employees WHERE ROWNUM <=1;
COMMIT;


-- Step 2: PL/SQL block (initial run)
DECLARE
    empRec tempEmployees%ROWTYPE;
BEGIN
    SELECT *
    INTO empRec
    FROM tempEmployees
    WHERE employeeId = (SELECT MIN(employeeId) FROM tempEmployees); -- Select any existing employee

    IF empRec.employeeId IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Initial run - Employee Salary: ' || empRec.salary);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Initial run - No employee found in tempEmployees.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Initial run - No employee found in tempEmployees.');
END;
/

-- Step 3: Drop column (outside PL/SQL)
ALTER TABLE tempEmployees DROP COLUMN salary;


-- Step 4: Re-run PL/SQL block
-- This block will now likely fail when recompiled because empRec.salary no longer exists.
DECLARE
    empRec tempEmployees%ROWTYPE; -- %ROWTYPE now reflects table without salary
BEGIN
    SELECT employeeId, firstName, lastName -- Must explicitly list columns now
    INTO empRec.employeeId, empRec.firstName, empRec.lastName -- Assign to available fields
    FROM tempEmployees
    WHERE employeeId = (SELECT MIN(employeeId) FROM tempEmployees);

    DBMS_OUTPUT.PUT_LINE('After column drop - Employee ID: ' || empRec.employeeId);
    -- Accessing empRec.salary would cause PLS-00302: component 'SALARY' must be declared
    -- DBMS_OUTPUT.PUT_LINE(empRec.salary); 
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error after column drop: ' || SQLERRM);
END;
/

-- Cleanup
DROP TABLE tempEmployees;
```
**Note:** The re-run of the PL/SQL block after dropping the column will fail compilation if `empRec.salary` is still referenced. The provided solution shows how you'd have to adjust the `SELECT INTO` if you were to avoid the compilation error, but typically the goal is to show the error that would occur from not updating the PL/SQL code.

#### Solution for Exercise 2.3: Conditional Control - CASE Statement without ELSE and No Match
```sql
SET SERVEROUTPUT ON;

DECLARE
    empJobTitle employees.jobTitle%TYPE;
    jobCategory VARCHAR2(30);
    vEmployeeId NUMBER := 101; -- Employee with jobTitle 'Clerk'
BEGIN
    SELECT jobTitle
    INTO empJobTitle
    FROM employees
    WHERE employeeId = vEmployeeId;

    DBMS_OUTPUT.PUT_LINE('Employee ' || vEmployeeId || ' job title: ' || empJobTitle);

    CASE empJobTitle
        WHEN 'Sales Manager' THEN
            jobCategory := 'Management';
        WHEN 'Developer' THEN
            jobCategory := 'Technical';
        -- No WHEN for 'Clerk' and no ELSE clause
    END CASE;

    DBMS_OUTPUT.PUT_LINE('Job Category: ' || jobCategory); -- This might not be reached

EXCEPTION
    WHEN CASE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pitfall: CASE_NOT_FOUND exception raised. Job title not covered and no ELSE.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 2.4: Iterative Control - Infinite Basic LOOP
**Solution (Illustrating Pitfall - DO NOT RUN IN PRODUCTION without care):**
```sql
-- SET SERVEROUTPUT ON;
-- 
-- DECLARE
--    counter NUMBER := 1;
-- BEGIN
--    DBMS_OUTPUT.PUT_LINE('--- Infinite LOOP Pitfall (DO NOT RUN UNCONTROLLED) ---');
--    LOOP
--        DBMS_OUTPUT.PUT_LINE('Counter: ' || counter);
--        -- counter := counter + 1; -- Increment forgotten
--        -- EXIT WHEN counter > 5; -- Exit condition forgotten or flawed
--    END LOOP;
-- END;
-- /
```
**Solution (Corrected):**
```sql
SET SERVEROUTPUT ON;

DECLARE
    counter NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Corrected Basic LOOP ---');
    LOOP
        DBMS_OUTPUT.PUT_LINE('Counter: ' || counter);
        counter := counter + 1; -- Increment added
        EXIT WHEN counter > 5; -- Exit condition added
    END LOOP;
END;
/
```

#### Solution for Exercise 2.5: SQL within PL/SQL - `SELECT INTO` with Multiple Rows
```sql
SET SERVEROUTPUT ON;

DECLARE
    empLastName employees.lastName%TYPE;
    vDepartmentId NUMBER := 40; -- This department has multiple employees
BEGIN
    DBMS_OUTPUT.PUT_LINE('Attempting to select last names from department ' || vDepartmentId);
    SELECT lastName
    INTO empLastName
    FROM employees
    WHERE departmentId = vDepartmentId;

    DBMS_OUTPUT.PUT_LINE('Last Name: ' || empLastName); -- This line won't be reached
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Pitfall: TOO_MANY_ROWS exception. Department ' || vDepartmentId || ' has multiple employees.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

---

### (iii) Contrasting with Inefficient Common Solutions - Solutions

#### Solution for Exercise 3.1: Inefficient Conditional Salary Update
```sql
SET SERVEROUTPUT ON;

-- Setup: Create a copy for safe updates
CREATE TABLE employeesTemp AS SELECT * FROM employees;
COMMIT;

-- Inefficient PL/SQL approach
DECLARE
    empId employeesTemp.employeeId%TYPE;
    empJob employeesTemp.jobTitle%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inefficient Conditional Update (using multiple IFs and UPDATEs) ---');
    
    FOR empRec IN (SELECT employeeId, jobTitle FROM employeesTemp WHERE jobTitle IN ('Clerk', 'Developer', 'Sales Manager')) LOOP
        empId := empRec.employeeId;
        empJob := empRec.jobTitle;

        IF empJob = 'Clerk' THEN
            UPDATE employeesTemp SET salary = salary * 1.05 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Clerk salary for ' || empId);
        ELSIF empJob = 'Developer' THEN
            UPDATE employeesTemp SET salary = salary * 1.07 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Developer salary for ' || empId);
        ELSIF empJob = 'Sales Manager' THEN
            UPDATE employeesTemp SET salary = salary * 1.10 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Sales Manager salary for ' || empId);
        END IF;
    END LOOP;
    
    -- Verification
    FOR r_emp IN (SELECT employeeId, jobTitle, salary FROM employeesTemp WHERE employeeId IN (101, 102, 103)) LOOP
        DBMS_OUTPUT.PUT_LINE(r_emp.jobTitle || ' (' || r_emp.employeeId || ') new salary: ' || r_emp.salary);
    END LOOP;

    ROLLBACK; -- Revert changes made by inefficient approach
    DBMS_OUTPUT.PUT_LINE('Inefficient changes rolled back.');
END;
/

-- Re-populate employeesTemp for the efficient approach or use original table
DROP TABLE employeesTemp;
CREATE TABLE employeesTemp AS SELECT * FROM employees;
COMMIT;

-- Efficient Oracle-idiomatic SQL approach
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Efficient Conditional Update (single UPDATE with CASE) ---');

    UPDATE employeesTemp
    SET salary = salary *
        CASE jobTitle
            WHEN 'Clerk' THEN 1.05
            WHEN 'Developer' THEN 1.07
            WHEN 'Sales Manager' THEN 1.10
            ELSE 1.00 -- No change for others
        END
    WHERE jobTitle IN ('Clerk', 'Developer', 'Sales Manager');

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' employee(s) salaries potentially updated.');

    -- Verification
    FOR empRec IN (SELECT employeeId, firstName, lastName, jobTitle, salary FROM employeesTemp WHERE employeeId IN (101, 102, 103)) LOOP
        DBMS_OUTPUT.PUT_LINE(
            empRec.firstName || ' ' || empRec.lastName || 
            ' (' || empRec.jobTitle || ') new salary: ' || empRec.salary
        );
    END LOOP;
    
    ROLLBACK; -- Revert changes
    DBMS_OUTPUT.PUT_LINE('Efficient changes rolled back.');
END;
/

-- Cleanup
DROP TABLE employeesTemp;
```

#### Solution for Exercise 3.2: Inefficient Row-by-Row Processing vs. SQL JOIN
```sql
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

-- Efficient Oracle-idiomatic SQL JOIN approach (demonstrated via PL/SQL FOR loop for output)
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Efficient SQL JOIN Approach ---');
    FOR rec IN (
        SELECT e.employeeId, e.lastName, d.departmentName
        FROM employees e
        LEFT JOIN departments d ON e.departmentId = d.departmentId -- LEFT JOIN to include employees without departments
        ORDER BY e.employeeId
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'EmpID: ' || rec.employeeId ||
            ', Name: ' || rec.lastName ||
            ', Dept: ' || NVL(rec.departmentName, 'N/A')
        );
    END LOOP;
END;
/
```

---

### (iv) Hardcore Combined Problem - Solution
```sql
SET SERVEROUTPUT ON;
SET DEFINE OFF; 

DECLARE
    -- Constants
    bonusThresholdDate CONSTANT DATE := TO_DATE('01-JAN-2021', 'YYYY-MM-DD');

    -- Variables
    vProcessedCount PLS_INTEGER := 0;

    -- Record for bonus info
    TYPE typeEmpBonusInfo IS RECORD (
        empId employees.employeeId%TYPE,
        fullName VARCHAR2(101), 
        yearsOfService NUMBER,
        potentialBonus NUMBER(10,2),
        departmentLocation departments.location%TYPE
    );
    empBonusInfo typeEmpBonusInfo;

    employeeReportXML XMLTYPE;
    isHighPerformer BOOLEAN := FALSE;

    -- For DML operations
    vNewCommission employees.commissionPct%TYPE;
    logMessage VARCHAR2(255);

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Employee Bonus Processing ---');

    FOR emp IN (
        SELECT e.employeeId, e.firstName, e.lastName, e.hireDate, e.jobTitle, e.salary, e.commissionPct, e.departmentId, d.departmentName AS deptNameActual
        FROM employees e
        JOIN departments d ON e.departmentId = d.departmentId
        WHERE d.departmentName IN ('IT', 'SALES') AND e.hireDate < bonusThresholdDate AND e.isActive = TRUE
        ORDER BY e.employeeId
    ) LOOP
        vProcessedCount := vProcessedCount + 1;

        empBonusInfo.empId := emp.employeeId;
        empBonusInfo.fullName := emp.firstName || ' ' || emp.lastName;
        empBonusInfo.yearsOfService := TRUNC(MONTHS_BETWEEN(SYSDATE, emp.hireDate) / 12);

        CASE emp.jobTitle
            WHEN 'IT Manager' THEN empBonusInfo.potentialBonus := emp.salary * 0.15;
            WHEN 'Sales Manager' THEN empBonusInfo.potentialBonus := emp.salary * 0.20;
            WHEN 'Developer' THEN empBonusInfo.potentialBonus := emp.salary * 0.10;
            WHEN 'Sales Representative' THEN empBonusInfo.potentialBonus := emp.salary * 0.12;
            ELSE empBonusInfo.potentialBonus := emp.salary * 0.05;
        END CASE;

        BEGIN
            SELECT location
            INTO empBonusInfo.departmentLocation
            FROM departments
            WHERE departmentId = emp.departmentId;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                empBonusInfo.departmentLocation := 'UNKNOWN_LOCATION_ERROR';
                DBMS_OUTPUT.PUT_LINE('Warning: Department location not found for employee ID ' || emp.employeeId || '. Department ID: ' || emp.departmentId);
        END;

        isHighPerformer := FALSE; -- Reset for each employee

        IF empBonusInfo.yearsOfService > 3 AND empBonusInfo.potentialBonus > 10000 THEN
            isHighPerformer := TRUE;
            
            vNewCommission := NVL(emp.commissionPct, 0) + 0.01;
            IF vNewCommission > 0.25 THEN
                vNewCommission := 0.25;
            END IF;

            UPDATE employees
            SET commissionPct = vNewCommission
            WHERE employeeId = emp.employeeId;

            logMessage := 'High performer bonus review for ' || empBonusInfo.fullName || ', New Commission: ' || TO_CHAR(vNewCommission);
            INSERT INTO salesLog (logMessage) VALUES (logMessage);

            DBMS_OUTPUT.PUT_LINE(
                empBonusInfo.fullName || 
                ' | Years: ' || empBonusInfo.yearsOfService ||
                ' | Bonus: ' || empBonusInfo.potentialBonus ||
                ' | Location: ' || empBonusInfo.departmentLocation ||
                ' | Status: High Performer, Commission Updated to ' || vNewCommission
            );
        ELSE
            logMessage := 'Standard review for ' || empBonusInfo.fullName;
            INSERT INTO salesLog (logMessage) VALUES (logMessage);
            
            DBMS_OUTPUT.PUT_LINE(
                empBonusInfo.fullName || 
                ' | Years: ' || empBonusInfo.yearsOfService ||
                ' | Bonus: ' || empBonusInfo.potentialBonus ||
                ' | Location: ' || empBonusInfo.departmentLocation ||
                ' | Status: Standard Performer'
            );
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Finished Employee Bonus Processing ---');
    DBMS_OUTPUT.PUT_LINE('Total Employees Processed: ' || vProcessedCount);

    -- XML Generation
    SELECT XMLElement("EmployeeBonusReport",
               XMLElement("ProcessedCount", vProcessedCount)
           )
    INTO employeeReportXML
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- XML Report ---');
    DBMS_OUTPUT.PUT_LINE(employeeReportXML.getClobVal());

    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Changes committed successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN -- Should ideally be caught inside the loop if a specific SELECT INTO fails, this is a broader catch.
        DBMS_OUTPUT.PUT_LINE('Error: A required data element was not found during processing.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A critical error occurred: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK;
END;
/

-- Query to verify salesLog (optional, run separately after execution)
-- SELECT * FROM salesLog ORDER BY logTime DESC;
-- Query to verify employee commission changes (optional, run separately after execution)
-- SELECT employeeId, firstName, lastName, salary, commissionPct 
-- FROM employees 
-- WHERE employeeId IN (SELECT employeeId FROM employees e JOIN departments d ON e.departmentId = d.departmentId WHERE d.departmentName IN ('IT', 'SALES') AND e.hireDate < TO_DATE('01-JAN-2021', 'YYYY-MM-DD') AND e.isActive = TRUE);
```

---

## Tips for Success & Learning

To conquer tasks, both big and small,
Heed these wise tips, stand strong and tall!

*   **Break It Down:** For complex problems (especially the "Hardcore" one), tackle one requirement at a time. Test each part before moving on.
*   **Experiment:** Don't just aim for the solution. Try variations. What if a condition changes? What if a value is NULL? This deepens understanding.
*   **`SET SERVEROUTPUT ON`:** This is your best friend for seeing `DBMS_OUTPUT.PUT_LINE` messages. Use it in SQL Developer, SQL*Plus, or ensure your Oracle Live SQL session is configured for output.
*   **Oracle Documentation:** When in doubt, the official Oracle documentation is the ultimate source of truth. It's vast, but learning to navigate it is a key skill.
*   **Error Messages are Clues:** Oracle's error messages (e.g., ORA-xxxxx, PLS-xxxxx) can be cryptic at first, but they provide valuable clues. Search for them online or in the Oracle docs.
*   **Rollback Often During Testing:** When practicing DML, use `ROLLBACK` frequently to revert your changes, so your dataset remains consistent for subsequent tests.
*   **Think in Sets (SQL) vs. Rows (PL/SQL):** Remember that SQL excels at set-based operations. While PL/SQL allows row-by-row processing, always consider if a pure SQL solution might be more efficient, especially for data retrieval and bulk updates.

<div class="rhyme">
If errors loom and make you frown,
Don't let despair just weigh you down.
Debug with care, line by line,
Success in PL/SQL, will be thine!
</div>

## Conclusion & Next Steps

Well done on working through these PL/SQL foundational exercises and their solutions! By understanding these core components, you've taken significant steps in bridging your PostgreSQL knowledge to the Oracle ecosystem and started to harness the procedural power of PL/SQL.

_The blocks you've built, the loops you've run,_
_Your PL/SQL journey has begun!_

The concepts covered here—block structure, variables, control flow, and SQL integration—are the bedrock upon which more advanced PL/SQL programming is built.

**Next, you'll venture into:**

*   **Cursors:** For more granular control over multi-row query results.
*   **Stored Procedures & Functions:** To encapsulate logic and create reusable code units.
*   **Packages:** Oracle's powerful mechanism for organizing related PL/SQL objects.

Keep practicing, keep exploring, and you'll become proficient in Oracle PL/SQL in no time!

</div>