<head>
    <link rel="stylesheet"href="../styles/lecture.css">
</head>

<body>
    <div class="toc-popup-container">
        <input type="checkbox"id="tocToggleChunk15"class="toc-toggle-checkbox">
        <label for="tocToggleChunk15"class="toc-toggle-label">
            <span>Future of Oracle: SQL Innovations in 23ai</span>
            <span class="toc-icon-open"></span>
        </label>
        <div class="toc-content">
            <h4>Contents</h4>
            <ul>
                <li><a href="#introduction">Introduction: The Evolving SQL Landscape</a></li>
                <li><a href="#setup">Prerequisites & Dataset Setup</a></li>
                <li><a href="#section1">Section 1: What Are They? (Meanings & Values)</a>
                    <ul>
                        <li><a href="#s1_boolean">The <code>BOOLEAN</code> Data Type</a></li>
                        <li><a href="#s1_if_exists"><code>IF [NOT] EXISTS</code> for DDL</a></li>
                        <li><a href="#s1_update_delete_from">Direct Joins in DML</a></li>
                        <li><a href="#s1_group_by_alias"><code>GROUP BY</code> Column Alias</a></li>
                        <li><a href="#s1_returning_into">The <code>RETURNING INTO</code> Clause</a></li>
                        <li><a href="#s1_select_no_from"><code>SELECT</code> Without <code>FROM</code></a></li>
                        <li><a href="#s1_values_constructor">Table Value Constructor</a></li>
                        <li><a href="#s1_interval_agg"><code>INTERVAL</code> Aggregations</a></li>
                        <li><a href="#s1_time_bucket"><code>TIME_BUCKET</code> Function</a></li>
                    </ul>
                </li>
                <li><a href="#section2">Section 2: Relations: How They Play with Others</a></li>
                <li><a href="#section3">Section 3: Bridging from PostgreSQL</a></li>
                <li><a href="#section4">Section 4: How to Use Them (Structures & Syntax)</a>
                    <ul>
                       <li><a href="#s4_boolean">Using the <code>BOOLEAN</code> Type</a></li>
                       <li><a href="#s4_if_exists">Using <code>IF [NOT] EXISTS</code></a></li>
                       <li><a href="#s4_update_delete_from">Using Direct Joins</a></li>
                       <li><a href="#s4_group_by_alias">Using <code>GROUP BY</code> Alias</a></li>
                       <li><a href="#s4_returning_into">Using <code>RETURNING INTO</code></a></li>
                       <li><a href="#s4_select_no_from">Using <code>SELECT</code> without <code>FROM</code></a></li>
                       <li><a href="#s4_values_constructor">Using <code>VALUES</code> Constructor</a></li>
                       <li><a href="#s4_interval_agg">Using <code>INTERVAL</code> Aggregations</a></li>
                       <li><a href="#s4_time_bucket">Using <code>TIME_BUCKET</code></a></li>
                    </ul>
                </li>
                <li><a href="#section5">Section 5: Why Use Them? (Advantages)</a></li>
                <li><a href="#section6">Section 6: Watch Out! (Pitfalls & Disadvantages)</a></li>
                <li><a href="#conclusion">Conclusion & Next Steps</a></li>
            </ul>
        </div>
    </div>

<div class="container">

<h1 id="mainTitle">Future of Oracle: SQL Innovations in 23ai</h1>

<h2 id="introduction">Introduction: The Evolving SQL Landscape</h2>

<p>
Welcome to a future where SQL is more intuitive, powerful, and less prone to scripting strife. Oracle Database 23ai doesn't just add features; it refines the very grammar of how we interact with data, making our code cleaner and our logic clearer. This lecture explores a suite of enhancements that modernize DML, simplify DDL, and introduce powerful new ways to handle data, from simple truth values to complex time-based analysis.
</p>
<p>
For those transitioning from PostgreSQL, many of these <em>new</em> features will feel like a welcome sight, a familiar tune in a different concert hall. Oracle has embraced several ISO SQL standard features that align its syntax more closely with other modern RDBMSs, making your transition smoother and your skills more portable. We will explore these innovations not just as new tools, but as bridges connecting your existing expertise to Oracle's powerful, evolving platform.
</p>

