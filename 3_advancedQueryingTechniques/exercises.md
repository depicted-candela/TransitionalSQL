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
        user-select: none;
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
        p { font-size: 1.05em; } /* li rule removed, font sizes for li are now level-specific and will scale with body's 1.1rem */
    }
</style>

<div class="container">

# Advanced Oracle SQL: Mastering Hierarchies, Analytics, and MERGE

Welcome, intrepid data navigator! This set of exercises is designed to sharpen your skills in some of Oracle SQL's most powerful and distinctive querying techniques. To Oracle's ways, your skills align, with queries deep and designs so fine. We'll venture into the realms of hierarchical data, sophisticated window functions, and the mighty `MERGE` statement.


## Learning Objectives
Upon completing these exercises, you will be able to:

*   **Master Hierarchical Queries:**
    *   Confidently use `CONNECT BY`, `START WITH`, `PRIOR`, and `LEVEL` to navigate and represent tree-like structures.
    *   Understand Oracle-specific advantages for hierarchical data compared to standard recursive CTEs (which you know from PostgreSQL).
*   **Leverage Analytic (Window) Functions:**
    *   Apply ranking functions (`RANK`, `DENSE_RANK`, `ROW_NUMBER`) with Oracle syntax.
    *   Utilize navigation functions (`LAG`, `LEAD`) effectively.
    *   Perform windowed aggregations (`SUM() OVER()`, `AVG() OVER()`).
    *   Reinforce your understanding of partitioning and ordering within analytic functions.
*   **Employ the `MERGE` Statement:**
    *   Implement complex `UPSERT` (update or insert) logic efficiently using Oracle's `MERGE`.
    *   Understand its advantages over traditional procedural approaches or separate DML statements.
    *   Handle conditional updates and deletes within a `MERGE` operation.
*   **Bridge Your Knowledge:**
    *   Specifically practice Oracle syntax and identify Oracle-specific nuances for concepts analogous to those in PostgreSQL.
    *   Recognize scenarios where Oracle offers unique and beneficial solutions.

<div class="postgresql-bridge">
<p><strong>Note for PostgreSQL Veterans:</strong> Many concepts like window functions are familiar. Here, the focus is on Oracle's specific syntax (though often similar), its unique hierarchical query clauses, and the versatile <code>MERGE</code> statement, a powerful alternative to PostgreSQL's <code>INSERT ... ON CONFLICT</code>.</p>
</div>

## Prerequisites & Setup

Before you embark on these challenges, please ensure you're comfortable with:

*   Core SQL concepts from "The Original PostgreSQL Course Sequence" (Joins, Aggregates, Subqueries, Basic DML).
*   Introductory Oracle concepts from "Server Programming with Oracle (DB 23 ai) PL/SQL: A Transition Guide for PostgreSQL Users," particularly:
    *   Key Differences & Core Syntax (Data Types, DUAL, NVL, CASE, ROWNUM).
    *   Oracle Date and String Functions.
    *   Set Operators (especially `MINUS`).

<div class="rhyme">
Before you dive and start to code,<br>
Ensure your data's rightly stowed.
</div>

### Dataset Guidance

The exercises in the following section will rely on a common dataset. The complete Oracle SQL scripts for table creation (`CREATE TABLE`) and data population (`INSERT INTO`) are provided at the beginning of the "Exercises and Dataset" section.

*   **Execution:**
    *   Copy the provided SQL scripts.
    *   Execute them in your Oracle DB 21ai environment (e.g., using SQL Developer, SQL*Plus, Oracle Live SQL, or your preferred SQL client).
    *   Ensure the scripts run without errors and all tables are created and populated.
*   **Tables Overview:**
    *   `Departments`: Stores department information (`departmentId`, `departmentName`, `locationCity`).
    *   `Employees`: Contains employee details (`employeeId`, `employeeName`, `jobTitle`, `managerId`, `hireDate`, `salary`, `departmentId`, `email`). The `managerId` column creates a hierarchical relationship within this table.
    *   `EmployeeUpdates`: A staging table used primarily for `MERGE` exercises, holding potential changes or new employee data.
