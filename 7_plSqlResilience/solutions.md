<head>
    <link rel="stylesheet" href="../styles/solutions.css">
</head>

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

## Solutions

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
                RETURN 'Employee ID ' || pEmployeeId || ' not found';
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

#### (ii) Disadvantages and Pitfalls (Packages)

**Exercise 2.1: Package State Invalidation**
*   <span class="problem-label">Problem Recap:</span> Demonstrate package state loss (ORA-04068) when a package body is recompiled in another session.

*   **Solution Code:**
    ```sql
    -- Package Specification
    CREATE OR REPLACE PACKAGE StatefulPkg AS
        counter NUMBER := 0;
        PROCEDURE IncrementCounter;
        FUNCTION GetCounter RETURN NUMBER;
    END StatefulPkg;
    /

    -- Package Body
    CREATE OR REPLACE PACKAGE BODY StatefulPkg AS
        PROCEDURE IncrementCounter IS
        BEGIN
            counter := counter + 1;
            DBMS_OUTPUT.PUT_LINE('Counter (session ' || SYS_CONTEXT('USERENV', 'SID') || ') is now: ' || counter);
        END IncrementCounter;

        FUNCTION GetCounter RETURN NUMBER IS
        BEGIN
            RETURN counter;
        END GetCounter;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('StatefulPkg initialized for session ' || SYS_CONTEXT('USERENV', 'SID') || '. Counter: ' || counter);
    END StatefulPkg;
    /
    ```

    **Test Steps:**
    1.  **Session 1:**
        ```sql
        SET SERVEROUTPUT ON;
        BEGIN
            StatefulPkg.IncrementCounter; -- Expected: Initialized, Counter is now: 1
            StatefulPkg.IncrementCounter; -- Expected: Counter is now: 2
            DBMS_OUTPUT.PUT_LINE('Final Counter in Session 1 (before recompile): ' || StatefulPkg.GetCounter); -- Expected: 2
        END;
        /
        ```
    2.  **Session 2:**
        ```sql
        -- Make a trivial change if needed, or just recompile
        ALTER PACKAGE StatefulPkg COMPILE BODY; 
        -- Or, if making a change to ensure it's "different":
        /*
        CREATE OR REPLACE PACKAGE BODY StatefulPkg AS
            PROCEDURE IncrementCounter IS
            BEGIN
                counter := counter + 1;
                DBMS_OUTPUT.PUT_LINE('Counter (session ' || SYS_CONTEXT('USERENV', 'SID') || ') is now (v2): ' || counter);
            END IncrementCounter;

            FUNCTION GetCounter RETURN NUMBER IS
            BEGIN
                RETURN counter;
            END GetCounter;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('StatefulPkg (v2) initialized for session ' || SYS_CONTEXT('USERENV', 'SID') || '. Counter: ' || counter);
        END StatefulPkg;
        /
        */
        ```
    3.  **Session 1 (again):**
        ```sql
        SET SERVEROUTPUT ON;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Attempting to increment counter after recompile in another session...');
            StatefulPkg.IncrementCounter; 
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error in Session 1: ' || SQLERRM);
                -- Attempt to re-access, which might re-initialize
                BEGIN
                    DBMS_OUTPUT.PUT_LINE('Attempting to get counter after error...');
                    DBMS_OUTPUT.PUT_LINE('Counter after re-access: ' || StatefulPkg.GetCounter);
                EXCEPTION
                    WHEN OTHERS THEN
                         DBMS_OUTPUT.PUT_LINE('Further error: ' || SQLERRM);
                END;
        END;
        /
        ```
*   **Detailed Explanation:**
    *   Initially, Session 1 uses `StatefulPkg`, and its `counter` variable maintains state (increments).
    *   When Session 2 recompiles the package *body*, the definition of the package changes in the database.
    *   When Session 1 next tries to access `StatefulPkg`, Oracle detects that its in-memory state for the package is stale (based on an older version of the body). This results in the `ORA-04068: existing state of package "SCHEMA.STATEFULPKG" has been discarded` error.
    *   Subsequent calls in Session 1 *might* trigger a re-initialization of the package for that session, at which point `counter` would reset to 0. The exact behavior can sometimes depend on how Oracle handles the re-instantiation.
    *   This demonstrates a critical pitfall in environments where package bodies are frequently updated during development or deployment while sessions are active.
    *   **Oracle 23ai Note:** The `SESSION_EXIT_ON_PACKAGE_STATE_ERROR` initialization parameter (mentioned in `PL/SQL Language Reference`, p. 11-8) can alter this behavior. If `TRUE`, the session would exit instead of just raising ORA-04068. For this exercise, the default behavior (raising ORA-04068) is assumed.

<div class="caution">
**Pitfall:** Unmanaged package state invalidation (ORA-04068) can lead to unexpected application errors if not handled or understood by developers. Applications should be designed to be resilient to this, or deployment procedures should minimize active sessions during package updates.
</div>

