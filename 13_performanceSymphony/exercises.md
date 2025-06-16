<head>
<link rel="stylesheet" href="../styles/lecture.css">
<link rel="stylesheet" href="../styles/exercises.css">
</head>
<body>
<div class="container">

<h1>Study Chunk 13: The Performance Symphony</h1>

<h2>Introduction & Learning Objectives</h2>

<p>Welcome to a pivotal module in your transition to Oracle. While writing functionally correct SQL is the first step, writing <strong>performant SQL</strong> is what distinguishes a proficient developer in an enterprise environment. This set of exercises is designed to build your intuition and practical skills in Oracle query optimization. You will move beyond simply getting the right answer to getting it efficiently.</p>

<p>For those coming from PostgreSQL, many core concepts like SARGable predicates and the purpose of joins will be familiar. Here, we will solidify that knowledge within the Oracle ecosystem, focusing on Oracle-specific syntax, tools, and the behavior of its powerful Cost-Based Optimizer (CBO). You will also get hands-on experience with transformative Oracle Database 23ai features that automate performance tuning and diagnostics.</p>

<h5>Upon completion of these exercises, you will be able to:</h5>
<ul>
<li>Write SARGable predicates in Oracle to ensure indexes are used effectively.</li>
<li>Understand the critical role of optimizer statistics and use the <code>DBMS_STATS</code> package to manage them.</li>
<li>Use optimizer hints cautiously to test performance hypotheses without hard-coding them into production applications.</li>
<li>Leverage the new Oracle 23ai <strong>SQL Analysis Report</strong> to automatically diagnose common structural and performance issues in your queries.</li>
<li>Grasp the philosophy behind <strong>Real-Time SQL Plan Management</strong> and how it provides a robust defense against performance regressions.</li>
</ul>

<div class="postgresql-bridge">
<p><strong>Bridging from PostgreSQL:</strong> Your knowledge of PostgreSQL's <code>EXPLAIN</code> is a great foundation. In this module, you'll learn Oracle's equivalent, <code>DBMS_XPLAN</code>, and discover how its CBO uses statistics. Concepts like SARGability are universal, but you'll practice them with Oracle's data types and functions. We'll contrast the reactive nature of manual tuning with Oracle's increasingly proactive, automated performance features.</p>
</div>

<h2>Prerequisites & Setup</h2>

<p>Before beginning, please ensure you have a solid understanding of the concepts from the preceding chunks of this course, especially:</p>
<ul>
<li>Oracle-specific data types (<code>DATE</code>, <code>NUMBER</code>, <code>VARCHAR2</code>).</li>
<li>Basic DML (<code>SELECT</code>, <code>INSERT</code>, <code>UPDATE</code>, <code>DELETE</code>) and Transaction Control.</li>
<li>Hierarchical Queries (<code>CONNECT BY</code>), as they often present unique tuning challenges.</li>
</ul>

<h4>Dataset Guidance</h4>
<p>All exercises in this module will be performed within a dedicated schema named <code>performanceSymphony</code>. This schema is designed to simulate real-world data distributions, including skewed data, which is essential for understanding optimizer behavior.</p>
<ol>
<li><strong>Connect as a privileged user</strong> (like <code>SYS</code> or <code>SYSTEM</code>) to create the practice user.</li>
<li>Execute the user creation script below.</li>
<li><strong>Connect as the new <code>performanceSymphony</code> user.</strong></li>
<li>Execute the subsequent <code>CREATE TABLE</code> and <code>INSERT</code> statements to build the necessary dataset for the exercises.</li>
</ol>

<p>It is crucial that you set up this dataset correctly, as the exercises are crafted to demonstrate specific performance characteristics based on this data.</p>

<h2>Exercises</h2>