<div class="rhyme">
So let the old syntax fade and fall, <br>
Heed the 23ai bugle call. <br>
For code that's cleaner, sharp, and true, <br>
A world of innovation waits for you.
</div>

<h2 id="setup">Prerequisites & Dataset Setup</h2>
<p>
Before diving into the exercises, ensure you have a solid grasp of the concepts from the previous course modules, particularly basic <code>SELECT</code> statements, <code>WHERE</code> clauses, and standard aggregate functions like <code>SUM</code> and <code>COUNT</code>.
</p>

<h3>Dataset Setup</h3>
<p>
The following script creates and populates a small, cohesive set of tables within the <code>future</code> schema. These tables are designed specifically to demonstrate the features in this section. Please execute this entire script in your Oracle 23ai environment (such as SQL Developer or SQL*Plus) before beginning the exercises.
</p>


```sql
-- Main Dataset for 23ai SQL Features
CREATE TABLE future.employees (
    employeeId      NUMBER PRIMARY KEY,
    firstName       VARCHAR2(50),
    lastName        VARCHAR2(50),
    departmentId    NUMBER,
    salary          NUMBER(10, 2),
    hireDate        DATE
);

CREATE TABLE future.departments (
    departmentId    NUMBER PRIMARY KEY,
    departmentName  VARCHAR2(100),
    locationCity    VARCHAR2(100)
);

CREATE TABLE future.projectTasks (
    taskId        NUMBER PRIMARY KEY,
    taskName      VARCHAR2(100),
    isCompleted   BOOLEAN, -- New 23ai Feature
    startDate     TIMESTAMP,
    endDate       TIMESTAMP
);

CREATE TABLE future.archivedEmployees (
    employeeId      NUMBER,
    lastName        VARCHAR2(50),
    archiveDate     DATE
);

-- Populate Data
INSERT INTO future.departments VALUES (10, 'Sales', 'New York');
INSERT INTO future.departments VALUES (20, 'Engineering', 'San Francisco');

INSERT INTO future.employees VALUES (101, 'Alice', 'Smith', 10, 75000, DATE '2022-01-15');
INSERT INTO future.employees VALUES (102, 'Bob', 'Johnson', 10, 80000, DATE '2021-03-22');
INSERT INTO future.employees VALUES (103, 'Charlie', 'Williams', 20, 120000, DATE '2020-05-10');

INSERT INTO future.projectTasks VALUES (1, 'Initial Analysis', TRUE, TIMESTAMP '2023-01-10 09:00:00', TIMESTAMP '2023-01-15 17:00:00');
INSERT INTO future.projectTasks VALUES (2, 'Design Phase', TRUE, TIMESTAMP '2023-01-16 09:00:00', TIMESTAMP '2023-01-28 18:00:00');
INSERT INTO future.projectTasks VALUES (3, 'Development Sprint 1', FALSE, TIMESTAMP '2023-02-01 09:00:00', NULL);

COMMIT;
```


<h2 id="section1">Section 1: What Are They? (Meanings & Values)</h2>

<p>This section defines the core identity of each new feature, explaining what it is and the kind of value it produces.</p>

<h3 id="s1_boolean">The <code>BOOLEAN</code> Data Type</h3>
<p>
This is a true, ISO SQL standard-compliant data type that stores the logical values of <code>TRUE</code> or <code>FALSE</code>. It provides a native, type-safe way to represent truth values, eliminating the need for workarounds like <code>NUMBER(1)</code> or <code>CHAR(1)</code>. The value of a <code>BOOLEAN</code> column is simply <code>TRUE</code> or <code>FALSE</code>.<sup id="fnref1_1"><a href="#fn1_1">1</a></sup>
</p>