**Exercise 2.2: Overloading Pitfall - Ambiguity with Implicit Conversions**
*   <span class="problem-label">Problem Recap:</span> Create a package with overloaded procedures `ProcessValue(NUMBER)` and `ProcessValue(VARCHAR2)`. Call it with a `DATE`.

*   **Solution Code:**
    ```sql
    CREATE OR REPLACE PACKAGE OverloadDemo AS
        PROCEDURE ProcessValue(pValue IN NUMBER);
        PROCEDURE ProcessValue(pValue IN VARCHAR2);
    END OverloadDemo;
    /

    CREATE OR REPLACE PACKAGE BODY OverloadDemo AS
        PROCEDURE ProcessValue(pValue IN NUMBER) IS
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Called ProcessValue(NUMBER) with: ' || pValue);
        END ProcessValue;

        PROCEDURE ProcessValue(pValue IN VARCHAR2) IS
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Called ProcessValue(VARCHAR2) with: ' || pValue);
        END ProcessValue;
    END OverloadDemo;
    /

    -- Test block
    SET SERVEROUTPUT ON;
    DECLARE
        myDate DATE := SYSDATE;
    BEGIN
        OverloadDemo.ProcessValue(myDate); 
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
    END;
    /
    ```
*   **Detailed Explanation:**
    *   When `OverloadDemo.ProcessValue(myDate)` is called, Oracle attempts to find a matching `ProcessValue` procedure.
    *   There is no `ProcessValue(DATE)`.
    *   Oracle will then try to implicitly convert `myDate` (a `DATE`) to either `NUMBER` or `VARCHAR2`.
    *   A `DATE` can be implicitly converted to `VARCHAR2` (using the default NLS date format). It typically cannot be implicitly converted to `NUMBER` directly in a way that makes sense for overloading resolution without an explicit cast or function call.
    *   **Expected Outcome:** The `ProcessValue(VARCHAR2)` version will likely be called, and `myDate` will be implicitly converted to its character representation (e.g., '15-MAY-25').
    *   **Pitfall:** The developer might have intended a different behavior or might not realize which overloaded version is being invoked due to implicit conversion. If there were, for instance, a `ProcessValue(TIMESTAMP)`, and `DATE` could also implicitly convert to `TIMESTAMP`, then PLS-00307 (too many declarations of 'PROCESSVALUE' match this call) could occur.
    *   **Resolution:** To avoid ambiguity and ensure the correct version is called, use explicit conversion:
        *   `OverloadDemo.ProcessValue(TO_CHAR(myDate));` to call the VARCHAR2 version.
        *   Or, if a numeric representation was intended (though less common for a DATE), `OverloadDemo.ProcessValue(TO_NUMBER(TO_CHAR(myDate, 'J')));` (for Julian date). The best resolution is often to provide an overloaded version that directly accepts the `DATE` type if that's a common use case.

<div class="postgresql-bridge">
**Bridging from PostgreSQL:** PostgreSQL's function overloading resolution also considers implicit casts. The "best match" rules can be complex. The key takeaway is that relying on implicit conversions with overloading can reduce code clarity and lead to unexpected behavior in both systems. Explicit casting is generally safer.
</div>

#### (iii) Contrasting with Inefficient Common Solutions (Packages)

**Exercise 3.1: Package vs. Standalone Utilities**
*   <span class="problem-label">Problem Recap:</span> Create string utility functions (`ReverseString`, `CountVowels`, `IsPalindrome`) first as standalone functions, then as a package. Discuss benefits.

*   **Inefficient Common Solution (Standalone Functions):**
    ```sql
    CREATE OR REPLACE FUNCTION ReverseString (pInput IN VARCHAR2) RETURN VARCHAR2 IS
        vReversed VARCHAR2(4000) := '';
    BEGIN
        FOR i IN REVERSE 1..LENGTH(pInput) LOOP
            vReversed := vReversed || SUBSTR(pInput, i, 1);
        END LOOP;
        RETURN vReversed;
    END ReverseString;
    /

    CREATE OR REPLACE FUNCTION CountVowels (pInput IN VARCHAR2) RETURN NUMBER IS
        vCount NUMBER := 0;
        vChar CHAR(1);
    BEGIN
        FOR i IN 1..LENGTH(pInput) LOOP
            vChar := UPPER(SUBSTR(pInput, i, 1));
            IF vChar IN ('A', 'E', 'I', 'O', 'U') THEN
                vCount := vCount + 1;
            END IF;
        END LOOP;
        RETURN vCount;
    END CountVowels;
    /

    CREATE OR REPLACE FUNCTION IsPalindrome (pInput IN VARCHAR2) RETURN BOOLEAN IS
        vCleanedInput VARCHAR2(4000);
        vReversedInput VARCHAR2(4000);
    BEGIN
        -- Basic cleaning: remove spaces and convert to upper case
        vCleanedInput := UPPER(REPLACE(pInput, ' ', ''));
        IF vCleanedInput IS NULL THEN RETURN TRUE; END IF; -- Empty or all spaces is a palindrome
        
        vReversedInput := ReverseString(vCleanedInput); -- Reuses the standalone ReverseString
        
        RETURN vCleanedInput = vReversedInput;
    END IsPalindrome;
    /
    ```

