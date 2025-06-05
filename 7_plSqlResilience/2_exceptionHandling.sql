        -- Exception Handling: Predefined exceptions, user-defined exceptions, SQLCODE, SQLERRM, PRAGMA EXCEPTION_INIT


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 1.4: Handling Predefined Exceptions

-- Problem: Write a PL/SQL anonymous block that attempts to:
-- Select an employee's salary into a NUMBER variable for an employeeId that does not exist in the Employees table.
-- Handle the NO_DATA_FOUND predefined exception and print a user-friendly message.
-- Attempt to divide a number by zero.
-- Handle the ZERO_DIVIDE predefined exception and print a user-friendly message.
DECLARE
    empId PLSQLRESILIENCE.EMPLOYEES.EMPLOYEEID%TYPE := 101;
    sal NUMBER;
BEGIN 
    SELECT SALARY INTO sal 
    FROM PLSQLRESILIENCE.EMPLOYEES 
    WHERE EMPLOYEEID = empId;
    IF SQL%FOUND THEN sal := sal / 0; END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No employees found for employeeId '||empId);
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('Dividing the salary ('||sal||') by zero is not allowed');
END;
/
-- Focus: Understand how to catch and handle common predefined Oracle exceptions.
-- Relations:
-- Oracle: Directly uses predefined exceptions. PL/SQL Language Reference (F46753-09), Chapter 12, "Predefined Exceptions" (p. 12-11, Table 12-3 lists them).

--      Exercise 1.5: User-Defined Exceptions and PRAGMA EXCEPTION_INIT
-- Problem:
-- In a PL/SQL anonymous block, declare a user-defined exception named NegativeSalaryException.
-- Attempt to update an employee's salary to a negative value.
-- If the attempted salary is negative, explicitly RAISE the NegativeSalaryException.
-- Include an exception handler for NegativeSalaryException that displays a message like "Error: Salary cannot be negative."
-- Now, modify the block: associate NegativeSalaryException with the Oracle error code -20002 using PRAGMA EXCEPTION_INIT. In a separate part of the block (or another
--  procedure called by it), use RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative from RAISE_APPLICATION_ERROR.'). Ensure your exception handler for 
-- NegativeSalaryException still catches this.
-- Focus: Declaring, raising, and handling user-defined exceptions; using PRAGMA EXCEPTION_INIT and RAISE_APPLICATION_ERROR. Refer to PL/SQL Language Reference, 
-- Chapter 12, sections "User-Defined Exceptions" (p. 12-13), "EXCEPTION_INIT Pragma" (p. 14-74), and "RAISE_APPLICATION_ERROR Procedure" (p. 12-18).

DECLARE
    newSalary NUMBER := -1;
    NegativeSalaryException EXCEPTION;
    PRAGMA EXCEPTION_INIT(NegativeSalaryException, -2);
BEGIN
    -- IF newSalary < 0 THEN RAISE NegativeSalaryException; END IF;
    IF newSalary < 0 THEN RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative from RAISE_APPLICATION_ERROR.'); END IF;
EXCEPTION
    WHEN NegativeSalaryException THEN DBMS_OUTPUT.PUT_LINE('Error: Salary cannot be negative.');
    WHEN OTHERS THEN IF SQLCODE = -20002 THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); END IF;
END;
/

--      Exercise 1.6: Using SQLCODE and SQLERRM
-- Problem: Write a PL/SQL anonymous block that attempts an operation known to cause a less common, unnamed Oracle error (e.g., try to insert a string longer than a 
-- VARCHAR2(10) column allows *without* a specific named exception for it). In the WHEN OTHERS exception handler, display the SQLCODE and SQLERRM to identify the 
-- error.
-- Focus: Using SQLCODE and SQLERRM for generic error reporting. Refer to PL/SQL Language Reference, Chapter 12, "Retrieving Error Code and Error Message" (p. 12-27).

DECLARE
    newString VARCHAR2(10);
BEGIN
    newString := '12345678910';
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('SQL CODE '||SQLCODE||' with ERRORS '||SQLERRM);
END;
/