<h3 id="s1_if_exists"><code>IF [NOT] EXISTS</code> for DDL</h3>
<p>
This is a syntax modifier for Data Definition Language (DDL) statements like <code>CREATE</code>, <code>ALTER</code>, and <code>DROP</code>. It allows you to execute a DDL command conditionally. For instance, <code>DROP TABLE IF EXISTS ...</code> will only execute if the table actually exists, preventing an error if it doesn't. This feature produces no direct output value but controls the flow of a script, making it idempotent and robust.<sup id="fnref1_2"><a href="#fn1_2">2</a></sup>
</p>

<h3 id="s1_update_delete_from">Direct Joins in DML</h3>
<p>
This feature adds the ability to use a <code>FROM</code> clause directly within <code>UPDATE</code> and <code>DELETE</code> statements. It allows you to join the target table with other tables to determine which rows to modify or remove. This brings a powerful and readable pattern for complex, conditional DML operations, a direct value that simplifies logic.<sup id="fnref1_3"><a href="#fn1_3">3</a></sup>
</p>

<h3 id="s1_group_by_alias"><code>GROUP BY</code> Column Alias</h3>
<p>
This feature is a quality-of-life improvement that allows you to reference a column alias from the <code>SELECT</code> list directly in the <code>GROUP BY</code> clause. Instead of repeating a complex expression, you can use its clean, aliased name for grouping. This simplifies the syntax for aggregate queries on calculated columns.<sup id="fnref1_4"><a href="#fn1_4">4</a></sup>
</p>

<h3 id="s1_returning_into">The <code>RETURNING INTO</code> Clause</h3>
<p>
While <code>RETURNING</code> has existed, its enhancement in 23ai is notable. This clause, used with <code>INSERT</code>, <code>UPDATE</code>, or <code>DELETE</code>, captures values from the rows affected by the DML operation. It can return columns *after* the change (and even before, for <code>UPDATE</code>/<code>DELETE</code>) without requiring a subsequent <code>SELECT</code> statement. When used in PL/SQL with <code>BULK COLLECT INTO</code>, it efficiently returns values from multiple affected rows into a collection variable.<sup id="fnref1_5"><a href="#fn1_5">5</a></sup>
</p>

<h3 id="s1_select_no_from"><code>SELECT</code> Without <code>FROM</code></h3>
<p>
This feature allows you to execute a <code>SELECT</code> statement that contains only expressions, without needing to specify a table in a <code>FROM</code> clause. It's a simplification for performing quick calculations or invoking functions without the syntactic baggage of referencing the <code>DUAL</code> table.<sup id="fnref1_6"><a href="#fn1_6">6</a></sup>
</p>

<h3 id="s1_values_constructor">Table Value Constructor</h3>
<p>
The <code>VALUES</code> clause can now be used to construct a transient, inline table of rows directly within a SQL query. This allows you to define a set of constant rows on-the-fly, which can then be used in a <code>SELECT</code> statement or joined with other tables, perfect for lookups or providing small sets of test data.<sup id="fnref1_7"><a href="#fn1_7">7</a></sup>
</p>

<h3 id="s1_interval_agg"><code>INTERVAL</code> Aggregations</h3>
<p>
This enhancement allows standard aggregate functions like <code>SUM()</code> and <code>AVG()</code> to operate directly on <code>INTERVAL</code> data types. This means you can easily calculate total or average durations across a set of records, producing a single, aggregate <code>INTERVAL</code> value.<sup id="fnref1_8"><a href="#fn1_8">8</a></sup>
</p>

<h3 id="s1_time_bucket"><code>TIME_BUCKET</code> Function</h3>
<p>
<code>TIME_BUCKET</code> is a powerful function designed for time-series analysis. It takes a timestamp, an interval (<code>stride</code>), and an origin point, and returns the start or end of the time <em>bucket</em> that the timestamp falls into. This allows for easy and accurate grouping of time-based data into consistent, fixed-size intervals (e.g., every 15 minutes, every 4 weeks).<sup id="fnref1_9"><a href="#fn1_9">9</a></sup>
</p>

