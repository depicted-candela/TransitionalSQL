<head>
    <link rel="stylesheet" href="../styles/solutions.css">
</head>

<body>
    <div class="container">
    <h1>PL/SQL Resilience: Packages, Errors, and Automation - Solutions</h1>
    <div class="exercise-set">
    <h2>Dataset for Exercises (Corrected with Schema Prefix)</h2>
    <p>This dataset is essential for the exercises. Ensure it's created in your Oracle DB 23ai environment. The <code>plsqlresilience</code> schema prefix is used as implied by the exercise descriptions.</p>

```sql
-- Drop tables if they exist to ensure a clean slate
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.OrderItems';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Orders';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Products';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.AuditLog';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Employees';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Departments';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Drop sequences if they exist
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.DepartmentSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.EmployeeSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.ProductSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.OrderSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.OrderItemSeq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Create Tables
CREATE TABLE plsqlresilience.Departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    locationCity VARCHAR2(100)
);

CREATE TABLE plsqlresilience.Employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    salary NUMBER(10, 2),
    departmentId NUMBER,
    hireDate DATE DEFAULT SYSDATE,
    CONSTRAINT fkEmployeeDepartment FOREIGN KEY (departmentId) REFERENCES plsqlresilience.Departments(departmentId)
);

CREATE TABLE plsqlresilience.Products (
    productId NUMBER PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    unitPrice NUMBER(10, 2) CHECK (unitPrice > 0),
    stockQuantity NUMBER DEFAULT 0 CHECK (stockQuantity >= 0)
);

CREATE TABLE plsqlresilience.Orders (
    orderId NUMBER PRIMARY KEY,
    customerId NUMBER,
    orderDate DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE plsqlresilience.OrderItems (
    orderItemId NUMBER PRIMARY KEY,
    orderId NUMBER NOT NULL,
    productId NUMBER NOT NULL,
    quantity NUMBER CHECK (quantity > 0),
    itemPrice NUMBER(10, 2),
    CONSTRAINT fkOrderItemOrder FOREIGN KEY (orderId) REFERENCES plsqlresilience.Orders(orderId),
    CONSTRAINT fkOrderItemProduct FOREIGN KEY (productId) REFERENCES plsqlresilience.Products(productId)
);

CREATE TABLE plsqlresilience.AuditLog (
    logId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tableName VARCHAR2(50),
    operationType VARCHAR2(10),
    changedBy VARCHAR2(100) DEFAULT USER,
    changeTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    oldValue CLOB,
    newValue CLOB,
    recordId VARCHAR2(100)
);

-- Create Sequences
CREATE SEQUENCE plsqlresilience.DepartmentSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.EmployeeSeq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.ProductSeq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.OrderSeq START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.OrderItemSeq START WITH 10000 INCREMENT BY 1;

-- Populate plsqlresilience.Departments
INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity) VALUES (plsqlresilience.DepartmentSeq.NEXTVAL, 'Sales', 'New York');
INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity) VALUES (plsqlresilience.DepartmentSeq.NEXTVAL, 'HR', 'London');
INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity) VALUES (plsqlresilience.DepartmentSeq.NEXTVAL, 'IT', 'Bangalore');

-- Populate plsqlresilience.Employees
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.EmployeeSeq.NEXTVAL, 'John', 'Doe', 'john.doe@example.com', 60000, 1, TO_DATE('2022-01-15', 'YYYY-MM-DD'));
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.EmployeeSeq.NEXTVAL, 'Jane', 'Smith', 'jane.smith@example.com', 75000, 1, TO_DATE('2021-03-22', 'YYYY-MM-DD'));
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.EmployeeSeq.NEXTVAL, 'Alice', 'Wonder', 'alice.wonder@example.com', 50000, 2, TO_DATE('2022-07-10', 'YYYY-MM-DD'));
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.EmployeeSeq.NEXTVAL, 'Bob', 'Builder', 'bob.builder@example.com', 90000, 3, TO_DATE('2020-11-01', 'YYYY-MM-DD'));

-- Populate plsqlresilience.Products
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.ProductSeq.NEXTVAL, 'Laptop Pro', 1200, 50);
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.ProductSeq.NEXTVAL, 'Wireless Mouse', 25, 200);
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.ProductSeq.NEXTVAL, 'Keyboard Ultra', 75, 10);
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.ProductSeq.NEXTVAL, 'Monitor HD', 300, 0); -- Out of stock for exception handling

COMMIT;
```

<hr>
    <h2>Category: Packages: Specification, body, benefits, overloading</h2>
    <h3>(i) Meanings, Values, Relations, and Advantages</h3>
        <h4>Exercise 1.1: Basic Package Creation and Usage</h4>
        <p><strong>Solution:</strong></p>

```sql
-- Package Specification
CREATE OR REPLACE PACKAGE plsqlresilience.EmployeeUtils AS
    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2;

    PROCEDURE UpdateEmployeeSalary (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary  IN plsqlresilience.Employees.salary%TYPE);
END EmployeeUtils;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY plsqlresilience.EmployeeUtils AS
    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2
    IS
        v_fullName VARCHAR2(101); -- Max 50 for first + 1 space + 50 for last
    BEGIN
        SELECT firstName || ' ' || lastName
        INTO v_fullName
        FROM plsqlresilience.Employees
        WHERE employeeId = p_employeeId;
        RETURN v_fullName;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Employee not found';
    END GetEmployeeFullName;

    PROCEDURE UpdateEmployeeSalary (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary  IN plsqlresilience.Employees.salary%TYPE)
    IS
    BEGIN
        UPDATE plsqlresilience.Employees
        SET salary = p_newSalary
        WHERE employeeId = p_employeeId;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employeeId || ' not found or salary not changed.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Salary updated for employee ID ' || p_employeeId || '.');
            COMMIT; -- Or handle transaction management at a higher level
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
            ROLLBACK; -- Rollback on error
    END UpdateEmployeeSalary;
END EmployeeUtils;
/
-- Anonymous block to test the package
DECLARE
    v_empId    plsqlresilience.Employees.employeeId%TYPE := 100; -- Assuming employee 100 exists
    v_fullName VARCHAR2(101);
    v_newSal   plsqlresilience.Employees.salary%TYPE := 65000;
BEGIN
    -- Test GetEmployeeFullName
    v_fullName := plsqlresilience.EmployeeUtils.GetEmployeeFullName(v_empId);
    DBMS_OUTPUT.PUT_LINE('Full name for employee ' || v_empId || ': ' || v_fullName);

    -- Test UpdateEmployeeSalary
    plsqlresilience.EmployeeUtils.UpdateEmployeeSalary(p_employeeId => v_empId, p_newSalary => v_newSal);

    -- Verify update (optional, can be checked with a SELECT statement)
    SELECT salary INTO v_newSal FROM plsqlresilience.Employees WHERE employeeId = v_empId;
    DBMS_OUTPUT.PUT_LINE('Verified new salary for employee ' || v_empId || ': ' || v_newSal);

    -- Test with a non-existent employee
    v_fullName := plsqlresilience.EmployeeUtils.GetEmployeeFullName(999);
    DBMS_OUTPUT.PUT_LINE('Full name for employee 999: ' || v_fullName);

    plsqlresilience.EmployeeUtils.UpdateEmployeeSalary(p_employeeId => 999, p_newSalary => 50000);
END;
/
```
        
<h4>Exercise 1.2: Package Variables and State</h4>
    <p><strong>Solution:</strong></p>

```sql
-- Package Specification
CREATE OR REPLACE PACKAGE plsqlresilience.EmployeeUtils AS
    defaultRaisePercentage NUMBER := 5; -- Public variable

    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2;

    PROCEDURE UpdateEmployeeSalary (p_employeeId     IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary      IN plsqlresilience.Employees.salary%TYPE DEFAULT NULL,
                                    p_raisePercentage IN NUMBER DEFAULT NULL); -- Optional parameter

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER;
END EmployeeUtils;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY plsqlresilience.EmployeeUtils AS
    totalRaisesProcessed NUMBER := 0; -- Private variable, initialized

    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2
    IS
        v_fullName VARCHAR2(101);
    BEGIN
        SELECT firstName || ' ' || lastName
        INTO v_fullName
        FROM plsqlresilience.Employees
        WHERE employeeId = p_employeeId;
        RETURN v_fullName;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Employee not found';
    END GetEmployeeFullName;

    PROCEDURE UpdateEmployeeSalary (p_employeeId     IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary      IN plsqlresilience.Employees.salary%TYPE DEFAULT NULL,
                                    p_raisePercentage IN NUMBER DEFAULT NULL)
    IS
        v_calculatedSalary plsqlresilience.Employees.salary%TYPE;
        v_currentSalary    plsqlresilience.Employees.salary%TYPE;
        v_actualRaisePct   NUMBER;
    BEGIN
        SELECT salary INTO v_currentSalary FROM plsqlresilience.Employees WHERE employeeId = p_employeeId;

        IF p_newSalary IS NOT NULL THEN
            v_calculatedSalary := p_newSalary;
        ELSE
            IF p_raisePercentage IS NOT NULL THEN
                v_actualRaisePct := p_raisePercentage;
            ELSE
                v_actualRaisePct := defaultRaisePercentage; -- Use package public variable
            END IF;
            v_calculatedSalary := v_currentSalary * (1 + (v_actualRaisePct / 100));
        END IF;

        UPDATE plsqlresilience.Employees
        SET salary = v_calculatedSalary
        WHERE employeeId = p_employeeId;

        IF SQL%ROWCOUNT > 0 THEN
            totalRaisesProcessed := totalRaisesProcessed + 1; -- Increment private variable
            DBMS_OUTPUT.PUT_LINE('Salary updated for employee ID ' || p_employeeId || ' to ' || v_calculatedSalary || '.');
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employeeId || ' not found.');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employeeId || ' not found for salary update.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
            ROLLBACK;
    END UpdateEmployeeSalary;

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER IS
    BEGIN
        RETURN totalRaisesProcessed;
    END GetTotalRaisesProcessed;

BEGIN
    DBMS_OUTPUT.PUT_LINE('EmployeeUtils package initialized. Default raise: ' || defaultRaisePercentage || '%');
END EmployeeUtils;
/

-- Anonymous block to test
DECLARE
    v_empId1 plsqlresilience.Employees.employeeId%TYPE := 100;
    v_empId2 plsqlresilience.Employees.employeeId%TYPE := 101;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Initial total raises: ' || plsqlresilience.EmployeeUtils.GetTotalRaisesProcessed());

    -- Call with explicit new salary
    plsqlresilience.EmployeeUtils.UpdateEmployeeSalary(p_employeeId => v_empId1, p_newSalary => 70000);

    -- Call with explicit raise percentage
    plsqlresilience.EmployeeUtils.UpdateEmployeeSalary(p_employeeId => v_empId2, p_raisePercentage => 10);

    -- Call using default raise percentage (p_newSalary is NULL, p_raisePercentage is NULL)
    plsqlresilience.EmployeeUtils.UpdateEmployeeSalary(p_employeeId => 102); -- Assuming emp 102 exists

    DBMS_OUTPUT.PUT_LINE('Final total raises processed: ' || plsqlresilience.EmployeeUtils.GetTotalRaisesProcessed());
END;
/
```
<h4>Exercise 1.3: Package Subprogram Overloading</h4>
    <p><strong>Solution:</strong></p>
    