--  (ii) Disadvantages and Pitfalls

--      Exercise 2.3: Overly Broad WHEN OTHERS Handler
-- Problem: Create a procedure ProcessEmployeeData(pEmployeeId IN NUMBER) that performs several DML operations:
-- Updates the employee's salary by 10%.
-- Inserts a record into AuditLog noting the salary change.
CREATE PROCEDURE PLSQLRESILIENCE.ProcessEmployeeData(pEmployeeId IN NUMBER)
AS BEGIN
    DECLARE
        oldSalary PLSQLRESILIENCE.EMPLOYEES.SALARY%TYPE;
    BEGIN
        SELECT SALARY INTO oldSalary FROM PLSQLRESILIENCE.EMPLOYEES WHERE EMPLOYEEID = pEmployeeId;
        IF SQL%NOTFOUND THEN RAISE NO_DATA_FOUND; END IF;
        SAVEPOINT oldValues;
        UPDATE PLSQLRESILIENCE.EMPLOYEES SET SALARY = SALARY * 1.1 WHERE EMPLOYEEID = pEmployeeId;
    END;
    IF SQL%ROWCOUNT = 0 THEN RAISE NO_DATA_FOUND; END IF;
    INSERT INTO PLSQLRESILIENCE.AuditLog(TABLENAME, OPERATIONTYPE, CHANGEDBY, CHANGETIMESTAMPM, OLDVALUE, NEWVALUE, RECORDID) 
    VALUES('EMPLOYEES', 'SALARY RAISE', 'ADMIN', SYSDATE, oldSalary, oldSalary * 1.1);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('The employee whose salary must be increased was not found');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AODIFAOISDFJ');
END ProcessEmployeeData;
-- Attempts to update the Departments table based on the employee's department (potentially causing a constraint violation if the department does not exist or if 
-- there's a typo in a column name).
-- Include a single WHEN OTHERS exception handler at the end of the procedure that simply logs "An unspecified error occurred" to DBMS_OUTPUT.PUT_LINE and then exits 
-- without re-raising the exception. Discuss the disadvantages of this approach. Why is it a pitfall? What information is lost?
-- Focus: Illustrate the dangers of generic WHEN OTHERS handlers that mask the actual error, making debugging difficult. Refer to PL/SQL Language Reference, Chapter 
-- 12, "Unhandled Exceptions" (p. 12-27) and general best practices for error handling.

--      Exercise 2.4: Exception Propagation and Scope
-- Problem: Create a nested PL/SQL block structure: An outer block declares an exception OuterException. An inner block declares an exception InnerException. The inner 
-- block raises InnerException and handles it. Then, the inner block raises OuterException. The outer block has a handler for OuterException. What happens? Now, modify
-- the inner block to *not* handle InnerException. What happens to InnerException? Explain the propagation rules demonstrated.
-- Focus: Understand how exceptions propagate out of blocks if not handled locally. Refer to PL/SQL Language Reference, Chapter 12, "Exception Propagation" (p. 12-19).


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 3.2: Manual Error Checking vs. Exception Handling
-- Scenario: A procedure needs to fetch an employee's salary. If the employee doesn't exist, it should return NULL. If multiple employees are found (which shouldn't 
-- happen if employeeId is primary key, but assume a faulty query for demonstration), it should also indicate an error.
-- Inefficient Common Solution (Problem): Implement this by:
-- Executing a SELECT COUNT(*) to check if the employee exists.
-- If count is 1, execute another SELECT salary INTO ....
-- If count is 0, set salary to NULL.
-- If count > 1, set salary to a special error indicator (e.g., -1).
-- Oracle-Idiomatic Solution (Solution): Implement this using a single SELECT salary INTO ... statement within a BEGIN...EXCEPTION...END block, handling NO_DATA_FOUND 
-- and TOO_MANY_ROWS exceptions appropriately.
-- Task: Implement both versions. Discuss the verbosity, performance implications (multiple queries vs. one), and clarity of the exception-handling approach.
-- Focus: Showcasing the conciseness and efficiency of PL/SQL exception handling over manual, multi-step error checking.