<h2 id="section2">Section 2: Relations: How They Play with Others</h2>

<div class="rhyme">
No feature's an island, you will find, <br>
They're all connected, intertwined.
</div>

<ul>
    <li>
        <strong><code>IF [NOT] EXISTS</code></strong> is purely a DDL enhancement, making scripts that use <code>CREATE</code> or <code>DROP</code> statements more resilient. It has no direct relation to DML or querying.
    </li>
    <li>
        <strong><code>BOOLEAN</code></strong> type naturally relates to <code>WHERE</code> clauses in any DML or <code>SELECT</code> statement, providing a clearer way to express filter conditions than <code>column = 1</code> or <code>column = 'Y'</code>.
    </li>
    <li>
        <strong>Direct Joins in DML</strong> are fundamentally related to the <code>JOIN</code> concepts you know. They allow <code>UPDATE</code> and <code>DELETE</code> to leverage the power of joining tables, something previously done with more complex correlated subqueries or <code>MERGE</code> statements.
    </li>
    <li>
        <strong><code>RETURNING INTO</code></strong> is a DML feature that bridges the gap between SQL and PL/SQL. It takes the output of a DML statement and feeds it directly into PL/SQL variables or collections, avoiding a follow-up <code>SELECT</code> query. It's particularly powerful when combined with bulk operations (<code>FORALL</code>).
    </li>
    <li>
        <strong><code>GROUP BY Column Alias</code></strong> is directly related to the <code>SELECT</code> list and the <code>GROUP BY</code> clause. It simplifies the syntax but does not change the logical order of operations: <code>WHERE</code> is still processed before aliases are available for grouping.
    </li>
    <li>
        <strong><code>SELECT without FROM</code></strong> directly relates to and often replaces the Oracle-specific <code>DUAL</code> table for simple, table-agnostic queries.
    </li>
    <li>
        <strong>Table Value Constructor (<code>VALUES</code>)</strong> acts like a temporary, inline Common Table Expression (CTE). It generates a row source that can be used in a <code>FROM</code> clause and joined with other tables.
    </li>
    <li>
        <strong><code>INTERVAL</code> Aggregations</strong> enhance existing aggregate functions like <code>SUM()</code> and <code>AVG()</code> by extending their capabilities to a new data type, <code>INTERVAL</code>.
    </li>
    <li>
        <strong><code>TIME_BUCKET</code></strong> is a powerful companion to <code>GROUP BY</code>. It's a function that you typically use within a <code>GROUP BY</code> clause to aggregate time-series data into consistent periods, something that previously required complex arithmetic with <code>TRUNC</code> or other date functions.
    </li>
</ul>

<h2 id="section3">Section 3: Bridging from PostgreSQL</h2>

