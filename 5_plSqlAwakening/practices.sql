-- Basic Anonymous Block:
DECLARE
  message VARCHAR2(100);
  numValue NUMBER;
BEGIN
  message := 'Oracle PL/SQL is neat!';
  numValue := 10 * 5;
  DBMS_OUTPUT.PUT_LINE(message);
  DBMS_OUTPUT.PUT_LINE('Calculated Value: ' || numValue);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- Nested Blocks: Blocks can be nested within other blocks. Variables in an outer block are visible to inner blocks, unless an inner block redeclares them.
DECLARE
  outerVar VARCHAR2(30) := 'I am Outer';
BEGIN
  DBMS_OUTPUT.PUT_LINE('Outer Block: ' || outerVar);

  DECLARE
    innerVar VARCHAR2(30) := 'I am Inner';
    outerVar VARCHAR2(30) := 'Inner''s Outer'; -- Redeclares outerVar
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inner Block: ' || outerVar); -- Refers to inner's outerVar
    DBMS_OUTPUT.PUT_LINE('Inner Block: ' || innerVar);
    -- To access the original outerVar, you'd need to label the outer block
    -- and qualify: labelName.outerVar
  END;

  DBMS_OUTPUT.PUT_LINE('Outer Block again: ' || outerVar); -- Refers to original outerVar
END;
/


-- Scalar Variable Declaration and Assignment:
DECLARE
  employeeName VARCHAR2(100);
  hireYear NUMBER(4);
  isActive BOOLEAN; -- Oracle 23ai BOOLEAN
  hourlyRate NUMBER(5,2) := 25.50; -- Initialization
BEGIN
  employeeName := 'John Doe';
  hireYear := 2023;
  isActive := FALSE;

  DBMS_OUTPUT.PUT_LINE('Employee: ' || employeeName);
  DBMS_OUTPUT.PUT_LINE('Hired: ' || hireYear || ', Active: ' || CASE WHEN isActive THEN 'Yes' ELSE 'No' END);
  DBMS_OUTPUT.PUT_LINE('Rate: ' || hourlyRate);

  -- Oracle 23ai: SELECT without FROM for simple expressions
  -- hourlyRate := (SELECT hourlyRate * 1.1); -- If supported directly for assignment
  -- Or older way for expression assignment:
  SELECT hourlyRate * 1.1 INTO hourlyRate FROM DUAL; 
  DBMS_OUTPUT.PUT_LINE('New Rate: ' || hourlyRate);
END;
/


-- Using %TYPE: Ensures variable type matches a column or another variable.
DECLARE
  empLastName plsqlawakeninglecture.employees.lastName%TYPE;
  empSalary plsqlawakeninglecture.employees.salary%TYPE;
  empId NUMBER := 101;
BEGIN
  SELECT lastName, salary
  INTO empLastName, empSalary
  FROM plsqlawakeninglecture.employees
  WHERE employeeId = empId;

  DBMS_OUTPUT.PUT_LINE('Employee: ' || empLastName || ', Salary: ' || empSalary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' not found.');
END;
/


-- Using %ROWTYPE
DECLARE
  empRecord plsqlawakeninglecture.employees%ROWTYPE;
  empId NUMBER := 101;
BEGIN
  SELECT *
  INTO empRecord
  FROM plsqlawakeninglecture.employees
  WHERE employeeId = empId;

  DBMS_OUTPUT.PUT_LINE('Employee: ' || empRecord.lastName || ', Salary: ' || empRecord.salary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' not found.');
END;
/


-- Constant Declaration:
DECLARE
  PI CONSTANT NUMBER := 3.14159;
  SITE_NAME CONSTANT VARCHAR2(50) := 'My Awesome App';
  MAX_LOGIN_ATTEMPTS CONSTANT PLS_INTEGER := 3;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Value of PI: ' || PI);
  DBMS_OUTPUT.PUT_LINE('Welcome to ' || SITE_NAME);
  DBMS_OUTPUT.PUT_LINE('Max login attempts ' || MAX_LOGIN_ATTEMPTS);
--   PI := 3.14; -- This would cause a compile-time error
END;
/


-- IF-THEN-ELSIF-ELSE Statement:
DECLARE
  employeesalary plsqlawakeninglecture.employees.salary%TYPE;
  performanceRating VARCHAR2(10) := 'Good'; -- Could be 'Excellent', 'Good', 'Average'
  empId NUMBER := 101;
BEGIN
  SELECT salary INTO employeesalary FROM plsqlawakeninglecture.employees WHERE employeeId = empId;
  IF performanceRating = 'Excellent' THEN
    employeesalary := employeesalary * 1.10; -- 10% raise
    DBMS_OUTPUT.PUT_LINE('Excellent performance! New salary: ' || employeesalary);
  ELSIF performanceRating = 'Good' THEN
    employeesalary := employeesalary * 1.05; -- 5% raise
    DBMS_OUTPUT.PUT_LINE('Good performance. New salary: ' || employeesalary);
  ELSE
    employeesalary := employeesalary * 1.02; -- 2% raise
    DBMS_OUTPUT.PUT_LINE('Standard review. New salary: ' || employeesalary);
  END IF;
END;
/


-- CONTROL

