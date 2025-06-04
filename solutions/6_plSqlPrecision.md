<head>
    <link rel="stylesheet" href="../styles/exercises.css">
</head>

<div class="container">

# PL/SQL Precision: Cursors, Procedures, and Data Flow - Exercises & Solutions

Welcome, Oracle Voyager! This set of exercises is designed to sharpen your skills in PL/SQL, focusing on the essential mechanisms for data iteration and procedural logic: cursors and stored program units (procedures and functions). With cursors tight and functions right, your Oracle might will take its flight!

These exercises will help you:
*   Master Oracle's specific syntax and behavior for implicit and explicit cursors, including cursor FOR loops.
*   Understand and implement stored procedures and functions with various parameter modes (`IN`, `OUT`, `IN OUT`).
*   Gain practical experience in controlling data flow and handling common scenarios in PL/SQL.
*   Bridge your existing PostgreSQL knowledge to Oracle's powerful procedural extensions.

As you work through these, remember:
<div class="rhyme">
In Oracle's realm, where data streams flow,<br>
Cursors guide the way, helping knowledge grow.<br>
Procedures and functions, with parameters so neat,<br>
Make complex logic a programmable treat.
</div>

</div>

<div class="container">

## Prerequisites & Setup

Before diving into these exercises, ensure you're comfortable with:
*   **Oracle Core Syntax:** Basic `SELECT`, `INSERT`, `UPDATE`, `DELETE` statements, `WHERE` clauses, and Oracle data types (especially `VARCHAR2`, `NUMBER`, `DATE`) as covered in the "Key Differences & Core Syntax" and subsequent DML/Date/String function sections of this transitional course.
*   **PL/SQL Fundamentals:** The basic PL/SQL block structure (`DECLARE`, `BEGIN`, `EXCEPTION`, `END`), variable declaration (`%TYPE`, `%ROWTYPE`), conditional logic (`IF-THEN-ELSIF`), and basic loops from the preceding "PL/SQL: Oracle's Procedural Powerhouse - Fundamentals" section.
*   **PostgreSQL Equivalents (Conceptual):** Understanding of how cursors (even if less explicitly managed in some PG styles) and functions/procedures work in PostgreSQL will help you appreciate Oracle's specific implementations.

<div class="oracle-specific">
    <p><strong>Dataset Setup: Your Oracle Playground</strong></p>
    <p>To tackle these exercises, you'll need our practice dataset. A complete Oracle SQL script is provided below to create the necessary tables (<code>departments</code>, <code>employees</code>, <code>salaryAudit</code>) and populate them with sample data. </p>
    <p><strong>How to Run the Script:</strong></p>
    <ol>
        <li>Copy the entire SQL script block.</li>
        <li>Paste it into your Oracle DB 23ai environment (e.g., SQL Developer worksheet, SQL*Plus session, or Oracle Live SQL).</li>
        <li>Execute the script. This will create the tables and insert the data.</li>
    </ol>
    <p><strong>Brief Table Overview:</strong></p>
    <ul>
        <li><code>departments</code>: Stores department information (<code>departmentId</code>, <code>departmentName</code>, <code>location</code>).</li>
        <li><code>employees</code>: Stores employee details (<code>employeeId</code>, names, <code>email</code>, <code>hireDate</code>, <code>jobId</code>, <code>salary</code>, <code>departmentId</code>). It has a foreign key to <code>departments</code>.</li>
        <li><code>salaryAudit</code>: A table to log salary changes, often updated by procedures or triggers.</li>
    </ul>
    <p>Ensure this dataset is correctly set up before you begin. If the tables exist, they'll be dropped and recreated, so your slate is clean and your data keen!</p>
</div>

</div>

<div class="container">

## Exercise Structure Overview

These exercises are structured to build your understanding progressively:
*   **Meanings, Values, Relations, and Advantages:** Focus on the core definition, usage, benefits, and connections of each concept, especially Oracle's specific syntax and features.
*   **Disadvantages and Pitfalls:** Explore common mistakes and limitations within the Oracle PL/SQL context.
*   **Contrasting with Inefficient Common Solutions:** Compare Oracle-idiomatic solutions with less optimal approaches one might take, highlighting the advantages of the Oracle way.
*   **Hardcore Combined Problem:** A comprehensive challenge integrating all concepts from this section and relevant prior topics.

<div class="rhyme">
Try each task with thought and with care,<br>
Then check solutions, true wisdom to share!
</div>
</div>

<div class="container">

## Exercises & Solutions: PL/SQL Precision

### Dataset for Exercises (Oracle SQL with ORACLE DB 23ai)

```sql
-- Drop tables if they exist to ensure a clean setup
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE salaryAudit';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE departments';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Create tables
CREATE TABLE departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    location VARCHAR2(100)
);

CREATE TABLE employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    hireDate DATE,
    jobId VARCHAR2(50),
    salary NUMBER(10, 2),
    departmentId NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (departmentId) REFERENCES departments(departmentId)
);

CREATE TABLE salaryAudit (
    auditId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employeeId NUMBER,
    oldSalary NUMBER(10,2),
    newSalary NUMBER(10,2),
    changeDate TIMESTAMP DEFAULT SYSTIMESTAMP,
    changedBy VARCHAR2(100),
    notes VARCHAR2(255)
);

-- Populate tables
INSERT INTO departments (departmentId, departmentName, location) VALUES (10, 'Administration', 'New York');
INSERT INTO departments (departmentId, departmentName, location) VALUES (20, 'Marketing', 'London');
INSERT INTO departments (departmentId, departmentName, location) VALUES (30, 'IT', 'Berlin');
INSERT INTO departments (departmentId, departmentName, location) VALUES (40, 'Human Resources', 'New York');
INSERT INTO departments (departmentId, departmentName, location) VALUES (50, 'Sales', 'London');

INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (101, 'Alice', 'Smith', 'asmith@example.com', DATE '2020-01-15', 'ADMIN_ASST', 50000, 10);
INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (102, 'Bob', 'Johnson', 'bjohnson@example.com', DATE '2019-03-01', 'MKT_REP', 60000, 20);
INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (103, 'Carol', 'Williams', 'cwilliams@example.com', DATE '2021-07-20', 'IT_PROG', 75000, 30);
INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (104, 'David', 'Brown', 'dbrown@example.com', DATE '2018-05-10', 'HR_REP', 55000, 40);
INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (105, 'Eve', 'Davis', 'edavis@example.com', DATE '2022-01-30', 'IT_PROG', 80000, 30);
INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (106, 'Frank', 'Miller', 'fmiller@example.com', DATE '2020-11-01', 'SALES_REP', 65000, 50);
INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (107, 'Grace', 'Wilson', 'gwilson@example.com', DATE '2023-02-01', 'SALES_REP', 70000, 50);
INSERT INTO employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (108, 'Henry', 'Moore', 'hmoore@example.com', DATE '2019-08-15', 'IT_ANALYST', 90000, 30);

COMMIT;
```

