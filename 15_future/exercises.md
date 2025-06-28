<head>
    <link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/exercises.css">
</head>
<body>

<div class="container">

<h1>Future of Oracle: SQL Innovations in 23ai</h1>

<h2>Introduction & Learning Objectives</h2>
<p>
    Welcome to the practical exercises for the new SQL features introduced in Oracle Database 23ai. This module is designed to bridge your existing expertise from PostgreSQL to the powerful, modern capabilities now available in Oracle SQL. By working through these problems, you will move from theoretical knowledge to hands-on proficiency, preparing you for real-world application development and consulting scenarios.
</p>
<ol>
    <li>Master the use of Oracle's native <strong><code>BOOLEAN</code></strong> data type for clearer, more standard logic.</li>
    <li>Simplify DML operations by leveraging <strong>direct <code>JOIN</code>s in <code>UPDATE</code> and <code>DELETE</code></strong> statements.</li>
    <li>Write more readable and maintainable aggregate queries using <strong>aliases in the <code>GROUP BY</code></strong> clause.</li>
    <li>Build robust, idempotent DDL scripts with the <strong><code>IF [NOT] EXISTS</code></strong> syntax.</li>
    <li>Perform direct and intuitive time-based math using <strong>aggregations on <code>INTERVAL</code></strong> data types.</li>
    <li>Efficiently capture data changes in a single operation with the enhanced <strong><code>RETURNING INTO</code></strong> clause.</li>
    <li>Streamline simple queries and calculations with the <strong><code>SELECT without FROM</code></strong> clause.</li>
    <li>Effortlessly group time-series data into discrete periods using the <strong><code>TIME_BUCKET</code></strong> function.</li>
    <li>Construct on-the-fly relational data sets within your queries using the <strong><code>Table Value Constructor</code> (<code>VALUES</code> clause)</strong>.</li>
</ol>
<div class="postgresql-bridge">
    <p><strong>PostgreSQL Bridge:</strong> Many of these features, like <code>IF EXISTS</code> and the <code>VALUES</code> clause, will feel familiar. The exercises here are designed to solidify your understanding of Oracle's specific syntax and demonstrate how these features integrate into the broader Oracle ecosystem, particularly in DML and PL/SQL contexts.</p>
</div>

<hr>

<h2>Prerequisites & Setup</h2>
<p>
    Before you begin, ensure you have a solid grasp of basic SQL concepts from your PostgreSQL experience, including <code>SELECT</code>, <code>UPDATE</code>, <code>DELETE</code>, standard <code>JOIN</code>s, and aggregate functions. It is also assumed you have completed the initial "Key Differences & Core Syntax" section of this course.
</p>

<h3>Dataset Guidance</h3>
<p>
    The following exercises are divided into logical groups, each with its own dedicated dataset. To complete the exercises, you must first create and populate the necessary tables in your Oracle DB 23ai environment.
</p>
<ol>
    <li>Connect to your Oracle database as the <code>future</code> user.</li>
    <li>Execute the <code>dataset.sql</code> script provided for this lecture.</li>
    <li>Verify that the data has been inserted correctly before proceeding with the problems.</li>
</ol>

<hr>

<h2>Exercises: New SQL Features in Oracle 23ai</h2>

<h3>Group 1: DDL and DML Enhancements</h3>
<p>This group focuses on features that simplify how you define schema objects and modify data, making your code more robust and efficient.</p>

<h4>(i) Meanings, Values, Relations, and Advantages</h4>
<h5>Problem 1: Conditional DDL with <code>IF EXISTS</code></h5>
<p>
    <span class="problem-label">Description:</span> Write a script that first attempts to drop a table named <code>future.tempProjects</code>. The script should not fail if the table doesn't exist. Then, write a statement to create the same <code>future.tempProjects</code> table (with columns <code>projectId NUMBER, projectName VARCHAR2(100)</code>), but only if it does not already exist.
</p>

<h5>Problem 2: Updating Records with a <code>FROM</code> Clause Join</h5>
<p>
    <span class="problem-label">Description:</span> The company has decided to give a 5% salary cut to all employees in the 'Sales' department who received a 'Below Average' performance review. Write a single <code>UPDATE</code> statement to apply this change.
</p>

<h5>Problem 3: Using the <code>RETURNING</code> Clause to Capture Changed Data</h5>
<p>
    <span class="problem-label">Description:</span> The HR department in 'New York' is being dissolved. All employees in that department must be deleted. As you delete them, you need to capture their <code>employeeId</code> and <code>lastName</code> into a log table (<code>future.archivedEmployees</code>). Use the <code>DELETE</code> statement with the <code>RETURNING</code> clause to accomplish this in a single step within a PL/SQL block.
