<style>
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    color: #d4d4d4; /* --night-text-primary */
    background-color: #1e1e1e; /* --night-bg-primary */
    margin: 0;
    padding: 20px;
  }
  .container {
    max-width: 900px;
    margin: auto;
    background-color: #2d2d2d; /* --night-bg-secondary */
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 0 20px rgba(0,0,0,0.6); /* Darker shadow for depth */
  }
  h1, h2, h3, h4 { /* Added h4 for exercise titles */
    color: #569cd6; /* --night-heading-primary (VS Code-like blue) */
  }
  h1 {
    border-bottom: 2px solid #FF9900; /* --night-accent-primary (Orange accent) */
    padding-bottom: 10px;
    font-size: 2.5em;
    text-align: center;
  }
  h2 { /* For main solution section title */
    font-size: 2em;
    margin-top: 40px;
    border-bottom: 1px solid #FF9900; /* Accent border for Solutions H2 */
    padding-bottom: 10px;
    text-align: center;
  }
  h3 { /* For Exercise Block titles within solutions */
    font-size: 1.6em;
    color: #4ec9b0; /* --night-accent-secondary (Teal/cyan) */
    margin-top: 30px;
    border-bottom: 1px dashed #444;
    padding-bottom: 6px;
  }
  h4 { /* For individual exercise solution titles (e.g., Exercise 1.1.1 Solution) */
    font-size: 1.3em;
    color: #ce9178; /* A subtle brownish-orange for emphasis */
    margin-top: 25px;
    margin-bottom: 10px;
  }
  p, li {
    font-size: 1em;
    margin-bottom: 10px;
    color: #cccccc; /* --night-text-secondary */
  }
  ul {
    padding-left: 20px;
  }
  code {
    font-family: 'Consolas', 'Monaco', 'Andale Mono', 'Ubuntu Mono', monospace;
    background-color: #1a1a1a; /* --night-code-bg (Very dark) */
    padding: 3px 7px;
    border-radius: 4px;
    font-size: 0.95em;
    color: #d4d4d4; /* Light text for code */
    border: 1px solid #3a3a3a; /* Subtle border for inline code */
  }
  pre {
    background-color: #1a1a1a; /* --night-code-bg */
    padding: 15px;
    border-radius: 5px;
    overflow-x: auto;
    border: 1px solid #444444; /* --night-border-subtle */
    color: #d4d4d4; /* Ensure preformatted text is also light */
    margin-top: 5px;
    margin-bottom: 15px;
  }
  pre code {
    background-color: transparent;
    padding: 0;
    border-radius: 0;
    font-size: 0.9em;
    border: none; /* No border for code within pre */
  }
  .solution-explanation {
    background-color: #252526; /* Slightly different dark shade for explanations */
    padding: 10px 15px;
    margin-top: 5px;
    margin-bottom: 15px;
    border-left: 3px solid #4ec9b0; /* Teal accent for explanation boxes */
    border-radius: 4px;
    font-size: 0.95em;
  }
  .solution-explanation p {
      margin-bottom: 5px;
      color: #b0b0b0; /* Slightly lighter grey for explanation text */
  }
  .solution-explanation code { /* Inline code within explanations */
      background-color: #333;
      color: #dcdcdc;
  }
  .exercise-solution-block { /* Wrapper for each individual exercise solution */
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 1px solid #3a3a3a;
  }
  .exercise-solution-block:last-child {
      border-bottom: none;
  }

  .highlight-primary {
    color: #569cd6; /* Match primary heading color */
    font-weight: bold;
  }
  .highlight-secondary {
    color: #FF9900; /* Orange accent */
    font-weight: bold;
  }
  .emphasize {
    font-style: italic;
    font-weight: bold;
    color: #ce9178; /* A subtle brownish-orange for emphasis */
  }
  a {
    color: #60AFFF; /* Brighter blue for links */
    text-decoration: none;
  }
  a:hover {
    text-decoration: underline;
    color: #90CAF9; /* Lighter blue on hover */
  }
</style>

<div class="container">

## Solutions to Exercises

This section provides the solutions and explanations for all exercises presented in the previous section. It is highly recommended to attempt each exercise yourself before reviewing these solutions. *The path to mastery is paved with practice and your own query drafts, surely!*

---
### Solutions for Exercise Block 1: Date Functions *(Oracle Specifics & Practice)*

