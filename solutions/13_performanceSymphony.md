<head>
<link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/solutions.css">
</head>
<body>
<div class="container">

<h1>Oracle Performance Symphony: Solutions for Optimization Basics</h1>

<div class="oracle-specific">
    <p>This document contains the complete solutions and detailed explanations for the exercises in <strong>Oracle Performance & Optimization Basics</strong>. The goal here is not just to verify your answers, but to solidify your understanding of *why* a particular approach is optimal in Oracle.</p>
    <p>Even if your code produced the correct result, we strongly encourage you to review the explanations. They often highlight Oracle-specific nuances, performance trade-offs, and best practices that are essential for a consultant and developer transitioning from PostgreSQL.</p>
</div>

<h2>Reviewing the Dataset</h2>
<p>All exercises operate within the <code>performanceSymphony</code> schema. This schema was designed to simulate common performance scenarios, including:</p>
<ul>
    <li>
        The <code>employees</code> table, containing a large number of rows with skewed data (many sales reps) and varied data types.
    </li>
    <li>
        The <code>departments</code> table, a smaller lookup table perfect for practicing joins.
    </li>
    <li>
        The <code>productSales</code> table, a larger table used to demonstrate the impact of statistics on optimizer decisions.
    </li>
</ul>
<p>Understanding these data characteristics is key to predicting how the Oracle Cost-Based Optimizer (CBO) will behave.</p>

<h2>Solution Structure Overview</h2>
<p>Each solution is structured for maximum clarity:</p>
<ol>
    <li>The <strong>Problem</strong> statement is repeated for context.</li>
    <li>The <strong>Solution</strong> provides the optimal, idiomatic Oracle SQL or PL/SQL code.</li>
    <li>The <strong>Explanation</strong> breaks down the "why" behind the solution, detailing the Oracle concepts, contrasting with inefficient methods, and highlighting the advantages of the chosen approach.</li>
</ol>
<p>As you review, focus on the explanations. Compare the logic to your own attempt and ensure you grasp the core principles that lead to performant, robust Oracle code.</p>
<hr>

<!-- SOLUTIONS GO HERE -->

<h2>Solutions: Oracle Performance & Optimization Basics</h2>

<h3>1. Meanings, Values, Relations, and Advantages</h3>

<h4>Exercise 1.1: The Power of SARGable Predicates</h4>

<div class="postgresql-bridge">
    <p><strong>Problem:</strong> Your PostgreSQL experience has taught you that functions on indexed columns can hinder performance. Oracle behaves similarly.
    <ol>
        <li>Write a query to find all employees hired in the year 2022. Use the <code>TO_CHAR</code> function on the <code>hireDate</code> column in your <code>WHERE</code> clause.</li>
        <li>Generate the execution plan for this query using <code>DBMS_XPLAN</code>. Observe the access path.</li>
        <li>Rewrite the query to be SARGable by using a date range with the <code>BETWEEN</code> operator or <code>>=</code> and <code><</code> operators, avoiding any function on the <code>hireDate</code> column.</li>
        <li>Generate the execution plan for the SARGable query and compare it to the first plan. Note the difference in the access path and cost.</li>
    </ol>
    </p>
</div>

<h5>Solution 1.1</h5>
<ol>
<li>
<strong>Create an index:</strong> To observe the behavior, an index on the <code>hireDate</code> column is necessary.

```sql
CREATE INDEX idxEmpHireDate ON employees(hireDate);
```

</li>
<li>
<strong>Non-SARGable Query and Plan:</strong>

```sql
EXPLAIN PLAN FOR
SELECT employeeId, lastName, hireDate FROM employees
WHERE TO_CHAR(hireDate, 'YYYY') = '2022';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

<strong>Explanation:</strong> The execution plan for this query will almost certainly show a <code>TABLE ACCESS FULL</code>.
<ul>
    <li><strong>Why?</strong> When you apply the <code>TO_CHAR</code> function to the <code>hireDate</code> column, Oracle must first compute the result of that function for every single row in the table *before* it can compare it to the string '2022'.</li>
    <li><strong>The Consequence:</strong> The index on the raw <code>hireDate</code> values is now useless. The optimizer cannot use the index to find the rows because the search predicate is on a *transformed* value, not the indexed value itself.</li>
</ul>
<div class="rhyme">
    A function on the column, a sad, slow tale,<br>
    Makes your shiny new index utterly fail.
</div>
</li>
<li>
<strong>SARGable Query and Plan:</strong>

```sql
EXPLAIN PLAN FOR
SELECT employeeId, lastName, hireDate FROM employees
WHERE hireDate >= TO_DATE('2022-01-01', 'YYYY-MM-DD')
  AND hireDate <  TO_DATE('2023-01-01', 'YYYY-MM-DD');

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