</p>

<h4>(ii) Disadvantages and Pitfalls</h4>
<h5>Problem 1: <code>RETURNING INTO</code> with Multiple Rows</h5>
<p>
    <span class="problem-label">Description:</span> Write a PL/SQL anonymous block. Attempt to delete all employees from the 'Sales' department and use <code>RETURNING employeeId INTO ...</code> to capture the ID of the deleted employee into a single <code>NUMBER</code> variable. Execute the block and analyze the error. Then, provide the corrected solution that handles multiple returned rows.
</p>

<h4>(iii) Contrasting with Inefficient Common Solutions</h4>
<h5>Problem 1: Inefficient Update vs. <code>UPDATE FROM</code></h5>
<p>
    <span class="problem-label">Description:</span> A policy change requires that the salary of every employee in the 'Engineering' department be updated to match the salary of employee 'Charlie Williams' (ID 103).
</p>
<ol>
    <li>First, solve this using a less efficient, two-step PL/SQL approach: a <code>SELECT</code> to get Charlie's salary into a variable, followed by an <code>UPDATE</code>.</li>
    <li>Then, solve it using a more efficient, but correlated, <code>UPDATE</code> statement with a subquery in the <code>SET</code> clause.</li>
</ol>

<hr>

<h3>Group 2: Querying Conveniences</h3>
<p>This group covers new features that make writing common queries simpler, more intuitive, and more readable.</p>

<h4>(i) Meanings, Values, Relations, and Advantages</h4>
<h5>Problem 1: <code>GROUP BY</code> with an Alias</h5>
<p>
    <span class="problem-label">Description:</span> Write a query that calculates the total sales for each region. In your <code>SELECT</code> list, alias the <code>region</code> column as <code>salesRegion</code>. Use this alias <code>salesRegion</code> in the <code>GROUP BY</code> clause.
</p>

<h5>Problem 2: <code>SELECT</code> without a <code>FROM</code> Clause</h5>
<p>
    <span class="problem-label">Description:</span> Perform two simple calculations without referencing any table:
</p>
<ol>
    <li>Find the result of <code>SYSDATE + 7</code>.</li>
    <li>Calculate <code>100 * 1.05</code>.</li>
</ol>

<h5>Problem 3: Using the <code>VALUES</code> Clause to Construct an Inline Table</h5>
<p>
    <span class="problem-label">Description:</span> You have a new set of product price points to analyze. Without creating a permanent table, construct a two-column, three-row result set using the <code>VALUES</code> clause for the following data: ('Gadget', 50.00), ('Widget', 75.50), ('Sprocket', 25.00). Then, join this on-the-fly table with your <code>regionalSales</code> table to show the total sales for each of these products.
</p>

<h4>(ii) Disadvantages and Pitfalls</h4>
<h5>Problem 1: Logical Processing Order Pitfall</h5>
<p>
    <span class="problem-label">Description:</span> Try to filter the results of an aggregate query using the <code>GROUP BY</code> alias in the <code>WHERE</code> clause. For example, calculate total sales by region and only show regions where the aliased <code>totalSales</code> is greater than 3000. Why does this fail? How do you correctly filter on an aggregate result?
</p>

<hr>

<h3>Group 3: Advanced Data Types and Functions</h3>
<p>This group explores new data types and functions that enable more powerful and modern data modeling and analysis.</p>

<h4>(i) Meanings, Values, Relations, and Advantages</h4>
<h5>Problem 1: Using the Native <code>BOOLEAN</code> Data Type</h5>
<p>
    <span class="problem-label">Description:</span> Query the <code>future.projectTasks</code> table to show the names of all tasks that have been marked as completed.
</p>

<h5>Problem 2: Aggregating <code>INTERVAL</code> Data Types</h5>
<p>
    <span class="problem-label">Description:</span> For all completed tasks, calculate the total duration and the average duration. The duration of a task is the difference between its <code>endDate</code> and <code>startDate</code>.
</p>

<h5>Problem 3: Grouping Data into Time Buckets</h5>
<p>
    <span class="problem-label">Description:</span> You want to see how many tasks started in each 15-day period throughout the project's timeline. Use the <code>TIME_BUCKET</code> function to group the tasks. The "origin" of the bucketing should be the earliest task start date in the table. For more information on this function, see the <a href="/books/sql-language-reference/09_ch07_functions.pdf">Functions</a> chapter in the SQL Language Reference.
</p>

