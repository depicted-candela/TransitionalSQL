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
        p { font-size: 1.05em; } /* li rule removed, font sizes for li are now level-specific and will scale with body's 1.1rem */
    }
</style>

<div class="container">

# PL/SQL Awakening: Foundations of Oracle Programming - Solutions

Welcome, PostgreSQL voyager, to the realm of Oracle's PL/SQL! These exercises, now with their solutions, are your compass and sextant for navigating the foundational currents of Oracle's procedural language. Your existing SQL strength is a mighty ship, and these practices will hoist the Oracle sails.

_With solutions clear, your path is made,_
_No PL/SQL puzzle leaves you swayed!_

## Learning Objectives

By reviewing these solutions and working through the exercises, you should be able to:

*   Confirm your understanding of the basic block structure of PL/SQL (`DECLARE`, `BEGIN`, `EXCEPTION`, `END`).
*   Verify your ability to declare and use scalar variables, constants, and anchor them using `%TYPE` and `%ROWTYPE`.
*   Check your implementation of conditional logic using `IF-THEN-ELSIF-ELSE` and `CASE` statements/expressions.
*   Assess your control over program flow with iterative constructs: basic `LOOP`, `WHILE` loop, and `FOR` loop.
*   Validate your integration of SQL (`SELECT INTO`, DML) within PL/SQL blocks.
*   Confirm effective use of `DBMS_OUTPUT.PUT_LINE` for basic debugging and displaying information.
*   Reinforce Oracle-specific nuances, especially when contrasting with your PostgreSQL background.
*   Identify and understand solutions to potential pitfalls in PL/SQL code.
*   Appreciate the conceptual benefit of Oracle 23ai features like the SQL Transpiler for PL/SQL functions used in SQL.

## Prerequisites & Setup

To make these exercises a breeze,
A bit of knowledge, if you please!

*   **Foundational SQL:** Solid understanding of SQL concepts from "The Original PostgreSQL Course Sequence" (especially Basic and Intermediate SQL).
*   **Oracle Core Syntax:** Familiarity with concepts from the "Key Differences & Core Syntax" and "Date Functions" sections of the "Server Programming with Oracle (DB 23ai) PL/SQL: A Transition Guide for PostgreSQL Users" course.
*   **Oracle Environment:** Access to an Oracle DB 23ai instance (Oracle Live SQL is a great option for many of these, or a local/cloud instance).

### Dataset Guidance

A practice ground, so neat and trim,
For every PL/SQL whim!

The Oracle SQL script below defines and populates the necessary tables for these exercises. It's crucial to run this script in your Oracle environment *before* you attempt the exercises or review the solutions.

<div class="oracle-specific">
<strong>Setup Tip:</strong> You can typically run this script in SQL Developer by opening a new SQL worksheet, pasting the code, and clicking the "Run Script" button (often an icon with a green play button and a page). For SQL*Plus, save it as a `.sql` file and run it using `@dataset.sql`. For Oracle Live SQL, paste it into a SQL Worksheet and click "Run". Ensure `SERVEROUTPUT` is enabled to see `DBMS_OUTPUT.PUT_LINE` results.
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

## Solutions to PL/SQL Fundamentals Exercises

Below are the solutions to the exercises. Compare them with your attempts to solidify your understanding.

---

### (i) Meanings, Values, Relations, and Advantages - Solutions

#### Solution for Exercise 1.1: Understanding PL/SQL Block Structure
```sql
SET SERVEROUTPUT ON;

DECLARE
    greeting VARCHAR2(50);
BEGIN
    greeting := 'Hello, Oracle PL/SQL!';
    DBMS_OUTPUT.PUT_LINE(greeting);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 1.2: Using Scalar Variables, %TYPE, and %ROWTYPE
```sql
SET SERVEROUTPUT ON;

DECLARE
    empLastName employees.lastName%TYPE;
    empRecord employees%ROWTYPE;
    vEmployeeId1 NUMBER := 101;
    vEmployeeId2 NUMBER := 102;