*   **Oracle-Idiomatic Solution (Package `StringUtils`):**
    ```sql
    CREATE OR REPLACE PACKAGE StringUtils AS
        FUNCTION ReverseString (pInput IN VARCHAR2) RETURN VARCHAR2;
        FUNCTION CountVowels (pInput IN VARCHAR2) RETURN NUMBER;
        FUNCTION IsPalindrome (pInput IN VARCHAR2) RETURN BOOLEAN;
    END StringUtils;
    /

    CREATE OR REPLACE PACKAGE BODY StringUtils AS
        FUNCTION ReverseString (pInput IN VARCHAR2) RETURN VARCHAR2 IS
            vReversed VARCHAR2(4000) := '';
        BEGIN
            IF pInput IS NULL THEN RETURN NULL; END IF;
            FOR i IN REVERSE 1..LENGTH(pInput) LOOP
                vReversed := vReversed || SUBSTR(pInput, i, 1);
            END LOOP;
            RETURN vReversed;
        END ReverseString;

        FUNCTION CountVowels (pInput IN VARCHAR2) RETURN NUMBER IS
            vCount NUMBER := 0;
            vChar CHAR(1);
        BEGIN
            IF pInput IS NULL THEN RETURN 0; END IF;
            FOR i IN 1..LENGTH(pInput) LOOP
                vChar := UPPER(SUBSTR(pInput, i, 1));
                IF vChar IN ('A', 'E', 'I', 'O', 'U') THEN
                    vCount := vCount + 1;
                END IF;
            END LOOP;
            RETURN vCount;
        END CountVowels;

        FUNCTION IsPalindrome (pInput IN VARCHAR2) RETURN BOOLEAN IS
            vCleanedInput VARCHAR2(4000);
            -- vReversedInput VARCHAR2(4000); -- Not needed if ReverseString is called directly
        BEGIN
            -- Basic cleaning: remove spaces and convert to upper case
            vCleanedInput := UPPER(REPLACE(pInput, ' ', ''));
            IF vCleanedInput IS NULL THEN RETURN TRUE; END IF;
            
            -- Calls the ReverseString function *within the same package*
            RETURN vCleanedInput = StringUtils.ReverseString(vCleanedInput); 
            -- Or simply: RETURN vCleanedInput = ReverseString(vCleanedInput); if unambiguous
        END IsPalindrome;
    END StringUtils;
    /

    -- Test the package
    SET SERVEROUTPUT ON
    BEGIN
      DBMS_OUTPUT.PUT_LINE('Reverse of "Oracle": ' || StringUtils.ReverseString('Oracle'));
      DBMS_OUTPUT.PUT_LINE('Vowels in "Database": ' || StringUtils.CountVowels('Database'));
      DBMS_OUTPUT.PUT_LINE('Is "madam" a palindrome? ' || CASE WHEN StringUtils.IsPalindrome('madam') THEN 'Yes' ELSE 'No' END);
      DBMS_OUTPUT.PUT_LINE('Is "test" a palindrome? ' || CASE WHEN StringUtils.IsPalindrome('test') THEN 'Yes' ELSE 'No' END);
    END;
    /
    ```
*   **Detailed Explanation & Discussion:**
    *   **Inefficient (Standalone):**
        *   Each function is a separate database object.
        *   Managing grants becomes per-function.
        *   If `IsPalindrome` needs a helper function also used by `ReverseString` (e.g., a more advanced string cleaning function), that helper would also have to be a standalone public function, or its code duplicated.
        *   If `ReverseString` is modified, any standalone function calling it (like `IsPalindrome`) might need revalidation, though Oracle's dependency tracking is quite good.
    *   **Oracle-Idiomatic (Package):**
        *   **Modularity & Organization:** All related string utilities are grouped logically.
        *   **Encapsulation:** The package could contain private helper functions or constants (e.g., a constant array of vowels) not exposed publicly but used by the public functions.
        *   **Easier Grant Management:** `GRANT EXECUTE ON StringUtils TO user_or_role;` grants access to all public members.
        *   **Reduced Namespace Pollution:** Only one top-level object (`StringUtils`) is created in the schema for these utilities.
        *   **Performance (Session State & Loading):** When the first subprogram in `StringUtils` is called in a session, the entire package (or relevant parts) is loaded into memory. Subsequent calls to other subprograms in the same package within that session can be faster as they don't require reloading from disk.
        *   **Dependency Management:** Changing the package *body* (implementation) without changing the specification does not invalidate objects that call the package. This is a significant advantage for maintenance. (`PL/SQL Language Reference, F46753-09`, p. 11-2 "Better Performance").
    *   The `IsPalindrome` function within the package can directly call `ReverseString` (also in the package) without needing to qualify it with the package name, though explicitly qualifying (`StringUtils.ReverseString`) is also fine and sometimes clearer.