<div class="exercise-solution-block">
<h4>Solution for Exercise 1.1.1: Oracle Current Date/Time Functions and Conversions</h4>
<pre><code class="language-sql">
-- a.
SELECT SYSDATE FROM DUAL;
-- b.
SELECT CURRENT_DATE FROM DUAL;
-- c.
SELECT SYSTIMESTAMP FROM DUAL;
-- d.
SELECT CURRENT_TIMESTAMP FROM DUAL;
-- e.
SELECT TO_DATE('2020-01-15', 'YYYY-MM-DD') AS aliceHireDate FROM DUAL;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (e):</strong> <code>TO_DATE</code> is crucial in Oracle for explicitly converting strings to DATE types. Unlike PostgreSQL, which might automatically cast 'YYYY-MM-DD' strings to dates if the format is unambiguous, Oracle often requires explicit conversion with a format model. If the session's <code>NLS_DATE_FORMAT</code> matches the string, implicit conversion might work, but relying on this is poor practice as NLS settings can vary. Explicit <code>TO_DATE</code> ensures portability and avoids <code>NLS_DATE_FORMAT</code> dependency issues. The format model (<code>'YYYY-MM-DD'</code>) tells Oracle exactly how to parse the string. PostgreSQL's <code>TO_DATE</code> also uses format models.</p>
<p><strong>Advantage:</strong> Oracle's strictness here forces clarity and reduces ambiguity from implicit conversions based on session settings.</p>
</div>
<pre><code class="language-sql">
-- f.
SELECT TO_CHAR(hireDate, 'Day, DDth Month YYYY, HH24:MI:SS') AS formattedHireDate
FROM Employees
WHERE employeeId = 101;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (f):</strong> <code>TO_CHAR</code> converts dates (or numbers) to formatted strings. Oracle's date format models (e.g., <code>'Day'</code>, <code>'DDth'</code>, <code>'Month'</code>, <code>'YYYY'</code>, <code>'HH24:MI:SS'</code>) are powerful and specific. PostgreSQL's <code>TO_CHAR</code> is very similar. Oracle has some unique format elements like <code>'DDSPTH'</code> or <code>'DDTH'</code> for ordinal numbers with spelling. These models are essential for presenting dates in user-readable formats or specific interchange formats. The <code>DATE</code> type in Oracle *always* stores date and time (down to the second). PostgreSQL's <code>DATE</code> type only stores the date.</p>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 1.1.2: Oracle Date Arithmetic and Interval Functions</h4>
<pre><code class="language-sql">
-- a.
SELECT ADD_MONTHS(hireDate, 6) AS sixMonthsAfterHire
FROM Employees WHERE employeeId = 101;

-- b.
SELECT MONTHS_BETWEEN(
           (SELECT hireDate FROM Employees WHERE employeeId = 101), -- Alice (later hire date)
           (SELECT hireDate FROM Employees WHERE employeeId = 102)  -- Bob (earlier hire date)
       ) AS monthsDifferenceBobToAlice
FROM DUAL; -- Result will be positive if first date is later.

-- c.
SELECT LAST_DAY(hireDate) AS lastDayOfHireMonth
FROM Employees WHERE employeeId = 101;

-- d.
SELECT NEXT_DAY(hireDate, 'FRIDAY') AS nextFridayAfterHire
FROM Employees WHERE employeeId = 101;
-- Note: 'FRIDAY' interpretation depends on NLS_DATE_LANGUAGE.

-- e.
SELECT
    TRUNC(hireDate, 'YYYY') AS truncatedToYear, -- or 'YEAR'
    ROUND(hireDate, 'YYYY') AS roundedToYear    -- or 'YEAR'
FROM Employees WHERE employeeId = 101;

-- f.
SELECT hireDate + 10 AS tenDaysAfterHire
FROM Employees WHERE employeeId = 101;

-- g.
SELECT
    (SELECT hireDate FROM Employees WHERE employeeId = 102) -
    (SELECT hireDate FROM Employees WHERE employeeId = 101)
    AS dateDifferenceInDays
FROM DUAL; -- Result is negative as Bob (102) was hired before Alice (101).

-- h.
SELECT
    deadlineTimestamp,
    deadlineTimestamp + INTERVAL '3 05:30:00' DAY TO SECOND AS newDeadline
FROM Projects
WHERE projectId = 1;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (h):</strong> Oracle's INTERVAL types are <code>INTERVAL YEAR TO MONTH</code> and <code>INTERVAL DAY TO SECOND</code>. The syntax for <code>DAY TO SECOND</code> is <code>INTERVAL 'D HH24:MI:SS.FF' DAY(precision) TO SECOND(fractional_precision)</code>. PostgreSQL uses a more string-like syntax: <code>deadlineTimestamp + INTERVAL '3 days 5 hours 30 minutes'</code>. Oracle's syntax is more structured for intervals.
<strong>Advantage:</strong> Oracle's interval types are strongly typed and allow precise definitions.</p>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 1.2.1: Date Function Pitfalls</h4>
<div class="solution-explanation">
<p><strong>a. Inefficiency of TO_CHAR on indexed date column:</strong></p>
<p>The query <code>SELECT * FROM Employees WHERE TO_CHAR(hireDate, 'YYYY') = '2020';</code> is inefficient because applying <code>TO_CHAR</code> to <code>hireDate</code> prevents Oracle from using a standard B-tree index on <code>hireDate</code> directly unless a function-based index on <code>TO_CHAR(hireDate, 'YYYY')</code> exists. Oracle would likely perform a full table scan.</p>
<p><strong>Better Oracle-idiomatic way (SARGable):</strong></p>
</div>
<pre><code class="language-sql">
SELECT * FROM Employees
WHERE hireDate >= TO_DATE('2020-01-01', 'YYYY-MM-DD')
  AND hireDate < TO_DATE('2021-01-01', 'YYYY-MM-DD');
</code></pre>
<div class="solution-explanation">
<p><strong>b. Pitfall of <code>startDate + 365</code> for "one year later":</strong></p>
<p><code>startDate + 365</code> does not reliably calculate "one year later" because it doesn't account for leap years. <code>ADD_MONTHS(date, 12)</code> is better as it correctly calculates "one year later" by preserving the day of the month (or adjusting to the last day of the target month if needed).</p>

<p><strong>c. NLS_DATE_LANGUAGE impact on NEXT_DAY:</strong></p>
<p>The string 'MONDAY' in <code>NEXT_DAY(some_date, 'MONDAY')</code> is interpreted based on <code>NLS_DATE_LANGUAGE</code>. If this setting changes, the query might fail or return an unexpected day. To make it robust, one could use <code>TO_CHAR(known_monday_date, 'DAY', 'NLS_DATE_LANGUAGE=AMERICAN')</code> as the day string or calculate manually using <code>TO_CHAR(date, 'D')</code> with knowledge of <code>NLS_TERRITORY</code>.</p>

