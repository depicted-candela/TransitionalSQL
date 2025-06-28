<head>
    <link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/solutions.css">
</head>
<body>

<div class="container">

<h1>Solutions: SQL Innovations in Oracle 23ai</h1>

<h2>Introduction and Purpose of These Solutions</h2>
<p>Welcome to the solutions guide for the "Future of Oracle" exercise set. This document is designed to validate your work, reinforce the powerful new SQL features in Oracle 23ai, and deepen your understanding of their practical application.</p>
<p>The goal here is not just to check if your answer was correct, but to understand <strong>why</strong> a particular solution is optimal. For those transitioning from PostgreSQL, the explanations will often highlight the Oracle-specific idioms and contrast them with familiar PostgreSQL patterns. Even if your code worked, we encourage you to review the provided solutions to discover alternative approaches and internalize best practices.</p>

<div class="rhyme">
To see if your query was truly astute,<br>
And your logic sound, from leaf down to root,<br>
This guide will explain, with logic and care,<br>
The optimal path, beyond just compare.
</div>

<h2>Reviewing the Dataset</h2>
<p>Before diving into the solutions, let's briefly revisit the schemas we used. These simple tables were designed to provide a clear context for practicing the new DDL and DML enhancements, querying conveniences, and advanced data types introduced in Oracle 23ai.</p>
<ul>
    <li><code>future.employees</code> and <code>future.departments</code>: A standard parent-child relationship for practicing joins in DML.</li>
    <li><code>future.performanceReviews</code> and <code>future.archivedEmployees</code>: Tables used to trigger updates and capture results with the <code>RETURNING</code> clause.</li>
    <li><code>future.regionalSales</code>: A simple table for practicing new aggregation and grouping conveniences.</li>
    <li><code>future.projectTasks</code>: A table designed to showcase the new native <code>BOOLEAN</code> and <code>INTERVAL</code> data types, and the <code>TIME_BUCKET</code> function.</li>
</ul>
<p>Understanding these relationships is key to interpreting the logic behind the solutions that follow.</p>

<h2>Solution Structure</h2>
<p>Each section below corresponds to the exercise groups you have completed. For every problem, you will find:</p>
<ol>
    <li><p><strong>The Problem Statement:</strong> The original problem is restated for immediate context.</p></li>
    <li><p><strong>The Optimal Solution:</strong> The complete, correct, and idiomatic Oracle SQL or PL/SQL code.</p></li>
    <li><p><strong>Detailed Explanation:</strong> A step-by-step breakdown of the solution's logic, focusing on the "why." This section will explain the advantages of the approach, highlight Oracle-specific features, and bridge concepts for those familiar with PostgreSQL.</p></li>
</ol>
<p>Let's begin solidifying your mastery of Oracle 23ai!</p>

<hr>

<h2>Solutions for Group 1: DDL and DML Enhancements</h2>

<h3>(i) Meanings, Values, Relations, and Advantages</h3>

<h4>Problem 1: Conditional DDL with <code>IF EXISTS</code></h4>
<h5>Problem Statement</h5>
<p class="problem-label">Write a script that first attempts to drop a table named <code>future.tempProjects</code>. The script should not fail if the table doesn't exist. Then, write a statement to create the same <code>future.tempProjects</code> table (with columns <code>projectId NUMBER, projectName VARCHAR2(100)</code>), but only if it does not already exist.</p>

<h5>Solution</h5>

```sql
-- Safely drop the table, ignoring the error if it does not exist
DROP TABLE IF EXISTS future.tempProjects;

-- Safely create the table, only if it is not already present
CREATE TABLE IF NOT EXISTS future.tempProjects (
    projectId     NUMBER,
    projectName   VARCHAR2(100)
);
```

<h5>Explanation</h5>
<div class="postgresql-bridge">
    <p>This is a welcome sight for PostgreSQL developers! Oracle 23ai introduces the <code>IF EXISTS</code> and <code>IF NOT EXISTS</code> clauses for DDL statements, which provides functionality that has long been standard in PostgreSQL. This eliminates the need for cumbersome and error-prone PL/SQL blocks that check the data dictionary (e.g., <code>USER_TABLES</code>) before executing DDL. The new syntax makes deployment and setup scripts cleaner, more readable, and far more resilient.</p>