*   **Relationships:**
    *   `Employees.managerId` references `Employees.employeeId` (self-referencing for hierarchy).
    *   `Employees.departmentId` references `Departments.departmentId`.

<div class="caution">
<p><strong>Critical Step:</strong> Setting up this dataset correctly is essential. The exercises are tailored to this specific data structure and content. Please run the setup scripts before attempting any problems!</p>
</div>


## Exercise Structure Overview

The exercises are structured to build your understanding progressively:

*   **(i) Meanings, Values, Relations, and Advantages:** Focus on the core purpose and benefits of each feature, highlighting Oracle-specific syntax and advantages, especially when bridging from PostgreSQL.
*   **(ii) Disadvantages and Pitfalls:** Explore common mistakes, limitations, and potential issues you might encounter.
*   **(iii) Contrasting with Inefficient Common Solutions:** Compare the Oracle-idiomatic approach with less efficient methods, demonstrating the value of using the right tools.
*   **(iv) Hardcore Combined Problem:** A comprehensive challenge integrating multiple concepts from this and previous modules.

We encourage you to tackle each problem yourself before reviewing any reference solutions (which are not included in this particular document, allowing for focused practice).


## Exercises & Dataset

<!-- 
    ********************************************************************************************************
    *** DEVELOPER NOTE: INSERT THE PRE-GENERATED DATASET (CREATE/INSERT) AND EXERCISE PROBLEM STATEMENTS ***
    *** (WITHOUT SOLUTIONS) BELOW THIS COMMENT BLOCK.                                                    ***
    ********************************************************************************************************
-->

### Dataset Definition and Population (Oracle SQL)

**To practices in SQL Developer or SQLPLUS** After to create the database create a new schema for these exercises to keep separate them from rest of datasets and review them as is necessary. Do it running the file **NewSchema.sql** of the current folder. Then execute the file **dataset.sql**.

**To practice in Oracle SQL Live** Execute the following SQL script in your Oracle DB 21ai environment to create and populate the necessary tables for the exercises.