### Category: Cursors
(Implicit Cursors, Explicit Cursors, Cursor FOR Loops)

#### (i) Meanings, Values, Relations, and Advantages

**Exercise C1:**
**Problem:** Write a PL/SQL anonymous block that attempts to update the salary of an employee with `employeeId = 999` (who does not exist) by increasing it by 10%. After the `UPDATE` statement, use Oracle's implicit cursor attributes to display:
1.  Whether any row was found and updated (`SQL%FOUND`).
2.  Whether no row was found and updated (`SQL%NOTFOUND`).
3.  The number of rows affected (`SQL%ROWCOUNT`).

<div class="postgresql-bridge">
<strong>Bridging from PostgreSQL:</strong> In PostgreSQL, you might use <code>GET DIAGNOSTICS affected_rows = ROW_COUNT;</code> after an <code>UPDATE</code>. Oracle provides boolean attributes <code>SQL%FOUND</code> and <code>SQL%NOTFOUND</code> for a more direct check, in addition to <code>SQL%ROWCOUNT</code>.
</div>

**Solution C1:**
```sql
SET SERVEROUTPUT ON;
DECLARE
    vEmployeeId NUMBER := 999;
BEGIN
    UPDATE employees
    SET salary = salary * 1.10
    WHERE employeeId = vEmployeeId;

    DBMS_OUTPUT.PUT_LINE('--- After UPDATE for non-existent employee ---');
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: TRUE - Row(s) updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: FALSE - No row updated.');
    END IF;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%NOTFOUND: TRUE - No row updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SQL%NOTFOUND: FALSE - Row(s) updated.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('SQL%ROWCOUNT: ' || SQL%ROWCOUNT || ' row(s) affected.');

    -- Now try with an existing employee
    vEmployeeId := 101;
    UPDATE employees
    SET salary = salary * 1.05 -- 5% raise for existing employee
    WHERE employeeId = vEmployeeId;

    DBMS_OUTPUT.PUT_LINE('--- After UPDATE for existing employee ---');
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: TRUE - Row(s) updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SQL%FOUND: FALSE - No row updated.');
    END IF;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL%NOTFOUND: TRUE - No row updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SQL%NOTFOUND: FALSE - Row(s) updated.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('SQL%ROWCOUNT: ' || SQL%ROWCOUNT || ' row(s) affected.');
    
    ROLLBACK; -- Rollback changes for subsequent exercises
END;
/
```

**Exercise C2:**
**Problem:** Write a PL/SQL anonymous block that declares an explicit cursor to fetch the `firstName`, `lastName`, and `salary` of all employees in the 'IT' department. Loop through the cursor, fetching one row at a time, and display the details. Ensure the cursor is properly opened and closed. Use `%TYPE` for variable declarations.
<div class="oracle-specific">
<strong>Advantage:</strong> Explicit cursors give fine-grained control over data retrieval, useful when processing row-by-row or when complex logic is needed for each row.
</div>

**Solution C2:**
```sql
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cITEmployees IS
        SELECT firstName, lastName, salary
        FROM employees e
        JOIN departments d ON e.departmentId = d.departmentId
        WHERE d.departmentName = 'IT';
    vFirstName employees.firstName%TYPE;
    vLastName employees.lastName%TYPE;
    vSalary employees.salary%TYPE;
BEGIN
    OPEN cITEmployees;
    LOOP
        FETCH cITEmployees INTO vFirstName, vLastName, vSalary;
        EXIT WHEN cITEmployees%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Name: ' || vFirstName || ' ' || vLastName || ', Salary: ' || vSalary);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total rows fetched: ' || cITEmployees%ROWCOUNT);
    CLOSE cITEmployees;
END;
/
```

**Exercise C3:**
**Problem:** Rewrite the previous exercise (C2) using a cursor FOR loop to display the `firstName`, `lastName`, and `salary` of all employees in the 'IT' department.
<div class="oracle-specific">
<strong>Advantage:</strong> Cursor FOR loops simplify cursor handling by implicitly opening, fetching, and closing the cursor, reducing boilerplate code and potential errors. This is very similar to <code>FOR record_variable IN query LOOP ... END LOOP;</code> in PostgreSQL.
</div>

**Solution C3:**
```sql
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employees in IT (using Cursor FOR Loop):');
    FOR empRec IN (
        SELECT e.firstName, e.lastName, e.salary
        FROM employees e
        JOIN departments d ON e.departmentId = d.departmentId
        WHERE d.departmentName = 'IT'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || empRec.firstName || ' ' || empRec.lastName || ', Salary: ' || empRec.salary);
    END LOOP;
END;
/
```

**Exercise C4:**
**Problem:** Explain the meaning and demonstrate the use of `SQL%ISOPEN` with an implicit cursor and an explicit cursor. Why does `SQL%ISOPEN` always return `FALSE` for implicit cursors after the SQL statement execution?
<div class="oracle-specific">
<strong>Relation to Previous (Oracle):</strong> This relates to the DML statements studied earlier, as implicit cursors are tied to their execution.
</div>

**Solution C4:**
```sql
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cExplicit IS SELECT 1 FROM dual;
    vCount NUMBER;
BEGIN
    -- Implicit Cursor
    SELECT COUNT(*) INTO vCount FROM employees WHERE departmentId = 10;
    -- SQL%ISOPEN is checked *after* the SELECT INTO statement has completed.
    -- Implicit cursors are automatically opened and closed by Oracle for each SQL statement.
    -- Thus, by the time we can check SQL%ISOPEN, it's already closed.
    IF SQL%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Implicit cursor SQL%ISOPEN: TRUE (This should not print)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Implicit cursor SQL%ISOPEN: FALSE (As expected)');
    END IF;

    -- Explicit Cursor
    IF NOT cExplicit%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Explicit cursor cExplicit%ISOPEN: FALSE (Before OPEN)');
        OPEN cExplicit;
        IF cExplicit%ISOPEN THEN
            DBMS_OUTPUT.PUT_LINE('Explicit cursor cExplicit%ISOPEN: TRUE (After OPEN)');
        END IF;
        CLOSE cExplicit;
        IF NOT cExplicit%ISOPEN THEN
            DBMS_OUTPUT.PUT_LINE('Explicit cursor cExplicit%ISOPEN: FALSE (After CLOSE)');
        END IF;
    END IF;
END;
/
```
<p><strong>Explanation:</strong> <code>SQL%ISOPEN</code> for an implicit cursor (associated with a standalone SQL statement like <code>SELECT INTO</code> or DML) will always be <code>FALSE</code> when checked in PL/SQL. This is because Oracle automatically opens the implicit cursor to process the SQL statement and closes it immediately after the statement completes. The check occurs after this automatic closure.
For explicit cursors, <code>cursor_name%ISOPEN</code> correctly reflects whether the cursor has been explicitly opened and not yet closed.</p>

#### (ii) Disadvantages and Pitfalls