</div>
<ul>
    <li><code>DROP TABLE IF EXISTS...</code>: This command attempts to drop the table. If the table exists, it is dropped. If it does not exist, the command does nothing and completes successfully without raising an <code>ORA-00942: table or view does not exist</code> error.</li>
    <li><code>CREATE TABLE IF NOT EXISTS...</code>: This command attempts to create the table. If a table with that name already exists, the command is ignored. If it does not exist, the table is created as specified.</li>
    <li><p><strong>Advantage:</strong> The primary advantage is <strong>idempotency</strong> in scripting. You can run the same script multiple times without it failing on the second run, which is crucial for automated deployments and database environment setup.</p>
    For more on this syntax, see the <a href="../books/sql-language-reference/15_ch13_sql-statements-commit-to-create-json-relational-duality-view.pdf">Oracle SQL Language Reference - CREATE TABLE</a>.</li>
</ul>

<h4>Problem 2: Updating Records with a <code>FROM</code> Clause Join</h4>
<h5>Problem Statement</h5>
<p class="problem-label">The company has decided to give a 5% salary cut to all employees in the 'Sales' department who received a 'Below Average' performance review. Write a single <code>UPDATE</code> statement to apply this change.</p>

<h5>Solution</h5>

```sql
UPDATE future.employees e
SET    e.salary = e.salary * 0.95
WHERE  EXISTS (
    SELECT 1
    FROM future.departments d
    JOIN future.performanceReviews pr
      ON e.employeeId = pr.employeeId
    WHERE e.departmentId = d.departmentId
      AND d.departmentName = 'Sales'
      AND pr.reviewScore = 'Below Average'
);
```

<h5>Explanation</h5>
<div class="oracle-specific">
    <p>Oracle 23ai introduces the ability to specify a <code>FROM</code> clause directly in <code>UPDATE</code> statements, similar to SQL Server. However, the classic and highly efficient Oracle idiom for this task uses a correlated subquery with <code>IN</code> or <code>EXISTS</code>. The solution above uses <code>EXISTS</code>, which is often the most performant method as it stops processing the subquery as soon as a match is found for a given employee.</p>
</div>
<ul>
    <li>The outer <code>UPDATE</code> statement targets the <code>future.employees</code> table.</li>
    <li>The <code>EXISTS</code> clause acts as the filter. For each row in <code>future.employees</code>, it executes the subquery.</li>
    <li>The subquery joins <code>departments</code> and <code>performanceReviews</code> to find if a record exists that matches the current employee's ID and meets the specified department and review score criteria.</li>
    <li><strong>Advantage:</strong> This single-statement approach is atomic and significantly more efficient than fetching employee IDs into a PL/SQL collection and then looping to perform individual updates. It minimizes context switching between the SQL and PL/SQL engines.</li>
</ul>

<h4>Problem 3: Using the <code>RETURNING</code> Clause to Capture Changed Data</h4>
<h5>Problem Statement</h5>
<p class="problem-label">The HR department in 'New York' is being dissolved. All employees in that department must be deleted. As you delete them, you need to capture their <code>employeeId</code> and <code>lastName</code> into a log table (<code>future.archivedEmployees</code>). Use the <code>DELETE</code> statement with the <code>RETURNING</code> clause to accomplish this in a single step.</p>

<h5>Solution</h5>

```sql
DECLARE
    TYPE t_employee_ids IS TABLE OF future.employees.employeeId%TYPE;
    TYPE t_last_names IS TABLE OF future.employees.lastName%TYPE;

    v_deleted_ids      t_employee_ids;
    v_deleted_names    t_last_names;
BEGIN
    DELETE FROM future.employees e
    WHERE e.departmentId IN (
        SELECT d.departmentId FROM future.departments d WHERE d.locationCity = 'New York'
    )
    RETURNING e.employeeId, e.lastName BULK COLLECT INTO v_deleted_ids, v_deleted_names;

    -- Now, efficiently insert the captured data into the log table
    FORALL i IN 1 .. v_deleted_ids.COUNT
        INSERT INTO future.archivedEmployees (employeeId, lastName, archiveDate)
        VALUES (v_deleted_ids(i), v_deleted_names(i), SYSDATE);

    DBMS_OUTPUT.PUT_LINE(v_deleted_ids.COUNT || ' employees archived.');
END;
/

```

