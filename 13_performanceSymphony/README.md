<head>
<link rel="stylesheet" href="../styles/lecture.css">
</head>

<body>
<div class="toc-popup-container">
<input type="checkbox" id="tocToggleChunk13" class="toc-toggle-checkbox">
<label for="tocToggleChunk13" class="toc-toggle-label">
    <span>Contents</span>
    <span class="toc-icon-open"></span>
</label>
<div class="toc-content">
    <h4>Oracle Performance & Optimization Basics</h4>
    <ul>
        <li><a href="#section1">Section 1: What Are They? (Meanings & Values in Oracle)</a>
            <ul>
                <li><a href="#section1sub1">The Cost-Based Optimizer (CBO)</a></li>
                <li><a href="#section1sub2">Query Tuning Considerations</a></li>
                <li><a href="#section1sub3">Optimizer Hints</a></li>
                <li><a href="#section1sub4">Table Statistics and DBMS_STATS</a></li>
                <li><a href="#section1sub5">Oracle 23ai: Real-Time Enhancements</a></li>
            </ul>
        </li>
        <li><a href="#section2">Section 2: Relations: How They Play with Others</a></li>
        <li><a href="#section3">Section 3: How to Use Them: Structures & Syntax</a>
            <ul>
                <li><a href="#section3sub1">Basic Query Tuning</a></li>
                <li><a href="#section3sub2">Using Optimizer Hints</a></li>
                <li><a href="#section3sub3">Managing Statistics with DBMS_STATS</a></li>
                <li><a href="#section3sub4">Using 23ai Performance Features</a></li>
            </ul>
        </li>
            <li><a href="#section4">Section 4: Why Use Them? (Advantages in Oracle)</a></li>
        <li><a href="#section5">Section 5: Watch Out! (Disadvantages & Pitfalls in Oracle)</a></li>
    </ul>
</div>
</div>

<div class="container">
<h1>ORACLE PERFORMANCE & OPTIMIZATION BASICS</h1>

<p>
    Welcome to the performance symphony, where every query is a note and the optimizer, a tireless conductor, makes it resonate. Moving from SQL that is merely correct to code that is truly performant is a pivotal, perfect step. In Oracle, this means you must elect to understand the heart of its decision-making intellect: the <strong>Cost-Based Optimizer</strong> (CBO). This lecture will connect you with the foundational principles of Oracle query tuning, from writing index-friendly code that the system can embrace, to managing the statistics that guide the optimizer's grace. We'll also explore groundbreaking Oracle Database 23ai features that automate this complex art, transforming potential performance discord into a harmonious, data-retrieving concerto that leaves no process forlorn.
</p>

<h2 id="section1">Section 1: What Are They? (Meanings & Values in Oracle)</h2>
<p>
    At its core, performance tuning is a thoughtful mission, about influencing the database's choices to ensure the most efficient path for data acquisition. This involves understanding the tools the database provides to observe and guide this intricate expedition. Why did the Cost-Based Optimizer break up with the Rule-Based Optimizer? Because it had absolutely no sense of value!
</p>

<h3 id="section1sub1">The Cost-Based Optimizer (CBO)</h3>
<p>
    The <strong>Cost-Based Optimizer</strong> is the <strong>Guiding Intelligence</strong> of Oracle's query execution. Its singular goal is to find the lowest-cost execution plan, a true mission of art. A plan's "cost" is an internal, unit-less number representing the estimated resources (I/O, CPU) that must be lent. The CBO evaluates multiple strategies—different join methods, join orders, and access paths—and then picks the one it calculates as the cheapest, an outcome that is heaven-sent.
</p>

<h3 id="section1sub2">Query Tuning Considerations</h3>
<ul>
    <li>
        <strong>SARGable Predicates:</strong> A "Searchable Argument" creates a <strong>Grounded Bridge</strong> from your query to an index. The core principle, which you know from PostgreSQL, is to avoid applying functions to indexed columns—a cardinal sin. Instead of <code>TRUNC(hireDate) = '2023-01-01'</code>, you define a clear date range. This simple change is the a-b-c that can mean the difference between a `TABLE ACCESS FULL`, a true `memory mountain`, and a swift `INDEX RANGE SCAN`, a `running river` of data.
    </li>
    <li>
        <strong>Efficient Joins:</strong> The optimizer's choice of join method is a key decision. A <code>NESTED LOOPS</code> join is efficient for joining a small, targeted result set to a large table via an index, while a <code>HASH JOIN</code> excels at processing two large, unsorted row sets in a session.
    </li>
    <li>
        <strong>Minimizing Data:</strong> The fundamental law of performance is to process the least amount of data necessary, a truth that's quite elementary.
    </li>
</ul>

<h3 id="section1sub3">Optimizer Hints</h3>
<p>
    An <strong>Optimizer Hint</strong> is a special comment, a `/*+ coded whisper */` embedded directly in a SQL statement that acts as a directive to the CBO. It's a way for a developer to make a <strong>Forced Decision</strong>, a sort of `technical debt` paid in advance. Hints are powerful but represent a `brittle solution` and should be used with extreme caution.
