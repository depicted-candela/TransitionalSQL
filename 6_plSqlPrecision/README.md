<head>
    <link rel="stylesheet" href="../styles/lecture.css">
</head>

<div class="toc-popup-container">
    <input type="checkbox" id="toc-toggle" class="toc-toggle-checkbox">
    <label for="toc-toggle" class="toc-toggle-label">
        <span class="toc-icon-open"></span>
        Contents
    </label>
    <div class="toc-content">
        <ul>
            <li><a href="#section1">1. What Are They? (Meanings & Values)</a>
                <ul>
                    <li><a href="#cursors-oracle">1.1 Cursors in Oracle</a></li>
                    <li><a href="#stored-procs-funcs-oracle">1.2 Stored Procedures & Functions</a></li>
                </ul>
            </li>
            <li><a href="#section2">2. Relations: How They Play with Others</a>
                <ul>
                    <li><a href="#cursor-relations">2.1 Cursor Relations</a></li>
                    <li><a href="#proc-func-relations">2.2 Procedure & Function Relations</a></li>
                    <li><a href="#transitional-cursor-proc-func">2.3 Transitional: PostgreSQL to Oracle</a></li>
                </ul>
            </li>
            <li><a href="#section3">3. How to Use Them: Structures & Syntax</a>
                <ul>
                    <li><a href="#implicit-cursors-syntax">3.1 Implicit Cursors</a></li>
                    <li><a href="#explicit-cursors-syntax">3.2 Explicit Cursors</a></li>
                    <li><a href="#cursor-for-loops-syntax">3.3 Cursor FOR Loops</a></li>
                    <li><a href="#procedures-syntax">3.4 Stored Procedures</a></li>
                    <li><a href="#functions-syntax">3.5 Stored Functions</a></li>
                    <li><a href="#parameter-modes-syntax">3.6 Parameter Modes</a></li>
                </ul>
            </li>
            <li><a href="#section4">4. Why Use Them? (Advantages)</a>
                <ul>
                    <li><a href="#advantages-cursors">4.1 Advantages of Cursors</a></li>
                    <li><a href="#advantages-procs-funcs">4.2 Advantages of Procedures & Functions</a></li>
                </ul>
            </li>
            <li><a href="#section5">5. Watch Out! (Disadvantages & Pitfalls)</a>
                <ul>
                    <li><a href="#disadvantages-cursors">5.1 Cursor Disadvantages & Pitfalls</a></li>
                    <li><a href="#disadvantages-procs-funcs">5.2 Procedure & Function Disadvantages & Pitfalls</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>


<div class="container">

# PL/SQL Precision: Cursors, Procedures, and Data Flow <a id="main-title"></a>

Welcome to the realm of PL/SQL precision, where data flows with grace and vision!
We'll explore cursors that cruise, and procedures that produce, the results you envision.
From PostgreSQL's familiar lands, to Oracle's new commands, this guide will aid your transition.

## 1. What Are They? (Meanings & Values in Oracle) <a id="section1"></a>

This section defines cursors, procedures, and functions in Oracle PL/SQL, highlighting their core meanings and the values they help manage.

### 1.1 Cursors in Oracle <a id="cursors-oracle"></a>

In Oracle, a **cursor** is essentially a pointer to a private SQL area—a memory region allocated by Oracle when a SQL statement is processed. This area contains information about the statement and the data it affects or retrieves. Think of it as a handle, or a named control structure, that lets your PL/SQL program manage the results of a SQL query, often row by row.
<div class="rhyme">
A cursor, a pointer so neat,<br>
Helps manage SQL data, oh what a treat!
</div>

There are two main types of cursors in Oracle:
*   **Implicit Cursors:** Oracle automatically creates and manages these for all SQL DML statements (INSERT, UPDATE, DELETE) and `SELECT ... INTO` statements executed within a PL/SQL block. You don't declare them, but you can access their attributes (like `SQL%FOUND`, `SQL%NOTFOUND`, `SQL%ROWCOUNT`, `SQL%ISOPEN`) to get information about the most recently executed SQL statement.<sup class="footnote-ref"><a href="#fn1" id="fnref1">[1]</a></sup>
    *   **Value:** The "value" of an implicit cursor is a set of boolean or numeric attributes reflecting the outcome of the last SQL operation. For instance, `SQL%ROWCOUNT` gives the number of rows affected.
*   **Explicit Cursors:** You, the developer, declare an explicit cursor in the declarative section of a PL/SQL block, typically for queries that return multiple rows. This gives you fine-grained control. You explicitly `OPEN` the cursor (to execute the associated query), `FETCH` rows one at a time (or in bulk), and `CLOSE` the cursor to release resources.<sup class="footnote-ref"><a href="#fn2" id="fnref2">[2]</a></sup>
    *   **Value:** The "value" of an explicit cursor, when open, is the active result set of its query. Individual rows are fetched into variables or records. Attributes like `cursorName%FOUND`, `cursorName%NOTFOUND`, `cursorName%ROWCOUNT`, and `cursorName%ISOPEN` provide status information.