```sql
-- Drop tables if they exist (for easy re-running of script)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE EmployeeUpdates';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Employees';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Departments';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Create Departments Table
CREATE TABLE Departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(50) NOT NULL,
    locationCity VARCHAR2(50)
);

-- Create Employees Table
CREATE TABLE Employees (
    employeeId NUMBER PRIMARY KEY,
    employeeName VARCHAR2(100) NOT NULL,
    jobTitle VARCHAR2(50),
    managerId NUMBER,
    hireDate DATE,
    salary NUMBER(10, 2),
    departmentId NUMBER,
    email VARCHAR2(100) UNIQUE,
    CONSTRAINT fkManager FOREIGN KEY (managerId) REFERENCES Employees(employeeId),
    CONSTRAINT fkDepartment FOREIGN KEY (departmentId) REFERENCES Departments(departmentId)
);

-- Create EmployeeUpdates Staging Table (for MERGE)
CREATE TABLE EmployeeUpdates (
    employeeId NUMBER,
    employeeName VARCHAR2(100),
    jobTitle VARCHAR2(50),
    managerId NUMBER,
    hireDate DATE,
    salary NUMBER(10, 2),
    departmentId NUMBER,
    email VARCHAR2(100),
    changeReason VARCHAR2(100) -- To describe the update
);

-- Populate Departments
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (10, 'Technology', 'New York');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (20, 'Sales', 'London');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (30, 'HR', 'New York');
INSERT INTO Departments (departmentId, departmentName, locationCity) VALUES (40, 'Finance', 'Chicago');

-- Populate Employees
-- Top Level
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (100, 'Sarah Connor', 'CEO', NULL, TO_DATE('2010-01-15', 'YYYY-MM-DD'), 250000, 10, 'sconnor@example.com');

-- Technology Department (Manager: Sarah Connor)
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (101, 'John Smith', 'CTO', 100, TO_DATE('2012-03-01', 'YYYY-MM-DD'), 180000, 10, 'jsmith@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (102, 'Alice Brown', 'Lead Developer', 101, TO_DATE('2015-06-10', 'YYYY-MM-DD'), 120000, 10, 'abrown@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (103, 'Bob Green', 'Senior Developer', 102, TO_DATE('2017-09-20', 'YYYY-MM-DD'), 100000, 10, 'bgreen@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (104, 'Carol White', 'Junior Developer', 102, TO_DATE('2022-07-01', 'YYYY-MM-DD'), 70000, 10, 'cwhite@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (105, 'David Black', 'DBA', 101, TO_DATE('2016-02-15', 'YYYY-MM-DD'), 110000, 10, 'dblack@example.com');

-- Sales Department (Manager: Sarah Connor)
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (201, 'Eve Adams', 'Sales Director', 100, TO_DATE('2013-05-01', 'YYYY-MM-DD'), 170000, 20, 'eadams@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (202, 'Frank Miller', 'Sales Manager', 201, TO_DATE('2018-11-01', 'YYYY-MM-DD'), 90000, 20, 'fmiller@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (203, 'Grace Davis', 'Sales Rep', 202, TO_DATE('2021-03-12', 'YYYY-MM-DD'), 60000, 20, 'gdavis@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (204, 'Henry Wilson', 'Sales Rep', 202, TO_DATE('2021-03-12', 'YYYY-MM-DD'), 60000, 20, 'hwilson@example.com'); -- Same salary and hire date for ranking demo

-- HR Department (Manager: Sarah Connor)
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (301, 'Ivy Clark', 'HR Director', 100, TO_DATE('2014-08-01', 'YYYY-MM-DD'), 160000, 30, 'iclark@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (302, 'Jack Lewis', 'HR Specialist', 301, TO_DATE('2019-01-10', 'YYYY-MM-DD'), 75000, 30, 'jlewis@example.com');

-- Finance Department (Manager: Sarah Connor, but Finance is separate)
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (401, 'Kyle Roberts', 'CFO', 100, TO_DATE('2011-07-01', 'YYYY-MM-DD'), 190000, 40, 'kroberts@example.com');
INSERT INTO Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (402, 'Laura King', 'Finance Analyst', 401, TO_DATE('2020-02-20', 'YYYY-MM-DD'), 85000, 40, 'lking@example.com');


-- Populate EmployeeUpdates for MERGE exercises
-- Row for existing employee update
INSERT INTO EmployeeUpdates (employeeId, employeeName, jobTitle, salary, departmentId, email, changeReason)
VALUES (103, 'Bob Green', 'Senior Developer II', 105000, 10, 'bgreen.updated@example.com', 'Promotion');
-- Row for new employee insert
INSERT INTO EmployeeUpdates (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email, changeReason)
VALUES (501, 'Nina Young', 'Intern', 102, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 40000, 10, 'nyoung@example.com', 'New Hire');
-- Row for existing employee, conditional update (e.g., only if salary increases)
INSERT INTO EmployeeUpdates (employeeId, employeeName, jobTitle, salary, departmentId, email, changeReason)
VALUES (203, 'Grace Davis', 'Senior Sales Rep', 65000, 20, 'gdavis.promo@example.com', 'Performance Raise');
-- Row for existing employee, but no actual change in salary initially (for MERGE update condition testing)
INSERT INTO EmployeeUpdates (employeeId, salary, changeReason)
VALUES (204, 60000, 'Salary Review - No Change');
-- Row that could cause ORA-30926 if source is not distinct for MERGE pitfall exercise
INSERT INTO EmployeeUpdates (employeeId, salary, changeReason)
VALUES (105, 112000, 'DBA Adjustment 1');
INSERT INTO EmployeeUpdates (employeeId, salary, changeReason)
VALUES (105, 115000, 'DBA Adjustment 2');

COMMIT;
```

