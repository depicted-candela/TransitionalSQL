        -- Stored Procedures & Functions


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise SP1: Problem: Create an Oracle stored procedure named addDepartment that accepts departmentId, departmentName, and location as IN parameters and 
-- inserts a new department into the departments table. Demonstrate invoking this procedure.
CREATE OR REPLACE PROCEDURE PLSQLPRECISION.ADDDEPARTMENT (
    deptId PLSQLPRECISION.DEPARTMENTS.departmentId%TYPE,
    deptName PLSQLPRECISION.DEPARTMENTS.departmentName%TYPE,
    deptLocation PLSQLPRECISION.DEPARTMENTS.LOCATION%TYPE
) AS 
BEGIN
    SAVEPOINT previous;
    INSERT INTO PLSQLPRECISION.DEPARTMENTS(DEPARTMENTID, DEPARTMENTNAME, LOCATION) VALUES (deptId, deptName, deptLocation);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' inserted rows');
    COMMIT;
EXCEPTION 
    WHEN OTHERS THEN 
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('The error "'||SQLERRM||'"" occurs');
END;
/

BEGIN
    PLSQLPRECISION.ADDDEPARTMENT(50, 'AS', 'Bogotá');   -- Fails with The error ORA-00001: unique constraint (PLSQLPRECISION.SYS_C008825) violated on table 
                                                        -- PLSQLPRECISION.DEPARTMENTS columns (DEPARTMENTID) occurs
    PLSQLPRECISION.ADDDEPARTMENT(100, 'AS', 'Bogotá');  -- Success and commit
END;
/

--      Exercise SP2: Problem: Create an Oracle stored function named getEmployeeFullName that takes an employeeId (IN parameter) and returns the employee's full 
--      name (firstName || ' ' || lastName) as a VARCHAR2. Demonstrate its use in a SELECT statement and a PL/SQL block.
CREATE OR REPLACE FUNCTION PLSQLPRECISION.GETEMPLOYEENAME (
    empId IN PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE
) RETURN VARCHAR2 AS 
    empFullName VARCHAR2(101);
BEGIN
    SELECT FIRSTNAME || ' ' || LASTNAME INTO empFullName
    FROM PLSQLPRECISION.EMPLOYEES WHERE EMPLOYEEID = empId;
    RETURN empFullName;
EXCEPTION
    WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found data');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error as '||SQLERRM);
END GETEMPLOYEENAME;
/

SELECT EMPLOYEEID, PLSQLPRECISION.GETEMPLOYEENAME(EMPLOYEEID) FROM PLSQLPRECISION.EMPLOYEES;

SET SERVEROUTPUT ON;
DECLARE
    empId PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE := 10;
    empFullName VARCHAR2(101);
BEGIN
    empFullName := PLSQLPRECISION.GETEMPLOYEENAME(empId);
    DBMS_OUTPUT.PUT_LINE('First full name '||empFullName);
EXCEPTION
    WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found data for employee id '||empId);
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error as '||SQLERRM||' for employee id '||empId);
END;
/

DECLARE
    empId PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE := 101;
    empFullName VARCHAR2(101);
BEGIN
    empFullName := PLSQLPRECISION.GETEMPLOYEENAME(empId);
    DBMS_OUTPUT.PUT_LINE('First full name '||empFullName);
EXCEPTION
    WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found data for employee id '||empId);
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error as '||SQLERRM);
END;
/

--      Exercise SP3: Problem: Create a procedure updateEmployeeJobAndGetOldJob that takes employeeId and a newJobId as IN parameters. It should update the employee's
-- jobId. The procedure must also return the employee's old jobId using an OUT parameter.
CREATE OR REPLACE PROCEDURE PLSQLPRECISION.UPDATEEMPLOYEEJOBANDGETOLDJOB (
    empId IN PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE,
    newJobId IN PLSQLPRECISION.EMPLOYEES.JOBID%TYPE,
    oldJobId OUT PLSQLPRECISION.EMPLOYEES.JOBID%TYPE
) AS
BEGIN
    SAVEPOINT previous;
    SELECT JOBID INTO OLDJOBID FROM PLSQLPRECISION.EMPLOYEES WHERE employeeId = empId;
    UPDATE PLSQLPRECISION.EMPLOYEES SET JOBID = newJobId WHERE employeeId = empId;
    DBMS_OUTPUT.PUT_LINE('Employee '||empId||' updated from job '||OLDJOBID||' to '||NEWJOBID);
    COMMIT;
