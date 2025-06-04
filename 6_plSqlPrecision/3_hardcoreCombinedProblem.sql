        -- Combined - Cursors and Stored Procedures & Functions

        
--  (iv) Hardcore Combined Problem

-- Problem: Create a PL/SQL stored procedure named processDepartmentRaises with the following requirements:
-- Parameters:
--  pDepartmentName (IN VARCHAR2): The name of the department to process.
--  pRaisePercentage (IN NUMBER): The percentage to increase salaries by (e.g., 5 for 5%).
--  pDepartmentBudget (IN NUMBER): The maximum total amount that can be added to salaries in this department for this raise cycle.
--  pEmployeesUpdatedCount (OUT NUMBER): The number of employees whose salaries were actually updated.
--  pStatusMessage (OUT VARCHAR2): A message indicating success, "Over budget", "No employees found", "Department not found", or other errors.
CREATE OR REPLACE PROCEDURE PLSQLPRECISION.processDepartmentRaises (
    pDepartmentName IN VARCHAR2, 
    pRaisePercentage IN NUMBER, 
    pDepartmentBudget IN NUMBER, 
    pEmployeesUpdatedCount OUT NUMBER,
    pStatusMessage OUT VARCHAR2 
) AS 
BEGIN
    DECLARE
        iDeptId PLSQLPRECISION.DEPARTMENTS.DEPARTMENTID%TYPE;
        CURSOR deptEmps (deptId PLSQLPRECISION.EMPLOYEES.EMPLOYEEID%TYPE) IS (
            SELECT * FROM PLSQLPRECISION.EMPLOYEES 
            NATURAL JOIN PLSQLPRECISION.DEPARTMENTS 
            WHERE DEPARTMENTID = deptId
        );
        totalRaiseCostForDepartment NUMBER(20,2) := 0;
    BEGIN
        SELECT DEPARTMENTID INTO iDeptId
        FROM PLSQLPRECISION.DEPARTMENTS 
        WHERE DEPARTMENTNAME = pDepartmentName;

        IF SQL%NOTFOUND THEN RETURN; END IF;
        
        SAVEPOINT afterSalary;
        pEmployeesUpdatedCount := 0;
        FOR x IN deptEmps(iDeptId) LOOP
            totalRaiseCostForDepartment := totalRaiseCostForDepartment + x.salary * pRaisePercentage/100;
            pEmployeesUpdatedCount := pEmployeesUpdatedCount + 1;
        END LOOP;
        IF pEmployeesUpdatedCount = 0 
            THEN pStatusMessage := 'EMPLOYEES NOT FOUND'; 
        ELSIF totalRaiseCostForDepartment > pDepartmentBudget
            THEN ROLLBACK TO afterSalary;
            pStatusMessage := 'EXCEEDED BUDGET';
        ELSE
            pStatusMessage := 'SUCCESS';
            COMMIT;
        END IF;
    END;
EXCEPTION
    WHEN NO_DATA_FOUND THEN pStatusMessage := 'DEPARTMENT NOT FOUND';
    WHEN OTHERS THEN pStatusMessage := SQLERRM;
END;
/

DECLARE
    pEmployeesUpdatedCount NUMBER;
    pStatusMessage VARCHAR2(50);
BEGIN
    PLSQLPRECISION.PROCESSDEPARTMENTRAISES('on', 30, 100000, pEmployeesUpdatedCount, pStatusMessage);
    DBMS_OUTPUT.PUT_LINE('Status Message: ' || pStatusMessage);
    DBMS_OUTPUT.PUT_LINE('Employees Updated: ' || pEmployeesUpdatedCount);
END;
/
-- Logic:
--  The procedure should first find the departmentId for the given pDepartmentName. If not found, set an appropriate pStatusMessage and exit.
--  Establish a SAVEPOINT before attempting any salary updates for the department.
--  Use an explicit cursor to iterate through all employees belonging to the found departmentId.
-- For each employee:
--  Calculate the raiseAmount.
--  Calculate the newSalary.
--  Keep a running totalRaiseCostForDepartment.
-- After iterating:
--  If no employees were found, set status.
--  If totalRaiseCostForDepartment > pDepartmentBudget, ROLLBACK to savepoint, set status.
-- Otherwise, iterate again (or use stored data) to UPDATE salaries, log each update to salaryAudit (you can use a helper private procedure), count updates, set
-- status, and COMMIT.
-- Handle unexpected errors gracefully.