<h5>Explanation</h5>
<div class="oracle-specific">
    <p>The <code>RETURNING BULK COLLECT INTO</code> clause is a cornerstone of high-performance PL/SQL. It allows a DML statement (<code>INSERT</code>, <code>UPDATE</code>, or <code>DELETE</code>) to return values from the affected rows directly into PL/SQL collections without a subsequent <code>SELECT</code> statement.</p>
</div>
<ul>
    <li>Two collection types, <code>t_employee_ids</code> and <code>t_last_names</code>, are declared to hold the data returned from the <code>DELETE</code> operation.</li>
    <li>The <code>DELETE</code> statement identifies the target rows.</li>
    <li>The <code>RETURNING e.employeeId, e.lastName BULK COLLECT INTO v_deleted_ids, v_deleted_names</code> clause takes the specified columns from **every deleted row** and populates the two collections in a single database operation.</li>
    <li>The <code>FORALL</code> statement then bulk-inserts all captured data from the collections into the audit table, again in a single, highly efficient operation.</li>
    <li><strong>Advantage:</strong> This avoids multiple round trips to the SQL engine, drastically reducing overhead compared to fetching and processing rows one by one. Find more details in the <a href="../books/sql-language-reference/21_ch19_sql-statements-merge-to-update.pdf">SQL Language Reference for the RETURNING Clause</a>.</li>
</ul>

<h3>(ii) Disadvantages and Pitfalls</h3>

<h4>Problem 1: <code>RETURNING INTO</code> with Multiple Rows</h4>
<h5>Problem Statement</h5>
<p class="problem-label">Write a PL/SQL anonymous block. Attempt to delete all employees from the 'Sales' department and use <code>RETURNING employeeId INTO ...</code> to capture the ID of the deleted employee into a single <code>NUMBER</code> variable. Execute the block and analyze the error.</p>

<h5>Solution</h5>

```sql
DECLARE
    vEmployeeId NUMBER;
BEGIN
    DELETE FROM future.employees
    WHERE departmentId = 10 -- This affects multiple rows
    RETURNING employeeId INTO vEmployeeId;

    DBMS_OUTPUT.PUT_LINE('Deleted employee: ' || vEmployeeId);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ORA-01422: exact fetch returns more than requested number of rows.');
        DBMS_OUTPUT.PUT_LINE('Pitfall: RETURNING INTO a scalar variable cannot handle multiple affected rows.');
END;
/
```

<h5>Explanation</h5>
<div class="caution">
    <p>This solution correctly demonstrates the pitfall. The DML statement affects multiple rows, but the <code>RETURNING INTO</code> clause attempts to place all of those returned values into a single scalar variable (<code>vEmployeeId</code>). This is analogous to a <code>SELECT ... INTO</code> that finds more than one row. Oracle raises the predefined <code>TOO_MANY_ROWS</code> exception.</p>
</div>
<ul>
    <li><strong>The Pitfall:</strong> Assuming a DML statement will only affect one row and using <code>RETURNING INTO</code> with a scalar variable.</li>
    <li><strong>The Correction:</strong> Whenever a DML statement *could* affect more than one row, you **must** use the <code>BULK COLLECT INTO</code> extension to return the values into a collection, as demonstrated in the previous "Advantages" section. This is a fundamental principle for writing robust PL/SQL.</li>
</ul>

<h3>(iii) Contrasting with Inefficient Common Solutions</h3>

<h4>Problem 1: Inefficient Update vs. Efficient <code>UPDATE</code></h4>
<h5>Problem Statement</h5>
<p class="problem-label">A policy change requires that the salary of every employee in the 'Engineering' department be updated to match the salary of employee 'Charlie Williams' (ID 103). First, solve this using a less efficient, two-step approach. Then, solve it using a more efficient, single-statement approach.</p>