```sql
-- Add to EmployeeUtils Package Specification:
/*
CREATE OR REPLACE PACKAGE plsqlresilience.EmployeeUtils AS
    defaultRaisePercentage NUMBER := 5;

    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2;

    -- Overloaded version
    FUNCTION GetEmployeeFullName (p_firstName IN plsqlresilience.Employees.firstName%TYPE,
                                p_lastName  IN plsqlresilience.Employees.lastName%TYPE)
        RETURN VARCHAR2;

    PROCEDURE UpdateEmployeeSalary (p_employeeId     IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary      IN plsqlresilience.Employees.salary%TYPE DEFAULT NULL,
                                    p_raisePercentage IN NUMBER DEFAULT NULL);

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER;
END EmployeeUtils;
/
*/

-- Add to EmployeeUtils Package Body:
/*
CREATE OR REPLACE PACKAGE BODY plsqlresilience.EmployeeUtils AS
    totalRaisesProcessed NUMBER := 0;

    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2
    IS
        v_fullName VARCHAR2(101);
    BEGIN
        SELECT firstName || ' ' || lastName
        INTO v_fullName
        FROM plsqlresilience.Employees
        WHERE employeeId = p_employeeId;
        RETURN v_fullName;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Employee ID ' || p_employeeId || ' not found';
    END GetEmployeeFullName;

    -- Overloaded version implementation
    FUNCTION GetEmployeeFullName (p_firstName IN plsqlresilience.Employees.firstName%TYPE,
                                p_lastName  IN plsqlresilience.Employees.lastName%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN p_firstName || ' ' || p_lastName;
    END GetEmployeeFullName;

    PROCEDURE UpdateEmployeeSalary (p_employeeId     IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary      IN plsqlresilience.Employees.salary%TYPE DEFAULT NULL,
                                    p_raisePercentage IN NUMBER DEFAULT NULL)
    IS
        v_calculatedSalary plsqlresilience.Employees.salary%TYPE;
        v_currentSalary    plsqlresilience.Employees.salary%TYPE;
        v_actualRaisePct   NUMBER;
    BEGIN
        SELECT salary INTO v_currentSalary FROM plsqlresilience.Employees WHERE employeeId = p_employeeId;

        IF p_newSalary IS NOT NULL THEN
            v_calculatedSalary := p_newSalary;
        ELSE
            IF p_raisePercentage IS NOT NULL THEN
                v_actualRaisePct := p_raisePercentage;
            ELSE
                v_actualRaisePct := defaultRaisePercentage;
            END IF;
            v_calculatedSalary := v_currentSalary * (1 + (v_actualRaisePct / 100));
        END IF;

        UPDATE plsqlresilience.Employees
        SET salary = v_calculatedSalary
        WHERE employeeId = p_employeeId;

        IF SQL%ROWCOUNT > 0 THEN
            totalRaisesProcessed := totalRaisesProcessed + 1;
            DBMS_OUTPUT.PUT_LINE('Salary updated for employee ID ' || p_employeeId || ' to ' || v_calculatedSalary || '.');
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employeeId || ' not found.');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employeeId || ' not found for salary update.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
            ROLLBACK;
    END UpdateEmployeeSalary;

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER IS
    BEGIN
        RETURN totalRaisesProcessed;
    END GetTotalRaisesProcessed;
BEGIN
    DBMS_OUTPUT.PUT_LINE('EmployeeUtils package initialized. Default raise: ' || defaultRaisePercentage || '%');
END EmployeeUtils;
/
*/

-- Assuming the EmployeeUtils package from Exercise 1.2 is already created,
-- we'll modify it to include the overloaded function.
-- First, re-create the specification with the new overloaded function.
CREATE OR REPLACE PACKAGE plsqlresilience.EmployeeUtils AS
    defaultRaisePercentage NUMBER := 5;

    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2;

    -- Overloaded version
    FUNCTION GetEmployeeFullName (p_firstName IN plsqlresilience.Employees.firstName%TYPE,
                                p_lastName  IN plsqlresilience.Employees.lastName%TYPE)
        RETURN VARCHAR2;

    PROCEDURE UpdateEmployeeSalary (p_employeeId     IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary      IN plsqlresilience.Employees.salary%TYPE DEFAULT NULL,
                                    p_raisePercentage IN NUMBER DEFAULT NULL);

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER;
END EmployeeUtils;
/

-- Then, re-create the body with the implementation for the overloaded function.
CREATE OR REPLACE PACKAGE BODY plsqlresilience.EmployeeUtils AS
    totalRaisesProcessed NUMBER := 0;

    FUNCTION GetEmployeeFullName (p_employeeId IN plsqlresilience.Employees.employeeId%TYPE)
        RETURN VARCHAR2
    IS
        v_fullName VARCHAR2(101);
    BEGIN
        SELECT firstName || ' ' || lastName
        INTO v_fullName
        FROM plsqlresilience.Employees
        WHERE employeeId = p_employeeId;
        RETURN v_fullName;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Employee ID ' || p_employeeId || ' not found';
    END GetEmployeeFullName;

    -- Overloaded version implementation
    FUNCTION GetEmployeeFullName (p_firstName IN plsqlresilience.Employees.firstName%TYPE,
                                p_lastName  IN plsqlresilience.Employees.lastName%TYPE)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN p_firstName || ' ' || p_lastName;
    END GetEmployeeFullName;

    PROCEDURE UpdateEmployeeSalary (p_employeeId     IN plsqlresilience.Employees.employeeId%TYPE,
                                    p_newSalary      IN plsqlresilience.Employees.salary%TYPE DEFAULT NULL,
                                    p_raisePercentage IN NUMBER DEFAULT NULL)
    IS
        v_calculatedSalary plsqlresilience.Employees.salary%TYPE;
        v_currentSalary    plsqlresilience.Employees.salary%TYPE;
        v_actualRaisePct   NUMBER;
    BEGIN
        SELECT salary INTO v_currentSalary FROM plsqlresilience.Employees WHERE employeeId = p_employeeId;

        IF p_newSalary IS NOT NULL THEN
            v_calculatedSalary := p_newSalary;
        ELSE
            IF p_raisePercentage IS NOT NULL THEN
                v_actualRaisePct := p_raisePercentage;
            ELSE
                v_actualRaisePct := defaultRaisePercentage;
            END IF;
            v_calculatedSalary := ROUND(v_currentSalary * (1 + (v_actualRaisePct / 100)), 2);
        END IF;

        UPDATE plsqlresilience.Employees
        SET salary = v_calculatedSalary
        WHERE employeeId = p_employeeId;

        IF SQL%ROWCOUNT > 0 THEN
            totalRaisesProcessed := totalRaisesProcessed + 1;
            DBMS_OUTPUT.PUT_LINE('Salary updated for employee ID ' || p_employeeId || ' to ' || v_calculatedSalary || '.');
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employeeId || ' not found for salary update or salary unchanged.');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employeeId || ' not found for salary update.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
            ROLLBACK;
    END UpdateEmployeeSalary;

    FUNCTION GetTotalRaisesProcessed RETURN NUMBER IS
    BEGIN
        RETURN totalRaisesProcessed;
    END GetTotalRaisesProcessed;
BEGIN
    DBMS_OUTPUT.PUT_LINE('EmployeeUtils package initialized. Default raise: ' || defaultRaisePercentage || '%');
END EmployeeUtils;
/

-- Anonymous block to test
DECLARE
    v_empId    plsqlresilience.Employees.employeeId%TYPE := 100;
    v_fullName1 VARCHAR2(101);
    v_fullName2 VARCHAR2(101);
BEGIN
    -- Call original version
    v_fullName1 := plsqlresilience.EmployeeUtils.GetEmployeeFullName(p_employeeId => v_empId);
    DBMS_OUTPUT.PUT_LINE('Full name (by ID '||v_empId||'): ' || v_fullName1);

    -- Call overloaded version
    v_fullName2 := plsqlresilience.EmployeeUtils.GetEmployeeFullName(p_firstName => 'Test', p_lastName => 'User');
    DBMS_OUTPUT.PUT_LINE('Full name (by names): ' || v_fullName2);
END;
/
```

<h3>(ii) Disadvantages and Pitfalls</h3>
    <h4>Exercise 2.1: Package State Invalidation</h4>
        <p><strong>Solution:</strong></p>
        
```sql
-- Package Specification
CREATE OR REPLACE PACKAGE plsqlresilience.StatefulPkg AS
    counter NUMBER := 0;
    PROCEDURE IncrementCounter;
END StatefulPkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY plsqlresilience.StatefulPkg AS
    PROCEDURE IncrementCounter IS
    BEGIN
        counter := counter + 1;
        DBMS_OUTPUT.PUT_LINE('Counter is now: ' || counter);
    END IncrementCounter;
BEGIN
    DBMS_OUTPUT.PUT_LINE('StatefulPkg initialized. Counter: ' || counter);
END StatefulPkg;
/

-- In Session 1:
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Session 1: First call');
    plsqlresilience.StatefulPkg.IncrementCounter;
    DBMS_OUTPUT.PUT_LINE('Session 1: Second call');
    plsqlresilience.StatefulPkg.IncrementCounter;
END;
/
-- Expected output in Session 1:
-- StatefulPkg initialized. Counter: 0
-- Session 1: First call
-- Counter is now: 1
-- Session 1: Second call
-- Counter is now: 2

-- In Session 2:
ALTER PACKAGE plsqlresilience.StatefulPkg COMPILE BODY;
-- Output: Package Body STATEFULPKG compiled.

-- Back in Session 1:
BEGIN
    DBMS_OUTPUT.PUT_LINE('Session 1: Third call after recompile');
    plsqlresilience.StatefulPkg.IncrementCounter;
END;
/
-- Expected output in Session 1 after recompile:
-- Session 1: Third call after recompile
-- ORA-04068: existing state of package "PLSQLRESILIENCE.STATEFULPKG" has been discarded
-- ORA-06508: PL/SQL: could not find program unit being called: "PLSQLRESILIENCE.STATEFULPKG"
-- ORA-06512: at line 3
--
-- If called again after the ORA-04068:
BEGIN
    DBMS_OUTPUT.PUT_LINE('Session 1: Fourth call');
    plsqlresilience.StatefulPkg.IncrementCounter;
END;
/
-- Expected output in Session 1 for the fourth call:
-- StatefulPkg initialized. Counter: 0  (Package re-initializes)
-- Session 1: Fourth call
-- Counter is now: 1
```
<p><strong>Explanation:</strong> When the package body of <code>StatefulPkg</code> is recompiled in Session 2, Oracle invalidates the existing state of this package in all sessions that are currently using it, including Session 1. When Session 1 attempts to call <code>IncrementCounter</code> again, it encounters ORA-04068. The package's state (the value of <code>counter</code>) is lost. If Session 1 calls a subprogram in the package *after* the ORA-04068 has been raised and handled (or if the block simply finishes and a new block starts), the package will be re-instantiated and its initialization block will run again, resetting <code>counter</code> to 0 (or its initial declared value if different from the initialization block's effect).</p>
    <div class="oracle-specific">
    <p>Refer to <code>PL/SQL Language Reference</code>, Chapter 11, "Package State" (p. 11-7): "If the body of an instantiated, stateful package is recompiled ... the next invocation of a subprogram in the package causes Oracle Database to discard the existing package state and raise the exception ORA-04068." Starting with Oracle Database 19c, Release Update 19.23, the <code>SESSION_EXIT_ON_PACKAGE_STATE_ERROR</code> initialization parameter can change this behavior to exit the session instead (p. 11-8).</p>
    </div>
<h4>Exercise 2.2: Overloading Pitfall - Ambiguity with Implicit Conversions</h4>
    <p><strong>Solution:</strong></p>
        