<div class="exercise-section">
<h3>Dataset: The `performanceSymphony` Schema</h3>
<pre><code>
-- Run this part as SYS or a user with DBA privileges
CREATE USER performanceSymphony IDENTIFIED BY YourPassword;
GRANT CONNECT, RESOURCE, DBA TO performanceSymphony;
ALTER USER performanceSymphony QUOTA UNLIMITED ON USERS;

-- Connect as the performanceSymphony user to create the objects
-- conn performanceSymphony/YourPassword

CREATE TABLE employees (
employeeId      NUMBER(6) NOT NULL,
firstName       VARCHAR2(20),
lastName        VARCHAR2(25) NOT NULL,
email           VARCHAR2(25) NOT NULL,
jobId           VARCHAR2(10) NOT NULL,
salary          NUMBER(8,2),
managerId       NUMBER(6),
departmentId    NUMBER(4),
status          VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
hireDate        DATE NOT NULL
);

CREATE TABLE departments (
departmentId    NUMBER(4) NOT NULL,
departmentName  VARCHAR2(30) NOT NULL,
locationId      NUMBER(4)
);

CREATE TABLE jobHistory (
employeeId      NUMBER(6) NOT NULL,
startDate       DATE NOT NULL,
endDate         DATE NOT NULL,
jobId           VARCHAR2(10) NOT NULL,
departmentId    NUMBER(4)
);

-- Populate with data to illustrate performance concepts

-- Departments Table
INSERT INTO departments VALUES (10, 'Administration', 1700);
INSERT INTO departments VALUES (20, 'Marketing', 1800);
INSERT INTO departments VALUES (30, 'Purchasing', 1700);
INSERT INTO departments VALUES (40, 'Human Resources', 2400);
INSERT INTO departments VALUES (50, 'Shipping', 1500);
INSERT INTO departments VALUES (60, 'IT', 1400);
INSERT INTO departments VALUES (70, 'Public Relations', 1700);
INSERT INTO departments VALUES (80, 'Sales', 2500);
INSERT INTO departments VALUES (90, 'Executive', 1700);
INSERT INTO departments VALUES (100, 'Finance', 1700);
INSERT INTO departments VALUES (110, 'Accounting', 1700);
INSERT INTO departments VALUES (120, 'Treasury', 1700);
INSERT INTO departments VALUES (130, 'Corporate Tax', 1700);
INSERT INTO departments VALUES (140, 'Control And Credit', 1700);
INSERT INTO departments VALUES (150, 'Shareholder Services', 1700);
INSERT INTO departments VALUES (160, 'Benefits', 1700);
INSERT INTO departments VALUES (170, 'Manufacturing', 1700);
INSERT INTO departments VALUES (180, 'Construction', 1700);
INSERT INTO departments VALUES (190, 'Contracting', 1700);
INSERT INTO departments VALUES (200, 'Operations', 1700);
INSERT INTO departments VALUES (210, 'IT Support', 1700);
INSERT INTO departments VALUES (220, 'NOC', 1700);
INSERT INTO departments VALUES (230, 'IT Helpdesk', 1700);
INSERT INTO departments VALUES (240, 'Government Sales', 1700);
INSERT INTO departments VALUES (250, 'Retail Sales', 1700);
INSERT INTO departments VALUES (260, 'Recruiting', 1700);
INSERT INTO departments VALUES (270, 'Payroll', 1700);