<div class="postgresql-bridge">
  <h4>From Postgres to Oracle: Familiar Concepts, New Dialect</h4>
  <p>If you're coming from PostgreSQL, many of Oracle's 23ai features will feel like meeting an old friend who now speaks with a slightly different accent. This section bridges that gap.</p>
  <ul>
    <li>
        <strong><code>BOOLEAN</code> Data Type:</strong> <strong>Welcome home!</strong> PostgreSQL has long had a native <code>BOOLEAN</code> type. Oracle 23ai's introduction of a standard <code>BOOLEAN</code> means you can now write <code>isCompleted BOOLEAN</code> and <code>WHERE isCompleted</code> just as you would in Postgres, abandoning Oracle's historical workarounds.
    </li>
    <li>
        <strong><code>IF [NOT] EXISTS</code>:</strong> This is another piece of familiar syntax. Both PostgreSQL and Oracle 23ai now support this for robust, re-runnable DDL scripts. The syntax is virtually identical.
    </li>
    <li>
        <strong>Direct Joins for DML:</strong> This is a major point of convergence. PostgreSQL's <code>UPDATE ... FROM ...</code> and <code>DELETE ... USING ...</code> syntax is famously clear and powerful. Oracle's new ability to include a <code>FROM</code> clause in <code>UPDATE</code> and <code>DELETE</code> achieves the same goal, though the exact syntax differs slightly. It's a massive improvement over older, more cumbersome Oracle methods.
    </li>
    <li>
        <strong><code>GROUP BY</code> Alias:</strong> Both platforms now offer this convenience, allowing for cleaner aggregate queries.
    </li>
    <li>
        <strong><code>RETURNING</code> Clause:</strong> You know this one well. PostgreSQL's <code>RETURNING</code> clause is a beloved feature for getting data back from DML. Oracle's <code>RETURNING INTO</code> is its PL/SQL counterpart, allowing you to capture those returned values directly into variables or collections within a PL/SQL block.
    </li>
    <li>
        <strong><code>SELECT</code> without <code>FROM</code>:</strong> In PostgreSQL, <code>SELECT 1 + 1;</code> just works. In Oracle, you historically needed <code>SELECT 1 + 1 FROM dual;</code>. With 23ai, Oracle now behaves like PostgreSQL in this regard, making simple calculations much cleaner. Why did the SQL query break up with the <code>DUAL</code> table? It said, <em>I just need some space, I don't always have to be <code>FROM</code> somewhere</em>"
    </li>
    <li>
        <strong><code>VALUES</code> Clause:</strong> PostgreSQL's <code>VALUES</code> list is a powerful tool for creating ad-hoc rowsets. Oracle's 23ai Table Value Constructor brings this same capability, allowing you to define inline tables for joins, inserts, or simple lookups.
    </li>
  </ul>
</div>

<h2 id="section4">Section 4: How to Use Them (Structures & Syntax)</h2>

<p>Here we detail the practical application and syntax for these modern SQL features in Oracle 23ai.</p>

<h3 id="s4_boolean">Using the <code>BOOLEAN</code> Type</h3>
<p>Declare it in a table and use it directly in a <code>WHERE</code> clause.</p>

```sql
-- In DDL
CREATE TABLE future.Tasks (
    taskId      NUMBER,
    description VARCHAR2(200),
    isUrgent    BOOLEAN
);

-- In DML
INSERT INTO future.Tasks (taskId, description, isUrgent)
VALUES (1, 'Finalize report', TRUE);

-- In a Query
SELECT description
FROM future.Tasks
WHERE isUrgent; -- No need for 'isUrgent = ''Y''' or 'isUrgent = 1'
```


<h3 id="s4_if_exists">Using <code>IF [NOT] EXISTS</code></h3>
<p>Prefix your DDL commands with this conditional check to avoid errors in scripts.</p>

```sql
-- Safely drop a table
DROP TABLE IF EXISTS future.oldData;

-- Safely create a table
CREATE TABLE IF NOT EXISTS future.newLog (
    logId       NUMBER,
    logMessage  VARCHAR2(500)
);
```


<h3 id="s4_update_delete_from">Using Direct Joins</h3>
<p>Use a <code>FROM</code> clause to bring in other tables for filtering <code>UPDATE</code> and <code>DELETE</code> operations.</p>

```sql
-- UPDATE: Give a 10% raise to all employees in the 'Engineering' department.
UPDATE future.employees e
SET    e.salary = e.salary * 1.10
WHERE  e.departmentId = (SELECT d.departmentId FROM future.departments d WHERE d.departmentName = 'Engineering');

-- DELETE: Remove all employees located in 'New York'.
DELETE FROM future.employees e
WHERE  e.departmentId IN (
    SELECT d.departmentId
    FROM future.departments d
    WHERE d.locationCity = 'New York'
);
```