```sql
CREATE OR REPLACE PACKAGE plsqlresilience.OverloadDemo AS
    PROCEDURE ProcessValue(pValue IN NUMBER);
    PROCEDURE ProcessValue(pValue IN VARCHAR2);
END OverloadDemo;
/

CREATE OR REPLACE PACKAGE BODY plsqlresilience.OverloadDemo AS
    PROCEDURE ProcessValue(pValue IN NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('NUMBER version called. Value: ' || TO_CHAR(pValue));
    END ProcessValue;

    PROCEDURE ProcessValue(pValue IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('VARCHAR2 version called. Value: ' || pValue);
    END ProcessValue;
END OverloadDemo;
/

-- Test block
SET SERVEROUTPUT ON;
DECLARE
    v_date DATE := SYSDATE;
    v_num  NUMBER := 123;
    v_char VARCHAR2(10) := 'Hello';
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Testing OverloadDemo ---');
    plsqlresilience.OverloadDemo.ProcessValue(v_num);  -- Calls NUMBER version
    plsqlresilience.OverloadDemo.ProcessValue(v_char); -- Calls VARCHAR2 version

    DBMS_OUTPUT.PUT_LINE('Attempting to call with DATE:');
    -- plsqlresilience.OverloadDemo.ProcessValue(v_date);
    -- This line above would cause: PLS-00307: too many declarations of 'PROCESSVALUE' match this call

    -- Oracle can implicitly convert DATE to VARCHAR2.
    -- If only the VARCHAR2 version existed, it would be called.
    -- If only the NUMBER version existed, it would error (no implicit DATE to NUMBER).
    -- With both, it's ambiguous.
    -- To resolve, explicitly convert:
    DBMS_OUTPUT.PUT_LINE('Explicitly calling VARCHAR2 version with DATE:');
    plsqlresilience.OverloadDemo.ProcessValue(TO_CHAR(v_date, 'YYYY-MM-DD HH24:MI:SS'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;
/
```
<p><strong>Analysis:</strong> When <code>ProcessValue(v_date)</code> is called, Oracle attempts to find a matching <code>ProcessValue</code> procedure.
    Oracle allows implicit conversion from <code>DATE</code> to <code>VARCHAR2</code>. It does *not* implicitly convert <code>DATE</code> to <code>NUMBER</code> for procedure calls.
    However, if multiple overloads could potentially match after an implicit conversion (even if one conversion is "better" or more direct than another, unless one is an exact match and others require conversion), PL/SQL might consider it ambiguous. In this specific case, <code>DATE</code> can be implicitly converted to <code>VARCHAR2</code>. If there were also a version accepting <code>TIMESTAMP</code>, and <code>DATE</code> could implicitly convert to that too, it could lead to PLS-00307 "too many declarations of 'PROCESSVALUE' match this call".
    The most common pitfall occurs when actual parameters of numeric types (e.g. <code>PLS_INTEGER</code>) are passed to overloaded procedures where one formal parameter is <code>NUMBER</code> and another is, say, <code>BINARY_FLOAT</code>. PL/SQL might prefer the "closest" numeric type, but complex rules apply (see "Formal Parameters that Differ Only in Numeric Data Type" p.9-30 in Subprograms chapter).

**Resolution:** To resolve ambiguity, explicitly convert the actual parameter to the type of the desired overloaded subprogram. For the <code>DATE</code> example, if we want the <code>VARCHAR2</code> version:
    <code>plsqlresilience.OverloadDemo.ProcessValue(TO_CHAR(v_date, 'YYYY-MM-DD'));</code></p>
    <div class="oracle-specific">
    <p>As per PL/SQL Language Reference Chapter 9, page 9-32 ("Subprogram Overload Errors"), the compiler catches overload errors. If an invocation is ambiguous because the actual parameter could match multiple overloaded formal parameters through implicit conversions, PLS-00307 is raised. For numeric types, PL/SQL has a preference order (e.g., PLS_INTEGER, then NUMBER, then BINARY_FLOAT, then BINARY_DOUBLE, as per p. 9-31), but direct matches are preferred over conversions.</p>
    </div>
    <h3>(iii) Contrasting with Inefficient Common Solutions</h3>
        <h4>Exercise 3.1: Package vs. Standalone Utilities for String Operations</h4>
    <p><strong>Solution:</strong></p>
    <p><strong>Inefficient Solution (Standalone Functions):</strong></p>
        
```sql
CREATE OR REPLACE FUNCTION plsqlresilience.ReverseString_standalone (pInputString IN VARCHAR2) RETURN VARCHAR2 IS
    vReversedString VARCHAR2(4000); -- Max size for VARCHAR2 in PL/SQL
BEGIN
    IF pInputString IS NULL THEN
        RETURN NULL;
    END IF;
    FOR i IN REVERSE 1..LENGTH(pInputString) LOOP
        vReversedString := vReversedString || SUBSTR(pInputString, i, 1);
    END LOOP;
    RETURN vReversedString;
END;
/

CREATE OR REPLACE FUNCTION plsqlresilience.CountVowels_standalone (pInputString IN VARCHAR2) RETURN NUMBER IS
    vVowelCount NUMBER := 0;
    vChar CHAR(1);
BEGIN
    IF pInputString IS NULL THEN
        RETURN 0;
    END IF;
    FOR i IN 1..LENGTH(pInputString) LOOP
        vChar := UPPER(SUBSTR(pInputString, i, 1));
        IF vChar IN ('A', 'E', 'I', 'O', 'U') THEN
            vVowelCount := vVowelCount + 1;
        END IF;
    END LOOP;
    RETURN vVowelCount;
END;
/

CREATE OR REPLACE FUNCTION plsqlresilience.IsPalindrome_standalone (pInputString IN VARCHAR2) RETURN BOOLEAN IS
    vCleanedString VARCHAR2(4000);
    vReversedString VARCHAR2(4000);
BEGIN
    IF pInputString IS NULL THEN
        RETURN NULL; -- Or FALSE, depending on definition
    END IF;
    -- Simple cleaning: remove spaces and convert to upper case
    vCleanedString := UPPER(REPLACE(pInputString, ' ', ''));
    vReversedString := plsqlresilience.ReverseString_standalone(vCleanedString); -- Reuses the standalone reverse
    RETURN vCleanedString = vReversedString;
END;
/
```
<p><strong>Oracle-Idiomatic Solution (Package-Based):</strong></p>
        
```sql
-- Package Specification
CREATE OR REPLACE PACKAGE plsqlresilience.StringUtilities AS
    FUNCTION ReverseString (pInputString IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION CountVowels (pInputString IN VARCHAR2) RETURN NUMBER;
    FUNCTION IsPalindrome (pInputString IN VARCHAR2) RETURN BOOLEAN;
END StringUtilities;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY plsqlresilience.StringUtilities AS

    -- Potentially a private helper function if more complex cleaning is needed
    -- For this example, IsPalindrome will call the public ReverseString

    FUNCTION ReverseString (pInputString IN VARCHAR2) RETURN VARCHAR2 IS
        vReversedString VARCHAR2(4000);
    BEGIN
        IF pInputString IS NULL THEN
            RETURN NULL;
        END IF;
        FOR i IN REVERSE 1..LENGTH(pInputString) LOOP
            vReversedString := vReversedString || SUBSTR(pInputString, i, 1);
        END LOOP;
        RETURN vReversedString;
    END ReverseString;

    FUNCTION CountVowels (pInputString IN VARCHAR2) RETURN NUMBER IS
        vVowelCount NUMBER := 0;
        vChar CHAR(1);
    BEGIN
        IF pInputString IS NULL THEN
            RETURN 0;
        END IF;
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
        -- No need to declare vReversedString if calling the package's own ReverseString
    BEGIN
        IF pInputString IS NULL THEN
            RETURN NULL; -- Or FALSE
        END IF;
        vCleanedString := UPPER(REPLACE(pInputString, ' ', ''));
        -- Calls the public ReverseString from within the same package
        RETURN vCleanedString = ReverseString(vCleanedString);
    END IsPalindrome;

END StringUtilities;
/

-- Test the package
SET SERVEROUTPUT ON;
DECLARE
    test_str VARCHAR2(50) := 'Madam Im Adam';
    rev_str VARCHAR2(50);
    vowel_count NUMBER;
    is_pal BOOLEAN;
BEGIN
    rev_str := plsqlresilience.StringUtilities.ReverseString(test_str);
    DBMS_OUTPUT.PUT_LINE('Original: ' || test_str || ', Reversed: ' || rev_str);

    vowel_count := plsqlresilience.StringUtilities.CountVowels(test_str);
    DBMS_OUTPUT.PUT_LINE('Vowels in "' || test_str || '": ' || vowel_count);

    is_pal := plsqlresilience.StringUtilities.IsPalindrome(test_str);
    IF is_pal THEN
        DBMS_OUTPUT.PUT_LINE('"' || test_str || '" is a palindrome.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('"' || test_str || '" is NOT a palindrome.');
    END IF;

    test_str := 'Oracle';
    is_pal := plsqlresilience.StringUtilities.IsPalindrome(test_str);
    IF is_pal THEN
        DBMS_OUTPUT.PUT_LINE('"' || test_str || '" is a palindrome.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('"' || test_str || '" is NOT a palindrome.');
    END IF;
END;
/
```
<p><strong>Discussion of Advantages of Package Solution:</strong></p>
    <ol>
        <li><strong>Organization & Modularity:</strong> All related string utilities are grouped under a single, named package (<code>StringUtilities</code>). This makes the codebase cleaner and easier to navigate. (PL/SQL Ref, Ch 11, "Reasons to Use Packages" p. 11-2: Modularity).</li>
        <li><strong>Maintainability:</strong> Changes or additions to string utilities are made within the package context. If a private helper function was used (e.g., for advanced string cleaning shared by multiple public functions), it could be modified without affecting the public interface. (PL/SQL Ref, Ch 11, "Hidden Implementation Details" p. 11-2).</li>
        <li><strong>Deployment & Dependency Management:</strong> Deploying the <code>StringUtilities</code> package deploys all its functionalities. Oracle manages dependencies at the package level, potentially reducing recompilation cascades compared to dependencies on multiple individual functions. (PL/SQL Ref, Ch 11, "Better Performance" p. 11-3, related to preventing cascading dependencies).</li>
        <li><strong>Encapsulation & Information Hiding:</strong> The package body can contain private variables and subprograms not exposed to the outside world. For instance, a more complex <code>NormalizeString</code> private function could be used by <code>IsPalindrome</code> and potentially other future string functions, without cluttering the public API. (PL/SQL Ref, Ch 11, "What is a Package?" p. 11-1, discussion of private items).</li>
        <li><strong>Performance:</strong> The first time any subprogram in a package is called, the entire package is loaded into memory. Subsequent calls to any subprogram in that same package (within the same session) do not require further disk I/O for loading the code. (PL/SQL Ref, Ch 11, "Better Performance" p. 11-3).</li>
        <li><strong>Security & Privileges:</strong> Privileges can be granted on the package as a whole, rather than on each individual function. (PL/SQL Ref, Ch 11, "Easier to Grant Roles" p. 11-3).</li>
    </ol>
    <hr>
<h2>Category: Exception Handling: Predefined exceptions, user-defined exceptions, SQLCODE, SQLERRM, PRAGMA EXCEPTION_INIT</h2>
    <h3>(i) Meanings, Values, Relations, and Advantages</h3>
<h4>Exercise 1.4: Handling Predefined Exceptions</h4>
<p><strong>Solution:</strong></p>
        
