<style>
  body {
    font-family: 'Oracle Sans', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.65;
    color: #e0e0e0; /* Soft white text */
    background-color: #1a1a24; /* Deep blue-black background */
    margin: 0;
    padding: 20px;
    background-image: radial-gradient(circle at 10% 20%, #2a2a3a 0%, transparent 20%),
                      radial-gradient(circle at 90% 80%, #2a2a3a 0%, transparent 20%);
    transition: all 0.3s ease-in-out;
  }
  
  .container {
    max-width: 950px;
    margin: auto;
    background-color: #252535; /* Slightly lighter than body */
    padding: 35px;
    border-radius: 6px;
    box-shadow: 0 4px 30px rgba(0, 0, 30, 0.5);
    border: 1px solid #3a3a4a; /* Subtle border */
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .container:hover {
    box-shadow: 0 6px 35px rgba(0, 80, 150, 0.3);
  }
  
  h1, h2, h3 {
    color: #4db8ff; /* Oracle brand blue */
    font-weight: 500;
    letter-spacing: 0.5px;
    transition: color 0.2s ease;
  }
  
  h1 {
    border-bottom: 2px solid #ff8c00; /* Oracle accent orange */
    padding-bottom: 12px;
    font-size: 2.6em;
    text-align: center;
    margin-bottom: 30px;
    text-shadow: 0 2px 4px rgba(0, 100, 200, 0.2);
  }
  
  h2 {
    font-size: 1.9em;
    margin-top: 35px;
    border-left: 4px solid #4db8ff;
    padding-left: 15px;
  }
  
  h3 {
    font-size: 1.5em;
    color: #6bd4ff; /* Lighter blue for h3 */
  }
  
  p, li {
    font-size: 1.05em;
    margin-bottom: 12px;
    color: #d0d0e0; /* Slightly brighter text */
  }
  
  code {
    font-family: 'Oracle Mono', 'Consolas', 'Monaco', monospace;
    background-color: #1e1e2e; /* Dark blue-gray */
    padding: 3px 8px;
    border-radius: 4px;
    font-size: 0.95em;
    color: #f0f0f0;
    border: 1px solid #3a3a5a;
    transition: all 0.2s ease;
  }
  
  code:hover {
    background-color: #252540;
  }
  
  pre {
    background-color: #1e1e2e;
    padding: 18px;
    border-radius: 6px;
    overflow-x: auto;
    border: 1px solid #3a3a5a;
    box-shadow: inset 0 1px 10px rgba(0, 0, 0, 0.3);
    transition: all 0.3s ease;
  }
  
  pre:hover {
    border-color: #4db8ff;
    box-shadow: inset 0 1px 15px rgba(0, 100, 200, 0.2);
  }
  
  pre code {
    background-color: transparent;
    padding: 0;
    border-radius: 0;
    font-size: 0.92em;
    border: none;
    color: #f0f0f0;
  }
  
  /* Oracle-themed boxes */
  .info-box, .tip-box, .objective-box, .sql-box {
    padding: 18px 20px;
    margin: 25px 0;
    border-radius: 6px;
    border-left: 5px solid;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .info-box {
    background-color: rgba(0, 100, 150, 0.1);
    border-color: #4db8ff; /* Oracle blue */
  }
  
  .info-box h3 {
    color: #4db8ff;
    margin-top: 0;
  }
  
  .tip-box {
    background-color: rgba(255, 140, 0, 0.08);
    border-color: #ff8c00; /* Oracle orange */
  }
  
  .tip-box h3 {
    color: #ff8c00;
    margin-top: 0;
  }
  
  .objective-box {
    background-color: rgba(0, 150, 100, 0.08);
    border-color: #00c176; /* Oracle green */
  }
  
  .objective-box h3 {
    color: #00c176;
    margin-top: 0;
  }
  
  .sql-box {
    background-color: rgba(77, 184, 255, 0.05);
    border-color: #4db8ff;
    border-left-width: 8px;
  }
  
  .sql-box h3 {
    color: #4db8ff;
    margin-top: 0;
  }
  
  .sql-box pre {
    background-color: rgba(0, 0, 0, 0.2);
  }
  
  .highlight-primary {
    color: #4db8ff;
    font-weight: 500;
    text-shadow: 0 0 8px rgba(77, 184, 255, 0.3);
  }
  
  .highlight-secondary {
    color: #ff8c00;
    font-weight: 500;
  }
  
  .emphasize {
    font-style: italic;
    color: #6bd4ff; /* Light Oracle blue */
    border-bottom: 1px dotted #6bd4ff;
    padding-bottom: 1px;
  }
  
  a {
    color: #4db8ff;
    text-decoration: none;
    transition: all 0.2s ease;
    font-weight: 500;
  }
  
  a:hover {
    color: #6bd4ff;
    text-decoration: underline;
    text-shadow: 0 0 8px rgba(77, 184, 255, 0.3);
  }
  
  /* Special Oracle SQL elements */
  .sql-keyword {
    color: #ff8c00; /* Oracle orange for keywords */
    font-weight: bold;
  }
  
  .sql-function {
    color: #6bd4ff; /* Light blue for functions */
  }
  
  .sql-comment {
    color: #7f7f9f; /* Gray for comments */
    font-style: italic;
  }
  
  /* Smooth scroll behavior */
  html {
    scroll-behavior: smooth;
  }
  
  /* Fade-in animation for content */
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  .container > * {
    animation: fadeIn 0.5s ease-out forwards;
  }
</style>

<div class="container">

# Oracle SQL Practice: Mastering Dates, Strings, Sets, and DML/TCL

## Introduction / Learning Objectives

Welcome to this set of practical exercises focusing on crucial SQL functionalities within the Oracle Database environment. These exercises are designed to solidify your understanding of <span class="highlight-primary">Date Functions, String Functions, Set Operators, and Data Manipulation Language (DML) with Transaction Control</span>.

If you're journeying from PostgreSQL, you'll find these drills particularly helpful. They highlight Oracle's specific syntax, its unique functions (like `MINUS` or `MERGE`), and how its data types (like `DATE` always including time) influence query construction. *From Postgres ways to Oracle days, these tasks will light your coding maze!*

<div class="objective-box">
<h3>🎯 Learning Objectives</h3>
<p>Upon completing these exercises, you will be able to:</p>
<ul>
    <li>Effectively use Oracle-specific date functions (<code>SYSDATE</code>, <code>ADD_MONTHS</code>, <code>MONTHS_BETWEEN</code>, etc.) and understand date arithmetic nuances.</li>
    <li>Confidently manipulate strings using Oracle's common and unique functions (<code>SUBSTR</code>, <code>INSTR</code>, <code>REPLACE</code>, <code>||</code>, <code>REGEXP_SUBSTR</code>).</li>
    <li>Employ Oracle set operators, including the PostgreSQL-analogous <code>MINUS</code> (<code>EXCEPT</code>), <code>INTERSECT</code>, and <code>UNION</code>, understanding their behavior with Oracle data types.</li>
    <li>Execute core DML operations (<code>INSERT</code>, <code>UPDATE</code>, <code>DELETE</code>) and manage transactions with <code>COMMIT</code>, <code>ROLLBACK</code>, and <code>SAVEPOINT</code>.</li>
    <li>Leverage the powerful Oracle-specific <code>MERGE</code> statement for conditional DML.</li>
    <li>Identify and avoid common pitfalls associated with these functions and operations in Oracle.</li>
    <li>Appreciate the advantages of Oracle-idiomatic solutions over less efficient approaches.</li>
    <li>Integrate multiple concepts to solve complex data manipulation problems.</li>
</ul>
</div>

## Prerequisites & Setup

Before diving in, ensure you're comfortable with the following concepts:

*   **From the PostgreSQL-based "SQL Sequentially" course:**
    *   Core SQL: `SELECT`, `FROM`, `WHERE`, `JOIN` (various types), `GROUP BY`, `HAVING`, `ORDER BY`.
    *   Basic understanding of string and date functions in PostgreSQL.
    *   Familiarity with PostgreSQL Set Operators (`EXCEPT`, `INTERSECT`, `UNION`).
    *   Fundamental DML (`INSERT`, `UPDATE`, `DELETE`) and Transaction Control (`BEGIN`, `COMMIT`, `ROLLBACK`).
*   **From the ORACLE-based "Transitional SQL" course:**
    *   **Key Differences & Core Syntax:**
        *   Oracle Data Types: `VARCHAR2`, `NUMBER`, `DATE` (and its time component), `TIMESTAMP`, `CLOB`, `BLOB`.
        *   The `DUAL` Table.
        *   NULL Handling: `NVL`, `NVL2`, `COALESCE`.
        *   Conditional Expressions: `CASE` (and awareness of `DECODE`).
        *   The `ROWNUM` Pseudo-column.

### Dataset Guidance

A comprehensive dataset is required to work through these exercises. The Oracle SQL scripts for creating tables (`CREATE TABLE`) and populating them with data (`INSERT INTO`) will be provided in the exercises section below.

<div class="info-box">
<h3><span class="highlight-primary">Setting Up Your Practice Environment</span></h3>
<ol>
    <li><strong>Obtain the Scripts:</strong> The <code>CREATE TABLE</code> and <code>INSERT INTO</code> statements are part of the exercise material.</li>
    <li>
        <strong>Execute in Oracle:</strong> Run these scripts in your Oracle DB 21ai environment. You can use tools like:
        <ul>
            <li><strong>SQL Developer or SQL*Plus:</strong> Run firstly <strong>NewSchema.sql</strong> in the SQL terminal to create the new schema for the exercises. See <strong>NewSchema.md</strong> for a better explanation
            And then modify the .sql file in the section <strong>Dataset Definition (DDL)</strong> in the following way
            <pre><code class="language-sql">
              BEGIN
                EXECUTE IMMEDIATE 'DROP TABLE EmployeeUpdatesForMerge';
              EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
            </code></pre>
            shuld be
            <pre><code class="language-sql">
              BEGIN
                EXECUTE IMMEDIATE 'DROP TABLE basic_oracle_uniqueness.EmployeeUpdatesForMerge';
              EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
            </code></pre>
            And the same for all tables always when they're mentioned
            <li><strong>SQL Developer:</strong> Copy and paste the script into a worksheet the created .sql and run it (F5 or the "Run Script" button).</li>
            <li><strong>SQL*Plus:</strong> Save the script to a <code>.sql</code> file (e.g., <code>setupLabData.sql</code>) and run it from the SQL*Plus command line using <code>@path/to/your/setupLabData.sql</code>.</li>
            <li><strong>Oracle Live SQL:</strong> Paste the DDL and DML into the SQL Worksheet and click "Run".</li>
        </ul>
    </li>
    <li><strong>Verify:</strong> After running the scripts, you can run a few <code>SELECT * FROM tableName;</code> queries to ensure the tables are created and populated correctly.</li>
</ol>
<p><span class="emphasize">Important:</span> Ensure the dataset is correctly set up <span class="highlight-secondary">before</span> attempting any exercises. This data foundation is key for each practical creation!</p>
</div>

**Brief Table Overview:**

*   `Departments`: Stores department information.
*   `Employees`: Contains employee details, including hire dates, job titles, salaries, and department affiliations. This is a central table for many exercises.
*   `Projects`: Information about company projects, including start/end dates and deadlines.
*   `ProjectAssignments`: Links employees to projects.
*   `ProductCatalogA` & `ProductCatalogB`: Two versions of a product catalog, used for set operator exercises.
*   `AuditLog`: A table to log DML changes, particularly used in the DML/TCL and hardcore problem sections.
*   `EmployeeUpdatesForMerge`: A source table used to demonstrate the `MERGE` statement.

## Exercise Structure Overview

The exercises are structured to progressively build your understanding and practical skills:

1.  **Meanings, Values, Relations, and Advantages:** Focus on the core purpose and benefits of each concept, especially highlighting Oracle-specific syntax and features when bridging from PostgreSQL.
2.  **Disadvantages and Pitfalls:** Explore common mistakes, limitations, and tricky aspects within the Oracle environment.
3.  **Contrasting with Inefficient Common Solutions:** Compare Oracle-idiomatic approaches with less optimal methods, demonstrating the advantages of using Oracle's features effectively.
4.  **Hardcore Combined Problem:** A complex challenge integrating concepts from this module and preceding ones, testing your cumulative knowledge.

*For each task, give it your best. Try the query, then view the solution, no need to be surly!*

## Tips for Success & Learning

<div class="tip-box">
<h3><span class="highlight-primary">Maximizing Your Learning Curve</span></h3>
<ul>
    <li><strong>Experiment Actively:</strong> Don't just run the provided solutions. Modify them! Change values, try different functions, and observe the outcomes. What happens if you use <code>TRUNC</code> instead of <code>ROUND</code> on a date? How does <code>SUBSTR</code> behave with negative indices?</li>
    <li><strong>Understand the "Why":</strong> Focus not just on *what* a solution does, but *why* it's the correct or most efficient way in Oracle. This is especially true when contrasting with PostgreSQL habits.</li>
    <li><strong>Consult Oracle Documentation:</strong> For functions or concepts that pique your interest, dive into the official Oracle SQL Language Reference. It's your ultimate guide for the nitty-gritty.</li>
    <li><strong>Break Down Complex Problems:</strong> If the "Hardcore Combined Problem" seems daunting, tackle it piece by piece. Solve each sub-requirement individually before combining them.</li>
    <li><strong>Use <code>DESC tableName</code>:</strong> Remind yourself of column names and data types quickly using the <code>DESCRIBE</code> command in SQL*Plus or SQL Developer.</li>
    <li><strong>Test with Edge Cases:</strong> Think about how queries would behave with <code>NULL</code> values, empty strings (which Oracle treats as <code>NULL</code> in <code>VARCHAR2</code>), or boundary conditions.</li>
</ul>
</div>

If you get stuck, first re-read the problem carefully. Then, review related concepts from the main course material or previous exercises. Sometimes, a short break can also bring fresh perspective!

## Exercises and Dataset

Here you'll find the dataset setup scripts and the exercises. Remember to run the dataset scripts in your Oracle environment *before* attempting the exercises.

<!-- PRE-GENERATED EXERCISES START HERE -->

### Dataset Definition and Population (Oracle SQL)

<div class="info-box">
<h3><span class="highlight-primary">Important: Run This First!</span></h3>
<p>Execute the following SQL DDL (<code>CREATE TABLE</code>) and DML (<code>INSERT INTO</code>) statements in your Oracle DB 21ai environment. This dataset is essential for all subsequent exercises in this module.</p>
</div>

<h4>Dataset Definition (DDL)</h4>
<pre><code class="language-sql">
-- Drop tables if they exist (for re-runnability)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE EmployeeUpdatesForMerge';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE AuditLog';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ProjectAssignments';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Projects';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Employees';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Departments';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ProductCatalogA';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ProductCatalogB';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/

-- Departments Table
CREATE TABLE Departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    locationCity VARCHAR2(50)
);

-- Employees Table
CREATE TABLE Employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50) NOT NULL,
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    jobTitle VARCHAR2(100),
    hireDate DATE,
    birthDate DATE,
    salary NUMBER(10, 2),
    commissionPct NUMBER(4, 2),
    departmentId NUMBER,
    managerId NUMBER,
    CONSTRAINT fk_emp_department FOREIGN KEY (departmentId) REFERENCES Departments(departmentId),
    CONSTRAINT fk_emp_manager FOREIGN KEY (managerId) REFERENCES Employees(employeeId)
);

-- Projects Table
CREATE TABLE Projects (
    projectId NUMBER PRIMARY KEY,
    projectName VARCHAR2(100) NOT NULL,
    startDate DATE,
    endDate DATE,
    deadlineTimestamp TIMESTAMP,
    projectStatus VARCHAR2(20) DEFAULT 'Pending'
);

-- ProjectAssignments Table
CREATE TABLE ProjectAssignments (
    assignmentId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    projectId NUMBER NOT NULL,
    employeeId NUMBER NOT NULL,
    assignmentDate DATE DEFAULT SYSDATE,
    role VARCHAR2(50),
    CONSTRAINT fk_pa_project FOREIGN KEY (projectId) REFERENCES Projects(projectId),
    CONSTRAINT fk_pa_employee FOREIGN KEY (employeeId) REFERENCES Employees(employeeId),
    CONSTRAINT uk_project_employee UNIQUE (projectId, employeeId)
);

-- ProductCatalogA Table
CREATE TABLE ProductCatalogA (
    productId VARCHAR2(10) PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    category VARCHAR2(50),
    listPrice NUMBER(8,2)
);

-- ProductCatalogB Table
CREATE TABLE ProductCatalogB (
    productId VARCHAR2(10) PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    category VARCHAR2(50),
    listPrice NUMBER(8,2)
);

-- AuditLog Table
CREATE TABLE AuditLog (
    logId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tableName VARCHAR2(100),
    operationType VARCHAR2(10), -- INSERT, UPDATE, DELETE
    operationTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    userId VARCHAR2(30) DEFAULT USER,
    details CLOB
);

-- EmployeeUpdatesForMerge Table (Source for MERGE)
CREATE TABLE EmployeeUpdatesForMerge (
    employeeId NUMBER PRIMARY KEY,
    newJobTitle VARCHAR2(100),
    newSalary NUMBER(10, 2),
    newDepartmentId NUMBER
);
</code></pre>

<h4>Dataset Population (DML)</h4>
<pre><code class="language-sql">
-- Populate Departments
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (10, 'Technology', 'New York');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (20, 'Human Resources', 'London');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (30, 'Sales', 'Paris');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (40, 'Marketing', 'New York');

-- Populate Employees
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (101, 'Alice', 'Smith', 'alice.smith@example.com', 'DBA', TO_DATE('2020-01-15', 'YYYY-MM-DD'), TO_DATE('1990-05-20', 'YYYY-MM-DD'), 90000, 0.10, 10, NULL);
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (102, 'Bob', 'Johnson', 'bob.johnson@example.com', 'Developer', TO_DATE('2019-03-01', 'YYYY-MM-DD'), TO_DATE('1985-08-15', 'YYYY-MM-DD'), 80000, NULL, 10, 101);
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (103, 'Carol', 'Williams', 'carol.w@example.com', 'HR Manager', TO_DATE('2021-07-22', 'YYYY-MM-DD'), TO_DATE('1992-11-30', 'YYYY-MM-DD'), 75000, 0.05, 20, NULL);
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (104, 'David', 'Brown', 'david.b@example.com', 'Sales Lead', TO_DATE('2018-05-10', 'YYYY-MM-DD'), TO_DATE('1980-02-25', 'YYYY-MM-DD'), 95000, 0.15, 30, NULL); -- Salary is 95000
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (105, 'Eve', 'Davis', 'eve.davis@example.com', 'Marketing Specialist', TO_DATE('2022-01-10', 'YYYY-MM-DD'), TO_DATE('1995-07-07', 'YYYY-MM-DD'), 65000, NULL, 40, NULL);
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (106, 'Frank', 'Miller', 'frank.miller@example.com', ' Developer ', TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('1998-01-10', 'YYYY-MM-DD'), 70000, 0.02, 10, 102);
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (107, 'Grace', 'Wilson', 'grace.w@example.com', 'Sales Intern', TO_DATE('2023-08-15', 'YYYY-MM-DD'), TO_DATE('2000-03-12', 'YYYY-MM-DD'), 40000, NULL, 30, 104);
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId) -- Added for Hardcore problem
VALUES (109, 'Kevin', 'Spacey', 'kevin.s@example.com', 'Senior Developer', TO_DATE('2019-07-01', 'YYYY-MM-DD'), TO_DATE('1988-04-10', 'YYYY-MM-DD'), 82000, NULL, 10, 101);