<h5>Solution</h5>
<div class="postgresql-bridge">
    <p>This contrast highlights a key performance principle in Oracle that is also true in PostgreSQL: minimizing the number of distinct statements and round-trips is paramount. Performing the operation in a single SQL statement is almost always superior to a multi-statement PL/SQL approach.</p>
</div>

<p><strong>Method 1: The Inefficient (but common) Two-Step PL/SQL Approach</strong></p>

```sql
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

```

<p><strong>Method 2: The Efficient Single-Statement SQL Approach</strong></p>

```sql
UPDATE future.employees
SET salary = (SELECT e2.salary FROM future.employees e2 WHERE e2.employeeId = 103)
WHERE departmentId = 20;

ROLLBACK;
```

<h5>Explanation</h5>
<ul>
    <li><strong>Inefficient Method:</strong> This approach involves two separate context switches between the PL/SQL engine and the SQL engine. The first is for the <code>SELECT INTO</code>, and the second is for the <code>UPDATE</code>. While logically simple, this is less performant for the database.</li>
    <li><strong>Efficient Method:</strong> This approach accomplishes the same goal in a single SQL statement. The database can resolve the subquery and perform the update in one atomic, optimized operation. This eliminates the overhead of context switching and is the idiomatic way to perform such an update in both Oracle and PostgreSQL.</li>
</ul>

<hr>

<h2>Solutions for Group 2: Querying Conveniences</h2>

<h3>(i) Meanings, Values, Relations, and Advantages</h3>

<h4>Problem 1: <code>GROUP BY</code> with an Alias</h4>
<h5>Problem Statement</h5>
<p class="problem-label">Write a query that calculates the total sales for each region. In your <code>SELECT</code> list, alias the <code>region</code> column as <code>salesRegion</code>. Use this alias <code>salesRegion</code> in the <code>GROUP BY</code> clause.</p>

<h5>Solution</h5>

```sql
SELECT
    region AS salesRegion,
    SUM(salesAmount) AS totalSales
FROM
    future.regionalSales
GROUP BY
    salesRegion -- Using the alias here is new in 23ai
ORDER BY
    salesRegion;
```

<h5>Explanation</h5>
<div class="postgresql-bridge">
    <p>Using a column alias in the <code>GROUP BY</code> clause has long been a standard and convenient feature in PostgreSQL. Oracle 23ai adopts this SQL-standard behavior, which is a significant quality-of-life improvement. Previously in Oracle, you had to repeat the entire column expression in the <code>GROUP BY</code> clause (<code>GROUP BY region</code>). This new feature enhances code readability and maintainability, especially when grouping by complex expressions.</p>
</div>

<h4>Problem 2: <code>SELECT</code> without a <code>FROM</code> Clause</h4>
<h5>Problem Statement</h5>
<p class="problem-label">Perform two simple calculations without referencing any table: 1. Find the result of <code>SYSDATE + 7</code>. 2. Calculate <code>100 * 1.05</code>.</p>

<h5>Solution</h5>

```sql
-- Example 1
SELECT SYSDATE + 7;

-- Example 2
SELECT 100 * 1.05 AS hundredWithInterest;
```

<h5>Explanation</h5>
<div class="postgresql-bridge">
    <p>This is another feature where Oracle 23ai aligns with PostgreSQL and the SQL standard. For decades, performing a calculation or calling a function without querying a table in Oracle required the use of the dummy table <code>DUAL</code> (e.g., <code>SELECT 100 * 1.05 FROM DUAL;</code>). Making the <code>FROM DUAL</code> clause optional simplifies quick calculations and makes the syntax more intuitive for developers coming from other database systems.</p>
</div>

<h4>Problem 3: Using the <code>VALUES</code> Clause to Construct an Inline Table</h4>
<h5>Problem Statement</h5>
<p class="problem-label">You have a new set of product price points to analyze. Without creating a permanent table, construct a two-column, three-row result set using the <code>VALUES</code> clause for the following data: ('Gadget', 50.00), ('Widget', 75.50), ('Sprocket', 25.00). Then, join this on-the-fly table with your <code>regionalSales</code> table to show the total sales for each of these products.</p>