```sql
SET SERVEROUTPUT ON;
DECLARE
    v_salary plsqlresilience.Employees.salary%TYPE;
    v_nonExistentEmpId plsqlresilience.Employees.employeeId%TYPE := 9999;
    v_num NUMBER := 10;
    v_divisor NUMBER := 0;
    v_result NUMBER;
BEGIN
    -- Attempt 1: Select for non-existent employee
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Attempting to select salary for employee ID ' || v_nonExistentEmpId);
        SELECT salary
        INTO v_salary
        FROM plsqlresilience.Employees
        WHERE employeeId = v_nonExistentEmpId;
        DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary); -- This line won't be reached
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Handler: Employee with ID ' || v_nonExistentEmpId || ' not found.');
    END;

    DBMS_OUTPUT.PUT_LINE('---'); -- Separator

    -- Attempt 2: Divide by zero
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Attempting to divide ' || v_num || ' by ' || v_divisor);
        v_result := v_num / v_divisor;
        DBMS_OUTPUT.PUT_LINE('Result: ' || v_result); -- This line won't be reached
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Handler: Cannot divide by zero.');
    END;
END;
/
```

<h4>Exercise 1.5: User-Defined Exceptions and PRAGMA EXCEPTION_INIT</h4>
<p><strong>Solution:</strong></p>

```sql
SET SERVEROUTPUT ON;
DECLARE
    NegativeSalaryException EXCEPTION;
    PRAGMA EXCEPTION_INIT(NegativeSalaryException, -20002);

    v_empId plsqlresilience.Employees.employeeId%TYPE := 100; -- Assuming employee 100 exists
    v_attemptedSalary1 plsqlresilience.Employees.salary%TYPE := -500;
    v_attemptedSalary2 plsqlresilience.Employees.salary%TYPE := -600;
BEGIN
    -- Part 1: Raise user-defined exception directly
    DBMS_OUTPUT.PUT_LINE('Attempting to update salary for employee ' || v_empId || ' to ' || v_attemptedSalary1 || ' using custom RAISE.');
    BEGIN
        IF v_attemptedSalary1 < 0 THEN
            RAISE NegativeSalaryException; -- Explicitly raise the custom exception
        END IF;
        -- UPDATE plsqlresilience.Employees SET salary = v_attemptedSalary1 WHERE employeeId = v_empId;
        -- DBMS_OUTPUT.PUT_LINE('Salary updated (this should not happen for negative salary).');
    EXCEPTION
        WHEN NegativeSalaryException THEN
            DBMS_OUTPUT.PUT_LINE('Handler: Error - Salary cannot be negative (caught direct raise).');
    END;

    DBMS_OUTPUT.PUT_LINE('---');

    -- Part 2: Raise using RAISE_APPLICATION_ERROR and catch with PRAGMA EXCEPTION_INIT
    DBMS_OUTPUT.PUT_LINE('Attempting to update salary for employee ' || v_empId || ' to ' || v_attemptedSalary2 || ' using RAISE_APPLICATION_ERROR.');
    BEGIN
        IF v_attemptedSalary2 < 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative from RAISE_APPLICATION_ERROR.');
        END IF;
        -- UPDATE plsqlresilience.Employees SET salary = v_attemptedSalary2 WHERE employeeId = v_empId;
        -- DBMS_OUTPUT.PUT_LINE('Salary updated (this should not happen for negative salary).');
    EXCEPTION
        WHEN NegativeSalaryException THEN -- This handler will catch the error associated via PRAGMA
            DBMS_OUTPUT.PUT_LINE('Handler: Error - Salary cannot be negative (caught RAISE_APPLICATION_ERROR via PRAGMA).');
            DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some other error occurred: ' || SQLERRM);
    END;
END;
/
```
<div class="oracle-specific">
    <p>Reference: "User-Defined Exceptions" (PL/SQL Ref, Ch 12, p. 12-13) shows declaring an exception. "EXCEPTION_INIT Pragma" (PL/SQL Ref, Ch 14, p. 14-74) details associating an exception name with an Oracle error number. "RAISE_APPLICATION_ERROR Procedure" (PL/SQL Ref, Ch 12, p. 12-18) is used to issue user-defined error messages from stored subprograms.</p>
</div>
<h4>Exercise 1.6: Using SQLCODE and SQLERRM</h4>
<p><strong>Solution:</strong></p>
    
```sql
SET SERVEROUTPUT ON;
DECLARE
    v_longString VARCHAR2(20) := 'This string is too long'; -- Longer than 10
    v_deptId plsqlresilience.Departments.departmentId%TYPE := plsqlresilience.DepartmentSeq.NEXTVAL;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Attempting to insert a string longer than column definition...');
    INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity)
    VALUES (v_deptId, 'Test Department', v_longString); -- locationCity is VARCHAR2(100) in dataset, so this is fine.
                                                    -- Let's try inserting into employee email with a long string
                                                    -- to trigger ORA-12899 value too large for column
    INSERT INTO plsqlresilience.Employees (employeeId, lastName, email)
    VALUES (plsqlresilience.EmployeeSeq.NEXTVAL, 'TestLastName', 'this_email_is_definitely_much_longer_than_one_hundred_characters_and_should_cause_an_error@example.com');

    DBMS_OUTPUT.PUT_LINE('Insert successful (this should not happen).');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An OTHERS exception occurred:');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/
-- Expected Output (will vary based on exact constraint violated, but for ORA-12899):
-- Attempting to insert a string longer than column definition...
-- An OTHERS exception occurred:
-- SQLCODE: -12899
-- SQLERRM: ORA-12899: value too large for column "PLSQLRESILIENCE"."EMPLOYEES"."EMAIL" (actual: 108, maximum: 100)
```
<div class="oracle-specific">
        <p><code>SQLCODE</code> returns the numeric error code and <code>SQLERRM</code> returns the associated error message. This is particularly useful in a <code>WHEN OTHERS</code> handler to identify unexpected errors. (PL/SQL Ref, Ch 12, p. 12-27, "Retrieving Error Code and Error Message").</p>
    </div>
    <h3>(ii) Disadvantages and Pitfalls</h3>
<h4>Exercise 2.3: Overly Broad WHEN OTHERS Handler</h4>
    <p><strong>Solution:</strong></p>
    
```sql
CREATE OR REPLACE PROCEDURE plsqlresilience.ProcessEmployeeData(pEmployeeId IN plsqlresilience.Employees.employeeId%TYPE) IS
    v_old_salary plsqlresilience.Employees.salary%TYPE;
    v_new_salary plsqlresilience.Employees.salary%TYPE;
BEGIN
    -- Get old salary for audit
    SELECT salary INTO v_old_salary FROM plsqlresilience.Employees WHERE employeeId = pEmployeeId;
    v_new_salary := v_old_salary * 1.10;

    -- 1. Update salary
    UPDATE plsqlresilience.Employees
    SET salary = v_new_salary
    WHERE employeeId = pEmployeeId;
    DBMS_OUTPUT.PUT_LINE('Salary updated for employee ' || pEmployeeId);

    -- 2. Insert into AuditLog
    INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, oldValue, newValue)
    VALUES ('Employees', 'SAL_UPDATE', TO_CHAR(pEmployeeId), TO_CHAR(v_old_salary), TO_CHAR(v_new_salary));
    DBMS_OUTPUT.PUT_LINE('Audit log entry created for employee ' || pEmployeeId);

    -- 3. Attempt to update Departments table (e.g., with a non-existent column or constraint violation)
    -- Forcing an error: departmentId 999 likely does not exist.
    UPDATE plsqlresilience.Departments
    SET departmentName = departmentName || ' - Verified'
    WHERE departmentId = (SELECT departmentId FROM plsqlresilience.Employees WHERE employeeId = pEmployeeId) + 999; --This will fail silently or throw an error swallowed by WHEN OTHERS

    -- Or try to update a non-existent column:
    -- UPDATE plsqlresilience.Departments
    -- SET NonExistentColumn = 'Test'
    -- WHERE departmentId = (SELECT departmentId FROM plsqlresilience.Employees WHERE employeeId = pEmployeeId);

    DBMS_OUTPUT.PUT_LINE('Department update attempted for employee ' || pEmployeeId);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unspecified error occurred in ProcessEmployeeData for employee ' || pEmployeeId || '. SQLCODE: ' || SQLCODE);
        -- The original problem specified just logging and exiting.
        -- In a real scenario, you might rollback, but the exercise focuses on the pitfall of *not* re-raising.
        -- ROLLBACK; -- Good practice, but not part of the pitfall demonstration itself
END ProcessEmployeeData;
/

-- Test
SET SERVEROUTPUT ON;
BEGIN
    -- Create a department and employee that will cause the department update to fail
    -- if we try to update a department that doesn't exist for the audit part.
    -- Let's assume employee 100 exists in department 1.
    -- The department update will try to update department 1 + 999, which should fail.
    plsqlresilience.ProcessEmployeeData(100);
END;
/
```
<p><strong>Discussion of Disadvantages:</strong></p>
    <ol>
        <li><strong>Masks the Real Error:</strong> The generic message "An unspecified error occurred" provides no clue about what actually went wrong (e.g., was it the salary update, the audit log insert, or the department update?). The original error (SQLCODE, SQLERRM, and stack trace) is lost.</li>
        <li><strong>Debugging Nightmare:</strong> Without knowing the specific error, debugging becomes incredibly difficult. Developers have to guess or add extensive logging to pinpoint the failure.</li>
        <li><strong>Incorrect Program Flow:</strong> The procedure exits as if it completed normally (or at least handled the error gracefully), but critical operations might have failed silently. The caller might assume success when partial failure occurred.</li>
        <li><strong>Data Inconsistency:</strong> If the <code>COMMIT</code> happens before the error or the error occurs mid-transaction and there's no <code>ROLLBACK</code> in the <code>WHEN OTHERS</code>, partial changes might be committed, leading to inconsistent data. (Although in this specific example, the implicit commit from DDL or an explicit commit after successful operations would be problematic if an error in step 3 occurred).</li>
        <li><strong>Violation of Best Practices:</strong> Generally, <code>WHEN OTHERS</code> should be used sparingly, primarily for top-level error logging and then re-raising the exception (<code>RAISE;</code> or <code>RAISE_APPLICATION_ERROR</code>) or logging detailed error information (SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_STACK).</li>
    </ol>
    <div class="oracle-specific">
        <p>The PL/SQL Reference (Chapter 12, page 12-27, "Unhandled Exceptions") emphasizes that if an exception is not handled, it propagates. A <code>WHEN OTHERS THEN NULL;</code> or just logging without re-raising effectively stops this propagation, hiding the problem. Page 12-9 recommends that the last statement in an OTHERS handler be either RAISE or an invocation of RAISE_APPLICATION_ERROR, or a subroutine marked with SUPPRESSES_WARNING_6009 if PLW-06009 is enabled and an issue.</p>
    </div>
<h4>Exercise 2.4: Exception Propagation and Scope</h4>
    <p><strong>Solution:</strong></p>
    