BEGIN
    -- Fetch lastName for employee 101
    SELECT lastName
    INTO empLastName
    FROM employees
    WHERE employeeId = vEmployeeId1;

    DBMS_OUTPUT.PUT_LINE('Last name of employee ' || vEmployeeId1 || ': ' || empLastName);

    -- Fetch entire row for employee 102
    SELECT *
    INTO empRecord
    FROM employees
    WHERE employeeId = vEmployeeId2;

    DBMS_OUTPUT.PUT_LINE('Details for employee ' || vEmployeeId2 || ':');
    DBMS_OUTPUT.PUT_LINE('  First Name: ' || empRecord.firstName);
    DBMS_OUTPUT.PUT_LINE('  Salary: ' || empRecord.salary);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 1.3: Conditional Logic with IF-THEN-ELSIF-ELSE and CASE
```sql
SET SERVEROUTPUT ON;

DECLARE
    empSalary employees.salary%TYPE;
    empId NUMBER := 103;
    salaryCategory VARCHAR2(20);
BEGIN
    SELECT salary
    INTO empSalary
    FROM employees
    WHERE employeeId = empId;

    DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' salary: ' || empSalary);

    -- Using IF-THEN-ELSIF-ELSE
    DBMS_OUTPUT.PUT_LINE('--- Using IF-THEN-ELSIF-ELSE ---');
    IF empSalary > 75000 THEN
        DBMS_OUTPUT.PUT_LINE('Category: High Earner');
    ELSIF empSalary > 65000 THEN -- No need to check <= 75000 due to IF structure
        DBMS_OUTPUT.PUT_LINE('Category: Mid Earner');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Category: Standard Earner');
    END IF;

    -- Using CASE Statement
    DBMS_OUTPUT.PUT_LINE('--- Using CASE Statement ---');
    CASE
        WHEN empSalary > 75000 THEN
            salaryCategory := 'High Earner';
        WHEN empSalary > 65000 THEN
            salaryCategory := 'Mid Earner';
        ELSE
            salaryCategory := 'Standard Earner';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('Category: ' || salaryCategory);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 1.4: Iterative Control with Basic LOOP, WHILE, and FOR
```sql
SET SERVEROUTPUT ON;

DECLARE
    counter NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Basic LOOP ---');
    counter := 1;
    LOOP
        DBMS_OUTPUT.PUT_LINE(counter);
        EXIT WHEN counter >= 3;
        counter := counter + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- WHILE LOOP ---');
    counter := 1;
    WHILE counter <= 3 LOOP
        DBMS_OUTPUT.PUT_LINE(counter);
        counter := counter + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Numeric FOR LOOP ---');
    FOR i IN 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/
```

#### Solution for Exercise 1.5: SQL within PL/SQL (SELECT INTO, DML, DBMS_OUTPUT)
```sql
SET SERVEROUTPUT ON;

DECLARE
    deptName departments.departmentName%TYPE;
    vDepartmentId NUMBER := 20;
    logMessageContent VARCHAR2(200);