</p>

<h3 id="section1sub4">Table Statistics & DBMS_STATS</h3>
<p>
    <strong>Statistics</strong> are the <strong>Optimizer's Eyes</strong>, the metadata describing the data landscape—row counts, distinct values, and data distribution. If these statistics are missing or stale, the CBO is effectively blind, and its cost calculations will be a guess, leading to a performance mess.
</p>
<p>
    <code>DBMS_STATS</code> is the Oracle-specific PL/SQL package, the designated <strong>Statistics Engine</strong>, used to gather and manage this vital information. Knowing its procedures is an absolute mission.
</p>

<h3 id="section1sub5" class="oracle-specific">Oracle 23ai: Real-Time Enhancements</h3>
<ul>
    <li>
        <strong>Real-Time SQL Plan Management (SPM):</strong> This feature is a true <strong>Performance Guardian</strong>. SPM automatically detects when a query's execution plan regresses, comparing it to a known-good "baseline." It can then prevent this `digital ghost` of a bad plan from haunting your system, a feature that's heaven-sent.<sup id="fnref13_2"><a href="#fn13_2">2</a></sup>
    </li>
    <li>
        <strong>SQL Analysis Report:</strong> A built-in diagnostic tool, an `analytical engine`, that automatically inspects a SQL statement for common structural flaws like Cartesian products and provides clear, actionable recommendations.
    </li>
</ul>

<h2 id="section2">Section 2: Relations: How They Play with Others (in Oracle)</h2>
<p>
    These performance concepts form a `knowledge cascade`. Accurate <strong>Statistics</strong>, gathered by <code>DBMS_STATS</code>, are the foundation. The <strong>CBO</strong> uses these stats to build an intelligent plan. When statistics are flawed, the CBO's plan might be absurd. A developer, in a moment of hurried concern, might then use a **Hint** to force a better plan, `shouting over a whisper` of the optimizer's logic.
</p>
<p>
    This creates a brittle solution, a `golden cage` that traps performance. The true Oracle way is to ensure statistics are current, allowing the CBO to adapt. The 23ai **Real-Time SQL Plan Management** feature elevates this to a new station, using a history of good plans to prevent regressions automatically, providing a powerful foundation. The **SQL Analysis Report** acts as an initial diagnostic layer, helping you find and bind the solution before you even start to feel the grind.
</p>

<div class="postgresql-bridge">
    <strong>PostgreSQL to Oracle Bridge:</strong> Your PostgreSQL knowledge of <code>EXPLAIN</code> and the importance of <code>ANALYZE</code> maps directly. In Oracle, <code>EXPLAIN PLAN</code> with <code>DBMS_XPLAN.DISPLAY</code> is the ritual, and <code>DBMS_STATS.GATHER_*_STATS</code> is the equivalent of <code>ANALYZE</code>, a tool that's just as vital. The core concept of a cost-based optimizer is identical. The key differences lie in the tooling and the automation. Oracle's 23ai features provide a proactive safety net that is a significant sensation.
</div>

<h2 id="section3">Section 3: How to Use Them: Structures & Syntax (in Oracle)</h2>
<p>
    To master the art, you must know every part.
</p>
<h3 id="section3sub1">Basic Query Tuning</h3>
<ul>
    <li>
        <strong>Writing SARGable Predicates:</strong> This discipline is your fate, a simple choice that dictates the rate at which your queries accelerate.
        <div class="rhyme">
            A function on a column brings a planner to its knees, <br>
            It makes your speedy index beg and plead and wheeze. <br>
            But flip the condition, make the logic take flight, <br>
            And the optimizer's path becomes blindingly bright.
        </div>
        <pre><code class="sql">-- Inefficient (Non-SARGable): optimizer cannot use an index on hireDate
SELECT * FROM employees WHERE TRUNC(hireDate) = TO_DATE('2022-01-15', 'YYYY-MM-DD');

-- Efficient (SARGable): optimizer can use an index on hireDate
SELECT * FROM employees WHERE hireDate >= TO_DATE('2022-01-15', 'YYYY-MM-DD') AND hireDate < TO_DATE('2022-01-16', 'YYYY-MM-DD');
</code></pre>
    </li>
</ul>
<h3 id="section3sub2">Using Optimizer Hints</h3>
<p>
    Hints are embedded in comments, a command you impart. They are powerful but should be used when you're truly smart.
</p>
<pre><code class="sql">-- Syntax: /*+ HINT_NAME(alias) [HINT_NAME(alias)] */

-- Force the use of a specific index
SELECT /*+ INDEX(e idxEmpHireDate) */ *
FROM employees e
WHERE hireDate > TO_DATE('2023-01-01', 'YYYY-MM-DD');

-- Force a full table scan
SELECT /*+ FULL(e) */ *
FROM employees e
WHERE status = 'ACTIVE';
</code></pre>

<h3 id="section3sub3">Managing Statistics with DBMS_STATS</h3>
<p>
    This PL/SQL package is your primary interface for managing optimizer statistics, a true performance-tuning artist.