<h3 id="s4_group_by_alias">Using <code>GROUP BY</code> Alias</h3>
<p>Define an alias in the <code>SELECT</code> list and reuse it in the <code>GROUP BY</code> clause.</p>

```sql
SELECT
    SUBSTR(departmentName, 1, 5) AS deptPrefix,
    COUNT(*) AS employeeCount
FROM
    future.departments
GROUP BY
    deptPrefix; -- Uses the alias, not the full SUBSTR expression
```


<h3 id="s4_returning_into">Using <code>RETURNING INTO</code></h3>
<p>Capture affected data from DML directly into PL/SQL variables.</p>

```sql
-- Capture a single value
DECLARE
    vUpdatedSalary future.employees.salary%TYPE;
BEGIN
    UPDATE future.employees
    SET salary = salary + 5000
    WHERE employeeId = 101
    RETURNING salary INTO vUpdatedSalary;

    DBMS_OUTPUT.PUT_LINE('New salary is: ' || vUpdatedSalary);
END;
/

-- Capture multiple values with BULK COLLECT
DECLARE
    TYPE t_emp_ids IS TABLE OF NUMBER;
    v_updated_ids t_emp_ids;
BEGIN
    UPDATE future.employees
    SET salary = salary * 1.05
    WHERE departmentId = 10
    RETURNING employeeId BULK COLLECT INTO v_updated_ids;

    DBMS_OUTPUT.PUT_LINE(v_updated_ids.COUNT || ' employees received a raise.');
END;
/
```


<h3 id="s4_select_no_from">Using <code>SELECT</code> without <code>FROM</code></h3>
<p>Execute simple queries for calculations or function calls.</p>

```sql
SELECT (500 * 3) / 2 AS result;

SELECT SYSTIMESTAMP;
```


<h3 id="s4_values_constructor">Using <code>VALUES</code> Constructor</h3>
<p>Create an ad-hoc table directly in your query.</p>

```sql
-- Use as a standalone query
SELECT * FROM (VALUES (1, 'Apple'), (2, 'Banana'));

-- Use in a join to find employees in specific departments
SELECT e.firstName, e.lastName, d.deptName
FROM future.employees e
JOIN (VALUES (10, 'Sales'), (30, 'HR')) d(deptId, deptName)
  ON e.departmentId = d.deptId;
```


<h3 id="s4_interval_agg">Using <code>INTERVAL</code> Aggregations</h3>
<p>Apply <code>SUM</code> or <code>AVG</code> to columns of type <code>INTERVAL DAY TO SECOND</code> or <code>INTERVAL YEAR TO MONTH</code>.</p>

```sql
-- Find the average task duration for completed projects
SELECT
    AVG(endDate - startDate) AS averageDuration
FROM
    future.projectTasks
WHERE
    isCompleted = TRUE;
```


<h3 id="s4_time_bucket">Using <code>TIME_BUCKET</code></h3>
<p>Group time-series data into fixed intervals.</p>

```sql
-- Group tasks by week, using a fixed date as the origin
SELECT
    TIME_BUCKET(startDate, INTERVAL '7' DAY, DATE '2023-01-01') AS weekBucket,
    COUNT(*) as taskCount
FROM
    future.projectTasks
GROUP BY
    TIME_BUCKET(startDate, INTERVAL '7' DAY, DATE '2023-01-01')
ORDER BY
    weekBucket;
```


