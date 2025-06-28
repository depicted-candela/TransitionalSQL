        -- Future of Oracle: SQL Innovations in 23ai


--  (iv) Hardcore Combined Problem
-- This final problem requires you to integrate all the concepts from this module into a single, multi-step solution.

-- Hardcore Problem Description
-- You are performing a year-end data analysis and cleanup. The process involves several steps which must be executed within a single atomic transaction.

-- Setup: Create an audit log table named future.hcAuditLog with a single logData VARCHAR2(200) column, but only if it doesn't already exist.
CREATE TABLE IF NOT EXISTS FUTURE.HCAUDITLOG (logData VARCHAR2(200));
-- Budget Analysis: Calculate a potential 5% budget increase for all projects. This requires a simple calculation without referencing any tables.
SELECT 1.05 budgetIncrease;
-- Project Duration Analysis: Calculate the average duration of all completed projects. The result should be an INTERVAL type.
SELECT AVG(ENDDATE - STARTDATE) AVERAGEDURATION FROM FUTURE.HCPROJECTS WHERE ENDDATE <= SYSDATE;
-- Quarterly Activity: Group all projects by the quarter in which they started to see how many projects kick off each quarter. Use TIME_BUCKET and alias the bucket as 
-- startQuarter. Use this alias in your GROUP BY clause.
-- Before running, ensure server output is enabled in your SQL client
-- SET SERVEROUTPUT ON;

DECLARE
    v_budgetIncrease    NUMBER;
    v_minimumYear       NUMBER;
    v_firstdayofminyear TIMESTAMP;
BEGIN
    SELECT 1.05 budgetIncrease INTO v_budgetIncrease;
    DBMS_OUTPUT.PUT_LINE('budget increase: ' || v_budgetIncrease);
    SELECT MIN(EXTRACT(YEAR FROM STARTDATE))
    INTO v_minimumYear
    FROM FUTURE.HCPROJECTS;
    v_firstdayofminyear := TO_TIMESTAMP(v_minimumYear || '-01-01', 'YYYY-MM-DD');
    -- Print the calculated values for verification
    DBMS_OUTPUT.PUT_LINE('The minimum year is: ' || v_minimumYear);
    DBMS_OUTPUT.PUT_LINE('The constructed timestamp origin is: ' || v_firstdayofminyear);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Quarterly Project Counts:');
    FOR rec IN (
        SELECT
            TIME_BUCKET(STARTDATE, INTERVAL '3' MONTH, v_firstdayofminyear) AS quarterlyStarted,
            COUNT(*) AS projects
        FROM
            FUTURE.HCPROJECTS
        GROUP BY
            TIME_BUCKET(STARTDATE, INTERVAL '3' MONTH, v_firstdayofminyear)
        ORDER BY
            quarterlyStarted -- Order the results chronologically
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Quarter Start: ' || TO_CHAR(rec.quarterlyStarted, 'YYYY-MM-DD') ||
            ', Projects: ' || rec.projects
        );
    END LOOP;
END;
/
-- Bonus Pool Creation: Create a temporary, inline view of employees and their base bonus using the VALUES clause.
SELECT EMPLOYEEID, FIRSTNAME||' '||LASTNAME, SALARY * v_budgetIncrease BONUS FROM FUTURE.EMPLOYEES;

SELECT EMPLOYEEID, FIRSTNAME||' '||LASTNAME FULLNAME, SALARY * 1.05 BASEBONUS FROM FUTURE.EMPLOYEES 
UNION ALL
SELECT EMPLOYEEID, FULLNAME, BASEBONUS FROM (VALUES(1, 'John Doe', 5000), (2, 'Jane Smith', 5500)) d(EMPLOYEEID, FULLNAME, BASEBONUS);
-- Include John Doe (ID 1, bonus 5000) and Jane Smith (ID 2, bonus 5500).
-- Update with Join: The 'Innovation' department has secured extra funding. Update the salary of all active employees in this department by 10%.
DECLARE
    TYPE auditingLogT IS TABLE OF VARCHAR2(200);
    auditingLog auditingLogT;
BEGIN
    UPDATE FUTURE.hcEmployees 
    SET SALARY = SALARY * 1.1 
    WHERE DEPARTMENTID = (SELECT DEPARTMENTID FROM FUTURE.HCDEPARTMENTS WHERE DEPARTMENTNAME = 'Innovation')
    RETURNING 'Employee ['||EMPLOYEEID||'] salary is now ['||SALARY * 1.1||'] auditingLog' BULK COLLECT INTO auditingLog; 
    FORALL i IN INDICES OF auditingLog
        INSERT INTO FUTURE.HCAUDITLOG(logData) VALUES(auditingLog(i));
END;
/

COMMIT;
-- Log the Update: As you perform the update in step 6, use the RETURNING clause to capture a string for each updated row, formatted as 
-- 'Employee [ID] salary is now [NEW]', and insert these strings into your hcAuditLog table.
-- Decommission: The 'Logistics' department is being dissolved. Delete all employees belonging to this department from the hcEmployees table.
DELETE FROM FUTURE.HCEMPLOYEES WHERE EMPLOYEEID = (SELECT EMPLOYEEID FROM FUTURE.HCEMPLOYEES NATURAL JOIN FUTURE.HCDEPARTMENTS WHERE DEPARTMENTNAME = 'Logistics');
COMMIT;