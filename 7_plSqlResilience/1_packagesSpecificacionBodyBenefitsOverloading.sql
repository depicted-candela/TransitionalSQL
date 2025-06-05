        -- Category: Packages: Specification, body, benefits, overloading


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 1.1: Basic Package Creation and Usage
-- Problem: Create a package named EmployeeUtils that has:
-- A public function GetEmployeeFullName which takes an employeeId (NUMBER) and returns the employee's full name (firstName || ' ' || lastName).
-- A public procedure UpdateEmployeeSalary which takes an employeeId (NUMBER) and a newSalary (NUMBER) and updates the employee's salary.
-- Write a PL/SQL anonymous block to call both the function and the procedure for an existing employee.
CREATE OR REPLACE PACKAGE PLSQLRESILIENCE.EmployeeUtils AS
    FUNCTION GetEmployeeFullName (empId PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE) RETURN VARCHAR2;
    PROCEDURE UpdateEmployeeSalary (empId IN PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE, newSalary IN PLSQLRESILIENCE.EMPLOYEES.salary%TYPE);
END EmployeeUtils;
/
CREATE OR REPLACE PACKAGE BODY PLSQLRESILIENCE.EmployeeUtils AS
    pFullName VARCHAR2(101);

    FUNCTION GetEmployeeFullName (empId PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE) RETURN VARCHAR2 IS
    BEGIN SELECT firstName||' '||lastName INTO pFullName FROM PLSQLRESILIENCE.EMPLOYEES WHERE EMPLOYEEID = empId;
    IF SQL%NOTFOUND THEN RETURN NULL; END IF;
    RETURN pFullName;
    EXCEPTION 
        WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND for the employeeId '||empId); RETURN NULL;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND for the employeeId '||empId); RETURN NULL;
    END GetEmployeeFullName;

    PROCEDURE UpdateEmployeeSalary (empId IN PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE, newSalary IN PLSQLRESILIENCE.EMPLOYEES.salary%TYPE) IS
    BEGIN UPDATE PLSQLRESILIENCE.EMPLOYEES SET SALARY = newSalary WHERE EMPLOYEEID = empId;
    IF SQL%NOTFOUND THEN RETURN; END IF;
    DBMS_OUTPUT.PUT_LINE('Salary of employeeId '||empId||' updated to '||newSalary);
    EXCEPTION WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('employeeId NOT FOUND to update '||empId);
    END UpdateEmployeeSalary;
END EmployeeUtils;
/

DECLARE
    empId PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE := 101;
    fullName VARCHAR2(101);
BEGIN
    fullName := PLSQLRESILIENCE.EmployeeUtils.GetEmployeeFullName(empId);
    DBMS_OUTPUT.PUT_LINE('The fullname of employee '||empId||' is '||fullName);
    PLSQLRESILIENCE.EmployeeUtils.UpdateEmployeeSalary(empId, 10000);
END;
/

--      Exercise 1.2: Package Variables and State
-- Problem: Modify the EmployeeUtils package:
-- Add a public variable defaultRaisePercentage of type NUMBER initialized to 5 in the package specification.
-- Add a private variable totalRaisesProcessed of type NUMBER in the package body, initialized to 0.
-- Modify UpdateEmployeeSalary to also accept an optional raisePercentage (NUMBER). If raisePercentage is NULL, use defaultRaisePercentage.
-- Inside UpdateEmployeeSalary, increment totalRaisesProcessed each time a salary is successfully updated.
-- Add a public function GetTotalRaisesProcessed to the package that returns the value of totalRaisesProcessed.
-- Write an anonymous block to call UpdateEmployeeSalary twice (once with and once without the optional percentage) and then display the total raises processed.
CREATE OR REPLACE PACKAGE PLSQLRESILIENCE.EmployeeUtils AS
    defaultRaisePercentage NUMBER := 5;
    FUNCTION GetEmployeeFullName (empId PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE) RETURN VARCHAR2;
    PROCEDURE UpdateEmployeeSalary (
        empId IN PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE, 
        newSalary IN PLSQLRESILIENCE.EMPLOYEES.salary%TYPE, 
        raisePercentage NUMBER DEFAULT NULL
    );
    FUNCTION GetTotalRaisesProcessed RETURN NUMBER;