<p><strong>d. Oracle DATE type includes time:</strong></p>
<p><code>TO_DATE('2020-01-15', 'YYYY-MM-DD')</code> results in <code>2020-01-15 00:00:00</code>. A query <code>WHERE hireDate = TO_DATE('2020-01-15', 'YYYY-MM-DD')</code> might miss employees hired at other times on that day. </p>
<p><strong>Correct way for a whole day (range scan, generally better for indexed columns):</strong></p>
</div>
<pre><code class="language-sql">
SELECT * FROM Employees
WHERE hireDate >= TO_DATE('2020-01-15', 'YYYY-MM-DD')
  AND hireDate < TO_DATE('2020-01-16', 'YYYY-MM-DD');
</code></pre>
<div class="solution-explanation">
<p><strong>Or using TRUNC (can be less performant on standard index):</strong></p>
</div>
<pre><code class="language-sql">
SELECT * FROM Employees
WHERE TRUNC(hireDate) = TO_DATE('2020-01-15', 'YYYY-MM-DD');
</code></pre>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 1.3.1: Date Range Queries - Inefficient vs. Efficient</h4>
<p><strong>Inefficient Approach (Example using EXTRACT):</strong></p>
<pre><code class="language-sql">
SELECT projectName, startDate
FROM Projects
WHERE EXTRACT(YEAR FROM startDate) = 2023;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation of Inefficiency:</strong> Applying functions like <code>EXTRACT()</code> or <code>TO_CHAR()</code> to the <code>startDate</code> column in the <code>WHERE</code> clause prevents Oracle from using standard B-Tree indexes on <code>startDate</code> effectively. This often leads to a Full Table Scan unless a specific function-based index exists.
<strong>Value Lost:</strong> Performance.</p>
</div>
<p><strong>Efficient, Oracle-Idiomatic Solution:</strong></p>
<pre><code class="language-sql">
SELECT projectName, startDate
FROM Projects
WHERE startDate >= TO_DATE('2023-01-01', 'YYYY-MM-DD')
  AND startDate < TO_DATE('2024-01-01', 'YYYY-MM-DD');
</code></pre>
<div class="solution-explanation">
<p><strong>Advantages:</strong> This approach uses SARGable predicates, allowing Oracle to use an index on <code>startDate</code> efficiently via an index range scan. This is significantly faster on large tables.
<strong>Oracle Values:</strong> Emphasizes writing SARGable queries.</p>
</div>
</div>


---
### Solutions for Exercise Block 2: String Functions *(Practice in Oracle)*

<div class="exercise-solution-block">
<h4>Solution for Exercise 2.1.1: Basic Oracle String Manipulation</h4>
<pre><code class="language-sql">
-- a. Concatenation
SELECT
    firstName || ' ' || lastName AS fullName_operator,
    CONCAT(CONCAT(firstName, ' '), lastName) AS fullName_function
FROM Employees
WHERE employeeId = 102;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (a):</strong> The <code>||</code> operator is standard SQL for concatenation and is preferred in Oracle because Oracle's <code>CONCAT(str1, str2)</code> function only accepts two arguments, requiring nested calls for more strings, which is less readable.</p>
</div>
<pre><code class="language-sql">
-- b. Extract username
SELECT
    email,
    SUBSTR(email, 1, INSTR(email, '@') - 1) AS username
FROM Employees
WHERE employeeId = 101;

-- c. Length of trimmed jobTitle
SELECT
    jobTitle AS originalJobTitle,
    TRIM(jobTitle) AS trimmedJobTitle,
    LENGTH(TRIM(jobTitle)) AS lengthOfTrimmedTitle
FROM Employees
WHERE employeeId = 106; -- Frank Miller, jobTitle ' Developer '

-- d. Replace substring
SELECT
    projectName,
    REPLACE(projectName, 'System', 'Platform') AS modifiedProjectName
FROM Projects
WHERE projectId = 1;

-- e. INSTR for Nth occurrence, case-insensitive
SELECT
    firstName,
    INSTR(firstName, 'e', 1, 2) AS pos_second_e_sensitive,
    INSTR(LOWER(firstName), 'e', 1, 2) AS pos_second_e_insensitive
FROM Employees
WHERE employeeId = 105; -- Eve Davis
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (e):</strong> <code>INSTR(string, substring, [start_position_Nth], [occurrence_Nth])</code>. <code>INSTR</code> is case-sensitive by default. To make it case-insensitive, convert both strings to the same case (e.g., using <code>LOWER()</code>). Oracle's <code>INSTR</code> is more powerful than PostgreSQL's <code>POSITION()</code> or <code>strpos()</code> which only find the first occurrence.</p>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 2.2.1: String Function Pitfalls in Oracle</h4>
<div class="solution-explanation">
<p><strong>a. CONCAT with more than two arguments:</strong></p>
<p>Attempt: <code>SELECT CONCAT(firstName, ' ', lastName, ' (', jobTitle, ')') FROM Employees;</code></p>
<p>Result: <code>ORA-00909: invalid number of arguments</code>. Oracle's <code>CONCAT</code> only accepts two arguments.</p>
<p><strong>Correct way using <code>||</code>:</strong></p>
</div>
<pre><code class="language-sql">
SELECT firstName || ' ' || lastName || ' (' || jobTitle || ')' AS fullDescription
FROM Employees WHERE employeeId = 101;
</code></pre>
<div class="solution-explanation">
<p><strong>b. Exact match vs. pattern matching:</strong></p>
<p><code>WHERE jobTitle = 'Developer'</code> fails to find 'Senior Developer'. Use <code>LIKE '%Developer%'</code>, <code>INSTR(jobTitle, 'Developer') > 0</code>, or <code>REGEXP_LIKE(jobTitle, 'Developer')</code> for pattern matching.</p>