<h5>Solution</h5>

```sql
SELECT
    p.productName,
    p.price,
    SUM(rs.salesAmount) AS totalSales
FROM
    (VALUES
        ('Gadget', 50.00),
        ('Widget', 75.50),
        ('Sprocket', 25.00)
    ) p (productName, price)
LEFT JOIN
    future.regionalSales rs ON p.productName = rs.product
GROUP BY
    p.productName, p.price
ORDER BY
    p.productName;
```

<h5>Explanation</h5>
<div class="oracle-specific">
    <p>The <code>VALUES</code> clause, when used as a table constructor, is a powerful 23ai feature. It allows you to create a temporary, inline table from literal values. This is incredibly useful for providing a set of parameters to a query or for creating test data without the overhead of DDL. The syntax involves wrapping the <code>VALUES</code> list in parentheses and providing an alias for the derived table and its columns, such as <code>p (productName, price)</code>.</p>
</div>
<ul>
    <li>This is more concise and readable than the older Oracle method, which involved chaining multiple <code>SELECT ... FROM DUAL</code> statements with <code>UNION ALL</code>.</li>
    <li>You can then treat this derived table like any other table in your query, joining it to other tables as shown with the <code>LEFT JOIN</code>.</li>
</ul>

<h3>(ii) Disadvantages and Pitfalls</h3>

<h4>Problem 1: Logical Processing Order Pitfall</h4>
<h5>Problem Statement</h5>
<p class="problem-label">Try to filter the results of an aggregate query using the <code>GROUP BY</code> alias in the `WHERE` clause. For example, calculate total sales by region and only show regions where the aliased <code>totalSales</code> is greater than 4000. Why does this fail? How do you correctly filter on an aggregate result?</p>

<h5>Solution</h5>

```sql
-- This query will fail with ORA-00904: "TOTALSALES": invalid identifier
SELECT
    region,
    SUM(salesAmount) AS totalSales
FROM
    future.regionalSales
WHERE
    totalSales > 4000;
```

```sql
-- This is the correct approach
SELECT
    region,
    SUM(salesAmount) AS totalSales
FROM
    future.regionalSales
GROUP BY
    region
HAVING
    SUM(salesAmount) > 4000;
```

<h5>Explanation</h5>
<div class="caution">
    <p>This demonstrates a fundamental principle of SQL's logical query processing order, which is the same in both Oracle and PostgreSQL. The clauses of a <code>SELECT</code> statement are processed in a specific sequence, and the <code>WHERE</code> clause is processed *before* the <code>GROUP BY</code> and <code>SELECT</code> clauses. Therefore, the alias <code>totalSales</code>, which is defined in the <code>SELECT</code> list, does not exist yet when the <code>WHERE</code> clause is being evaluated.</p>
</div>
<ul>
    <li><strong>The Pitfall:</strong> Attempting to reference a column alias from the <code>SELECT</code> list within a <code>WHERE</code> clause.</li>
    <li><strong>The Correction:</strong> The <code>HAVING</code> clause was created specifically for this purpose. It is processed *after* the <code>GROUP BY</code> clause and is used to filter results based on the output of aggregate functions (like <code>SUM()</code>, <code>AVG()</code>, etc.).</li>
</ul>

<hr>

<h2>Solutions for Group 3: Advanced Data Types and Functions</h2>

<h3>(i) Meanings, Values, Relations, and Advantages</h3>

<h4>Problem 1: Using the Native <code>BOOLEAN</code> Data Type</h4>
<h5>Problem Statement</h5>
<p class="problem-label">Query the <code>future.projectTasks</code> table to show the names of all tasks that have been marked as completed.</p>

<h5>Solution</h5>

```sql
SELECT taskName
FROM future.projectTasks
WHERE isCompleted;
```