*   **Cursor FOR Loops:** This is a convenient PL/SQL construct that simplifies working with explicit cursors. It implicitly declares a loop variable (usually a record), opens the cursor, fetches rows into the record one by one, and closes the cursor when all rows are processed or the loop is exited.
    *   **Value:** The loop variable in a cursor FOR loop holds the data for the current row being processed in each iteration.

<div class="postgresql-bridge" id="cursor-pg-bridge">
<strong>PostgreSQL Bridge:</strong> PostgreSQL users are familiar with looping through query results using `FOR record_variable IN query LOOP ... END LOOP;`. This is very similar to Oracle's cursor FOR loop. PostgreSQL also has cursors that can be explicitly declared (using `DECLARE cursor_name CURSOR FOR query`), opened, fetched from, and closed, primarily used for processing large result sets without loading everything into memory at once. Oracle's explicit cursor syntax and management are distinct but serve a similar purpose of row-by-row processing. The concept of implicit cursor attributes like `SQL%FOUND` is more specific to Oracle's PL/SQL; in PostgreSQL, one typically checks `FOUND` special variable or uses `GET DIAGNOSTICS row_count = ROW_COUNT`.
</div>

### 1.2 Stored Procedures & Functions in Oracle <a id="stored-procs-funcs-oracle"></a>

**Stored Procedures** and **Stored Functions** are named PL/SQL blocks that are compiled and stored in the database. They can be invoked (called) repeatedly.
<div class="rhyme">
Procedures and functions, stored with care,<br>
Reusable logic, beyond compare!
</div>

*   **Stored Procedure:** A named PL/SQL block that performs one or more specific actions. It does *not* directly return a value through its name, though it can return values via `OUT` or `IN OUT` parameters.<sup class="footnote-ref"><a href="#fn3" id="fnref3">[3]</a></sup>
    *   **Value/Output:** Procedures achieve their "value" by performing actions like DML operations, calling other procedures, or modifying `OUT`/`IN OUT` parameters.
*   **Stored Function:** A named PL/SQL block that *must* return a single value to the caller. This value is specified using the `RETURN` keyword and its data type is defined in the function's header.<sup class="footnote-ref"><a href="#fn4" id="fnref4">[4]</a></sup>
    *   **Value/Output:** The primary "value" of a function is the single value it returns. Functions can also have `OUT` or `IN OUT` parameters, but this is less common and often discouraged as it can make the function's purpose less clear and limit its usability in SQL statements.

