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

## Solutions for Chunk 7

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
    2.  **`totalRaisesProcessed` (Private):** Declared in the body, so it's only accessible within the package body. It's initialized to `0` in its declaration. The package initialization block (the `BEGIN...END;` at the end of the package body) runs once per session when the package is first referenced and can also be used for more complex initialization of package state variables.
    3.  **`UpdateEmployeeSalary` Modification:**
        *   Now accepts `pNewSalary` and `pRaisePercentage` as optional parameters (using `DEFAULT NULL`).
        *   It prioritizes `pNewSalary`, then `pRaisePercentage`, then the package's `defaultRaisePercentage`. This uses IF-THEN-ELSIF logic (Chunk 5).
        *   It increments the private `totalRaisesProcessed` variable if the update is successful (`SQL%FOUND`).
    4.  **`GetTotalRaisesProcessed` Function:** A simple public function to return the current value of the private `totalRaisesProcessed`. This demonstrates encapsulation – controlling access to internal state.
    5.  **Package Initialization Block (`BEGIN ... END EmployeeUtils;` at the end of the package body):** This block executes once per session when any part of the package is first accessed. Here, it just prints an initialization message.
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

#### (ii) Disadvantages and Pitfalls

**Exercise 2.1: Package State Invalidation**
*   <span class="problem-label">Problem Recap:</span> Create `StatefulPkg` with a counter. Observe its behavior after recompiling the package body from another session.
*   **Solution Code:**
    ```sql
    -- Package Specification
    CREATE OR REPLACE PACKAGE StatefulPkg AS
        counter NUMBER := 0;
        PROCEDURE IncrementCounter;
    END StatefulPkg;
    /

    -- Package Body
    CREATE OR REPLACE PACKAGE BODY StatefulPkg AS
        PROCEDURE IncrementCounter IS
        BEGIN
            counter := counter + 1;
            DBMS_OUTPUT.PUT_LINE('Counter is now: ' || counter);
        END IncrementCounter;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('StatefulPkg initialized. Counter at initialization: ' || counter); 
    END StatefulPkg;
    /

    -- In SQL*Plus Session 1:
    SET SERVEROUTPUT ON;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Session 1: First calls ---');
        StatefulPkg.IncrementCounter;
        StatefulPkg.IncrementCounter;
    END;
    /
    -- Expected Output from Session 1 (First calls):
    -- StatefulPkg initialized. Counter at initialization: 0
    -- Counter is now: 1
    -- Counter is now: 2

    -- In SQL*Plus Session 2 (or another SQL Developer worksheet):
    -- ALTER PACKAGE StatefulPkg COMPILE BODY;
    -- Statement processed.

    -- Back in SQL*Plus Session 1:
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Session 1: Call after recompile in Session 2 ---');
        StatefulPkg.IncrementCounter;
    END;
    /
    -- Expected Output from Session 1 (Call after recompile):
    -- ORA-04068: existing state of package "YOUR_SCHEMA.STATEFULPKG" has been discarded
    -- ORA-06508: PL/SQL: could not find program unit being called: "YOUR_SCHEMA.STATEFULPKG"
    -- ORA-06512: at line 3 
    -- (Note: If you run it a third time in Session 1, it might re-initialize and work, showing the counter from 1 again)
    ```
*   **Detailed Explanation:**
    1.  **Initial State:** When `StatefulPkg.IncrementCounter` is first called in Session 1, the package is loaded into the session's memory, its initialization block runs (setting `counter` to 0 if not already initialized at declaration, and printing the message), and `counter` is incremented. The state (`counter = 2`) persists for Session 1.
    2.  **Recompilation:** Recompiling the package body (`ALTER PACKAGE StatefulPkg COMPILE BODY;`) in Session 2 invalidates the compiled state of the package across all sessions that might have an older version loaded.
    3.  **State Invalidation (ORA-04068):** When Session 1 attempts to call `IncrementCounter` again, Oracle detects that the package body it has in memory is no longer valid due to the recompile. It discards the old state and raises `ORA-04068`. The subsequent `ORA-06508` means it couldn't immediately find/re-load the program unit.
    4.  **Resolution:** If Session 1 calls `StatefulPkg.IncrementCounter` yet *again* after the `ORA-04068` error, Oracle will typically reload and re-initialize the package for that session. The `counter` would start again from 0 (or its declaration-time initialization), and the initialization block message would print again.
*   **Pitfall:** Uncontrolled recompilation of stateful packages in a production environment can lead to unexpected errors and loss of session-specific data held in package variables.
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 11, "Package State" (p. 11-7). The behavior with `SESSION_EXIT_ON_PACKAGE_STATE_ERROR` (Oracle 19.23+) is also relevant for how applications can handle this.