<div class="oracle-specific">
**Oracle Advantage:** Packages are a cornerstone of Oracle PL/SQL development for their organizational, encapsulation, and performance benefits. They represent a more robust modularization approach compared to simply grouping functions in a schema as one might do in PostgreSQL.
</div>

---

### Category: Exception Handling: Predefined exceptions, user-defined exceptions, SQLCODE, SQLERRM, PRAGMA EXCEPTION_INIT

#### (i) Meanings, Values, Relations, and Advantages

**Exercise 1.4: Handling Predefined Exceptions**
*   **Problem:** Write a PL/SQL anonymous block that attempts to:
    1.  Select an employee's salary into a `NUMBER` variable for an `employeeId` that does not exist in the `Employees` table.
    2.  Handle the `NO_DATA_FOUND` predefined exception and print a user-friendly message.
    3.  Attempt to divide a number by zero.
    4.  Handle the `ZERO_DIVIDE` predefined exception and print a user-friendly message.
*   **Focus:** Understand how to catch and handle common predefined Oracle exceptions.
*   **Relations:**
    *   **Oracle:** Directly uses predefined exceptions. `PL/SQL Language Reference (F46753-09)`, Chapter 12, "Predefined Exceptions" (p. 12-11, Table 12-3 lists them).
    *   **PostgreSQL Bridge:** PostgreSQL also has predefined exceptions (e.g., `no_data_found`, `division_by_zero`). The concept is similar, but the specific exception names and the `EXCEPTION WHEN ... THEN` syntax are key Oracle PL/SQL constructs.
*   **Advantages Demonstrated:** Graceful error recovery, providing better user experience than unhandled errors.

**Exercise 1.5: Declaring and Raising User-Defined Exceptions**
*   **Problem:**
    1.  Create a procedure `CheckProductStock` that takes `pProductId` and `pQuantityRequired` as input.
    2.  Inside the procedure, declare a user-defined exception named `LowStockWarning`.
    3.  If the `stockQuantity` for the given `pProductId` in the `Products` table is less than `pQuantityRequired` but greater than 0, raise `LowStockWarning`.
    4.  If `stockQuantity` is 0, raise the predefined `NO_DATA_FOUND` (or a different user-defined exception like `OutOfStockError`).
    5.  The procedure should have an exception block to handle `LowStockWarning` by printing "Warning: Low stock for product ID [ID]." and `NO_DATA_FOUND` by printing "Error: Product ID [ID] is out of stock."
    Write an anonymous block to test both scenarios (low stock and out of stock for Product ID 1002 'Wireless Mouse' and 1003 'Monitor HD' respectively, assuming initial quantities).
*   **Focus:** Learn how to declare, raise, and handle user-defined exceptions.
*   **Relations:**
    *   **Oracle:** `PL/SQL Language Reference (F46753-09)`, Chapter 12, "User-Defined Exceptions" (p. 12-13) and "Raising Exceptions Explicitly" (p. 12-15).
    *   **PostgreSQL Bridge:** PostgreSQL's `RAISE EXCEPTION` is similar in concept. Oracle's `DECLARE exception_name EXCEPTION;` and `RAISE exception_name;` syntax is specific.
*   **Advantages Demonstrated:** Ability to create custom error conditions specific to application logic.

**Exercise 1.6: Using `SQLCODE`, `SQLERRM`, and `PRAGMA EXCEPTION_INIT`**
*   **Problem:**
    1.  Declare a user-defined exception `NegativeSalaryError`.
    2.  Use `PRAGMA EXCEPTION_INIT` to associate this exception with the Oracle error code -20002.
    3.  Create a procedure `ValidateSalary` that takes a `newSalary` as input. If `newSalary` is negative, raise `NegativeSalaryError`.
    4.  Write an anonymous block that calls `ValidateSalary` with a negative salary. The exception handler in the anonymous block should catch `NegativeSalaryError` and print the error code using `SQLCODE` and the error message using `SQLERRM`.