<strong>Explanation:</strong> The execution plan for this rewritten query will show an <code>INDEX RANGE SCAN</code> on <code>idxEmpHireDate</code>.
<ul>
    <li><strong>Why?</strong> This predicate is <strong>SARGable</strong> (Search ARGument Able). The <code>WHERE</code> clause operates directly on the indexed <code>hireDate</code> column without transforming it.</li>
    <li><strong>The Advantage:</strong> The optimizer can now efficiently use the B-Tree structure of the index to immediately locate the starting point for January 1st, 2022, and scan until it reaches the end of the range. This avoids a full table scan, drastically reducing I/O and improving performance, especially on large tables. This principle is a direct and vital bridge from your PostgreSQL knowledge, applied here with Oracle's specific date functions.</li>
</ul>
</li>
</ol>
<p><strong>📚 Reference:</strong> Review <code>database-performance-tuning-guide/ch02_2-designing-and-developing-for-performance.pdf</code> for more on this core design principle.</p>

---

<h4>Exercise 1.2: The Importance of Table Statistics</h4>

<div class="oracle-specific">
    <p><strong>Problem:</strong> Oracle's Cost-Based Optimizer (CBO) relies entirely on statistics to make intelligent decisions. Without them, its choices can be suboptimal.
    <ol>
        <li>Create a new table <code>productSales</code> and populate it. Do *not* gather statistics yet. Create an index on the <code>productId</code>.</li>
        <li>Write a query to find sales for a single, specific <code>productId</code>.</li>
        <li>Generate the <code>EXPLAIN PLAN</code>. Observe the optimizer's estimated number of rows (<code>Rows</code> column).</li>
        <li>Now, gather statistics for the table using <code>DBMS_STATS.GATHER_TABLE_STATS</code>.</li>
        <li>Generate the <code>EXPLAIN PLAN</code> again and compare the new cardinality estimate to the previous one.</li>
    </ol>
    </p>
</div>

<h5>Solution 1.2</h5>
<ol>
<li>
<strong>Create and Populate Table:</strong>

```sql
CREATE TABLE productSales (
  saleId NUMBER GENERATED ALWAYS AS IDENTITY,
  productId NUMBER,
  saleAmount NUMBER(10,2)
);

-- Note: In a real scenario, connect as a user with privileges
-- to run this anonymous block.
BEGIN
  FOR i IN 1..50000 LOOP
    INSERT INTO productSales (productId, saleAmount) 
    VALUES (TRUNC(DBMS_RANDOM.VALUE(1, 500)), DBMS_RANDOM.VALUE(10, 1000));
  END LOOP;
  COMMIT;
END;
/
CREATE INDEX idxProdId ON productSales(productId);

```

</li>
<li>
<strong>Query and Plan *Without* Statistics:</strong>

```sql
EXPLAIN PLAN FOR
SELECT saleId FROM productSales WHERE productId = 101;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

<strong>Explanation:</strong> The <code>Rows</code> column in the plan will show a very small, default number. The CBO has no information about the data distribution, the number of distinct products, or the total row count. It is "flying blind" and must use built-in heuristics or dynamic sampling, which adds overhead. Its cost calculation is based on a guess, which could lead it to incorrectly choose a full table scan if it assumes the table is tiny.
</li>
<li>
<strong>Gather Statistics:</strong> The <code>DBMS_STATS</code> package is the standard, modern tool for this.

```sql
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(
    ownname => 'PERFORMANCESYMPHONY',
    tabname => 'PRODUCTSALES'
  );
END;
/

```

</li>
<li>
<strong>Query and Plan *With* Statistics:</strong>

```sql
EXPLAIN PLAN FOR
SELECT saleId FROM productSales WHERE productId = 101;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