END EmployeeUtils;
/
CREATE OR REPLACE PACKAGE BODY PLSQLRESILIENCE.EmployeeUtils AS
    pFullName VARCHAR2(101);
    totalRaisesProcessed NUMBER := 0;

    FUNCTION GetEmployeeFullName (empId PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE) RETURN VARCHAR2 IS
    BEGIN 
        SELECT firstName||' '||lastName INTO pFullName FROM PLSQLRESILIENCE.EMPLOYEES WHERE EMPLOYEEID = empId;
        IF SQL%NOTFOUND THEN RETURN NULL; END IF;
        RETURN pFullName;
    EXCEPTION 
        WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND for the employeeId '||empId); RETURN NULL;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND for the employeeId '||empId); RETURN NULL;
    END GetEmployeeFullName;

    PROCEDURE UpdateEmployeeSalary (
        empId IN PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE, 
        newSalary IN PLSQLRESILIENCE.EMPLOYEES.salary%TYPE,
        raisePercentage NUMBER DEFAULT NULL
    ) IS BEGIN 
        UPDATE PLSQLRESILIENCE.EMPLOYEES SET SALARY = newSalary * (1 + NVL(raisePercentage/100, defaultRaisePercentage/100)) WHERE EMPLOYEEID = empId;
        IF SQL%NOTFOUND THEN RETURN; END IF;
        totalRaisesProcessed := totalRaisesProcessed + 1;
        DBMS_OUTPUT.PUT_LINE('Salary of employeeId '||empId||' updated to '||newSalary);
    EXCEPTION WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('employeeId NOT FOUND to update '||empId);
    END UpdateEmployeeSalary;

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER IS BEGIN RETURN totalRaisesProcessed; END;
END EmployeeUtils;
/
DECLARE
    empId1 PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE := 101;
    empId2 PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE := 102;
BEGIN
    PLSQLRESILIENCE.EmployeeUtils.UpdateEmployeeSalary(empId1, 10000);
    PLSQLRESILIENCE.EmployeeUtils.UpdateEmployeeSalary(empId2, 100000, 2);
    PLSQLRESILIENCE.EmployeeUtils.UpdateEmployeeSalary(empId1, 1000000, 20);
    DBMS_OUTPUT.PUT_LINE('The current total number of raised salaries is ' || PLSQLRESILIENCE.EmployeeUtils.GetTotalRaisesProcessed());
END;
/

--      Exercise 1.3: Package Subprogram Overloading
-- Problem: In the EmployeeUtils package:
-- Overload the GetEmployeeFullName function. Create a new version that takes firstName (VARCHAR2) and lastName (VARCHAR2) as input and returns the concatenated full 
-- name.
-- Write an anonymous block that calls both versions of GetEmployeeFullName.
CREATE OR REPLACE PACKAGE PLSQLRESILIENCE.EmployeeUtils AS
    defaultRaisePercentage NUMBER := 5;
    FUNCTION GetEmployeeFullName (empId PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE) RETURN VARCHAR2;
    FUNCTION GetEmployeeFullName (fName PLSQLRESILIENCE.EMPLOYEES.firstName%TYPE, lName PLSQLRESILIENCE.EMPLOYEES.lastName%TYPE) RETURN VARCHAR2;
    PROCEDURE UpdateEmployeeSalary (
        empId IN PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE, 
        newSalary IN PLSQLRESILIENCE.EMPLOYEES.salary%TYPE, 
        raisePercentage NUMBER DEFAULT NULL
    );
    FUNCTION GetTotalRaisesProcessed RETURN NUMBER;