*   **Focus:** Understand how to use `SQLCODE` and `SQLERRM` for error diagnostics and `PRAGMA EXCEPTION_INIT` to map custom exceptions to Oracle error numbers.
*   **Relations:**
    *   **Oracle:** `PL/SQL Language Reference (F46753-09)`, Chapter 12, "Retrieving Error Code and Error Message" (p. 12-27) and "Naming Internally Defined Exception" (p. 12-10), which explains `PRAGMA EXCEPTION_INIT`.
    *   **PostgreSQL Bridge:** PostgreSQL has `SQLSTATE` and `SQLERRM` available in its `EXCEPTION` block. Oracle's `SQLCODE` is an integer, and `PRAGMA EXCEPTION_INIT` provides a way to give a name to a specific ORA- error or a user-defined error number within the range -20000 to -20999.
*   **Advantages Demonstrated:** Standardized error reporting, ability to handle specific Oracle errors by custom names.

#### (ii) Disadvantages and Pitfalls (Exception Handling)

**Exercise 2.3: Overuse of `WHEN OTHERS`**
*   **Problem:** Write a procedure `ProcessOrder` that performs several DML operations (e.g., inserts into `Orders`, then `OrderItems`, then updates `Products`). Include a single `WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An error occurred.');` exception handler at the end.
    Discuss the disadvantages of this approach. How could it be improved for better error diagnosis and recovery?
*   **Focus:** Highlight the pitfalls of catching all exceptions with a generic `WHEN OTHERS` without specific handling or re-raising.
*   **Disadvantage/Pitfall:** Masks the actual error, making debugging very difficult. The specific cause of the failure is lost. It might also prevent proper transaction rollback if the error is critical.
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 12, "Guidelines for Avoiding and Handling Exceptions" (p. 12-9) - especially the point about writing handlers for named exceptions.

**Exercise 2.4: Exception Propagation and Unhandled Exceptions**
*   **Problem:**
    1.  Create a procedure `InnerProc` that attempts to insert a duplicate `productId` into the `Products` table (which will raise `DUP_VAL_ON_INDEX` due to the primary key constraint). `InnerProc` should *not* have an exception handler for `DUP_VAL_ON_INDEX`.
    2.  Create another procedure `OuterProc` that calls `InnerProc`. `OuterProc` should also *not* have an exception handler for `DUP_VAL_ON_INDEX`.
    3.  Write an anonymous block that calls `OuterProc`. This block *should* have an exception handler for `DUP_VAL_ON_INDEX`.
    Explain the flow of exception propagation. What happens if the anonymous block also doesn't handle it?
*   **Focus:** Demonstrate how unhandled exceptions propagate up the call stack.
*   **Pitfall:** If an exception propagates all the way to the client without being handled, it can result in an ungraceful application termination or a generic error message to the user.
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 12, "Exception Propagation" (p. 12-19).

#### (iii) Contrasting with Inefficient Common Solutions (Exception Handling)

**Exercise 3.2: Manual Error Checking vs. Exception Handling**
*   **Scenario:** A requirement is to ensure that when a new employee is added, their salary is within a valid range for their department (e.g., min 30000, max 150000 for Sales).
*   **Inefficient Common Solution (Problem):** A developer writes a procedure `AddEmployeeManualCheck` that takes employee details. After the `INSERT` statement, they use several `IF` statements to check if `SQL%ROWCOUNT = 1` (for successful insert) and then separately query the salary ranges and check if the inserted salary is valid. If not, they try to manually `DELETE` the inserted record and print error messages.
*   **Oracle-Idiomatic Solution (Solution):** Create a procedure `AddEmployeeWithException` that declares a user-defined exception `InvalidSalaryRange`. Before the `INSERT`, check the salary. If invalid, `RAISE InvalidSalaryRange`. The `INSERT` only happens if the salary is valid. The calling block can then handle `InvalidSalaryRange`. Alternatively, use a `CHECK` constraint on the table if the range is static, or a trigger to validate (covered next). For this exercise, focus on the procedural exception.
*   **Discussion Point:** Explain how exception handling simplifies the logic, makes it more readable, and centralizes error management compared to scattered `IF` checks and manual rollback/delete attempts.
*   **Focus:** Show that proactive validation and raising custom exceptions leads to cleaner and more robust code than reactive manual checks and cleanups.
*   **Loss of Advantages (Inefficient):** Code becomes cluttered with error checks, manual cleanup is error-prone, transaction atomicity might be compromised if cleanup fails.

#### (iv) Hardcore Combined Problem (Packages & Exception Handling)

This section will be combined with the Triggers hardcore problem below, as they often work together in complex scenarios.

---

### Category: Triggers: DML triggers, :NEW and :OLD qualifiers, conditional predicates

#### (i) Meanings, Values, Relations, and Advantages

