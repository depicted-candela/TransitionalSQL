        -- Awakening PL/SQL


--  (ii) Disadvantages and Pitfalls

--      Exercise 2.1: PL/SQL Block - Unhandled Exceptions Pitfall
-- Problem: Write a PL/SQL block that attempts to select salary into a NUMBER variable for an employeeId that does not exist (e.g., 999). Do not include an EXCEPTION 
-- block initially. Observe the error. Then, modify the block to include a WHEN OTHERS THEN handler that prints a generic error message.
DECLARE
    notRealEmpID PLSQLAWAKENING.EMPLOYEES.EMPLOYEEID%TYPE := 999;
    salaryT PLSQLAWAKENING.EMPLOYEES.SALARY%TYPE; 
BEGIN
    SELECT SALARY
    INTO salaryT
    FROM PLSQLAWAKENING.EMPLOYEES
    WHERE EMPLOYEEID = notRealEmpID;
END;
/ 
-- Gives: ORA-01403: no data found

SET SERVEROUTPUT ON;
DECLARE
    notRealEmpID PLSQLAWAKENING.EMPLOYEES.EMPLOYEEID%TYPE := 999;
    salaryT PLSQLAWAKENING.EMPLOYEES.SALARY%TYPE; 
BEGIN
    SELECT SALARY
    INTO salaryT
    FROM PLSQLAWAKENING.EMPLOYEES
    WHERE EMPLOYEEID = notRealEmpID;
    DBMS_OUTPUT.PUT_LINE('Salary: ' || salaryT);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('EMPLOYEE ' || notRealEmpID || ' not found'); -- THIS ERROR IS THE APPROPRIATE
    WHEN CASE_NOT_FOUND THEN DBMS_OUTPUT.PUT_LINE('EMPLOYEE ' || notRealEmpID || ' not found'); -- THIS APPLY IN OTHER SCENARIOS
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM); -- This helped determining NO_DATA_FOUND, SQLERRM is highly important
END;
/

--      Exercise 2.2: Variables & Constants - %TYPE/%ROWTYPE and Dropped Columns
-- Problem:
-- Create a temporary table tempEmployees by copying employeeId, firstName, lastName, salary from employees.
CREATE TABLE IF NOT EXISTS PLSQLAWAKENING.TEMPEMPLOYEES AS SELECT * FROM PLSQLAWAKENING.EMPLOYEES WHERE 1 = 0;
-- Write a PL/SQL block that declares a record empRec tempEmployees%ROWTYPE and selects data into it. Print empRec.salary.
SET SERVEROUTPUT ON;
DECLARE 
    empRec PLSQLAWAKENING.TEMPEMPLOYEES%ROWTYPE;
BEGIN
    BEGIN
        SELECT * INTO empRec
        FROM PLSQLAWAKENING.EMPLOYEES WHERE EMPLOYEEID = 101;
        DBMS_OUTPUT.PUT_LINE('THe salary for the record is: ' || empRec.salary);
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('The error is '||SQLERRM);
    END;
END;
/
-- Outside the PL/SQL block, alter tempEmployees to drop the salary column.
ALTER TABLE PLSQLAWAKENING.TEMPEMPLOYEES DROP COLUMN SALARY;
-- Re-run the PL/SQL block. Observe the error.
--      ORA-06550: line 7, column 73:
--      PLS-00302: component 'SALARY' must be declared
DROP TABLE PLSQLAWAKENING.TEMPEMPLOYEES;

--      Exercise 2.3: Conditional Control - CASE Statement without ELSE and No Match
-- Problem: 
-- Write a PL/SQL block that uses a CASE statement to categorize an employee's jobTitle.
-- Declare a variable jobCategory VARCHAR2(30). Fetch the jobTitle for employeeId = 101 ('Clerk'). 
-- The CASE statement should have WHEN clauses for 'Sales Manager' and 'Developer', but not for 'Clerk', and no ELSE clause. Attempt to 
-- print jobCategory. What happens?
DECLARE
    jobCategory VARCHAR2(30);
    empJobTitle PLSQLAWAKENING.EMPLOYEES.JOBTITLE%TYPE := 101;
    empID PLSQLAWAKENING.EMPLOYEES.EMPLOYEEID%TYPE := 101;
BEGIN
    SELECT jobTitle
    INTO empJobTitle
    FROM PLSQLAWAKENING.employees
    WHERE employeeId = empID;

    DBMS_OUTPUT.PUT_LINE('Employee ' || empID || ' job title: ' || empJobTitle);

    CASE empJobTitle        -- Throws the error 'ORA-06592: CASE not found while executing CASE statement'
        WHEN 'Sales Manager' THEN jobCategory := 'Management';
        WHEN 'Developer' THEN jobCategory := 'Technical';
    END CASE;

    DBMS_OUTPUT.PUT_LINE('EMPLOYEES: '||jobCategory);
END;
/

--      Exercise 2.4: Iterative Control - Infinite Basic LOOP
-- Problem: Write a PL/SQL block using a basic LOOP that intends to print a counter from 1 to 5. Deliberately forget to include the EXIT condition or the counter 
-- increment. What is the pitfall? (You might need to manually stop execution in your SQL client). Then, correct the loop.
SET SERVEROUTPUT ON;
DECLARE
   counter NUMBER := 1;
BEGIN
   DBMS_OUTPUT.PUT_LINE('--- Infinite LOOP Pitfall (DO NOT RUN UNCONTROLLED) ---');
   LOOP
       DBMS_OUTPUT.PUT_LINE('Counter: ' || counter);
       -- counter := counter + 1; -- Increment forgotten
       -- EXIT WHEN counter > 5; -- Exit condition forgotten or flawed
   END LOOP;
END;
/

--      Exercise 2.5: SQL within PL/SQL - SELECT INTO with Multiple Rows
-- Problem: Write a PL/SQL block that attempts to use SELECT INTO to fetch lastName from the employees table where departmentId = 40 into a single scalar variable 
-- empLastName employees.lastName%TYPE. What is the pitfall? Handle the specific exception.
DECLARE
    empLastName employees.lastName%TYPE;
BEGIN
    SELECT lastName INTO empLastName 
    FROM PLSQLAWAKENING.EMPLOYEES 
    WHERE departmentId = 40; -- gives ORA-01422: exact fetch returned more than the requested number of rows
END;
/