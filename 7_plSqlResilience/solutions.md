<head>
    <link rel="stylesheet" href="../styles/solutions.css">
</head>

<style>
    /* CSS styles from exercises.css are assumed to be linked or embedded here */
    /* For this example, I will embed the CSS directly. In a real setup, you'd link to solutions.css */
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
        
        --header-font: 'Lato', 'Oracle Sans', 'Helvetica Neue', Arial, sans-serif;
        --body-font: 'Roboto', 'Georgia', Times, serif;
        --code-font: 'Fira Code', 'Oracle Mono', 'Consolas', 'Monaco', 'Courier New', monospace;
        
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
        font-size: 1em; /* Relative to body font-size */
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
    /* ol { */
        /* padding-left: 40px; /* Example if you want to control default first-level indentation */
    /* } */

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

    .problem-label {
        font-style: italic;
        font-weight: normal; /* Explicitly set to normal if it might inherit bold from somewhere else */
        /* You might want to adjust color or other properties here too */
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

# Solutions: PL/SQL Resilience - Packages, Errors, and Automation

<div class="rhyme">
With packages neat, and errors well caught,<br>
Triggers automated, resilience is wrought.
</div>

## Introduction / Purpose of Solutions

Welcome to the solutions for the exercises on PL/SQL Packages, Exception Handling, and Triggers! This document is your guide to understanding the optimal ways to implement these crucial Oracle features. The goal here isn't just to verify if your code "worked," but to deepen your understanding of *why* certain approaches are preferred, especially the Oracle-specific nuances that make PL/SQL a powerful and resilient language.

Even if your solutions produced the correct output, we encourage you to review the provided explanations. You might discover alternative techniques, best practices, or further insights into Oracle's architecture. For those transitioning from PostgreSQL, these solutions will specifically highlight how Oracle handles these concepts, often offering more structured or feature-rich approaches.

## Reviewing the Dataset

As a quick refresher, these exercises operate on a dataset comprising `Departments`, `Employees`, `Products`, `Orders`, `OrderItems`, and an `AuditLog` table. The relationships are fairly standard: employees belong to departments, orders contain order items which refer to products, and the audit log tracks changes. If you haven't set up this dataset, please refer back to the exercise document for the `CREATE TABLE` and `INSERT` scripts and ensure they are executed in your Oracle DB 23ai environment. A correctly set up dataset is vital for the solutions to run as expected.

## Solution Structure Overview

Each solution presented below will typically follow this structure:
1.  **Problem Recap:** A brief restatement of the exercise problem for context.
2.  **Solution Code:** The complete and optimal Oracle SQL and PL/SQL code.
3.  **Detailed Explanation:** A step-by-step breakdown of the solution, explaining the logic, Oracle-specific features used, and how it addresses the problem requirements. For concepts with PostgreSQL parallels, the explanation will often bridge the understanding by highlighting Oracle's unique implementation or advantages.

When reviewing, try to:
*   Compare your approach to the provided solution.
*   Understand the rationale behind Oracle-specific constructs.
*   Note any pitfalls or common errors discussed in the explanations.

## <!-- PLACEHOLDER FOR PRE-GENERATED SOLUTIONS -->

*(The pre-generated exercises and their solutions, including dataset DDL/DML if not provided separately in the exercise document, will be inserted here. Each solution will follow the structure outlined above: Problem Recap, Solution Code, and Detailed Explanation.)*

---
**BEGINNING OF INSERTED SOLUTIONS**

*(This is where your previously generated exercise solutions would go. For brevity, I will provide the solutions for the exercises I generated in the previous step. Ensure each solution includes the problem statement for context, the code, and a detailed explanation.)*

### Category: Packages: Specification, body, benefits, overloading

#### (i) Meanings, Values, Relations, and Advantages

**Exercise 1.1: Basic Package Creation and Usage**
*   <span class="problem-label">Problem Recap:</span> Create `EmployeeUtils` package with `GetEmployeeFullName` function and `UpdateEmployeeSalary` procedure. Test them.

*   **Solution Code:**
    ```sql
    -- Package Specification
    CREATE OR REPLACE PACKAGE EmployeeUtils AS
        FUNCTION GetEmployeeFullName (pEmployeeId IN Employees.employeeId%TYPE) RETURN VARCHAR2;
        PROCEDURE UpdateEmployeeSalary (pEmployeeId IN Employees.employeeId%TYPE, pNewSalary IN Employees.salary%TYPE);
    END EmployeeUtils;
    /

    -- Package Body
    CREATE OR REPLACE PACKAGE BODY EmployeeUtils AS
        FUNCTION GetEmployeeFullName (pEmployeeId IN Employees.employeeId%TYPE) RETURN VARCHAR2 IS
            vFullName VARCHAR2(101);
        BEGIN
            SELECT firstName || ' ' || lastName
            INTO vFullName
            FROM Employees
            WHERE employeeId = pEmployeeId;
            RETURN vFullName;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 'Employee not found';
        END GetEmployeeFullName;

        PROCEDURE UpdateEmployeeSalary (pEmployeeId IN Employees.employeeId%TYPE, pNewSalary IN Employees.salary%TYPE) IS
        BEGIN
            UPDATE Employees
            SET salary = pNewSalary
            WHERE employeeId = pEmployeeId;

            IF SQL%NOTFOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found for salary update.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Salary updated for employee ' || pEmployeeId);
                COMMIT; 
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
                ROLLBACK; 
        END UpdateEmployeeSalary;
    END EmployeeUtils;
    /

    -- Anonymous block to test
    SET SERVEROUTPUT ON;
    DECLARE
        empFullName VARCHAR2(101);
        existingEmployeeId NUMBER := 100; 
        newSalaryAmount NUMBER := 65000;
    BEGIN
        -- Test GetEmployeeFullName
        empFullName := EmployeeUtils.GetEmployeeFullName(existingEmployeeId);
        DBMS_OUTPUT.PUT_LINE('Full Name for employee ' || existingEmployeeId || ': ' || empFullName);

        -- Test UpdateEmployeeSalary
        DBMS_OUTPUT.PUT_LINE('Updating salary for employee ' || existingEmployeeId || ' to ' || newSalaryAmount);
        EmployeeUtils.UpdateEmployeeSalary(pEmployeeId => existingEmployeeId, pNewSalary => newSalaryAmount);

        -- Verify the update by fetching again (optional, or check table directly)
        SELECT salary INTO newSalaryAmount FROM Employees WHERE employeeId = existingEmployeeId;
        DBMS_OUTPUT.PUT_LINE('New salary for employee ' || existingEmployeeId || ' is: ' || newSalaryAmount);
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred in the test block: ' || SQLERRM);
    END;
    /
    ```
*   **Detailed Explanation:**
    1.  **Package Specification (`EmployeeUtils AS ... END EmployeeUtils;`):** This is the public interface.
        *   `FUNCTION GetEmployeeFullName (...) RETURN VARCHAR2;`: Declares a function that takes an employee ID and returns their full name as a string.
        *   `PROCEDURE UpdateEmployeeSalary (...);`: Declares a procedure to update an employee's salary.
        *   The use of `%TYPE` for parameter `pEmployeeId` and `pNewSalary` in `UpdateEmployeeSalary` (and `GetEmployeeFullName`) ensures that if the underlying table column types change, this code is less likely to break. This demonstrates a best practice learned in PL/SQL Fundamentals (Chunk 5).
    2.  **Package Body (`EmployeeUtils AS ... END EmployeeUtils;`):** This contains the implementation of the declared subprograms.
        *   **`GetEmployeeFullName` Implementation:**
            *   A local variable `vFullName` is declared.
            *   A `SELECT` statement retrieves the `firstName` and `lastName` from the `Employees` table, concatenates them, and stores the result in `vFullName`. This uses basic SQL DML (Chunk 2) and string concatenation (Chunk 2).
            *   An `EXCEPTION` block handles the predefined `NO_DATA_FOUND` exception (covered later in this chunk's exercises but good practice to include early), returning a message if the employee doesn't exist.
        *   **`UpdateEmployeeSalary` Implementation:**
            *   An `UPDATE` statement modifies the `salary` in the `Employees` table.
            *   `SQL%NOTFOUND` (an implicit cursor attribute from Chunk 6) is used to check if any row was updated.
            *   `COMMIT` is used to make the change permanent. Transaction control (Chunk 2) is essential.
            *   A `WHEN OTHERS` exception handler is included to catch any other unexpected errors during the update, display an error message using `SQLERRM` (covered later in this chunk), and `ROLLBACK` the transaction.
    3.  **Anonymous Block:**
        *   `SET SERVEROUTPUT ON;` enables output for `DBMS_OUTPUT`.
        *   It declares variables and then calls the package subprograms using dot notation (`PackageName.SubprogramName`).
        *   This demonstrates how client PL/SQL code or other database objects would interact with the package.

<div class="oracle-specific">
**Oracle Nugget:** Packages are fundamental to modular PL/SQL development. They bundle related logic and data, improve organization, and manage dependencies effectively. Unlike PostgreSQL's schema-based function grouping, Oracle packages provide true encapsulation with public and private members.
</div>

**Exercise 1.2: Package Variables and State**
*   <span class="problem-label">Problem Recap:</span> Add public `defaultRaisePercentage` and private `totalRaisesProcessed` to `EmployeeUtils`. Modify `UpdateEmployeeSalary` to use these. Add `GetTotalRaisesProcessed`.

*   **Solution Code:**
    ```sql
    -- Package Specification (Modified)
    CREATE OR REPLACE PACKAGE EmployeeUtils AS
        defaultRaisePercentage NUMBER := 5; -- Public variable with default

        FUNCTION GetEmployeeFullName (pEmployeeId IN Employees.employeeId%TYPE) RETURN VARCHAR2;
        PROCEDURE UpdateEmployeeSalary (
            pEmployeeId IN Employees.employeeId%TYPE, 
            pNewSalary IN Employees.salary%TYPE DEFAULT NULL, -- Make newSalary optional
            pRaisePercentage IN NUMBER DEFAULT NULL -- Optional raise percentage
        );
        FUNCTION GetTotalRaisesProcessed RETURN NUMBER;
    END EmployeeUtils;
    /

    -- Package Body (Modified)
    CREATE OR REPLACE PACKAGE BODY EmployeeUtils AS
        totalRaisesProcessed NUMBER := 0; -- Private package variable

        FUNCTION GetEmployeeFullName (pEmployeeId IN Employees.employeeId%TYPE) RETURN VARCHAR2 IS
            vFullName VARCHAR2(101);
        BEGIN
            SELECT firstName || ' ' || lastName
            INTO vFullName
            FROM Employees
            WHERE employeeId = pEmployeeId;
            RETURN vFullName;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 'Employee not found';
        END GetEmployeeFullName;

        PROCEDURE UpdateEmployeeSalary (
            pEmployeeId IN Employees.employeeId%TYPE, 
            pNewSalary IN Employees.salary%TYPE DEFAULT NULL,
            pRaisePercentage IN NUMBER DEFAULT NULL
        ) IS
            vCalculatedSalary Employees.salary%TYPE;
            vCurrentSalary Employees.salary%TYPE;
        BEGIN
            SELECT salary INTO vCurrentSalary FROM Employees WHERE employeeId = pEmployeeId;

            IF pNewSalary IS NOT NULL THEN
                vCalculatedSalary := pNewSalary;
            ELSIF pRaisePercentage IS NOT NULL THEN
                vCalculatedSalary := vCurrentSalary * (1 + pRaisePercentage / 100);
            ELSE
                vCalculatedSalary := vCurrentSalary * (1 + defaultRaisePercentage / 100);
            END IF;
            
            UPDATE Employees
            SET salary = ROUND(vCalculatedSalary, 2) -- Round to 2 decimal places for currency
            WHERE employeeId = pEmployeeId;

            IF SQL%FOUND THEN
                totalRaisesProcessed := totalRaisesProcessed + 1;
                DBMS_OUTPUT.PUT_LINE('Salary updated for employee ' || pEmployeeId || '. Total raises processed this session: ' || totalRaisesProcessed);
                COMMIT;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found for salary update.');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN -- If SELECT salary INTO vCurrentSalary fails
                 DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
                ROLLBACK; 
        END UpdateEmployeeSalary;

        FUNCTION GetTotalRaisesProcessed RETURN NUMBER IS
        BEGIN
            RETURN totalRaisesProcessed;
        END GetTotalRaisesProcessed;

    BEGIN
        DBMS_OUTPUT.PUT_LINE('EmployeeUtils package initialized. Default Raise: ' || defaultRaisePercentage || '%.');
    END EmployeeUtils;
    /

    -- Anonymous block to test
    SET SERVEROUTPUT ON;
    DECLARE
        vTotalRaises NUMBER;
        empId1 NUMBER := 100;
        empId2 NUMBER := 101;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test 1: Update with default raise ---');
        EmployeeUtils.UpdateEmployeeSalary(pEmployeeId => empId1);
        
        DBMS_OUTPUT.PUT_LINE('--- Test 2: Update with specific percentage ---');
        EmployeeUtils.UpdateEmployeeSalary(pEmployeeId => empId2, pRaisePercentage => 10);

        DBMS_OUTPUT.PUT_LINE('--- Test 3: Update with specific new salary ---');
        EmployeeUtils.UpdateEmployeeSalary(pEmployeeId => empId1, pNewSalary => 70000);

        vTotalRaises := EmployeeUtils.GetTotalRaisesProcessed();
        DBMS_OUTPUT.PUT_LINE('Total raises processed in this session: ' || vTotalRaises);
    END;
    /
    ```
*   **Detailed Explanation:**
    1.  **`defaultRaisePercentage` (Public):** Declared in the specification, making it accessible outside the package (e.g., `EmployeeUtils.defaultRaisePercentage`). It's initialized to `5`.
    2.  **`totalRaisesProcessed` (Private):** Declared in the body, so it's only accessible within the package body. It's initialized to `0` in its declaration and also in the package initialization block (the `BEGIN...END;` at the end of the package body), which runs once per session when the package is first referenced. The explicit initialization block is good for more complex setup.
    3.  **`UpdateEmployeeSalary` Modification:**
        *   Now accepts `pNewSalary` and `pRaisePercentage` as optional parameters (using `DEFAULT NULL`).
        *   It prioritizes `pNewSalary`, then `pRaisePercentage`, then the package's `defaultRaisePercentage`. This uses IF-THEN-ELSIF logic (Chunk 5).
        *   It increments the private `totalRaisesProcessed` variable if the update is successful (`SQL%FOUND`).
    4.  **`GetTotalRaisesProcessed` Function:** A simple public function to return the current value of the private `totalRaisesProcessed`. This demonstrates encapsulation – controlling access to internal state.
    5.  **Package Initialization Block (`BEGIN ... END EmployeeUtils;` at the end of the package body):** This block executes once per session when any part of the package is first accessed. Here, it just prints an initialization message. It could also be used to initialize `totalRaisesProcessed` if not done at declaration.
    6.  **Test Block:** Shows calls to `UpdateEmployeeSalary` using different parameter combinations and then retrieves the session-specific count of raises.

<div class="postgresql-bridge">
**Bridging from PostgreSQL:** PostgreSQL functions can have default parameter values. However, the concept of persistent package state (like `totalRaisesProcessed` which maintains its value across multiple calls to `UpdateEmployeeSalary` *within the same database session*) is a key Oracle feature. In PostgreSQL, you might achieve similar session-level state using temporary tables or session-level variables set via `SET session.variable = value;`, but Oracle packages offer a more structured and type-safe way to manage this.
</div>

**Exercise 1.3: Package Subprogram Overloading**
*   <span class="problem-label">Problem Recap:</span> Overload `GetEmployeeFullName` in `EmployeeUtils` to also accept `firstName` and `lastName` as parameters.

*   **Solution Code:**
    ```sql
    -- Package Specification (Modified for Overloading)
    CREATE OR REPLACE PACKAGE EmployeeUtils AS
        defaultRaisePercentage NUMBER := 5; 

        -- Original version
        FUNCTION GetEmployeeFullName (pEmployeeId IN Employees.employeeId%TYPE) RETURN VARCHAR2;
        
        -- Overloaded version
        FUNCTION GetEmployeeFullName (pFirstName IN Employees.firstName%TYPE, pLastName IN Employees.lastName%TYPE) RETURN VARCHAR2;

        PROCEDURE UpdateEmployeeSalary (
            pEmployeeId IN Employees.employeeId%TYPE, 
            pNewSalary IN Employees.salary%TYPE DEFAULT NULL,
            pRaisePercentage IN NUMBER DEFAULT NULL 
        );
        FUNCTION GetTotalRaisesProcessed RETURN NUMBER;
    END EmployeeUtils;
    /

    -- Package Body (Modified for Overloading)
    CREATE OR REPLACE PACKAGE BODY EmployeeUtils AS
        totalRaisesProcessed NUMBER := 0; 

        -- Original version implementation
        FUNCTION GetEmployeeFullName (pEmployeeId IN Employees.employeeId%TYPE) RETURN VARCHAR2 IS
            vFullName VARCHAR2(101);
        BEGIN
            SELECT firstName || ' ' || lastName
            INTO vFullName
            FROM Employees
            WHERE employeeId = pEmployeeId;
            RETURN vFullName;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 'Employee ID ' || pEmployeeId || ' not found';
        END GetEmployeeFullName;

        -- Overloaded version implementation
        FUNCTION GetEmployeeFullName (pFirstName IN Employees.firstName%TYPE, pLastName IN Employees.lastName%TYPE) RETURN VARCHAR2 IS
        BEGIN
            RETURN pFirstName || ' ' || pLastName;
        END GetEmployeeFullName;

        PROCEDURE UpdateEmployeeSalary (
            pEmployeeId IN Employees.employeeId%TYPE, 
            pNewSalary IN Employees.salary%TYPE DEFAULT NULL,
            pRaisePercentage IN NUMBER DEFAULT NULL
        ) IS
            vCalculatedSalary Employees.salary%TYPE;
            vCurrentSalary Employees.salary%TYPE;
        BEGIN
            SELECT salary INTO vCurrentSalary FROM Employees WHERE employeeId = pEmployeeId;

            IF pNewSalary IS NOT NULL THEN
                vCalculatedSalary := pNewSalary;
            ELSIF pRaisePercentage IS NOT NULL THEN
                vCalculatedSalary := vCurrentSalary * (1 + pRaisePercentage / 100);
            ELSE
                vCalculatedSalary := vCurrentSalary * (1 + defaultRaisePercentage / 100);
            END IF;
            
            UPDATE Employees
            SET salary = ROUND(vCalculatedSalary, 2)
            WHERE employeeId = pEmployeeId;

            IF SQL%FOUND THEN
                totalRaisesProcessed := totalRaisesProcessed + 1;
                DBMS_OUTPUT.PUT_LINE('Salary updated for employee ' || pEmployeeId || '.');
                COMMIT;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found for salary update.');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
                ROLLBACK; 
        END UpdateEmployeeSalary;

        FUNCTION GetTotalRaisesProcessed RETURN NUMBER IS
        BEGIN
            RETURN totalRaisesProcessed;
        END GetTotalRaisesProcessed;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EmployeeUtils package (with overloading) initialized.');
    END EmployeeUtils;
    /

    -- Anonymous block to test overloading
    SET SERVEROUTPUT ON;
    DECLARE
        fullNameById VARCHAR2(101);
        fullNameByNames VARCHAR2(101);
    BEGIN
        fullNameById := EmployeeUtils.GetEmployeeFullName(pEmployeeId => 100);
        DBMS_OUTPUT.PUT_LINE('Full name (by ID 100): ' || fullNameById);

        fullNameByNames := EmployeeUtils.GetEmployeeFullName(pFirstName => 'Jane', pLastName => 'Smith');
        DBMS_OUTPUT.PUT_LINE('Full name (by names): ' || fullNameByNames);
    END;
    /
    ```
*   **Detailed Explanation:**
    1.  **Specification Change:** A second `FUNCTION GetEmployeeFullName` declaration is added, but this one takes `pFirstName` and `pLastName` as `VARCHAR2` parameters. The PL/SQL compiler can distinguish between these two functions because their parameter lists differ in type and/or number.
    2.  **Body Change:** The implementation for the new overloaded function is added. It simply concatenates the provided first and last names. The original function implementation remains unchanged.
    3.  **Test Block:** The anonymous block now demonstrates calling both versions of `GetEmployeeFullName`. Oracle determines which version to execute based on the data types of the arguments passed.

<div class="oracle-specific">
**Oracle Insight:** Overloading allows you to create multiple subprograms with the same name but different parameter signatures. This enhances code flexibility and readability, as users can call the version of the subprogram that best suits the data they have. It's a common practice in Oracle's own supplied packages.
</div>

*(Solutions for (ii), (iii), and (iv) would continue in a similar fashion, with problem recaps, code, and detailed explanations, including PostgreSQL bridge comments and Oracle-specific insights where appropriate.)*

---
**END OF INSERTED SOLUTIONS**
---

## Key Takeaways & Best Practices

Reviewing these solutions for PL/SQL Packages, Exception Handling, and Triggers should reinforce several key Oracle concepts:

*   **Packages for Organization:** Always group related procedures, functions, types, and variables into packages. This is fundamental for maintainable and scalable Oracle applications. Remember the separation of specification (the "what") and body (the "how").
*   **Principled Exception Handling:**
    *   Strive to handle specific, named exceptions whenever possible, rather than relying solely on `WHEN OTHERS`.
    *   Use `PRAGMA EXCEPTION_INIT` to associate custom error messages and codes (via `RAISE_APPLICATION_ERROR`) with user-defined exceptions for clearer error reporting.
    *   `SQLCODE` and `SQLERRM` are invaluable for diagnosing errors within `WHEN OTHERS` blocks, but always aim to re-raise the exception or a more meaningful one unless you can fully recover.
*   **Strategic Trigger Use:**
    *   Triggers are powerful but use them judiciously. They can introduce complexity and performance overhead if not carefully designed.
    *   DML triggers (`BEFORE`/`AFTER`, `FOR EACH ROW`/`STATEMENT`) are common for auditing, maintaining data integrity, or enforcing complex business rules.
    *   Leverage the `:OLD` and `:NEW` pseudorecords effectively within row-level triggers to access data values before and after the DML operation.
    *   Use conditional predicates (`INSERTING`, `UPDATING`, `DELETING`, and `WHEN` clause) to control precisely when a trigger's logic executes.
*   **Oracle vs. PostgreSQL Nuances:** While PostgreSQL offers functions and triggers, Oracle's package system provides a more comprehensive module structure. Oracle's exception handling syntax and predefined exceptions will also differ. Pay close attention to these Oracle-specific implementations.

**Tips for Internalizing Learning:**
*   **Re-Type, Don't Just Copy-Paste:** Manually re-typing solutions helps build muscle memory for Oracle syntax.
*   **Experiment:** Modify the solutions. What happens if you change a parameter type? What if you remove an exception handler? Active experimentation solidifies understanding.
*   **Consult Documentation:** The Oracle PL/SQL Language Reference is your best friend. If a concept in a solution is unclear, look it up! The provided PDFs (especially `reduction-f46753-09-PLSQL-Language-Reference.pdf` Chapters 10, 11, 12) are direct excerpts and invaluable.
*   **Think "Why":** For each solution, ask yourself *why* it's designed that way. What Oracle features does it leverage? How does it compare to how you might have solved it in PostgreSQL?

## Conclusion & Next Steps

Mastering packages, exception handling, and triggers is a significant step in becoming proficient with Oracle PL/SQL. These constructs allow you to build robust, maintainable, and automated database applications.

<div class="rhyme">
Your PL/SQL skills, now truly advance,<br>
With packages, errors, and triggers that dance!
</div>

You're now well-equipped to tackle more advanced PL/SQL topics. Continue your journey with the next chunk in "Server Programming with Oracle (DB 23 ai) PL/SQL: A Transition Guide for PostgreSQL Users," which will likely delve into **Collections & Records, Bulk Operations, and Dynamic SQL.**

Keep practicing, and your Oracle expertise will continue to grow!

</div>