---
### Category: Hierarchical Queries (Oracle Specific)
*(CONNECT BY clause, LEVEL pseudo-column, PRIOR operator, START WITH clause)*

#### (i) Meanings, Values, Relations, and Advantages

**Exercise HQ.1.1: Basic Employee Hierarchy**
*   **Problem:** Display the complete organizational hierarchy. For each employee, show their ID, name, job title, manager's ID, and their level in the hierarchy. The top-level manager(s) should be at `LEVEL 1`. Indent the employee names based on their level for readability.
*   **Bridging Focus:** PostgreSQL users would typically use a `WITH RECURSIVE` CTE for this. Demonstrate the Oracle `CONNECT BY` syntax as a more concise alternative for this common task.
*   **Concepts:** `START WITH`, `CONNECT BY PRIOR`, `LEVEL`, `LPAD` (for formatting).

**Exercise HQ.1.2: Subordinates of a Specific Manager**
*   **Problem:** List all direct and indirect subordinates of 'John Smith' (employeeId 101). Include their employee ID, name, job title, and their level relative to John Smith (John Smith being effectively level 0 for his own sub-hierarchy, his direct reports level 1, etc.).
*   **Concepts:** `START WITH` (specific employee), `CONNECT BY`, `LEVEL`.

#### (ii) Disadvantages and Pitfalls

**Exercise HQ.2.1: Handling Cycles in Data**
*   **Problem:** Introduce a cyclical management relationship (e.g., Bob Green manages Carol White, and Carol White manages Bob Green). Then, attempt to query the hierarchy. Observe the error. Finally, use `NOCYCLE` and `CONNECT_BY_ISCYCLE` to handle and identify the cycle. *Remember to restore the data to its original state after this exercise.*
*   **Concepts:** Cycles, `ORA-01436: CONNECT BY loop in user data`, `NOCYCLE`, `CONNECT_BY_ISCYCLE`.

#### (iii) Contrasting with Inefficient Common Solutions

**Exercise HQ.3.1: Finding All Subordinates - Efficient vs. Inefficient**
*   **Problem:** Retrieve all direct and indirect subordinates for 'John Smith' (employeeId 101).
    *   First, describe (pseudo-code or conceptual) how one might do this inefficiently using multiple self-joins or a procedural loop (common for those unfamiliar with hierarchical queries).
    *   Then, write the efficient Oracle `CONNECT BY` query.
*   **Concepts:** `CONNECT BY` efficiency vs. iterative/multi-join approaches.

---
### Category: Analytic (Window) Functions (Practice in Oracle Syntax)
*(Ranking: RANK, DENSE_RANK, ROW_NUMBER; Navigation: LAG, LEAD; Aggregates: SUM() OVER (...), AVG() OVER (...))*

#### (i) Meanings, Values, Relations, and Advantages