<p><strong>c. Empty string <code>''</code> as NULL in Oracle VARCHAR2 concatenation:</strong></p>
<p>In Oracle, an empty string (<code>''</code>) in <code>VARCHAR2</code> is treated as <code>NULL</code>. The <code>||</code> operator treats <code>NULL</code> operands as if they were empty strings for concatenation (i.e., <code>'A' || NULL || 'B'</code> results in <code>'AB'</code>). In PostgreSQL, <code>''</code> is an empty string, not <code>NULL</code>, and <code>'A' || NULL || 'B'</code> results in <code>NULL</code>.</p>

<p><strong>d. SUBSTR behavior with non-positive start/length:</strong></p>
</div>
<pre><code class="language-sql">
SELECT
    SUBSTR('OracleSQL', 0, 3) AS substr_start_0,     -- Oracle treats start_pos 0 as 1: 'Ora'
    SUBSTR('OracleSQL', -3, 3) AS substr_start_neg,  -- Negative start counts from end: 'SQL'
    SUBSTR('OracleSQL', 1, -2) AS substr_len_neg    -- Negative length returns NULL
FROM DUAL;
</code></pre>
<div class="solution-explanation">
<p>Oracle's <code>SUBSTR</code> is flexible: 0 start is treated as 1; negative start counts from end; negative length returns <code>NULL</code>. PostgreSQL's <code>SUBSTRING</code> behavior differs, especially with negative indices/lengths.</p>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 2.3.1: Complex String Parsing - Iterative SUBSTR/INSTR vs. REGEXP_SUBSTR</h4>
<p><strong>Inefficient/Complex Common Solution (Conceptual Outline):</strong></p>
<div class="solution-explanation">
<p>Logic involves finding positions of 1st and 2nd commas using <code>INSTR</code>, then using <code>SUBSTR</code> based on these positions, potentially with <code>CASE</code> for handling fewer commas, and finally <code>TRIM</code>. This becomes deeply nested and error-prone.</p>
<p><strong>Disadvantages:</strong> Poor readability, difficult maintenance, error-prone with off-by-one errors and edge cases. <strong>Value Lost:</strong> Developer productivity, code clarity, robustness.</p>
</div>
<p><strong>Efficient, Oracle-Idiomatic Solution using REGEXP_SUBSTR:</strong></p>
<pre><code class="language-sql">
-- Ensure test data exists if not already run:
-- INSERT INTO Projects (projectId, projectName, startDate) VALUES (99, 'Omega System Upgrade, Phase 2, Alpha Release', SYSDATE); COMMIT;

SELECT
    projectName,
    TRIM(REGEXP_SUBSTR(projectName, '[^,]+', 1, 3)) AS third_element
FROM Projects
WHERE projectId = 99;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation of <code>REGEXP_SUBSTR</code>:</strong></p>
<ul>
    <li><code>source_char</code>: The project name string.</li>
    <li><code>pattern</code>: <code>'[^,]+'</code> (matches one or more non-comma characters).</li>
    <li><code>position</code>: 1 (start search from beginning).</li>
    <li><code>occurrence</code>: 3 (find the third match).</li>
</ul>
<p><code>TRIM</code> is used to remove leading/trailing spaces from the extracted element.</p>
<p><strong>Advantages:</strong> Concise, readable (once regex is understood), flexible, robust.
<strong>Oracle Value:</strong> Provides powerful regular expression capabilities directly in SQL.</p>
</div>
</div>

---
### Solutions for Exercise Block 3: Set Operators *(Practice in Oracle)*

<div class="exercise-solution-block">
<h4>Solution for Exercise 3.1.1: Oracle Set Operators - MINUS, INTERSECT, UNION</h4>
<pre><code class="language-sql">
-- a. Products in A but not B (MINUS)
SELECT productId, productName FROM ProductCatalogA
MINUS
SELECT productId, productName FROM ProductCatalogB;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (a):</strong> Oracle's <code>MINUS</code> is functionally identical to PostgreSQL's <code>EXCEPT</code>. Both return distinct rows from the first query not in the second.
<strong>Advantage:</strong> Clear, declarative way to find differences.</p>
</div>
<pre><code class="language-sql">
-- b. Products common to A and B (INTERSECT)
SELECT productId, productName FROM ProductCatalogA
INTERSECT
SELECT productId, productName FROM ProductCatalogB;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (b):</strong> <code>INTERSECT</code> returns distinct rows present in both query result sets. Identical in Oracle and PostgreSQL.
<strong>Advantage:</strong> Clear, declarative way to find commonalities.</p>
</div>
<pre><code class="language-sql">
-- c. All unique products from A or B (UNION)
SELECT productId, productName FROM ProductCatalogA
UNION
SELECT productId, productName FROM ProductCatalogB;
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation for (c):</strong> <code>UNION</code> combines result sets and returns distinct rows. Identical in Oracle and PostgreSQL. Use <code>UNION ALL</code> for all rows including duplicates.
<strong>Advantage:</strong> Standard way to combine and de-duplicate results.</p>
</div>
<div class="solution-explanation">
<p><strong>d. Requirements for SELECT lists in set operations:</strong></p>
<ol>
    <li><strong>Number of Columns:</strong> All <code>SELECT</code> statements must have the same number of columns.</li>
    <li><strong>Data Type Compatibility:</strong> Data types of corresponding columns must be in the same group (e.g., all numeric) or implicitly convertible. Oracle determines result column types by precedence.</li>
    <li><strong>Column Names:</strong> Output column names are from the first <code>SELECT</code> statement.</li>