<h5>Explanation</h5>
<div class="postgresql-bridge">
    <p>This syntax is identical to PostgreSQL and adheres to the SQL standard. The introduction of a native <code>BOOLEAN</code> type in Oracle 23ai is a monumental improvement. Previously, developers had to simulate booleans using <code>CHAR(1)</code> with values 'Y'/'N' or <code>NUMBER(1)</code> with values 1/0. The native <code>BOOLEAN</code> type is self-documenting, removes ambiguity, and simplifies logic, as you no longer need to write <code>WHERE isCompletedFlag = 'Y'</code>.</p>
    <li>For an in-depth look, see the <a href="../books/sql-language-reference/04_ch02_basic-elements-of-oracle-sql.pdf">SQL Language Reference on Data Types</a>.</li>
</div>

<h4>Problem 2: Aggregating <code>INTERVAL</code> Data Types</h4>
<h5>Problem Statement</h5>
<p class="problem-label">For all completed tasks, calculate the total duration and the average duration. The duration of a task is the difference between its <code>endDate</code> and <code>startDate</code>.</p>

<h5>Solution</h5>

```sql
SELECT
    SUM(endDate - startDate) AS totalDuration,
    AVG(endDate - startDate) AS averageDuration
FROM
    future.projectTasks
WHERE
    isCompleted = TRUE;
```

<h5>Explanation</h5>
<div class="oracle-specific">
    <p>Oracle 23ai introduces the ability to directly use aggregate functions like <code>SUM</code> and <code>AVG</code> on <code>INTERVAL</code> data types. The subtraction of two <code>TIMESTAMP</code> or <code>DATE</code> values results in an <code>INTERVAL DAY TO SECOND</code>.</p>
</div>
<ul>
    <li>Before this feature, calculating a total or average duration was a complex task. One would have to extract each component (days, hours, minutes, seconds) as a number, perform the aggregation on the numbers, and then manually reconstruct an interval, which was both tedious and error-prone.</li>
    <li>This enhancement dramatically simplifies date/time analytics, making such calculations intuitive and concise.</li>
</ul>

<h4>Problem 3: Grouping Data into Time Buckets</h4>
<h5>Problem Statement</h5>
<p class="problem-label">You want to see how many tasks started in each 15-day period throughout the project's timeline. Use the <code>TIME_BUCKET</code> function to group the tasks. The "origin" of the bucketing should be the earliest task start date in the table.</p>

<h5>Solution</h5>

```sql
WITH origin_point AS (
    SELECT MIN(startDate) as minStartDate FROM future.projectTasks
)
SELECT
    TIME_BUCKET(pt.startDate, INTERVAL '15' DAY, o.minStartDate) AS bucketStart,
    COUNT(pt.taskId) AS tasksStartedInBucket
FROM
    future.projectTasks pt,
    origin_point o
GROUP BY
    TIME_BUCKET(pt.startDate, INTERVAL '15' DAY, o.minStartDate)
ORDER BY
    bucketStart;
```

<h5>Explanation</h5>
<div class="oracle-specific">
    <p>The <code>TIME_BUCKET</code> function is a powerful new 23ai feature for time-series analysis. It simplifies the process of grouping data into fixed-size time intervals ("buckets").</p>
</div>
<ul>
    <li><strong>First Argument:</strong> The timestamp column to be bucketed (<code>pt.startDate</code>).</li>
    <li><strong>Second Argument:</strong> The size of the bucket, expressed as an <code>INTERVAL</code> literal (<code>INTERVAL '15' DAY</code>).</li>
    <li><strong>Third Argument:</strong> The "origin" or anchor date. All buckets are calculated relative to this point in time, ensuring consistent and predictable bucket boundaries. Here, we use a CTE to find the earliest start date to use as a logical anchor for our analysis.</li>
    <li>This function is vastly superior to older manual methods that involved complex arithmetic with <code>TRUNC</code> and date calculations to achieve a similar result. See the documentation for more on the <a href="../books/sql-language-reference/09_ch07_functions.pdf">TIME_BUCKET function</a>.</li>
</ul>

<h3>(iii) Contrasting with Inefficient Common Solutions</h3>

