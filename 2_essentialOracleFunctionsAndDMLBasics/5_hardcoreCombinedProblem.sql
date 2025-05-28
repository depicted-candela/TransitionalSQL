        -- Hardcore Combined Problem

-- Challenge: The Performance Recognition Initiative
-- Scenario:

-- The company is launching a "Performance Recognition Initiative" for Q1 2024. This initiative requires identifying top-performing non-managerial employees in 
-- specific departments based on their hire date and current salary, calculating a recognition payment, updating their records, and logging these changes. All 
-- DML operations must be part of a single, controlled transaction.

-- Eligibility Criteria for Recognition Payment:
-- Employee must have been hired on or before '2022-06-30'.
-- Employee must be in the 'Technology' (departmentId 10) or 'Sales' (departmentId 30) department.
-- Employee must not be a manager (i.e., their employeeId does not appear in the managerId column of any other employee).
-- Their current salary must be less than $90,000.
-- Their email must end with '@example.com'.

-- Recognition Payment Calculation:
-- Base Payment:
-- If jobTitle contains 'Developer' (case-insensitive): $2000.
-- If jobTitle contains 'Sales': $1500.
-- Otherwise: $1000.

-- Service Kicker (added to Base Payment):
-- MONTHS_BETWEEN(SYSDATE, hireDate) / 12 (number of full years of service) * $100.
-- The total calculated payment should be ROUNDed to the nearest dollar. This payment is a one-time bonus and does not change their salary. 
-- Instead, it should be recorded.

-- Tasks:
-- Pre-analysis (Set Operators & ROWNUM):
-- a. Using MINUS, identify employeeIds of all current non-managers.
-- b. Display the firstName, lastName, hireDate, and salary of the top 3 *longest-serving* (earliest hireDate) employees who meet all eligibility criteria 
-- (1, 2, 3, 4, 5). Use ROWNUM correctly.
-- Transactional Processing (DML & Transaction Control):
-- (For this part, you will likely need a PL/SQL block to manage the cursor, calculations, conditional DML, and overall transaction logic.)

DROP TABLE IF EXISTS ESSENTIAL_FUNCTIONS_DMLBASICS.TLS;
SAVEPOINT temp_table;
CREATE TABLE ESSENTIAL_FUNCTIONS_DMLBASICS.TLS (EMPLOYEEID NUMBER(3) PRIMARY KEY, FULLNAME CHARACTER(20), SERVICEYEARS NUMBER(4,2), SERVICEKICKER NUMBER(4));
INSERT INTO ESSENTIAL_FUNCTIONS_DMLBASICS.TLS (EMPLOYEEID, FULLNAME, SERVICEYEARS, SERVICEKICKER)
WITH NOT_MANAGERS AS (
    SELECT EMPLOYEEID FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES
        MINUS
    SELECT MANAGERID FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES
), CRITERIAS AS (
    SELECT
        DECODE(e.JOBTITLE, 'Developer', 2000, 'Sales', 1500, 1000) AS BASEPAYMENT,
        e.EMPLOYEEID, e.HIREDATE, TRIM(e.FIRSTNAME || ' ' || e.LASTNAME) AS FULLNAME
    FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES e
    WHERE EXISTS(SELECT 1 FROM NOT_MANAGERS nm WHERE e.EMPLOYEEID = nm.EMPLOYEEID)
        AND e.HIREDATE <= TO_DATE('2022-06-30', 'YYYY-MM-DD')
        AND e.DEPARTMENTID IN (10, 20) 
        AND e.SALARY < 90000 
        AND e.EMAIL LIKE '%@example.com'
), KICKED_SALARIES AS (
    SELECT ROUND(((MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12) * 100) + BASEPAYMENT) AS SERVICEKICKER, cr.EMPLOYEEID, cr.FULLNAME, cr.HIREDATE
    FROM CRITERIAS cr
), TOP_LONGEST_SERVING AS (
    SELECT ks.EMPLOYEEID, ks.SERVICEKICKER, ROUND(MONTHS_BETWEEN(SYSTIMESTAMP, ks.HIREDATE) / 12, 2) SERVICEYEARS, ks.FULLNAME FROM KICKED_SALARIES ks ORDER BY HIREDATE ASC FETCH NEXT 3 ROWS ONLY
)
SELECT EMPLOYEEID, FULLNAME, SERVICEYEARS, SERVICEKICKER FROM TOP_LONGEST_SERVING;
COMMIT;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.TLS;