<h2 id="section5">Section 5: Why Use Them? (Advantages)</h2>
<div class="rhyme">
For code that's standard, safe, and fast, <br>
These new features are built to last.
</div>
<ul>
  <li>
    <strong>Clarity and Readability:</strong> Features like native <code>BOOLEAN</code>, <code>GROUP BY</code> Alias, and Direct Joins in DML make SQL code significantly more self-documenting and easier to understand. This reduces maintenance overhead and the potential for bugs.
  </li>
  <li>
    <strong>Robustness and Idempotency:</strong> <code>IF [NOT] EXISTS</code> is a game-changer for deployment scripts. It allows scripts to be re-run without causing errors, a core principle of modern DevOps and automation.
  </li>
  <li>
    <strong>Performance and Efficiency:</strong> The enhanced <code>RETURNING INTO</code> clause with <code>BULK COLLECT</code> avoids a second round-trip to the database to fetch data about what you just changed. The <code>VALUES</code> constructor avoids creating and dropping temporary tables for small lookups.
  </li>
  <li>
    <strong>Standards Compliance & Portability:</strong> Adopting standard features like <code>BOOLEAN</code>, <code>IF EXISTS</code>, and <code>SELECT without FROM</code> makes Oracle SQL more aligned with the ISO SQL standard and other databases like PostgreSQL, making skills and even code more portable.
  </li>
  <li>
    <strong>Simplified Logic:</strong> Functions like <code>TIME_BUCKET</code> and <code>INTERVAL</code> aggregations encapsulate complex logic into a single, clean function call, replacing what would otherwise be pages of convoluted date arithmetic and <code>CASE</code> statements.
  </li>
</ul>

<h2 id="section6">Section 6: Watch Out! (Pitfalls & Disadvantages)</h2>

<div class="caution">
  <h4>Caution: A Modern Tool has Modern Rules</h4>
  <p>While powerful, these new features come with their own considerations. Understanding them prevents unexpected behavior.</p>
  <ul>
    <li>
        <strong><code>BOOLEAN</code> Type:</strong> Older tools, drivers (pre-23ai JDBC), or legacy code may not understand the native <code>BOOLEAN</code> type and might require casting (e.g., <code>CAST(isCompleted AS NUMBER)</code>) for compatibility.
    </li>
    <li>
        <strong><code>GROUP BY</code> Alias:</strong> A common pitfall is attempting to use the column alias in the <code>WHERE</code> clause. This will fail because the <code>WHERE</code> clause is logically processed *before* the <code>SELECT</code> list (and thus before the alias is created). Filtering on aggregate results must still be done in the <code>HAVING</code> clause.
    </li>
    <li>
        <strong><code>RETURNING INTO</code>:</strong> When capturing data into a scalar variable (not a collection), your DML statement **must** affect exactly one row. If it affects zero rows, <code>NO_DATA_FOUND</code> is raised. If it affects more than one row, <code>TOO_MANY_ROWS</code> is raised. Always use <code>BULK COLLECT INTO</code> when multiple rows could be affected.
    </li>
    <li>
        <strong><code>IF EXISTS</code>:</strong> This clause can mask problems. For example, <code>DROP TABLE IF EXISTS myApp.importantConfig</code> will run silently if <code>myApp.importantConfig</code> doesn't exist, which might be a critical error in your deployment logic. It suppresses the error, but doesn't fix the underlying problem of a missing object. Use it for idempotency, not to hide configuration errors.
    </li>
  </ul>
</div>

<h2 id="conclusion">Conclusion & Next Steps</h2>
<p>
The innovations in Oracle 23ai represent a significant leap forward in developer productivity and SQL standards alignment. By mastering the native <code>BOOLEAN</code> type, simplifying DML with direct joins, and leveraging powerful new functions like <code>TIME_BUCKET</code> and the <code>VALUES</code> constructor, you can write code that is not only more efficient but also dramatically more readable and maintainable. These tools bridge the gap from other systems and empower you to build sophisticated, robust applications with cleaner, more modern Oracle SQL.
</p>
<p>
With these foundations set, you are now prepared to explore more of Oracle's rich feature set. The next step in your journey will be to dive into **Date Functions**, where you'll see how Oracle handles time with precision and power.
</p>

</div>