**Exercise 1.7: Basic AFTER INSERT Row-Level Trigger**
*   **Problem:** Create a trigger `trgAfterNewEmployee` that fires *after* a new row is inserted into the `Employees` table. For each inserted row, the trigger should print a message to `DBMS_OUTPUT` saying "New employee added: [Employee's Full Name] with ID: [Employee ID]". Use the `:NEW` pseudorecord.
*   **Focus:** Understand basic `AFTER INSERT FOR EACH ROW` trigger syntax and the usage of `:NEW`.
*   **Relations:**
    *   **Oracle:** `PL/SQL Language Reference (F46753-09)`, Chapter 10, "DML Triggers" (p. 10-4) and "Correlation Names and Pseudorecords" (p. 10-28). `Get Started Guide (F79574-03)`, "About OLD and NEW Pseudorecords" (p. 6-3).
    *   **PostgreSQL Bridge:** PostgreSQL triggers have similar concepts (`NEW` record for `INSERT`/`UPDATE`, `OLD` for `UPDATE`/`DELETE`). The `CREATE TRIGGER ... FOR EACH ROW EXECUTE FUNCTION ...` syntax is different. Oracle's PL/SQL trigger body is defined inline.
*   **Advantages Demonstrated:** Automating actions (like logging or derived calculations) based on DML events.

**Exercise 1.8: BEFORE UPDATE Statement-Level Trigger with Conditional Predicates**
*   **Problem:** Create a trigger `trgBeforeEmployeeUpdateAudit` that fires *before* any `UPDATE` statement is executed on the `Employees` table.
    1.  The trigger should log a generic message to the `AuditLog` table: `tableName` = 'Employees', `operationType` = 'BATCH UPDATE START'.
    2.  This trigger should be a statement-level trigger.
    3.  Test by updating multiple employee salaries in a single `UPDATE` statement.
*   **Focus:** Understand `BEFORE UPDATE` statement-level triggers and how conditional predicates like `UPDATING` work (though `UPDATING` is more useful with multiple DML events, this sets the stage).
*   **Relations:**
    *   **Oracle:** `PL/SQL Language Reference (F46753-09)`, Chapter 10, "Conditional Predicates for Detecting Triggering DML Statement" (p. 10-5). `Get Started Guide (F79574-03)`, "Tutorial: Creating a Trigger that Logs Table Changes" (p. 6-3) uses these.
    *   **PostgreSQL Bridge:** PostgreSQL triggers can also be statement-level (`FOR EACH STATEMENT`). Conditional logic within the trigger function would achieve similar predicate effects.
*   **Advantages Demonstrated:** Performing an action once per DML statement, regardless of how many rows are affected. Useful for setting up audit trails or global checks.

**Exercise 1.9: Using `:OLD` and `:NEW` in an UPDATE Trigger with a WHEN Clause**
*   **Problem:** Create a trigger `trgLogSignificantSalaryChange` that fires *after* an `UPDATE` on the `salary` column of the `Employees` table *for each row*.
    1.  The trigger should only fire if the new salary is at least 10% greater than the old salary (`WHEN (NEW.salary > OLD.salary * 1.10)`).
    2.  If it fires, it should insert a record into `AuditLog` with `tableName`='Employees', `operationType`='SIG_SAL_INC', `recordId`=`:NEW.employeeId`, `oldValue`=`:OLD.salary`, `newValue`=`:NEW.salary`.
    Test by updating salaries, some significantly, some not.
*   **Focus:** Combine `:OLD`, `:NEW`, `FOR EACH ROW`, and the `WHEN` clause for fine-grained trigger control.
*   **Relations:**
    *   **Oracle:** Reinforces `:OLD`/`:NEW` and introduces the trigger's `WHEN` clause. `PL/SQL Language Reference (F46753-09)`, Chapter 10, "Correlation Names and Pseudorecords" (p. 10-28) and the `CREATE TRIGGER` syntax for the `WHEN` clause.
    *   **PostgreSQL Bridge:** PostgreSQL trigger functions can use `OLD` and `NEW` records. The conditional logic (WHEN clause) in Oracle triggers is a concise way to control firing without an explicit IF statement at the beginning of the trigger body.
*   **Advantages Demonstrated:** Efficiently targeting trigger logic to specific conditions on row data changes, reducing unnecessary trigger executions.

#### (ii) Disadvantages and Pitfalls (Triggers)

**Exercise 2.5: The Mutating Table Error (ORA-04091)**
*   **Problem:**
    1.  Create a trigger `trgEnforceMaxDepartmentSalary` on the `Employees` table that fires `BEFORE INSERT OR UPDATE OF salary, departmentId`.
    2.  Inside the trigger (for each row), attempt to query the `Employees` table to find the maximum salary for the `:NEW.departmentId` and ensure the `:NEW.salary` does not exceed this maximum by more than 20%. If it does, raise an application error.
    3.  Attempt to insert a new employee or update an existing one in a way that would cause the trigger to query the `Employees` table. Observe the ORA-04091 error. Explain why it occurs.
*   **Focus:** Demonstrate the common mutating table error.
*   **Pitfall:** A trigger cannot query or modify the same table that is currently being modified by the DML statement that fired the trigger (for row-level triggers).
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 10, "Mutating-Table Restriction" (p. 10-42).