<h4>Problem 1: Pre-23ai `BOOLEAN` vs. Native `BOOLEAN`</h4>
<h5>Problem Statement</h5>
<p class="problem-label">Imagine the <code>projectTasks</code> table was designed in Oracle 19c. The <code>isCompleted</code> column would likely be <code>isCompletedLegacy CHAR(1) CHECK (isCompletedLegacy IN ('Y', 'N'))</code>. Add this legacy column, populate it, and write a query to find completed tasks. Compare it with the native <code>BOOLEAN</code> query.</p>

<h5>Solution</h5>

```sql
-- Step 1: Add and populate the legacy column
ALTER TABLE future.projectTasks ADD (isCompletedLegacy CHAR(1));
UPDATE future.projectTasks SET isCompletedLegacy = CASE WHEN isCompleted THEN 'Y' ELSE 'N' END;
COMMIT;

-- Step 2: Query using the less clear, legacy method
SELECT taskName
FROM future.projectTasks
WHERE isCompletedLegacy = 'Y';
```

<h5>Explanation</h5>
<div class="caution">
    <p>The solution demonstrates the common workaround for the lack of a boolean type in older Oracle versions. The contrast is stark:</p>
</div>
<ul>
    <li><strong>Legacy Method:</strong> <code>WHERE isCompletedLegacy = 'Y'</code>. This code is not self-documenting. It requires the developer to know that 'Y' means true. It is also less safe; without a <code>CHECK</code> constraint, a user could insert 'T', 'F', or other values, leading to data integrity issues.</li>
    <li><strong>Modern Method:</strong> <code>WHERE isCompleted</code>. This is unambiguous, type-safe, and aligns with standard programming logic. It represents a significant step forward in clarity and correctness for Oracle SQL.</li>
</ul>

<hr>

<h2>Solution for the Hardcore Combined Problem</h2>

<h5>Problem Statement</h5>
<p class="problem-label">A multi-step year-end analysis and cleanup is required. It involves conditionally creating a log table, performing various calculations, updating active employees in a specific department based on a join, logging those changes using <code>RETURNING</code>, and finally deleting employees from a decommissioned department.</p>

<h5>Solution</h5>

```sql
-- Step 1: Conditionally create the audit log table
CREATE TABLE IF NOT EXISTS future.hcAuditLog (
    logData VARCHAR2(200)
);

-- Step 2: Perform a simple calculation without a table
SELECT 1.05 AS potentialBudgetMultiplier;

-- Step 3: Aggregate an INTERVAL data type
SELECT AVG(endDate - startDate) AS averageProjectDuration
FROM future.hcProjects
WHERE endDate IS NOT NULL;

-- Step 4: Use TIME_BUCKET with a GROUP BY alias
SELECT
    TIME_BUCKET(startDate, INTERVAL '3' MONTH) AS startQuarter,
    COUNT(projectId) AS projectCount
FROM
    future.hcProjects
GROUP BY
    startQuarter -- Using the alias is a 23ai feature
ORDER BY
    startQuarter;

-- Step 5, 6, 7 & 8 are combined into a single atomic PL/SQL block
DECLARE
    TYPE t_log_messages IS TABLE OF VARCHAR2(200);
    v_log_msgs t_log_messages;
BEGIN
    -- Steps 6 & 7: Update active employees in 'Innovation' and log the changes
    -- This uses a direct join in the UPDATE (via EXISTS) and the RETURNING clause.
    UPDATE future.hcEmployees e
    SET e.salary = e.salary * 1.10
    WHERE e.isActive -- Uses the native BOOLEAN type
      AND EXISTS (
          SELECT 1
          FROM future.hcDepartments d
          WHERE e.departmentId = d.departmentId
            AND d.departmentName = 'Innovation'
      )
    RETURNING 'Employee ' || e.employeeId || ' salary is now ' || (e.salary * 1.10)
    BULK COLLECT INTO v_log_msgs;

    -- Insert all captured log messages efficiently
    FORALL i IN 1 .. v_log_msgs.COUNT
        INSERT INTO future.hcAuditLog (logData) VALUES (v_log_msgs(i));

    DBMS_OUTPUT.PUT_LINE(v_log_msgs.COUNT || ' salary records updated and logged.');

    -- Step 8: Delete employees from the 'Logistics' department
    DELETE FROM future.hcEmployees e
    WHERE e.departmentId IN (
        SELECT d.departmentId
        FROM future.hcDepartments d
        WHERE d.departmentName = 'Logistics'
    );

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' employees deleted from Logistics.');

    COMMIT;
END;
/

```