</ol>
<p><strong>Value:</strong> These rules ensure structural compatibility.
<strong>Relation:</strong> Standard across SQL databases, including PostgreSQL.</p>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 3.2.1: Set Operator Pitfalls in Oracle</h4>
<div class="solution-explanation">
<p><strong>a. UNION vs. UNION ALL for duplicates:</strong></p>
<p><code>UNION</code> performs a distinct operation, removing duplicates. If all rows including duplicates are needed, use <code>UNION ALL</code>. <code>UNION ALL</code> is generally faster as it avoids the deduplication sort/hash.</p>

<p><strong>b. Set operators with LOB types:</strong></p>
<p>Attempting set operations (<code>UNION</code>, <code>INTERSECT</code>, <code>MINUS</code>) on LOB columns (<code>CLOB</code>, <code>BLOB</code>, etc.) results in <code>ORA-00932: inconsistent datatypes: expected - got CLOB</code>. Direct comparison of LOB content for set operations is not supported.</p>

<p><strong>c. MINUS behavior:</strong></p>
<p><code>(SELECT departmentId FROM Employees WHERE departmentId = 10 AND ROWNUM = 1) MINUS (SELECT departmentId FROM Employees WHERE departmentId = 20 AND ROWNUM = 1);</code></p>
<p>Result: <code>departmentId</code> 10. (Rows in first set not in second).</p>
<p><code>(SELECT departmentId FROM Employees WHERE departmentId = 10 AND ROWNUM = 1) MINUS (SELECT departmentId FROM Employees WHERE departmentId = 10 AND ROWNUM = 1);</code></p>
<p>Result: No rows. (All rows from first set are found in second).</p>

<p><strong>d. Order of set operations:</strong></p>
<p>Oracle evaluates set operators from top to bottom by default, but <code>INTERSECT</code> has higher precedence than <code>UNION</code>, <code>UNION ALL</code>, and <code>MINUS</code>. Using parentheses is crucial for clarity and to ensure the intended order of evaluation, especially in complex queries.</p>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 3.3.1: Finding Disjoint Sets - MINUS vs. Multiple NOT IN/NOT EXISTS</h4>
<p><strong>Less Efficient/More Complex Common Solution (NOT IN):</strong></p>
<pre><code class="language-sql">
-- Setup temp table for illustration if needed:
-- CREATE TABLE ApprovedDepartments (departmentId NUMBER PRIMARY KEY);
-- INSERT INTO ApprovedDepartments VALUES (20);
-- INSERT INTO ApprovedDepartments VALUES (40); COMMIT;

SELECT DISTINCT departmentId
FROM Employees
WHERE departmentId IS NOT NULL
  AND departmentId NOT IN (SELECT departmentId FROM ApprovedDepartments);
</code></pre>
<div class="solution-explanation">
<p><strong>Potential issues with <code>NOT IN</code>:</strong> If the subquery for <code>NOT IN</code> returns even one <code>NULL</code>, the <code>NOT IN</code> condition evaluates to UNKNOWN or FALSE for all rows, leading to an empty result set.
<strong>Value Lost:</strong> Correctness with <code>NULL</code>s in exclusion list; readability can suffer.</p>
</div>
<p><strong>Efficient and Clear Oracle-Idiomatic Solution using MINUS:</strong></p>
<pre><code class="language-sql">
SELECT DISTINCT departmentId
FROM Employees
WHERE departmentId IS NOT NULL
MINUS
SELECT departmentId
FROM ApprovedDepartments
WHERE departmentId IS NOT NULL; -- Explicitly exclude NULLs from the approved set if they could exist
</code></pre>
<div class="solution-explanation">
<p><strong>Advantages of MINUS:</strong></p>
<ol>
    <li><strong>Correct NULL Handling:</strong> Treats two <code>NULL</code>s as identical for comparison.</li>
    <li><strong>Clarity:</strong> Clearly expresses set difference.</li>
    <li><strong>Set-Based:</strong> Operates on entire sets, often well-optimized.</li>
    <li><strong>Multiple Columns:</strong> Naturally handles multi-column comparisons for set difference.</li>
</ol>
<p><strong>Oracle Value:</strong> <code>MINUS</code> is a powerful, declarative tool for set-based comparisons.</p>
<pre><code class="language-sql">
-- DROP TABLE ApprovedDepartments; -- Cleanup if created
</code></pre>
</div>
</div>


---
### Solutions for Exercise Block 4: Data Manipulation Language (DML) & Transaction Control *(Practice in Oracle)*

<div class="exercise-solution-block">
<h4>Solution for Exercise 4.1.1: Oracle DML and Transaction Control Basics</h4>
<pre><code class="language-sql">
-- a. INSERT
INSERT INTO Departments (departmentId, departmentName, locationCity)
VALUES (60, 'Operations', 'Chicago');
-- Verify: SELECT * FROM Departments WHERE departmentId = 60;
COMMIT; -- Commit this initial insert for clarity in subsequent steps