**Exercise 2.6: Trigger Cascading and Performance**
*   **Problem:**
    1.  Create table `TableA` with a column `val NUMBER`.
    2.  Create table `TableB` with a column `val NUMBER`.
    3.  Create a trigger `trgCascadeAtoB` on `TableA` that fires `AFTER INSERT FOR EACH ROW`. This trigger inserts a new row into `TableB` with `:NEW.val * 2`.
    4.  Create a trigger `trgCascadeBtoA` on `TableB` that fires `AFTER INSERT FOR EACH ROW`. This trigger attempts to insert a new row into `TableA` with `:NEW.val / 2`.
    What happens when you insert a row into `TableA`? Discuss the potential for infinite loops and performance issues with cascading triggers.
*   **Focus:** Illustrate the dangers of uncontrolled trigger cascading.
*   **Pitfall:** Cascading triggers can lead to complex, hard-to-debug chains of events, infinite loops (ORA-00036: maximum number of recursive SQL levels exceeded), and significant performance degradation.
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 10, "Order in Which Triggers Fire" (p. 10-46) touches on cascading.

#### (iii) Contrasting with Inefficient Common Solutions (Triggers)

**Exercise 3.3: Complex Validation in Application Code vs. Trigger**
*   **Scenario:** A business rule states that whenever an order item's quantity is updated, if the product is 'Laptop Pro' and the new quantity exceeds 5, the `status` of the corresponding order in the `Orders` table must be set to 'ReviewRequired'.
*   **Inefficient Common Solution (Problem):** The application code handles this logic. After every `UPDATE` to `OrderItems`, the application code explicitly checks the product name and quantity, and if necessary, issues a separate `UPDATE` statement to the `Orders` table.
*   **Oracle-Idiomatic Solution (Solution):** Create an `AFTER UPDATE OF quantity ON OrderItems FOR EACH ROW` trigger. Inside the trigger, check if `:NEW.productId` corresponds to 'Laptop Pro' (requires a lookup to `Products` table) and if `:NEW.quantity > 5`. If both are true, update the `status` of the `Orders` table where `orderId = :NEW.orderId`.
*   **Discussion Point:** Explain how a trigger centralizes this business rule in the database, ensuring it's applied consistently regardless of how the `OrderItems` table is updated (e.g., by different applications, direct SQL). This reduces code duplication and potential for the rule to be missed in some application paths.
*   **Focus:** Demonstrates triggers as a robust way to enforce complex, cross-table business rules that might be inconsistently applied or forgotten in application-level code.
*   **Loss of Advantages (Inefficient):** Rule enforcement is decentralized and depends on all application paths correctly implementing it. Increased network traffic if the checks and subsequent updates are done from the client. Potential for data inconsistency if some paths miss the logic.

#### (iv) Hardcore Combined Problem (Packages, Exception Handling, Triggers)