<strong>Explanation:</strong> The plan is now radically different in one key aspect: the <code>Rows</code> estimate. The optimizer now knows there are 50,000 rows and approximately 500 distinct values for <code>productId</code>. It accurately estimates it will retrieve about 100 rows (50000 / 500). Based on this accurate cardinality, it can confidently and correctly choose the <code>INDEX RANGE SCAN</code> as the cheapest access path. This demonstrates the immense value of statistics: they are the foundational data that empowers the optimizer to make intelligent, cost-based decisions.
</li>
</ol>
<p><strong>📚 Reference:</strong> For a deep dive into what statistics are and why they matter, see the foundational chapter in <code>sql-tuning-guide/ch01_10-optimizer-statistics-concepts.pdf</code>.</p>

---

<h4>Exercise 1.3: Diagnosing with the 23ai SQL Analysis Report</h4>

<div class="oracle-specific">
    <p><strong>Problem:</strong> A junior developer has written a query that is performing poorly. Use the new Oracle 23ai SQL Analysis Report feature to get an automatic diagnosis of the structural flaw.
    <ol>
        <li>Execute the flawed query, which unintentionally creates a Cartesian product.</li>
        <li>Use <code>DBMS_XPLAN.DISPLAY_CURSOR</code> to view the execution plan and the associated analysis report.</li>
        <li>Interpret the report's findings.</li>
    </ol>
    </p>
</div>

<h5>Solution 1.3</h5>
<ol>
<li>
<strong>Execute Flawed Query:</strong> This query is missing the join condition `e.departmentId = d.departmentId`.

```sql
SELECT e.lastName, d.departmentName
FROM employees e, departments d
WHERE e.departmentId = 90;

```

</li>
<li>
<strong>View Plan and Analysis Report:</strong>

```sql
-- The FORMAT=>'ALL' is a good practice to get all available details,
-- including the new SQL Analysis Report section.
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT => 'ALL'));

```

</li>
<li>
<strong>Interpret the Report:</strong>
The output will have two key parts. First, the execution plan itself will show an operation like <code>MERGE JOIN CARTESIAN</code>, a major red flag indicating every row from one source is being joined to every row from the other. The row estimates will be huge.

Second, and most powerfully, a new section will appear at the bottom:
<pre>
--------------------------------------------------------------------
| SQL Analysis Report (identified by operation id / Query Block Name/Object Alias): |
--------------------------------------------------------------------
1 - SEL$1
  - The query block has 1 cartesian product which may be
    expensive. Consider adding join conditions or removing the
    disconnected tables or views.
</pre>
<strong>Advantage Explanation:</strong> This is a game-changer for developers. In previous versions, you had to manually inspect the plan, identify the Cartesian join, and deduce the cause. The Oracle 23ai **SQL Analysis Report** does this for you. It automatically diagnoses the structural flaw (a Cartesian product in the <code>SEL$1</code> query block) and provides a clear, actionable recommendation: "Consider adding join conditions". This feature significantly reduces the time to resolution for common but critical SQL errors.
</li>
</ol>
<p><strong>📚 Reference:</strong> The SQL Analysis Report is detailed in the `sql-tuning-guide/ch01_19-influencing-the-optimizer.pdf` and highlighted as a key enhancement in the `oracle-database-23ai-new-features-guide/10_OLTP_and_Core_Database.pdf`.</p>

---

<h3>2. Disadvantages and Pitfalls</h3>

<h4>Exercise 2.1: The Pitfall of Stale Statistics</h4>

<div class="caution">
    <p><strong>Problem:</strong> An application's performance has suddenly degraded. The query in question retrieves "ACTIVE" employees with a high salary. Initially, the table had very few such employees, but after a large data load, the number has increased dramatically. The statistics have not been updated.
    <ol>
        <li>Re-initialize the `employees` table with a small set of data where only 2 employees have a salary > 10000 and gather statistics.</li>
        <li>Simulate a large data load by inserting 50,000 new employees, all with high salaries. Do <strong>not</strong> regather statistics.</li>
        <li>Run a query to select all employees with `salary > 10000` and examine its very inefficient execution plan.</li>
        <li>Explain the pitfall.</li>
    </ol>
    </p>
</div>

<h5>Solution 2.1</h5>
<ol>
<li>
<strong>Initial State and Stats:</strong>

