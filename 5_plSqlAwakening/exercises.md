<style>
    :root {
        /* --- Oracle Night Mode Palette --- */
        --primary-color: #4db8ff; /* Oracle brand blue */
        --secondary-color: #6bd4ff; /* Lighter Oracle blue */
        --accent-color: #ff8c00; /* Oracle accent orange */
        --background-color: #1a1a24; /* Deep blue-black */
        --text-color: #e0e0e0; /* Soft white text */
        
        --code-background: #1e1e2e; /* Dark blue-gray */
        --code-border: #3a3a5a; /* Medium blue-gray */
        --inline-code-text: #f0f0f0; /* Bright code text */
        
        --table-border: #4a4a6a; /* Blue-gray border */
        --table-header-bg: rgba(77, 184, 255, 0.15); /* Oracle blue tint */
        --table-header-text: var(--secondary-color); /* Light blue text */
        --table-cell-bg: #252535; /* Slightly lighter than main BG */
        
        --header-font: 'Oracle Sans', 'Helvetica Neue', Arial, sans-serif;
        --body-font: 'Georgia', Times, serif;
        --code-font: 'Oracle Mono', 'Consolas', 'Monaco', 'Courier New', monospace;
        
        /* Animation variables */
        --transition-speed: 0.4s;
        --hover-scale: 1.02;
        --glow-intensity: 0.6;

        /* Additional custom properties for specific callouts if needed */
        --oracle-specific-bg: rgba(255, 140, 0, 0.1);
        --oracle-specific-border: var(--accent-color);
        --postgresql-bridge-bg: rgba(0, 193, 118, 0.1);
        --postgresql-bridge-border: #00c176;
        --caution-bg: rgba(230, 76, 0, 0.1); /* More reddish orange for caution */
        --caution-border: #e64c00; /* Darker reddish orange */
        --footnote-color: #a0a0c0;
        --box-shadow-color: rgba(0,0,0,0.3);
    }

    @keyframes slideUp {
        from { 
            opacity: 0;
            transform: translateY(30px);
        }
        to { 
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes containerGlow {
        0% { box-shadow: 0 0 5px rgba(77, 184, 255, 0); }
        50% { box-shadow: 0 0 20px rgba(77, 184, 255, var(--glow-intensity)); }
        100% { box-shadow: 0 0 5px rgba(77, 184, 255, 0); }
    }

    body {
        font-family: var(--body-font);
        color: var(--text-color);
        background-color: var(--background-color);
        line-height: 1.7;
        margin: 0;
        padding: 25px;
        background-image: 
            radial-gradient(circle at 10% 20%, #2a2a3a 0%, transparent 20%),
            radial-gradient(circle at 90% 80%, #2a2a3a 0%, transparent 20%);
        overflow-x: hidden;
        font-size: 1.2rem;
        /* user-select: none; */
    }

    .container {
        max-width: 950px;
        margin: 2rem auto;
        background-color: #252535;
        padding: 35px;
        border-radius: 8px;
        box-shadow: 0 4px 30px rgba(0, 0, 30, 0.5);
        border: 1px solid transparent;
        animation: 
            slideUp 0.8s cubic-bezier(0.22, 1, 0.36, 1) forwards,
            containerGlow 3s ease-in-out 1s infinite;
        transition: 
            transform var(--transition-speed) ease,
            box-shadow var(--transition-speed) ease,
            border-color var(--transition-speed) ease;
        opacity: 0; /* Start invisible for animation */
    }

    .container:hover {
        border: 1px solid var(--primary-color);
        box-shadow: 
            0 0 25px rgba(77, 184, 255, 0.3),
            0 4px 30px rgba(0, 0, 30, 0.6);
        transform: translateY(-5px);
    }

    /* Content animations with staggered delays */
    .container > * {
        opacity: 0;
        animation: slideUp 0.6s cubic-bezier(0.22, 1, 0.36, 1) forwards;
    }

    .container > h1 { animation-delay: 0.3s; }
    .container > h2 { animation-delay: 0.4s; }
    .container > h3 { animation-delay: 0.5s; }
    .container > p { animation-delay: 0.6s; }
    .container > pre { animation-delay: 0.7s; }
    .container > table { animation-delay: 0.8s; }
    .container > .oracle-specific { animation-delay: 0.9s; }
    .container > ul, .container > ol { animation-delay: 0.65s; }
    .container > .postgresql-bridge { animation-delay: 0.9s; }
    .container > .caution { animation-delay: 0.9s; }

    h1, h2, h3, h4 {
        font-family: var(--header-font);
        color: var(--primary-color);
        transition: color var(--transition-speed) ease;
    }

    h1 {
        border-bottom: 4px solid var(--secondary-color);
        padding-bottom: 15px;
        font-size: 2.8em;
        text-align: center;
        letter-spacing: 1px;
        text-shadow: 0 2px 4px rgba(0, 100, 200, 0.2);
    }

    h2 {
        color: var(--secondary-color);
        font-size: 2.2em;
        border-bottom: 2px solid var(--accent-color);
        margin-top: 35px;
        padding-bottom: 8px;
        transform-origin: left;
        transition: transform 0.2s ease;
    }

    h2:hover {
        transform: scaleX(1.01);
    }

    h3 {
        color: var(--accent-color);
        font-size: 1.7em;
        margin-top: 25px;
        border-left: 4px solid var(--primary-color);
        padding-left: 10px;
        transition: all var(--transition-speed) ease;
    }
    h3:hover {
        border-left-color: var(--secondary-color);
        color: var(--primary-color);
    }

    p { /* li styling moved to specific list item rules */
        font-size: 1.15em; /* Relative to body font-size */
        margin-bottom: 12px;
    }

    li { /* General li, mostly for margin, font-size will be overridden */
        margin-bottom: 10px; 
    }

    /* --- Unordered List Styling --- */
    ul {
        list-style-type: none; 
        padding-left: 0;
    }

    /* Level 1 UL Items */
    ul > li {
        font-size: 1.15em; /* Relative to body font-size */
        padding-left: 25px; 
        position: relative; 
        margin-bottom: 10px; 
    }

    ul > li::before {
        content: '►'; 
        color: var(--accent-color); 
        position: absolute;
        left: 0;
        top: 1px; 
        font-size: 1em; /* Relative to this li's font-size */
        transition: transform 0.2s ease-out, color 0.2s ease-out;
    }

    ul > li:hover::before {
        color: var(--primary-color);
        transform: scale(1.2) translateX(2px);
    }

    /* Level 2 UL Container */
    ul ul {
        margin-top: 8px;
        margin-bottom: 8px;
        padding-left: 0; /* Sub-list aligns with parent text start */
        /* font-size removed from here, applied to li */
    }

    /* Level 2 UL Items */
    ul ul > li { 
        font-size: 1.0em; /* Relative to body font-size */
        padding-left: 25px; /* Inherited padding from parent ul li is typically how this is done if not explicit */
        position: relative; /* Ensure positioning context for ::before */
        margin-bottom: 8px; 
    }

    ul ul > li::before {
        content: '–'; 
        color: var(--secondary-color);
        font-size: 1em; /* Relative to this li's font-size */
        position: absolute;
        left: 0;
        top: 0px; 
        transition: color 0.2s ease-out, transform 0.2s ease-out;
    }

    ul ul > li:hover::before {
        color: var(--primary-color);
        transform: none; 
    }

    /* Level 3 UL Container */
    ul ul ul {
        margin-top: 6px;
        margin-bottom: 6px;
        padding-left: 0; 
    }

    /* Level 3 UL Items */
    ul ul ul > li { 
        font-size: 0.9em; /* Relative to body font-size */
        padding-left: 25px;
        position: relative;
        margin-bottom: 6px;
    }

    ul ul ul > li::before {
        content: '·'; 
        color: var(--footnote-color);
        font-size: 1.1em; /* Slightly larger to make the small dot visible, relative to this li's font-size */
        position: absolute;
        left: 1px; 
        top: 0px;
        transition: color 0.2s ease-out;
    }

    ul ul ul > li:hover::before {
        color: var(--text-color);
        transform: none;
    }

    /* --- Ordered List Styling --- */
    ol {
        /* padding-left: 40px; /* Example if you want to control default first-level indentation */
    }

    /* Level 1 OL Items */
    ol > li {
        font-size: 1em; /* Relative to body font-size */
        margin-bottom: 10px; 
        transition: opacity 0.3s ease-out;
        /* Default browser numbering and ::before marker will apply */
        /* If custom marker needed for L1 OL, add here similar to ul > li */
    }

    ol > li::marker {
        transition: color 0.2s ease-out; /* Smooth transition if color changes */
        /* The default color will be inherited from the li text color */
    }

    /* NEW: Hide the ::marker on hover for first-level OL items */
    ol > li:hover::marker {
        color: transparent; /* Makes the marker invisible */
    }

    /* Level 2 OL Container (nested in ul or ol) */
    ol ol,
    ul ol { 
        list-style-type: none;   
        padding-left: 0;         
        margin-top: 8px;         
        margin-bottom: 8px;      
        /* font-size removed from here, applied to li */
        counter-reset: nested-ol-counter; 
    }

    /* Level 2 OL Items */
    ol ol > li,
    ul ol > li { 
        font-size: 1.0em; /* Relative to body font-size */
        position: relative;
        padding-left: 25px;      
        margin-bottom: 8px;      
        counter-increment: nested-ol-counter; 
    }

    ol ol > li::before,
    ul ol > li::before { 
        content: counter(nested-ol-counter) ". "; 
        color: var(--secondary-color);           
        font-weight: normal;                     
        font-size: 1em; /* Relative to this li's font-size */
        position: absolute;
        left: 0;
        top: 0px;
    }

    ol ol > li:hover::before,
    ul ol > li:hover::before { 
        color: var(--primary-color);             
    }

    /* Level 3 OL Container (nested in various ways) */
    ol ol ol,
    ul ol ol,
    ol ul ol,
    ul ul ol {
        list-style-type: none;
        padding-left: 0;
        margin-top: 6px;
        margin-bottom: 6px;
        /* font-size removed from here, applied to li */
        counter-reset: sub-sub-ol-counter;
    }

    /* Level 3 OL Items - Ensuring all 8 combinations for font size */
    ul ul ul > li, /* From UL section, repeated for clarity or combined */
    ul ul ol > li,
    ul ol ul > li,
    ul ol ol > li,
    ol ul ul > li,
    ol ul ol > li,
    ol ol ul > li,
    ol ol ol > li {
        font-size: 0.9em; /* Relative to body font-size */
        position: relative;
        padding-left: 25px;
        margin-bottom: 6px;
        /* counter-increment will be specific to the type of list item (ol vs ul) */
    }
    /* Specific counter-increment for OL L3 items */
    ol ol ol > li,
    ul ol ol > li,
    ol ul ol > li,
    ul ul ol > li { /* Only for OL items */
         counter-increment: sub-sub-ol-counter;
    }


    /* Level 3 OL Markers */
    ol ol ol > li::before,
    ul ol ol > li::before,
    ol ul ol > li::before,
    ul ul ol > li::before {
        content: counter(sub-sub-ol-counter, lower-alpha) ". "; 
        color: var(--footnote-color);
        font-size: 1em; /* Relative to this li's font-size */
        position: absolute;
        left: 0px; /* Adjusted from 1px to align with other numbered lists */
        top: 0px;
        transition: color 0.2s ease-out;
    }

    ol ol ol > li:hover::before,
    ul ol ol > li:hover::before,
    ol ul ol > li:hover::before,
    ul ul ol > li:hover::before {
        color: var(--text-color);
    }

    /* Combining Level 3 UL and OL items for shared properties (font-size, padding, margin) */
    /* This is a more concise way to set common L3 li properties if preferred over listing all 8 */
    ul ul ul > li, ol ol ol > li, ul ol ul > li, ol ul ol > li, 
    ul ul ol > li, ol ul ul > li, ul ol ol > li, ol ol ul > li {
        font-size: 0.9em;
        position: relative;
        padding-left: 25px;
        margin-bottom: 6px;
    }

    code {
        font-family: var(--code-font);
        background-color: var(--code-background);
        padding: 3px 6px;
        border-radius: 4px;
        border: 1px solid var(--code-border);
        color: var(--inline-code-text);
        font-size: 0.95em; /* Relative to parent element's font size */
        transition: all var(--transition-speed) ease;
    }

    code:hover {
        background-color: #252540;
        border-color: var(--primary-color);
    }

    pre {
        background-color: var(--code-background);
        border: 1px solid var(--code-border);
        border-left: 5px solid var(--secondary-color);
        border-radius: 5px;
        padding: 18px;
        overflow-x: auto;
        box-shadow: 2px 2px 8px var(--box-shadow-color);
        font-size: 1em; /* Relative to parent, typically body or container */
        transition: all var(--transition-speed) ease;
    }

    pre:hover {
        border-color: var(--primary-color);
        box-shadow: 0 0 15px rgba(77, 184, 255, 0.3); 
    }

    pre code {
        font-family: var(--code-font);
        background-color: transparent;
        border: none;
        padding: 0;
        color: inherit;
        font-size: inherit; /* Inherits from pre's 1em */
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 25px;
        box-shadow: 2px 2px 8px var(--box-shadow-color);
        transition: transform var(--transition-speed) ease, box-shadow var(--transition-speed) ease;
    }

    table:hover {
        transform: scale(1.005);
        box-shadow: 0 0 15px rgba(77, 184, 255, 0.3); 
    }

    th, td {
        border: 1px solid var(--table-border);
        padding: 12px;
        text-align: left;
        transition: background-color var(--transition-speed) ease;
    }

    th {
        background-color: var(--table-header-bg);
        color: var(--table-header-text);
        font-family: var(--header-font);
        font-size: 1.1em; /* Relative to table's font size (inherited) */
    }

    td {
        background-color: var(--table-cell-bg);
    }

    tr:hover td {
        background-color: #2e2e3e;
    }

    .oracle-specific {
        background-color: var(--oracle-specific-bg);
        border-left: 6px solid var(--oracle-specific-border);
        padding: 12px 15px;
        margin: 18px 0;
        border-radius: 4px;
        transition: all var(--transition-speed) ease, box-shadow var(--transition-speed) ease;
    }

    .oracle-specific:hover {
        transform: translateX(5px);
        box-shadow: 3px 0 10px rgba(255, 140, 0, 0.2), 0 0 15px rgba(77, 184, 255, 0.3); 
    }

    .postgresql-bridge {
        background-color: var(--postgresql-bridge-bg);
        border-left: 6px solid var(--postgresql-bridge-border);
        padding: 12px 15px;
        margin: 18px 0;
        border-radius: 4px;
        transition: all var(--transition-speed) ease;
    }

    .postgresql-bridge:hover {
        transform: translateX(5px);
        box-shadow: 3px 0 10px rgba(0, 193, 118, 0.2);
    }

    .caution {
        background-color: var(--caution-bg);
        border-left: 6px solid var(--caution-border);
        padding: 12px 15px;
        margin: 18px 0;
        border-radius: 4px;
        transition: all var(--transition-speed) ease;
    }

    .caution:hover {
        transform: translateX(5px);
        box-shadow: 3px 0 10px rgba(230, 76, 0, 0.2); 
    }

    .rhyme {
        font-style: italic;
        color: var(--primary-color);
        margin-left: 25px;
        padding: 5px 0;
        border-left: 3px dotted var(--accent-color);
        padding-left: 10px;
        transition: all var(--transition-speed) ease;
    }

    .rhyme:hover {
        color: var(--secondary-color);
        border-left-color: var(--primary-color);
        transform: translateX(3px);
    }

    p > small {
        display: block;
        margin-top: 8px;
        font-size: 0.9em; /* Relative to parent p's font size */
        color: var(--footnote-color);
        transition: color var(--transition-speed) ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @keyframes pulse {
        0% { box-shadow: 0 0 0 0 rgba(77, 184, 255, 0.4); }
        70% { box-shadow: 0 0 0 10px rgba(77, 184, 255, 0); }
        100% { box-shadow: 0 0 0 0 rgba(77, 184, 255, 0); }
    }

    html {
        scroll-behavior: smooth;
    }

    .sql-keyword {
        color: var(--accent-color);
        font-weight: bold;
    }

    .sql-function {
        color: var(--secondary-color);
    }

    .sql-comment {
        color: #7f7f9f;
        font-style: italic;
    }

    @media (max-width: 768px) {
        .container {
            padding: 20px;
            margin: 1rem auto;
        }
        :root {
            --glow-intensity: 0.3; 
        }
        body {
            font-size: 1.1rem; 
            padding: 15px;
        }
        h1 { font-size: 2.4em; }
        h2 { font-size: 1.9em; }
        h3 { font-size: 1.5em; }
        p { font-size: 1.05em; }
    }
</style>


<div class="container">

# PL/SQL Awakening: Foundations of Oracle Programming - Exercises

Welcome, PostgreSQL voyager, to the realm of Oracle's PL/SQL! These exercises are your compass and sextant for navigating the foundational currents of Oracle's procedural language. Your existing SQL strength is a mighty ship, and these practices will hoist the Oracle sails.

_If your PL/SQL seems to ail,_
_These tasks and drills will never fail!_

## Learning Objectives

Upon completing these exercises, you should be able to:

*   Understand and implement the basic block structure of PL/SQL (`DECLARE`, `BEGIN`, `EXCEPTION`, `END`).
*   Declare and use scalar variables, constants, and anchor them to database objects using `%TYPE` and `%ROWTYPE`.
*   Implement conditional logic using `IF-THEN-ELSIF-ELSE` and `CASE` statements/expressions.
*   Control program flow with iterative constructs: basic `LOOP`, `WHILE` loop, and `FOR` loop.
*   Seamlessly integrate SQL (`SELECT INTO`, DML) within PL/SQL blocks.
*   Utilize `DBMS_OUTPUT.PUT_LINE` for basic debugging and displaying information.
*   Appreciate Oracle-specific nuances, especially when contrasting with your PostgreSQL background.
*   Recognize potential pitfalls and write more robust PL/SQL code.
*   Understand the conceptual benefit of Oracle 23ai features like the SQL Transpiler for PL/SQL functions used in SQL.

## Prerequisites & Setup

To make these exercises a breeze,
A bit of knowledge, if you please!

*   **Foundational SQL:** Solid understanding of SQL concepts from "The Original PostgreSQL Course Sequence" (especially Basic and Intermediate SQL).
*   **Oracle Core Syntax:** Familiarity with concepts from the "Key Differences & Core Syntax" and "Date Functions" sections of the "Server Programming with Oracle (DB 23ai) PL/SQL: A Transition Guide for PostgreSQL Users" course.
*   **Oracle Environment:** Access to an Oracle DB 23ai instance (Oracle Live SQL is a great option for many of these, or a local/cloud instance).

### Dataset Guidance

A practice ground, so neat and trim,
For every PL/SQL whim!

Below, you'll find the Oracle SQL script to create and populate the necessary tables for these exercises. It's crucial to run this script in your Oracle environment *before* you start.

<div class="oracle-specific">
<strong>Setup Tip:</strong> You can typically run this script in SQL Developer by opening a new SQL worksheet, pasting the code, and clicking the "Run Script" button (often an icon with a green play button and a page). For SQL*Plus, save it as a `.sql` file and run it using `@your_script_name.sql`. For Oracle Live SQL, paste it into a SQL Worksheet and click "Run".
</div>

The primary tables you'll be working with are:

*   `departments`: Stores department information.
*   `employees`: Stores employee details, including their department, salary, and hire date. The `isActive` column uses the new Oracle 23ai `BOOLEAN` type.
*   `jobGrades`: Defines salary ranges for different job grades.
*   `products`: Contains product information, including stock levels.
*   `salesLog`: A simple table for logging messages, useful for tracking DML operations or debugging.
*   `salesOrders` and `orderItems`: For order-related scenarios.

Relationships are established via foreign keys (e.g., `employees.departmentId` references `departments.departmentId`).

## Exercise Structure Overview

The path to mastery, clear and bright,
Four types of tests, to shed new light!

These exercises are structured to build your understanding progressively:

1.  **Meanings, Values, Relations, and Advantages:** Focus on the core definition and benefits of each concept, especially Oracle's unique take.
2.  **Disadvantages and Pitfalls:** Explore common mistakes and limitations.
3.  **Contrasting with Inefficient Common Solutions:** Compare elegant Oracle solutions with less optimal, often more verbose, alternatives.
4.  **Hardcore Combined Problem:** A capstone challenge integrating multiple concepts.

It's best to try each problem on your own before peeking at the solutions. Experimentation is a grand old teacher!

## Exercises: PL/SQL Fundamentals

<!-- BEGIN EXERCISES SECTION - Problems Only -->

### (i) Meanings, Values, Relations, and Advantages

#### Exercise 1.1: Understanding PL/SQL Block Structure

**Problem:**
Write a basic anonymous PL/SQL block that declares a variable `greeting` of type `VARCHAR2(50)`, assigns it the value 'Hello, Oracle PL/SQL!', and then prints this greeting using `DBMS_OUTPUT.PUT_LINE`. Include a simple exception handler that prints a generic error message if anything goes wrong.

<div class="postgresql-bridge">
<strong>PostgreSQL Bridge:</strong>
In PostgreSQL, you might achieve similar procedural logic using a `DO` block with `RAISE NOTICE` for output. Oracle's PL/SQL block structure (`DECLARE`, `BEGIN`, `EXCEPTION`, `END`) is more formal and feature-rich, especially with its dedicated exception handling section.
</div>

<div class="oracle-specific">
<strong>Oracle Value/Advantage:</strong>
This exercise demonstrates the fundamental structure of PL/SQL, which enforces a clear separation of declarations, executable logic, and error handling. This modularity improves code readability and maintainability.
</div>

#### Exercise 1.2: Using Scalar Variables, %TYPE, and %ROWTYPE

**Problem:**
Write a PL/SQL block that:
1.  Declares a variable `empLastName` using the `%TYPE` attribute to match the `lastName` column of the `employees` table.
2.  Declares a record variable `empRecord` using the `%ROWTYPE` attribute to match the structure of a row in the `employees` table.
3.  Fetches the `lastName` of employee with `employeeId = 101` into `empLastName`.
4.  Fetches the entire row for employee with `employeeId = 102` into `empRecord`.
5.  Prints the fetched last name and the first name and salary from the record.

<div class="postgresql-bridge">
<strong>PostgreSQL Bridge:</strong>
PostgreSQL allows declaring variables with types matching table columns (e.g., `empLastName employees.lastName%TYPE;`) and records matching table rows (e.g., `empRecord employees%ROWTYPE;`). Oracle's syntax and usage are very similar, providing strong typing and maintainability.
</div>

<div class="oracle-specific">
<strong>Oracle Value/Advantage:</strong>
`%TYPE` and `%ROWTYPE` ensure that variables automatically adapt to changes in table column definitions (data type, size), reducing maintenance effort and potential runtime errors due to type mismatches. This is a key advantage for robust code.
</div>

#### Exercise 1.3: Conditional Logic with IF-THEN-ELSIF-ELSE and CASE

**Problem:**
Write a PL/SQL block that retrieves the salary of employee with `employeeId = 103`.
1.  Using an `IF-THEN-ELSIF-ELSE` structure, print:
    *   "High Earner" if salary > 75000.
    *   "Mid Earner" if salary > 65000 and salary <= 75000.
    *   "Standard Earner" otherwise.
2.  Using a `CASE` statement (not a CASE expression within SQL), achieve the same logic and print the result.

<div class="postgresql-bridge">
<strong>PostgreSQL Bridge:</strong>
PostgreSQL's `IF ELSIF ELSE END IF` and `CASE WHEN THEN ELSE END CASE` structures are very similar to Oracle's. This exercise reinforces the syntax in an Oracle context.
</div>

<div class="oracle-specific">
<strong>Oracle Value/Advantage:</strong>
Both `IF` and `CASE` statements provide clear and structured ways to implement conditional logic, making PL/SQL code readable and easy to follow. The `CASE` statement can sometimes be more readable for multiple discrete conditions.
</div>

#### Exercise 1.4: Iterative Control with Basic LOOP, WHILE, and FOR

**Problem:**
1.  **Basic LOOP with EXIT WHEN:** Print numbers from 1 to 3.
2.  **WHILE LOOP:** Print numbers from 1 to 3.
3.  **Numeric FOR LOOP:** Print numbers from 1 to 3.

<div class="postgresql-bridge">
<strong>PostgreSQL Bridge:</strong>
PostgreSQL has `LOOP END LOOP` (with `EXIT WHEN`), `WHILE END LOOP`, and `FOR integer_var IN start .. end LOOP`. Oracle's syntax is nearly identical, making this a practice of Oracle's implementation.
</div>

<div class="oracle-specific">
<strong>Oracle Value/Advantage:</strong>
Oracle PL/SQL offers a comprehensive set of loop structures suitable for various iteration needs. The numeric `FOR` loop is particularly concise for simple counter-based iterations, as it implicitly declares the loop counter.
</div>

#### Exercise 1.5: SQL within PL/SQL (SELECT INTO, DML, DBMS_OUTPUT)

**Problem:**
Write a PL/SQL block that performs the following actions:
1.  Declares a variable `deptName` of type `departments.departmentName%TYPE`.
2.  Uses `SELECT INTO` to retrieve the `departmentName` for `departmentId = 20` into `deptName`.
3.  Prints the retrieved department name using `DBMS_OUTPUT.PUT_LINE`.
4.  Inserts a new row into the `salesLog` table with the message 'Department lookup successful: ' concatenated with `deptName`.
5.  Updates the `location` of department `20` to 'MANCHESTER'.
6.  Prints a confirmation message for the update.
7.  Deletes the newly inserted log entry based on the message.
8.  Prints a confirmation message for the delete.
Assume the department and log table exist.

<div class="postgresql-bridge">
<strong>PostgreSQL Bridge:</strong>
In PostgreSQL functions/DO blocks, you can directly embed SQL. `SELECT INTO` is a common pattern. `DBMS_OUTPUT.PUT_LINE` is Oracle's equivalent of `RAISE NOTICE`.
</div>

<div class="oracle-specific">
<strong>Oracle Value/Advantage:</strong>
Seamless integration of SQL DML and `SELECT INTO` within PL/SQL blocks is a core strength, allowing complex business logic to be implemented close to the data. `DBMS_OUTPUT` is invaluable for debugging. The SQL Transpiler in 23ai might optimize simple PL/SQL functions with embedded SQL when they are called from SQL.
</div>

---

### (ii) Disadvantages and Pitfalls

#### Exercise 2.1: PL/SQL Block - Unhandled Exceptions Pitfall

**Problem:**
Write a PL/SQL block that attempts to select `salary` into a `NUMBER` variable for an `employeeId` that does not exist (e.g., 999). Do *not* include an `EXCEPTION` block initially. Observe the error. Then, modify the block to include a `WHEN OTHERS THEN` handler that prints a generic error message.

<div class="caution">
<strong>Disadvantage/Pitfall:</strong>
Without an `EXCEPTION` block, a runtime error (like `NO_DATA_FOUND`) will halt the PL/SQL block's execution and propagate the error to the calling environment. This is often undesirable in production applications where graceful error handling is needed. Even with a `WHEN OTHERS` handler, not knowing the specific error can make debugging harder.
</div>

#### Exercise 2.2: Variables & Constants - %TYPE/%ROWTYPE and Dropped Columns

**Problem:**
1. Create a temporary table `tempEmployees` by copying `employeeId`, `firstName`, `lastName`, `salary` from `employees`.
2. Write a PL/SQL block that declares a record `empRec tempEmployees%ROWTYPE` and selects data into it. Print `empRec.salary`.
3. Outside the PL/SQL block, alter `tempEmployees` to drop the `salary` column.
4. Re-run the PL/SQL block. Observe the error.

<div class="caution">
<strong>Disadvantage/Pitfall:</strong>
While `%ROWTYPE` adapts to data type changes or column additions, if a column referenced by the PL/SQL code (either directly or via `%ROWTYPE` field access) is dropped from the table, the PL/SQL block will become invalid and fail at compile-time or runtime when it's recompiled/executed. The block needs to be manually updated.
</div>

#### Exercise 2.3: Conditional Control - CASE Statement without ELSE and No Match

**Problem:**
Write a PL/SQL block that uses a `CASE` statement to categorize an employee's `jobTitle`.
Declare a variable `jobCategory VARCHAR2(30)`.
Fetch the `jobTitle` for `employeeId = 101` ('Clerk').
The `CASE` statement should have `WHEN` clauses for 'Sales Manager' and 'Developer', but *not* for 'Clerk', and *no* `ELSE` clause.
Attempt to print `jobCategory`. What happens?

<div class="caution">
<strong>Disadvantage/Pitfall:</strong>
If a `CASE` statement does not find any matching `WHEN` condition and there is no `ELSE` clause, it raises a `CASE_NOT_FOUND` exception (ORA-06592). This must be handled if such scenarios are possible.
</div>

#### Exercise 2.4: Iterative Control - Infinite Basic LOOP

**Problem:**
Write a PL/SQL block using a basic `LOOP` that intends to print a counter from 1 to 5. Deliberately forget to include the `EXIT` condition or the counter increment. What is the pitfall? (You might need to manually stop execution in your SQL client). Then, correct the loop.

<div class="caution">
<strong>Disadvantage/Pitfall:</strong>
A basic `LOOP` without a proper `EXIT` condition (or a condition that never becomes true due to logic errors like not incrementing a counter) will result in an infinite loop, consuming resources and potentially requiring manual intervention to stop.
</div>

#### Exercise 2.5: SQL within PL/SQL - `SELECT INTO` with Multiple Rows

**Problem:**
Write a PL/SQL block that attempts to use `SELECT INTO` to fetch `lastName` from the `employees` table where `departmentId = 40` into a single scalar variable `empLastName employees.lastName%TYPE`. What is the pitfall? Handle the specific exception.

<div class="caution">
<strong>Disadvantage/Pitfall:</strong>
If a `SELECT INTO` statement returns more than one row, it raises the predefined `TOO_MANY_ROWS` exception (ORA-01422). `SELECT INTO` is designed for queries expected to return exactly one row.
</div>

---

### (iii) Contrasting with Inefficient Common Solutions

#### Exercise 3.1: Inefficient Conditional Salary Update

**Problem:**
An employee's salary needs to be updated based on their `jobTitle`.
*   'Clerk': +5%
*   'Developer': +7%
*   'Sales Manager': +10%

**Inefficient Solution Approach:** Write separate `UPDATE` statements for each `jobTitle` within individual IF conditions in PL/SQL.
**Efficient Oracle-idiomatic Solution:** Use a single `UPDATE` statement with a `CASE` expression directly in the SQL.

Demonstrate both approaches. Explain why the second is better.

<div class="oracle-specific">
<strong>Contrast Focus:</strong>
The inefficient PL/SQL approach involves multiple context switches between PL/SQL and SQL engines if done iteratively for many employees, or multiple separate DML statements. The efficient SQL approach performs the conditional logic within a single SQL statement, reducing overhead and often allowing for better optimization by the SQL engine.
</div>

#### Exercise 3.2: Inefficient Row-by-Row Processing vs. SQL JOIN

**Problem:**
You need to find the `departmentName` for each employee in the `employees` table and print `employeeId`, `lastName`, and `departmentName`.

**Inefficient Solution Approach (Common for procedural thinkers):** Loop through each employee, and inside the loop, execute a separate `SELECT` statement to fetch the department name for that employee's `departmentId`.
**Efficient Oracle-idiomatic Solution:** Use a single SQL `SELECT` statement with a `JOIN` between `employees` and `departments`. (If PL/SQL is strictly required for some other processing, fetch all necessary data in one go using a cursor FOR loop on the joined query).

Demonstrate both. Explain why the SQL `JOIN` is superior.

<div class="oracle-specific">
<strong>Contrast Focus:</strong>
The "row-by-row" (often called "RBAR" - Row By Agonizing Row) processing in the inefficient PL/SQL solution is a classic anti-pattern. It leads to excessive context switches and fails to leverage the power of set-based SQL processing. A single SQL JOIN is almost always vastly more performant.
</div>

---

### (iv) Hardcore Combined Problem

**Problem Statement:**
You are tasked with generating a summary report and performing some data updates for employees. Create a single PL/SQL anonymous block to achieve the following:

1.  **Declarations:**
    *   Declare a constant `bonusThresholdDate` of type `DATE`, initialized to '01-JAN-2021'.
    *   Declare a variable `vProcessedCount` of type `PLS_INTEGER`, initialized to 0.
    *   Declare a record `empBonusInfo` with fields: `empId NUMBER`, `fullName VARCHAR2(100)`, `yearsOfService NUMBER`, `potentialBonus NUMBER(10,2)`, `departmentLocation VARCHAR2(100)`.
    *   Declare an XMLTYPE variable `employeeReportXML`.
    *   Declare a BOOLEAN variable `isHighPerformer` initialized to FALSE (Oracle 23ai `BOOLEAN` type).

2.  **Processing Logic (within a loop for employees in department 'IT' or 'SALES'):**
    *   For each employee in the 'IT' or 'SALES' departments hired *before* `bonusThresholdDate`:
        *   Increment `vProcessedCount`.
        *   Concatenate `firstName` and `lastName` into `empBonusInfo.fullName`.
        *   Calculate `empBonusInfo.yearsOfService` as the integer part of years between their `hireDate` and `SYSDATE`. (Hint: `MONTHS_BETWEEN` / 12, `TRUNC`).
        *   Determine `empBonusInfo.potentialBonus` based on `jobTitle` using a `CASE` expression:
            *   'IT Manager': salary * 0.15
            *   'Sales Manager': salary * 0.20
            *   'Developer': salary * 0.10
            *   'Sales Representative': salary * 0.12
            *   Others in IT/Sales: salary * 0.05
        *   Using `SELECT INTO`, fetch the `location` of their department into `empBonusInfo.departmentLocation`.
        *   **Conditional Update & Output:**
            *   If `yearsOfService` is greater than 3 AND `potentialBonus` is greater than 10000:
                *   Set `isHighPerformer` to `TRUE`.
                *   Update the employee's `commissionPct` by adding 0.01 to their current commission (use `NVL` to handle `NULL` commission, treating `NULL` as 0 for addition). Cap the new commission at 0.25.
                *   Log a message to `salesLog` like: 'High performer bonus review for [fullName], New Commission: [new_commission_value]'.
                *   Print (DBMS_OUTPUT) `empBonusInfo.fullName`, `empBonusInfo.yearsOfService`, `empBonusInfo.potentialBonus`, `empBonusInfo.departmentLocation`, and "High Performer".
            *   Else:
                *   Set `isHighPerformer` to `FALSE`.
                *   Log a message to `salesLog` like: 'Standard review for [fullName]'.
                *   Print (DBMS_OUTPUT) `empBonusInfo.fullName`, `empBonusInfo.yearsOfService`, `empBonusInfo.potentialBonus`, `empBonusInfo.departmentLocation`, and "Standard Performer".

3.  **XML Generation (after the loop):**
    *   Construct a simple XML document in `employeeReportXML` containing a root element `<EmployeeBonusReport>` with child elements `<ProcessedCount>` holding the value of `vProcessedCount`. (Hint: `XMLElement`, `XMLForest`).
    *   Print this generated XML using `DBMS_OUTPUT.PUT_LINE(employeeReportXML.getClobVal());`.

4.  **Exception Handling:**
    *   Include a `NO_DATA_FOUND` handler in case an employee's department location cannot be found (though unlikely with FK).
    *   Include a `WHEN OTHERS` handler to catch any other unexpected errors, printing the error code and message.

5.  **Transaction Control:**
    *   After the loop and XML generation, if no errors occurred, `COMMIT` the changes. Otherwise, `ROLLBACK`.

<div class="oracle-specific">
<strong>Note on SQL Transpiler:</strong> While not directly coded for, the parts of this PL/SQL block that involve calculations and assignments are standard procedural logic. If parts of this logic were encapsulated in a PL/SQL function *called from a SQL query*, the SQL Transpiler could potentially optimize those function calls. The primary focus here is on demonstrating the PL/SQL fundamentals.
</div>
<div class="postgresql-bridge">
<strong>Bridging Concepts from PostgreSQL / Previous Oracle Concepts:</strong>
This problem uses basic SQL (SELECT, UPDATE), conditional logic, loops, and date functions similar to PostgreSQL. It emphasizes Oracle's PL/SQL block structure, `%TYPE`/`%ROWTYPE`, `NVL` for NULL handling (common in Oracle), DML within PL/SQL, and Oracle's `XMLTYPE` for XML manipulation.
</div>

<!-- END EXERCISES SECTION -->

## Tips for Success & Learning

To conquer tasks, both big and small,
Heed these wise tips, stand strong and tall!

*   **Break It Down:** For complex problems (especially the "Hardcore" one), tackle one requirement at a time. Test each part before moving on.
*   **Experiment:** Don't just aim for the solution. Try variations. What if a condition changes? What if a value is NULL? This deepens understanding.
*   **`SET SERVEROUTPUT ON`:** This is your best friend for seeing `DBMS_OUTPUT.PUT_LINE` messages. Use it in SQL Developer, SQL*Plus, or ensure your Oracle Live SQL session is configured for output.
*   **Oracle Documentation:** When in doubt, the official Oracle documentation is the ultimate source of truth. It's vast, but learning to navigate it is a key skill.
*   **Error Messages are Clues:** Oracle's error messages (e.g., ORA-xxxxx, PLS-xxxxx) can be cryptic at first, but they provide valuable clues. Search for them online or in the Oracle docs.
*   **Rollback Often During Testing:** When practicing DML, use `ROLLBACK` frequently to revert your changes, so your dataset remains consistent for subsequent tests.
*   **Think in Sets (SQL) vs. Rows (PL/SQL):** Remember that SQL excels at set-based operations. While PL/SQL allows row-by-row processing, always consider if a pure SQL solution might be more efficient, especially for data retrieval and bulk updates.

<div class="rhyme">
If errors loom and make you frown,
Don't let despair just weigh you down.
Debug with care, line by line,
Success in PL/SQL, will be thine!
</div>

## Conclusion & Next Steps

Well done on embarking on these PL/SQL foundational exercises! By working through them, you've taken significant steps in bridging your PostgreSQL knowledge to the Oracle ecosystem and started to harness the procedural power of PL/SQL.

_The blocks you've built, the loops you've run,_
_Your PL/SQL journey has begun!_

The concepts covered here—block structure, variables, control flow, and SQL integration—are the bedrock upon which more advanced PL/SQL programming is built.

**Next, you'll venture into:**

*   **Cursors:** For more granular control over multi-row query results.
*   **Stored Procedures & Functions:** To encapsulate logic and create reusable code units.
*   **Packages:** Oracle's powerful mechanism for organizing related PL/SQL objects.

Keep practicing, keep exploring, and you'll become proficient in Oracle PL/SQL in no time!

</div>