</p>
<pre><code class="sql">-- Basic syntax to gather stats for a single table
BEGIN
DBMS_STATS.GATHER_TABLE_STATS(
ownname => 'PERFORMANCESYMPHONY',
tabname => 'EMPLOYEES'
);
END;
/

-- To gather statistics for an entire schema
BEGIN
DBMS_STATS.GATHER_SCHEMA_STATS(
ownname => 'PERFORMANCESYMPHONY'
);
END;
/
</code></pre>

<h3 id="section3sub4" class="oracle-specific">Using 23ai Performance Features</h3>
<ol>
    <li>
        <strong>SQL Analysis Report:</strong> This feature requires no special syntax; it's part of the `EXPLAIN PLAN` bargain.
        <pre><code class="sql">-- Step 1: Run your query (even a flawed one)
SELECT e.lastName FROM employees e, departments d; -- Missing join

-- Step 2: Display the cursor plan with the analysis report
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT => 'ALL'));
</code></pre>
    </li>
    <li>
        <strong>Real-Time SQL Plan Management (Conceptual Use):</strong> Load a known-good plan to protect it from a change of heart.
        <pre><code class="sql">-- Find the SQL_ID of your well-performing query
SELECT sql_id FROM v$sql WHERE sql_text LIKE '...';

-- Load the plan from the cursor cache into a new baseline
DECLARE
l_plans_loaded PLS_INTEGER;
BEGIN
l_plans_loaded := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(
sql_id => 'your_sql_id_here'
);
END;
/
</code></pre>
    </li>
</ol>

<h2 id="section4">Why Use Them? (Advantages in Oracle)</h2>
<ul>
    <li>
        <strong>Predictable Performance:</strong> Properly maintained statistics lead to stable, predictable query execution. The CBO can make consistently good choices, a true elevation.
    </li>
    <li>
        <strong>Automation and Reduced Overhead:</strong> 23ai features act as a **laughing river**, effortlessly washing away performance bugs and plan regressions. They automate what was once a manual, expertise-driven expedition.
    </li>
    <li>
        <strong>Scalability:</strong> Writing SARGable queries and ensuring efficient joins are fundamental to building applications that can handle a growing data foundation.
    </li>
    <li>
        <strong>Surgical Intervention:</strong> With great care, a hint becomes a `precision tool`, a scalpel for the rare case, providing a powerful escape hatch when the optimizer, for complex reasons, is out of the race.
    </li>
</ul>

<h2 id="section5">Watch Out! (Disadvantages & Pitfalls in Oracle)</h2>
<ul>
    <li>
        <strong>Stale Statistics (The #1 Pitfall):</strong> The most common cause of performance degradation is stale statistics, an optimizer's lamentation. A plan for a 1,000-row table will fail on 10 million. Relying on this is like using a **frozen flame** for warmth; it's a `brittle solution` that offers no real salvation.
    </li>
    <li>
        <strong>Hint Brittleness:</strong> Hard-coding hints is a **time carpet**; you're woven into its design, unable to leave. A hint that helps today becomes a bottleneck tomorrow. It locks a plan in place, removing the CBO's ability to adapt to a new design.
    </li>
    <li>
        <strong>Dynamic Sampling's Toll:</strong> If stats are missing, the database may resort to dynamic sampling. While helpful, it adds overhead to the parsing elation. It's better to have pre-gathered, accurate statistics for every situation.
    </li>
    <li>
        <strong>A Consultant's Tale:</strong> I once saw a DBA, a man of great station, approach a slow query with nervous trepidation. He checked the server load, the memory, and disk space, with a worried look on his face. He checked networking, then cleared the cache, a frantic, desperate dash. But the query remained slow, a digital ghost, mocking the DBA he hated the most. Finally, he ran a simple script to see if stats were stale, and the answer came back, a sorrowful wail. The table had grown a thousand-fold in a single night's run, and the optimizer's old plan was now second to none... in being slow. The moral is clear: before you suspect a complex affliction, check the basics first; it's the simplest conviction.
    </li>
</ul>
</div>
<div class="footnotes">
<ol>
    <li id="fn13_1">
        <p><a href="/books/sql-tuning-guide/ch01_19-influencing-the-optimizer.pdf" title="Oracle Database SQL Tuning Guide, 23ai - Chapter 19: Influencing the Optimizer">Oracle Database SQL Tuning Guide, 23ai, Chapter 19: Influencing the Optimizer</a>. This chapter provides a comprehensive overview of hints, their syntax, and their purpose. <a href="#fnref13_1" title="Jump back to footnote 1 in the text">↩</a></p>
    </li>
    <li id="fn13_2">
        <p><a href="/books/oracle-database-23ai-new-features-guide/11_Diagnosability.pdf" title="Oracle Database 23ai New Features Guide - Chapter 11: Diagnosability">Oracle Database 23ai New Features Guide, Chapter 11: Diagnosability, Section "Add Verified SQL Plan Baseline"</a>. This section introduces the concept of real-time plan management and automatic baseline creation. <a href="#fnref13_2" title="Jump back to footnote 2 in the text">↩</a></p>
    </li>
</ol>
</div>
</body>