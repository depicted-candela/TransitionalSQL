<head>
    <link rel="stylesheet" href="../styles/exercises.css">
</head>

<div class="container">

# PL/SQL Precision: Cursors, Procedures, and Data Flow - Practice Exercises

Welcome to the practice arena for *PL/SQL Precision: Cursors, Procedures, and Data Flow*! These exercises are crafted to sharpen your skills, moving from PostgreSQL's familiar grounds to Oracle's powerful PL/SQL landscape with Oracle DB 23ai. Get ready to loop with finesse and craft procedures that sing!

## Learning Objectives

Upon completing these exercises, you will be able to:

*   Understand and utilize **Oracle implicit cursors** and their attributes (`SQL%FOUND`, `SQL%NOTFOUND`, `SQL%ROWCOUNT`, `SQL%ISOPEN`).
*   Master the declaration, opening, fetching, and closing of **Oracle explicit cursors**.
*   Implement **cursor FOR loops** for efficient and concise row-by-row processing in Oracle.
*   Identify and handle common pitfalls associated with cursor usage in Oracle PL/SQL.
*   Create and execute **Oracle stored procedures and functions** with various parameter modes (`IN`, `OUT`, `IN OUT`).
*   Understand the behavior and purpose of the `RETURN` statement in Oracle functions.
*   Recognize Oracle-specific syntax and best practices for procedural logic, especially when contrasting with PostgreSQL approaches.
*   Apply these concepts to solve complex data processing tasks in an Oracle environment.

## Prerequisites & Setup

To make the most of these exercises, you should have a solid understanding of:

*   **From "The Original PostgreSQL Course Sequence":**
    *   Basic SQL (WHERE, ORDER BY).
    *   Intermediate SQL (Aggregators, Joins, Date Functions, CASE).
    *   Procedural concepts (Loops, Conditionals, Functions in PostgreSQL).
*   **From "Server Programming with Oracle (DB 23 ai) PL/SQL: A Transition Guide for PostgreSQL Users" (Previous Sections):**
    *   Key Differences & Core Syntax (Oracle Data Types, DUAL, NULL Handling, ROWNUM).
    *   Date Functions, String Functions, Set Operators, Hierarchical Queries, Analytic Functions (Oracle syntax).
    *   DML & Transaction Control (Oracle context).
    *   PL/SQL Fundamentals (Block Structure, Variables, Conditional & Iterative Control, SQL within PL/SQL).

### Dataset Guidance

A complete Oracle SQL script for defining and populating the necessary tables is provided below within the "Exercises & Dataset" section.

**To set up the dataset:**

1.  **Connect** to your Oracle DB 23ai free environment using a tool like SQL Developer, SQL\*Plus, or Oracle Live SQL.
2.  **Copy and paste** the entire `CREATE TABLE` and `INSERT INTO` script block provided into your SQL tool.
3.  **Execute** the script. This will create three tables: `departments`, `employees`, and `salaryAudit`.
    *   `departments`: Stores department information.
    *   `employees`: Stores employee details, including their department and salary.
    *   `salaryAudit`: Will be used to log salary changes made by some procedures.
4.  Ensure the script runs without errors. A `COMMIT` statement is included at the end of the population script.

*It's crucial to have this dataset ready before you start,
Or your queries and procedures might just fall apart!*

## Exercise Structure Overview

The exercises are structured to build your understanding progressively:

*   **Meanings, Values, Relations, and Advantages:** Focus on the core concepts and their benefits, bridging from PostgreSQL where applicable.
*   **Disadvantages and Pitfalls:** Explore common issues and limitations specific to Oracle's implementation.
*   **Contrasting with Inefficient Common Solutions:** Compare Oracle-idiomatic approaches with less optimal ones you might encounter.
*   **Hardcore Combined Problem:** A complex scenario integrating all concepts from this and preceding sections.

*Attempt each problem first, give your mind a good test,
Then check the solution, and put your skills to their best!*

## Exercises & Dataset
<hr/>
<br/>

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

## Category: Cursors
(Implicit Cursors, Explicit Cursors, Cursor FOR Loops)

### (i) Meanings, Values, Relations, and Advantages