-- CASE Statement (Selector Form):
DECLARE
  grade CHAR(1) := 'B';
  remarks VARCHAR2(50);
BEGIN
  CASE grade
    WHEN 'A' THEN remarks := 'Outstanding!';
    WHEN 'B' THEN remarks := 'Very Good.';
    WHEN 'C' THEN remarks := 'Satisfactory.';
    WHEN 'D' THEN remarks := 'Needs Improvement.';
    ELSE remarks := 'Grade not recognized.';
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Grade ' || grade || ': ' || remarks);
END;
/

-- CASE Statement (Searched Form):
DECLARE
  itemPrice NUMBER := 150;
  discountRate NUMBER;
BEGIN
  CASE
    WHEN itemPrice > 200 THEN discountRate := 0.15;
    WHEN itemPrice > 100 AND itemPrice <= 200 THEN discountRate := 0.10;
    WHEN itemPrice > 50  AND itemPrice <= 100 THEN discountRate := 0.05;
    ELSE discountRate := 0;
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Item Price: ' || itemPrice || ', Discount Rate: ' || (discountRate*100) || '%');
END;
/

-- CASE Expression:
DECLARE
  employeeCount NUMBER;
  companySize VARCHAR2(10);
BEGIN
  SELECT COUNT(*) INTO employeeCount FROM plsqlawakeninglecture.employees;
  companySize := CASE
                   WHEN employeeCount > 1000 THEN 'Large'
                   WHEN employeeCount > 100  THEN 'Medium'
                   ELSE 'Small'
                 END;
  DBMS_OUTPUT.PUT_LINE('Number of Employees: ' || employeeCount || ', Company Size: ' || companySize);
END;
/


---- LOOPS

-- Basic LOOP with EXIT WHEN:
DECLARE
  counter NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Basic Loop - Iteration: ' || counter);
    EXIT WHEN counter > 2;
    counter := counter + 1;
  END LOOP;
END;
/

-- WHILE LOOP:
DECLARE
  counter NUMBER := 1;
  maxIterations NUMBER := 3;
BEGIN
  WHILE counter < maxIterations + 1 LOOP
    DBMS_OUTPUT.PUT_LINE('WHILE Loop - Iteration: ' || counter);
    counter := counter + 1;
  END LOOP;
END;
/

-- Numeric FOR LOOP:
BEGIN
  FOR i IN 1..3 LOOP -- i is implicitly declared as PLS_INTEGER
    DBMS_OUTPUT.PUT_LINE('FOR Loop - Iteration: ' || i);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- Reverse ---');
  FOR j IN REVERSE 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE('FOR Loop (Reverse) - Iteration: ' || j);
  END LOOP;
END;
/


---- SQL within PL/SQL

-- Implicit SELECT INTO:
DECLARE
  empFirstName employees.firstName%TYPE;
  empLastName  employees.lastName%TYPE;
  targetEmpId  NUMBER := 101;
BEGIN
  SELECT firstName, lastName
  INTO empFirstName, empLastName
  FROM plsqlawakeninglecture.employees
  WHERE employeeId = targetEmpId;

  DBMS_OUTPUT.PUT_LINE('Employee ' || targetEmpId || ': ' || empFirstName || ' ' || empLastName);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || targetEmpId || ' not found.');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Error: Query returned multiple rows for employee ' || targetEmpId);
END;
/

-- DML Operations (INSERT, UPDATE, DELETE):
DECLARE
  newDeptId departments.departmentId%TYPE := 99;
  newDeptName departments.departmentName%TYPE := 'Innovation';
  rowsAffected NUMBER;
BEGIN
  -- INSERT
  INSERT INTO plsqlawakeninglecture.departments (departmentId, departmentName, location)
  VALUES (newDeptId, newDeptName, 'Remote');
  rowsAffected := SQL%ROWCOUNT; -- Attribute for DML
  DBMS_OUTPUT.PUT_LINE('INSERTed ' || rowsAffected || ' row(s).');
  COMMIT;

  -- UPDATE
  UPDATE plsqlawakeninglecture.departments
  SET location = 'Global Remote'
  WHERE departmentId = newDeptId;
  rowsAffected := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('UPDATEd ' || rowsAffected || ' row(s).');
  COMMIT;

  -- DELETE
  DELETE FROM plsqlawakeninglecture.departments
  WHERE departmentId = newDeptId;
  rowsAffected := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('DELETEd ' || rowsAffected || ' row(s).');
  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Error: Department ID ' || newDeptId || ' already exists.');
    ROLLBACK;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An SQL error occurred: ' || SQLERRM);
    ROLLBACK;
END;
/


---- 3.6 DBMS_OUTPUT.PUT_LINE

-- SET SERVEROUTPUT ON SIZE 1000000; -- Enable and set buffer size

DECLARE
  currentAction VARCHAR2(100) := 'Initializing Process';
  itemCount PLS_INTEGER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Starting script execution.');
  DBMS_OUTPUT.PUT_LINE('Current Action: ' || currentAction);

  FOR i IN 1..5 LOOP
    itemCount := itemCount + i;
    DBMS_OUTPUT.PUT_LINE('Loop iteration ' || i || ', itemCount is now: ' || itemCount);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Process completed. Final itemCount: ' || itemCount);
END;
/