-- Employees Table
-- Skewed data: a large number of employees are 'SA_REP'
BEGIN
FOR i IN 1..2000 LOOP
INSERT INTO employees (employeeId, firstName, lastName, email, jobId, salary, departmentId, status, hireDate)
VALUES (i, 'John'||i, 'Doe'||i, 'JDOE'||i, 'SA_REP', 6000 + (10*i), 80, 'ACTIVE', TO_DATE('2022-01-01', 'YYYY-MM-DD') + i);
END LOOP;
-- Add a few non-sales reps for variety and index testing
INSERT INTO employees VALUES (2001, 'Jane', 'Smith', 'JSMITH', 'IT_PROG', 9000, 60, 'ACTIVE', TO_DATE('2021-05-15', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (2002, 'Peter', 'Jones', 'PJONES', 'IT_PROG', 8500, 60, 'ACTIVE', TO_DATE('2020-03-20', 'YYYY-MM-DD'));
INSERT INTO employees VALUES (2003, 'Mary', 'Jane', 'MJANE', 'MK_MAN', 14000, 20, 'ACTIVE', TO_DATE('2019-11-10', 'YYYY-MM-DD'));
-- Add an entry with a function-unfriendly format
INSERT INTO employees VALUES (2004, 'Manager', 'Case', 'MCASE', 'SA_MAN', 15000, 80, 'active', TO_DATE('2018-01-01', 'YYYY-MM-DD'));
END;
/

COMMIT;
</code></pre>
</div>

<div class="exercise-section">
<h3>1. Meanings, Values, Relations, and Advantages</h3>

<h4>Exercise 1.1: The Power of SARGable Predicates</h4>
<p class="problem-label">Problem:</p>
<p>Your PostgreSQL experience has taught you that functions on indexed columns can hinder performance. Oracle behaves similarly.</p>
<ol>
    <li>Write a query to find all employees hired in the year 2022. Use the <code>TO_CHAR</code> function on the <code>hireDate</code> column in your <code>WHERE</code> clause.</li>
    <li>Generate the execution plan for this query using <code>DBMS_XPLAN</code>. Observe the access path.</li>
    <li>Rewrite the query to be SARGable by using a date range with the <code>BETWEEN</code> operator or <code>&gt;=</code> and <code>&lt;</code> operators, avoiding any function on the <code>hireDate</code> column.</li>
    <li>Generate the execution plan for the SARGable query and compare it to the first plan. Note the difference in the access path and cost.</li>
</ol>
<div class="oracle-specific">
    <p><strong>Focus:</strong> This exercise reinforces a universal SQL tuning principle within the Oracle context, contrasting an inefficient function-based predicate with an efficient, index-friendly range scan. Read more about performance design in the <a href="../books/database-performance-tuning-guide/ch02_2-designing-and-developing-for-performance.pdf">Database Performance Tuning Guide, Chapter 2</a>.</p>
</div>

<h4>Exercise 1.2: The Importance of Table Statistics</h4>
<p class="problem-label">Problem:</p>
<p>Oracle's Cost-Based Optimizer (CBO) relies entirely on statistics to make intelligent decisions. Without them, its choices can be suboptimal.</p>
<ol>
    <li>Create a new table <code>productSales</code> and populate it with a significant number of rows. Do <strong>not</strong> gather statistics yet. Create an index on the <code>productId</code>.</li>
    <li>Write a query to find sales for a single, specific <code>productId</code>.</li>
    <li>Generate the <code>EXPLAIN PLAN</code>. Observe the optimizer's estimated number of rows (<code>Rows</code> column) and the access path chosen.</li>
    <li>Now, gather statistics for the table using <code>DBMS_STATS.GATHER_TABLE_STATS</code>.</li>
    <li>Generate the <code>EXPLAIN PLAN</code> for the <em>exact same query</em> again. Compare the new plan's cardinality estimate and access path to the previous one.</li>
</ol>
<div class="oracle-specific">
    <p><strong>Focus:</strong> This exercise demonstrates the fundamental value of the <code>DBMS_STATS</code> package. It shows how providing the CBO with accurate data distribution information is the most direct way to get efficient query plans. For a deep dive into statistics, see the <a href="../books/sql-tuning-guide/ch01_10-optimizer-statistics-concepts.pdf">SQL Tuning Guide, Chapter 10</a>.</p>
</div>

<h4>Exercise 1.3: Diagnosing with the 23ai SQL Analysis Report</h4>
<p class="problem-label">Problem:</p>
<p>You have been given a query written by a junior developer that is performing poorly. The query is intended to join <code>employees</code> and <code>departments</code> but has a logical flaw. Use the new SQL Analysis Report feature to get an automatic diagnosis.</p>
<ol>
    <li>Execute the following flawed query, which unintentionally creates a Cartesian product.</li>
    <li>Use <code>DBMS_XPLAN.DISPLAY_CURSOR</code> to view the execution plan and the SQL Analysis Report that Oracle generates for the last executed statement.</li>
    <li>Interpret the report's findings and explain its recommendation.</li>
</ol>
<pre><code>
-- The flawed query
SELECT e.lastName, d.departmentName
FROM employees e, departments d
WHERE e.departmentId = 90; -- Missing join condition!
</code></pre>
<div class="oracle-specific">
    <p><strong>Focus:</strong> This exercise introduces a powerful <strong>Oracle 23ai feature</strong>. The SQL Analysis Report automates the diagnosis of common SQL anti-patterns, providing clear, actionable feedback directly in the plan output. This is a significant time-saver for both new and experienced developers. Learn more in the <a href="../books/sql-tuning-guide/ch01_19-influencing-the-optimizer.pdf">SQL Tuning Guide, Chapter 19</a> and the <a href="../books/oracle-database-23ai-new-features-guide/10_OLTP_and_Core_Database.pdf">New Features Guide</a>.</p>
</div>
</div>

<div class="exercise-section">
<h3>2. Disadvantages and Pitfalls</h3>
<h4>Exercise 2.1: The Pitfall of Stale Statistics</h4>
<p class="problem-label">Problem:</p>
<p>An application's performance has suddenly degraded. The query in question retrieves "ACTIVE" employees with a high salary. Initially, the table had very few such employees, but after a large data load, the number has increased dramatically. The statistics have not been updated.</p>
<ol>
    <li>Delete the existing <code>employees</code> data. Insert a small, initial set of data where only 2 employees have a salary > 10000.</li>
    <li>Gather statistics on this small table.</li>
    <li>Now, simulate a large data load by inserting 50,000 new employees, all with salaries > 10000. Do <strong>not</strong> regather statistics.</li>
    <li>Run a query to select all employees with <code>salary > 10000</code>.</li>
    <li>Examine the execution plan. Explain why the optimizer chose this plan and why it is now a major performance pitfall.</li>
</ol>
<div class="caution">
    <p>This exercise illustrates one of the most common causes of sudden performance degradation in real-world systems. Relying on outdated information leads the optimizer to make poor, costly decisions.</p>
</div>
</div>

<div class="exercise-section">
<h3>3. Contrasting with Inefficient Common Solutions</h3>
<h4>Exercise 3.1: Forcing a Plan with Hints vs. Robust Plan Management</h4>
<p class="problem-label">Problem:</p>
<p>In the previous exercise (2.1), you identified that a <code>TABLE ACCESS FULL</code> would be better due to the stale statistics. A common, but often short-sighted, reaction is to force the better plan using a hint.</p>
<ol>
    <li>Using the state from the end of exercise 2.1 (large table, stale stats), modify the query to use the <code>/*+ FULL(table_alias) */</code> hint to force a full table scan.</li>
    <li>Examine the execution plan to confirm the hint worked.</li>
    <li>Now, <code>ROLLBACK</code> or delete the large data load. The table is small again.</li>
    <li>Execute the <em>hinted</em> query again on the small table.</li>
    <li>Explain why the hinted query is now the "inefficient common solution" and what the Oracle-idiomatic, long-term solution is.</li>
</ol>
<div class="postgresql-bridge">
    <p><strong>Bridging from PostgreSQL:</strong> While PostgreSQL supports hints via extensions (like `pg_hint_plan`), they are not part of the core product and are often discouraged. Oracle has a long history with hints, but modern best practice, especially with 23ai, is to treat them as a temporary diagnostic tool, not a permanent fix. The idiomatic Oracle approach is to provide the optimizer with the best information (via statistics) and use features like SQL Plan Management to ensure stability.</p>
</div>
</div>

<div class="exercise-section">
<h3>4. Hardcore Combined Problem</h3>
<h4>Exercise 4.1: The Consultant's Challenge</h4>
<p class="problem-label">Problem:</p>
<p>You are a consultant tasked with optimizing a critical reporting query at an e-commerce company. The query identifies all IT and Sales managers and their direct/indirect reports. The query's performance is unacceptable.</p>
<p><strong>The problematic query:</strong></p>
<pre><code>
SELECT
LPAD(' ', (LEVEL-1)*2) || e.lastName as employee,
e.jobId,
d.departmentName
FROM
employees e,
departments d
WHERE e.departmentId = d.departmentId
START WITH e.jobId IN ('IT_PROG', 'SA_MAN')
CONNECT BY PRIOR e.employeeId = e.managerId;
</code></pre>
<p><strong>Your Task:</strong></p>
<ol>
    <li><strong>Initial Diagnosis:</strong> Gather initial statistics on the tables. Run the query and generate its execution plan using <code>DBMS_XPLAN.DISPLAY_CURSOR</code>. Analyze the plan, paying special attention to the join methods and any findings in the SQL Analysis Report. What are the immediate problems you can spot?</li>
    <li><strong>Hypothesize and Test:</strong> The query joins <code>employees</code> and <code>departments</code>. Looking at the plan from Step 1, you see a specific join method (e.g., HASH JOIN). Given the hierarchical nature, you suspect a NESTED LOOPS join might be better. Use the <code>/*+ USE_NL(e d) */</code> hint to test this theory. Generate the new plan. Is it better? Why might this not be a good permanent solution?</li>
    <li><strong>The Proper Fix:</strong> After a discussion with the business, you learn a massive new-hire event just concluded, primarily in the Sales department. Your statistics are now stale. Simulate this by updating the manager for 500 sales reps. Now, gather fresh statistics on the <code>employees</code> table. Re-run the original, un-hinted query and examine its new plan. How has the CBO's strategy changed now that it has accurate information?</li>
    <li><strong>Long-Term Stability with 23ai's Philosophy:</strong> To prevent future performance regressions for this critical query, use Oracle's SQL Plan Management. Execute the query with the good plan so it's in the cursor cache. Then, use <code>DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE</code> to create a SQL Plan Baseline, capturing this known-good plan. Explain how this provides a more robust, long-term solution than hard-coded hints.</li>
</ol>
</div>

<h2>Tips for Success & Learning</h2>
<ul>
<li><strong>Experiment:</strong> Don't just run the provided solutions. Change the predicates, alter the data, and see how the execution plans change. The goal is to build an intuition for how the Oracle optimizer thinks.</li>
<li><strong>Read the Plan:</strong> Focus on the <code>Operation</code>, <code>Rows</code> (cardinality), and <code>Cost</code> columns in the `EXPLAIN PLAN` output. Understanding the relationship between these is key.</li>
<li><strong>Consult the Docs:</strong> When you encounter a new operation or hint, use the provided links to the Oracle documentation. They are your most reliable source for in-depth information.</li>
</ul>

<h2>Conclusion & Next Steps</h2>
<p>Congratulations on working through these foundational performance tuning exercises. You have practiced how to write efficient SQL, how to diagnose problems using Oracle's powerful tools, and how to ensure long-term performance stability—skills that are essential in any consulting or development role.</p>
<p>You have seen how stale statistics can mislead the optimizer and how brittle hints can be. Most importantly, you've been introduced to the modern Oracle philosophy of automated tuning, exemplified by the <strong>SQL Analysis Report</strong> and the principles behind <strong>Real-Time SQL Plan Management</strong>.</p>
<p>In the next module, we will explore how Oracle interfaces with other enterprise technologies, putting your SQL and PL/SQL skills into a broader application context.</p>

</div>
</body>