BEGIN
    -- 1. SELECT INTO
    SELECT departmentName
    INTO deptName
    FROM departments
    WHERE departmentId = vDepartmentId;

    -- 2. DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Retrieved Department: ' || deptName);

    -- 3. INSERT
    logMessageContent := 'Department lookup successful: ' || deptName;
    INSERT INTO salesLog (logMessage) VALUES (logMessageContent);
    DBMS_OUTPUT.PUT_LINE('Log entry inserted.');

    -- 4. UPDATE
    UPDATE departments
    SET location = 'MANCHESTER'
    WHERE departmentId = vDepartmentId;
    DBMS_OUTPUT.PUT_LINE('Department ' || vDepartmentId || ' location updated to MANCHESTER.');
    
    -- 5. DELETE
    DELETE FROM salesLog WHERE logMessage = logMessageContent;
    DBMS_OUTPUT.PUT_LINE('Log entry deleted.');

    -- Rollback changes for subsequent runs of this script to work consistently
    ROLLBACK; 
    DBMS_OUTPUT.PUT_LINE('Changes rolled back for script re-runnability.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Department ' || vDepartmentId || ' not found.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK; -- Rollback in case of other errors
END;
/
```

---

### (ii) Disadvantages and Pitfalls - Solutions

#### Solution for Exercise 2.1: PL/SQL Block - Unhandled Exceptions Pitfall
**Solution (Initial - to show error):**
```sql
SET SERVEROUTPUT ON;

DECLARE
    empSalary employees.salary%TYPE;
BEGIN
    SELECT salary
    INTO empSalary
    FROM employees
    WHERE employeeId = 999; -- This employee does not exist

    DBMS_OUTPUT.PUT_LINE('Salary: ' || empSalary);
END;
/
-- Expected ORA-01403: no data found
```

**Solution (Modified - with EXCEPTION block):**
```sql
SET SERVEROUTPUT ON;

DECLARE
    empSalary employees.salary%TYPE;
BEGIN
    SELECT salary
    INTO empSalary
    FROM employees
    WHERE employeeId = 999; -- This employee does not exist

    DBMS_OUTPUT.PUT_LINE('Salary: ' || empSalary); -- This line won't be reached
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pitfall: Employee with ID 999 not found. NO_DATA_FOUND raised.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 2.2: Variables & Constants - %TYPE/%ROWTYPE and Dropped Columns
```sql
SET SERVEROUTPUT ON;

-- Step 1: Create temporary table
CREATE TABLE tempEmployees AS
SELECT employeeId, firstName, lastName, salary FROM employees WHERE 1=2; 

INSERT INTO tempEmployees (employeeId, firstName, lastName, salary)
SELECT employeeId, firstName, lastName, salary FROM employees WHERE ROWNUM <=1;
COMMIT;


-- Step 2: PL/SQL block (initial run)
DECLARE
    empRec tempEmployees%ROWTYPE;
BEGIN
    SELECT *
    INTO empRec
    FROM tempEmployees
    WHERE employeeId = (SELECT MIN(employeeId) FROM tempEmployees); -- Select any existing employee

    IF empRec.employeeId IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Initial run - Employee Salary: ' || empRec.salary);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Initial run - No employee found in tempEmployees.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Initial run - No employee found in tempEmployees.');
END;
/

-- Step 3: Drop column (outside PL/SQL)
ALTER TABLE tempEmployees DROP COLUMN salary;


-- Step 4: Re-run PL/SQL block
-- This block will now likely fail when recompiled because empRec.salary no longer exists.
DECLARE
    empRec tempEmployees%ROWTYPE; -- %ROWTYPE now reflects table without salary
BEGIN
    SELECT employeeId, firstName, lastName -- Must explicitly list columns now
    INTO empRec.employeeId, empRec.firstName, empRec.lastName -- Assign to available fields
    FROM tempEmployees
    WHERE employeeId = (SELECT MIN(employeeId) FROM tempEmployees);

    DBMS_OUTPUT.PUT_LINE('After column drop - Employee ID: ' || empRec.employeeId);
    -- Accessing empRec.salary would cause PLS-00302: component 'SALARY' must be declared
    -- DBMS_OUTPUT.PUT_LINE(empRec.salary); 
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error after column drop: ' || SQLERRM);
END;
/

-- Cleanup
DROP TABLE tempEmployees;
```
**Note:** The re-run of the PL/SQL block after dropping the column will fail compilation if `empRec.salary` is still referenced. The provided solution shows how you'd have to adjust the `SELECT INTO` if you were to avoid the compilation error, but typically the goal is to show the error that would occur from not updating the PL/SQL code.

#### Solution for Exercise 2.3: Conditional Control - CASE Statement without ELSE and No Match
```sql
SET SERVEROUTPUT ON;

DECLARE
    empJobTitle employees.jobTitle%TYPE;
    jobCategory VARCHAR2(30);
    vEmployeeId NUMBER := 101; -- Employee with jobTitle 'Clerk'
BEGIN
    SELECT jobTitle
    INTO empJobTitle
    FROM employees
    WHERE employeeId = vEmployeeId;

    DBMS_OUTPUT.PUT_LINE('Employee ' || vEmployeeId || ' job title: ' || empJobTitle);

    CASE empJobTitle
        WHEN 'Sales Manager' THEN
            jobCategory := 'Management';
        WHEN 'Developer' THEN
            jobCategory := 'Technical';
        -- No WHEN for 'Clerk' and no ELSE clause
    END CASE;

    DBMS_OUTPUT.PUT_LINE('Job Category: ' || jobCategory); -- This might not be reached

EXCEPTION
    WHEN CASE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pitfall: CASE_NOT_FOUND exception raised. Job title not covered and no ELSE.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

#### Solution for Exercise 2.4: Iterative Control - Infinite Basic LOOP
**Solution (Illustrating Pitfall - DO NOT RUN IN PRODUCTION without care):**
```sql
-- SET SERVEROUTPUT ON;
-- 
-- DECLARE
--    counter NUMBER := 1;
-- BEGIN
--    DBMS_OUTPUT.PUT_LINE('--- Infinite LOOP Pitfall (DO NOT RUN UNCONTROLLED) ---');
--    LOOP
--        DBMS_OUTPUT.PUT_LINE('Counter: ' || counter);
--        -- counter := counter + 1; -- Increment forgotten
--        -- EXIT WHEN counter > 5; -- Exit condition forgotten or flawed
--    END LOOP;
-- END;
-- /
```
**Solution (Corrected):**
```sql
SET SERVEROUTPUT ON;

DECLARE
    counter NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Corrected Basic LOOP ---');
    LOOP
        DBMS_OUTPUT.PUT_LINE('Counter: ' || counter);
        counter := counter + 1; -- Increment added
        EXIT WHEN counter > 5; -- Exit condition added
    END LOOP;
END;
/
```

#### Solution for Exercise 2.5: SQL within PL/SQL - `SELECT INTO` with Multiple Rows
```sql
SET SERVEROUTPUT ON;

DECLARE
    empLastName employees.lastName%TYPE;
    vDepartmentId NUMBER := 40; -- This department has multiple employees
BEGIN
    DBMS_OUTPUT.PUT_LINE('Attempting to select last names from department ' || vDepartmentId);
    SELECT lastName
    INTO empLastName
    FROM employees
    WHERE departmentId = vDepartmentId;

    DBMS_OUTPUT.PUT_LINE('Last Name: ' || empLastName); -- This line won't be reached
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Pitfall: TOO_MANY_ROWS exception. Department ' || vDepartmentId || ' has multiple employees.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

---

### (iii) Contrasting with Inefficient Common Solutions - Solutions

#### Solution for Exercise 3.1: Inefficient Conditional Salary Update
```sql
SET SERVEROUTPUT ON;

-- Setup: Create a copy for safe updates
CREATE TABLE employeesTemp AS SELECT * FROM employees;
COMMIT;

-- Inefficient PL/SQL approach
DECLARE
    empId employeesTemp.employeeId%TYPE;
    empJob employeesTemp.jobTitle%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inefficient Conditional Update (using multiple IFs and UPDATEs) ---');
    
    FOR empRec IN (SELECT employeeId, jobTitle FROM employeesTemp WHERE jobTitle IN ('Clerk', 'Developer', 'Sales Manager')) LOOP
        empId := empRec.employeeId;
        empJob := empRec.jobTitle;

        IF empJob = 'Clerk' THEN
            UPDATE employeesTemp SET salary = salary * 1.05 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Clerk salary for ' || empId);
        ELSIF empJob = 'Developer' THEN
            UPDATE employeesTemp SET salary = salary * 1.07 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Developer salary for ' || empId);
        ELSIF empJob = 'Sales Manager' THEN
            UPDATE employeesTemp SET salary = salary * 1.10 WHERE employeeId = empId;
            DBMS_OUTPUT.PUT_LINE('Updated Sales Manager salary for ' || empId);
        END IF;
    END LOOP;
    
    -- Verification
    FOR r_emp IN (SELECT employeeId, jobTitle, salary FROM employeesTemp WHERE employeeId IN (101, 102, 103)) LOOP
        DBMS_OUTPUT.PUT_LINE(r_emp.jobTitle || ' (' || r_emp.employeeId || ') new salary: ' || r_emp.salary);
    END LOOP;

    ROLLBACK; -- Revert changes made by inefficient approach
    DBMS_OUTPUT.PUT_LINE('Inefficient changes rolled back.');
END;
/

-- Re-populate employeesTemp for the efficient approach or use original table
DROP TABLE employeesTemp;
CREATE TABLE employeesTemp AS SELECT * FROM employees;
COMMIT;

-- Efficient Oracle-idiomatic SQL approach
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Efficient Conditional Update (single UPDATE with CASE) ---');

    UPDATE employeesTemp
    SET salary = salary *
        CASE jobTitle
            WHEN 'Clerk' THEN 1.05
            WHEN 'Developer' THEN 1.07
            WHEN 'Sales Manager' THEN 1.10
            ELSE 1.00 -- No change for others
        END
    WHERE jobTitle IN ('Clerk', 'Developer', 'Sales Manager');

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' employee(s) salaries potentially updated.');

    -- Verification
    FOR empRec IN (SELECT employeeId, firstName, lastName, jobTitle, salary FROM employeesTemp WHERE employeeId IN (101, 102, 103)) LOOP
        DBMS_OUTPUT.PUT_LINE(
            empRec.firstName || ' ' || empRec.lastName || 
            ' (' || empRec.jobTitle || ') new salary: ' || empRec.salary
        );
    END LOOP;
    
    ROLLBACK; -- Revert changes
    DBMS_OUTPUT.PUT_LINE('Efficient changes rolled back.');
END;
/

-- Cleanup
DROP TABLE employeesTemp;
```

#### Solution for Exercise 3.2: Inefficient Row-by-Row Processing vs. SQL JOIN
```sql
SET SERVEROUTPUT ON;

-- Inefficient PL/SQL row-by-row approach
DECLARE
    deptName departments.departmentName%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inefficient Row-by-Row Department Lookup ---');
    FOR empRec IN (SELECT employeeId, lastName, departmentId FROM employees ORDER BY employeeId) LOOP
        BEGIN -- Inner block for individual SELECT INTO exception handling
            SELECT departmentName
            INTO deptName
            FROM departments
            WHERE departmentId = empRec.departmentId;

            DBMS_OUTPUT.PUT_LINE(
                'EmpID: ' || empRec.employeeId ||
                ', Name: ' || empRec.lastName ||
                ', Dept: ' || deptName
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE(
                    'EmpID: ' || empRec.employeeId ||
                    ', Name: ' || empRec.lastName ||
                    ', Dept: NOT FOUND'
                );
        END;
    END LOOP;
END;
/

-- Efficient Oracle-idiomatic SQL JOIN approach (demonstrated via PL/SQL FOR loop for output)
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Efficient SQL JOIN Approach ---');
    FOR rec IN (
        SELECT e.employeeId, e.lastName, d.departmentName
        FROM employees e
        LEFT JOIN departments d ON e.departmentId = d.departmentId -- LEFT JOIN to include employees without departments
        ORDER BY e.employeeId
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'EmpID: ' || rec.employeeId ||
            ', Name: ' || rec.lastName ||
            ', Dept: ' || NVL(rec.departmentName, 'N/A')
        );
    END LOOP;
END;
/```

---

### (iv) Hardcore Combined Problem - Solution
```sql
SET SERVEROUTPUT ON;
SET DEFINE OFF; 

DECLARE
    -- Constants
    bonusThresholdDate CONSTANT DATE := TO_DATE('01-JAN-2021', 'YYYY-MM-DD');

    -- Variables
    vProcessedCount PLS_INTEGER := 0;

    -- Record for bonus info
    TYPE typeEmpBonusInfo IS RECORD (
        empId employees.employeeId%TYPE,
        fullName VARCHAR2(101), 
        yearsOfService NUMBER,
        potentialBonus NUMBER(10,2),
        departmentLocation departments.location%TYPE
    );
    empBonusInfo typeEmpBonusInfo;

    employeeReportXML XMLTYPE;
    isHighPerformer BOOLEAN := FALSE;

    -- For DML operations
    vNewCommission employees.commissionPct%TYPE;
    logMessage VARCHAR2(255);

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Employee Bonus Processing ---');

    FOR emp IN (
        SELECT e.employeeId, e.firstName, e.lastName, e.hireDate, e.jobTitle, e.salary, e.commissionPct, e.departmentId, d.departmentName AS deptNameActual
        FROM employees e
        JOIN departments d ON e.departmentId = d.departmentId
        WHERE d.departmentName IN ('IT', 'SALES') AND e.hireDate < bonusThresholdDate AND e.isActive = TRUE
        ORDER BY e.employeeId
    ) LOOP
        vProcessedCount := vProcessedCount + 1;

        empBonusInfo.empId := emp.employeeId;
        empBonusInfo.fullName := emp.firstName || ' ' || emp.lastName;
        empBonusInfo.yearsOfService := TRUNC(MONTHS_BETWEEN(SYSDATE, emp.hireDate) / 12);

        CASE emp.jobTitle
            WHEN 'IT Manager' THEN empBonusInfo.potentialBonus := emp.salary * 0.15;
            WHEN 'Sales Manager' THEN empBonusInfo.potentialBonus := emp.salary * 0.20;
            WHEN 'Developer' THEN empBonusInfo.potentialBonus := emp.salary * 0.10;
            WHEN 'Sales Representative' THEN empBonusInfo.potentialBonus := emp.salary * 0.12;
            ELSE empBonusInfo.potentialBonus := emp.salary * 0.05;
        END CASE;

        BEGIN
            SELECT location
            INTO empBonusInfo.departmentLocation
            FROM departments
            WHERE departmentId = emp.departmentId;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                empBonusInfo.departmentLocation := 'UNKNOWN_LOCATION_ERROR';
                DBMS_OUTPUT.PUT_LINE('Warning: Department location not found for employee ID ' || emp.employeeId || '. Department ID: ' || emp.departmentId);
        END;

        isHighPerformer := FALSE; -- Reset for each employee

        IF empBonusInfo.yearsOfService > 3 AND empBonusInfo.potentialBonus > 10000 THEN
            isHighPerformer := TRUE;
            
            vNewCommission := NVL(emp.commissionPct, 0) + 0.01;
            IF vNewCommission > 0.25 THEN
                vNewCommission := 0.25;
            END IF;

            UPDATE employees
            SET commissionPct = vNewCommission
            WHERE employeeId = emp.employeeId;

            logMessage := 'High performer bonus review for ' || empBonusInfo.fullName || ', New Commission: ' || TO_CHAR(vNewCommission);
            INSERT INTO salesLog (logMessage) VALUES (logMessage);

            DBMS_OUTPUT.PUT_LINE(
                empBonusInfo.fullName || 
                ' | Years: ' || empBonusInfo.yearsOfService ||
                ' | Bonus: ' || empBonusInfo.potentialBonus ||
                ' | Location: ' || empBonusInfo.departmentLocation ||
                ' | Status: High Performer, Commission Updated to ' || vNewCommission
            );
        ELSE
            logMessage := 'Standard review for ' || empBonusInfo.fullName;
            INSERT INTO salesLog (logMessage) VALUES (logMessage);
            
            DBMS_OUTPUT.PUT_LINE(
                empBonusInfo.fullName || 
                ' | Years: ' || empBonusInfo.yearsOfService ||
                ' | Bonus: ' || empBonusInfo.potentialBonus ||
                ' | Location: ' || empBonusInfo.departmentLocation ||
                ' | Status: Standard Performer'
            );
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Finished Employee Bonus Processing ---');
    DBMS_OUTPUT.PUT_LINE('Total Employees Processed: ' || vProcessedCount);

    -- XML Generation
    SELECT XMLElement("EmployeeBonusReport",
               XMLElement("ProcessedCount", vProcessedCount)
           )
    INTO employeeReportXML
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- XML Report ---');
    DBMS_OUTPUT.PUT_LINE(employeeReportXML.getClobVal());

    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Changes committed successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN -- Should ideally be caught inside the loop if a specific SELECT INTO fails, this is a broader catch.
        DBMS_OUTPUT.PUT_LINE('Error: A required data element was not found during processing.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A critical error occurred: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK;
END;
/

-- Query to verify salesLog (optional, run separately after execution)
-- SELECT * FROM salesLog ORDER BY logTime DESC;
-- Query to verify employee commission changes (optional, run separately after execution)
-- SELECT employeeId, firstName, lastName, salary, commissionPct 
-- FROM employees 
-- WHERE employeeId IN (SELECT employeeId FROM employees e JOIN departments d ON e.departmentId = d.departmentId WHERE d.departmentName IN ('IT', 'SALES') AND e.hireDate < TO_DATE('01-JAN-2021', 'YYYY-MM-DD') AND e.isActive = TRUE);
```

---

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

Well done on working through these PL/SQL foundational exercises and their solutions! By understanding these core components, you've taken significant steps in bridging your PostgreSQL knowledge to the Oracle ecosystem and started to harness the procedural power of PL/SQL.

_The blocks you've built, the loops you've run,_
_Your PL/SQL journey has begun!_

The concepts covered here—block structure, variables, control flow, and SQL integration—are the bedrock upon which more advanced PL/SQL programming is built.

**Next, you'll venture into:**

*   **Cursors:** For more granular control over multi-row query results.
*   **Stored Procedures & Functions:** To encapsulate logic and create reusable code units.
*   **Packages:** Oracle's powerful mechanism for organizing related PL/SQL objects.

Keep practicing, keep exploring, and you'll become proficient in Oracle PL/SQL in no time!

</div>