**Exercise AF.1.1: Employee Ranking by Salary**
*   **Problem:** For each department, rank employees by their salary in descending order. Display department name, employee name, salary, and their rank using `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.
*   **Bridging Focus:** PostgreSQL users are familiar with these functions. The exercise is to practice the Oracle syntax and observe the behavior of different ranking functions, especially with ties in salary (e.g., Grace Davis and Henry Wilson).
*   **Concepts:** `ROW_NUMBER() OVER()`, `RANK() OVER()`, `DENSE_RANK() OVER()`, `PARTITION BY`, `ORDER BY`.

**Exercise AF.1.2: Salary Comparison with Previous/Next Hired Employee**
*   **Problem:** For each employee, show their salary, and the salary of the employee hired immediately before them and immediately after them *within the same department*. Order by department and then by hire date. Include the names of the previous/next employees.
*   **Concepts:** `LAG() OVER()`, `LEAD() OVER()`, `PARTITION BY`, `ORDER BY`.

**Exercise AF.1.3: Running Total and Department Average Salary**
*   **Problem:** For each employee, display their name, department, salary, a running total of salaries within their department (ordered by hire date), and the average salary for their department. Also, show the total salary for their department.
*   **Concepts:** `SUM() OVER()`, `AVG() OVER()`, `PARTITION BY`, `ORDER BY` (for running total), frame clause.

#### (ii) Disadvantages and Pitfalls

**Exercise AF.2.1: Misinterpreting Ranking Functions**
*   **Problem:** Consider the 'Sales' department where 'Grace Davis' and 'Henry Wilson' have the same salary. Write a query to rank them by salary. Explain how the results of `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` would differ and which might be "misleading" if the user isn't careful about the specific requirement (e.g., if they wanted to identify distinct salary tiers).
*   **Concepts:** Nuances between `ROW_NUMBER`, `RANK`, `DENSE_RANK`.

**Exercise AF.2.2: Impact of `PARTITION BY` and `ORDER BY`**
*   **Problem:** Show how changing or omitting `PARTITION BY` or `ORDER BY` in a `LAG` function changes the result. Calculate `LAG(salary)`:
    1.  Partitioned by department, ordered by hire date.
    2.  No partition, ordered by hire date globally.
    3.  Explain what happens if you try to use `LAG` partitioned by department but with *no explicit order* in the `OVER` clause. Also, demonstrate `SUM() OVER()` with and without `PARTITION BY` and `ORDER BY` to show its different behaviors (department total vs. grand total vs. running total).
*   **Concepts:** Critical role of `PARTITION BY` and `ORDER BY` in window definitions.

#### (iii) Contrasting with Inefficient Common Solutions

**Exercise AF.3.1: Calculating Rank - Efficient vs. Inefficient**
*   **Problem:** Calculate the salary rank for each employee within their department (highest salary = rank 1, using dense ranking logic).
    *   First, describe how one might attempt this inefficiently using a correlated subquery.
    *   Then, provide the efficient Oracle Analytic Function solution.
*   **Concepts:** `DENSE_RANK() OVER()` vs. correlated subqueries for ranking.

---
### Category: Data Manipulation Language (DML) & Transaction Control (Practice in Oracle)
*(MERGE statement (Oracle Specific))*

#### (i) Meanings, Values, Relations, and Advantages

**Exercise DML.1.1: Basic UPSERT with MERGE**
*   **Problem:** Synchronize the `Employees` table with data from `EmployeeUpdates`.
    *   If an employee from `EmployeeUpdates` exists in `Employees` (match on `employeeId`), update their `jobTitle`, `salary`, and `email`.
    *   If an employee from `EmployeeUpdates` does not exist in `Employees`, insert them as a new record.
    *   Focus on records for Bob Green (employeeId 103 - for update) and Nina Young (employeeId 501 - for insert) from the `EmployeeUpdates` table. After running the MERGE, verify the changes and then `ROLLBACK`.
*   **Bridging Focus:** PostgreSQL users achieve UPSERT using `INSERT ... ON CONFLICT DO UPDATE`. `MERGE` is Oracle's more versatile equivalent.
*   **Concepts:** `MERGE INTO`, `USING`, `ON`, `WHEN MATCHED THEN UPDATE`, `WHEN NOT MATCHED THEN INSERT`.

**Exercise DML.1.2: MERGE with Conditional Update and Delete**
*   **Problem:** Use `MERGE` to update `Employees` based on `EmployeeUpdates`:
    1.  For 'Grace Davis' (employeeId 203), if her proposed salary in `EmployeeUpdates` is higher than her current salary, update her `jobTitle`, `salary`, and `email`.
    2.  Add a record to `EmployeeUpdates` for Carol White (employeeId 104) with `changeReason = 'Obsolete Role'`. Then, for any employee in `EmployeeUpdates` (matched with `Employees`) tagged with `changeReason = 'Obsolete Role'`, delete them from the `Employees` table.
    *   Perform these actions in a single `MERGE` statement. Verify changes and then `ROLLBACK`. Clean up the added 'Obsolete Role' record from `EmployeeUpdates`.
*   **Concepts:** `MERGE` with conditional `UPDATE` (using `WHERE` in `UPDATE` clause) and `WHEN MATCHED THEN DELETE`.

#### (ii) Disadvantages and Pitfalls

**Exercise DML.2.1: Non-Deterministic Source for MERGE**
*   **Problem:** The `EmployeeUpdates` table currently has two entries for `employeeId = 105` (David Black) with different salaries.
    1.  Attempt to use this non-deterministic source in a `MERGE` statement to update `Employees.salary`. Observe and explain the `ORA-30926` error.
    2.  Modify the `USING` clause of your `MERGE` statement to deterministically pick one of the update records for employeeId 105 (e.g., based on `changeReason`) to prevent the error. Execute the corrected `MERGE`, verify, and then `ROLLBACK`.
*   **Concepts:** `ORA-30926: unable to get a stable set of rows in the source tables`, ensuring deterministic source data for `MERGE`.

#### (iii) Contrasting with Inefficient Common Solutions

**Exercise DML.3.1: Synchronizing Data - MERGE vs. Procedural Logic**
*   **Problem:** Synchronize `Employees` with `EmployeeUpdates` for `employeeId = 204` (Henry Wilson - salary review, no change initially) and `employeeId = 501` (Nina Young - new hire). The `EmployeeUpdates` record for Henry Wilson (204) has a salary of 60000.
    *   First, describe conceptually (pseudo-code) how one might do this inefficiently using separate `UPDATE` and `INSERT` statements, perhaps with existence checks or within a PL/SQL loop.
    *   Then, provide the efficient Oracle `MERGE` solution. Ensure the `MERGE` only updates Henry Wilson if there is an actual change to his salary or other specified fields. Verify results and `ROLLBACK`.
*   **Concepts:** `MERGE` efficiency and atomicity vs. multiple DMLs/PL/SQL.

---
### (iv) Hardcore Combined Problem

**Scenario:**
The company is conducting an annual review. You need to perform a series of operations to update employee records and generate reports. *Use a PL/SQL anonymous block to manage the MERGE operation and its commit/rollback, and ensure you create a baseline copy of the Employees table named `EmployeesOriginal` before the MERGE.*

1.  **Propose Changes & MERGE:**
    *   Within a CTE named `ProposedChanges`, calculate new salaries and emails for employees.
        *   **Tenure:** Calculate `tenureYears` using `MONTHS_BETWEEN` and `SYSDATE`.
        *   **Ranking:** Determine `salaryRankInDept` using `DENSE_RANK() OVER()`.
        *   **Departmental Averages:** Calculate `avgSalaryDept` using `AVG() OVER()`.
        *   **Salary Adjustments (New Salary Calculation Logic within the CTE):**
            *   **Rule 1:** If `salaryRankInDept` is 1 AND `tenureYears` > 3, give a 7% raise.
            *   **Rule 2:** If current `salary` < 60% of `avgSalaryDept` AND `tenureYears` > 1, raise salary to the GREATER of (current `salary` * 1.05) OR (60% of `avgSalaryDept`). Round results.
            *   **Rule 3 (Simplified LAG use):** If an employee's current `salary` is less than 90% of the salary of the person ranked immediately above them in salary *within the same department* (use `LAG` ordering by salary ascending to find this) AND this employee is NOT a direct report of the CEO (employeeId 100), AND they are not already covered by Rule 1, give a 3% raise.
            *   Employees not meeting any of these conditions retain their current salary.
        *   **New Email:** Generate a `newEmail` in the format: `lowercase(firstinitial + lastname + '@megacorp.com')`. Use string functions like `SUBSTR`, `INSTR`, `LOWER`, and concatenation.
    *   Use a `MERGE` statement to update the `Employees` table with `newSalary` and `newEmail` from the `ProposedChanges` CTE. Only perform an `UPDATE` if the `newSalary` or `newEmail` is actually different from the current values.
    *   Commit the changes after the MERGE. Handle potential exceptions within the PL/SQL block with a `ROLLBACK`.

2.  **Post-Adjustment Reporting (after the MERGE is committed):**
    *   **Tech Hierarchy:** Display a hierarchical report for the 'Technology' department (departmentId 10). Show indented employee name, job title, their new salary, and their level in the hierarchy (`LEVEL`). Use `START WITH` for top managers in Tech and `CONNECT BY PRIOR`.
    *   **Top 2 Earners:** List the top 2 highest-paid employees (name, department name, salary) per department after the adjustments. Use `ROW_NUMBER() OVER()`.
    *   **Unchanged Salaries:** Using the `EmployeesOriginal` table and the updated `Employees` table, list the `employeeId`, `employeeName`, and `originalSalary` of employees whose salary did *not* change during the MERGE operation.

*Remember to drop the `EmployeesOriginal` table at the end of your script.*

**Concepts Integrated:**
*   **Current:** `CONNECT BY`, `LEVEL`, `START WITH`, `PRIOR`, `RANK`/`DENSE_RANK`/`ROW_NUMBER`, `LAG`, `SUM() OVER`, `AVG() OVER`, `MERGE`.
*   **Previous Oracle:** PL/SQL anonymous block, `CREATE TABLE AS SELECT`, `TO_DATE`, `SYSDATE`, `MONTHS_BETWEEN`, `NVL`, `CASE`, `LOWER`, `SUBSTR`, `INSTR`, `||` (concat), `MINUS` (conceptually for comparison, direct join/where for implementation).
*   **Foundational PostgreSQL (mirrored in Oracle):** CTEs (`WITH`), Joins, Aggregates, `WHERE`, `ORDER BY`.

---

<!-- 
    ********************************************************************************************************
    *** END OF EXERCISE PLACEHOLDER                                                                      ***
    ********************************************************************************************************
-->

## Tips for Success & Learning

To make the most of these exercises:

*   **Experiment Actively:** Don't just aim for the "correct" answer. Modify the queries, change conditions, and observe how the results differ. This builds deeper intuition.
    <div class="rhyme">
    A query tweaked, a condition bent,<br>
    New understanding heaven-sent.
    </div>
*   **Understand the "Why":** For each Oracle-specific feature, especially `CONNECT BY` and `MERGE`, focus on *why* it's designed the way it is and what problems it solves elegantly.
*   **Consult Oracle Documentation:** If a concept feels fuzzy, the official Oracle SQL Language Reference is your best friend for authoritative details.
*   **Deconstruct Complex Problems:** For the "Hardcore Combined Problem," break it down into smaller, manageable parts. Test each part (like the CTE) before assembling the whole.
*   **Practice Makes Permanent:** The more you use these constructs, the more natural they'll become.


## Conclusion & Next Steps

Well done on working through (or preparing to work through) these advanced Oracle SQL exercises! By mastering hierarchical queries, analytic functions, and the `MERGE` statement, you've significantly enhanced your ability to tackle complex data manipulation and analysis tasks in an Oracle environment. Your journey from PostgreSQL to Oracle fluency is taking great strides.

<div class="rhyme">
With `CONNECT BY`, the trees take flight,<br>
Analytics gleam, with insight bright.<br>
And `MERGE` combines with graceful ease,<br>
Your Oracle skills now aim to please!
</div>

Having solidified these querying techniques, you're well-prepared to venture into handling even more complex data structures. The next exciting topics in your "Server Programming with Oracle (DB 23 ai) PL/SQL: A Transition Guide for PostgreSQL Users" journey include:

*   **Handling Complex Data Types (Job Relevance: XML):**
    *   `XMLTYPE` Data Type
    *   Key functions for XML processing: `XMLTABLE`, `XMLELEMENT`, `XMLFOREST`, `XMLAGG`
    *   XPath expressions

Keep exploring, keep coding, and keep questioning!
</div>