<h5>Explanation</h5>
<div class="oracle-specific">
<p>This comprehensive solution integrates nearly all the concepts from this exercise set, showcasing how they combine to solve a realistic business problem efficiently in Oracle 23ai.</p>
</div>
<ol>
    <li><p>The script begins with an idempotent DDL statement using <code>IF NOT EXISTS</code>, ensuring the log table is ready without causing errors on subsequent runs.</p></li>
    <li><p>The budget multiplier and average duration calculations demonstrate the convenience of <code>SELECT</code> without <code>FROM</code> and the power of aggregating <code>INTERVAL</code> types, respectively.</p></li>
    <li><p>The quarterly report uses <code>TIME_BUCKET</code> for modern time-series analysis and the new <code>GROUP BY</code> alias feature for improved readability.</p></li>
    <li><p>The core logic is encapsulated in a single PL/SQL block to ensure atomicity—all changes succeed or none do.</p></li>
    <li><p>The <code>UPDATE</code> statement efficiently targets rows using a join condition and filters on the new native <code>BOOLEAN</code> type (<code>WHERE e.isActive</code>).</p></li>
    <li><p>The <code>RETURNING BULK COLLECT INTO</code> clause is used to capture the results of the update without needing a follow-up query, feeding the data directly into a PL/SQL collection.</p></li>
    <li><p><code>FORALL</code> provides the most performant way to insert the collection of log messages into the audit table.</p></li>
    <li><p>Finally, a clean <code>DELETE</code> statement removes the decommissioned employees, completing the transaction before the final <code>COMMIT</code>.</p></li>
</ol>

<hr>

<h2>Key Takeaways & Best Practices</h2>
<ul>
    <li><p><strong>Embrace Idempotent DDL:</strong> Always use <code>IF [NOT] EXISTS</code> in your setup and deployment scripts to make them robust and re-runnable.</p></li>
    <li><p><strong>Think in Sets:</strong> Leverage single, powerful SQL statements with joins in DML (<code>UPDATE</code>/<code>DELETE</code>) and correlated subqueries instead of looping in PL/SQL whenever possible. This minimizes context switching and is almost always more performant.</p></li>
    <li><p><strong>Capture Results Efficiently:</strong> Master the <code>RETURNING BULK COLLECT INTO</code> pattern. It is the cornerstone of high-performance DML processing in PL/SQL.</p></li>
    <li><p><strong>Use the Right Type for the Job:</strong> The new native <code>BOOLEAN</code> type is a massive improvement. Use it instead of legacy character or number workarounds to improve clarity, correctness, and maintainability.</p></li>
    <li><p><strong>Modernize Your Queries:</strong> Use new conveniences like <code>GROUP BY</code> alias, <code>SELECT</code> without <code>FROM</code>, and the <code>VALUES</code> table constructor to write cleaner, more readable, and more modern Oracle SQL.</p></li>
</ul>

<h2>Conclusion & Next Steps</h2>
<p>Congratulations on working through these exercises! You have now practiced some of the most impactful new SQL features in Oracle 23ai, from foundational DDL/DML enhancements to modern data types and analytical functions.</p>
<p>By understanding not only *how* these features work but also *why* they are superior to older methods, you are well-equipped to write efficient, modern, and maintainable Oracle SQL. The next logical step in your journey is to explore how Oracle handles date and time with its powerful set of specific functions.</p>
<div class="rhyme">
The syntax is learned, the logic is sound,<br>
On solid new features, your knowledge is founded.<br>
Now forward you go, to the next chapter's call,<br>
To master the dates, and stand ever so tall.
</div>
<p>Prepare to dive into <strong>Date Functions: Oracle Specifics & Practice</strong>.</p>
</div>
</body>