-- Populate Projects
INSERT INTO Projects (projectId, projectName, startDate, endDate, deadlineTimestamp, projectStatus)
VALUES (1, 'Omega System Upgrade', TO_DATE('2023-01-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-12-31 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'In Progress');
INSERT INTO Projects (projectId, projectName, startDate, endDate, deadlineTimestamp, projectStatus)
VALUES (2, 'New Website Launch', TO_DATE('2023-03-01', 'YYYY-MM-DD'), TO_DATE('2023-09-30', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-09-30 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');
INSERT INTO Projects (projectId, projectName, startDate, deadlineTimestamp, projectStatus)
VALUES (3, 'Mobile App Development', TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-05-31 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pending');
INSERT INTO Projects (projectId, projectName, startDate, endDate, deadlineTimestamp, projectStatus)
VALUES (4, 'Data Warehouse Migration', TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2023-05-30', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-05-30 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');

-- Populate ProjectAssignments
INSERT INTO ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (1, 101, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Lead DBA');
INSERT INTO ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (1, 102, TO_DATE('2023-01-20', 'YYYY-MM-DD'), 'Senior Developer');
INSERT INTO ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (2, 105, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Marketing Lead');
INSERT INTO ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (3, 102, TO_DATE('2023-06-05', 'YYYY-MM-DD'), 'Lead Developer');
INSERT INTO ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (3, 106, TO_DATE('2023-06-10', 'YYYY-MM-DD'), 'Junior Developer');

-- Populate ProductCatalogA
INSERT INTO ProductCatalogA (productId, productName, category, listPrice) VALUES ('ORA101', 'Oracle Database 21c', 'Software', 5000);
INSERT INTO ProductCatalogA (productId, productName, category, listPrice) VALUES ('ORA102', 'Oracle WebLogic Server', 'Software', 3000);
INSERT INTO ProductCatalogA (productId, productName, category, listPrice) VALUES ('SRV201', 'Dell PowerEdge R750', 'Hardware', 7500);
INSERT INTO ProductCatalogA (productId, productName, category, listPrice) VALUES ('BK001', 'Oracle SQL Performance Tuning', 'Book', 70);

-- Populate ProductCatalogB
INSERT INTO ProductCatalogB (productId, productName, category, listPrice) VALUES ('ORA101', 'Oracle Database 21c', 'Software', 4950); -- Different Price
INSERT INTO ProductCatalogB (productId, productName, category, listPrice) VALUES ('SRV201', 'Dell PowerEdge R750', 'Hardware', 7500);
INSERT INTO ProductCatalogB (productId, productName, category, listPrice) VALUES ('PGSQL10', 'PostgreSQL Advanced Server', 'Software', 2500);
INSERT INTO ProductCatalogB (productId, productName, category, listPrice) VALUES ('BK002', 'PostgreSQL Administration Guide', 'Book', 60);

-- Populate EmployeeUpdatesForMerge
INSERT INTO EmployeeUpdatesForMerge (employeeId, newJobTitle, newSalary, newDepartmentId) VALUES (102, 'Senior Software Engineer', 85000, 10); -- Existing employee, update
INSERT INTO EmployeeUpdatesForMerge (employeeId, newJobTitle, newSalary, newDepartmentId) VALUES (106, 'Software Engineer', 72000, 10); -- Existing employee, update salary
INSERT INTO EmployeeUpdatesForMerge (employeeId, newJobTitle, newSalary, newDepartmentId) VALUES (108, 'Data Analyst', 60000, 10); -- New employee, insert
COMMIT;
</code></pre>

---
### Exercise Block 1: Date Functions *(Oracle Specifics & Practice)*

<div class="exercise-category-box">
<h4>(i) Meanings, Values, Relations, and Advantages</h4>
<div class="problem-description">
<h5>Exercise 1.1.1: Oracle Current Date/Time Functions and Conversions</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. Display the current system date and time using <code>SYSDATE</code>.</li>
    <li>b. Display the current session date using <code>CURRENT_DATE</code>. (PostgreSQL equivalent: <code>CURRENT_DATE</code>)</li>
    <li>c. Display the current system timestamp with time zone using <code>SYSTIMESTAMP</code>. (PostgreSQL equivalent: <code>NOW()</code> or <code>CURRENT_TIMESTAMP</code> (with time zone))</li>
    <li>d. Display the current session timestamp using <code>CURRENT_TIMESTAMP</code>. (Oracle's <code>CURRENT_TIMESTAMP</code> returns TIMESTAMP WITH TIME ZONE based on session settings).</li>
    <li>e. Alice Smith (employeeId 101) was hired on '2020-01-15'. Convert this string to an Oracle DATE type and display it. Explain the importance of <code>TO_DATE</code> and format models in Oracle compared to PostgreSQL's potentially more lenient string-to-date casting.</li>
    <li>f. Display Alice Smith's hire date in the format 'Day, DDth Month YYYY, HH24:MI:SS'. Explain how <code>TO_CHAR</code> with date format models works in Oracle.</li>
</ul>
</div>
<div class="problem-description">
<h5>Exercise 1.1.2: Oracle Date Arithmetic and Interval Functions</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. Calculate the date 6 months after Alice Smith's (employeeId 101) hire date using <code>ADD_MONTHS</code>.</li>
    <li>b. Calculate the number of months between Bob Johnson's (employeeId 102) hire date and Alice Smith's hire date using <code>MONTHS_BETWEEN</code>.</li>
    <li>c. Find the last day of the month for Alice Smith's hire date using <code>LAST_DAY</code>.</li>
    <li>d. Find the date of the next Friday after Alice Smith's hire date using <code>NEXT_DAY</code>.</li>
    <li>e. Show Alice Smith's hire date truncated to the beginning of the year and rounded to the nearest year. (Illustrates <code>TRUNC(date,'YYYY')</code> and <code>ROUND(date,'YYYY')</code>).</li>
    <li>f. Add 10 days to Alice Smith's hire date using simple date arithmetic. (Known from PG, syntax: <code>date + number</code>).</li>
    <li>g. Subtract Alice Smith's hire date from Bob Johnson's hire date to find the difference in days. (Known from PG, syntax: <code>date - date</code>).</li>
    <li>h. The 'Omega System Upgrade' project (projectId 1) has a <code>deadlineTimestamp</code>. Add an interval of '3 days and 5 hours and 30 minutes' to this deadline using an Oracle <code>INTERVAL DAY TO SECOND</code> type. Contrast Oracle's <code>INTERVAL</code> syntax with PostgreSQL's.</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(ii) Disadvantages and Pitfalls</h4>
<div class="problem-description">
<h5>Exercise 1.2.1: Date Function Pitfalls</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. A developer tries to find all employees hired in '2020' using <code>TO_CHAR(hireDate, 'YYYY') = '2020'</code>. Explain why this is inefficient for indexed <code>hireDate</code> columns and suggest a better Oracle-idiomatic way.</li>
    <li>b. A junior DBA attempts to set the <code>endDate</code> of project 'Mobile App Development' (projectId 3) to be exactly one year from its <code>startDate</code> using <code>startDate + 365</code>. What is a potential issue with this approach, especially concerning leap years? How would <code>ADD_MONTHS</code> be better?</li>
    <li>c. What is a potential issue if <code>NEXT_DAY(some_date, 'MONDAY')</code> is used in an application deployed across regions with different <code>NLS_DATE_LANGUAGE</code> settings? How can this be made more robust?</li>
    <li>d. Oracle's <code>DATE</code> type stores both date and time. A query <code>WHERE hireDate = TO_DATE('2020-01-15', 'YYYY-MM-DD')</code> is used to find employees hired on January 15, 2020. Why might this query miss employees hired on that day? What is a correct way to find all employees hired on a specific day, regardless of time?</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(iii) Contrasting with Inefficient Common Solutions</h4>
<div class="problem-description">
<h5>Exercise 1.3.1: Date Range Queries - Inefficient vs. Efficient</h5>
<p><strong>Problem:</strong></p>
<p>A developer needs to find all projects that had a <code>startDate</code> within the calendar year 2023.</p>
<ul>
    <li><strong>Inefficient Approach:</strong> They write a query using <code>EXTRACT(YEAR FROM startDate) = 2023</code> or <code>TO_CHAR(startDate, 'YYYY') = '2023'</code>.</li>
    <li>Show this inefficient approach.</li>
    <li>Explain why it's inefficient in Oracle, especially if <code>startDate</code> is indexed.</li>
    <li>Provide the efficient, Oracle-idiomatic solution using date range comparisons that can leverage indexes.</li>
</ul>
</div>
</div>

---
### Exercise Block 2: String Functions *(Practice in Oracle)*

<div class="exercise-category-box">
<h4>(i) Meanings, Values, Relations, and Advantages</h4>
<div class="problem-description">
<h5>Exercise 2.1.1: Basic Oracle String Manipulation</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. Concatenate the <code>firstName</code>, a space, and the <code>lastName</code> of employee Bob Johnson (employeeId 102) using the <code>||</code> operator. Also show it using nested <code>CONCAT</code> functions. Explain why <code>||</code> is generally preferred in Oracle.</li>
    <li>b. For employee Alice Smith (employeeId 101), extract the username part (before '@') from her email address. Use <code>SUBSTR</code> and <code>INSTR</code>.</li>
    <li>c. Find the length of Frank Miller's (employeeId 106) <code>jobTitle</code> <em>after</em> removing leading/trailing spaces. Use <code>LENGTH</code> and <code>TRIM</code>.</li>
    <li>d. Display the <code>projectName</code> for projectId 1 ('Omega System Upgrade') with 'System' replaced by 'Platform'. Use <code>REPLACE</code>.</li>
    <li>e. (Oracle Specific Nuance for INSTR) Find the starting position of the second occurrence of 'e' (case-insensitive) in the <code>firstName</code> 'Eve' (employeeId 105). Use <code>INSTR</code> with its occurrence parameter. How might you achieve case-insensitivity directly in <code>INSTR</code> or by combining functions?</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(ii) Disadvantages and Pitfalls</h4>
<div class="problem-description">
<h5>Exercise 2.2.1: String Function Pitfalls in Oracle</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. A developer attempts <code>SELECT CONCAT(firstName, ' ', lastName, ' (', jobTitle, ')') FROM Employees;</code>. What error occurs and why? How should it be written?</li>
    <li>b. A query <code>WHERE jobTitle = 'Developer'</code> is intended to find all types of developers (e.g., 'Senior Developer', 'Developer Lead'). Why will this fail? What Oracle functions/operators should be used for substring or pattern matching?</li>
    <li>c. Oracle treats empty strings (<code>''</code>) in <code>VARCHAR2</code> columns as <code>NULL</code>. A developer writes <code>SELECT firstName || details || lastName FROM someTable</code> where <code>details</code> can sometimes be an empty string from source data that becomes <code>NULL</code>. What is the result compared to PostgreSQL where <code>''</code> is not <code>NULL</code>?</li>
    <li>d. If <code>SUBSTR(string, start_pos, length)</code> is used and <code>start_pos</code> is 0 or negative, or <code>length</code> is negative, how does Oracle's <code>SUBSTR</code> behave? Contrast with PostgreSQL's <code>SUBSTRING</code> if known behavior differs.</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(iii) Contrasting with Inefficient Common Solutions</h4>
<div class="problem-description">
<h5>Exercise 2.3.1: Complex String Parsing - Iterative SUBSTR/INSTR vs. REGEXP_SUBSTR</h5>
<p><strong>Problem:</strong></p>
<p>The <code>Projects</code> table has <code>projectName</code> 'Omega System Upgrade, Phase 2, Alpha Release'. You need to extract the third comma-separated value ('Alpha Release' after trimming).</p>
<ul>
    <li><strong>Inefficient/Complex Common Solution:</strong> A developer might use multiple nested calls to <code>INSTR</code> to find the positions of the first, second, and third commas, and then <code>SUBSTR</code> to extract the segment, followed by <code>TRIM</code>. This can become very complex and error-prone.</li>
    <li>Show conceptually how this might look (you don't need to write the fully working deeply nested version if it's too verbose, just outline the logic).</li>
    <li>Explain its disadvantages (readability, maintainability, error-proneness).</li>
    <li>Present the efficient and often clearer Oracle-idiomatic solution using <code>REGEXP_SUBSTR</code>.</li>
</ul>
</div>
</div>

---
### Exercise Block 3: Set Operators *(Practice in Oracle)*

<div class="exercise-category-box">
<h4>(i) Meanings, Values, Relations, and Advantages</h4>
<div class="problem-description">
<h5>Exercise 3.1.1: Oracle Set Operators - MINUS, INTERSECT, UNION</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. List all <code>productId</code> and <code>productName</code> from <code>ProductCatalogA</code> that are *not* present with the exact same <code>productId</code> and <code>productName</code> in <code>ProductCatalogB</code>. Use the Oracle-specific <code>MINUS</code> operator. Explain its relation to PostgreSQL's <code>EXCEPT</code>.</li>
    <li>b. List all <code>productId</code> and <code>productName</code> that are common to *both* <code>ProductCatalogA</code> and <code>ProductCatalogB</code> (i.e., <code>productId</code> and <code>productName</code> are identical in both). Use <code>INTERSECT</code>.</li>
    <li>c. List all unique <code>productId</code> and <code>productName</code> combinations present in *either* <code>ProductCatalogA</code> *or* <code>ProductCatalogB</code> (or both). Use <code>UNION</code>.</li>
    <li>d. What are the requirements for the <code>SELECT</code> lists regarding number of columns and data types when using these set operators in Oracle?</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(ii) Disadvantages and Pitfalls</h4>
<div class="problem-description">
<h5>Exercise 3.2.1: Set Operator Pitfalls in Oracle</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. A developer wants to combine all rows from <code>ProductCatalogA</code> and <code>ProductCatalogB</code>, including duplicates if a product appears in both with identical details. They use <code>UNION</code>. What is the pitfall? What should they use?</li>
    <li>b. If <code>MINUS</code> or <code>INTERSECT</code> is used on queries selecting CLOB columns, what happens? What is the general limitation for LOB types with set operators?</li>
    <li>c. Consider <code>(SELECT departmentId FROM Employees WHERE departmentId = 10) MINUS (SELECT departmentId FROM Employees WHERE departmentId = 20);</code>. What is the result and why? What if it was <code>(SELECT departmentId FROM Employees WHERE departmentId = 10) MINUS (SELECT departmentId FROM Employees WHERE departmentId = 10);</code>?</li>
    <li>d. The order of operations for multiple set operators (e.g., <code>Q1 UNION Q2 MINUS Q3</code>) can be ambiguous without parentheses. How does Oracle evaluate them by default? Why is using parentheses good practice?</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(iii) Contrasting with Inefficient Common Solutions</h4>
<div class="problem-description">
<h5>Exercise 3.3.1: Finding Disjoint Sets - MINUS vs. Multiple NOT IN/NOT EXISTS</h5>
<p><strong>Problem:</strong></p>
<p>You need to identify all <code>departmentId</code>s that have employees listed in the <code>Employees</code> table but are *not* present in a predefined list of 'approved' department IDs (e.g., 20, 40).</p>
<ul>
    <li><strong>Less Efficient/More Complex Common Solution:</strong> A developer might use <code>SELECT DISTINCT departmentId FROM Employees WHERE departmentId NOT IN (20, 40)</code>. While this works for simple lists, consider if the "approved list" came from another table and had many values, or involved multiple columns for exclusion. The use of <code>NOT IN</code> can also have pitfalls with <code>NULL</code> values in the subquery/list.</li>
    <li>Explain potential issues with <code>NOT IN</code> especially if the subquery for <code>NOT IN</code> could return <code>NULL</code>.</li>
    <li>Show how <code>MINUS</code> offers a clear and robust alternative, especially if the "approved list" is also derived from a query.</li>
</ul>
</div>
</div>

---
### Exercise Block 4: Data Manipulation Language (DML) & Transaction Control *(Practice in Oracle)*

<div class="exercise-category-box">
<h4>(i) Meanings, Values, Relations, and Advantages</h4>
<div class="problem-description">
<h5>Exercise 4.1.1: Oracle DML and Transaction Control Basics</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. <strong>INSERT:</strong> Add a new department 'Operations' (departmentId 60) located in 'Chicago' to the <code>Departments</code> table.</li>
    <li>b. <strong>SAVEPOINT:</strong> Create a savepoint named <code>pre_salary_update</code>.</li>
    <li>c. <strong>UPDATE:</strong> Increase the salary of all employees in the 'Technology' department (departmentId 10) by 5%. Use the <code>ROUND</code> function to ensure the new salary has two decimal places.</li>
    <li>d. <strong>DELETE:</strong> Remove any assignments from <code>ProjectAssignments</code> for employee Frank Miller (employeeId 106). Then, delete Frank Miller from the <code>Employees</code> table.</li>
    <li>e. <strong>ROLLBACK TO SAVEPOINT:</strong> It was decided not to delete Frank Miller yet. Rollback the changes to <code>pre_salary_update</code>. Verify Frank Miller and his assignments are back, but the salary updates for Tech employees persist. *(Adjust savepoint placement if necessary for intended demonstration)*</li>
    <li>f. <strong>COMMIT:</strong> Make the salary updates permanent.</li>
    <li>g. <strong>MERGE (Oracle Specific Advantage):</strong> Use the <code>EmployeeUpdatesForMerge</code> table (populated earlier) to update existing employees or insert new ones into the <code>Employees</code> table.
        <ul>
            <li>If an <code>employeeId</code> from <code>EmployeeUpdatesForMerge</code> exists in <code>Employees</code>, update their <code>jobTitle</code>, <code>salary</code>, and <code>departmentId</code>.</li>
            <li>If an <code>employeeId</code> does not exist, insert a new employee record: <code>firstName</code>='NewEmp', <code>lastName</code>='ViaMerge', <code>email</code> as <code>employeeId || '@merge.com'</code>, and other details from <code>EmployeeUpdatesForMerge</code>, <code>hireDate</code> as <code>SYSDATE</code>.</li>
        </ul>
        Explain the advantage of <code>MERGE</code> over separate <code>UPDATE</code> and <code>INSERT</code> statements (atomicity, performance, readability). Contrast with PostgreSQL's <code>INSERT ... ON CONFLICT</code>.</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(ii) Disadvantages and Pitfalls</h4>
<div class="problem-description">
<h5>Exercise 4.2.1: DML and Transaction Pitfalls</h5>
<p><strong>Problem:</strong></p>
<ul>
    <li>a. A developer issues <code>UPDATE Employees SET commissionPct = 0.05 WHERE departmentId = 30;</code> but forgets to <code>COMMIT</code>. They then run a report query in the *same session* that relies on <code>commissionPct</code>. What value will the report see? What if another session runs the report? What happens if the first session closes without <code>COMMIT</code>?</li>
    <li>b. An intern accidentally runs <code>DELETE FROM Projects;</code> (without a <code>WHERE</code> clause). What is the immediate action they should take if this was unintended and no <code>COMMIT</code> has been issued?</li>
    <li>c. A <code>MERGE</code> statement's <code>ON</code> clause is <code>ON (target.departmentId = source.departmentId)</code>. If <code>departmentId</code> is not unique in the <code>source</code> table for a given <code>departmentId</code> in the <code>target</code>, what error might occur and why?</li>
    <li>d. A transaction starts, a savepoint <code>S1</code> is created, some DML (DML1) occurs, another savepoint <code>S2</code> is created, more DML (DML2) occurs. If <code>ROLLBACK TO S1</code> is issued, what is the state of DML1 and DML2? What happens to savepoint <code>S2</code>?</li>
</ul>
</div>
</div>

<div class="exercise-category-box">
<h4>(iii) Contrasting with Inefficient Common Solutions</h4>
<div class="problem-description">
<h5>Exercise 4.3.1: Conditional Insert/Update - MERGE vs. Separate UPDATE then INSERT (with NOT EXISTS)</h5>
<p><strong>Problem:</strong></p>
<p>You need to synchronize data from <code>EmployeeUpdatesForMerge</code> into <code>Employees</code>. If an employee exists (matched by <code>employeeId</code>), update their <code>jobTitle</code> and <code>salary</code>. If not, insert them.</p>
<ul>
    <li><strong>Less Efficient/More Complex Common Solution:</strong> A developer might write two separate SQL statements:
        <ol>
            <li>An <code>UPDATE</code> statement for existing employees (perhaps using <code>EXISTS</code> or an updatable join).</li>
            <li>An <code>INSERT ... SELECT</code> statement for new employees, using <code>NOT EXISTS</code> or a <code>LEFT JOIN ... WHERE IS NULL</code> to identify those not already present.</li>
        </ol>
    </li>
    <li>Show this two-statement SQL approach.</li>
    <li>Explain its disadvantages (multiple table scans, potential for race conditions if not perfectly isolated, more complex logic).</li>
    <li>Present the efficient, Oracle-idiomatic solution using <code>MERGE</code>.</li>
</ul>
</div>
</div>

---
### Hardcore Combined Problem

<div class="exercise-category-box" style="border-color: #FF9900;"> <!-- Orange border for emphasis -->
<h3 style="color: #FF9900;">Challenge: The Performance Recognition Initiative</h3>
<div class="problem-description">
<p><strong>Scenario:</strong></p>
<p>The company is launching a "Performance Recognition Initiative" for Q1 2024. This initiative requires identifying top-performing non-managerial employees in specific departments based on their hire date and current salary, calculating a recognition payment, updating their records, and logging these changes. All DML operations must be part of a single, controlled transaction.</p>

<p><strong>Eligibility Criteria for Recognition Payment:</strong></p>
<ol>
    <li>Employee must have been hired on or before '2022-06-30'.</li>
    <li>Employee must be in the 'Technology' (departmentId 10) or 'Sales' (departmentId 30) department.</li>
    <li>Employee must <strong>not</strong> be a manager (i.e., their <code>employeeId</code> does not appear in the <code>managerId</code> column of any other employee).</li>
    <li>Their current <code>salary</code> must be less than $90,000.</li>
    <li>Their <code>email</code> must end with '@example.com'.</li>
</ol>

<p><strong>Recognition Payment Calculation:</strong></p>
<ul>
    <li>Base Payment:
        <ul>
            <li>If <code>jobTitle</code> contains 'Developer' (case-insensitive): $2000.</li>
            <li>If <code>jobTitle</code> contains 'Sales': $1500.</li>
            <li>Otherwise: $1000.</li>
        </ul>
    </li>
    <li>Service Kicker (added to Base Payment):
        <ul>
            <li><code>MONTHS_BETWEEN(SYSDATE, hireDate)</code> / 12 (number of full years of service) * $100.</li>
        </ul>
    </li>
    <li>The total calculated payment should be <code>ROUND</code>ed to the nearest dollar. This payment is a one-time bonus and does <strong>not</strong> change their <code>salary</code>. Instead, it should be recorded.</li>
</ul>

<p><strong>Tasks:</strong></p>
<ol>
    <li><strong>Pre-analysis (Set Operators & ROWNUM):</strong>
        <ul>
            <li>a. Using <code>MINUS</code>, identify <code>employeeId</code>s of all current non-managers.</li>
            <li>b. Display the <code>firstName</code>, <code>lastName</code>, <code>hireDate</code>, and <code>salary</code> of the top 3 *longest-serving* (earliest <code>hireDate</code>) employees who meet all eligibility criteria (1, 2, 3, 4, 5). Use <code>ROWNUM</code> correctly.</li>
        </ul>
    </li>
    <li><strong>Transactional Processing (DML & Transaction Control):</strong>
        <p><em>(For this part, you will likely need a PL/SQL block to manage the cursor, calculations, conditional DML, and overall transaction logic.)</em></p>
        <ul>
            <li>Start a transaction. Create a savepoint named <code>recognition_initiative_start</code>.</li>
            <li>For each employee meeting <strong>all</strong> eligibility criteria:
                <ul>
                    <li>a. Calculate their total recognition payment using Oracle date functions (<code>MONTHS_BETWEEN</code>, <code>SYSDATE</code>), string functions (<code>INSTR</code>, <code>LOWER</code> for case-insensitive <code>jobTitle</code> check), <code>NVL</code> (if needed), and <code>CASE</code> expressions or PL/SQL <code>IF</code> statements. Remember to <code>ROUND</code> the final payment.</li>
                    <li>b. Update the employee's <code>commissionPct</code>. If their calculated recognition payment is greater than $1200, add 0.01 to their <code>commissionPct</code>. <code>NVL</code> should be used to treat an initial <code>NULL</code> <code>commissionPct</code> as 0. The <code>commissionPct</code> should not exceed 0.25.</li>
                    <li>c. Insert a record into the <code>AuditLog</code> table.
                        <ul>
                            <li><code>tableName</code>: 'Employees'</li>
                            <li><code>operationType</code>: 'RECOGNIZE'</li>
                            <li><code>details</code> (CLOB): A string like: 'Recognition: EmpID=XXX (Name: FirstName LastName), Payment=$PPP, NewCommPct=CCC, YearsSvc=YY.YY'. Use <code>TO_CHAR</code> for formatting numbers (payment to 2 decimal places, years of service to 2 decimal places). Concatenate <code>firstName</code> and <code>lastName</code>.</li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li>After processing all eligible employees, if the total number of employees recognized is less than 1, <code>ROLLBACK</code> the transaction to <code>recognition_initiative_start</code>. Otherwise, <code>COMMIT</code> the transaction.</li>
        </ul>
    </li>
</ol>
<p><strong>Constraint Reminder:</strong> Focus on using concepts covered up to this point in the Oracle transitional course.</p>
</div>
</div>

## Conclusion & Next Steps

Well done on working through (or preparing to work through) these exercises! Practice is paramount in mastering SQL, and these Oracle-focused tasks are designed to sharpen your skills significantly, especially for those transitioning from PostgreSQL. *With functions mastered, and DML embraced, your Oracle journey is well-paced!*

Having solidified your understanding of Oracle's date and string manipulation, set operations, and DML/TCL, you are now well-prepared to tackle more advanced and powerful Oracle SQL features.

**Your next learning adventures in "The Sequential and Complete Transitional Course from PostgreSQL to ORACLE SQL with ORACLE DB 21ai" include:**

*   **Hierarchical Queries (`CONNECT BY`, `LEVEL`, `PRIOR`)**
*   **Analytic (Window) Functions (Practicing Oracle Syntax for `RANK`, `LAG`, `SUM() OVER()`, etc.)**

Keep up the excellent work, and continue exploring the vast capabilities of Oracle SQL!

</div>