**Exercise 4.2: Comprehensive Order and Inventory Management with Auditing and Error Handling**
*   **Problem:**
    Enhance the `OrderManagementPkg` from a previous exercise (or create it if not done) and integrate it with robust auditing and error handling through triggers.

    **Requirements:**
    1.  **`ProductStockPkg` Package:**
        *   **Specification:**
            *   Public procedure `CheckAndAdjustStock(pProductId IN NUMBER, pQuantityChange IN NUMBER, pOperationType IN VARCHAR2)` (pOperationType can be 'DECREMENT' for sale, 'INCREMENT' for restock).
            *   User-defined exception `ProductNotFoundException`.
            *   User-defined exception `CriticalStockLevelException`.
        *   **Body:**
            *   Implement `CheckAndAdjustStock`:
                *   If `pOperationType` is 'DECREMENT':
                    *   Check if product exists. If not, raise `ProductNotFoundException`.
                    *   Check if current `stockQuantity - pQuantityChange < 0`. If so, raise the `InsufficientStockException` (from `OrderManagementPkg` or declare it here).
                    *   Update `Products` table to decrement stock.
                    *   If the new `stockQuantity` falls below 5 (but is >= 0), raise `CriticalStockLevelException` *after* successfully updating the stock (this is a warning, the transaction should still commit).
                *   If `pOperationType` is 'INCREMENT':
                    *   Update `Products` table to increment stock.
            *   Use `PRAGMA EXCEPTION_INIT` to associate `ProductNotFoundException` with -20010 and `CriticalStockLevelException` with -20011.
            *   Include a `WHEN OTHERS` handler to log to `DBMS_OUTPUT` and `RAISE`.

    2.  **Modified `OrderManagementPkg` Package:**
        *   **Body:**
            *   The `PlaceOrder` procedure should now call `ProductStockPkg.CheckAndAdjustStock` to decrement stock instead of updating the `Products` table directly.
            *   `PlaceOrder` must handle `ProductNotFoundException` and `InsufficientStockException` from `ProductStockPkg` and re-raise them as appropriate application errors (e.g., using `RAISE_APPLICATION_ERROR` with different error codes or messages).
            *   `PlaceOrder` should *not* directly handle `CriticalStockLevelException`; this exception should propagate out of `PlaceOrder` if raised by `ProductStockPkg`.

    3.  **Trigger `trgEnforceOrder IntegrityAndAudit`:**
        *   Create a compound DML trigger on the `OrderItems` table for `INSERT`, `UPDATE`, `DELETE`.
        *   **`BEFORE EACH ROW` section:**
            *   If `INSERTING` or `UPDATING quantity`: Ensure `:NEW.itemPrice` is not null and is greater than 0. If not, `RAISE_APPLICATION_ERROR(-20012, 'Item price must be positive.')`.
            *   If `UPDATING quantity`: Store `:OLD.quantity` in a package-level variable (e.g., in a new utility package or within `OrderManagementPkg` if appropriate, but for this exercise, a simple helper package `TriggerStatePkg` with a PL/SQL record/array might be used to hold old quantities if needed across timing points, though for this specific rule, it might not be strictly necessary for the BEFORE EACH ROW part).
        *   **`AFTER EACH ROW` section:**
            *   If `INSERTING`: This is where the stock adjustment logically happens *via the package call*. Since `PlaceOrder` now calls `ProductStockPkg`, this specific trigger section might not need to call it again if all order item creations go through the package. However, for direct DML on `OrderItems` outside the package, this would be the place. For this exercise, assume `PlaceOrder` is the primary path. If direct DML on `OrderItems` is possible, this section would also call `ProductStockPkg.CheckAndAdjustStock` to decrement stock for `:NEW.productId` and `:NEW.quantity`.
            *   If `DELETING`: Call `ProductStockPkg.CheckAndAdjustStock` to increment stock for `:OLD.productId` and `:OLD.quantity` (restocking).
            *   If `UPDATING quantity`: Calculate the difference (`:NEW.quantity - :OLD.quantity`). Call `ProductStockPkg.CheckAndAdjustStock` with this difference (positive if increase, negative if decrease).
            *   Log the DML operation (`INSERT`, `UPDATE`, `DELETE`) on `OrderItems` to the `AuditLog` table, including `orderItemId`, `productId`, old/new `quantity` (if applicable).
        *   **Exception Handling within the trigger:** Catch exceptions from `ProductStockPkg` (like `InsufficientStockException`) and `RAISE_APPLICATION_ERROR` with a trigger-specific message (e.g., -20013, "Stock adjustment failed for order item.").

    4.  **Test Scenarios (Anonymous Blocks):**
        *   **Scenario A (Success with warning):** Use `OrderManagementPkg.PlaceOrder` to order a product such that its stock quantity drops to 3 (e.g., 'Wireless Mouse' initially 200, order 197). Verify order creation, stock update, audit log, and that `CriticalStockLevelException` (-20011) is propagated and caught by the anonymous block.
        *   **Scenario B (Failure - insufficient stock):** Attempt to place an order for 'Laptop Pro' (initial stock 50) with a quantity of 60. Verify `InsufficientStockException` (via the re-raised application error from `PlaceOrder`) is caught and no changes are made.
        *   **Scenario C (Direct DML - Delete):** Directly delete an `OrderItem`. Verify stock is incremented via `ProductStockPkg.CheckAndAdjustStock` called from `trgEnforceOrderIntegrityAndAudit` and an audit entry is made.
        *   **Scenario D (Direct DML - Update price to invalid):** Attempt to directly update an `OrderItem` to have a negative `itemPrice`. Verify the `BEFORE EACH ROW` part of `trgEnforceOrderIntegrityAndAudit` raises error -20012.

*   **Focus:** This complex problem integrates package design (multiple packages interacting), advanced exception handling (user-defined, `PRAGMA EXCEPTION_INIT`, `RAISE_APPLICATION_ERROR`, propagation, handling exceptions from called procedures), and complex trigger logic (compound trigger, multiple timing points, conditional logic, `:OLD`/`:NEW`, calling packages from triggers).
*   **Preceding Concepts Used:** All concepts from Chunk 7, plus PL/SQL Fundamentals (Chunk 5), Procedures/Functions (Chunk 6), and SQL DML/Data Types (Chunks 1-3).
*   **PostgreSQL Bridge:** This demonstrates a sophisticated use of Oracle's PL/SQL features. While PostgreSQL can achieve parts of this with functions and triggers, Oracle's packages provide superior organization and state management. Compound triggers are an Oracle-specific feature for handling multiple DML events and timing points within a single trigger unit, which can be more efficient and manageable than multiple simple triggers for complex logic. The way exceptions are declared and handled with pragmas is also Oracle-specific.

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