```sql
SET SERVEROUTPUT ON;
-- Scenario 1: InnerException handled, OuterException raised by inner and handled by outer
DECLARE
    OuterException EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Outer block started.');
    DECLARE
        InnerException EXCEPTION;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(' Inner block started.');
        BEGIN
            DBMS_OUTPUT.PUT_LINE('  Innermost try block started.');
            RAISE InnerException;
        EXCEPTION
            WHEN InnerException THEN
                DBMS_OUTPUT.PUT_LINE('  InnerException caught and handled by inner block.');
        END;

        DBMS_OUTPUT.PUT_LINE(' Inner block: Raising OuterException...');
        RAISE OuterException; -- This will propagate to the outer block
        DBMS_OUTPUT.PUT_LINE(' Inner block: This line will not be reached.');
    EXCEPTION
        WHEN OTHERS THEN -- This would catch OuterException if not handled by a specific handler above.
            DBMS_OUTPUT.PUT_LINE(' Inner block OTHERS: Should not happen if OuterException is specifically handled by outer.');
    END;
    DBMS_OUTPUT.PUT_LINE('Outer block: This line will not be reached if OuterException was raised.');
EXCEPTION
    WHEN OuterException THEN
        DBMS_OUTPUT.PUT_LINE('OuterException caught and handled by outer block.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Outer block OTHERS: Some other unhandled exception.');
END;
/

DBMS_OUTPUT.PUT_LINE('--- Scenario 2 ---');

-- Scenario 2: InnerException NOT handled by inner, propagates out
DECLARE
    OuterException EXCEPTION; -- Not used in this specific scenario path but good for context
BEGIN
    DBMS_OUTPUT.PUT_LINE('Outer block started.');
    DECLARE
        InnerException EXCEPTION;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(' Inner block started.');
        DBMS_OUTPUT.PUT_LINE(' Inner block: Raising InnerException (will not be handled here)...');
        RAISE InnerException;
        DBMS_OUTPUT.PUT_LINE(' Inner block: This line will not be reached.');
    -- No handler for InnerException in this inner block
    END;
    DBMS_OUTPUT.PUT_LINE('Outer block: This line will not be reached if InnerException propagated.');
EXCEPTION
    WHEN OTHERS THEN -- This will catch InnerException as it's not OuterException
        DBMS_OUTPUT.PUT_LINE('Outer block OTHERS: Unhandled exception from inner block caught. SQLCODE: ' || SQLCODE || ' SQLERRM: ' || SQLERRM);
        IF SQLCODE = -6510 THEN -- PL/SQL: unhandled user-defined exception has code -06510 before ORA- prefix
            DBMS_OUTPUT.PUT_LINE(' (This is likely the propagated InnerException which is a user-defined exception)');
        END IF;
END;
/
```
<p><strong>Explanation:</strong></p>
    <ul>
        <li><strong>Scenario 1:</strong>
            <ol>
                <li><code>InnerException</code> is raised in the innermost block.</li>
                <li>The inner block's <code>EXCEPTION WHEN InnerException</code> handler catches it.</li>
                <li>The inner block then explicitly raises <code>OuterException</code>.</li>
                <li>Control transfers to the outer block's exception-handling section.</li>
                <li>The outer block's <code>EXCEPTION WHEN OuterException</code> handler catches it.</li>
            </ol>
        </li>
        <li><strong>Scenario 2:</strong>
            <ol>
                <li><code>InnerException</code> is raised in the inner block.</li>
                <li>The inner block has no handler for <code>InnerException</code>.</li>
                <li>The exception propagates out of the inner block to its enclosing block (the outer block).</li>
                <li>The outer block's <code>WHEN OTHERS</code> handler catches <code>InnerException</code> (since it's not <code>OuterException</code>). User-defined exceptions, when unhandled and propagated, typically result in ORA-06510.</li>
            </ol>
        </li>
    </ul>
    <p>This demonstrates that if an exception is not handled in the current block, it propagates to the immediate enclosing block. The scope of an exception declared in an inner block is limited to that block; once propagated out, it can only be caught by <code>WHEN OTHERS</code> unless it was associated with an error number using <code>PRAGMA EXCEPTION_INIT</code> and the outer block handles that specific error number or a named exception linked to it. (PL/SQL Ref, Ch 12, p. 12-19, "Exception Propagation").</p>
    <h3>(iii) Contrasting with Inefficient Common Solutions</h3>
<h4>Exercise 3.2: Manual Error Checking vs. Exception Handling</h4>
    <p><strong>Solution:</strong></p>
    <p><strong>Inefficient Common Solution (Manual Checking):</strong></p>
    
```sql
CREATE OR REPLACE FUNCTION plsqlresilience.GetEmployeeSalary_Manual (
    p_employeeId IN plsqlresilience.Employees.employeeId%TYPE
) RETURN NUMBER IS
    v_salary plsqlresilience.Employees.salary%TYPE;
    v_count NUMBER;
    v_error_indicator NUMBER := -1; -- Special value for multiple rows
BEGIN
    -- Check for existence and uniqueness
    SELECT COUNT(*)
    INTO v_count
    FROM plsqlresilience.Employees
    WHERE employeeId = p_employeeId;

    IF v_count = 0 THEN
        RETURN NULL; -- Employee does not exist
    ELSIF v_count = 1 THEN
        -- Fetch the salary
        SELECT salary
        INTO v_salary
        FROM plsqlresilience.Employees
        WHERE employeeId = p_employeeId;
        RETURN v_salary;
    ELSE -- v_count > 1 (should not happen with primary key, but for demonstration)
        RETURN v_error_indicator; -- Multiple employees found
    END IF;
END GetEmployeeSalary_Manual;
/
```

<p><strong>Oracle-Idiomatic Solution (Exception Handling):</strong></p>
    
```sql
CREATE OR REPLACE FUNCTION plsqlresilience.GetEmployeeSalary_Exceptions (
    p_employeeId IN plsqlresilience.Employees.employeeId%TYPE
) RETURN NUMBER IS
    v_salary plsqlresilience.Employees.salary%TYPE;
    v_error_indicator NUMBER := -1; -- For TOO_MANY_ROWS
BEGIN
    SELECT salary
    INTO v_salary
    FROM plsqlresilience.Employees
    WHERE employeeId = p_employeeId;
    RETURN v_salary;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- Employee does not exist
    WHEN TOO_MANY_ROWS THEN
        RETURN v_error_indicator; -- Multiple employees found
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error in GetEmployeeSalary_Exceptions: ' || SQLERRM);
        RETURN NULL; -- Or re-raise, or return a specific error code
END GetEmployeeSalary_Exceptions;
/

-- Test blocks
SET SERVEROUTPUT ON;
DECLARE
    sal_manual NUMBER;
    sal_except NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Testing Manual Check ---');
    sal_manual := plsqlresilience.GetEmployeeSalary_Manual(100); -- Exists
    DBMS_OUTPUT.PUT_LINE('Salary for 100 (Manual): ' || NVL(TO_CHAR(sal_manual), 'NULL'));
    sal_manual := plsqlresilience.GetEmployeeSalary_Manual(999); -- Non-existent
    DBMS_OUTPUT.PUT_LINE('Salary for 999 (Manual): ' || NVL(TO_CHAR(sal_manual), 'NULL'));

    DBMS_OUTPUT.PUT_LINE('--- Testing Exception Handling ---');
    sal_except := plsqlresilience.GetEmployeeSalary_Exceptions(100); -- Exists
    DBMS_OUTPUT.PUT_LINE('Salary for 100 (Except): ' || NVL(TO_CHAR(sal_except), 'NULL'));
    sal_except := plsqlresilience.GetEmployeeSalary_Exceptions(999); -- Non-existent
    DBMS_OUTPUT.PUT_LINE('Salary for 999 (Except): ' || NVL(TO_CHAR(sal_except), 'NULL'));

    -- To test TOO_MANY_ROWS, you'd need a table where employeeId is not unique
    -- or a query that could return multiple rows for the INTO clause.
    -- For example (hypothetical, as employeeId is PK):
    -- INSERT INTO plsqlresilience.Employees (employeeId, lastName, salary) VALUES (777, 'Dup1', 500);
    -- INSERT INTO plsqlresilience.Employees (employeeId, lastName, salary) VALUES (777, 'Dup2', 600);
    -- COMMIT;
    -- sal_except := plsqlresilience.GetEmployeeSalary_Exceptions(777);
    -- DBMS_OUTPUT.PUT_LINE('Salary for 777 (Except): ' || NVL(TO_CHAR(sal_except), 'NULL'));
END;
/
```

<p><strong>Discussion:</strong></p>
    <ul>
        <li><strong>Verbosity:</strong> The manual checking approach is more verbose. It requires an initial <code>COUNT(*)</code> query and then conditional logic to perform the actual data retrieval. The exception handling version is more concise.</li>
        <li><strong>Performance:</strong> The manual approach executes at least two SQL statements (<code>COUNT(*)</code> then potentially <code>SELECT salary</code>) to get the salary or determine non-existence. The exception handling approach executes only one <code>SELECT salary</code>. If the data is found, it's more efficient. The overhead of raising and catching an exception is generally acceptable, especially compared to an extra database query. (PL/SQL Ref, Ch 12, "Advantages of Exception Handlers" p. 12-7).</li>
        <li><strong>Clarity and Intent:</strong> The exception handling approach clearly separates the main logic (fetching the salary) from the error/special case handling. The intent is "try to get the salary; if it's not there, do X; if too many are there, do Y." The manual approach intermingles existence checks with data retrieval.</li>
        <li><strong>Atomicity:</strong> While not a major factor here, in more complex DML, exception handlers ensure that error conditions are dealt with immediately after the DML statement that might cause them, allowing for cleaner transaction control.</li>
    </ul>
    <hr>
    <h2>Category: Triggers: DML triggers, :NEW and :OLD qualifiers, conditional predicates</h2>
    <h3>(i) Meanings, Values, Relations, and Advantages</h3>
<h4>Exercise 1.7: Basic AFTER INSERT Trigger</h4>
    <p><strong>Solution:</strong></p>
    
```sql
CREATE OR REPLACE TRIGGER plsqlresilience.trgLogNewOrder
AFTER INSERT ON plsqlresilience.Orders
FOR EACH ROW
BEGIN
    INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, newValue)
    VALUES ('Orders', 'INSERT', TO_CHAR(:NEW.orderId),
            'Order ID: ' || :NEW.orderId ||
            ', Cust ID: ' || :NEW.customerId ||
            ', Date: ' || TO_CHAR(:NEW.orderDate, 'YYYY-MM-DD') ||
            ', Status: ' || :NEW.status);
END trgLogNewOrder;
/
-- Test the trigger
SET SERVEROUTPUT ON;
DECLARE
v_new_order_id plsqlresilience.Orders.orderId%TYPE;
BEGIN
    INSERT INTO plsqlresilience.Orders (orderId, customerId, status)
    VALUES (plsqlresilience.OrderSeq.NEXTVAL, 123, 'Pending')
    RETURNING orderId INTO v_new_order_id;

    DBMS_OUTPUT.PUT_LINE('New order inserted with ID: ' || v_new_order_id);
    COMMIT;

    -- Verify AuditLog (optional, query separately)
    -- SELECT * FROM plsqlresilience.AuditLog WHERE recordId = TO_CHAR(v_new_order_id) AND tableName = 'Orders';
END;
/
```

<div class="oracle-specific">
        <p>This uses an <code>AFTER INSERT</code> trigger, which fires after the DML operation completes for each affected row. <code>:NEW.orderId</code> refers to the value of the <code>orderId</code> column for the newly inserted row. (PL/SQL Ref, Ch 10, p. 10-4 "DML Triggers", p. 10-28 "Correlation Names and Pseudorecords").</p>
    </div>
<h4>Exercise 1.8: BEFORE UPDATE Trigger with :OLD and :NEW</h4>
    <p><strong>Solution:</strong></p>
    