-- b. SAVEPOINT, c. UPDATE, d. DELETE, e. ROLLBACK TO SAVEPOINT, f. COMMIT
-- Re-do sequence for clarity on savepoint effect:

-- Start new transaction segment
UPDATE Employees
SET salary = ROUND(salary * 1.05, 2)
WHERE departmentId = 10;
-- Verify salary update for tech:
-- SELECT employeeId, salary FROM Employees WHERE departmentId = 10;

SAVEPOINT post_salary_update_pre_delete; -- SAVEPOINT (after salary update)

DELETE FROM ProjectAssignments WHERE employeeId = 106; -- DELETE
DELETE FROM Employees WHERE employeeId = 106;          -- DELETE
-- Verify Frank Miller (106) is gone:
-- SELECT * FROM Employees WHERE employeeId = 106;

ROLLBACK TO SAVEPOINT post_salary_update_pre_delete; -- ROLLBACK TO SAVEPOINT
-- Verify Frank Miller (106) is back:
-- SELECT 'Frank Miller status after rollback:' AS status, employeeId, firstName FROM Employees WHERE employeeId = 106;
-- Verify salary updates for Tech dept persist as they were before this specific savepoint:
-- SELECT 'Tech salary after rollback to post_salary_update_pre_delete:' AS status, employeeId, salary FROM Employees WHERE departmentId = 10;

COMMIT; -- COMMIT (makes salary updates and Frank Miller's non-deletion permanent)

-- g. MERGE
MERGE INTO Employees e
USING EmployeeUpdatesForMerge u
    ON (e.employeeId = u.employeeId)
WHEN MATCHED THEN
    UPDATE SET
        e.jobTitle = u.newJobTitle,
        e.salary = u.newSalary,
        e.departmentId = u.newDepartmentId
WHEN NOT MATCHED THEN
    INSERT (employeeId, firstName, lastName, email, jobTitle, salary, departmentId, hireDate)
    VALUES (u.employeeId, 'NewEmp', 'ViaMerge', u.employeeId || '@merge.com', u.newJobTitle, u.newSalary, u.newDepartmentId, SYSDATE);

COMMIT; -- Commit the MERGE operation.
-- Verify MERGE:
-- SELECT employeeId, firstName, lastName, email, jobTitle, salary, departmentId FROM Employees WHERE employeeId IN (102, 106, 108);
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation of MERGE Advantage:</strong> <code>MERGE</code> (upsert) combines <code>UPDATE</code> and <code>INSERT</code> into a single atomic statement.</p>
<ol>
    <li><strong>Atomicity:</strong> Avoids race conditions of separate check-then-act logic.</li>
    <li><strong>Performance:</strong> Generally more performant for bulk operations than procedural loops or multiple SQLs.</li>
    <li><strong>Readability/Conciseness:</strong> Clearly expresses conditional insert/update.</li>
</ol>
<p><strong>Relation to PostgreSQL:</strong> PostgreSQL (9.5+) offers <code>INSERT ... ON CONFLICT ... DO UPDATE/NOTHING</code>. Oracle's <code>MERGE</code> is often considered more flexible with its <code>USING <source></code> clause and an optional <code>DELETE</code> clause in <code>WHEN MATCHED</code>.</p>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 4.2.1: DML and Transaction Pitfalls</h4>
<div class="solution-explanation">
<p><strong>a. Uncommitted DML and visibility:</strong></p>
<p>If <code>UPDATE Employees SET commissionPct = 0.05 WHERE departmentId = 30;</code> is run without <code>COMMIT</code>:</p>
<ul>
    <li><strong>Same Session Report:</strong> Sees the updated <code>commissionPct</code>.</li>
    <li><strong>Another Session Report:</strong> Does *not* see uncommitted changes (due to read consistency/MVCC).</li>
    <li><strong>Session Closes Without COMMIT:</strong> Oracle automatically performs a <code>ROLLBACK</code>. Changes are discarded.</li>
</ul>
<p><strong>Pitfall:</strong> Assuming uncommitted changes are visible to others or are permanent without <code>COMMIT</code>.</p>

<p><strong>b. Accidental <code>DELETE FROM Projects;</code> (No COMMIT):</strong></p>
<p><strong>Immediate Action:</strong> Issue <code>ROLLBACK;</code> immediately. This will undo the delete operation. If <code>COMMIT</code> occurred, recovery is harder (Flashback, backups).</p>

<p><strong>c. MERGE ON condition with non-unique source matches for a target row:</strong></p>
<p>If the <code>ON</code> clause (e.g., <code>target.departmentId = source.departmentId</code>) allows one target row to match multiple source rows, Oracle raises <code>ORA-30926: unable to get a stable set of rows in the source tables</code>. This is because it's ambiguous which source row's data should be used for the update. The source often needs pre-aggregation or filtering.</p>

<p><strong>d. ROLLBACK TO SAVEPOINT behavior:</strong></p>
<p>Transaction: <code>BEGIN -> SAVEPOINT S1 -> DML1 -> SAVEPOINT S2 -> DML2 -> ROLLBACK TO S1;</code></p>
<ul>
    <li><strong>DML1:</strong> Is rolled back (occurred after S1).</li>
    <li><strong>DML2:</strong> Is rolled back (occurred after S2, which is after S1).</li>
    <li><strong>Savepoint S2:</strong> Is discarded. <code>ROLLBACK TO S1</code> erases all changes and savepoints created *after* S1. S1 remains active.</li>
</ul>
</div>
</div>

<div class="exercise-solution-block">
<h4>Solution for Exercise 4.3.1: Conditional Insert/Update - MERGE vs. Separate UPDATE then INSERT</h4>
<p><strong>Less Efficient/More Complex Common Solution (Separate SQL Statements):</strong></p>
<pre><code class="language-sql">
-- Step 1: Update existing employees
UPDATE Employees e
SET (jobTitle, salary, departmentId) = (
    SELECT u.newJobTitle, u.newSalary, u.newDepartmentId
    FROM EmployeeUpdatesForMerge u
    WHERE u.employeeId = e.employeeId
)
WHERE EXISTS (
    SELECT 1
    FROM EmployeeUpdatesForMerge u
    WHERE u.employeeId = e.employeeId
);

-- Step 2: Insert new employees
INSERT INTO Employees (employeeId, firstName, lastName, email, jobTitle, salary, departmentId, hireDate)
SELECT
    u.employeeId, 'Separate', 'SQL', u.employeeId || '@separate.com',
    u.newJobTitle, u.newSalary, u.newDepartmentId, SYSDATE
FROM EmployeeUpdatesForMerge u
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.employeeId = u.employeeId
);
-- COMMIT; -- After both operations
</code></pre>
<div class="solution-explanation">
<p><strong>Disadvantages of Separate SQL:</strong></p>
<ol>
    <li><strong>Multiple Scans/Operations:</strong> Less efficient.</li>
    <li><strong>Complexity:</strong> Requires careful <code>EXISTS</code>/<code>NOT EXISTS</code> logic.</li>
    <li><strong>Race Conditions:</strong> Theoretical window between <code>UPDATE</code> and <code>INSERT</code> in concurrent environments.</li>
    <li><strong>Verbosity:</strong> More code.</li>
