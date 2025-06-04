<head>
    <link rel="stylesheet" href="../styles/exercises.css">
</head>

<body>
<div class="container">

# PL/SQL Resilience: Packages, Errors, and Automation - Exercises

## Introduction / Learning Objectives
Welcome to the practical exercises for "PL/SQL Resilience." This section is designed to fortify your understanding of Oracle's powerful features for building robust and maintainable server-side code. By tackling these challenges, you'll gain hands-on experience with Packages, Exception Handling, and Triggers.

After completing these exercises, you will be able to:

*   Design, implement, and utilize PL/SQL packages for modularity, encapsulation, and state management.
*   Effectively handle runtime errors using Oracle's exception handling mechanisms, including predefined and user-defined exceptions.
*   Implement DML triggers to automate actions based on data modifications, utilizing `:NEW` and `:OLD` qualifiers and conditional predicates.
*   Understand and apply Oracle-specific syntax and nuances for these concepts, bridging your existing PostgreSQL knowledge.

<div class="rhyme">
From Postgres's shore to Oracle's embrace,<br>
Resilience in code, we'll set the right pace.
</div>

## Prerequisites & Setup

Before diving into these exercises, ensure you are comfortable with the following concepts from previous chunks of this "Server Programming with Oracle (DB 23 ai) PL/SQL: A Transition Guide for PostgreSQL Users" course:

*   **Chunk 5: PL/SQL Awakening:** PL/SQL Block Structure, Variables & Constants, Conditional & Iterative Control, SQL within PL/SQL.
*   **Chunk 6: PL/SQL Precision:** Cursors, Stored Procedures & Functions.
*   Fundamental Oracle SQL DML and Data Types (covered in Chunks 1-3).

And from your "Original PostgreSQL Course Sequence":
*   Basic SQL (Conditionals, Aggregators, Joins).
*   Intermediate SQL (Date Functions, Casters, Null Space, Cases).

### Dataset Guidance

The exercises in this section will use a predefined dataset. The complete Oracle SQL script for creating the necessary tables and populating them with initial data is provided below.

**To set up the dataset:**
1.  Copy the entire SQL script block provided in the "Exercises" section (it will be marked clearly).
2.  Execute this script in your Oracle DB 23ai environment. You can use tools like:
    *   **SQL Developer:** Open a SQL Worksheet, paste the script, and run it (usually by pressing F5 or the "Run Script" button).
    *   **SQL\*Plus:** Save the script to a `.sql` file (e.g., `dataset.sql`) and run it from the SQL\*Plus command line using `@path/to/your/dataset.sql`.
    *   **Oracle Live SQL:** Paste the script into the SQL Worksheet and click "Run".

**Dataset Schema Overview:**
The dataset includes tables such as `Departments`, `Employees`, `Products`, `Orders`, `OrderItems`, and `AuditLog`. These tables are interrelated to simulate a basic business environment, allowing you to practice creating packages for business logic, triggers for auditing, and exception handling for data validation and operational errors.

<div class="caution">
<strong>Important:</strong> Ensure the dataset is correctly set up before attempting the exercises. Many exercises depend on these specific tables and their initial data.
</div>


## Exercise Structure Overview

The exercises are structured to progressively build your skills:
*   **Meanings, Values, Relations, and Advantages:** Focus on the core utility and benefits of each concept.
*   **Disadvantages and Pitfalls:** Explore limitations and common mistakes to avoid.
*   **Contrasting with Inefficient Common Solutions:** Compare Oracle-idiomatic approaches with less optimal alternatives.
*   **Hardcore Combined Problem:** A comprehensive challenge integrating multiple concepts.

It is highly recommended to attempt each exercise on your own before reviewing the provided solutions. This active engagement is key to effective learning.


<!-- === INSERT PRE-GENERATED EXERCISES HERE === -->
<div class="exercise-set">

<h2>Dataset for Exercises</h2>

<p>The following dataset will be used for the exercises. Ensure it is created in your Oracle DB 23ai environment.</p>

<pre><code class="language-sql">
-- Drop tables if they exist to ensure a clean slate
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE OrderItems';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Orders';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Products';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE AuditLog';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Employees';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Departments';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Drop sequences if they exist
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE departmentSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE employeeSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE productSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE orderSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE orderItemSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Create Tables
CREATE TABLE Departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    locationCity VARCHAR2(100) -- Changed from 'location' to avoid reserved word issues in some tools
);