```sql
CREATE OR REPLACE TRIGGER plsqlresilience.trgPreventSalaryDecrease
BEFORE UPDATE OF salary ON plsqlresilience.Employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20003, 'Salary decrease not allowed for employee ID ' || :OLD.employeeId ||
                                    '. Old Salary: ' || :OLD.salary || ', Attempted New Salary: ' || :NEW.salary);
    END IF;
END trgPreventSalaryDecrease;
/

-- Test the trigger
SET SERVEROUTPUT ON;
DECLARE
    v_empId plsqlresilience.Employees.employeeId%TYPE := 100; -- Assuming employee 100 exists
    v_current_salary plsqlresilience.Employees.salary%TYPE;
BEGIN
    SELECT salary INTO v_current_salary FROM plsqlresilience.Employees WHERE employeeId = v_empId;
    DBMS_OUTPUT.PUT_LINE('Current salary for employee ' || v_empId || ': ' || v_current_salary);

    -- Attempt to decrease salary (should fail)
    BEGIN
        UPDATE plsqlresilience.Employees
        SET salary = v_current_salary - 5000
        WHERE employeeId = v_empId;
        DBMS_OUTPUT.PUT_LINE('Salary decreased (this should not happen).');
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error caught: ' || SQLERRM);
            ROLLBACK;
    END;

    -- Attempt to increase salary (should succeed)
    BEGIN
        UPDATE plsqlresilience.Employees
        SET salary = v_current_salary + 5000
        WHERE employeeId = v_empId;
        DBMS_OUTPUT.PUT_LINE('Salary increased successfully for employee ' || v_empId || '.');
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error during salary increase: ' || SQLERRM);
            ROLLBACK;
    END;

    SELECT salary INTO v_current_salary FROM plsqlresilience.Employees WHERE employeeId = v_empId;
    DBMS_OUTPUT.PUT_LINE('Final salary for employee ' || v_empId || ': ' || v_current_salary);
END;
/
```
<div class="oracle-specific">
        <p>A <code>BEFORE UPDATE</code> trigger fires before the DML operation. <code>:OLD.salary</code> holds the salary value before the update, and <code>:NEW.salary</code> holds the proposed new value. <code>RAISE_APPLICATION_ERROR</code> stops the DML and returns a custom error. (Get Started with Oracle DB Dev, Ch 6, p. 6-3 "About OLD and NEW Pseudorecords").</p>
    </div>

<h4>Exercise 1.9: Trigger with Conditional Predicates</h4>
    <p><strong>Solution:</strong></p>
    
```sql
CREATE OR REPLACE TRIGGER plsqlresilience.trgLogSignificantPriceChange
AFTER UPDATE OF unitPrice ON plsqlresilience.Products -- More specific than just AFTER UPDATE
FOR EACH ROW
-- WHEN (ABS(:NEW.unitPrice - :OLD.unitPrice) / :OLD.unitPrice > 0.20) -- Can use WHEN clause for simple conditions
-- For more complex logic including the UPDATING predicate, it's often done in the body.
DECLARE
    v_price_change_percent NUMBER;
BEGIN
    -- The UPDATING predicate is best used for compound triggers or when multiple columns could be updated.
    -- For a single column trigger like this "OF unitPrice", UPDATING('unitPrice') is implicitly true if the trigger fires.
    -- However, to demonstrate its use if the trigger was more general (e.g. AFTER UPDATE ON Products):
    -- IF UPDATING('unitPrice') THEN
        IF :OLD.unitPrice IS NOT NULL AND :OLD.unitPrice != 0 THEN -- Avoid division by zero
            v_price_change_percent := ABS(:NEW.unitPrice - :OLD.unitPrice) / :OLD.unitPrice;
            IF v_price_change_percent > 0.20 THEN
                INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, oldValue, newValue)
                VALUES ('Products',
                        'PRICE_ADJUST',
                        TO_CHAR(:NEW.productId),
                        'OldPrice:' || :OLD.unitPrice,
                        'NewPrice:' || :NEW.unitPrice || ', Change:' || ROUND(v_price_change_percent*100,2) || '%');
            END IF;
        ELSIF :OLD.unitPrice IS NULL AND :NEW.unitPrice IS NOT NULL THEN -- Case where old price was NULL
            INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, oldValue, newValue)
                VALUES ('Products',
                        'PRICE_INIT', -- Or consider it a significant change
                        TO_CHAR(:NEW.productId),
                        'OldPrice: NULL',
                        'NewPrice:' || :NEW.unitPrice);
        END IF;
    -- END IF; -- Corresponds to IF UPDATING('unitPrice')
END trgLogSignificantPriceChange;
/

-- Test the trigger
SET SERVEROUTPUT ON;
DECLARE
    v_productId_laptop plsqlresilience.Products.productId%TYPE := 1000; -- Laptop Pro
    v_productId_mouse  plsqlresilience.Products.productId%TYPE := 1001; -- Wireless Mouse
BEGIN
    -- Test 1: Price change > 20% (e.g., Laptop Pro from 1200 to 1500 is 25% increase)
    DBMS_OUTPUT.PUT_LINE('Test 1: Updating Laptop Pro price significantly.');
    UPDATE plsqlresilience.Products SET unitPrice = 1500 WHERE productId = v_productId_laptop;
    COMMIT;

    -- Test 2: Price change < 20% (e.g., Wireless Mouse from 25 to 26 is 4% increase)
    DBMS_OUTPUT.PUT_LINE('Test 2: Updating Wireless Mouse price insignificantly.');
    UPDATE plsqlresilience.Products SET unitPrice = 26 WHERE productId = v_productId_mouse;
    COMMIT;

    -- Test 3: Price change > 20% decrease (e.g., Laptop Pro from 1500 to 1100 is >20% decrease)
    DBMS_OUTPUT.PUT_LINE('Test 3: Updating Laptop Pro price significantly (decrease).');
    UPDATE plsqlresilience.Products SET unitPrice = 1100 WHERE productId = v_productId_laptop;
    COMMIT;

    -- Verify AuditLog (optional, query separately)
    -- SELECT * FROM plsqlresilience.AuditLog WHERE tableName = 'Products' ORDER BY changeTimestamp DESC;
END;
/
```
<div class="oracle-specific">
        <p>The <code>UPDATING('columnName')</code> predicate returns TRUE if the specified column is being updated. This is useful in triggers defined for multiple DML operations (INSERT, UPDATE, DELETE) or for updates on multiple columns, to execute specific logic only when a particular column is affected. (PL/SQL Ref, Ch 10, p. 10-5, Table 10-1 Conditional Predicates).</p>
        <p>Note: For a trigger defined with <code>UPDATE OF unitPrice</code>, the <code>UPDATING('unitPrice')</code> check within the body is somewhat redundant because the trigger only fires if <code>unitPrice</code> is in the <code>SET</code> clause of the <code>UPDATE</code> statement. It would be more impactful in a general <code>AFTER UPDATE ON Products</code> trigger.</p>
    </div>
    <h3>(ii) Disadvantages and Pitfalls</h3>
<h4>Exercise 2.5: Mutating Table Error (ORA-04091)</h4>
    <p><strong>Solution:</strong></p>
    <p>The provided trigger code will indeed cause an ORA-04091 error.</p>

```sql
CREATE OR REPLACE TRIGGER plsqlresilience.trgCheckMaxSalary
BEFORE UPDATE OF salary ON plsqlresilience.Employees
FOR EACH ROW
DECLARE
vAvgDeptSalary NUMBER;
BEGIN
-- This SELECT statement on plsqlresilience.Employees table,
-- which is the same table the trigger is defined on,
-- will cause a mutating table error (ORA-04091).
SELECT AVG(salary) INTO vAvgDeptSalary
FROM plsqlresilience.Employees
WHERE departmentId = :NEW.departmentId; -- or :OLD.departmentId if department is not changing

IF :NEW.salary > (vAvgDeptSalary * 1.5) THEN
    RAISE_APPLICATION_ERROR(-20004, 'Salary exceeds 1.5x department average.');
END IF;
END;
/

-- Test that causes the error:
SET SERVEROUTPUT ON;
BEGIN
    UPDATE plsqlresilience.Employees
    SET salary = salary * 1.1 -- Attempt a 10% raise
    WHERE employeeId = 100;   -- Assuming employee 100 exists
    DBMS_OUTPUT.PUT_LINE('Update successful? Should not be.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;
/
-- Expected Output:
-- Error: -4091 - ORA-04091: table PLSQLRESILIENCE.EMPLOYEES is mutating, trigger/function may not see it
```
<p><strong>Why the error occurs (ORA-04091):</strong></p>
    <p>A row-level trigger (<code>FOR EACH ROW</code>) on a table (<code>Employees</code>) cannot query or modify the same table (<code>Employees</code>). This is because the table is in a state of flux ("mutating") while the trigger is executing for each row. Oracle prevents this to ensure data consistency and avoid potential infinite loops or unpredictable results that could arise if a trigger's action on a row caused the trigger to fire again for the same or other rows in a way that's hard to resolve.</p>
    <p><strong>How Compound Triggers can help:</strong></p>
    <p>Compound triggers allow you to define different sections of code that fire at different timing points (BEFORE STATEMENT, BEFORE EACH ROW, AFTER EACH ROW, AFTER STATEMENT) all within a single trigger unit. They also allow for the declaration of state (variables) that is maintained across these timing points for the duration of the DML statement.</p>
    <p>To solve the mutating table issue for the average salary check, a compound trigger could:</p>
    <ol>
        <li><strong>BEFORE STATEMENT:</strong> Query the <code>Employees</code> table to calculate and store the average salaries for all relevant departments in package variables or collections defined within the compound trigger's declarative section. At this point, the table is not mutating.</li>
        <li><strong>BEFORE EACH ROW:</strong> Access the pre-calculated average salary for the current row's department (<code>:NEW.departmentId</code>) from the stored state and perform the validation (<code>:NEW.salary > (vAvgDeptSalary * 1.5)</code>).</li>
    </ol>
    <p>This approach avoids querying the <code>Employees</code> table during the row-level execution phase when it's mutating. (PL/SQL Ref, Ch 10, p. 10-42 "Mutating-Table Restriction", and p. 10-15 "Using Compound DML Triggers to Avoid Mutating-Table Error").</p>

<h4>Exercise 2.6: Trigger Firing Order and Cascading Effects</h4>
    <p><strong>Solution:</strong></p>
    