END EmployeeUtils;
/
CREATE OR REPLACE PACKAGE BODY PLSQLRESILIENCE.EmployeeUtils AS
    pFullName VARCHAR2(101);
    totalRaisesProcessed NUMBER := 0;

    FUNCTION GetEmployeeFullName (empId PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE) RETURN VARCHAR2 IS
    BEGIN 
        SELECT firstName||' '||lastName INTO pFullName FROM PLSQLRESILIENCE.EMPLOYEES WHERE EMPLOYEEID = empId;
        IF SQL%NOTFOUND THEN RETURN NULL; END IF;
        RETURN pFullName;
    EXCEPTION 
        WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND for the employeeId '||empId); RETURN NULL;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND for the employeeId '||empId); RETURN NULL;
    END GetEmployeeFullName;

    FUNCTION GetEmployeeFullName (fName PLSQLRESILIENCE.EMPLOYEES.firstName%TYPE, lName PLSQLRESILIENCE.EMPLOYEES.lastName%TYPE) RETURN VARCHAR2 IS
    BEGIN 
        SELECT firstName||' '||lastName INTO pFullName FROM PLSQLRESILIENCE.EMPLOYEES WHERE FIRSTNAME = fName AND LASTNAME = lName;
        IF SQL%NOTFOUND THEN RETURN NULL; END IF;
        RETURN pFullName;
    EXCEPTION 
        WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA FOUND for the employee '||fName||' '||lName); RETURN NULL;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected error '||SQLERRM||' for '||fName||' '||lName); RETURN NULL;
    END GetEmployeeFullName;

    PROCEDURE UpdateEmployeeSalary (
        empId IN PLSQLRESILIENCE.EMPLOYEES.employeeId%TYPE, 
        newSalary IN PLSQLRESILIENCE.EMPLOYEES.salary%TYPE,
        raisePercentage NUMBER DEFAULT NULL
    ) IS BEGIN 
        UPDATE PLSQLRESILIENCE.EMPLOYEES SET SALARY = newSalary * (1 + NVL(raisePercentage/100, defaultRaisePercentage/100)) WHERE EMPLOYEEID = empId;
        IF SQL%NOTFOUND THEN RETURN; END IF;
        totalRaisesProcessed := totalRaisesProcessed + 1;
        DBMS_OUTPUT.PUT_LINE('Salary of employeeId '||empId||' updated to '||newSalary);
    EXCEPTION WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('employeeId NOT FOUND to update '||empId);
    END UpdateEmployeeSalary;

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER IS BEGIN RETURN totalRaisesProcessed; END;
END EmployeeUtils;
/
DECLARE
    fullName VARCHAR2(101);
BEGIN
    fullName := PLSQLRESILIENCE.EmployeeUtils.GetEmployeeFullName('Nicolas', 'Cordoba');
    fullName := PLSQLRESILIENCE.EmployeeUtils.GetEmployeeFullName('John', 'Doe');
    DBMS_OUTPUT.PUT_LINE('Full name: '||fullName);
END;
/


--  (ii) Disadvantages and Pitfalls

--      Exercise 2.1: Package State Invalidation
-- Problem:
-- Create a simple package StatefulPkg with a specification that declares a public variable counter (NUMBER := 0) and a procedure IncrementCounter.
-- Create the package body for StatefulPkg where IncrementCounter increments the counter variable and uses DBMS_OUTPUT.PUT_LINE to display its new value and an 
-- initialization block that outputs "StatefulPkg initialized".
-- In one SQL*Plus session (Session 1), execute an anonymous block that calls StatefulPkg.IncrementCounter twice. Note the output.
-- In a separate SQL*Plus session (Session 2), recompile the body of StatefulPkg (e.g., ALTER PACKAGE StatefulPkg COMPILE BODY;).
-- Go back to Session 1 and execute StatefulPkg.IncrementCounter again. Observe the output and any errors. Explain what happened.
CREATE OR REPLACE PACKAGE PLSQLRESILIENCE.StatefulPkg AS 
    counter NUMBER := 0;
    PROCEDURE IncrementCounter;
END StatefulPkg;
/
CREATE OR REPLACE PACKAGE BODY PLSQLRESILIENCE.StatefulPkg AS 
    PROCEDURE IncrementCounter
    IS BEGIN
        counter := counter + 1;
        DBMS_OUTPUT.PUT_LINE('Counter: '||counter);
    END;
BEGIN   
    DBMS_OUTPUT.PUT_LINE('StatefulPkg initialized');
END StatefulPkg;
/
BEGIN
    PLSQLRESILIENCE.StatefulPkg.IncrementCounter();
    PLSQLRESILIENCE.StatefulPkg.IncrementCounter();
END;
/
ALTER PACKAGE PLSQLRESILIENCE.StatefulPkg COMPILE BODY; -- Runnning this in another session makes unusable such function
                                                        -- in the previous session. Thus the previous session must be closed if it's necessary to use there
                                                        -- such function

--      Exercise 2.2: Overloading Pitfall - Ambiguity with Implicit Conversions
-- Problem: Create a package OverloadDemo with two overloaded procedures:
-- ProcessValue(pValue IN NUMBER)
-- ProcessValue(pValue IN VARCHAR2)
CREATE OR REPLACE PACKAGE PLSQLRESILIENCE.OverloadDemo AS
    PROCEDURE ProcessValue(pValue IN NUMBER);
    PROCEDURE ProcessValue(pValue IN VARCHAR2);