**Exercise 2.2: Overloading Pitfall - Ambiguity with Implicit Conversions**
*   <span class="problem-label">Problem Recap:</span> Create `OverloadDemo` with `ProcessValue(NUMBER)` and `ProcessValue(VARCHAR2)`. Call it with a `DATE`.

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
        DBMS_OUTPUT.PUT_LINE('Attempting to call ProcessValue with a DATE:');
        OverloadDemo.ProcessValue(myDate); 
    END;
    /
    ```
*   **Detailed Explanation:**
    *   **What Happens:** When you call `OverloadDemo.ProcessValue(myDate)`, Oracle attempts to find a matching `ProcessValue` procedure. Since there's no version that directly accepts a `DATE`, it tries implicit conversions.
    *   A `DATE` can be implicitly converted to `VARCHAR2` (using the session's `NLS_DATE_FORMAT`).
    *   A `DATE` *cannot* be implicitly converted directly to `NUMBER` in a way that makes sense for general numeric processing without an explicit conversion function like `TO_NUMBER(TO_CHAR(myDate, 'J'))`.
    *   Therefore, the PL/SQL compiler will choose the `ProcessValue(pValue IN VARCHAR2)` version.
    *   **Output:**
        ```
        Attempting to call ProcessValue with a DATE:
        Called ProcessValue(VARCHAR2) with: <current_date_in_NLS_DATE_FORMAT>
        ```
    *   **Why this is a Pitfall:** While it works here by converting to `VARCHAR2`, if there were, for instance, another overloaded procedure `ProcessValue(pAnotherType)` to which `DATE` could also be implicitly converted, you might get a PLS-00307 (too many declarations of 'PROCESSVALUE' match this call) if the conversion "cost" is similar. More subtly, the developer might have *intended* a numeric representation or a different string format, but the implicit conversion takes over, potentially leading to logic errors if the `VARCHAR2` version handles the data differently than expected for a date.
    *   **Resolution:** To avoid ambiguity or ensure the correct version is called:
        1.  **Explicit Conversion:** `OverloadDemo.ProcessValue(TO_CHAR(myDate, 'YYYY-MM-DD'));` or `OverloadDemo.ProcessValue(TO_NUMBER(TO_CHAR(myDate, 'J')));` (if a numeric representation like Julian date was intended and a `NUMBER` overload existed).
        2.  **Create a Specific Overload:** Add `PROCEDURE ProcessValue(pValue IN DATE);` to the package. This is the best approach for clarity and type safety.
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 9, section "Formal Parameters that Differ Only in Numeric Data Type" (p. 9-30) gives rules for numeric type precedence, and the general concept of implicit conversion applies across types.

#### (iii) Contrasting with Inefficient Common Solutions

**Exercise 3.1: Package vs. Standalone Utilities**
*   <span class="problem-label">Scenario Recap:</span> A developer needs `ReverseString`, `CountVowels`, and `IsPalindrome` string utility functions.
*   **Inefficient Common Solution (Standalone Functions):**
    ```sql
    CREATE OR REPLACE FUNCTION ReverseString (pInputString IN VARCHAR2) RETURN VARCHAR2 IS
        vReversedString VARCHAR2(4000) := '';
    BEGIN
        IF pInputString IS NULL THEN RETURN NULL; END IF;
        FOR i IN REVERSE 1..LENGTH(pInputString) LOOP
            vReversedString := vReversedString || SUBSTR(pInputString, i, 1);
        END LOOP;
        RETURN vReversedString;
    END ReverseString;
    /

    CREATE OR REPLACE FUNCTION CountVowels (pInputString IN VARCHAR2) RETURN NUMBER IS
        vVowelCount NUMBER := 0;
        vChar CHAR(1);
    BEGIN
        IF pInputString IS NULL THEN RETURN 0; END IF;
        FOR i IN 1..LENGTH(pInputString) LOOP
            vChar := UPPER(SUBSTR(pInputString, i, 1));
            IF vChar IN ('A', 'E', 'I', 'O', 'U') THEN
                vVowelCount := vVowelCount + 1;
            END IF;
        END LOOP;
        RETURN vVowelCount;
    END CountVowels;
    /

    CREATE OR REPLACE FUNCTION IsPalindrome (pInputString IN VARCHAR2) RETURN BOOLEAN IS
        vCleanedString VARCHAR2(4000);
        vReversedString VARCHAR2(4000);
    BEGIN
        IF pInputString IS NULL THEN RETURN NULL; END IF; -- Or TRUE/FALSE depending on definition
        vCleanedString := REGEXP_REPLACE(UPPER(pInputString), '[^A-Z0-9]', '');
        IF LENGTH(vCleanedString) = 0 THEN RETURN TRUE; END IF; -- Empty or all non-alphanum is a palindrome
        
        -- Could call the standalone ReverseString here, or implement again
        FOR i IN REVERSE 1..LENGTH(vCleanedString) LOOP
            vReversedString := vReversedString || SUBSTR(vCleanedString, i, 1);
        END LOOP;
        
        RETURN vCleanedString = vReversedString;
    END IsPalindrome;
    /
    ```
*   **Oracle-Idiomatic Solution (Package):**
    ```sql
    CREATE OR REPLACE PACKAGE StringUtils AS
        FUNCTION ReverseString (pInputString IN VARCHAR2) RETURN VARCHAR2;
        FUNCTION CountVowels (pInputString IN VARCHAR2) RETURN NUMBER;
        FUNCTION IsPalindrome (pInputString IN VARCHAR2) RETURN BOOLEAN;
    END StringUtils;
    /

    CREATE OR REPLACE PACKAGE BODY StringUtils AS
        FUNCTION ReverseString (pInputString IN VARCHAR2) RETURN VARCHAR2 IS
            vReversedString VARCHAR2(4000) := '';
        BEGIN
            IF pInputString IS NULL THEN RETURN NULL; END IF;
            FOR i IN REVERSE 1..LENGTH(pInputString) LOOP
                vReversedString := vReversedString || SUBSTR(pInputString, i, 1);
            END LOOP;
            RETURN vReversedString;
        END ReverseString;

        FUNCTION CountVowels (pInputString IN VARCHAR2) RETURN NUMBER IS
            vVowelCount NUMBER := 0;
            vChar CHAR(1);
        BEGIN
            IF pInputString IS NULL THEN RETURN 0; END IF;
            FOR i IN 1..LENGTH(pInputString) LOOP
                vChar := UPPER(SUBSTR(pInputString, i, 1));
                IF vChar IN ('A', 'E', 'I', 'O', 'U') THEN
                    vVowelCount := vVowelCount + 1;
                END IF;
            END LOOP;
            RETURN vVowelCount;
        END CountVowels;

        FUNCTION IsPalindrome (pInputString IN VARCHAR2) RETURN BOOLEAN IS
            vCleanedString VARCHAR2(4000);
            -- No need to declare vReversedString if calling the package's ReverseString
        BEGIN
            IF pInputString IS NULL THEN RETURN NULL; END IF;
            vCleanedString := REGEXP_REPLACE(UPPER(pInputString), '[^A-Z0-9]', '');
            IF LENGTH(vCleanedString) = 0 THEN RETURN TRUE; END IF;
            
            RETURN vCleanedString = StringUtils.ReverseString(vCleanedString); -- Call package function
        END IsPalindrome;
    END StringUtils;
    /
    ```
*   **Detailed Explanation & Discussion:**
    *   **Inefficient Approach (Standalone Functions):**
        *   **Namespace Pollution:** Each function (`ReverseString`, `CountVowels`, `IsPalindrome`) becomes a top-level schema object. With many utilities, this can clutter the schema.
        *   **Grant Management:** If these utilities need to be granted to other users, each function must be granted individually.
        *   **Dependency Management:** If `IsPalindrome` were to internally call `ReverseString` (as it logically could), a change to `ReverseString`'s signature could potentially invalidate `IsPalindrome`, requiring its recompilation. While Oracle handles this, packages offer finer-grained control.
        *   **No Private Helpers:** If there was a common internal helper function needed by all three (e.g., a character cleaning function), it would either have to be a standalone public function (further polluting the namespace) or duplicated within each function.
    *   **Oracle-Idiomatic Approach (Package `StringUtils`):**
        *   **Modularity & Organization:** All related string utilities are grouped logically within a single package `StringUtils`. This makes the codebase cleaner and easier to understand. The package itself becomes the unit of deployment and management for these utilities.
        *   **Encapsulation:** The package specification defines the public API. The implementation details are hidden within the package body. `IsPalindrome` can directly call `StringUtils.ReverseString` (or just `ReverseString` if called from within the same package body).
        *   **Simplified Grant Management:** You can grant `EXECUTE` permission on the entire `StringUtils` package to other users/roles, rather than on individual functions.
        *   **Performance:** When the first subprogram in a package is called, the entire package (or parts of it) is loaded into memory for the session. Subsequent calls to other subprograms in the same package within that session can be faster as they don't require disk I/O to fetch the code.
        *   **Private Members:** The package body can contain private functions, procedures, types, and variables that are only accessible within the package body. This is useful for helper routines or shared internal state that shouldn't be exposed publicly. (Though not explicitly used in this simple example, it's a major advantage).
    *   **Loss of Advantages (Inefficient):** The standalone approach loses the organizational benefits, simplified security management, potential performance gains from shared memory, and the ability to have truly private helper routines that packages provide. It leads to a less structured and potentially harder-to-maintain codebase as the number of utilities grows.

<div class="postgresql-bridge">
**Bridging from PostgreSQL:** PostgreSQL uses schemas to organize functions. You can create `CREATE FUNCTION myschema.myfunction(...)`. This provides namespacing. However, Oracle packages go further by allowing a package specification (the API) and a package body (the implementation), public/private members, and package-level state. This level of encapsulation and state management within a single named unit is a key differentiator.
</div>

### Category: Exception Handling

#### (i) Meanings, Values, Relations, and Advantages

**Exercise 1.4: Handling Predefined Exceptions**
*   <span class="problem-label">Problem:</span> Write a PL/SQL anonymous block that attempts to:
    1.  Divide a number by zero.
    2.  Fetch a row from the `Employees` table with an `employeeId` that does not exist.
    Include separate exception handlers for `ZERO_DIVIDE` and `NO_DATA_FOUND`. In each handler, use `DBMS_OUTPUT.PUT_LINE` to display a user-friendly message and the values of `SQLCODE` and `SQLERRM`.
*   **Focus:** Practice handling common predefined exceptions and accessing `SQLCODE` and `SQLERRM`.
*   **Relations:**
    *   **Oracle:** Introduces predefined exceptions and error information functions. Refer to `PL/SQL Language Reference (F46753-09)`, Chapter 12: "PL/SQL Error Handling", sections "Predefined Exceptions" (p. 12-11), "SQLCODE Function" (p. 14-177), and "SQLERRM Function" (p. 14-178).
    *   **PostgreSQL Bridge:** PostgreSQL also has predefined exceptions (e.g., `division_by_zero`, `no_data_found`). The concept of catching specific errors is similar. However, the exact exception names and the functions to get error details (`SQLSTATE`, `SQLERRM` in PG) differ. Oracle's `SQLCODE` returns a number, while `SQLERRM` returns the message.
*   **Advantages Demonstrated:** Graceful error recovery, providing informative messages to the user or for logging.

**Exercise 1.5: Declaring and Raising User-Defined Exceptions**

*   <span class="problem-label">Problem Recap:</span> Create a procedure `AdjustStock` that takes `pProductId` (NUMBER) and `pQuantityChange` (NUMBER).
    *   Declare `InvalidStockOperationException`.
    *   Raise it if `pQuantityChange` is 0 or if applying it results in negative stock.
    *   Otherwise, update `stockQuantity`.
    *   Handle `InvalidStockOperationException` within the procedure.

*   **Solution Code:**
    ```sql
    CREATE OR REPLACE PROCEDURE AdjustStock (
        pProductId IN Products.productId%TYPE,
        pQuantityChange IN NUMBER
    ) AS
        InvalidStockOperationException EXCEPTION; -- Declare the user-defined exception
        vCurrentStock Products.stockQuantity%TYPE;
        vProductName Products.productName%TYPE;
    BEGIN
        -- Get current stock and product name for messages
        BEGIN
            SELECT stockQuantity, productName
            INTO vCurrentStock, vProductName
            FROM Products
            WHERE productId = pProductId;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Error: Product ID ' || pProductId || ' not found.');
                RETURN; -- Exit procedure if product not found
        END;

        IF pQuantityChange = 0 THEN
            RAISE InvalidStockOperationException; -- Raise with default or no message
        END IF;

        IF (vCurrentStock + pQuantityChange) < 0 THEN
            -- It's often better to raise with RAISE_APPLICATION_ERROR for custom messages
            -- But for this exercise, we'll stick to the basic RAISE and handle the message in the EXCEPTION block
            RAISE InvalidStockOperationException; 
        END IF;

        -- If no exception, update the stock
        UPDATE Products
        SET stockQuantity = stockQuantity + pQuantityChange
        WHERE productId = pProductId;

        DBMS_OUTPUT.PUT_LINE('Stock for product ' || vProductName || ' (ID: ' || pProductId || ') adjusted by ' || pQuantityChange || 
                             '. New quantity: ' || (vCurrentStock + pQuantityChange));
        COMMIT;

    EXCEPTION
        WHEN InvalidStockOperationException THEN
            IF pQuantityChange = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error: Quantity change cannot be zero for product ' || vProductName || ' (ID: ' || pProductId || ').');
            ELSE -- Implies negative stock scenario
                DBMS_OUTPUT.PUT_LINE('Error: Operation for product ' || vProductName || ' (ID: ' || pProductId || 
                                     ') would result in negative stock. Current: ' || vCurrentStock || ', Change: ' || pQuantityChange);
            END IF;
            ROLLBACK; -- Ensure atomicity if an error occurred
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLCODE || ' - ' || SQLERRM);
            ROLLBACK;
    END AdjustStock;
    /

    -- Test Scenarios
    SET SERVEROUTPUT ON;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test 1: Valid stock increase ---');
        AdjustStock(pProductId => 1000, pQuantityChange => 10); -- Laptop Pro, initial stock 50

        DBMS_OUTPUT.PUT_LINE('--- Test 2: Valid stock decrease (sale) ---');
        AdjustStock(pProductId => 1000, pQuantityChange => -5);

        DBMS_OUTPUT.PUT_LINE('--- Test 3: Quantity change is zero ---');
        AdjustStock(pProductId => 1001, pQuantityChange => 0); -- Wireless Mouse

        DBMS_OUTPUT.PUT_LINE('--- Test 4: Operation results in negative stock ---');
        AdjustStock(pProductId => 1002, pQuantityChange => -15); -- Keyboard Ultra, initial stock 10

        DBMS_OUTPUT.PUT_LINE('--- Test 5: Non-existent product ---');
        AdjustStock(pProductId => 9999, pQuantityChange => 5);
    END;
    /
    ```

*   **Detailed Explanation:**
    1.  **`InvalidStockOperationException EXCEPTION;`**: This line in the declaration section of the `AdjustStock` procedure defines a new, user-named exception.
    2.  **`RAISE InvalidStockOperationException;`**: This statement is used to explicitly signal that the `InvalidStockOperationException` has occurred.
        *   It's used when `pQuantityChange` is 0.
        *   It's also used if the calculation `(vCurrentStock + pQuantityChange)` would be less than 0.
    3.  **Exception Handler (`EXCEPTION WHEN InvalidStockOperationException THEN ...`)**: This block of code executes only if `InvalidStockOperationException` is raised within the `BEGIN...END` block of the procedure.
        *   It uses an `IF` statement to differentiate between the "zero quantity change" and "negative stock" scenarios to provide a more specific error message via `DBMS_OUTPUT.PUT_LINE`.
        *   `ROLLBACK` is included to undo any partial changes if an error occurs, ensuring the operation is atomic.
    4.  **Pre-check for Product Existence**: An inner `BEGIN...EXCEPTION...END` block is used to gracefully handle the case where `pProductId` doesn't exist. This prevents the main logic from failing on a `NO_DATA_FOUND` before it even gets to the stock operation checks.
    5.  **`WHEN OTHERS THEN ...`**: A general handler is good practice to catch any other unexpected issues.
    6.  **Test Scenarios**: The anonymous block demonstrates calling `AdjustStock` with various inputs to trigger different outcomes, including successful updates and the defined exceptions.

<div class="postgresql-bridge">
**Bridging from PostgreSQL:**
In PostgreSQL, you would typically raise an exception like this:
`RAISE EXCEPTION 'Quantity change cannot be zero' USING ERRCODE = 'P0001';` (where P0001 is a custom error code).
The catching mechanism in PL/pgSQL would be:
`EXCEPTION WHEN SQLSTATE 'P0001' THEN ...` or by a condition name if you've mapped it.
Oracle's approach separates the declaration of the exception name (`InvalidStockOperationException EXCEPTION;`) from the act of raising it (`RAISE InvalidStockOperationException;`). This named exception can then be caught directly by its name, which can improve readability.
</div>

**Exercise 1.6: Using `PRAGMA EXCEPTION_INIT`**

*   <span class="problem-label">Problem Recap:</span> Create a `Promotions` table. Attempt an insert that violates a rule (e.g., discount > 100). Map the resulting Oracle error (or a custom one) to `InvalidDiscountException` using `PRAGMA EXCEPTION_INIT` and handle it.

*   **Solution Code:**
    ```sql
    -- Drop table if it exists
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE Promotions';
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    /

    -- Create table with a check constraint
    CREATE TABLE Promotions (
        promotionId NUMBER PRIMARY KEY,
        discountPercentage NUMBER,
        CONSTRAINT chkDiscount CHECK (discountPercentage BETWEEN 0 AND 100)
    );

    -- PL/SQL block demonstrating PRAGMA EXCEPTION_INIT
    SET SERVEROUTPUT ON;
    DECLARE
        InvalidDiscountException EXCEPTION;
        -- ORA-02290 is the error for check constraint violation.
        PRAGMA EXCEPTION_INIT(InvalidDiscountException, -2290); 
        
        vPromotionId Promotions.promotionId%TYPE := 1;
        vDiscount Promotions.discountPercentage%TYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Attempting to insert an invalid discount...');
        vDiscount := 150; -- This will violate the check constraint

        BEGIN -- Inner block for the DML operation
            INSERT INTO Promotions (promotionId, discountPercentage)
            VALUES (vPromotionId, vDiscount);
            DBMS_OUTPUT.PUT_LINE('Promotion ' || vPromotionId || ' inserted with discount ' || vDiscount || '%.');
            COMMIT;
        EXCEPTION
            WHEN InvalidDiscountException THEN
                DBMS_OUTPUT.PUT_LINE('Error: Invalid discount percentage (' || vDiscount || '%). ORA-' || 
                                     TO_CHAR(ABS(SQLCODE)) || ': ' || SQLERRM);
                DBMS_OUTPUT.PUT_LINE('Associated PL/SQL Exception: InvalidDiscountException was caught.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLCODE || ' - ' || SQLERRM);
        END;

        DBMS_OUTPUT.PUT_LINE('---');
        DBMS_OUTPUT.PUT_LINE('Attempting to insert a valid discount...');
        vPromotionId := 2;
        vDiscount := 10;
        
        BEGIN -- Inner block for the DML operation
            INSERT INTO Promotions (promotionId, discountPercentage)
            VALUES (vPromotionId, vDiscount);
            DBMS_OUTPUT.PUT_LINE('Promotion ' || vPromotionId || ' inserted with discount ' || vDiscount || '%.');
            COMMIT;
        EXCEPTION
            WHEN InvalidDiscountException THEN -- Should not happen for valid discount
                DBMS_OUTPUT.PUT_LINE('Error: Invalid discount percentage (' || vDiscount || '%). Handled by InvalidDiscountException.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLCODE || ' - ' || SQLERRM);
        END;

    END;
    /
    ```

*   **Detailed Explanation:**
    1.  **`Promotions` Table:** Created with a `CHECK` constraint to ensure `discountPercentage` is between 0 and 100. This constraint will raise `ORA-02290` if violated.
    2.  **`InvalidDiscountException EXCEPTION;`**: Declares a user-defined exception.
    3.  **`PRAGMA EXCEPTION_INIT(InvalidDiscountException, -2290);`**: This is the key part.
        *   `PRAGMA EXCEPTION_INIT` is a compiler directive (not a runtime statement).
        *   It associates the PL/SQL exception name `InvalidDiscountException` with the Oracle error number `-2290` (which corresponds to `ORA-02290`, check constraint violation).
        *   The error number *must* be a negative integer, excluding -100 (`NO_DATA_FOUND`).
    4.  **First `INSERT` Attempt:**
        *   `vDiscount` is set to `150`, which violates the `chkDiscount` constraint.
        *   The `INSERT` statement will cause Oracle to raise `ORA-02290`.
        *   Because of the `PRAGMA EXCEPTION_INIT` directive, this `ORA-02290` is now also known by the PL/SQL name `InvalidDiscountException`.
        *   The `WHEN InvalidDiscountException THEN` handler catches the error, and a user-friendly message including `SQLCODE` and `SQLERRM` is displayed.
    5.  **Second `INSERT` Attempt:**
        *   `vDiscount` is set to `10` (valid).
        *   The `INSERT` succeeds, and no exception is raised.
    6.  **Inner Blocks for DML:** The `INSERT` statements are wrapped in their own `BEGIN...EXCEPTION...END` blocks. This is a good practice to isolate DML that might raise exceptions and handle them specifically, allowing the main block to continue if desired.

<div class="oracle-specific">
**Oracle Power Tool: `PRAGMA EXCEPTION_INIT`**
This pragma is extremely useful for making your error handling code more readable and maintainable. Instead of catching generic `WHEN OTHERS` or specific but cryptic `ORA-xxxxx` numbers, you can give meaningful names to Oracle errors relevant to your application's logic. This allows you to handle system-level errors (like constraint violations, deadlocks, etc.) with the same clarity as your custom user-defined exceptions.
</div>

#### (ii) Disadvantages and Pitfalls (Exception Handling)

**Exercise 2.3: Overuse of `WHEN OTHERS THEN NULL;`**

*   <span class="problem-label">Problem Recap:</span> Create `ProcessProduct` procedure which retrieves `unitPrice`. Include `EXCEPTION WHEN OTHERS THEN NULL;`. Test with valid, non-existent, and NULL `productId`. Explain pitfalls.

*   **Solution Code:**
    ```sql
    CREATE OR REPLACE PROCEDURE ProcessProduct (
        pProductId IN Products.productId%TYPE
    ) AS
        vUnitPrice Products.unitPrice%TYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Processing product ID: ' || NVL(TO_CHAR(pProductId), 'NULL'));
        
        SELECT unitPrice
        INTO vUnitPrice
        FROM Products
        WHERE productId = pProductId;
        
        DBMS_OUTPUT.PUT_LINE('Unit price for product ID ' || pProductId || ' is: ' || vUnitPrice);
        
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- This is the problematic handler
    END ProcessProduct;
    /

    -- Test Scenarios
    SET SERVEROUTPUT ON;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test 1: Valid Product ID (Laptop Pro, ID 1000) ---');
        ProcessProduct(pProductId => 1000); 
        -- Expected: Prints price.
        
        DBMS_OUTPUT.PUT_LINE('--- Test 2: Non-existent Product ID ---');
        ProcessProduct(pProductId => 9999); 
        -- Expected without bad handler: ORA-01403: no data found
        -- With bad handler: Nothing printed, error is swallowed.

        DBMS_OUTPUT.PUT_LINE('--- Test 3: NULL Product ID ---');
        ProcessProduct(pProductId => NULL); 
        -- Expected without bad handler: ORA-01403: no data found (as productId = NULL will not match any row unless there's a NULL PK, which is unlikely)
        -- With bad handler: Nothing printed, error is swallowed.
    END;
    /
    ```

*   **Detailed Explanation & Pitfalls:**
    1.  **Procedure Logic:** The procedure attempts to select the `unitPrice` for a given `pProductId`.
    2.  **`EXCEPTION WHEN OTHERS THEN NULL;`**: This is the critical part. This handler catches *any and all* exceptions that occur within the `BEGIN...END` block and then does absolutely nothing (`NULL` is a do-nothing statement).
    3.  **Test 1 (Valid Product ID):**
        *   The `SELECT` statement succeeds.
        *   The unit price is printed.
        *   The exception handler is not invoked.
    4.  **Test 2 (Non-existent Product ID):**
        *   The `SELECT` statement will not find a matching `productId` and would normally raise the predefined `NO_DATA_FOUND` exception (ORA-01403).
        *   However, the `WHEN OTHERS THEN NULL;` handler catches this `NO_DATA_FOUND` exception.
        *   Since the handler does `NULL;`, the exception is effectively "swallowed" or ignored.
        *   No error message is shown to the user or logged. The program continues as if nothing went wrong, which is highly misleading.
    5.  **Test 3 (NULL Product ID):**
        *   The `SELECT ... WHERE productId = NULL` will not match any rows (standard SQL behavior unless `productId` can actually be NULL and you have `ANSI_NULLS OFF`, which is not default Oracle behavior and generally not recommended for primary keys).
        *   This would also typically raise `NO_DATA_FOUND`.
        *   Again, the `WHEN OTHERS THEN NULL;` handler catches and silences this error.

    **Pitfalls of `WHEN OTHERS THEN NULL;` (or `WHEN OTHERS THEN -- do nothing`):**
    *   **Masks All Errors:** It catches every possible runtime error, from expected ones like `NO_DATA_FOUND` to critical unexpected ones like `STORAGE_ERROR`, `SYS_INVALID_ROWID`, or even programmer errors like `VALUE_ERROR` from an incorrect data type assignment.
    *   **Debugging Nightmare:** When errors are silently ignored, it becomes incredibly difficult to diagnose problems. The application might produce incorrect results, corrupt data, or behave erratically without any indication of where or why the problem originated.
    *   **Data Integrity Risks:** If an error during a DML operation is swallowed, the transaction might partially complete, leaving the database in an inconsistent state.
    *   **False Sense of Security:** The code *appears* to run without errors, but it's failing silently.
    *   **Hides Important Information:** `SQLCODE` and `SQLERRM` which provide crucial details about the error are not examined or logged.

    **Best Practice:**
    *   Handle specific exceptions that you anticipate and can recover from.
    *   If you use `WHEN OTHERS`, it should generally be at the outermost level of your program unit (or in specific controlled scenarios) and *must* include:
        *   Logging of the error details (e.g., `SQLCODE`, `SQLERRM`, `DBMS_UTILITY.FORMAT_ERROR_STACK`, `DBMS_UTILITY.FORMAT_ERROR_BACKTRACE`).
        *   A `RAISE;` or `RAISE_APPLICATION_ERROR;` statement to propagate the error or a more meaningful application-specific error, unless the error is truly benign and intentionally ignored (a very rare case).

**Exercise 2.4: Exception Raised in Declaration Section**

*   <span class="problem-label">Problem Recap:</span> Declare a `CONSTANT NUMBER(2)` and initialize it to `100`. Include a `VALUE_ERROR` handler in the same block. Observe if it's caught.

*   **Solution Code:**
    ```sql
    SET SERVEROUTPUT ON;
    BEGIN -- Outer (or only) block
        DECLARE
            -- This declaration will raise VALUE_ERROR (ORA-06502) because 100 does not fit in NUMBER(2)
            myConst CONSTANT NUMBER(2) := 100; 
        BEGIN
            DBMS_OUTPUT.PUT_LINE('This line will not be reached.');
            DBMS_OUTPUT.PUT_LINE('myConst = ' || myConst);
        EXCEPTION
            WHEN VALUE_ERROR THEN -- This handler is in the same block as the faulty declaration
                DBMS_OUTPUT.PUT_LINE('VALUE_ERROR caught within the declaration block - THIS WILL NOT HAPPEN.');
        END;
    EXCEPTION -- Exception handler for the outer block
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('VALUE_ERROR caught by the ENCLOSING block.');
            DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some other error caught by enclosing block: ' || SQLERRM);
    END;
    /
    ```

*   **Detailed Explanation:**
    1.  **`myConst CONSTANT NUMBER(2) := 100;`**:
        *   `NUMBER(2)` can store integers from -99 to 99.
        *   Attempting to initialize it with `100` will cause an `ORA-06502: PL/SQL: numeric or value error` (which is a `VALUE_ERROR` in PL/SQL) during the elaboration of the declaration section.
    2.  **Exception Propagation:**
        *   When an exception is raised in the *declaration section* of a PL/SQL block, control *immediately* passes to the exception-handling section of the *enclosing block* (if one exists).
        *   The exception handler within the *same block* where the declaration error occurred is **bypassed**.
    3.  **Execution and Output:**
        *   The `DECLARE` section of the inner anonymous block (if we consider the outer `BEGIN...END;` as the main block and the inner `DECLARE...BEGIN...EXCEPTION...END;` as a sub-block, though here it's simpler as a single block with a faulty declaration) attempts to initialize `myConst`.
        *   The `VALUE_ERROR` is raised.
        *   The `WHEN VALUE_ERROR THEN` handler *within that same block's EXCEPTION section* is **not** executed.
        *   If this entire structure was nested inside another `BEGIN...EXCEPTION...END;` block, that outer block's handler would catch it. In this standalone example, the error propagates to the SQL*Plus environment (or the calling environment).
        *   If we add an outer block with an exception handler as shown in the corrected solution code above, the output will be:
            ```
            VALUE_ERROR caught by the ENCLOSING block.
            SQLCODE: -6502, SQLERRM: ORA-06502: PL/SQL: numeric or value error: number precision too large
            ```

<div class="oracle-specific">
**Oracle PL/SQL Behavior:** This behavior is crucial to understand. Exceptions in declarations are handled by the parent scope, not the current scope's exception handler. This is because the block's executable section (and thus its own exception handlers) only get control *after* all declarations have been successfully processed. If a declaration fails, the block itself is not considered to have started execution properly.
</div>

#### (iii) Contrasting with Inefficient Common Solutions (Exception Handling)

**Exercise 3.2: Error Checking vs. Exception Handling for `NO_DATA_FOUND`**
*   **Scenario:** A developer needs to retrieve an employee's salary. If the employee doesn't exist, a default salary of 0 should be used.
*   **Less Idiomatic/Potentially Inefficient Common Solution (Problem):** The developer first performs a `SELECT COUNT(*)` to check if the employee exists, and then, based on the count, either performs another `SELECT` to get the salary or assigns the default. Write this PL/SQL block.
    ```sql
    -- Example of a less idiomatic (two-query) approach
    DECLARE
        vEmployeeId Employees.employeeId%TYPE := 999; -- Non-existent ID
        vSalary Employees.salary%TYPE;
        vEmployeeCount NUMBER;
    BEGIN
        SELECT COUNT(*) INTO vEmployeeCount FROM Employees WHERE employeeId = vEmployeeId;
        IF vEmployeeCount > 0 THEN
            SELECT salary INTO vSalary FROM Employees WHERE employeeId = vEmployeeId;
        ELSE
            vSalary := 0;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Salary: ' || vSalary);
    END;
    /
    ```
*   **Oracle-Idiomatic Solution (Solution):** Use a single `SELECT INTO` statement and an exception handler for `NO_DATA_FOUND` to assign the default salary.
    ```sql
    DECLARE
        vEmployeeId Employees.employeeId%TYPE := 999; -- Non-existent ID
        vSalary Employees.salary%TYPE;
    BEGIN
        BEGIN -- Inner block for specific exception handling
            SELECT salary INTO vSalary FROM Employees WHERE employeeId = vEmployeeId;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                vSalary := 0;
        END;
        DBMS_OUTPUT.PUT_LINE('Salary: ' || vSalary);
    END;
    /
    ```
*   **Focus:** Demonstrate that using exception handling for expected conditions like `NO_DATA_FOUND` can be more concise and often more efficient than explicit pre-checks in Oracle.
*   **Loss of Advantages (Inefficient):** The pre-check approach involves two separate SQL executions (one `COUNT(*)` and one actual data retrieval), which is generally less performant than a single `SELECT INTO` with an exception handler for a case where data might not be found. It also makes the code more verbose.
*   **Note:** While `NO_DATA_FOUND` is an exception, it's often considered a normal outcome in many scenarios (e.g., "is this user registered?"). For such "expected not found" cases, exception handling is idiomatic in Oracle.

### Category: Triggers

#### (i) Meanings, Values, Relations, and Advantages

**Exercise 1.7: Basic DML Trigger (`AFTER INSERT`)**
*   <span class="problem-label">Problem:</span> Create an `AFTER INSERT ON Orders FOR EACH ROW` trigger named `LogNewOrder`. This trigger should insert a record into the `AuditLog` table indicating that a new order was placed. Log the `tableName` ('Orders'), `operationType` ('INSERT'), and the `recordId` (the `:NEW.orderId`).
    Test by inserting a new order.
*   **Focus:** Basic DML trigger syntax, `AFTER INSERT` timing, `FOR EACH ROW` clause, and using the `:NEW` pseudorecord.
*   **Relations:**
    *   **Oracle:** Introduces core trigger concepts. Refer to `PL/SQL Language Reference (F46753-09)`, Chapter 10: "PL/SQL Triggers", sections "DML Triggers" (p. 10-4) and "Correlation Names and Pseudorecords" (p. 10-28). Also, `Get Started with Oracle Database Development (F79574-03)`, Chapter 6 is a good practical intro.
    *   **PostgreSQL Bridge:** PostgreSQL has a very similar trigger mechanism (`CREATE TRIGGER ... AFTER INSERT ON ... FOR EACH ROW EXECUTE FUNCTION ...`). The main difference is that Oracle trigger logic is directly embedded in the `CREATE TRIGGER` statement, while PostgreSQL triggers call a separate function. The `:NEW` and `:OLD` concepts (though named `NEW` and `OLD` in PG) are analogous.
*   **Advantages Demonstrated:** Automating actions (auditing) based on data modifications.

**Exercise 1.8: Trigger with Conditional Logic (`UPDATING` predicate)**
*   <span class="problem-label">Problem:</span> Create an `AFTER UPDATE ON Products FOR EACH ROW` trigger named `NotifyStockChange`.
    1.  Inside the trigger, use the `UPDATING('stockQuantity')` conditional predicate.
    2.  If `stockQuantity` was updated AND the new `stockQuantity` is less than 5, use `DBMS_OUTPUT.PUT_LINE` to simulate sending a low stock notification (e.g., "Low stock alert for Product ID: [product_id], New Quantity: [new_quantity]").
    Test by updating `stockQuantity` for a product to a value less than 5, and then update another column (e.g., `unitPrice`) for the same product.
*   **Focus:** Using conditional predicates (`UPDATING`) within a trigger to execute logic only when specific columns are affected.
*   **Relations:**
    *   **Oracle:** Focuses on conditional predicates. Refer to `PL/SQL Language Reference (F46753-09)`, Chapter 10, section "Conditional Predicates for Detecting Triggering DML Statement" (p. 10-5).
    *   **PostgreSQL Bridge:** PostgreSQL triggers can also achieve conditional logic within the trigger function using IF statements on the `NEW` and `OLD` values or by checking `TG_OP`. The `UPDATING('column_name')` predicate is a concise Oracle feature.
*   **Advantages Demonstrated:** More granular control over trigger execution, improving performance by only running logic when necessary.

**Exercise 1.9: Trigger Using `:OLD` and `:NEW`**
*   <span class="problem-label">Problem:</span> Create a `BEFORE UPDATE ON Employees FOR EACH ROW` trigger named `PreventSalaryDecrease`.
    This trigger should prevent any update that attempts to decrease an employee's salary. If a salary decrease is attempted, use `RAISE_APPLICATION_ERROR` with a custom error number (-20002) and a message "Salary decrease is not allowed."
    Test by attempting to decrease an employee's salary and then by attempting to increase it.
*   **Focus:** Using `:OLD` and `:NEW` to compare values before and after an update, and using `RAISE_APPLICATION_ERROR` to enforce a business rule.
*   **Relations:**
    *   **Oracle:** Reinforces `:OLD`/`:NEW` and introduces `RAISE_APPLICATION_ERROR` for custom error signaling from triggers. Refer to `PL/SQL Language Reference (F46753-09)`, Chapter 12, section "RAISE_APPLICATION_ERROR Procedure" (p. 12-18).
    *   **PostgreSQL Bridge:** PostgreSQL trigger functions use `NEW` and `OLD` records. To prevent an update, a PG trigger function would `RETURN NULL` (for a `BEFORE` trigger) or `RAISE EXCEPTION`. Oracle's `RAISE_APPLICATION_ERROR` is the standard way to return custom errors from PL/SQL to the calling environment.
*   **Advantages Demonstrated:** Enforcing complex business rules at the database level, providing clear error messages for violations.

#### (ii) Disadvantages and Pitfalls (Triggers)

**Exercise 2.5: The Mutating Table Error (ORA-04091)**
*   <span class="problem-label">Problem:</span>
    1.  Create a `BEFORE UPDATE OF salary ON Employees FOR EACH ROW` trigger named `CheckAvgSalary`.
    2.  Inside this trigger, attempt to query the `Employees` table itself to calculate the average salary of the employee's department (e.g., `SELECT AVG(salary) FROM Employees WHERE departmentId = :NEW.departmentId;`).
    3.  Try to update an employee's salary.
    Observe the error (ORA-04091). Explain why this error occurs and what the term "mutating table" means in this context.
*   **Focus:** Demonstrate the common "mutating table" error.
*   **Disadvantage/Pitfall:** Row-level triggers cannot query or modify the table on which they are defined because it's in a state of flux (mutating). This is a fundamental restriction to ensure data consistency.
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 10, section "Mutating-Table Restriction" (p. 10-42).

**Exercise 2.6: Cascading Triggers and Performance**
*   <span class="problem-label">Problem (Conceptual):**</span>
    Imagine you have three tables: `TableA`, `TableB`, and `TableC`.
    *   An `AFTER INSERT` trigger on `TableA` inserts a row into `TableB`.
    *   An `AFTER INSERT` trigger on `TableB` inserts a row into `TableC`.
    *   An `AFTER INSERT` trigger on `TableC` updates a row in `TableA`.
    What potential issue might arise here? How can the `OPEN_CURSORS` database parameter be relevant?
*   **Focus:** Understand the concept of cascading triggers and their potential for complexity, performance issues, or even infinite loops if not designed carefully.
*   **Disadvantage/Pitfall:**
    *   **Complexity:** Hard to debug and understand the flow of execution.
    *   **Performance:** Multiple DML operations and trigger firings can slow down the initial DML.
    *   **Recursion/Infinite Loops:** If a trigger on TableA causes an action that eventually fires the same trigger on TableA again (directly or indirectly), it can lead to an infinite loop (though Oracle has limits to prevent true infinite loops, it will hit a recursion depth error).
    *   **`OPEN_CURSORS`:** Each trigger execution and each SQL statement within a trigger consumes cursors. Deeply cascading triggers can exhaust the `OPEN_CURSORS` limit, leading to ORA-01000 errors.
*   **Relevant Docs:** `PL/SQL Language Reference (F46753-09)`, Chapter 10, section "Order in Which Triggers Fire" (p. 10-46) mentions the 32-trigger cascade limit.

#### (iii) Contrasting with Inefficient Common Solutions (Triggers)

**Exercise 3.3: Auditing Manually in Application vs. Using Triggers**
*   **Scenario:** Every time a product's `stockQuantity` is updated, the change needs to be logged into the `AuditLog` table.
*   **Inefficient/Error-Prone Common Solution (Problem):** The application developer decides to write code in every part of their application (e.g., Java, Python, or another PL/SQL procedure) that updates product stock to also manually insert a record into `AuditLog`. *You don't need to write the application code, just describe why this approach is problematic.*
*   **Oracle-Idiomatic Solution (Solution):** Implement the `trgUpdateProductStockAudit` trigger from Exercise 1.7 (or a similar one).
*   **Focus:** Showcasing the reliability and consistency benefits of using database triggers for auditing over manual application-level logging.
*   **Loss of Advantages (Inefficient/Problematic):**
    *   **Inconsistency:** Developers might forget to add the audit log insert in some parts of the application.
    *   **Duplication of Code:** Audit logic is repeated in multiple places.
    *   **Bypass:** Ad-hoc SQL updates made directly to the database (e.g., by a DBA for maintenance) would bypass the application-level audit.
    *   **Maintenance Overhead:** If the audit requirements change, all application code performing the update and audit needs to be modified.
    With a database trigger, the audit logic is centralized, enforced for *all* DML operations on the table (regardless of the source), and easier to maintain.

#### (iv) Hardcore Combined Problem

**Exercise 4.1: Order Processing System with Auditing and Error Handling**
*   <span class="problem-label">Problem Recap:**</span> Build `OrderManagementPkg` to place orders, handle insufficient stock with custom exceptions, and use triggers to audit stock and salary changes.
*   **Solution Code:**
    ```sql
    -- Package Specification: OrderManagementPkg
    CREATE OR REPLACE PACKAGE OrderManagementPkg AS
        InsufficientStockException EXCEPTION;
        PRAGMA EXCEPTION_INIT(InsufficientStockException, -20001);

        PROCEDURE PlaceOrder(
            pCustomerId IN Orders.customerId%TYPE,
            pProductId IN Products.productId%TYPE,
            pQuantity IN OrderItems.quantity%TYPE,
            pItemPrice IN OrderItems.itemPrice%TYPE
        );
    END OrderManagementPkg;
    /

    -- Package Body: OrderManagementPkg
    CREATE OR REPLACE PACKAGE BODY OrderManagementPkg AS
        PROCEDURE PlaceOrder(
            pCustomerId IN Orders.customerId%TYPE,
            pProductId IN Products.productId%TYPE,
            pQuantity IN OrderItems.quantity%TYPE,
            pItemPrice IN OrderItems.itemPrice%TYPE
        ) IS
            vOrderId Orders.orderId%TYPE;
            vOrderItemId OrderItems.orderItemId%TYPE;
            vCurrentStock Products.stockQuantity%TYPE;
            vProductName Products.productName%TYPE;
        BEGIN
            -- Check stock first
            SELECT productName, stockQuantity 
            INTO vProductName, vCurrentStock
            FROM Products
            WHERE productId = pProductId;

            IF vCurrentStock < pQuantity THEN
                RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for product: ' || vProductName || 
                                               '. Requested: ' || pQuantity || ', Available: ' || vCurrentStock);
            END IF;

            -- If stock is sufficient, proceed with order creation and stock update
            -- All of this should be part of the same transaction.
            -- A SAVEPOINT could be used here if parts of the order could proceed even if others fail,
            -- but for this exercise, we'll treat the whole order placement as atomic.

            INSERT INTO Orders (orderId, customerId, orderDate, status)
            VALUES (orderSeq.NEXTVAL, pCustomerId, SYSDATE, 'Processing')
            RETURNING orderId INTO vOrderId; -- Oracle 23ai RETURNING INTO for sequences

            INSERT INTO OrderItems (orderItemId, orderId, productId, quantity, itemPrice)
            VALUES (orderItemSeq.NEXTVAL, vOrderId, pProductId, pQuantity, pItemPrice);
            
            UPDATE Products
            SET stockQuantity = stockQuantity - pQuantity
            WHERE productId = pProductId;

            DBMS_OUTPUT.PUT_LINE('Order ' || vOrderId || ' placed successfully.');
            COMMIT; -- Commit the successful transaction

        EXCEPTION
            WHEN NO_DATA_FOUND THEN -- Product not found
                RAISE_APPLICATION_ERROR(-20003, 'Product ID ' || pProductId || ' not found.');
                -- No explicit ROLLBACK needed here as DML hasn't happened or will be rolled back by unhandled exception
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Unexpected error in PlaceOrder: ' || SQLCODE || ' - ' || SQLERRM);
                ROLLBACK; -- Rollback on any other unexpected error
                RAISE; -- Re-raise the original exception
        END PlaceOrder;
    END OrderManagementPkg;
    /

    -- Trigger: trgUpdateProductStockAudit
    CREATE OR REPLACE TRIGGER trgUpdateProductStockAudit
    AFTER UPDATE OF stockQuantity ON Products
    FOR EACH ROW
    BEGIN
        INSERT INTO AuditLog (tableName, operationType, recordId, oldValue, newValue)
        VALUES ('Products', 'UPDATE', :OLD.productId, TO_CHAR(:OLD.stockQuantity), TO_CHAR(:NEW.stockQuantity));
    END;
    /

    -- Trigger: trgLogEmployeeSalaryChanges
    CREATE OR REPLACE TRIGGER trgLogEmployeeSalaryChanges
    AFTER UPDATE OF salary ON Employees
    FOR EACH ROW
    WHEN (NEW.salary <> OLD.salary) -- Conditional Predicate
    BEGIN
        INSERT INTO AuditLog (tableName, operationType, recordId, oldValue, newValue)
        VALUES ('Employees', 'UPDATE', :OLD.employeeId, TO_CHAR(:OLD.salary), TO_CHAR(:NEW.salary));
    END;
    /

    -- Test Scenario 1: Successful order
    SET SERVEROUTPUT ON;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test Scenario 1: Successful Order ---');
        OrderManagementPkg.PlaceOrder(pCustomerId => 1, pProductId => 1000, pQuantity => 2, pItemPrice => 1200);
        -- Verify data in Orders, OrderItems, Products, AuditLog tables manually or with SELECTs
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Scenario 1: ' || SQLERRM);
    END;
    /

    -- Test Scenario 2: Insufficient stock
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test Scenario 2: Insufficient Stock ---');
        -- Product 1003 (Monitor HD) has stockQuantity = 0
        OrderManagementPkg.PlaceOrder(pCustomerId => 2, pProductId => 1003, pQuantity => 1, pItemPrice => 300);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught expected error in Test Scenario 2: ' || SQLCODE || ' - ' || SQLERRM);
            -- Verify no order/orderitem created and stock for product 1003 is still 0
    END;
    /

    -- Test Scenario 3: Update employee salary (should log)
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test Scenario 3: Update Employee Salary (should log) ---');
        UPDATE Employees SET salary = salary + 5000 WHERE employeeId = 100;
        COMMIT;
        -- Verify AuditLog for employee 100
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Scenario 3: ' || SQLERRM);
    END;
    /
    
    -- Test Scenario 4: Update employee salary to same value (should NOT log)
    DECLARE
        vCurrentSalary Employees.salary%TYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test Scenario 4: Update Employee Salary to same value (should NOT log) ---');
        SELECT salary INTO vCurrentSalary FROM Employees WHERE employeeId = 101;
        UPDATE Employees SET salary = vCurrentSalary WHERE employeeId = 101;
        COMMIT;
        -- Verify AuditLog - no new entry for employee 101 for this specific operation.
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Scenario 4: ' || SQLERRM);
    END;
    /
    ```
*   **Detailed Explanation:**
    1.  **`OrderManagementPkg` Specification:**
        *   Declares `InsufficientStockException` for clear, business-specific error handling.
        *   `PRAGMA EXCEPTION_INIT` associates this custom PL/SQL exception with an Oracle error number (-20001). This allows calling applications (like Java) to potentially catch this specific Oracle error number if the exception propagates unhandled by PL/SQL up to the client.
        *   Defines the public interface `PlaceOrder`.
    2.  **`OrderManagementPkg` Body:**
        *   **`PlaceOrder` Procedure:**
            *   **Pre-check for Stock:** Before any DML, it queries the `Products` table to get the `productName` (for a user-friendly message) and `stockQuantity`. This uses `SELECT INTO` (Chunk 5).
            *   **Raise Custom Exception:** If `vCurrentStock < pQuantity`, it uses `RAISE_APPLICATION_ERROR(-20001, ...)` to raise the custom error with a dynamic message. This immediately halts processing within the `BEGIN...END` block of `PlaceOrder` and transfers control to its `EXCEPTION` section.
            *   **Atomic Operations:** If stock is sufficient, it performs `INSERT` into `Orders` (using `orderSeq.NEXTVAL` - Chunk 2 SQL features), then `INSERT` into `OrderItems`, and finally `UPDATE`s `Products` stock.
            *   The Oracle 23ai feature `RETURNING orderId INTO vOrderId` is used with the INSERT into `Orders` to get the newly generated `orderId` without a separate `SELECT` statement.
            *   **Transaction Control:** `COMMIT` is issued only after all DML operations succeed. If any exception occurs before the `COMMIT` (either the stock check or an unexpected DML error), the `EXCEPTION` block's `ROLLBACK` (or the implicit rollback on unhandled exception propagation) will undo all changes made within the procedure call.
            *   **Exception Handling:**
                *   `WHEN NO_DATA_FOUND THEN`: Catches the case where the `pProductId` doesn't exist in the `Products` table during the initial stock check. It then raises a different custom application error.
                *   `WHEN OTHERS THEN`: Catches any other unexpected SQL or PL/SQL errors. It logs the `SQLCODE` and `SQLERRM` (Oracle built-in error functions) and then `RAISE`s the original exception to let the calling environment know something went wrong. This is crucial for not silently swallowing unexpected errors.
    3.  **`trgUpdateProductStockAudit` Trigger:**
        *   `AFTER UPDATE OF stockQuantity ON Products`: Fires after an update operation specifically on the `stockQuantity` column of the `Products` table.
        *   `FOR EACH ROW`: Indicates it's a row-level trigger, meaning it fires for each row affected by the `UPDATE` statement.
        *   The trigger body simply `INSERT`s a new record into `AuditLog`, using `:OLD.productId` (the product ID of the row being updated), `:OLD.stockQuantity` (the value before the update), and `:NEW.stockQuantity` (the value after the update). The `:OLD` and `:NEW` are pseudorecords (this Chunk).
    4.  **`trgLogEmployeeSalaryChanges` Trigger:**
        *   `AFTER UPDATE OF salary ON Employees`: Fires after the `salary` column is updated.
        *   `WHEN (NEW.salary <> OLD.salary)`: This is a conditional predicate (this Chunk). The trigger body will only execute if the new salary is actually different from the old salary, preventing unnecessary audit logs for "updates" that don't change the value.
        *   The body logs the change to `AuditLog` using `:OLD` and `:NEW` values.
    5.  **Test Scenarios:** The anonymous blocks demonstrate various use cases, including successful operations, expected error handling (insufficient stock), and the conditional logic of the salary update trigger.

<div class="oracle-specific">
**Oracle Power Play:** This hardcore problem combines several key Oracle PL/SQL features:
*   **Packages** for modularity and encapsulation.
*   **User-defined exceptions** and `RAISE_APPLICATION_ERROR` for robust, application-specific error signaling.
*   **Triggers** for automated auditing and business rule enforcement at the database level.
*   **:OLD and :NEW pseudorecords** for accessing row data within triggers.
*   **Conditional predicates in triggers** for fine-grained control over trigger execution.
*   **Implicit and explicit transaction control** (`COMMIT`, `ROLLBACK`).
*   **Oracle 23ai's `RETURNING INTO`** with sequence-generated values in `INSERT` statements provides a more concise way to get generated IDs.
This type of integrated design ensures data integrity, provides clear error feedback, and automates common tasks, making the application more resilient and maintainable.
</div>

</div>