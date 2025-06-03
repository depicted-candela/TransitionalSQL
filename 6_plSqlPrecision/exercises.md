<head>
    <link rel="stylesheet" href="../styles/exercises.css">
</head>

<div class="container">

# PL/SQL Precision: Cursors, Procedures, and Data Flow - Exercises

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
    <p>To tackle these exercises, you'll need our practice dataset. A complete Oracle SQL script is provided below (or will be inserted by the generation tool) to create the necessary tables (`departments`, `employees`, `salaryAudit`) and populate them with sample data. </p>
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
Before peeking at answers, if you dare!
</div>
</div>

<div class="container">

## Exercises: PL/SQL Precision

<!-- ### INSERT PRE-GENERATED EXERCISES AND SOLUTIONS HERE ### -->
<!-- The previously generated Markdown for exercises (C1-C7, SP1-SP7, and Hardcore Problem) -->
<!-- including their problem descriptions and solutions, and the dataset script, -->
<!-- would be programmatically inserted into this location. -->
<!-- For now, I will manually paste the dataset and one example from each category of exercise. -->

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

---
*(... Other exercises C2-C7 would be listed here ...)*
---

### Category: Stored Procedures & Functions

#### (i) Meanings, Values, Relations, and Advantages

**Exercise SP1:**
**Problem:** Create an Oracle stored procedure named `addDepartment` that accepts `departmentId`, `departmentName`, and `location` as `IN` parameters and inserts a new department into the `departments` table. Demonstrate invoking this procedure.
<div class="oracle-specific">
<strong>Advantage:</strong> Procedures encapsulate DML logic, promoting reusability and maintainability. Parameters allow for dynamic data input.
</div>

---
*(... Other exercises SP2-SP7 would be listed here ...)*
---

### Category: Combined - Cursors and Stored Procedures & Functions

#### (iv) Hardcore Combined Problem

**Problem:**
Create a PL/SQL stored procedure named `processDepartmentRaises` with the following requirements:
1.  **Parameters:**
    *   `pDepartmentName` (IN VARCHAR2): The name of the department to process.
    *   `pRaisePercentage` (IN NUMBER): The percentage to increase salaries by (e.g., 5 for 5%).
    *   `pDepartmentBudget` (IN NUMBER): The maximum total amount that can be added to salaries in this department for this raise cycle.
    *   `pEmployeesUpdatedCount` (OUT NUMBER): The number of employees whose salaries were actually updated.
    *   `pStatusMessage` (OUT VARCHAR2): A message indicating success, "Over budget", "No employees found", "Department not found", or other errors.

2.  **Logic:**
    *   The procedure should first find the `departmentId` for the given `pDepartmentName`. If not found, set an appropriate `pStatusMessage` and exit. (Hint: `SELECT INTO`, handle `NO_DATA_FOUND`).
    *   Establish a `SAVEPOINT` before attempting any salary updates for the department.
    *   Use an explicit cursor to iterate through all employees belonging to the found `departmentId`.
    *   For each employee:
        *   Calculate the `raiseAmount` (current salary * `pRaisePercentage` / 100).
        *   Calculate the `newSalary` (current salary + `raiseAmount`).
        *   Keep a running `totalRaiseCostForDepartment`.
    *   After iterating through all employees in the department (or if no employees are found):
        *   If no employees were found in the department, set `pStatusMessage` to "No employees found" and `pEmployeesUpdatedCount` to 0.
        *   If `totalRaiseCostForDepartment` exceeds `pDepartmentBudget`:
            *   `ROLLBACK` to the savepoint.
            *   Set `pStatusMessage` to "Over budget. No salaries updated for department [departmentName]."
            *   Set `pEmployeesUpdatedCount` to 0.
        *   Otherwise (if within budget and employees exist):
            *   Iterate through the employees of the department again (you might re-open the cursor or use a second cursor, or store employee IDs from the first pass if memory allows and it's efficient).
            *   For each employee, `UPDATE` their `salary` to the calculated `newSalary`.
            *   After each successful `UPDATE`, log the change into the `salaryAudit` table (employeeId, oldSalary, newSalary, changedBy='PROC_RAISE', notes='Departmental Raise'). You can create a helper private procedure within `processDepartmentRaises` for this logging.
            *   Count the number of successfully updated employees and set `pEmployeesUpdatedCount`.
            *   Set `pStatusMessage` to "Salaries updated successfully for [count] employees in department [departmentName]."
            *   `COMMIT` the transaction (if all updates are successful and within budget).
    *   Use appropriate exception handling for unexpected errors.

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

Well done on working through (or preparing to work through) these exercises! Mastering cursors and stored program units is fundamental to effective PL/SQL development and harnessing the full power of Oracle Database.

<div class="rhyme">
With cursors now flowing, and functions so keen,<br>
Your PL/SQL prowess, a magnificent scene!
</div>

You're now better equipped to handle complex data processing and build modular, efficient applications in Oracle.

**Next Up:** Prepare to delve into **PL/SQL Packages**, a cornerstone of Oracle development for organizing your code, managing state, and building robust applications.

</div>