</ol>
<p><strong>Value Lost:</strong> Potential performance, atomicity in a single statement, conciseness.</p>
</div>
<p><strong>Efficient, Oracle-Idiomatic Solution using MERGE:</strong></p>
<pre><code class="language-sql">
MERGE INTO Employees e
USING EmployeeUpdatesForMerge u
    ON (e.employeeId = u.employeeId)
WHEN MATCHED THEN
    UPDATE SET
        e.jobTitle = u.newJobTitle,
        e.salary = u.newSalary,
        e.departmentId = u.newDepartmentId
WHEN NOT MATCHED THEN
    INSERT (employeeId, firstName, lastName, email, jobTitle, salary, departmentId, hireDate)
    VALUES (u.employeeId, 'NewEmp', 'ViaMerge', u.employeeId || '@merge.com', u.newJobTitle, u.newSalary, u.newDepartmentId, SYSDATE);
-- COMMIT;
</code></pre>
<div class="solution-explanation">
<p><strong>Advantages of MERGE (reiteration):</strong> Single atomic statement, often better performance, more readable for "upsert" logic.
<strong>Oracle Value:</strong> Cornerstone DML for data warehousing, ETL, and synchronization.</p>
</div>
</div>

---
### Solution for Hardcore Combined Problem

<div class="exercise-solution-block" style="border-color: #FF9900;"> <!-- Orange border for emphasis -->
<h3 style="color: #FF9900;">Solution: The Performance Recognition Initiative</h3>

<h4>Part 1: Pre-analysis (Set Operators & ROWNUM)</h4>
<pre><code class="language-sql">
-- 1.a. Identify employeeIds of all current non-managers using MINUS
PROMPT 'Non-Managers (employeeId):';
SELECT employeeId FROM Employees
MINUS
SELECT managerId FROM Employees WHERE managerId IS NOT NULL;

-- 1.b. Top 3 longest-serving eligible employees
PROMPT 'Top 3 longest-serving eligible employees:';
SELECT firstName, lastName, hireDate, salary
FROM (
    SELECT e.firstName, e.lastName, e.hireDate, e.salary
    FROM Employees e
    WHERE e.hireDate <= TO_DATE('2022-06-30', 'YYYY-MM-DD')
      AND e.departmentId IN (10, 30)
      AND e.salary < 90000
      AND e.email LIKE '%@example.com'
      AND e.employeeId NOT IN (SELECT DISTINCT m.managerId FROM Employees m WHERE m.managerId IS NOT NULL) -- Must not be a manager
    ORDER BY e.hireDate ASC -- Earliest hireDate first for longest-serving
)
WHERE ROWNUM <= 3;
</code></pre>

<h4>Part 2: Transactional Processing (DML & Transaction Control)</h4>
<div class="solution-explanation">
<p><em>Note: The following PL/SQL block implements the transactional logic. <code>SET SERVEROUTPUT ON</code> is needed to see DBMS_OUTPUT messages. You might want to <code>DELETE FROM AuditLog WHERE operationType = 'RECOGNIZE'; COMMIT;</code> before re-runs for clean testing.</em></p>
</div>
<pre><code class="language-sql">
SET SERVEROUTPUT ON;
DECLARE
    v_recognized_count NUMBER := 0;
    v_recognition_payment NUMBER;
    v_base_payment NUMBER;
    v_service_kicker NUMBER;
    v_years_service NUMBER;
    v_current_comm_pct NUMBER;
    v_new_comm_pct NUMBER;
    v_audit_details CLOB;
    v_emp_fullname VARCHAR2(101);

    CURSOR c_eligible_employees IS
        SELECT e.employeeId, e.firstName, e.lastName, e.hireDate, e.salary, e.commissionPct, e.departmentId, e.jobTitle, e.email
        FROM Employees e
        WHERE e.hireDate <= TO_DATE('2022-06-30', 'YYYY-MM-DD')
          AND e.departmentId IN (10, 30)
          AND e.salary < 90000
          AND e.email LIKE '%@example.com'
          AND e.employeeId NOT IN (SELECT DISTINCT m.managerId FROM Employees m WHERE m.managerId IS NOT NULL)
        FOR UPDATE OF e.commissionPct;