```sql
TRUNCATE TABLE employees;
INSERT INTO employees VALUES (1, 'High', 'Earner1', 'HE1', 'VP', 20000, 90, 'ACTIVE', SYSDATE);
INSERT INTO employees VALUES (2, 'High', 'Earner2', 'HE2', 'VP', 21000, 90, 'ACTIVE', SYSDATE);
INSERT INTO employees VALUES (3, 'Low', 'Earner1', 'LE1', 'CLERK', 3000, 50, 'ACTIVE', SYSDATE);
COMMIT;

CREATE INDEX idxEmpSalary ON employees(salary);

-- Gather stats on the small, skewed table
EXEC DBMS_STATS.GATHER_TABLE_STATS('PERFORMANCESYMPHONY', 'EMPLOYEES');

```

</li>
<li>
<strong>Simulate Large Data Load:</strong>

```sql
BEGIN
  FOR i IN 1..50000 LOOP
    INSERT INTO employees VALUES (100+i, 'New', 'Hire'||i, 'NH'||i, 'SA_REP', 11000, 80, 'ACTIVE', SYSDATE);
  END LOOP;
  COMMIT;
END;
/

```

</li>
<li>
<strong>Query with Stale Statistics:</strong>

```sql
EXPLAIN PLAN FOR
SELECT employeeId, lastName FROM employees WHERE salary > 10000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

```

</li>
<li>
<strong>Pitfall Explanation:</strong> The execution plan will show an <code>INDEX RANGE SCAN</code> on `idxEmpSalary` followed by a <code>TABLE ACCESS BY INDEX ROWID</code>. The key problem is in the <code>Rows</code> column of the plan, which will estimate a very small number (e.g., 2), based on the old statistics.
<div class="rhyme">
    The stats are old, the plan's a mess,<br>
    The CBO is lost, I must confess.<br>
    It thinks the rows are very few,<br>
    An index scan, it will pursue.<br>
    But thousands of rows it has to find,<br>
    Leaving performance far behind.
</div>
The pitfall is that **the optimizer's plan is only as good as the statistics it's given**. Based on the stale data, it made a perfectly logical choice to use the index. However, the underlying data reality has changed dramatically. Accessing over 50,000 rows one-by-one via an index is a classic performance killer. A `TABLE ACCESS FULL` would now be vastly more efficient because it would use multi-block reads. This scenario demonstrates the critical danger of not maintaining statistics in a database with volatile data.
</li>
</ol>

---

<h3>3. Contrasting with Inefficient Common Solutions</h3>

<h4>Exercise 3.1: Forcing a Plan with Hints vs. Robust Plan Management</h4>

<div class="postgresql-bridge">
    <p><strong>Problem:</strong> In the previous exercise, you identified that a `TABLE ACCESS FULL` would be better. A common, but often short-sighted, reaction from developers under pressure is to force the better plan using a hint.
    <ol>
        <li>Using the state from the end of exercise 2.1 (large table, stale stats), use the <code>/*+ FULL(e) */</code> hint to force a full table scan. Confirm the plan changes.</li>
        <li>Now, revert the data to its small, original state.</li>
        <li>Execute the <strong>hinted</strong> query again on the small table.</li>
        <li>Explain why the hint is now an inefficient "fix" and describe the superior, idiomatic Oracle approach.</li>
    </ol>
    </p>
</div>

<h5>Solution 3.1</h5>
<ol>
<li>
<strong>Hinted Query on Large Table:</strong>

```sql
-- State: Large table, stale stats
EXPLAIN PLAN FOR
SELECT /*+ FULL(e) */ employeeId, lastName FROM employees e WHERE salary > 10000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

```

<strong>Explanation:</strong> The plan now shows a <code>TABLE ACCESS FULL</code>. The hint has successfully overridden the optimizer's cost-based decision, and for this specific data state, this plan is indeed faster. The immediate problem appears solved.
</li>
<li>
<strong>Revert Data:</strong>

```sql
DELETE FROM employees WHERE employeeId > 100;
COMMIT;

```

</li>
<li>
<strong>Hinted Query on Small Table:</strong>

```sql
EXPLAIN PLAN FOR
SELECT /*+ FULL(e) */ employeeId, lastName FROM employees e WHERE salary > 10000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

```

</li>
<li>
<strong>Contrast and Conclusion:</strong> The plan is *still* a <code>TABLE ACCESS FULL</code> because the hint forces it, but this is now the wrong choice. For retrieving just 2 rows from the table, an `INDEX RANGE SCAN` would be far more efficient.

The **inefficient common solution** is hard-coding hints in application code. It creates a "brittle" plan that is only optimal under a specific set of circumstances. When data volumes or statistics change, the hint can become a performance liability, requiring a code deployment to fix.