**Key Concepts for Procedures and Functions:**
*   **Parameters:** Subprograms can accept parameters to receive input values and/or return output values. Oracle supports three parameter modes:
    *   `IN`: The parameter's value is passed into the subprogram. Inside the subprogram, it acts like a constant and cannot be reassigned. This is the default mode if none is specified. (Value is passed by reference typically, but cannot be changed).
    *   `OUT`: The parameter is used to return a value from the subprogram to the caller. Its initial value within the subprogram is `NULL` (unless it's a record type with default field values). The subprogram is expected to assign a value to it. (Value is passed by value; the actual parameter gets the final value upon successful completion).
    *   `IN OUT`: The parameter's value is passed into the subprogram, can be modified by the subprogram, and the (potentially modified) value is passed back to the caller. (Value is passed by value initially, and the final value is passed back).
*   **`RETURN` Statement:**
    *   In a **function**, a `RETURN expression;` statement is mandatory to specify the value the function sends back to the caller. Every execution path in a function must lead to a `RETURN` statement.
    *   In a **procedure**, a `RETURN;` statement (without an expression) can be used to immediately exit the procedure and return control to the caller. It's optional; if omitted, the procedure exits after its last executable statement.

<div class="postgresql-bridge" id="proc-func-pg-bridge">
<strong>PostgreSQL Bridge:</strong> PostgreSQL also has functions, and its procedures (introduced in version 11) are similar to Oracle's. PostgreSQL functions can return values via `RETURN` or `OUT` parameters (or `INOUT`). Oracle's distinction between a `PROCEDURE` (primarily for actions, no direct return via name) and a `FUNCTION` (must return a value via name) is a key syntactic and conceptual difference. Parameter modes (`IN`, `OUT`, `INOUT`) are conceptually similar, though the underlying pass-by-value/reference semantics might have subtle differences in implementation or default behavior if `NOCOPY` hint is not used in Oracle.
</div>

## 2. Relations: How They Play with Others (in Oracle) <a id="section2"></a>

Understanding how these concepts interact with each other and with previously learned Oracle/PLSQL elements is crucial.

### 2.1 Cursor Relations <a id="cursor-relations"></a>

*   **Implicit Cursors & DML/SELECT INTO:** Implicit cursors are intrinsically linked to DML (`INSERT`, `UPDATE`, `DELETE`) and `SELECT ... INTO` statements. Their attributes (`SQL%FOUND`, `SQL%ROWCOUNT`, etc.) provide feedback on the outcome of these SQL operations executed within PL/SQL.<sup class="footnote-ref"><a href="#fn1" id="fnref1_2">[1]</a></sup>
*   **Explicit Cursors & Variables/Records:** Explicit cursors `FETCH` data *into* PL/SQL variables or records. The data types of these variables/records must be compatible with the columns selected by the cursor. Using `%TYPE` and `%ROWTYPE` (from PL/SQL Fundamentals) ensures this compatibility and makes code resilient to table structure changes.
*   **Cursor FOR Loops & Implicit Record Declaration:** A cursor `FOR` loop implicitly declares a record variable of the cursor's row type. This simplifies code as you don't need to manually declare the fetch target.
*   **Cursors & Transactions:** Cursors operate within the context of a transaction. `COMMIT` or `ROLLBACK` (from DML & Transaction Control) will typically affect cursor states (e.g., a `FOR UPDATE` cursor releases locks on commit/rollback). Closing a cursor does not automatically commit or rollback a transaction.
*   **Cursors & PL/SQL Block Structure:** Explicit cursors are declared in the `DECLARE` section of a PL/SQL block (anonymous block, procedure, or function). They are opened, fetched from, and closed within the `BEGIN...END` section. Their scope is tied to the block they are declared in.

<div class="rhyme">
A cursor fetches data, row by row with a grin,<br>
Into variables or records, let the processing begin!
</div>

### 2.2 Procedure & Function Relations <a id="proc-func-relations"></a>

*   **Procedures/Functions & PL/SQL Blocks:** They *are* named PL/SQL blocks. They share the same fundamental structure: `DECLARE` (optional for procedures/functions, but the parameter list serves a similar purpose for inputs), `BEGIN`, `EXCEPTION` (optional), `END`.
*   **Procedures/Functions & Variables/Constants:** They can declare their own local variables and constants within their `DECLARE` section (or after `AS`/`IS` before `BEGIN`). These are scoped locally to the subprogram.
*   **Procedures/Functions & SQL:** They routinely embed SQL DML statements and `SELECT ... INTO` for data manipulation and retrieval.
*   **Procedures/Functions & Cursors:** They can declare, open, fetch from, and close both implicit and explicit cursors to process query results.
*   **Calling Procedures/Functions:** Procedures can call other procedures or functions. Functions can call other functions or procedures (though procedures called from functions must not violate purity rules if the function is used in SQL).
*   **Parameter Modes & Data Flow:**
    *   `IN` parameters receive values (constants, variables, expressions).
    *   `OUT` parameters require a variable in the calling environment to receive the output.
    *   `IN OUT` parameters require a variable in the calling environment to both send an initial value and receive a potentially modified value.
*   **RETURN Statement (Functions):** The `RETURN` statement in a function is critical; it defines the function's output value. Its data type must match the `RETURN` type declared in the function header.
*   **RETURN Statement (Procedures):** The `RETURN` statement in a procedure allows for an early exit from the procedure. It does not return a value.

<div class="rhyme">
A procedure acts, a function returns what's due,<br>
With parameters IN, OUT, or IN OUT for you!
</div>

### 2.3 Transitional: PostgreSQL to Oracle Cursors and Subprograms <a id="transitional-cursor-proc-func"></a>

*   **Cursors:**
    *   **PostgreSQL:** `FOR rec IN SELECT ... LOOP` is common for row-by-row processing. Explicit cursors (`DECLARE c CURSOR FOR ...; OPEN c; FETCH c INTO ...; CLOSE c;`) are also available, often used with `REF CURSOR` types passed to/from functions.
    *   **Oracle:** Cursor FOR loops (`FOR rec IN (SELECT ...) LOOP` or `FOR rec IN cursor_name LOOP`) are very similar and preferred for simplicity. Oracle's explicit cursor syntax (`CURSOR c IS SELECT ...; OPEN c; FETCH c INTO ...; CLOSE c;`) is standard. Oracle's implicit cursor attributes (`SQL%FOUND`, `SQL%NOTFOUND`, `SQL%ROWCOUNT`) offer a standardized way to check DML outcomes, whereas PostgreSQL often uses the `FOUND` variable or `GET DIAGNOSTICS`.
*   **Subprograms (Procedures & Functions):**
    *   **PostgreSQL:** Uses `CREATE FUNCTION` for both procedures (returning `void` or using `OUT` parameters) and functions (returning a specific type). The `CREATE PROCEDURE` syntax was added in later versions (v11+) for SQL-standard compliance and better clarity for routines not returning a value directly.
    *   **Oracle:** Has a clear distinction with `CREATE PROCEDURE` (no direct return via name) and `CREATE FUNCTION` (must have a `RETURN` clause specifying the data type and a `RETURN expression` in the body).
    *   **Parameter Modes:** `IN`, `OUT`, `INOUT` are conceptually similar. Oracle's `NOCOPY` hint for `OUT` and `IN OUT` parameters, which suggests pass-by-reference, is an Oracle-specific optimization detail.
    *   **Return Values from Procedures:** In PostgreSQL, a "procedure-like" function might use multiple `OUT` parameters. In Oracle, procedures use `OUT` or `IN OUT` parameters to return values; functions primarily use the `RETURN` statement for a single value.

## 3. How to Use Them: Structures & Syntax (in Oracle) <a id="section3"></a>

This section details the syntax and common usage patterns. For detailed syntax diagrams, always consult the official Oracle documentation.<sup class="footnote-ref"><a href="#fn5" id="fnref5">[5]</a></sup>

*(Examples will use the dataset provided at the beginning).*

### 3.1 Implicit Cursors <a id="implicit-cursors-syntax"></a>
Managed by Oracle. Accessed via attributes after DML or `SELECT INTO`.

**Syntax (Accessing Attributes):**
```sql
SQL%FOUND       -- BOOLEAN: TRUE if last SQL affected/returned one or more rows
SQL%NOTFOUND    -- BOOLEAN: TRUE if last SQL affected/returned no rows (logical opposite of SQL%FOUND)
SQL%ROWCOUNT    -- INTEGER: Number of rows affected by last DML or fetched by SELECT INTO
SQL%ISOPEN      -- BOOLEAN: Always FALSE for implicit cursors when checked in PL/SQL
```

**Example:**
```sql
SET SERVEROUTPUT ON;
DECLARE
    vSalary employees.salary%TYPE;
    vDepartmentId departments.departmentId%TYPE := 30;
BEGIN
    UPDATE employees SET salary = salary * 1.05 WHERE departmentId = vDepartmentId;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' employees in department ' || vDepartmentId || ' received a raise.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No employees found in department ' || vDepartmentId || ' for a raise.');
    END IF;
    
    -- Example of SELECT INTO with implicit cursor attributes
    BEGIN
      SELECT salary INTO vSalary FROM employees WHERE employeeId = 101;
      DBMS_OUTPUT.PUT_LINE('Salary for employee 101: ' || vSalary || '. SQL%ROWCOUNT after SELECT INTO: ' || SQL%ROWCOUNT); -- Will be 1
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee 101 not found. SQL%FOUND is ' || CASE WHEN SQL%FOUND THEN 'TRUE' ELSE 'FALSE' END); -- Will be FALSE
    END;

    ROLLBACK;
END;
/
```

### 3.2 Explicit Cursors <a id="explicit-cursors-syntax"></a>
Declared by the user for multi-row queries.

**Syntax (Declaration, Open, Fetch, Close):**
```sql
DECLARE
    CURSOR cursorName [(parameter1 datatype, ...)] IS
        SELECT_statement;
    
    variable1 cursorName%ROWTYPE; -- To fetch a whole row
    -- OR
    variable2 column1%TYPE;       -- To fetch individual columns
    variable3 column2%TYPE;
BEGIN
    OPEN cursorName [(actual_parameter1, ...)];
    
    LOOP
        FETCH cursorName INTO variable1; -- or INTO variable2, variable3 ...
        EXIT WHEN cursorName%NOTFOUND;
        -- Process fetched data
    END LOOP;
    
    CLOSE cursorName;
END;
```
**Attributes:** `cursorName%FOUND`, `cursorName%NOTFOUND`, `cursorName%ROWCOUNT`, `cursorName%ISOPEN`.

**Example:**
```sql
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cMarketingEmps IS
        SELECT employeeId, firstName, lastName
        FROM employees
        WHERE departmentId = (SELECT departmentId FROM departments WHERE departmentName = 'Marketing');
    
    vEmpRec cMarketingEmps%ROWTYPE;
BEGIN
    OPEN cMarketingEmps;
    DBMS_OUTPUT.PUT_LINE('Marketing Employees:');
    LOOP
        FETCH cMarketingEmps INTO vEmpRec;
        EXIT WHEN cMarketingEmps%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vEmpRec.employeeId || ': ' || vEmpRec.firstName || ' ' || vEmpRec.lastName);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Marketing employees fetched: ' || cMarketingEmps%ROWCOUNT);
    CLOSE cMarketingEmps;
END;
/
```

### 3.3 Cursor FOR Loops <a id="cursor-for-loops-syntax"></a>
Simplifies explicit cursor usage.

**Syntax:**
```sql
BEGIN
    FOR recordName IN (SELECT_statement) LOOP
        -- process recordName.columnName
    END LOOP;

    -- OR with a pre-declared cursor
    -- FOR recordName IN cursorName [(actual_parameters...)] LOOP
    --     -- process recordName.columnName
    -- END LOOP;
END;
```
**Example:**
```sql
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('HR Department Employees (Cursor FOR Loop):');
    FOR empRec IN (
        SELECT employeeId, firstName, lastName, salary
        FROM employees e
        JOIN departments d ON e.departmentId = d.departmentId
        WHERE d.departmentName = 'Human Resources'
        ORDER BY e.lastName
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(empRec.lastName || ', ' || empRec.firstName || ' - Salary: ' || empRec.salary);
    END LOOP;
END;
/
```

### 3.4 Stored Procedures <a id="procedures-syntax"></a>
Named PL/SQL blocks for actions.

**Syntax (Creation):**<sup class="footnote-ref"><a href="#fn3" id="fnref3_2">[3]</a></sup>
```sql
CREATE [OR REPLACE] PROCEDURE procedureName
    [(parameter1 [IN|OUT|IN OUT] datatype [DEFAULT expression], ...)]
AS -- or IS
    -- Declarations (optional)
BEGIN
    -- Executable statements
EXCEPTION -- Optional
    -- Exception handlers
END [procedureName];
/
```
**Syntax (Execution):**
```sql
-- From PL/SQL
BEGIN
    procedureName(actual_parameter1, ...);
END;
/

-- From SQL*Plus (or similar tools)
EXECUTE procedureName(actual_parameter1, ...);
-- or
CALL procedureName(actual_parameter1, ...); 
```

**Example:**
```sql
CREATE OR REPLACE PROCEDURE updateEmployeeSalary (
    pEmployeeId IN employees.employeeId%TYPE,
    pNewSalary IN employees.salary%TYPE
) AS
BEGIN
    UPDATE employees
    SET salary = pNewSalary
    WHERE employeeId = pEmployeeId;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee ' || pEmployeeId || ' not found. Salary not updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Salary for employee ' || pEmployeeId || ' updated to ' || pNewSalary);
        -- COMMIT; -- Often handled by calling application or another procedure
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error updating salary for ' || pEmployeeId || ': ' || SQLERRM);
        -- ROLLBACK;
END updateEmployeeSalary;
/

SET SERVEROUTPUT ON;
BEGIN
    updateEmployeeSalary(101, 55000);
    updateEmployeeSalary(999, 60000); -- Non-existent
    ROLLBACK; -- To revert test changes
END;
/
```

### 3.5 Stored Functions <a id="functions-syntax"></a>
Named PL/SQL blocks that return a single value.

**Syntax (Creation):**<sup class="footnote-ref"><a href="#fn4" id="fnref4_2">[4]</a></sup>
```sql
CREATE [OR REPLACE] FUNCTION functionName
    [(parameter1 [IN] datatype [DEFAULT expression], ...)]
RETURN return_datatype
AS -- or IS
    -- Declarations (optional)
BEGIN
    -- Executable statements
    RETURN expression; -- At least one RETURN statement is mandatory
EXCEPTION -- Optional
    -- Exception handlers (might also include a RETURN)
END [functionName];
/
```
**Syntax (Execution):**
```sql
-- From PL/SQL
DECLARE
    vResult return_datatype;
BEGIN
    vResult := functionName(actual_parameter1, ...);
END;
/

-- From SQL (if function meets purity levels)
SELECT functionName(column_name, ...) FROM tableName;
```

**Example:**
```sql
CREATE OR REPLACE FUNCTION getDepartmentLocation (
    pDepartmentId IN departments.departmentId%TYPE
) RETURN VARCHAR2
AS
    vLocation departments.location%TYPE;
BEGIN
    SELECT location INTO vLocation
    FROM departments
    WHERE departmentId = pDepartmentId;
    RETURN vLocation;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown Location';
END getDepartmentLocation;
/

SET SERVEROUTPUT ON;
-- Using in PL/SQL
DECLARE
    loc VARCHAR2(100);
BEGIN
    loc := getDepartmentLocation(30);
    DBMS_OUTPUT.PUT_LINE('Location of Department 30: ' || loc);
    loc := getDepartmentLocation(99);
    DBMS_OUTPUT.PUT_LINE('Location of Department 99: ' || loc);
END;
/

-- Using in SQL
SELECT departmentName, getDepartmentLocation(departmentId) AS deptLocation
FROM departments;
```

### 3.6 Parameter Modes <a id="parameter-modes-syntax"></a>
Control data flow for procedure/function parameters.

*   **IN (Default):** Passes a value into the subprogram. Cannot be modified.
*   **OUT:** Returns a value from the subprogram. Initial value inside is `NULL`. Must be assigned a value.
*   **IN OUT:** Passes a value in, can be modified, and the modified value is returned.

**Example (Illustrating all modes):**
```sql
CREATE OR REPLACE PROCEDURE demoParameterModes (
    pInParam IN VARCHAR2,
    pOutParam OUT NUMBER,
    pInOutParam IN OUT DATE
) AS
    vLocalTemp VARCHAR2(100);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inside procedure:');
    DBMS_OUTPUT.PUT_LINE('  IN pInParam: ' || pInParam);
    -- pInParam := 'New Value'; -- This would cause a compile error

    -- pOutParam is initially NULL (or uninitialized if actual param had no value)
    DBMS_OUTPUT.PUT_LINE('  OUT pOutParam (initial): ' || NVL(TO_CHAR(pOutParam), 'NULL'));
    pOutParam := LENGTH(pInParam) * 10; -- Assign value to OUT parameter

    DBMS_OUTPUT.PUT_LINE('  IN OUT pInOutParam (initial): ' || TO_CHAR(pInOutParam, 'YYYY-MM-DD'));
    pInOutParam := pInOutParam + LENGTH(pInParam); -- Modify IN OUT parameter
    
    DBMS_OUTPUT.PUT_LINE('After modification:');
    DBMS_OUTPUT.PUT_LINE('  OUT pOutParam: ' || pOutParam);
    DBMS_OUTPUT.PUT_LINE('  IN OUT pInOutParam: ' || TO_CHAR(pInOutParam, 'YYYY-MM-DD'));
END demoParameterModes;
/

SET SERVEROUTPUT ON;
DECLARE
    vInput VARCHAR2(20) := 'Oracle';
    vOutput NUMBER; -- Does not need initialization for OUT
    vInOut DATE := SYSDATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before call:');
    DBMS_OUTPUT.PUT_LINE('  vInput: ' || vInput);
    DBMS_OUTPUT.PUT_LINE('  vOutput: ' || NVL(TO_CHAR(vOutput), 'NULL'));
    DBMS_OUTPUT.PUT_LINE('  vInOut: ' || TO_CHAR(vInOut, 'YYYY-MM-DD'));

    demoParameterModes(vInput, vOutput, vInOut);

    DBMS_OUTPUT.PUT_LINE('After call:');
    DBMS_OUTPUT.PUT_LINE('  vInput (unchanged): ' || vInput);
    DBMS_OUTPUT.PUT_LINE('  vOutput (from procedure): ' || vOutput);
    DBMS_OUTPUT.PUT_LINE('  vInOut (modified by procedure): ' || TO_CHAR(vInOut, 'YYYY-MM-DD'));
END;
/
```
<div class="rhyme">
Parameters flow IN, or come OUT anew,<br>
Sometimes IN OUT, for a modified view!
</div>

<div class="oracle-specific" id="oracle-specific-env">
<strong>Practicing Examples:</strong> These PL/SQL examples can be run in Oracle environments like Oracle Live SQL (web-based), a local Oracle XE (Express Edition) database with SQL Developer, or any standard Oracle Database installation. SQL Developer provides a user-friendly interface for creating, running, and debugging PL/SQL code.
</div>

## 4. Why Use Them? (Advantages in Oracle) <a id="section4"></a>

### 4.1 Advantages of Cursors <a id="advantages-cursors"></a>

*   **Row-by-Row Processing:** Cursors allow you to process the result set of a query one row at a time, which is essential when complex logic needs to be applied to each individual row that cannot be achieved with a single SQL statement.
*   **Fine-Grained Control (Explicit Cursors):** You control when the query is executed (OPEN), when data is retrieved (FETCH), and when resources are released (CLOSE).
*   **Status Checking:** Cursor attributes (`%FOUND`, `%NOTFOUND`, `%ROWCOUNT`, `%ISOPEN`) provide immediate feedback on the state of cursor operations, allowing for robust error handling and conditional logic.
*   **Simplification (Cursor FOR Loops):** Cursor FOR loops significantly reduce the amount of code needed for common cursor operations by handling open, fetch, exit condition, and close implicitly, making code cleaner and less error-prone. This is an advantage in its own right.
*   **Handling Multi-Row Queries Safely:** Unlike `SELECT ... INTO` which fails if zero or more than one row is returned, cursors are designed for multi-row results. The `NO_DATA_FOUND` condition with cursors is not an exception but a status indicated by `%NOTFOUND`.

<div class="rhyme">
When SQL alone just won't suffice,<br>
Cursors process rows, precise and nice!
</div>

### 4.2 Advantages of Procedures & Functions <a id="advantages-procs-funcs"></a>

*   **Modularity:** Break down complex applications into smaller, manageable, logical units. Each subprogram can focus on a specific task.
*   **Reusability:** Stored subprograms are compiled and stored in the database, allowing them to be called by multiple applications or different parts of the same application, reducing redundant code.<sup class="footnote-ref"><a href="#fn6" id="fnref6">[6]</a></sup>
*   **Maintainability:** Changes to the logic within a subprogram body do not necessarily require changes to the calling applications, as long as the subprogram's interface (name and parameters) remains the same. This simplifies updates and bug fixes.
*   **Improved Performance:**
    *   Stored subprograms run directly within the database server, reducing network traffic compared to sending individual SQL statements from a client.
    *   They are compiled once and stored in executable form. Subsequent calls use the compiled version, avoiding repeated parsing and optimization overhead.
*   **Security:**
    *   You can grant `EXECUTE` privileges on a subprogram to a user without granting privileges on the underlying tables it accesses (especially with definer's rights, the default). This allows controlled access to data.
    *   Business logic is centralized in the database, making it harder to bypass.
*   **Extensibility of SQL (Functions):** User-defined functions can be used in SQL expressions, extending the capabilities of SQL to perform complex calculations or data manipulations that are not possible with standard SQL functions.
*   **Transaction Control Encapsulation:** Procedures can encapsulate parts of a transaction, including `COMMIT` or `ROLLBACK`, ensuring atomicity for specific business operations.
*   **Clearer Code:** Well-named procedures and functions make the overall application logic easier to read and understand.

<div class="rhyme">
For logic reused, and actions so grand,<br>
Procedures and functions, throughout the land!
</div>

## 5. Watch Out! (Disadvantages & Pitfalls in Oracle) <a id="section5"></a>

### 5.1 Cursor Disadvantages & Pitfalls <a id="disadvantages-cursors"></a>

*   **Performance Overhead for Row-by-Row Processing:** Processing data row-by-row using cursors (often called "slow-by-slow" processing) is generally less efficient than set-based SQL operations. If the logic can be expressed in a single SQL statement, that is usually preferable.<sup class="footnote-ref"><a href="#fn7" id="fnref7">[7]</a></sup>
*   **Resource Consumption (Explicit Cursors):** Each open cursor consumes server resources (memory, locks if `FOR UPDATE` is used). Forgetting to `CLOSE` explicit cursors can lead to:
    *   `ORA-01000: maximum open cursors exceeded`.
    *   `ORA-06511: PL/SQL: cursor already open` if attempting to re-open a named cursor that wasn't closed.
*   **`SELECT ... INTO` Pitfalls:** While `SELECT ... INTO` uses an implicit cursor, it's prone to:
    *   `NO_DATA_FOUND` if no rows are returned.
    *   `TOO_MANY_ROWS` if more than one row is returned.
    Explicit cursors or cursor FOR loops handle these scenarios more gracefully by design.
*   **Implicit Cursor Attribute Scope:** `SQL%FOUND`, `SQL%NOTFOUND`, `SQL%ROWCOUNT` refer to the *most recently executed* SQL statement. If another SQL statement (e.g., inside a called procedure, or even a `DBMS_OUTPUT.PUT_LINE` if it internally flushes via SQL) executes before you check these attributes, their values will reflect the outcome of that *other* statement, not the one you intended to check. Always save attribute values to local variables immediately if needed later.
*   **Complexity (Explicit Cursors):** Manual management of `OPEN`, `FETCH`, loop termination logic, and `CLOSE` for explicit cursors can be verbose and error-prone compared to cursor FOR loops or set-based SQL.

<div class="rhyme">
If cursors you fail to close with might,<br>
Resources will vanish, and errors take flight!
</div>

### 5.2 Procedure & Function Disadvantages & Pitfalls <a id="disadvantages-procs-funcs"></a>

*   **Overuse Leading to Poor SQL:** Encapsulating simple SQL logic that could be done in a single efficient SQL statement into many small procedure/function calls can degrade performance due to context switching between PL/SQL and SQL engines.
*   **Hidden Complexity:** While modularity is good, deeply nested calls between procedures and functions can sometimes make debugging and understanding the overall application flow more complex.
*   **Transaction Mismanagement:** If procedures performing DML don't handle `COMMIT` and `ROLLBACK` consistently or as expected by the calling application, it can lead to data inconsistencies or incomplete transactions.
*   **Purity Rules for Functions in SQL:** Functions called from SQL statements have restrictions (e.g., cannot perform DML, unless using `PRAGMA AUTONOMOUS_TRANSACTION`, which has its own considerations). Violating these rules leads to runtime errors (`ORA-14551`).<sup class="footnote-ref"><a href="#fn8" id="fnref8">[8]</a></sup>
*   **`OUT` Parameter Uninitialization:** If an `OUT` parameter is not assigned a value in all execution paths of a procedure, its value in the calling environment will be the value the actual parameter had *before* the call. This can be confusing if the caller expects it to be `NULL` or a specific default.
*   **`NOCOPY` Hint Behavior:** The `NOCOPY` hint for `OUT` and `IN OUT` parameters is only a hint to the compiler to attempt pass-by-reference. The compiler may ignore it in certain situations, leading to pass-by-value behavior. Relying on `NOCOPY` for specific side effects (like seeing changes immediately in aliased global variables) can make code less predictable.
*   **Security Risks with Definer's Rights (Default):** While definer's rights can be useful for controlled access, if the procedure has overly broad privileges or contains dynamic SQL susceptible to injection, it can be a security risk as it runs with the owner's privileges. Invoker's rights (`AUTHID CURRENT_USER`) mitigate this but require the invoker to have direct privileges on underlying objects.
*   **Performance of Functions in `WHERE` Clause:** Functions in a `WHERE` clause can prevent the optimizer from using indexes on the columns passed to the function, potentially leading to full table scans. Function-based indexes can mitigate this.

<div class="rhyme">
A function in SQL, with DML inside,<br>
Will raise an error, nowhere to hide!
</div>

</div> <!-- End of container -->

<div class="footnotes">
  <hr>
  <ol>
    <li id="fn1">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 7, "Implicit Cursors". Details attributes like SQL%FOUND, SQL%NOTFOUND, SQL%ROWCOUNT, and SQL%ISOPEN. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/oracle-database-pl-sql-language-reference/ch07_static-sql.pdf" title="Oracle Database PL/SQL Language Reference - Chapter 7">PL/SQL Ref - Ch7</a> - Pages 7-6 to 7-8. <a href="#fnref1" title="Jump back to footnote 1 in the text">↩</a> <a href="#fnref1_2" title="Jump back to footnote 1_2 in the text">↩</a></p>
    </li>
    <li id="fn2">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 7, "Explicit Cursors". Covers declaration, OPEN, FETCH, CLOSE statements, and attributes. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/oracle-database-pl-sql-language-reference/ch07_static-sql.pdf" title="Oracle Database PL/SQL Language Reference - Chapter 7">PL/SQL Ref - Ch7</a> - Pages 7-9 to 7-23. <a href="#fnref2" title="Jump back to footnote 2 in the text">↩</a></p>
    </li>
    <li id="fn3">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 9, "Subprogram Parts" and "Procedure Declaration and Definition". Explains procedure syntax and structure. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/oracle-database-pl-sql-language-reference/ch09_subprograms.pdf" title="Oracle Database PL/SQL Language Reference - Chapter 9">PL/SQL Ref - Ch9</a> - Pages 9-3, and Language Elements Ch14 page 14-141 for full syntax. <a href="#fnref3" title="Jump back to footnote 3 in the text">↩</a> <a href="#fnref3_2" title="Jump back to footnote 3_2 in the text">↩</a></p>
    </li>
    <li id="fn4">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 9, "Additional Parts for Functions" and "Function Declaration and Definition". Details function syntax including the RETURN clause. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/oracle-database-pl-sql-language-reference/ch09_subprograms.pdf" title="Oracle Database PL/SQL Language Reference - Chapter 9">PL/SQL Ref - Ch9</a> - Page 9-5, and Language Elements Ch14 page 14-108 for full syntax. <a href="#fnref4" title="Jump back to footnote 4 in the text">↩</a> <a href="#fnref4_2" title="Jump back to footnote 4_2 in the text">↩</a></p>
    </li>
    <li id="fn5">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 14, "PL/SQL Language Elements". This chapter serves as a comprehensive syntax reference. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/oracle-database-pl-sql-language-reference/ch14_language-elements.pdf" title="Oracle Database PL/SQL Language Reference - Chapter 14">PL/SQL Ref - Ch14</a>. <a href="#fnref5" title="Jump back to footnote 5 in the text">↩</a></p>
    </li>
     <li id="fn6">
      <p>Oracle Database Development Guide, 23ai, Chapter 14, "Advantages of PL/SQL Subprograms". Discusses reusability, modularity, and performance. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/database-development-guide/ch14_coding_pl_sql_subprograms_and_packages.pdf" title="Oracle Database Development Guide - Chapter 14">Dev Guide - Ch14</a> - Pages 14-1 to 14-2. <a href="#fnref6" title="Jump back to footnote 6 in the text">↩</a></p>
    </li>
    <li id="fn7">
      <p>Oracle Database Development Guide, 23ai, Chapter 4, "Designing Applications for Oracle Real-World Performance" specifically 4.3.1 "Iterative Data Processing". Contrasts row-by-row with set-based. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/database-development-guide/ch04_designing_applications_for_oracle_real-world_performance.pdf" title="Oracle Database Development Guide - Chapter 4">Dev Guide - Ch4</a> - Page 4-3. <a href="#fnref7" title="Jump back to footnote 7 in the text">↩</a></p>
    </li>
    <li id="fn8">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 9, "PL/SQL Functions that SQL Statements Can Invoke". Details purity rules and restrictions. <a href="https://github.com/depicted-candela/TransitionalSQL/blob/main/books/oracle-database-pl-sql-language-reference/ch09_subprograms.pdf" title="Oracle Database PL/SQL Language Reference - Chapter 9">PL/SQL Ref - Ch9</a> - Page 9-51. <a href="#fnref8" title="Jump back to footnote 8 in the text">↩</a></p>
    </li>
  </ol>
</div>