BEGIN
    SAVEPOINT recognition_initiative_start;
    DBMS_OUTPUT.PUT_LINE('Transaction started. Savepoint recognition_initiative_start created.');

    FOR emp_rec IN c_eligible_employees LOOP
        -- Calculate Base Payment
        IF INSTR(LOWER(emp_rec.jobTitle), 'developer') > 0 THEN
            v_base_payment := 2000;
        ELSIF INSTR(LOWER(emp_rec.jobTitle), 'sales') > 0 THEN
            v_base_payment := 1500;
        ELSE
            v_base_payment := 1000;
        END IF;

        -- Calculate Service Kicker
        v_years_service := MONTHS_BETWEEN(SYSDATE, emp_rec.hireDate) / 12;
        v_service_kicker := FLOOR(v_years_service) * 100; -- Only full years

        -- Total Recognition Payment
        v_recognition_payment := ROUND(v_base_payment + v_service_kicker, 0);

        -- Update commissionPct
        v_current_comm_pct := NVL(emp_rec.commissionPct, 0);
        v_new_comm_pct := v_current_comm_pct; 

        IF v_recognition_payment > 1200 THEN
            v_new_comm_pct := LEAST(v_current_comm_pct + 0.01, 0.25);
            UPDATE Employees
            SET commissionPct = v_new_comm_pct
            WHERE CURRENT OF c_eligible_employees;
        END IF;

        -- Log to AuditLog
        v_emp_fullname := emp_rec.firstName || ' ' || emp_rec.lastName;
        v_audit_details := 'Recognition: EmpID=' || TO_CHAR(emp_rec.employeeId) ||
                           ' (Name: ' || v_emp_fullname || ')' ||
                           ', Payment=$' || TO_CHAR(v_recognition_payment, '9999990.00') ||
                           ', NewCommPct=' || TO_CHAR(v_new_comm_pct, '0.00') ||
                           ', YearsSvc=' || TO_CHAR(v_years_service, '990.00');

        INSERT INTO AuditLog (tableName, operationType, details)
        VALUES ('Employees', 'RECOGNIZE', v_audit_details);

        v_recognized_count := v_recognized_count + 1;
        DBMS_OUTPUT.PUT_LINE('Recognized employee ' || emp_rec.employeeId || '. Payment: $' || v_recognition_payment || '. New Comm Pct: ' || v_new_comm_pct);

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total employees recognized: ' || v_recognized_count);

    IF v_recognized_count < 1 THEN
        ROLLBACK TO SAVEPOINT recognition_initiative_start;
        DBMS_OUTPUT.PUT_LINE('Fewer than 1 employee recognized. Transaction rolled back to recognition_initiative_start.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(v_recognized_count || ' employee(s) recognized. Transaction committed.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLCODE || ' - ' || SQLERRM);
        RAISE;
END;
/
</code></pre>
<div class="solution-explanation">
<p><strong>Explanation of Hardcore Problem Solution Elements:</strong></p>
<ul>
    <li><strong>Date Functions:</strong> <code>MONTHS_BETWEEN(SYSDATE, hireDate)</code>, <code>TO_DATE</code>.</li>
    <li><strong>String Functions:</strong> <code>INSTR(LOWER(jobTitle), ...)</code>, <code>||</code>, <code>TO_CHAR</code> for formatting, <code>LIKE</code>.</li>
    <li><strong>Set Operators:</strong> <code>MINUS</code> for non-managers. <code>IN (SELECT ...)</code> and <code>NOT IN (SELECT ...)</code> for eligibility.</li>
    <li><strong>DML & Transaction Control:</strong> <code>SAVEPOINT</code>, <code>UPDATE ... WHERE CURRENT OF cursor</code>, <code>INSERT</code> into <code>AuditLog</code>, conditional <code>COMMIT</code>/<code>ROLLBACK</code>.</li>
    <li><strong>Preceding Concepts:</strong> Utilizes Oracle data types, <code>NVL</code> for NULL handling, <code>ROWNUM</code>, and PL/SQL for procedural flow control.</li>
</ul>
<p>This problem integrates multiple concepts, focusing on Oracle-specific syntax (like <code>MONTHS_BETWEEN</code>, PL/SQL block structure, <code>WHERE CURRENT OF</code>) and common SQL patterns adapted for Oracle.</p>
</div>
<pre><code class="language-sql">
-- Verification queries (optional, to run after the PL/SQL block)
PROMPT 'Verification of employee commission percentages after PL/SQL block:';
SELECT employeeId, firstName, lastName, salary, commissionPct, hireDate, departmentId, jobTitle
FROM Employees
WHERE departmentId IN (10,30) AND employeeId NOT IN (SELECT DISTINCT managerId FROM Employees WHERE managerId IS NOT NULL)
ORDER BY employeeId;

PROMPT 'Verification of AuditLog for RECOGNIZE operations:';
SELECT logId, tableName, operationType, TO_CHAR(operationTimestamp, 'YYYY-MM-DD HH24:MI:SS') AS opTime, details
FROM AuditLog
WHERE operationType = 'RECOGNIZE'
ORDER BY logId DESC;
</code></pre>
</div>

</div>