CREATE TABLE Employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    salary NUMBER(10, 2),
    departmentId NUMBER,
    hireDate DATE DEFAULT SYSDATE,
    CONSTRAINT fkEmployeeDepartment FOREIGN KEY (departmentId) REFERENCES Departments(departmentId)
);

CREATE TABLE Products (
    productId NUMBER PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    unitPrice NUMBER(10, 2) CHECK (unitPrice > 0),
    stockQuantity NUMBER DEFAULT 0 CHECK (stockQuantity >= 0)
);

CREATE TABLE Orders (
    orderId NUMBER PRIMARY KEY,
    customerId NUMBER,
    orderDate DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE OrderItems (
    orderItemId NUMBER PRIMARY KEY,
    orderId NUMBER NOT NULL,
    productId NUMBER NOT NULL,
    quantity NUMBER CHECK (quantity > 0),
    itemPrice NUMBER(10, 2),
    CONSTRAINT fkOrderItemOrder FOREIGN KEY (orderId) REFERENCES Orders(orderId),
    CONSTRAINT fkOrderItemProduct FOREIGN KEY (productId) REFERENCES Products(productId)
);

CREATE TABLE AuditLog (
    logId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tableName VARCHAR2(50),
    operationType VARCHAR2(10),
    changedBy VARCHAR2(100) DEFAULT USER,
    changeTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    oldValue CLOB, -- Changed to CLOB for potentially larger values
    newValue CLOB, -- Changed to CLOB
    recordId VARCHAR2(100)
);

-- Create Sequences
CREATE SEQUENCE departmentSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE employeeSeq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE productSeq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE orderSeq START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE orderItemSeq START WITH 10000 INCREMENT BY 1;

-- Populate Departments
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (departmentSeq.NEXTVAL, 'Sales', 'New York');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (departmentSeq.NEXTVAL, 'HR', 'London');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (departmentSeq.NEXTVAL, 'IT', 'Bangalore');

-- Populate Employees
INSERT INTO Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (employeeSeq.NEXTVAL, 'John', 'Doe', 'john.doe@example.com', 60000, 1, TO_DATE('2022-01-15', 'YYYY-MM-DD'));
INSERT INTO Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (employeeSeq.NEXTVAL, 'Jane', 'Smith', 'jane.smith@example.com', 75000, 1, TO_DATE('2021-03-22', 'YYYY-MM-DD'));
INSERT INTO Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (employeeSeq.NEXTVAL, 'Alice', 'Wonder', 'alice.wonder@example.com', 50000, 2, TO_DATE('2022-07-10', 'YYYY-MM-DD'));
INSERT INTO Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (employeeSeq.NEXTVAL, 'Bob', 'Builder', 'bob.builder@example.com', 90000, 3, TO_DATE('2020-11-01', 'YYYY-MM-DD'));

-- Populate Products
INSERT INTO Products (productId, productName, unitPrice, stockQuantity) VALUES (productSeq.NEXTVAL, 'Laptop Pro', 1200, 50);
INSERT INTO Products (productId, productName, unitPrice, stockQuantity) VALUES (productSeq.NEXTVAL, 'Wireless Mouse', 25, 200);
INSERT INTO Products (productId, productName, unitPrice, stockQuantity) VALUES (productSeq.NEXTVAL, 'Keyboard Ultra', 75, 10);
INSERT INTO Products (productId, productName, unitPrice, stockQuantity) VALUES (productSeq.NEXTVAL, 'Monitor HD', 300, 0); -- Out of stock for exception handling

COMMIT;
</code></pre>

<hr>

<h2>Category: Packages: Specification, body, benefits, overloading</h2>

<h3>(i) Meanings, Values, Relations, and Advantages</h3>

<h4>Exercise 1.1: Basic Package Creation and Usage</h4>
<p><span class="problem-label">Problem:</span> Create a package named <code>EmployeeUtils</code> that has:</p>
<ol>
    <li>A public function <code>GetEmployeeFullName</code> which takes an <code>employeeId</code> (NUMBER) and returns the employee's full name (firstName || ' ' || lastName).</li>
    <li>A public procedure <code>UpdateEmployeeSalary</code> which takes an <code>employeeId</code> (NUMBER) and a <code>newSalary</code> (NUMBER) and updates the employee's salary.</li>
</ol>
<p>Write a PL/SQL anonymous block to call both the function and the procedure for an existing employee.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understand the basic structure of a package specification and body, and how to call public subprograms.</p>
</div>
<div class="postgresql-bridge">
<p><strong>Relations (PostgreSQL Bridge):</strong> In PostgreSQL, you might group related functions within a schema. Oracle packages provide stronger encapsulation (private vs. public elements) and can also hold types, variables, and cursors. The <code>CREATE PACKAGE</code> and <code>CREATE PACKAGE BODY</code> syntax is Oracle-specific.</p>
</div>

<h4>Exercise 1.2: Package Variables and State</h4>
<p><span class="problem-label">Problem:</span> Modify the <code>EmployeeUtils</code> package:</p>
<ol>
    <li>Add a public variable <code>defaultRaisePercentage</code> of type NUMBER initialized to 5 in the package specification.</li>
    <li>Add a private variable <code>totalRaisesProcessed</code> of type NUMBER in the package body, initialized to 0.</li>
    <li>Modify <code>UpdateEmployeeSalary</code> to also accept an optional <code>raisePercentage</code> (NUMBER). If <code>raisePercentage</code> is NULL, use <code>defaultRaisePercentage</code>.</li>
    <li>Inside <code>UpdateEmployeeSalary</code>, increment <code>totalRaisesProcessed</code> each time a salary is successfully updated.</li>
    <li>Add a public function <code>GetTotalRaisesProcessed</code> to the package that returns the value of <code>totalRaisesProcessed</code>.</li>
</ol>
<p>Write an anonymous block to call <code>UpdateEmployeeSalary</code> twice (once with and once without the optional percentage) and then display the total raises processed.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understand package variables (public and private), initialization, and package state persistence within a session. Refer to <code>PL/SQL Language Reference</code>, Chapter 11: "Package Instantiation and Initialization" and "Package State".</p>
</div>

<h4>Exercise 1.3: Package Subprogram Overloading</h4>
<p><span class="problem-label">Problem:</span> In the <code>EmployeeUtils</code> package:</p>
<ol>
    <li>Overload the <code>GetEmployeeFullName</code> function. Create a new version that takes <code>firstName</code> (VARCHAR2) and <code>lastName</code> (VARCHAR2) as input and returns the concatenated full name.</li>
</ol>
<p>Write an anonymous block that calls both versions of <code>GetEmployeeFullName</code>.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understand how to overload subprograms within a package. Refer to <code>PL/SQL Language Reference</code>, Chapter 9: "Overloaded Subprograms".</p>
</div>

<h3>(ii) Disadvantages and Pitfalls</h3>

<h4>Exercise 2.1: Package State Invalidation</h4>
<p><span class="problem-label">Problem:</span></p>
<ol>
    <li>Create a simple package <code>StatefulPkg</code> with a specification that declares a public variable <code>counter</code> (NUMBER := 0) and a procedure <code>IncrementCounter</code>.</li>
    <li>Create the package body for <code>StatefulPkg</code> where <code>IncrementCounter</code> increments the <code>counter</code> variable and uses <code>DBMS_OUTPUT.PUT_LINE</code> to display its new value and an initialization block that outputs "StatefulPkg initialized".</li>
    <li>In one SQL*Plus session (Session 1), execute an anonymous block that calls <code>StatefulPkg.IncrementCounter</code> twice. Note the output.</li>
    <li>In a separate SQL*Plus session (Session 2), recompile the <em>body</em> of <code>StatefulPkg</code> (e.g., <code>ALTER PACKAGE StatefulPkg COMPILE BODY;</code>).</li>
    <li>Go back to Session 1 and execute <code>StatefulPkg.IncrementCounter</code> again. Observe the output and any errors. Explain what happened.</li>
</ol>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understand that recompiling a package body can invalidate the package state for existing sessions, leading to ORA-04068. Refer to <code>PL/SQL Language Reference</code>, Chapter 11, "Package State".</p>
</div>

<h4>Exercise 2.2: Overloading Pitfall - Ambiguity with Implicit Conversions</h4>
<p><span class="problem-label">Problem:</span> Create a package <code>OverloadDemo</code> with two overloaded procedures:</p>
<ol>
    <li><code>ProcessValue(pValue IN NUMBER)</code></li>
    <li><code>ProcessValue(pValue IN VARCHAR2)</code></li>
</ol>
<p>Both procedures should simply use <code>DBMS_OUTPUT.PUT_LINE</code> to indicate which version was called. Now, in an anonymous block, call <code>ProcessValue</code> with a <code>DATE</code> type variable (e.g., <code>SYSDATE</code>). Analyze what happens and why. Propose a resolution to explicitly call the desired version.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Illustrate how implicit data type conversions can lead to ambiguity with overloaded subprograms. Refer to <code>PL/SQL Language Reference</code>, Chapter 9, "Formal Parameters that Differ Only in Numeric Data Type" and "Subprogram Overload Errors".</p>
</div>

<h3>(iii) Contrasting with Inefficient Common Solutions</h3>

<h4>Exercise 3.1: Package vs. Standalone Utilities for String Operations</h4>
<p><strong>Scenario:</strong> A development team frequently needs to perform several common string operations: reversing a string, counting vowels in a string, and checking if a string is a palindrome.</p>
<p><strong>Inefficient Common Solution (Problem):</strong> Implement these three utilities as standalone PL/SQL functions: <code>ReverseString(pInputString IN VARCHAR2) RETURN VARCHAR2</code>, <code>CountVowels(pInputString IN VARCHAR2) RETURN NUMBER</code>, and <code>IsPalindrome(pInputString IN VARCHAR2) RETURN BOOLEAN</code>.</p>
<p><strong>Oracle-Idiomatic Solution (Solution):</strong> Design and implement a single package named <code>StringUtilities</code> that encapsulates these three functions as public subprograms. Additionally, consider if any helper logic (e.g., a private function to standardize character case for palindrome check) could be part of the package body.</p>
<p><strong>Task:</strong> Write the DDL for both the inefficient (standalone functions) and the efficient (package-based) solutions. Discuss the advantages the package solution offers in terms of organization, maintainability, deployment, and potential for shared internal logic.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Demonstrate the organizational and maintainability benefits of packages over multiple standalone subprograms for related functionalities.</p>
</div>

<hr>

<h2>Category: Exception Handling: Predefined exceptions, user-defined exceptions, SQLCODE, SQLERRM, PRAGMA EXCEPTION_INIT</h2>

<h3>(i) Meanings, Values, Relations, and Advantages</h3>

<h4>Exercise 1.4: Handling Predefined Exceptions</h4>
<p><span class="problem-label">Problem:</span> Write a PL/SQL anonymous block that attempts to:</p>
<ol>
    <li>Select an employee's salary into a variable for an `employeeId` that does not exist in the `Employees` table.</li>
    <li>Handle the `NO_DATA_FOUND` exception specifically. Inside the handler, display a user-friendly message "Employee not found."</li>
    <li>Attempt to divide a number by zero.</li>
    <li>Handle the `ZERO_DIVIDE` exception specifically. Inside the handler, display "Cannot divide by zero."</li>
</ol>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understand and use predefined exceptions. Refer to <code>PL/SQL Language Reference</code>, Chapter 12, "Predefined Exceptions" (p. 12-11) and "Overview of Exception Handling" (p. 12-5).</p>
</div>

<h4>Exercise 1.5: User-Defined Exceptions and PRAGMA EXCEPTION_INIT</h4>
<p><span class="problem-label">Problem:</span></p>
<ol>
    <li>In a PL/SQL anonymous block, declare a user-defined exception named `NegativeSalaryException`.</li>
    <li>Attempt to update an employee's salary to a negative value.</li>
    <li>If the attempted salary is negative, explicitly `RAISE` the `NegativeSalaryException`.</li>
    <li>Include an exception handler for `NegativeSalaryException` that displays a message like "Error: Salary cannot be negative."</li>
    <li>Now, modify the block: associate `NegativeSalaryException` with the Oracle error code -20002 using `PRAGMA EXCEPTION_INIT`. In a separate part of the block (or another procedure called by it), use `RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative from RAISE_APPLICATION_ERROR.')`. Ensure your exception handler for `NegativeSalaryException` still catches this.</li>
</ol>
<div class="oracle-specific">
<p><strong>Focus:</strong> Declaring, raising, and handling user-defined exceptions; using `PRAGMA EXCEPTION_INIT` and `RAISE_APPLICATION_ERROR`. Refer to <code>PL/SQL Language Reference</code>, Chapter 12, sections "User-Defined Exceptions" (p. 12-13), "EXCEPTION_INIT Pragma" (p. 14-74), and "RAISE_APPLICATION_ERROR Procedure" (p. 12-18).</p>
</div>

<h4>Exercise 1.6: Using SQLCODE and SQLERRM</h4>
<p><span class="problem-label">Problem:</span> Write a PL/SQL anonymous block that attempts an operation known to cause a less common, unnamed Oracle error (e.g., try to insert a string longer than a `VARCHAR2(10)` column allows *without* a specific named exception for it). In the `WHEN OTHERS` exception handler, display the `SQLCODE` and `SQLERRM` to identify the error.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Using `SQLCODE` and `SQLERRM` for generic error reporting. Refer to <code>PL/SQL Language Reference</code>, Chapter 12, "Retrieving Error Code and Error Message" (p. 12-27).</p>
</div>

<h3>(ii) Disadvantages and Pitfalls</h3>

<h4>Exercise 2.3: Overly Broad WHEN OTHERS Handler</h4>
<p><span class="problem-label">Problem:</span> Create a procedure `ProcessEmployeeData(pEmployeeId IN NUMBER)` that performs several DML operations:
1.  Updates the employee's salary by 10%.
2.  Inserts a record into `AuditLog` noting the salary change.
3.  Attempts to update the `Departments` table based on the employee's department (potentially causing a constraint violation if the department does not exist or if there's a typo in a column name).
Include a single `WHEN OTHERS` exception handler at the end of the procedure that simply logs "An unspecified error occurred" to `DBMS_OUTPUT.PUT_LINE` and then exits without re-raising the exception.
Discuss the disadvantages of this approach. Why is it a pitfall? What information is lost?</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Illustrate the dangers of generic `WHEN OTHERS` handlers that mask the actual error, making debugging difficult. Refer to `PL/SQL Language Reference</code>, Chapter 12, "Unhandled Exceptions" (p. 12-27) and general best practices for error handling.</p>
</div>

<h4>Exercise 2.4: Exception Propagation and Scope</h4>
<p><span class="problem-label">Problem:</span> Create a nested PL/SQL block structure:
An outer block declares an exception `OuterException`.
An inner block declares an exception `InnerException`.
The inner block raises `InnerException` and handles it.
Then, the inner block raises `OuterException`.
The outer block has a handler for `OuterException`.
What happens? Now, modify the inner block to *not* handle `InnerException`. What happens to `InnerException`? Explain the propagation rules demonstrated.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understand how exceptions propagate out of blocks if not handled locally. Refer to <code>PL/SQL Language Reference</code>, Chapter 12, "Exception Propagation" (p. 12-19).</p>
</div>

<h3>(iii) Contrasting with Inefficient Common Solutions</h3>

<h4>Exercise 3.2: Manual Error Checking vs. Exception Handling</h4>
<p><strong>Scenario:** A procedure needs to fetch an employee's salary. If the employee doesn't exist, it should return NULL. If multiple employees are found (which shouldn't happen if `employeeId` is primary key, but assume a faulty query for demonstration), it should also indicate an error.</p>
<p><strong>Inefficient Common Solution (Problem):** Implement this by:
1.  Executing a `SELECT COUNT(*)` to check if the employee exists.
2.  If count is 1, execute another `SELECT salary INTO ...`.
3.  If count is 0, set salary to NULL.
4.  If count > 1, set salary to a special error indicator (e.g., -1).</p>
<p><strong>Oracle-Idiomatic Solution (Solution):** Implement this using a single `SELECT salary INTO ...` statement within a BEGIN...EXCEPTION...END block, handling `NO_DATA_FOUND` and `TOO_MANY_ROWS` exceptions appropriately.</p>
<p><strong>Task:** Implement both versions. Discuss the verbosity, performance implications (multiple queries vs. one), and clarity of the exception-handling approach.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Showcasing the conciseness and efficiency of PL/SQL exception handling over manual, multi-step error checking.</p>
</div>

<hr>

<h2>Category: Triggers: DML triggers, :NEW and :OLD qualifiers, conditional predicates</h2>

<h3>(i) Meanings, Values, Relations, and Advantages</h3>

<h4>Exercise 1.7: Basic AFTER INSERT Trigger</h4>
<p><span class="problem-label">Problem:</span> Create an `AFTER INSERT ON Orders FOR EACH ROW` trigger named `trgLogNewOrder`. This trigger should insert a record into the `AuditLog` table with `tableName` = 'Orders', `operationType` = 'INSERT', and `recordId` = `:NEW.orderId`.</p>
<p>Test by inserting a new order into the `Orders` table.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Basic DML trigger syntax, `AFTER INSERT` timing, `FOR EACH ROW`, and usage of `:NEW` qualifier. Refer to `PL/SQL Language Reference`, Chapter 10, "DML Triggers" (p. 10-4) and "Correlation Names and Pseudorecords" (p. 10-28).</p>
</div>

<h4>Exercise 1.8: BEFORE UPDATE Trigger with :OLD and :NEW</h4>
<p><span class="problem-label">Problem:</span> Create a `BEFORE UPDATE OF salary ON Employees FOR EACH ROW` trigger named `trgPreventSalaryDecrease`. This trigger should prevent any update that attempts to decrease an employee's salary. If a decrease is attempted, it should use `RAISE_APPLICATION_ERROR` with a custom error number (-20003) and a message "Salary decrease not allowed."</p>
<p>Test by attempting to decrease an employee's salary and then by increasing it.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> `BEFORE UPDATE` timing, accessing `:OLD.salary` and `:NEW.salary`, and raising an application error to prevent DML. Refer to `Get Started with Oracle Database Development`, Chapter 6, "About OLD and NEW Pseudorecords" (p. 6-3).</p>
</div>

<h4>Exercise 1.9: Trigger with Conditional Predicates</h4>
<p><span class="problem-label">Problem:</span> Create an `AFTER UPDATE ON Products FOR EACH ROW` trigger named `trgLogSignificantPriceChange`. This trigger should log to `AuditLog` only if the `unitPrice` changes by more than 20% (either increase or decrease). The `operationType` should be 'PRICE_ADJUST'. Use the `UPDATING('unitPrice')` conditional predicate in conjunction with your percentage check in the trigger body.</p>
<p>Test with various price updates.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Using conditional predicates like `UPDATING('columnName')` combined with PL/SQL logic to control trigger firing conditions. Refer to `PL/SQL Language Reference`, Chapter 10, "Conditional Predicates for Detecting Triggering DML Statement" (p. 10-5).</p>
</div>

<h3>(ii) Disadvantages and Pitfalls</h3>

<h4>Exercise 2.5: Mutating Table Error (ORA-04091)</h4>
<p><span class="problem-label">Problem:</span> Attempt to create a trigger on the `Employees` table that, for each row being updated, queries the *same* `Employees` table to find the average salary of the employee's department and then tries to ensure the employee's new salary is not more than 1.5 times this average.
For example:
`CREATE OR REPLACE TRIGGER trgCheckMaxSalary
BEFORE UPDATE OF salary ON Employees
FOR EACH ROW
DECLARE
  vAvgDeptSalary NUMBER;