<h4>(iii) Contrasting with Inefficient Common Solutions</h4>
<h5>Problem 1: Pre-23ai <code>BOOLEAN</code> vs. Native <code>BOOLEAN</code></h5>
<p>
    <span class="problem-label">Description:</span> Imagine the <code>projectTasks</code> table was designed in Oracle 19c. The <code>isCompleted</code> column would likely be <code>isCompleted_legacy CHAR(1) CHECK (isCompleted_legacy IN ('Y', 'N'))</code>.
</p>
<ol>
    <li>Add this legacy column to the table and populate it.</li>
    <li>Write a query to find completed tasks using the legacy column.</li>
    <li>Compare the clarity and syntax with the native <code>BOOLEAN</code> query from the previous section.</li>
</ol>

<hr>

<h3>Hardcore Combined Problem</h3>
<p>This final problem requires you to integrate all the concepts from this module into a single, multi-step solution.</p>

<h4>Hardcore Problem Description</h4>
<p>
    You are performing a year-end data analysis and cleanup. The process involves several steps which must be executed within a single atomic transaction.
</p>
<ol>
    <li>
        <strong>Setup:</strong> Create an audit log table named <code>future.hcAuditLog</code> with a single <code>logData VARCHAR2(200)</code> column, but only if it doesn't already exist.
    </li>
    <li>
        <strong>Budget Analysis:</strong> Calculate a potential 5% budget increase for all projects. This requires a simple calculation without referencing any tables.
    </li>
    <li>
        <strong>Project Duration Analysis:</strong> Calculate the average duration of all <strong>completed</strong> projects. The result should be an <code>INTERVAL</code> type.
    </li>
    <li>
        <strong>Quarterly Activity:</strong> Group all projects by the quarter in which they started to see how many projects kick off each quarter. Use <code>TIME_BUCKET</code> and alias the bucket as <code>startQuarter</code>. Use this alias in your <code>GROUP BY</code> clause.
    </li>
    <li>
        <strong>Bonus Pool Creation:</strong> Create a temporary, inline view of employees and their base bonus using the <code>VALUES</code> clause. Include John Doe (ID 1, bonus 5000) and Jane Smith (ID 2, bonus 5500).
    </li>
    <li>
        <strong>Update with Join:</strong> The 'Innovation' department has secured extra funding. Update the salary of all active employees in this department by 10%.
    </li>
    <li>
        <strong>Log the Update:</strong> As you perform the update in step 6, use the <code>RETURNING</code> clause to capture a string for each updated row, formatted as 'Employee [ID] salary is now [NEW]', and insert these strings into your <code>hcAuditLog</code> table.
    </li>
    <li>
        <strong>Decommission:</strong> The 'Logistics' department is being dissolved. Delete all employees belonging to this department from the <code>hcEmployees</code> table.
    </li>
</ol>

<hr>

<h2>Tips for Success & Learning</h2>
<ul>
    <li>
        <strong>Experiment:</strong> Don't just solve the problem. Change the parameters. What happens if you use <code>IF EXISTS</code> instead of <code>IF NOT EXISTS</code>? What if the alias in <code>GROUP BY</code> has a space? Experimentation builds deeper understanding.
    </li>
    <li>
        <strong>Consult the Docs:</strong> When a function's behavior seems odd, refer to the official documentation. The Oracle 23ai New Features guide is your best friend for these new capabilities.
        <ul>
            <li><a href="/books/oracle-database-23ai-new-features-guide/03_Application_Development.pdf">Application Development in 23ai</a></li>
            <li><a href="/books/sql-language-reference/09_ch07_functions.pdf">Oracle SQL Functions</a></li>
            <li><a href="/books/get-started-oracle-database-development/get-started-guide_ch05_developing-stored-subprograms-packages.pdf">Developing PL/SQL Subprograms</a></li>
        </ul>
    </li>
    <li>
        <strong>Bridge the Gap:</strong> For each feature, ask yourself: "How would I have done this in PostgreSQL?" Recognizing the similarities (like <code>VALUES</code>) and the powerful differences (like <code>UPDATE FROM</code> and <code>RETURNING INTO</code> a collection) is key to a successful transition.
    </li>
</ul>

<h2>Conclusion & Next Steps</h2>
<p>
    Congratulations on tackling these modern SQL features. Mastering these capabilities not only makes your code cleaner and more efficient but also aligns you with the future direction of Oracle Database. You are now equipped with powerful tools for DDL management, DML operations, and advanced data analysis.
</p>
<p>
    With this foundation, you are ready to explore the next essential topic in your journey: <strong>Date Functions</strong>, where you'll dive deep into Oracle's robust set of tools for manipulating date and time.
</p>

</div>

</body>