EXCEPTION
    WHEN CASE_NOT_FOUND OR NO_DATA_FOUND 
        THEN 
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No data found for employee '||empId);
    WHEN TOO_MANY_ROWS 
        THEN
            ROLLBACK; 
            DBMS_OUTPUT.PUT_LINE('More than one row for the employee '||empId);
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error for employee '||empId);
END;
/

DECLARE
    empId PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE := 101;
    newJobId PLSQLPRECISION.EMPLOYEES.JOBID%TYPE := 'NEWJOB';
    oldJobId PLSQLPRECISION.EMPLOYEES.JOBID%TYPE;
BEGIN
    PLSQLPRECISION.UPDATEEMPLOYEEJOBANDGETOLDJOB(empId, newJobId, oldJobId);
    DBMS_OUTPUT.PUT_LINE('Old job is '||oldJobId);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error '||SQLERRM||' for employee '||empId);
END;
/

--      Exercise SP4: Problem: Create a procedure processSalary that takes an employeeId as an IN parameter and a currentSalary as an IN OUT parameter. The procedure 
-- should:
-- Fetch the employee's current salary into the IN OUT parameter.
-- If the fetched salary is less than 60000, increase the currentSalary (which is the IN OUT parameter) by 10% within the procedure.
-- The calling block should see the modified salary.
CREATE OR REPLACE PROCEDURE PLSQLPRECISION.PROCESSSALARY (
    empId IN PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE,
    currentSalary IN OUT PLSQLPRECISION.EMPLOYEES.SALARY%TYPE
) AS BEGIN
    SELECT SALARY INTO currentSalary FROM PLSQLPRECISION.EMPLOYEES WHERE EMPLOYEEID = empId;
    IF currentSalary < 60000 THEN currentSalary := currentSalary * 1.1;
    END IF;
EXCEPTION 
    WHEN CASE_NOT_FOUND OR NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Employee '||empId||' does not exists');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error ('||SQLERRM||') for employee '|| empId);
END;
/

DECLARE 
    currentSalary PLSQLPRECISION.EMPLOYEES.SALARY%TYPE;
BEGIN
    FOR x IN (SELECT * FROM PLSQLPRECISION.EMPLOYEES) LOOP
        currentSalary := x.SALARY;
        DBMS_OUTPUT.PUT_LINE('Process for employee '||x.EMPLOYEEID||' with salary '||currentSalary||' started');
        PLSQLPRECISION.PROCESSSALARY(x.EMPLOYEEID, currentSalary);
        DBMS_OUTPUT.PUT_LINE('New salary is '||currentSalary);
    END LOOP;
EXCEPTION 
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error ('||SQLERRM||')');
END;
/

SELECT EMPLOYEEID, PLSQLPRECISION.PROCESSSALARY(EMPLOYEEID, SALARY) FROM PLSQLPRECISION.EMPLOYEES;


--  (ii) Disadvantages and Pitfalls

--      Exercise SP5: Problem: A function is designed to calculate an annual bonus (10% of salary) but mistakenly attempts to perform an UPDATE statement inside it to
-- log the bonus calculation. Why is this problematic if the function is intended to be called from a SELECT query? 
-- Answer: if the function is to be used in a select statement, there is not space for the log to be represented
-- What Oracle error would occur?
-- Answer: ORA-14551: cannot perform a DML operation inside a query

--      Exercise SP6: Problem: A procedure has an OUT parameter. Inside the procedure, there's an IF-THEN-ELSIF structure. One of the ELSIF branches does not assign a 
-- value to the OUT parameter. 
-- What is the state of the OUT parameter in the calling environment if that branch is executed? 
-- Answer: NULL
-- How does this differ from an IN OUT parameter?
-- Answer: the value given in the IN side is returned


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise SP7: Problem: A developer needs to retrieve an employee's firstName and salary for a given employeeId. They create two separate functions: 
-- getEmpFirstName(p_id IN NUMBER) RETURN VARCHAR2 and getEmpSalary(p_id IN NUMBER) RETURN NUMBER. In their main PL/SQL block, they call these two functions 
-- sequentially for the same employeeId. Show this approach. Then, provide a more efficient Oracle-idiomatic solution using a single procedure with OUT parameters or 
-- a function returning a record type. Explain the inefficiency of the first approach.