```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER plsqlresilience.trgDeptUpdate
AFTER UPDATE ON plsqlresilience.Departments
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('trgDeptUpdate: Department ' || :OLD.departmentId || ' updated. Old Name: ' || :OLD.departmentName || ', New Name: ' || :NEW.departmentName);
END;
/

CREATE OR REPLACE TRIGGER plsqlresilience.trgEmpDeptFkUpdate
AFTER UPDATE OF departmentId ON plsqlresilience.Employees
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('trgEmpDeptFkUpdate: Employee ' || :OLD.employeeId || ' departmentId changed from ' || :OLD.departmentId || ' to ' || :NEW.departmentId);
END;
/

-- Test: Update a departmentId in Departments.
-- First, ensure there are employees in department 1 to see the cascade IF it were active.
-- Assuming employee 100 and 101 are in departmentId 1.
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Simulating Department ID Update ---');
    -- Let's change departmentId 1 to 10 in the Departments table.
    -- We'll simulate the cascade manually for now by also updating employees.

    -- Step 1: Update the Departments table
    UPDATE plsqlresilience.Departments
    SET departmentName = departmentName || ' (Updated)', locationCity = 'New Location'
    WHERE departmentId = 1;
    -- This fires trgDeptUpdate.

    -- Step 2: Manually "cascade" the update to Employees table for demonstration of trgEmpDeptFkUpdate
    -- IF an ON UPDATE CASCADE FK existed, this would happen automatically due to the previous UPDATE.
    -- Without it, we do it manually to show the employee trigger firing.
    IF SQL%FOUND THEN -- Only if department update happened
        UPDATE plsqlresilience.Employees
        SET departmentId = 1 -- Keep departmentId same for this test, but update something else to fire its trigger
        WHERE departmentId = 1 AND ROWNUM <= 1; -- Update just one employee linked to Dept 1 to see its trigger
                                            -- but we are not changing departmentId in employee in this manual step to avoid complexity.
                                            -- To truly show cascade, we'd change departmentID here.
                                            -- Let's assume an FK ON UPDATE CASCADE *did* change Employees.departmentId
        -- For a clearer demonstration if cascade *was* active on departmentId update:
        -- UPDATE plsqlresilience.Employees SET departmentId = 10 WHERE departmentId = 1;
        -- This would fire trgEmpDeptFkUpdate for each affected employee.
    END IF;

    COMMIT;
END;
/
-- To better demonstrate the intended scenario with actual cascade firing trgEmpDeptFkUpdate:
-- 1. Add a temporary new department
INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity) VALUES (10, 'Temp Dept', 'Temp City');
COMMIT;
-- 2. Perform the update that, if ON UPDATE CASCADE were on the FK, would fire both.
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test with potential cascade (simulated impact) ---');
    -- This update will fire trgDeptUpdate
    UPDATE plsqlresilience.Departments SET departmentId = 10, departmentName = 'Sales Updated' WHERE departmentId = 1;
    DBMS_OUTPUT.PUT_LINE('Departments table updated.');

    -- If ON UPDATE CASCADE was set on FK_EmployeeDepartment for departmentId,
    -- the above UPDATE would automatically update Employees.departmentId from 1 to 10.
    -- This, in turn, would fire trgEmpDeptFkUpdate for each employee moved.
    -- Simulating one such employee update:
    UPDATE plsqlresilience.Employees SET departmentId = 10 WHERE employeeId = 100 AND departmentId = 1;
    DBMS_OUTPUT.PUT_LINE('Simulated cascade update for one employee.');

    COMMIT;
END;
/
-- Clean up:
-- UPDATE plsqlresilience.Employees SET departmentId = 1 WHERE departmentId = 10;
-- UPDATE plsqlresilience.Departments SET departmentId = 1, departmentName = 'Sales' WHERE departmentId = 10;
-- DELETE FROM plsqlresilience.Departments WHERE departmentId = 10 AND departmentName = 'Temp Dept';
-- COMMIT;

```
<p><strong>Discussion of Firing Order and Cascading Effects:</strong></p>
    <ol>
        <li><strong>Initial Update:</strong> The <code>UPDATE</code> on <code>plsqlresilience.Departments</code> occurs.</li>
        <li><strong><code>trgDeptUpdate</code> Fires:</strong> For each row updated in <code>plsqlresilience.Departments</code>, the <code>trgDeptUpdate</code> (AFTER UPDATE ON Departments) trigger fires.</li>
        <li><strong>Cascading Update (Hypothetical):</strong> If the foreign key from <code>plsqlresilience.Employees.departmentId</code> to <code>plsqlresilience.Departments.departmentId</code> had an <code>ON UPDATE CASCADE</code> clause, the database would automatically propagate the change in <code>departmentId</code> from the <code>Departments</code> table to all matching rows in the <code>Employees</code> table.</li>
        <li><strong><code>trgEmpDeptFkUpdate</code> Fires:</strong> For each row in <code>plsqlresilience.Employees</code> whose <code>departmentId</code> is updated due to the cascade (or a direct update), the <code>trgEmpDeptFkUpdate</code> (AFTER UPDATE OF departmentId ON Employees) trigger would fire.</li>
    </ol>
    <p><strong>Implications of Cascading Effects:</strong></p>
    <ul>
        <li><strong>Performance:</strong> If updating one department cascades to updating hundreds or thousands of employee records, both <code>trgDeptUpdate</code> (once per department row) and <code>trgEmpDeptFkUpdate</code> (once per affected employee row) will fire. This can lead to significant performance overhead if the triggers perform complex operations.</li>
        <li><strong>Complexity and Debugging:</strong> The chain of trigger firings can become complex and hard to debug. An issue in one trigger might only manifest as a problem in a later, seemingly unrelated trigger.</li>
        <li><strong>Unexpected Multiple Firings:</strong> If <code>trgDeptUpdate</code>, for instance, also performed an DML on <code>Employees</code> that updated <code>departmentId</code> again, it could lead to recursive or unintended multiple firings of <code>trgEmpDeptFkUpdate</code>. Oracle has limits on trigger recursion depth (typically 32 or 50, can be affected by <code>OPEN_CURSORS</code> parameter as per PL/SQL Ref Ch 10, p. 10-46) to prevent infinite loops.</li>
        <li><strong>Transaction Integrity:</strong> If any trigger in the chain fails and raises an unhandled exception, the entire original DML statement and all subsequent trigger actions are typically rolled back, which is generally desirable for consistency.</li>
    </ul>
    <p>Careful design is needed to manage trigger interactions, especially with cascading foreign key actions or when triggers on one table cause DML on another table that also has triggers. (PL/SQL Ref, Ch 10, p. 10-46 "Order in Which Triggers Fire").</p>
<h3>(iii) Contrasting with Inefficient Common Solutions</h3>
<h4>Exercise 3.3: Auditing via Application Code vs. Triggers</h4>
    <p><strong>Solution:</strong></p>
    <p><strong>Inefficient Common Solution (Application Code Logging):</strong></p>
    <p>If application developers were to log manually, their code (e.g., in Java, Python, etc.) would perform two distinct database operations:</p>
    <ol>
        <li>Update the product's stock quantity:
        
```sql
-- Executed by the application
UPDATE plsqlresilience.Products
SET stockQuantity = :new_stock_quantity -- :new_stock_quantity is a bind variable from application
WHERE productId = :product_id;          -- :product_id is a bind variable from application
```

</li>
<li>Insert an audit record (assuming the application also fetches the old value first, or logs only new value):

```sql
-- Executed by the application, after fetching old_stock_quantity if needed
INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, oldValue, newValue, changedBy)
VALUES ('Products',
        'STOCK_CHG',
        TO_CHAR(:product_id),                     -- :product_id from application
        TO_CHAR(:old_stock_quantity),             -- :old_stock_quantity fetched/known by application
        TO_CHAR(:new_stock_quantity),             -- :new_stock_quantity from application
        :app_user_context);                   -- :app_user_context from application
```
</li>
</ol>
    <p><strong>Oracle-Idiomatic Solution (Trigger-Based Auditing):</strong></p>
    