The **superior Oracle-idiomatic solution** is to manage the environment, not the code.
<ul>
    <li><strong>Primary Solution:</strong> Keep statistics up-to-date.
        <pre><code>EXEC DBMS_STATS.GATHER_TABLE_STATS('PERFORMANCESYMPHONY', 'EMPLOYEES');
```

        By simply running this after the data load, the CBO would have naturally switched to a `TABLE ACCESS FULL` on its own. When the data was reverted and stats gathered again, it would switch back to the `INDEX RANGE SCAN`.
    </li>
    <li><strong>Robust Solution (The 23ai Way):</strong> For truly critical queries prone to instability, use **SQL Plan Management**. Capturing a known-good plan as a baseline ensures that even if stats change, the database will not immediately switch to a potentially regressed plan without verification. This is the philosophy behind 23ai's **Real-Time SQL Plan Management**, which automates this protection, providing performance stability without brittle, hard-coded hints.</li>
</ul>
</li>
</ol>

---

<h3>4. Hardcore Combined Problem</h3>

<div class="oracle-specific">
    <p><strong>Problem:</strong> You are tasked with optimizing a critical hierarchical reporting query that is performing poorly after a large data load. You must diagnose the issue, test a fix, and implement a robust, long-term solution that prevents future regressions, leveraging Oracle 23ai concepts.</p>
</div>

<h5>Solution 4.1</h5>
<ol>
<li>
<strong>Initial Diagnosis:</strong>
<p>First, we establish a baseline. We ensure stats are current for the initial, smaller dataset.</p>

```sql
-- Initial State
TRUNCATE TABLE employees;
INSERT INTO employees VALUES (2001, 'Jane', 'Smith', 'JSMITH', 'IT_PROG', 9000, 60, 'ACTIVE', SYSDATE-100);
INSERT INTO employees VALUES (2003, 'Mary', 'Jane', 'MJANE', 'SA_MAN', 14000, 20, 'ACTIVE', SYSDATE-100);
INSERT INTO employees VALUES (2002, 'Peter', 'Jones', 'PJONES', 'IT_PROG', 8500, 60, 'ACTIVE', SYSDATE-90, 2001);
INSERT INTO employees VALUES (2004, 'Manager', 'Case', 'MCASE', 'SA_REP', 7000, 80, 'ACTIVE', SYSDATE-90, 2003);
COMMIT;
EXEC DBMS_STATS.GATHER_TABLE_STATS('PERFORMANCESYMPHONY', 'EMPLOYEES');
EXEC DBMS_STATS.GATHER_TABLE_STATS('PERFORMANCESYMPHONY', 'DEPARTMENTS');

```

<p>Now, we run the problematic query and check its plan.</p>

```sql
-- The Problematic Query
SELECT LPAD(' ', (LEVEL-1)*2) || e.lastName as employee, e.jobId, d.departmentName
FROM employees e, departments d
WHERE e.departmentId = d.departmentId
START WITH e.jobId IN ('IT_PROG', 'SA_MAN')
CONNECT BY PRIOR e.employeeId = e.managerId;

-- Check the plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALL'));

```

<strong>Analysis:</strong> For this small dataset, the plan will likely feature <code>NESTED LOOPS</code> and index access. The key is to note the cardinality estimates (`Rows` column). They will be very small. The plan is efficient for this data size.
</li>
<li>
<strong>Simulate Data Change and The Pitfall:</strong>
<p>Now, simulate the large data load that caused the performance regression. Crucially, we do **not** update the statistics.</p>

```sql
-- Simulate large data load under the existing managers
BEGIN
  FOR i IN 1..25000 LOOP
    INSERT INTO employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, status, hireDate)
    VALUES (3000+i, 'New', 'Rep'||i, 'NREP'||i, 'SA_REP', 5000, 2003, 80, 'ACTIVE', SYSDATE-10);
  END LOOP;
  COMMIT;
END;
/

```

<p>Now, re-run the *exact same query*.</p>

```sql
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALL'));

```

<strong>Analysis:</strong> The optimizer, still using the **stale statistics** from the small dataset, generates the *exact same execution plan* with <code>NESTED LOOPS</code>. The cardinality estimates are still tiny. This is the performance pitfall: the optimizer is trying to execute a plan designed for a few rows against tens of thousands, leading to a massive number of inefficient single-block reads.
</li>
<li>
<strong>The Proper Fix: Gathering Statistics:</strong>
<p>The first and most important step is to provide the optimizer with accurate information.</p>

```sql
EXEC DBMS_STATS.GATHER_TABLE_STATS('PERFORMANCESYMPHONY', 'EMPLOYEES');