**Exercise C1:**
**Problem:** Write a PL/SQL anonymous block that attempts to update the salary of an employee with `employeeId = 999` (who does not exist) by increasing it by 10%. After the `UPDATE` statement, use Oracle's implicit cursor attributes to display:
1.  Whether any row was found and updated (`SQL%FOUND`).
2.  Whether no row was found and updated (`SQL%NOTFOUND`).
3.  The number of rows affected (`SQL%ROWCOUNT`).

**Exercise C2:**
**Problem:** Write a PL/SQL anonymous block that declares an explicit cursor to fetch the `firstName`, `lastName`, and `salary` of all employees in the 'IT' department. Loop through the cursor, fetching one row at a time, and display the details. Ensure the cursor is properly opened and closed. Use `%TYPE` for variable declarations.

**Exercise C3:**
**Problem:** Rewrite the previous exercise (C2) using a cursor FOR loop to display the `firstName`, `lastName`, and `salary` of all employees in the 'IT' department.

**Exercise C4:**
**Problem:** Explain the meaning and demonstrate the use of `SQL%ISOPEN` with an implicit cursor and an explicit cursor. Why does `SQL%ISOPEN` always return `FALSE` for implicit cursors after the SQL statement execution?

### (ii) Disadvantages and Pitfalls

**Exercise C5:**
**Problem:** Write a PL/SQL block that declares an explicit cursor but forgets to close it after processing. Then, write another PL/SQL block that tries to open the *same named cursor* again (simulate this by running the first block, then the second in a SQL*Plus session or similar tool where session state persists for cursors if not properly managed). What is the potential issue here, and what Oracle error might you encounter?

**Exercise C6:**
**Problem:** A PL/SQL block uses `SELECT ... INTO` to fetch an employee's salary. What are two common exceptions (pitfalls) that can occur with `SELECT ... INTO` if the `WHERE` clause is not carefully constructed, and how can an explicit cursor or cursor FOR loop mitigate one of them?

### (iii) Contrasting with Inefficient Common Solutions

**Exercise C7:**
**Problem:** A developer needs to process all employees from the 'Sales' department. They write a PL/SQL block that first counts the total number of 'Sales' employees using one `SELECT COUNT(*)` query, and then uses this count in a `WHILE` loop with an explicit cursor, fetching one employee at a time and manually incrementing a counter to stop the loop.
Demonstrate this potentially less efficient approach. Then, provide the more Oracle-idiomatic and efficient solution using a cursor `FOR` loop or an explicit cursor with `EXIT WHEN %NOTFOUND`. Explain why the latter is generally preferred.

## Category: Stored Procedures & Functions

### (i) Meanings, Values, Relations, and Advantages

**Exercise SP1:**
**Problem:** Create an Oracle stored procedure named `addDepartment` that accepts `departmentId`, `departmentName`, and `location` as `IN` parameters and inserts a new department into the `departments` table. Demonstrate invoking this procedure.

**Exercise SP2:**
**Problem:** Create an Oracle stored function named `getEmployeeFullName` that takes an `employeeId` (`IN` parameter) and returns the employee's full name (firstName || ' ' || lastName) as a `VARCHAR2`. Demonstrate its use in a `SELECT` statement and a PL/SQL block.

**Exercise SP3:**
**Problem:** Create a procedure `updateEmployeeJobAndGetOldJob` that takes `employeeId` and a `newJobId` as `IN` parameters. It should update the employee's `jobId`. The procedure must also return the employee's *old* `jobId` using an `OUT` parameter.

**Exercise SP4:**
**Problem:** Create a procedure `processSalary` that takes an `employeeId` as an `IN` parameter and a `currentSalary` as an `IN OUT` parameter. The procedure should:
1.  Fetch the employee's current salary into the `IN OUT` parameter.
2.  If the fetched salary is less than 60000, increase the `currentSalary` (which is the `IN OUT` parameter) by 10% within the procedure.
3.  The calling block should see the modified salary.

### (ii) Disadvantages and Pitfalls

**Exercise SP5:**
**Problem:** A function is designed to calculate an annual bonus (10% of salary) but mistakenly attempts to perform an `UPDATE` statement inside it to log the bonus calculation. Why is this problematic if the function is intended to be called from a `SELECT` query? What Oracle error would occur?