END OverloadDemo;
/
CREATE OR REPLACE PACKAGE BODY PLSQLRESILIENCE.OverloadDemo AS
    PROCEDURE ProcessValue(pValue IN NUMBER)
    IS BEGIN
        DBMS_OUTPUT.PUT_LINE('Numeric overloaded version used');
    END ProcessValue;
    PROCEDURE ProcessValue(pValue IN VARCHAR2)
    IS BEGIN
        DBMS_OUTPUT.PUT_LINE('Alphameric overloaded version used');
    END ProcessValue;
END OverloadDemo;
/
BEGIN
    PLSQLRESILIENCE.OverloadDemo.ProcessValue(SYSDATE);
    PLSQLRESILIENCE.OverloadDemo.ProcessValue('AOIJDFAOSIDJF');
END;
/
-- Both procedures should simply use DBMS_OUTPUT.PUT_LINE to indicate which version was called. Now, in an anonymous block, call ProcessValue with a DATE type variable
-- (e.g., SYSDATE). Analyze what happens and why. Propose a resolution to explicitly call the desired version.
-- Answer: the compiler catches the argument in specific ways if it can be casted, getting the first overloading function that can cast the given value. This is
-- conflictive if the given argument can be casted by two different overloadings, for this type of problems or the order must be well selected (despite this approach
-- does not have always a solution) or a specific overloading for all possible cases must be written.


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 3.1: Package vs. Standalone Utilities for String Operations
-- Scenario: A development team frequently needs to perform several common string operations: reversing a string, counting vowels in a string, and checking if a string
-- is a palindrome.
-- Inefficient Common Solution (Problem): Implement these three utilities as standalone PL/SQL functions: ReverseString(pInputString IN VARCHAR2) RETURN VARCHAR2, 
-- CountVowels(pInputString IN VARCHAR2) RETURN NUMBER, and IsPalindrome(pInputString IN VARCHAR2) RETURN BOOLEAN.
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
-- Oracle-Idiomatic Solution (Solution): Design and implement a single package named StringUtilities that encapsulates these three functions as public subprograms. 
-- Additionally, consider if any helper logic (e.g., a private function to standardize character case for palindrome check) could be part of the package body.
CREATE OR REPLACE PACKAGE PLSQLRESILIENCE.StringUtilities AS
    FUNCTION ReverseString (pInput IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION CountVowels (pInput IN VARCHAR2) RETURN NUMBER;
    FUNCTION IsPalindrome (pInput IN VARCHAR2) RETURN BOOLEAN;
END StringUtilities;
/

CREATE OR REPLACE PACKAGE BODY PLSQLRESILIENCE.StringUtilities AS
    FUNCTION ReverseString (pInput IN VARCHAR2) RETURN VARCHAR2 IS
        vReversed VARCHAR2(4000) := '';
    BEGIN
        FOR i IN REVERSE 1..LENGTH(pInput) LOOP
            vReversed := vReversed || SUBSTR(pInput, i, 1);
        END LOOP;
        RETURN vReversed;
    END ReverseString;

    FUNCTION CountVowels (pInput IN VARCHAR2) RETURN NUMBER IS
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

    FUNCTION IsPalindrome (pInput IN VARCHAR2) RETURN BOOLEAN IS
        vCleanedInput VARCHAR2(4000);
        vReversedInput VARCHAR2(4000);
    BEGIN
        -- Basic cleaning: remove spaces and convert to upper case
        vCleanedInput := UPPER(REPLACE(pInput, ' ', ''));
        IF vCleanedInput IS NULL THEN RETURN TRUE; END IF; -- Empty or all spaces is a palindrome
        
        vReversedInput := ReverseString(vCleanedInput); -- Reuses the standalone ReverseString
        
        RETURN vCleanedInput = vReversedInput;
    END IsPalindrome;
END StringUtilities;
/

-- Task: Write the DDL for both the inefficient (standalone functions) and the efficient (package-based) solutions. Discuss the advantages the package solution offers 
-- in terms of organization, maintainability, deployment, and potential for shared internal logic.
-- Answer: organization - when you have in mind just the name of packages, often IDEs shows the available functions, thus is not necessary to remember each name, 
-- keeping focus on very important tasks
-- maintainability & internal logic - when you know exactly where things are or could be is more maintainable the code writing as is natively performed the well 
-- partition of tools in chunks to be mixed with the ease of an organized set of tools for easy remembering of artifacts
-- deployment - better organization means better performance and less errors (highly relevant in production)