BEGIN
  SELECT AVG(salary) INTO vAvgDeptSalary FROM Employees WHERE departmentId = :NEW.departmentId;
  IF :NEW.salary > (vAvgDeptSalary * 1.5) THEN
    RAISE_APPLICATION_ERROR(-20004, 'Salary exceeds 1.5x department average.');
  END IF;
END;
/`
Execute an update statement that would fire this trigger. What error do you get and why? How can compound triggers (introduced conceptually in `PL/SQL Language Reference`, Chapter 10, "Compound DML Triggers", p.10-10) help solve this? (Detailed compound trigger implementation is beyond this chunk but understanding the problem is key).</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understanding the mutating table error (ORA-04091) which is a common pitfall when triggers query or modify the table they are defined on. Refer to `PL/SQL Language Reference`, Chapter 10, "Mutating-Table Restriction" (p. 10-42).</p>
</div>

<h4>Exercise 2.6: Trigger Firing Order and Cascading Effects</h4>
<p><span class="problem-label">Problem:</span>
1.  Create a simple `AFTER UPDATE ON Departments FOR EACH ROW` trigger (`trgDeptUpdate`) that prints "Department updated" to `DBMS_OUTPUT`.
2.  Create an `AFTER UPDATE OF departmentId ON Employees FOR EACH ROW` trigger (`trgEmpDeptFkUpdate`) that prints "Employee's departmentId updated".
3.  Now, write an UPDATE statement that changes a `departmentId` in the `Departments` table. Assume there's a foreign key with `ON UPDATE CASCADE` from `Employees.departmentId` to `Departments.departmentId` (though you don't need to create the FK with cascade for this exercise, just understand the hypothetical).
Discuss the potential firing order and the "cascading" effect if the FK was set to cascade updates. What are the implications if one trigger's action inadvertently causes another trigger to fire multiple times?</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Understanding that triggers can cause other triggers to fire, and the order can sometimes be non-obvious or lead to performance issues if not designed carefully. Refer to `PL/SQL Language Reference`, Chapter 10, "Order in Which Triggers Fire" (p. 10-46).</p>
</div>

<h3>(iii) Contrasting with Inefficient Common Solutions</h3>

<h4>Exercise 3.3: Auditing via Application Code vs. Triggers</h4>
<p><strong>Scenario:** Every time a product's `stockQuantity` is changed, an audit record needs to be created in `AuditLog`.</p>
<p><strong>Inefficient Common Solution (Problem):** The application developers are instructed to manually insert a record into `AuditLog` every time their Java or other application code updates the `Products.stockQuantity`. Describe the DML statement the application would execute and the subsequent `INSERT` into `AuditLog`.</p>
<p><strong>Oracle-Idiomatic Solution (Solution):** Implement an `AFTER UPDATE OF stockQuantity ON Products FOR EACH ROW` trigger (similar to `trgUpdateProductStockAudit` from the hardcore problem) to automatically log these changes.</p>
<p><strong>Task:** Discuss why the trigger-based approach is superior for this auditing requirement in terms of data integrity, consistency, and reduced application code complexity/redundancy.</p>
<div class="oracle-specific">
<p><strong>Focus:</strong> Highlighting the reliability and data-centricity of triggers for auditing over manual application-level logging, which can be inconsistent or bypassed.</p>
</div>

<hr>

<h3>(iv) Hardcore Combined Problem</h3>
<p>This was already provided in the prompt as Exercise 4.1. Its solution would integrate all the concepts of Packages, Exception Handling, and Triggers from this chunk.</p>
</div>

<!-- === END OF INSERTED EXERCISES === -->

## Tips for Success & Learning
<div class="rhyme">
To master this art, a few tips we impart,<br>
So Oracle's power resides in your heart.
</div>

*   **Experiment Freely:** Don't just run the solutions. Modify them. Try different values, introduce deliberate errors, and observe Oracle's behavior. This hands-on experimentation is invaluable.
*   **Understand the "Why":** For each solution, ensure you understand not just *what* it does, but *why* it's structured that way and *why* it's the Oracle-idiomatic approach.
*   **Consult the Oracle Docs:** The provided PDF snippets in the main lecture are your friends! For deeper dives, the full `PL/SQL Language Reference` and `PL/SQL Packages and Types Reference` are your ultimate guides.
*   **Bridge from PostgreSQL:** If you're stuck, think about how you might have solved a similar problem in PostgreSQL. Then, focus on finding the Oracle equivalent or the Oracle-specific feature that addresses it more effectively.
*   **Break Down Complexity:** For the hardcore problem, tackle it piece by piece. Implement one requirement at a time, test it, and then integrate it with others.

## Conclusion & Next Steps
Well done on working through these exercises on PL/SQL Resilience! You've now gained practical experience with Oracle's robust mechanisms for creating modular, error-tolerant, and automated database logic. Packages, comprehensive exception handling, and powerful triggers are cornerstones of effective Oracle development.

<div class="rhyme">
With packages neat and errors well-tamed,<br>
Your PL/SQL skills are brightly acclaimed!
</div>

The journey continues! The next chunk in "Server Programming with Oracle (DB 23 ai) PL/SQL: A Transition Guide for PostgreSQL Users" is **Chunk 8: PL/SQL Mastery: Power Moves with Collections and Dynamic SQL**. This will take your PL/SQL programming to an even more advanced level, equipping you with tools to handle complex data structures and highly flexible SQL generation.

</div>
</body>