-- Inefficient way
CREATE OR REPLACE FUNCTION PLSQLPRECISION.getEmpFirstName (
    pEmployeeId IN employees.employeeId%TYPE
) RETURN VARCHAR2 AS
    vFirstName employees.firstName%TYPE;
BEGIN
    SELECT firstName INTO vFirstName FROM PLSQLPRECISION.employees WHERE employeeId = pEmployeeId;
    RETURN vFirstName;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END getEmpFirstName;
/
CREATE OR REPLACE FUNCTION PLSQLPRECISION.getEmpSalary (
    pEmployeeId IN employees.employeeId%TYPE
) RETURN NUMBER AS
    vSalary employees.salary%TYPE;
BEGIN
    SELECT salary INTO vSalary FROM PLSQLPRECISION.employees WHERE employeeId = pEmployeeId;
    RETURN vSalary;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END getEmpSalary;
/

SET SERVEROUTPUT ON;
DECLARE
    vEmpId employees.employeeId%TYPE := 103;
    vFName employees.firstName%TYPE;
    vSal employees.salary%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Less Efficient Approach ---');
    vFName := PLSQLPRECISION.getEmpFirstName(vEmpId);
    vSal := PLSQLPRECISION.getEmpSalary(vEmpId);
    DBMS_OUTPUT.PUT_LINE('Employee: ' || vFName || ', Salary: ' || vSal);
END;
/

DECLARE     -- Explicit cursor example
    CURSOR fetcher IS (
        SELECT FIRSTNAME, LASTNAME, SALARY 
        FROM PLSQLPRECISION.EMPLOYEES 
        NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'IT'
    );
    TYPE fetching IS RECORD (
        FIRSTNAME PLSQLPRECISION.EMPLOYEES.FIRSTNAME%TYPE,
        LASTNAME PLSQLPRECISION.EMPLOYEES.LASTNAME%TYPE,
        SALARY PLSQLPRECISION.EMPLOYEES.SALARY%TYPE
    );
    fetchingData fetching;
BEGIN
    OPEN fetcher;
    LOOP
        FETCH fetcher INTO fetchingData;
        EXIT WHEN fetcher%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Row: ('||fetchingData.FIRSTNAME||', '||fetchingData.LASTNAME||', '||fetchingData.SALARY);
    END LOOP;
    CLOSE fetcher;
END;
/


-- Then, provide a more efficient Oracle-idiomatic solution using a single procedure with OUT parameters or 
-- a function returning a record type. Explain the inefficiency of the first approach.

-- Efficient ways
SET SERVEROUTPUT ON;            -- With declaration and type as record
SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PLSQLPRECISION.PROCEDURALOBJECT (
    empId PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE := 101,
    firstName OUT PLSQLPRECISION.EMPLOYEES.FIRSTNAME%TYPE,
    salary OUT PLSQLPRECISION.EMPLOYEES.SALARY%TYPE
) AS BEGIN
    SELECT firstName, salary 
    INTO firstName, salary 
    FROM PLSQLPRECISION.employees WHERE employeeId = empId;
    DBMS_OUTPUT.PUT_LINE('The extracted info is: SALARY('||salary||') and FIRSTNAME('||firstName||')');
EXCEPTION WHEN NO_DATA_FOUND OR CASE_NOT_FOUND THEN DBMS_OUTPUT.PUT_LINE('No data found');
END PROCEDURALOBJECT;
/

SET SERVEROUTPUT ON;
DECLARE
    globalId PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE := 101;
    TYPE functionalType IS RECORD (firstName PLSQLPRECISION.EMPLOYEES.FIRSTNAME%TYPE, salary PLSQLPRECISION.EMPLOYEES.SALARY%TYPE);
    functionalReturn functionalType;
    FUNCTION returnsEmployee (empId IN PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE) RETURN functionalType AS internalEmp functionalType;
    BEGIN 
        SELECT firstName, salary 
        INTO internalEmp.firstName, internalEmp.salary 
        FROM PLSQLPRECISION.employees 
        WHERE employeeId = empId;
        RETURN internalEmp;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
        WHEN OTHERS THEN RETURN NULL;
    END;
BEGIN
    functionalReturn := returnsEmployee(globalId);
    IF functionalReturn.firstName IS NULL OR functionalReturn.SALARY IS NULL 
    THEN DBMS_OUTPUT.PUT_LINE('NO data for id '||globalId);
    ELSE DBMS_OUTPUT.PUT_LINE('The salary for '||functionalReturn.firstName||' is '||functionalReturn.salary);
    END IF;
END;