-- Start a transaction. Create a savepoint named recognition_initiative_start.
SET AUTOCOMMIT OFF;
SAVEPOINT recognition_initiative_start;
-- For each employee meeting all eligibility criteria:
-- a. Calculate their total recognition payment using Oracle date functions (MONTHS_BETWEEN, SYSDATE), string functions (INSTR, LOWER for case-insensitive 
-- jobTitle check), NVL (if needed), and CASE expressions or PL/SQL IF statements. Remember to ROUND the final payment.
-- b. Update the employee's commissionPct. If their calculated recognition payment is greater than $1200, add 0.01 to their commissionPct. NVL should be used to 
-- treat an initial NULL commissionPct as 0. The commissionPct should not exceed 0.25.
MERGE INTO ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES e
USING ESSENTIAL_FUNCTIONS_DMLBASICS.TLS tls
ON (e.EMPLOYEEID = tls.EMPLOYEEID)
WHEN MATCHED THEN
    UPDATE SET e.COMMISSIONPCT = NVL(e.COMMISSIONPCT, 0) + 0.01 WHERE tls.SERVICEKICKER > 1200;
-- c. Insert a record into the AuditLog table.
-- tableName: 'Employees'
-- operationType: 'RECOGNIZE'
-- details (CLOB): A string like: 'Recognition: EmpID=XXX (Name: FirstName LastName), Payment=$PPP, NewCommPct=CCC, YearsSvc=YY.YY'. Use TO_CHAR for formatting 
-- numbers (payment to 2 decimal places, years of service to 2 decimal places). Concatenate firstName and lastName.

SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.TLS;
INSERT INTO ESSENTIAL_FUNCTIONS_DMLBASICS.AUDITLOG (TABLENAME, OPERATIONTYPE) VALUES ('Employees', 'RECOGNIZE', );
WITH c_logins AS (
    SELECT 
    CONCAT('Recognition: EmpID=', EMPLOYEEID, ' (Name: ', RTRIM(FULLNAME), '), Payment=$', SERVICEKICKER, ', NewCommPct=', COMMISSIONPCT, ', YearsSvc=', SERVICEYEARS) AS DETAILS
    FROM ESSENTIAL_FUNCTIONS_DMLBASICS.TLS NATURAL JOIN ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES
)

DECLARE 
BEGIN 
    SAVEPOINT audited_logs;
    FOR c_log IN (
        SELECT 
        CONCAT(
            'Recognition: EmpID=', EMPLOYEEID, 
            ' (Name: ', RTRIM(FULLNAME), 
            '), Payment=$', SERVICEKICKER, 
            ', NewCommPct=', COMMISSIONPCT, 
            ', YearsSvc=', SERVICEYEARS
        ) AS DETAILS
        FROM ESSENTIAL_FUNCTIONS_DMLBASICS.TLS NATURAL JOIN ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES
    ) LOOP
      INSERT INTO ESSENTIAL_FUNCTIONS_DMLBASICS.AUDITLOG (TABLENAME, OPERATIONTYPE, DETAILS) VALUES ('Employees', 'RECOGNIZE', c_log.DETAILS);
    END LOOP;
END;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.AUDITLOG;
-- After processing all eligible employees, if the total number of employees recognized is less than 1, ROLLBACK the transaction to recognition_initiative_start. 
DBMS_OUTPUT.PUT_LINE('Not necessary the final rollback because 2 employees were recognized');
-- Otherwise, COMMIT the transaction.
COMMIT;
-- Constraint Reminder: Focus on using concepts covered up to this point in the Oracle transitional course.