```

<p>Now, let's see how the CBO adapts when we run the query a third time.</p>

```sql
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALL'));

```

<strong>Analysis:</strong> With fresh statistics, the CBO now sees the massive number of rows under the 'SA_MAN'. It will likely change the plan dramatically, perhaps switching from `NESTED LOOPS` to a `HASH JOIN` to process the larger dataset more efficiently. It has adapted correctly because it has the right information.
</li>
<li>
<strong>Long-Term Stability with SQL Plan Management (The 23ai Philosophy):</strong>
<p>We now have a good, cost-based plan. To protect this query from future regressions, we establish it as a baseline. This is a manual simulation of what Real-Time SQL Plan Management automates.</p>

```sql
-- Find the SQL_ID for our query
SELECT sql_id, child_number FROM v$sql 
WHERE sql_text LIKE 'SELECT LPAD%';
-- Assume the latest plan's sql_id is 'g80xfrd7a4b1c'

-- Load this known-good plan into a baseline
DECLARE
  l_plans PLS_INTEGER;
BEGIN
  l_plans := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(
    sql_id       => 'g80xfrd7a4b1c',
    plan_hash_value => NULL, -- Use NULL to capture all plans for the SQL ID
    fixed        => 'NO',
    enabled      => 'YES'
  );
END;
/

```

<strong>Conclusion:</strong> We have taken a poorly performing query, diagnosed the root cause (stale statistics), fixed it by providing the optimizer with accurate data, and finally, protected the resulting good plan using SQL Plan Management. This workflow embodies the principles of Oracle tuning. The 23ai **Real-Time SQL Plan Management** feature automates this last step, detecting plan changes, comparing performance against the baseline, and preventing the use of a regressed plan without any manual intervention, ensuring robust performance over time.
</li>
</ol>

<hr>

<h2>Key Takeaways & Best Practices</h2>

<ul>
    <li><strong>Trust, but Verify, the Optimizer:</strong> The Oracle CBO is incredibly powerful, but its decisions are only as good as the statistics it has. Your primary job is not to outsmart it, but to feed it accurate information.</li>
    <li><strong>Statistics are Paramount:</strong> Never underestimate the performance impact of stale or missing statistics. Use the <code>DBMS_STATS</code> package as your standard tool. Automated statistics gathering is on by default and is highly recommended.</li>
    <li><strong>Write SARGable Predicates:</strong> This is a universal database principle. Avoid applying functions to indexed columns in your <code>WHERE</code> clauses. Rewrite queries to use direct comparisons, ranges, or <code>LIKE</code> patterns that don't start with a wildcard.</li>
    <li><strong>Use Hints for Diagnosis, Not for Production:</strong> Hints are invaluable for testing a performance hypothesis ("what if the plan used a full scan?"). However, hard-coding them into application logic is brittle. A change in data can render a hint a performance bottleneck.</li>
    <li><strong>Leverage 23ai's Automation:</strong> Features like the **SQL Analysis Report** and **Real-Time SQL Plan Management** are designed to automate the most common and critical performance tuning tasks. Learn to use and interpret their output to drastically reduce your mean-time-to-resolution for performance problems.</li>
</ul>

<h2>Conclusion & Next Steps</h2>

<div class="postgresql-bridge">
<p>Congratulations on completing this foundational module in Oracle performance tuning! You have bridged your existing SQL knowledge from PostgreSQL to the Oracle ecosystem and learned the core principles that drive the Oracle optimizer. You now have the tools to diagnose inefficiencies, understand execution plans, and leverage Oracle's powerful statistics and plan management features.</p>
<p>You've seen how writing good SQL is the first step, and how feeding the optimizer good information is the second. With the new 23ai features, you've also had a glimpse into how Oracle is automating this process to ensure stable, predictable performance.</p>
</div>

<p>The journey continues. Your next step is to explore how Oracle interfaces with the wider world of enterprise technology, a critical skill for any consultant.</p>

<p>Prepare to dive into <strong>(Conceptual) Oracle & Interfacing Technologies</strong>, where we'll explore JDBC connectivity, XML processing, and Oracle's powerful Advanced Queuing system.</p>

</div>
</body>