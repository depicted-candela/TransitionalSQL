        -- PL/SQL Fundamentals

--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 1.1: Understanding PL/SQL Block Structure
-- Problem: Write a basic anonymous PL/SQL block that declares a variable greeting of type VARCHAR2(50), assigns it the value 'Hello, Oracle 
-- PL/SQL!', and then prints this greeting using DBMS_OUTPUT.PUT_LINE. Include a simple exception handler that prints a generic error message if 
-- anything goes wrong.
DECLARE
    greeting VARCHAR2(50) := 'Hello, Oracle PL/SQL!';
BEGIN
    DBMS_OUTPUT.PUT_LINE(greeting);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error');
END;
/

--      Exercise 1.2: Using Scalar Variables, %TYPE, and %ROWTYPE
-- Problem: Write a PL/SQL block that:
-- Declares a variable empLastName using the %TYPE attribute to match the lastName column of the employees table.
-- Declares a record variable empRecord using the %ROWTYPE attribute to match the structure of a row in the employees table.
-- Fetches the lastName of employee with employeeId = 101 into empLastName.
-- Fetches the entire row for employee with employeeId = 102 into empRecord.
-- Prints the fetched last name and the first name and salary from the record.
SET SERVEROUTPUT ON;
DECLARE
    empId1 SMALLINT := 101;
    empId2 SMALLINT := 102;
    empLastName plsqlawakening.employees.lastName%TYPE;
    empRecord plsqlawakening.employees%ROWTYPE;
BEGIN
    SELECT e.LASTNAME
    INTO empLastName
    FROM plsqlawakening.employees e
    WHERE e.employeeId = empId1;

    SELECT *
    INTO empRecord
    FROM plsqlawakening.employees e
    WHERE e.employeeId = empId2;

    DBMS_OUTPUT.PUT_LINE('LAST NAME of 101: ' || empLastName);
    DBMS_OUTPUT.PUT_LINE('RECORD (FIRST NAME, SALARY) of 102: ' || empRecord.firstName ||', '|| empRecord.lastName);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No data for ' || empId1 || ' or ' || empId2);
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('MOre than one row for ' || empId1 || ' or ' || empId2);
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error');
END;
/

--      Exercise 1.3: Conditional Logic with IF-THEN-ELSIF-ELSE and CASE
-- Problem: Write a PL/SQL block that retrieves the salary of employee with employeeId = 103.
-- Using an IF-THEN-ELSIF-ELSE structure, print:
-- "High Earner" if salary > 75000.
-- "Mid Earner" if salary > 65000 and salary <= 75000.
-- "Standard Earner" otherwise.
-- Using a CASE statement (not a CASE expression within SQL), achieve the same logic and print the result.
SET SERVEROUTPUT ON;
DECLARE
    empId PLSQLAWAKENING.EMPLOYEES.EMPLOYEEID%TYPE := 103;
    empSalary PLSQLAWAKENING.EMPLOYEES.SALARY%TYPE;
    catEmpSalary VARCHAR2(20);
BEGIN
    SELECT SALARY
    INTO empSalary
    FROM PLSQLAWAKENING.EMPLOYEES
    WHERE EMPLOYEEID = empId;

    IF empSalary > 75000 THEN catEmpSalary := 'High Earner';
    ELSIF empSalary > 65000 THEN catEmpSalary := 'Mid Earner';
    ELSE catEmpSalary := 'Standard Earner';
    END IF;
    DBMS_OUTPUT.PUT_LINE(catEmpSalary || ' with IF ELSE');

    CASE
        WHEN empSalary > 75000 THEN catEmpSalary := 'High Earner';
        WHEN empSalary > 65000 THEN catEmpSalary := 'Mid Earner';
        ELSE catEmpSalary := 'Standard Earner';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(catEmpSalary || ' with CASE');
END;
/