<div class="footnotes">
<hr>
<ol>
<li id="fn1_1">
<p><a href="/books/oracle-database-23ai-new-features-guide/03_Application_Development.pdf"title="Oracle Database 23ai New Features Guide">Oracle Database 23ai New Features Guide, <em>SQL BOOLEAN Data Type"</a>. This section introduces the native, ISO SQL standard-compliant boolean type. <a href="#fnref1_1"title="Jump back to footnote 1 in the text">↩</a></p>
</li>
<li id="fn1_2">
<p><a href="/books/oracle-database-23ai-new-features-guide/03_Application_Development.pdf"title="Oracle Database 23ai New Features Guide">Oracle Database 23ai New Features Guide, <em>IF [NOT] EXISTS Syntax Support"</a>. Describes the conditional DDL modifiers for objects. <a href="#fnref1_2"title="Jump back to footnote 2 in the text">↩</a></p>
</li>
<li id="fn1_3">
<p><a href="/books/oracle-database-23ai-new-features-guide/03_Application_Development.pdf"title="Oracle Database 23ai New Features Guide">Oracle Database 23ai New Features Guide, <em>Direct Joins for UPDATE and DELETE Statements"</a>. Explains the use of the FROM clause in DML. <a href="#fnref1_3"title="Jump back to footnote 3 in the text">↩</a></p>
</li>
<li id="fn1_4">
<p><a href="/books/sql-language-reference/11_ch09_sql-queries-and-subqueries.pdf"title="Oracle Database SQL Language Reference, 23ai">SQL Language Reference, 23ai, Chapter 9: SQL Queries and Subqueries</a>. While the <code>GROUP BY</code> alias is a new feature, this chapter covers the fundamentals of grouping. The new functionality is also detailed in the 23ai New Features guide. <a href="#fnref1_4"title="Jump back to footnote 4 in the text">↩</a></p>
</li>
<li id="fn1_5">
<p><a href="/books/sql-language-reference/15_ch13_sql-statements-commit-to-create-json-relational-duality-view.pdf"title="Oracle Database SQL Language Reference, 23ai">SQL Language Reference, 23ai, Chapter 13: <em>SQL UPDATE RETURN Clause Enhancements"</a>. Details the enhanced functionality of the RETURNING clause for various DML statements. <a href="#fnref1_5"title="Jump back to footnote 5 in the text">↩</a></p>
</li>
<li id="fn1_6">
<p><a href="/books/oracle-database-23ai-new-features-guide/03_Application_Development.pdf"title="Oracle Database 23ai New Features Guide">Oracle Database 23ai New Features Guide, <em>SELECT Without FROM Clause"</a>. Describes expression-only queries without needing the DUAL table. <a href="#fnref1_6"title="Jump back to footnote 6 in the text">↩</a></p>
</li>
<li id="fn1_7">
<p><a href="/books/oracle-database-23ai-new-features-guide/03_Application_Development.pdf"title="Oracle Database 23ai New Features Guide">Oracle Database 23ai New Features Guide, <em>Table Value Constructor"</a>. Explains the use of the VALUES clause to create inline rowsets. <a href="#fnref1_7"title="Jump back to footnote 7 in the text">↩</a></p>
</li>
<li id="fn1_8">
<p><a href="/books/oracle-database-23ai-new-features-guide/03_Application_Development.pdf"title="Oracle Database 23ai New Features Guide">Oracle Database 23ai New Features Guide, <em>Aggregation over INTERVAL Data Types"</a>. Details the use of SUM and AVG on interval types. <a href="#fnref1_8"title="Jump back to footnote 8 in the text">↩</a></p>
</li>
<li id="fn1_9">
<p><a href="/books/sql-language-reference/09_ch07_functions.pdf"title="Oracle Database SQL Language Reference, 23ai">SQL Language Reference, 23ai, Chapter 7: Functions, <em>TIME_BUCKET (datetime)"</a>. This provides the full syntax and semantics for the time bucketing function. <a href="#fnref1_9"title="Jump back to footnote 9 in the text">↩</a></p>
</li>
</ol>
</div>

</body>