**Exercise C5:**
**Problem:** Write a PL/SQL block that declares an explicit cursor but forgets to close it after processing. Then, write another PL/SQL block that tries to open the *same named cursor* again (simulate this by running the first block, then the second in a SQL*Plus session or similar tool where session state persists for cursors if not properly managed). What is the potential issue here, and what Oracle error might you encounter?
<div class="caution">
<strong>Pitfall:</strong> Forgetting to close explicit cursors can lead to resource leaks or errors like <code>ORA-01000: maximum open cursors exceeded</code> in long-running sessions or <code>ORA-06511: PL/SQL: cursor already open</code> if trying to re-open without closing.
</div>

**Solution C5:**
<p><strong>Block 1 (Simulating forgetting to close):</strong></p>

```sql
-- In SQL*Plus or similar, cursors can persist if not closed if the PL/SQL block doesn't
-- complete in a way that automatically closes them (e.g. session termination)
-- However, for a simple anonymous block, Oracle often cleans up.
-- To better demonstrate the "already open" issue, we'd ideally use a package cursor.
-- For this exercise, we'll focus on the principle.
DECLARE
    CURSOR cLeak IS SELECT * FROM employees WHERE departmentId = 10;
    empRow employees%ROWTYPE;
BEGIN
    OPEN cLeak;
    FETCH cLeak INTO empRow;
    IF cLeak%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Fetched: ' || empRow.firstName);
    END IF;
    -- FORGETTING TO CLOSE cLeak;
    -- In a simple anonymous block, Oracle will close it upon block completion.
    -- If this cursor were a package global cursor, it would remain open.
    DBMS_OUTPUT.PUT_LINE('Block 1 completed. Cursor state depends on environment.');
END;
/
```

<p><strong>Block 2 (Attempting to re-open, illustrating the point if it were a persistent cursor):</strong></p>

```sql
-- This block would demonstrate ORA-06511 if cLeak from Block 1 remained open.
-- In typical anonymous block execution, cLeak from Block 1 is closed automatically.
-- Let's modify to show the error by attempting to open twice in the same block.
DECLARE
    CURSOR cLeak IS SELECT * FROM employees WHERE departmentId = 10;
    empRow employees%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Attempting to open cLeak first time...');
    OPEN cLeak;
    DBMS_OUTPUT.PUT_LINE('cLeak opened.');
    DBMS_OUTPUT.PUT_LINE('Attempting to open cLeak second time without closing...');
    OPEN cLeak; -- This will raise ORA-06511
    DBMS_OUTPUT.PUT_LINE('cLeak opened again (This should not print).');
    CLOSE cLeak;
EXCEPTION
    WHEN CURSOR_ALREADY_OPEN THEN -- ORA-06511
        DBMS_OUTPUT.PUT_LINE('Error: Cursor already open. ORA-06511');
        IF cLeak%ISOPEN THEN CLOSE cLeak; END IF; -- Ensure it's closed
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        IF cLeak%ISOPEN THEN CLOSE cLeak; END IF; -- Ensure it's closed
END;
/
```
<p><strong>Potential Issue:</strong> If a cursor (especially a package-level cursor) is opened and not closed, subsequent attempts to open it without first closing will raise <code>ORA-06511: PL/SQL: cursor already open</code>. In long-running applications with many such unclosed cursors, <code>ORA-01000: maximum open cursors exceeded</code> can occur.</p>

**Exercise C6:**
**Problem:** A PL/SQL block uses `SELECT ... INTO` to fetch an employee's salary. What are two common exceptions (pitfalls) that can occur with `SELECT ... INTO` if the `WHERE` clause is not carefully constructed, and how can an explicit cursor or cursor FOR loop mitigate one of them?

**Solution C6:**
```sql
SET SERVEROUTPUT ON;
DECLARE
    vSalary employees.salary%TYPE;
    vEmployeeId employees.employeeId%TYPE;
BEGIN
    -- Pitfall 1: NO_DATA_FOUND
    DBMS_OUTPUT.PUT_LINE('--- Testing NO_DATA_FOUND ---');
    vEmployeeId := 999; -- Non-existent employee
    BEGIN
        SELECT salary INTO vSalary
        FROM employees
        WHERE employeeId = vEmployeeId;
        DBMS_OUTPUT.PUT_LINE('Salary for ' || vEmployeeId || ': ' || vSalary);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No employee found with ID ' || vEmployeeId || '. (NO_DATA_FOUND)');
    END;

    -- Pitfall 2: TOO_MANY_ROWS
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Testing TOO_MANY_ROWS ---');
    BEGIN
        SELECT salary INTO vSalary -- departmentId = 30 has multiple employees
        FROM employees
        WHERE departmentId = 30;
        DBMS_OUTPUT.PUT_LINE('Salary from department 30: ' || vSalary);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Multiple employees found in department 30. (TOO_MANY_ROWS)');
    END;

    -- Mitigation for TOO_MANY_ROWS using a cursor FOR loop (processes all, not just one)
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Mitigating TOO_MANY_ROWS with Cursor FOR Loop ---');
    FOR empRec IN (SELECT employeeId, salary FROM employees WHERE departmentId = 30) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ' || empRec.employeeId || ' in department 30 has salary: ' || empRec.salary);
    END LOOP;

END;
/
```
<p><strong>Pitfalls with <code>SELECT ... INTO</code>:</strong></p>
<ol>
    <li><code>NO_DATA_FOUND</code> (ORA-01403): Raised if the <code>WHERE</code> clause results in no rows being returned.</li>
    <li><code>TOO_MANY_ROWS</code> (ORA-01422): Raised if the <code>WHERE</code> clause results in more than one row being returned.</li>