--      Exercise 1.4: Iterative Control with Basic LOOP, WHILE, and FOR
-- Problem:
-- Basic LOOP with EXIT WHEN: Print numbers from 1 to 3.
-- WHILE LOOP: Print numbers from 1 to 3.
-- Numeric FOR LOOP: Print numbers from 1 to 3.
-- PostgreSQL Bridge: PostgreSQL has `LOOP END LOOP` (with `EXIT WHEN`), `WHILE END LOOP`, and `FOR integer_var IN start .. end LOOP`. Oracle's 
-- syntax is nearly identical, making this a practice of Oracle's implementation.
-- Oracle Value/Advantage: Oracle PL/SQL offers a comprehensive set of loop structures suitable for various iteration needs. The numeric `FOR` 
-- loop is particularly concise for simple counter-based iterations, as it implicitly declares the loop counter.
DECLARE
    starting_index SMALLINT := 1;
    final_index SMALLINT := 3;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('LOOP #' || starting_index);
        IF starting_index = final_index THEN EXIT; END IF;
        starting_index := starting_index + 1;
    END LOOP;
END;
/
DECLARE 
    starting_index SMALLINT := 1;
    final_index SMALLINT := 3;
BEGIN 
    FOR x IN starting_index..final_index LOOP
        DBMS_OUTPUT.PUT_LINE('LOOP #' || x);
    END LOOP;
END;
/
DECLARE
    final_index SMALLINT := 3;
    loop_ SMALLINT := 1;
BEGIN
    WHILE loop_ < final_index + 1 LOOP
      DBMS_OUTPUT.PUT_LINE('LOOP #' || loop_);
      loop_ := loop_ + 1;
    END LOOP;
END;
/

--      Exercise 1.5: SQL within PL/SQL (SELECT INTO, DML, DBMS_OUTPUT)
-- Problem: Write a PL/SQL block that performs the following actions:
-- Declares a variable deptName of type departments.departmentName%TYPE.
-- Uses SELECT INTO to retrieve the departmentName for departmentId = 20 into deptName.
-- Prints the retrieved department name using DBMS_OUTPUT.PUT_LINE.
-- Inserts a new row into the salesLog table with the message 'Department lookup successful: ' concatenated with deptName.
-- Updates the location of department 20 to 'MANCHESTER'.
-- Prints a confirmation message for the update.
-- Deletes the newly inserted log entry based on the message.
-- Prints a confirmation message for the delete. Assume the department and log table exist.
SET SERVEROUTPUT ON;
DECLARE
    deptName PLSQLAWAKENING.DEPARTMENTS.departmentName%TYPE;
    logt PLSQLAWAKENING.SALESLOG.LOGTIME%TYPE := SYSDATE;
    logm PLSQLAWAKENING.SALESLOG.LOGMESSAGE%TYPE;
    updatingDepartment SMALLINT := 20;
BEGIN
    SELECT DEPARTMENTNAME INTO deptName FROM PLSQLAWAKENING.DEPARTMENTS
    WHERE DEPARTMENTID = updatingDepartment;
    DBMS_OUTPUT.PUT_LINE('The department: ' || deptName);
    logm := 'Department lookup successful: ' || deptName;
    INSERT INTO PLSQLAWAKENING.SALESLOG(LOGMESSAGE, LOGTIME)
    VALUES (logm, logt);
    BEGIN
        UPDATE PLSQLAWAKENING.DEPARTMENTS SET DEPARTMENTNAME = 'MANCHESTER' WHERE DEPARTMENTID = updatingDepartment;
        DBMS_OUTPUT.PUT_LINE('UPDATE FOR DEPARTMENT ' || updatingDepartment || ' with DEPARTMENTNAME as MANCHESTER');
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR UPDATING DEPARTMENT');
    END;
    BEGIN
        DELETE PLSQLAWAKENING.SALESLOG WHERE LOGMESSAGE = logm;
        DBMS_OUTPUT.PUT_LINE('DELETION FOR LOG "' || logm ||'"');
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('UNKWON ERROR DELETING THE LOG ENTRY');
    END;
END;
/