**Exercise SP6:**
**Problem:** A procedure has an `OUT` parameter. Inside the procedure, there's an `IF-THEN-ELSIF` structure. One of the `ELSIF` branches does not assign a value to the `OUT` parameter. What is the state of the `OUT` parameter in the calling environment if that branch is executed? How does this differ from an `IN OUT` parameter?

### (iii) Contrasting with Inefficient Common Solutions

**Exercise SP7:**
**Problem:** A developer needs to retrieve an employee's `firstName` and `salary` for a given `employeeId`. They create two separate functions: `getEmpFirstName(p_id IN NUMBER) RETURN VARCHAR2` and `getEmpSalary(p_id IN NUMBER) RETURN NUMBER`. In their main PL/SQL block, they call these two functions sequentially for the same `employeeId`.
Show this approach. Then, provide a more efficient Oracle-idiomatic solution using a single procedure with `OUT` parameters or a function returning a record type. Explain the inefficiency of the first approach.

## Category: Combined - Cursors and Stored Procedures & Functions

### (iv) Hardcore Combined Problem

**Problem:**
Create a PL/SQL stored procedure named `processDepartmentRaises` with the following requirements:
1.  **Parameters:**
    *   `pDepartmentName` (IN VARCHAR2): The name of the department to process.
    *   `pRaisePercentage` (IN NUMBER): The percentage to increase salaries by (e.g., 5 for 5%).
    *   `pDepartmentBudget` (IN NUMBER): The maximum total amount that can be added to salaries in this department for this raise cycle.
    *   `pEmployeesUpdatedCount` (OUT NUMBER): The number of employees whose salaries were actually updated.
    *   `pStatusMessage` (OUT VARCHAR2): A message indicating success, "Over budget", "No employees found", "Department not found", or other errors.

2.  **Logic:**
    *   The procedure should first find the `departmentId` for the given `pDepartmentName`. If not found, set an appropriate `pStatusMessage` and exit.
    *   Establish a `SAVEPOINT` before attempting any salary updates for the department.
    *   Use an explicit cursor to iterate through all employees belonging to the found `departmentId`.
    *   For each employee:
        *   Calculate the `raiseAmount`.
        *   Calculate the `newSalary`.
        *   Keep a running `totalRaiseCostForDepartment`.
    *   After iterating:
        *   If no employees were found, set status.
        *   If `totalRaiseCostForDepartment` > `pDepartmentBudget`, `ROLLBACK` to savepoint, set status.
        *   Otherwise, iterate again (or use stored data) to `UPDATE` salaries, log each update to `salaryAudit` (you can use a helper private procedure), count updates, set status, and `COMMIT`.
    *   Handle unexpected errors gracefully.

<br/>
<hr/>

## Tips for Success & Learning

*   **Experiment Freely:** Don't just run the solutions. Modify them, try different approaches, and see what happens. *The best way to learn the rules, is to sometimes bend them like fools! (But then fix them, of course).*
*   **Understand the "Why":** Focus not just on *how* a solution works, but *why* it's the Oracle-idiomatic way. Consider performance and readability.
*   **Oracle Docs are Your Friend:** For deep dives on any concept, the official Oracle documentation is invaluable.
*   **Break Down Problems:** If a hardcore problem seems daunting, break it into smaller, manageable pieces. *A mountain's climbed one step, not in a single, giant leap!*
*   **Embrace the Oracle Way:** While your PostgreSQL knowledge is a great foundation, be open to Oracle's specific syntax and features. Some things are different, and that's where the new learning shines!

## Conclusion & Next Steps

Great job tackling these exercises! You're building a strong bridge from PostgreSQL to the world of Oracle PL/SQL. The concepts of cursors, procedures, and functions are fundamental, and mastering them here will pay dividends.

*With cursors and procs, your PL/SQL will gleam,
Ready for packages, a powerful, organized dream!*

Next up in your "Server Programming with Oracle (DB 23 ai) PL/SQL: A Transition Guide for PostgreSQL Users" journey are **Packages**. Get ready to organize your code like a pro!

</div>