</ol>
<p><strong>Mitigation:</strong>
An explicit cursor or a cursor FOR loop can mitigate <code>TOO_MANY_ROWS</code> by design, as they are intended to process multiple rows. For <code>NO_DATA_FOUND</code>, an explicit cursor would simply not fetch any rows (<code>cursor%NOTFOUND</code> would be true immediately after the first <code>FETCH</code> attempt or the loop wouldn't execute), which can be handled gracefully without an exception.</p>

#### (iii) Contrasting with Inefficient Common Solutions

**Exercise C7:**
**Problem:** A developer needs to process all employees from the 'Sales' department. They write a PL/SQL block that first counts the total number of 'Sales' employees using one `SELECT COUNT(*)` query, and then uses this count in a `WHILE` loop with an explicit cursor, fetching one employee at a time and manually incrementing a counter to stop the loop.
Demonstrate this potentially less efficient approach. Then, provide the more Oracle-idiomatic and efficient solution using a cursor `FOR` loop or an explicit cursor with `EXIT WHEN %NOTFOUND`. Explain why the latter is generally preferred.

**Solution C7:**
<p><strong>Less Efficient Approach (Manual Count and Loop Control):</strong></p>

```sql
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cSalesEmployees IS
        SELECT firstName, lastName
        FROM employees e
        JOIN departments d ON e.departmentId = d.departmentId
        WHERE d.departmentName = 'Sales';
    vFirstName employees.firstName%TYPE;
    vLastName employees.lastName%TYPE;
    vTotalSalesEmployees NUMBER;
    vFetchedCount NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vTotalSalesEmployees
    FROM employees e
    JOIN departments d ON e.departmentId = d.departmentId
    WHERE d.departmentName = 'Sales';
    DBMS_OUTPUT.PUT_LINE('Less Efficient Approach: Total Sales Employees = ' || vTotalSalesEmployees);
    OPEN cSalesEmployees;
    WHILE vFetchedCount < vTotalSalesEmployees LOOP
        FETCH cSalesEmployees INTO vFirstName, vLastName;
        -- EXIT WHEN cSalesEmployees%NOTFOUND; -- More robust, but for this exercise, we rely on count
        DBMS_OUTPUT.PUT_LINE('Processing: ' || vFirstName || ' ' || vLastName);
        vFetchedCount := vFetchedCount + 1;
    END LOOP;
    CLOSE cSalesEmployees;
END;
/
```

**More Efficient / Idiomatic Oracle Solution (Cursor FOR Loop):**
```sql
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'More Efficient Approach (Cursor FOR Loop):');
    FOR empRec IN (
        SELECT e.firstName, e.lastName
        FROM employees e
        JOIN departments d ON e.departmentId = d.departmentId
        WHERE d.departmentName = 'Sales'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Processing: ' || empRec.firstName || ' ' || empRec.lastName);
    END LOOP;
END;
/
```

<p><strong>Explanation:</strong><br>
The first approach is less efficient and less idiomatic because:</p>
<ol>
    <li><strong>Extra Query:</strong> It requires an initial <code>SELECT COUNT(*)</code> query, which is an extra database hit.</li>
    <li><strong>Manual Loop Management:</strong> It relies on manually managing the loop counter (<code>vFetchedCount</code>). This is error-prone (e.g., if the data changes between the <code>COUNT</code> and the fetch loop).</li>
    <li><strong>Less Robust:</strong> If a row is deleted between the <code>COUNT</code> and the <code>FETCH</code> operations, the loop might attempt to fetch past the end of the actual data, or if it solely relies on the count, <code>FETCH</code> would return no data and <code>vFirstName</code>/<code>vLastName</code> would retain their previous values for the last iteration if <code>EXIT WHEN %NOTFOUND</code> is not used.</li>
</ol>
<p>The cursor <code>FOR</code> loop (or an explicit cursor with <code>LOOP...FETCH...EXIT WHEN %NOTFOUND...END LOOP; CLOSE;</code>) is preferred because:</p>
<ol>
    <li><strong>No Extra Count Query:</strong> It processes rows as they are fetched without needing a preliminary count.</li>
    <li><strong>Automatic Management:</strong> The loop implicitly handles opening, fetching, checking for no more data (<code>%NOTFOUND</code>), and closing the cursor.</li>
    <li><strong>Conciseness and Readability:</strong> The code is much cleaner and easier to understand.</li>
</ol>

### Category: Stored Procedures & Functions

#### (i) Meanings, Values, Relations, and Advantages

**Exercise SP1:**
**Problem:** Create an Oracle stored procedure named `addDepartment` that accepts `departmentId`, `departmentName`, and `location` as `IN` parameters and inserts a new department into the `departments` table. Demonstrate invoking this procedure.
<div class="oracle-specific">
<strong>Advantage:</strong> Procedures encapsulate DML logic, promoting reusability and maintainability. Parameters allow for dynamic data input.
</div>

**Solution SP1:**
```sql
CREATE OR REPLACE PROCEDURE addDepartment (
    pDepartmentId IN departments.departmentId%TYPE,
    pDepartmentName IN departments.departmentName%TYPE,
    pLocation IN departments.location%TYPE
) AS
BEGIN
    INSERT INTO departments (departmentId, departmentName, location)
    VALUES (pDepartmentId, pDepartmentName, pLocation);
    DBMS_OUTPUT.PUT_LINE('Department ' || pDepartmentName || ' added successfully.');
    COMMIT; -- Or handle transaction control outside if preferred
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Department ID ' || pDepartmentId || ' already exists.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK;
END addDepartment;
/

-- Demonstrate invocation
SET SERVEROUTPUT ON;
BEGIN
    addDepartment(60, 'Finance', 'Chicago');
    addDepartment(10, 'Duplicate Admin', 'New York'); -- To show exception
END;
/

-- Cleanup
DELETE FROM departments WHERE departmentId = 60;
COMMIT;
```

**Exercise SP2:**
**Problem:** Create an Oracle stored function named `getEmployeeFullName` that takes an `employeeId` (`IN` parameter) and returns the employee's full name (firstName || ' ' || lastName) as a `VARCHAR2`. Demonstrate its use in a `SELECT` statement and a PL/SQL block.
<div class="postgresql-bridge">
<strong>Relation to PostgreSQL:</strong> PostgreSQL functions are very similar. Oracle's <code>RETURN</code> clause and data type specification are key.
</div>
<div class="oracle-specific">
<strong>Advantage:</strong> Functions can be used directly in SQL queries (if they meet purity levels), extending SQL's capabilities.
</div>

**Solution SP2:**
```sql
CREATE OR REPLACE FUNCTION getEmployeeFullName (
    pEmployeeId IN employees.employeeId%TYPE
) RETURN VARCHAR2 AS
    vFullName VARCHAR2(101); -- Max 50 for first + 1 space + 50 for last
BEGIN
    SELECT firstName || ' ' || lastName
    INTO vFullName
    FROM employees
    WHERE employeeId = pEmployeeId;

    RETURN vFullName;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Employee Not Found';
    WHEN OTHERS THEN
        RETURN 'Error retrieving name';
END getEmployeeFullName;
/

-- Demonstrate in SQL
SELECT employeeId, getEmployeeFullName(employeeId) AS fullName
FROM employees
WHERE departmentId = 30;

-- Demonstrate in PL/SQL
SET SERVEROUTPUT ON;
DECLARE
    empName VARCHAR2(101);
BEGIN
    empName := getEmployeeFullName(103);
    DBMS_OUTPUT.PUT_LINE('Employee 103: ' || empName);
    empName := getEmployeeFullName(999); -- Non-existent
    DBMS_OUTPUT.PUT_LINE('Employee 999: ' || empName);
END;
/
```

**Exercise SP3:**
**Problem:** Create a procedure `updateEmployeeJobAndGetOldJob` that takes `employeeId` and a `newJobId` as `IN` parameters. It should update the employee's `jobId`. The procedure must also return the employee's *old* `jobId` using an `OUT` parameter.
<div class="oracle-specific">
<strong>Advantage/Oracle Specific:</strong> <code>OUT</code> parameters are a common way for Oracle procedures to return values, contrasting with PostgreSQL functions that might return multiple values via a record type or use <code>INOUT</code>.
</div>

**Solution SP3:**
```sql
CREATE OR REPLACE PROCEDURE updateEmployeeJobAndGetOldJob (
    pEmployeeId IN employees.employeeId%TYPE,
    pNewJobId IN employees.jobId%TYPE,
    pOldJobId OUT employees.jobId%TYPE
) AS
BEGIN
    -- Get the old job ID first
    SELECT jobId INTO pOldJobId
    FROM employees
    WHERE employeeId = pEmployeeId;

    -- Update to the new job ID
    UPDATE employees
    SET jobId = pNewJobId
    WHERE employeeId = pEmployeeId;

    IF SQL%NOTFOUND THEN
      pOldJobId := NULL; -- Indicate employee was not found
      DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found for update.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' job updated from ' || pOldJobId || ' to ' || pNewJobId);
    END IF;
    -- COMMIT; -- Decide on transaction control strategy
EXCEPTION
    WHEN NO_DATA_FOUND THEN -- For the initial SELECT
        pOldJobId := NULL;
        DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found.');
    WHEN OTHERS THEN
        pOldJobId := NULL;
        DBMS_OUTPUT.PUT_LINE('Error updating job for employee ' || pEmployeeId || ': ' || SQLERRM);
        -- ROLLBACK;
END updateEmployeeJobAndGetOldJob;
/

-- Demonstrate invocation
SET SERVEROUTPUT ON;
DECLARE
    vOriginalJobId employees.jobId%TYPE;
BEGIN
    -- Ensure there's an employee to update and know their current job
    SELECT jobId INTO vOriginalJobId FROM employees WHERE employeeId = 101;
    DBMS_OUTPUT.PUT_LINE('Original job for 101: ' || vOriginalJobId);

    updateEmployeeJobAndGetOldJob(101, 'NEW_ADMIN_JOB', vOriginalJobId);
    DBMS_OUTPUT.PUT_LINE('After procedure call, old job ID was: ' || vOriginalJobId);

    -- Test non-existent employee
    updateEmployeeJobAndGetOldJob(999, 'ANY_JOB', vOriginalJobId);
    DBMS_OUTPUT.PUT_LINE('Attempt to update non-existent employee, old job ID: ' || NVL(vOriginalJobId, 'NULL'));
    
    ROLLBACK; -- Revert changes made by the procedure for test isolation
END;
/
```

**Exercise SP4:**
**Problem:** Create a procedure `processSalary` that takes an `employeeId` as an `IN` parameter and a `currentSalary` as an `IN OUT` parameter. The procedure should:
1.  Fetch the employee's current salary into the `IN OUT` parameter.
2.  If the fetched salary is less than 60000, increase the `currentSalary` (which is the `IN OUT` parameter) by 10% within the procedure.
3.  The calling block should see the modified salary.
<div class="oracle-specific">
<strong>Advantage/Oracle Specific:</strong> <code>IN OUT</code> parameters allow a value to be passed into a procedure, modified, and then the modification to be visible to the caller. This is useful for "pass-by-reference" like behavior for modifications.
</div>

**Solution SP4:**
```sql
CREATE OR REPLACE PROCEDURE processSalary (
    pEmployeeId IN employees.employeeId%TYPE,
    pCurrentSalary IN OUT employees.salary%TYPE
) AS
    vFetchedSalary employees.salary%TYPE;
BEGIN
    SELECT salary INTO vFetchedSalary
    FROM employees
    WHERE employeeId = pEmployeeId;

    pCurrentSalary := vFetchedSalary; -- Initialize IN OUT param with fetched salary

    DBMS_OUTPUT.PUT_LINE('Inside procedure - Initial salary for ' || pEmployeeId || ': ' || pCurrentSalary);

    IF pCurrentSalary < 60000 THEN
        pCurrentSalary := pCurrentSalary * 1.10;
        DBMS_OUTPUT.PUT_LINE('Inside procedure - Salary increased to: ' || pCurrentSalary);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Inside procedure - Salary not increased.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Inside procedure - Employee ' || pEmployeeId || ' not found.');
        pCurrentSalary := NULL; -- Or some other indicator of error
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Inside procedure - Error: ' || SQLERRM);
        pCurrentSalary := NULL;
END processSalary;
/

-- Demonstrate invocation
SET SERVEROUTPUT ON;
DECLARE
    vEmpId employees.employeeId%TYPE := 101; -- Salary is 50000
    vSalaryToProcess employees.salary%TYPE; -- Can be initialized or not
BEGIN
    -- Call for employee who should get a raise
    vSalaryToProcess := 0; -- Initial dummy value, will be overwritten
    DBMS_OUTPUT.PUT_LINE('Before call for ' || vEmpId || ', vSalaryToProcess: ' || NVL(TO_CHAR(vSalaryToProcess), 'NULL'));
    processSalary(vEmpId, vSalaryToProcess);
    DBMS_OUTPUT.PUT_LINE('After call for ' || vEmpId || ', vSalaryToProcess is now: ' || NVL(TO_CHAR(vSalaryToProcess), 'NULL'));

    -- Call for employee who should not get a raise
    vEmpId := 103; -- Salary is 75000
    vSalaryToProcess := 0; -- Reset
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Before call for ' || vEmpId || ', vSalaryToProcess: ' || NVL(TO_CHAR(vSalaryToProcess), 'NULL'));
    processSalary(vEmpId, vSalaryToProcess);
    DBMS_OUTPUT.PUT_LINE('After call for ' || vEmpId || ', vSalaryToProcess is now: ' || NVL(TO_CHAR(vSalaryToProcess), 'NULL'));
END;
/
```

#### (ii) Disadvantages and Pitfalls

**Exercise SP5:**
**Problem:** A function is designed to calculate an annual bonus (10% of salary) but mistakenly attempts to perform an `UPDATE` statement inside it to log the bonus calculation. Why is this problematic if the function is intended to be called from a `SELECT` query? What Oracle error would occur?

**Solution SP5:**
```sql
-- Function definition
CREATE OR REPLACE FUNCTION calculateAndLogBonus (
    pEmployeeId IN employees.employeeId%TYPE
) RETURN NUMBER AS
    vBonus NUMBER;
    vSalary employees.salary%TYPE;
BEGIN
    SELECT salary INTO vSalary
    FROM employees
    WHERE employeeId = pEmployeeId;

    vBonus := vSalary * 0.10;

    -- Problematic part: DML inside a function called from SELECT
    /*
    UPDATE salaryAudit 
    SET notes = 'Bonus ' || vBonus || ' calculated' 
    WHERE employeeId = pEmployeeId AND ROWNUM = 1; -- Simplified logging attempt
    -- If no audit row exists, this UPDATE does nothing. A more robust log would INSERT.
    -- For this exercise, the focus is on the DML attempt itself.
    */
    -- To demonstrate the error, let's try a simple INSERT which is also DML
    INSERT INTO salaryAudit (employeeId, notes) VALUES (pEmployeeId, 'Bonus ' || vBonus || ' calculated');
    -- Even without COMMIT, the DML operation itself is the issue.
    
    RETURN vBonus;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END calculateAndLogBonus;
/

-- Attempt to call from SQL (will cause error)
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Attempting to call function with DML from SQL:');
    -- The error ORA-14551 will be raised when this SELECT statement is executed.
    FOR rec IN (SELECT employeeId, calculateAndLogBonus(employeeId) AS bonus FROM employees WHERE departmentId = 50) LOOP
      DBMS_OUTPUT.PUT_LINE('Employee ' || rec.employeeId || ' Bonus: ' || rec.bonus);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF SQLCODE = -14551 THEN
          DBMS_OUTPUT.PUT_LINE('ORA-14551: cannot perform a DML operation inside a query - as expected.');
        END IF;
        ROLLBACK; -- Clean up the failed DML attempt if any part of it started
END;
/
-- Cleanup the function
DROP FUNCTION calculateAndLogBonus;
```
<p><strong>Pitfall/Problem:</strong><br>Functions called from SQL queries (e.g., in a <code>SELECT</code> list or <code>WHERE</code> clause) are generally not allowed to perform DML operations (INSERT, UPDATE, DELETE) on database tables, nor can they execute DDL or transaction control statements (COMMIT, ROLLBACK).</p>
<p><strong>Oracle Error:</strong> If such a function attempts DML, Oracle will raise <code>ORA-14551: cannot perform a DML operation inside a query</code>.</p>
<p><strong>Reason:</strong> SQL queries are designed for read-consistency. Allowing DML within a function called by a query could lead to inconsistent results, as the data might change mid-query. Autonomous transactions are a way to work around this, but they have their own implications.</p>

**Exercise SP6:**
**Problem:** A procedure has an `OUT` parameter. Inside the procedure, there's an `IF-THEN-ELSIF` structure. One of the `ELSIF` branches does not assign a value to the `OUT` parameter. What is the state of the `OUT` parameter in the calling environment if that branch is executed? How does this differ from an `IN OUT` parameter?

**Solution SP6:**
```sql
CREATE OR REPLACE PROCEDURE checkStatus (
    pInput IN NUMBER,
    pResult OUT VARCHAR2,
    pInOutResult IN OUT VARCHAR2
) AS
BEGIN
    pInOutResult := pInOutResult || ' - Processed'; -- Append to existing IN OUT value
    IF pInput = 1 THEN
        pResult := 'Status A';
    ELSIF pInput = 2 THEN
        -- pResult is NOT assigned here for pInput = 2
        DBMS_OUTPUT.PUT_LINE('Inside procedure: pResult not assigned for input 2.');
    ELSIF pInput = 3 THEN
        pResult := 'Status C';
    ELSE
        pResult := 'Status Unknown';
    END IF;
    DBMS_OUTPUT.PUT_LINE('Inside procedure: pInput = ' || pInput || ', pResult = ' || NVL(pResult, 'NULL') || ', pInOutResult = ' || pInOutResult);
END checkStatus;
/

SET SERVEROUTPUT ON;
DECLARE
    vStatus VARCHAR2(50);
    vInOutStatus VARCHAR2(100);
BEGIN
    -- Case 1: pResult gets assigned
    vInOutStatus := 'InitialInOut1';
    checkStatus(1, vStatus, vInOutStatus);
    DBMS_OUTPUT.PUT_LINE('After call (input 1): vStatus = ' || NVL(vStatus, 'NULL') || ', vInOutStatus = ' || vInOutStatus);

    -- Case 2: pResult does NOT get assigned
    vStatus := 'InitialValue'; -- Give vStatus a value before the call
    vInOutStatus := 'InitialInOut2';
    checkStatus(2, vStatus, vInOutStatus);
    DBMS_OUTPUT.PUT_LINE('After call (input 2): vStatus = ' || NVL(vStatus, 'NULL') || ', vInOutStatus = ' || vInOutStatus);
    
    -- Case 3: pResult gets assigned
    vInOutStatus := 'InitialInOut3';
    checkStatus(3, vStatus, vInOutStatus);
    DBMS_OUTPUT.PUT_LINE('After call (input 3): vStatus = ' || NVL(vStatus, 'NULL') || ', vInOutStatus = ' || vInOutStatus);    
END;
/
```
<p><strong>Explanation:</strong></p>
<ul>
    <li><strong><code>OUT</code> parameter (<code>pResult</code>):</strong> If a branch is executed where the <code>OUT</code> parameter is not explicitly assigned a value within the procedure, its value in the calling environment remains what it was <em>before the procedure call</em>. If it was uninitialized, it remains <code>NULL</code> (or uninitialized). If it had a value, it retains that value. The procedure does not implicitly initialize <code>OUT</code> parameters to <code>NULL</code> if they aren't assigned.</li>
    <li><strong><code>IN OUT</code> parameter (<code>pInOutResult</code>):</strong> An <code>IN OUT</code> parameter passes its initial value <em>into</em> the procedure. If the procedure does not modify it, the calling environment sees the original value. If modified, the calling environment sees the new value. In the example, <code>pInOutResult</code> is always modified by appending to its initial value.</li>
</ul>
<div class="caution">
<strong>Pitfall:</strong> Relying on an <code>OUT</code> parameter to be <code>NULL</code> if not explicitly set within all paths of a procedure can lead to bugs if the corresponding actual parameter in the calling environment had a pre-existing value. It's good practice to initialize <code>OUT</code> parameters at the beginning of the procedure or ensure every execution path assigns a value.
</div>

#### (iii) Contrasting with Inefficient Common Solutions

**Exercise SP7:**
**Problem:** A developer needs to retrieve an employee's `firstName` and `salary` for a given `employeeId`. They create two separate functions: `getEmpFirstName(p_id IN NUMBER) RETURN VARCHAR2` and `getEmpSalary(p_id IN NUMBER) RETURN NUMBER`. In their main PL/SQL block, they call these two functions sequentially for the same `employeeId`.
Show this approach. Then, provide a more efficient Oracle-idiomatic solution using a single procedure with `OUT` parameters or a function returning a record type. Explain the inefficiency of the first approach.

**Solution SP7:**
Less Efficient Approach (Two Separate Functions):
```sql
CREATE OR REPLACE FUNCTION getEmpFirstName (
    pEmployeeId IN employees.employeeId%TYPE
) RETURN VARCHAR2 AS
    vFirstName employees.firstName%TYPE;
BEGIN
    SELECT firstName INTO vFirstName FROM employees WHERE employeeId = pEmployeeId;
    RETURN vFirstName;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END getEmpFirstName;
/

CREATE OR REPLACE FUNCTION getEmpSalary (
    pEmployeeId IN employees.employeeId%TYPE
) RETURN NUMBER AS
    vSalary employees.salary%TYPE;
BEGIN
    SELECT salary INTO vSalary FROM employees WHERE employeeId = pEmployeeId;
    RETURN vSalary;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END getEmpSalary;
/

SET SERVEROUTPUT ON;
DECLARE
    vEmpId employees.employeeId%TYPE := 103;
    vFName employees.firstName%TYPE;
    vSal employees.salary%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Less Efficient Approach ---');
    vFName := getEmpFirstName(vEmpId);
    vSal := getEmpSalary(vEmpId);
    DBMS_OUTPUT.PUT_LINE('Employee: ' || vFName || ', Salary: ' || vSal);
END;
/
```
More Efficient Oracle Solution (Procedure with OUT parameters):
```sql
CREATE OR REPLACE PROCEDURE getEmployeeDetails (
    pEmployeeId IN employees.employeeId%TYPE,
    pFirstName OUT employees.firstName%TYPE,
    pSalary OUT employees.salary%TYPE
) AS
BEGIN
    SELECT firstName, salary
    INTO pFirstName, pSalary
    FROM employees
    WHERE employeeId = pEmployeeId;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        pFirstName := NULL;
        pSalary := NULL;
END getEmployeeDetails;
/

SET SERVEROUTPUT ON;
DECLARE
    vEmpId employees.employeeId%TYPE := 103;
    vFName employees.firstName%TYPE;
    vSal employees.salary%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- More Efficient Approach (Procedure) ---');
    getEmployeeDetails(vEmpId, vFName, vSal);
    DBMS_OUTPUT.PUT_LINE('Employee: ' || vFName || ', Salary: ' || vSal);
END;
/
-- Alternative: Function returning a record (also efficient)
DECLARE
    TYPE empDetailRec IS RECORD (
        firstName employees.firstName%TYPE,
        salary employees.salary%TYPE
    );
    vEmpRec empDetailRec;
    FUNCTION getEmployeeDetailsFunc (
        pEmployeeId IN employees.employeeId%TYPE
    ) RETURN empDetailRec AS
        rec empDetailRec;
    BEGIN
        SELECT firstName, salary
        INTO rec.firstName, rec.salary
        FROM employees
        WHERE employeeId = pEmployeeId;
        RETURN rec;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL; -- Or an empty record, depending on desired handling
    END getEmployeeDetailsFunc;
    vEmpId employees.employeeId%TYPE := 103;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- More Efficient Approach (Function returning Record) ---');
    vEmpRec := getEmployeeDetailsFunc(vEmpId);
    IF vEmpRec.firstName IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Employee: ' || vEmpRec.firstName || ', Salary: ' || vEmpRec.salary);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
    END IF;
END;
/
```
<p><strong>Inefficiency of the First Approach:</strong><br>
The first approach executes two separate <code>SELECT</code> statements against the <code>employees</code> table for the same <code>employeeId</code>. This means two context switches between PL/SQL and SQL, and two separate lookups (potentially two index scans or reads).</p>
<p><strong>Advantage of the Second Approach:</strong><br>
The procedure <code>getEmployeeDetails</code> (or the function <code>getEmployeeDetailsFunc</code>) retrieves both <code>firstName</code> and <code>salary</code> in a single <code>SELECT</code> statement. This results in:</p>
<ol>
    <li><strong>One Context Switch:</strong> Only one transition from PL/SQL to SQL and back.</li>
    <li><strong>Single Data Access:</strong> The database fetches the required data for the row once.</li>
</ol>
This is generally more performant, especially if the queries are more complex or the table is large.

### Category: Combined - Cursors and Stored Procedures & Functions

#### (iv) Hardcore Combined Problem

**Problem:**
Create a PL/SQL stored procedure named `processDepartmentRaises` with the following requirements:
*(Problem description as previously provided)*

<div class="postgresql-bridge">
<strong>Foundational PostgreSQL Concepts to Leverage (and contrast with Oracle way):</strong>
<ul>
    <li>Looping through query results (PostgreSQL <code>FOR rec IN SELECT ... LOOP</code>).</li>
    <li>Functions and Procedures (PostgreSQL combines these more; Oracle has distinct <code>PROCEDURE</code> and <code>FUNCTION</code>).</li>
    <li>Transaction control (similar, but Oracle savepoints are part of the standard flow).</li>
</ul>
</div>
<div class="oracle-specific">
<strong>Previous Oracle Concepts to Integrate:</strong>
<ul>
    <li>PL/SQL Block Structure, Variables (<code>%TYPE</code>, <code>%ROWTYPE</code>).</li>
    <li>Conditional Control (<code>IF-THEN-ELSIF-ELSE</code>).</li>
    <li>SQL within PL/SQL (<code>SELECT INTO</code>, <code>UPDATE</code>).</li>
    <li>Implicit Cursor Attributes (<code>SQL%FOUND</code>, <code>SQL%ROWCOUNT</code>).</li>
    <li>Explicit Cursors (DECLARE, OPEN, FETCH, CLOSE, attributes).</li>
    <li>Exception Handling (predefined, <code>OTHERS</code>).</li>
    <li><code>COMMIT</code>, <code>ROLLBACK</code>, <code>SAVEPOINT</code>.</li>
    <li><code>SYSDATE</code>, <code>TO_CHAR</code> (implicitly via default <code>salaryAudit.changeDate</code>).</li>
    <li><code>NVL</code>.</li>
</ul>
</div>

**Solution - Hardcore Combined Problem:**
```sql
CREATE OR REPLACE PROCEDURE processDepartmentRaises (
    pDepartmentName IN VARCHAR2,
    pRaisePercentage IN NUMBER,
    pDepartmentBudget IN NUMBER,
    pEmployeesUpdatedCount OUT NUMBER,
    pStatusMessage OUT VARCHAR2
) AS
    vDepartmentId departments.departmentId%TYPE;
    vCurrentSalary employees.salary%TYPE;
    vRaiseAmount NUMBER;
    vNewSalary employees.salary%TYPE;
    vTotalRaiseCostForDepartment NUMBER := 0;
    vEmployeeCountInDept NUMBER := 0;
    vActualUpdates NUMBER := 0;

    -- Explicit cursor for fetching employees of the target department
    CURSOR cEmployeesInDept (cpDepartmentId IN departments.departmentId%TYPE) IS
        SELECT employeeId, salary
        FROM employees
        WHERE departmentId = cpDepartmentId;
    
    empRec cEmployeesInDept%ROWTYPE; -- Record for cursor rows

    -- Private helper procedure for logging
    PROCEDURE logSalaryChange(
        prEmployeeId IN employees.employeeId%TYPE,
        prOldSalary IN employees.salary%TYPE,
        prNewSalary IN employees.salary%TYPE,
        prNotes IN VARCHAR2
    ) AS
    BEGIN
        INSERT INTO salaryAudit (employeeId, oldSalary, newSalary, changedBy, notes)
        VALUES (prEmployeeId, prOldSalary, prNewSalary, 'PROC_RAISE', prNotes);
    END logSalaryChange;

BEGIN
    pEmployeesUpdatedCount := 0; -- Initialize OUT parameter

    -- 1. Find departmentId
    BEGIN
        SELECT departmentId INTO vDepartmentId
        FROM departments
        WHERE departmentName = pDepartmentName;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            pStatusMessage := 'Department not found: ' || pDepartmentName;
            RETURN;
        WHEN TOO_MANY_ROWS THEN
            pStatusMessage := 'Multiple departments found with name: ' || pDepartmentName;
            RETURN;
    END;

    -- 2. Establish SAVEPOINT
    SAVEPOINT before_dept_raises;

    -- 3. First pass: Calculate total raise cost and count employees
    OPEN cEmployeesInDept(vDepartmentId);
    LOOP
        FETCH cEmployeesInDept INTO empRec;
        EXIT WHEN cEmployeesInDept%NOTFOUND;
        
        vEmployeeCountInDept := vEmployeeCountInDept + 1;
        vRaiseAmount := empRec.salary * (pRaisePercentage / 100);
        vTotalRaiseCostForDepartment := vTotalRaiseCostForDepartment + vRaiseAmount;
    END LOOP;
    CLOSE cEmployeesInDept; -- Close after first pass

    -- 4. Check budget and employee count
    IF vEmployeeCountInDept = 0 THEN
        pStatusMessage := 'No employees found in department: ' || pDepartmentName;
        -- No need to rollback as no DML was done yet.
        RETURN;
    END IF;

    IF vTotalRaiseCostForDepartment > pDepartmentBudget THEN
        ROLLBACK TO before_dept_raises;
        pStatusMessage := 'Over budget for department ' || pDepartmentName || 
                          '. Required: ' || TO_CHAR(vTotalRaiseCostForDepartment) || 
                          ', Budget: ' || TO_CHAR(pDepartmentBudget) || '. No salaries updated.';
        RETURN;
    END IF;

    -- 5. Second pass: Apply raises if within budget
    -- Re-open cursor or use stored data. For simplicity, re-opening.
    -- A more optimized approach for large datasets might store IDs and old salaries from the first pass.
    OPEN cEmployeesInDept(vDepartmentId);
    LOOP
        FETCH cEmployeesInDept INTO empRec;
        EXIT WHEN cEmployeesInDept%NOTFOUND;

        vRaiseAmount := empRec.salary * (pRaisePercentage / 100);
        vNewSalary := empRec.salary + vRaiseAmount;

        UPDATE employees
        SET salary = vNewSalary
        WHERE employeeId = empRec.employeeId;

        IF SQL%FOUND THEN -- Check if update was successful for this specific employee
            vActualUpdates := vActualUpdates + 1;
            logSalaryChange(empRec.employeeId, empRec.salary, vNewSalary, 'Departmental Raise: ' || pDepartmentName);
        END IF;
    END LOOP;
    CLOSE cEmployeesInDept;

    pEmployeesUpdatedCount := vActualUpdates;
    pStatusMessage := 'Salaries updated successfully for ' || pEmployeesUpdatedCount || 
                      ' employees in department ' || pDepartmentName || '.';
    COMMIT; -- Commit all changes for this department

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO before_dept_raises; -- Rollback to savepoint on any unexpected error
        pStatusMessage := 'An unexpected error occurred: ' || SQLCODE || ' - ' || SQLERRM;
        pEmployeesUpdatedCount := 0;
        -- Ensure cursor is closed if an error happened while it was open
        IF cEmployeesInDept%ISOPEN THEN
            CLOSE cEmployeesInDept;
        END IF;
END processDepartmentRaises;
/

-- Test cases for the hardcore procedure
SET SERVEROUTPUT ON;
DECLARE
    vUpdatedCount NUMBER;
    vMessage VARCHAR2(500);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test Case 1: IT Department, 10% raise, Budget 10000 ---');
    processDepartmentRaises('IT', 10, 10000, vUpdatedCount, vMessage);
    DBMS_OUTPUT.PUT_LINE('Updated: ' || vUpdatedCount || ', Message: ' || vMessage);
    -- Verify audit log if successful
    FOR r IN (SELECT * FROM salaryAudit WHERE changedBy = 'PROC_RAISE' AND notes LIKE '%IT%') LOOP
        DBMS_OUTPUT.PUT_LINE('Audit: Emp ' || r.employeeId || ' Old: ' || r.oldSalary || ' New: ' || r.newSalary);
    END LOOP;
    ROLLBACK; -- Revert for next test

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Case 2: Sales Department, 5% raise, Budget 1000 (should be over budget) ---');
    processDepartmentRaises('Sales', 5, 1000, vUpdatedCount, vMessage);
    DBMS_OUTPUT.PUT_LINE('Updated: ' || vUpdatedCount || ', Message: ' || vMessage);
    ROLLBACK;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Case 3: NonExistent Department ---');
    processDepartmentRaises('NonExistent', 5, 5000, vUpdatedCount, vMessage);
    DBMS_OUTPUT.PUT_LINE('Updated: ' || vUpdatedCount || ', Message: ' || vMessage);
    ROLLBACK;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Case 4: Department with no employees (if any) ---');
    -- Assuming department 'Administration' might have fewer or no employees directly assigned complex salaries
    -- Let's create one to test this, or ensure one exists
    INSERT INTO departments (departmentId, departmentName, location) VALUES (70, 'Research', 'Virtual');
    COMMIT;
    processDepartmentRaises('Research', 5, 5000, vUpdatedCount, vMessage);
    DBMS_OUTPUT.PUT_LINE('Updated: ' || vUpdatedCount || ', Message: ' || vMessage);
    DELETE FROM departments WHERE departmentId = 70;
    COMMIT;

END;
/
```

</div>

<div class="container">

## Tips for Success & Learning

To get the most out of these exercises:
*   **Experiment and Explore:** Don't just run the solutions. Try modifying them. What happens if you change a parameter mode? What if a cursor fetches no data?
*   **Understand the *Why*:** For each solution, make sure you understand why it works and why it's an Oracle-idiomatic way.
*   **Consult the Docs:** If a concept is new or unclear, the Oracle PL/SQL Language Reference and Oracle SQL Language Reference are your best friends.
    <div class="rhyme">
    When doubt casts a shadow, or questions arise,<br>
    The Oracle manuals hold wisdom, so very wise.
    </div>
*   **Tackle Challenges Step-by-Step:** For the "Hardcore Combined Problem," break it down into smaller, manageable parts. Test each part as you build it.
*   **Error Messages are Clues:** Oracle's error messages (like `ORA-xxxxx`) can seem cryptic at first, but they often point directly to the issue. Learn to interpret them.

</div>

<div class="container">

## Conclusion & Next Steps

Well done on working through these exercises! Mastering cursors and stored program units is fundamental to effective PL/SQL development and harnessing the full power of Oracle Database.

<div class="rhyme">
With cursors now flowing, and functions so keen,<br>
Your PL/SQL prowess, a magnificent scene!
</div>

You're now better equipped to handle complex data processing and build modular, efficient applications in Oracle.

**Next Up:** Prepare to delve into **PL/SQL Packages**, a cornerstone of Oracle development for organizing your code, managing state, and building robust applications.

</div>