```sql
CREATE OR REPLACE TRIGGER plsqlresilience.trgAuditProductStockChange
AFTER UPDATE OF stockQuantity ON plsqlresilience.Products
FOR EACH ROW
-- Optionally, only fire if the value actually changed:
-- WHEN (NVL(:OLD.stockQuantity, -99999) != NVL(:NEW.stockQuantity, -99999))
BEGIN
    INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, oldValue, newValue)
    VALUES ('Products',
            'STOCK_CHG',
            TO_CHAR(:NEW.productId), -- or :OLD.productId, they are the same for an UPDATE on PK
            TO_CHAR(:OLD.stockQuantity),
            TO_CHAR(:NEW.stockQuantity));
    -- changedBy and changeTimestamp will use their DEFAULT values (USER and SYSTIMESTAMP)
END trgAuditProductStockChange;
/
-- Application code now only needs to do:
-- UPDATE plsqlresilience.Products SET stockQuantity = 55 WHERE productId = 1000;
-- COMMIT;
-- The trigger handles the auditing automatically.
```
<p><strong>Discussion of Superiority of Trigger-Based Approach:</strong></p>
    <ol>
        <li><strong>Data Integrity & Consistency:</strong>
            <ul>
                <li><strong>Guaranteed Auditing:</strong> The trigger ensures that *every* change to <code>stockQuantity</code> made through an <code>UPDATE</code> statement is audited, regardless of which application module or ad-hoc SQL tool makes the change. Application-level auditing can be forgotten by a developer, bypassed by direct SQL updates, or inconsistently implemented across different parts of an application.</li>
                <li><strong>Atomic Operation (Effectively):</strong> The DML operation and the trigger's action occur within the same transaction. If the DML succeeds, the audit log is written. If the audit log insert fails for some reason (e.g., <code>AuditLog</code> table is full and trigger doesn't handle it), the original DML that fired the trigger will also be rolled back (unless the trigger has specific exception handling to prevent this, which would be unusual for auditing). This maintains consistency. With application-level logging, the product update might succeed, but the subsequent audit insert could fail, leading to an unaudited change.</li>
            </ul>
        </li>
        <li><strong>Reduced Application Code Complexity & Redundancy:</strong>
            <ul>
                <li><strong>DRY (Don't Repeat Yourself):</strong> The auditing logic is defined once in the database trigger. Application developers don't need to write and maintain auditing code in multiple places within the application. This reduces boilerplate code and the chance of inconsistencies in how auditing is performed.</li>
                <li><strong>Simpler Application DML:</strong> The application code becomes simpler, focusing only on the primary business operation (updating stock).</li>
            </ul>
        </li>
        <li><strong>Centralized Logic:</strong> Auditing rules are enforced at the database level, which is the central point of data management. This is generally a more robust place for such critical business rules than distributing them across potentially multiple client applications.</li>
        <li><strong>Access to <code>:OLD</code> and <code>:NEW</code> Values:</strong> Triggers have direct and easy access to both the old and new values of the columns being modified via the <code>:OLD</code> and <code>:NEW</code> pseudorecords. In application-level auditing, the application might need to perform an additional <code>SELECT</code> to fetch the old value before the update, adding overhead and a potential race condition if the data changes between the <code>SELECT</code> and the <code>UPDATE</code>.</li>
        <li><strong>Security:</strong> If direct table access is restricted and modifications are only allowed through stored procedures, triggers still ensure auditing. If users have direct DML privileges, triggers are even more crucial as they cannot be easily bypassed.</li>
    </ol>
    <p>While triggers can add overhead to DML operations, for critical tasks like auditing, their benefits in terms of reliability and data integrity often outweigh the performance considerations, which can usually be managed through efficient trigger code.</p>
    <hr>
</div>

<h3>(iv) Hardcore Combined Problem Solution</h3>
<p><strong>Comprehensive Order Processing and Auditing</strong></p>

<p><strong>Part 1: Order Management Package (`OrderProcessingPkg`)</strong></p>
<p><strong>Package Specification:</strong></p>

```sql
CREATE OR REPLACE PACKAGE plsqlresilience.OrderProcessingPkg AS
    -- Public record type for order items
    TYPE OrderItemRec IS RECORD (
        productId     plsqlresilience.Products.productId%TYPE,
        quantity      plsqlresilience.OrderItems.quantity%TYPE
    );

    -- Public collection type for a list of order items
    TYPE OrderItemList IS TABLE OF OrderItemRec INDEX BY PLS_INTEGER;

    -- Public user-defined exceptions
    e_insufficient_stock EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_insufficient_stock, -20010);

    e_product_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_product_not_found, -20011);
    
    e_invalid_quantity EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_invalid_quantity, -20012);

    -- Public procedure to create a new order
    PROCEDURE CreateNewOrder (
        p_customer_id IN  plsqlresilience.Orders.customerId%TYPE,
        p_items       IN  OrderItemList,
        p_order_id    OUT plsqlresilience.Orders.orderId%TYPE
    );

END OrderProcessingPkg;
/
```
<p><strong>Package Body:</strong></p>

```sql
CREATE OR REPLACE PACKAGE BODY plsqlresilience.OrderProcessingPkg AS

    -- Private procedure to log order attempts/results
    PROCEDURE LogOrderAttempt (
        p_customer_id       IN NUMBER,
        p_status_indicator  IN VARCHAR2, -- e.g., 'SUCCESS', 'FAIL_STOCK', 'FAIL_PRODUCT', 'FAIL_OTHER'
        p_order_id_created  IN NUMBER DEFAULT NULL,
        p_error_message     IN VARCHAR2 DEFAULT NULL,
        p_product_id_issue  IN NUMBER DEFAULT NULL
    ) IS
        v_operation_type plsqlresilience.AuditLog.operationType%TYPE;
        v_details        plsqlresilience.AuditLog.details%TYPE;
    BEGIN
        v_details := 'CustID: ' || p_customer_id;
        IF p_order_id_created IS NOT NULL THEN
            v_details := v_details || ', OrderID: ' || p_order_id_created;
        END IF;
        IF p_product_id_issue IS NOT NULL THEN
            v_details := v_details || ', ProductIssueID: ' || p_product_id_issue;
        END IF;
        IF p_error_message IS NOT NULL THEN
            v_details := v_details || ', Msg: ' || SUBSTR(p_error_message, 1, 500);
        END IF;

        CASE p_status_indicator
            WHEN 'SUCCESS' THEN v_operation_type := 'ORDER_SUCCESS';
            WHEN 'FAIL_STOCK' THEN v_operation_type := 'ORDER_FAIL_STOCK';
            WHEN 'FAIL_PRODUCT' THEN v_operation_type := 'ORDER_FAIL_PROD';
            WHEN 'FAIL_QUANTITY' THEN v_operation_type := 'ORDER_FAIL_QTY';
            ELSE v_operation_type := 'ORDER_FAIL_OTHER';
        END CASE;

        INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, details)
        VALUES ('Orders', v_operation_type, NVL(TO_CHAR(p_order_id_created), 'N/A'), v_details);
        -- No COMMIT here, part of the main transaction or handled by autonomous transaction if preferred for logging failures
    END LogOrderAttempt;

    PROCEDURE CreateNewOrder (
        p_customer_id IN  plsqlresilience.Orders.customerId%TYPE,
        p_items       IN  OrderItemList,
        p_order_id    OUT plsqlresilience.Orders.orderId%TYPE
    ) IS
        v_current_product_price plsqlresilience.Products.unitPrice%TYPE;
        v_available_stock       plsqlresilience.Products.stockQuantity%TYPE;
        v_item                  OrderItemRec;
        v_idx                   PLS_INTEGER;
    BEGIN
        -- Validate all items first
        IF p_items.COUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20013, 'Order must contain at least one item.');
        END IF;

        v_idx := p_items.FIRST;
        WHILE v_idx IS NOT NULL LOOP
            v_item := p_items(v_idx);

            IF v_item.quantity <= 0 THEN
                LogOrderAttempt(p_customer_id, 'FAIL_QUANTITY', NULL, 'Invalid quantity <= 0.', v_item.productId);
                RAISE e_invalid_quantity;
            END IF;

            BEGIN
                SELECT unitPrice, stockQuantity
                INTO v_current_product_price, v_available_stock
                FROM plsqlresilience.Products
                WHERE productId = v_item.productId;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    LogOrderAttempt(p_customer_id, 'FAIL_PRODUCT', NULL, NULL, v_item.productId);
                    RAISE e_product_not_found;
            END;

            IF v_item.quantity > v_available_stock THEN
                LogOrderAttempt(p_customer_id, 'FAIL_STOCK', NULL, 'Stock: '||v_available_stock||', Req: '||v_item.quantity, v_item.productId);
                RAISE e_insufficient_stock;
            END IF;
            v_idx := p_items.NEXT(v_idx);
        END LOOP;

        -- All items validated, proceed to create order and update stock
        p_order_id := plsqlresilience.OrderSeq.NEXTVAL;

        INSERT INTO plsqlresilience.Orders (orderId, customerId, orderDate, status)
        VALUES (p_order_id, p_customer_id, SYSDATE, 'Pending');

        v_idx := p_items.FIRST;
        WHILE v_idx IS NOT NULL LOOP
            v_item := p_items(v_idx);
            
            -- Re-fetch price at the time of insert to ensure current price is used
            SELECT unitPrice INTO v_current_product_price 
            FROM plsqlresilience.Products WHERE productId = v_item.productId;

            INSERT INTO plsqlresilience.OrderItems (orderItemId, orderId, productId, quantity, itemPrice)
            VALUES (plsqlresilience.OrderItemSeq.NEXTVAL, p_order_id, v_item.productId, v_item.quantity, v_current_product_price);

            UPDATE plsqlresilience.Products
            SET stockQuantity = stockQuantity - v_item.quantity
            WHERE productId = v_item.productId;
            
            v_idx := p_items.NEXT(v_idx);
        END LOOP;

        LogOrderAttempt(p_customer_id, 'SUCCESS', p_order_id);
        COMMIT;

    EXCEPTION
        WHEN e_invalid_quantity THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20012, 'Order failed: Invalid item quantity.');
        WHEN e_insufficient_stock THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20010, 'Order failed: Insufficient stock for one or more products.');
        WHEN e_product_not_found THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20011, 'Order failed: Product not found.');
        WHEN OTHERS THEN
            LogOrderAttempt(p_customer_id, 'FAIL_OTHER', NULL, SQLCODE || ': ' || SQLERRM);
            ROLLBACK;
            RAISE; -- Re-raise the original exception
    END CreateNewOrder;

END OrderProcessingPkg;
/
```
<p><strong>Part 2: Product Stock Audit Trigger (`trgAuditStockChange`)</strong></p>

```sql
CREATE OR REPLACE TRIGGER plsqlresilience.trgAuditStockChange
AFTER UPDATE OF stockQuantity ON plsqlresilience.Products
FOR EACH ROW
BEGIN
    -- Ensure the trigger only logs if the stock quantity actually changed.
    -- The WHEN clause in trigger definition is simpler for this, but doing it in body for explicit demonstration.
    IF :NEW.stockQuantity != :OLD.stockQuantity THEN
        INSERT INTO plsqlresilience.AuditLog (tableName, operationType, recordId, oldValue, newValue, details)
        VALUES ('Products',
                'STOCK_UPDATE',
                TO_CHAR(:NEW.productId),
                TO_CLOB(:OLD.stockQuantity),
                TO_CLOB(:NEW.stockQuantity),
                'Stock quantity changed for product ' || :NEW.productName);
    END IF;
END trgAuditStockChange;
/
```
<p><strong>Part 3: Testing Anonymous Block</strong></p>

```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;
DECLARE
    v_items           plsqlresilience.OrderProcessingPkg.OrderItemList;
    v_new_order_id    plsqlresilience.Orders.orderId%TYPE;
    v_laptop_id       plsqlresilience.Products.productId%TYPE;
    v_mouse_id        plsqlresilience.Products.productId%TYPE;
    v_keyboard_id     plsqlresilience.Products.productId%TYPE;
    v_monitor_id      plsqlresilience.Products.productId%TYPE;
    v_customer_test_id NUMBER := 777; -- Example customer ID
BEGIN
    -- Get product IDs
    SELECT productId INTO v_laptop_id FROM plsqlresilience.Products WHERE productName = 'Laptop Pro';
    SELECT productId INTO v_mouse_id FROM plsqlresilience.Products WHERE productName = 'Wireless Mouse';
    SELECT productId INTO v_keyboard_id FROM plsqlresilience.Products WHERE productName = 'Keyboard Ultra';
    SELECT productId INTO v_monitor_id FROM plsqlresilience.Products WHERE productName = 'Monitor HD';

    DBMS_OUTPUT.PUT_LINE('--- Test Case 1: Successful Order ---');
    v_items.DELETE; -- Clear previous items
    v_items(1).productId := v_laptop_id;
    v_items(1).quantity  := 1;
    v_items(2).productId := v_mouse_id;
    v_items(2).quantity  := 2;
    BEGIN
        plsqlresilience.OrderProcessingPkg.CreateNewOrder(
            p_customer_id => v_customer_test_id,
            p_items       => v_items,
            p_order_id    => v_new_order_id
        );
        DBMS_OUTPUT.PUT_LINE('Successful order created with ID: ' || v_new_order_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 1: ' || SQLERRM);
    END;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Case 2: Insufficient Stock ---');
    v_items.DELETE;
    v_items(1).productId := v_keyboard_id; -- Keyboard Ultra, stock is 10
    v_items(1).quantity  := 15; -- Requesting more than available
    BEGIN
        plsqlresilience.OrderProcessingPkg.CreateNewOrder(
            p_customer_id => v_customer_test_id,
            p_items       => v_items,
            p_order_id    => v_new_order_id 
        );
        DBMS_OUTPUT.PUT_LINE('Order created (should not happen): ' || v_new_order_id);
    EXCEPTION
        WHEN plsqlresilience.OrderProcessingPkg.e_insufficient_stock THEN
            DBMS_OUTPUT.PUT_LINE('Caught expected insufficient stock: ' || SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 2: ' || SQLERRM);
    END;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Case 3: Product Not Found ---');
    v_items.DELETE;
    v_items(1).productId := 9999; -- Non-existent product ID
    v_items(1).quantity  := 1;
    BEGIN
        plsqlresilience.OrderProcessingPkg.CreateNewOrder(
            p_customer_id => v_customer_test_id,
            p_items       => v_items,
            p_order_id    => v_new_order_id
        );
        DBMS_OUTPUT.PUT_LINE('Order created (should not happen): ' || v_new_order_id);
    EXCEPTION
        WHEN plsqlresilience.OrderProcessingPkg.e_product_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Caught expected product not found: ' || SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 3: ' || SQLERRM);
    END;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Test Case 4: Invalid Quantity ---');
    v_items.DELETE;
    v_items(1).productId := v_mouse_id;
    v_items(1).quantity  := 0; -- Invalid quantity
    BEGIN
        plsqlresilience.OrderProcessingPkg.CreateNewOrder(
            p_customer_id => v_customer_test_id,
            p_items       => v_items,
            p_order_id    => v_new_order_id
        );
        DBMS_OUTPUT.PUT_LINE('Order created (should not happen for invalid quantity): ' || v_new_order_id);
    EXCEPTION
        WHEN plsqlresilience.OrderProcessingPkg.e_invalid_quantity THEN
            DBMS_OUTPUT.PUT_LINE('Caught expected invalid quantity: ' || SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 4: ' || SQLERRM);
    END;


    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Verification Queries ---');
    DBMS_OUTPUT.PUT_LINE('-- Recent Orders --');
    FOR rec IN (SELECT orderId, customerId, status FROM plsqlresilience.Orders ORDER BY orderDate DESC FETCH FIRST 3 ROWS ONLY) LOOP
        DBMS_OUTPUT.PUT_LINE('Order ID: ' || rec.orderId || ', Cust ID: ' || rec.customerId || ', Status: ' || rec.status);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('-- Recent Order Items --');
    FOR rec IN (SELECT oi.orderId, p.productName, oi.quantity, oi.itemPrice 
                FROM plsqlresilience.OrderItems oi JOIN plsqlresilience.Products p ON oi.productId = p.productId 
                WHERE oi.orderId = v_new_order_id -- Assuming v_new_order_id holds the ID from the successful order
                ORDER BY oi.orderItemId DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('Order ID: ' || rec.orderId || ', Product: ' || rec.productName || ', Qty: ' || rec.quantity || ', Price: ' || rec.itemPrice);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('-- Product Stock Levels --');
    FOR rec IN (SELECT productName, stockQuantity FROM plsqlresilience.Products WHERE productId IN (v_laptop_id, v_mouse_id, v_keyboard_id)) LOOP
        DBMS_OUTPUT.PUT_LINE('Product: ' || rec.productName || ', Stock: ' || rec.stockQuantity);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('-- Recent Audit Logs --');
    FOR rec IN (SELECT operationType, tableName, recordId, details FROM plsqlresilience.AuditLog ORDER BY changeTimestamp DESC FETCH FIRST 10 ROWS ONLY) LOOP
        DBMS_OUTPUT.PUT_LINE('Audit: ' || rec.operationType || ' on ' || rec.tableName || ' for ID ' || rec.recordId || '. Details: '|| rec.details);
    END LOOP;

END;
/
```

</div>
</div>
</body>