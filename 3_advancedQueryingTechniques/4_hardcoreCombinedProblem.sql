        -- Hardcore Combined Problem
        
-- Scenario: The company is conducting an annual review. You need to perform a series of operations to update employee records and generate reports. Use a PL/SQL anonymous block to manage the MERGE operation and its commit/rollback, and ensure you create a baseline copy of the Employees table named EmployeesOriginal before the MERGE.

--      Propose Changes & MERGE:
-- Within a CTE named ProposedChanges, calculate new salaries and emails for employees.
-- Tenure: Calculate tenureYears using MONTHS_BETWEEN and SYSDATE.
-- Ranking: Determine salaryRankInDept using DENSE_RANK() OVER().
-- Departmental Averages: Calculate avgSalaryDept using AVG() OVER().
-- Salary Adjustments (New Salary Calculation Logic within the CTE):
-- Rule 1: If salaryRankInDept is 1 AND tenureYears > 3, give a 7% raise.
-- Rule 2: If current salary < 60% of avgSalaryDept AND tenureYears > 1, raise salary to the GREATER of (current salary * 1.05) OR (60% of avgSalaryDept). 
-- Round results.
-- Rule 3 (Simplified LAG use): If an employee's current salary is less than 90% of the salary of the person ranked immediately above 
-- them in salary within the same department (use LAG ordering by salary ascending to find this) AND this employee is NOT a direct 
-- report of the CEO (employeeId 100), AND they are not already covered by Rule 1, give a 3% raise.
-- Employees not meeting any of these conditions retain their current salary.
-- New Email: Generate a newEmail in the format: lowercase(firstinitial + lastname + '@megacorp.com'). Use string functions like SUBSTR,
-- INSTR, LOWER, and concatenation.

-- Use a MERGE statement to update the Employees table with newSalary and newEmail from the ProposedChanges CTE. Only perform an UPDATE
-- if the newSalary or newEmail is actually different from the current values.
-- Commit the changes after the MERGE. Handle potential exceptions within the PL/SQL block with a ROLLBACK.
-- Post-Adjustment Reporting (after the MERGE is committed):

SET AUTOCOMMIT OFF;

SAVEPOINT previous;

DROP TABLE IF EXISTS ADVANCED_QUERYING.EMPLOYEE_ANALYSIS_DATA;

CREATE TABLE ADVANCED_QUERYING.EMPLOYEE_ANALYSIS_DATA (
    PREVIOUSDEPARTMENTALSALARY NUMBER,
    FIRSTNAME                  VARCHAR2(50 CHAR), -- CHAR for character semantics
    LASTNAME                   VARCHAR2(50 CHAR),
    LOWERNAME                  VARCHAR2(100 CHAR),
    TENUREYEARS                NUMBER(7,2), -- e.g., 184.47 (5 total, 2 decimal) -> (5+2 = 7, 2)
    AVGSALARYDEPT              NUMBER(12,2),-- e.g., 138333.33 (8 total, 2 decimal) -> (8+2=10, 2) but allow for larger
    SALARYRANKINDEPT           NUMBER,
    CLEANNAME                  VARCHAR2(100 CHAR),
    NAMESEP                    NUMBER,
    EMPLOYEEID                 NUMBER NOT NULL,
    EMPLOYEENAME               VARCHAR2(100 CHAR),
    JOBTITLE                   VARCHAR2(100 CHAR),
    MANAGERID                  NUMBER,
    HIREDATE                   DATE,
    SALARY                     NUMBER(10,2), -- Assuming salary might have cents, or just NUMBER for whole values
    DEPARTMENTID               NUMBER,
    EMAIL                      VARCHAR2(255 CHAR),
    NEWSALARY                  NUMBER(10,2), -- Assuming new salary might have cents
    NEWMAIL                    VARCHAR2(255 CHAR),
    UPDATED                    BOOLEAN,
    CONSTRAINT PK_EMPLOYEE_ANALYSIS_DATA PRIMARY KEY (EMPLOYEEID)
);

INSERT INTO ADVANCED_QUERYING.EMPLOYEE_ANALYSIS_DATA (
    PREVIOUSDEPARTMENTALSALARY,
    FIRSTNAME,
    LASTNAME,
    LOWERNAME,
    TENUREYEARS,
    AVGSALARYDEPT,
    SALARYRANKINDEPT,
    CLEANNAME,NAMESEP,
    EMPLOYEEID,EMPLOYEENAME,
    JOBTITLE,MANAGERID,HIREDATE,
    SALARY, DEPARTMENTID,EMAIL,NEWSALARY,NEWMAIL,UPDATED
)
WITH AGGREGATIONS AS (
    SELECT 
        ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE), 2) TENUREYEARS,
        ROUND(AVG(SALARY) OVER(PARTITION BY DEPARTMENTID), 2) AVGSALARYDEPT,
        DENSE_RANK() OVER(PARTITION BY DEPARTMENTID ORDER BY SALARY) SALARYRANKINDEPT,
        TRIM(EMPLOYEENAME) CLEANNAME,
        INSTR(TRIM(EMPLOYEENAME), ' ', 1) NAMESEP,
        E.*
    FROM ADVANCED_QUERYING.EMPLOYEES E
), LAGGED_SALARIES AS (
    SELECT 
        LAG(SALARY) OVER(PARTITION BY DEPARTMENTID ORDER BY SALARYRANKINDEPT) PREVIOUSDEPARTMENTALSALARY,
        SUBSTR(CLEANNAME, 0, NAMESEP - 1) FIRSTNAME,
        SUBSTR(CLEANNAME, NAMESEP + 1, LENGTH(CLEANNAME) - 1) LASTNAME,
        LOWER(CONCAT(SUBSTR(CLEANNAME, 0, NAMESEP - 1), SUBSTR(CLEANNAME, NAMESEP + 1, LENGTH(CLEANNAME)))) LOWERNAME,
        A.*
    FROM AGGREGATIONS A
), PROPOSEDCHANGES AS (
    SELECT 
        A.*, 
        CASE 
            WHEN A.SALARYRANKINDEPT = 1 AND A.TENUREYEARS > 3 THEN A.SALARY * 1.07
            WHEN A.SALARY < 0.6 * A.AVGSALARYDEPT AND A.TENUREYEARS > 1
                THEN CASE 
                    WHEN A.SALARY * 1.05 > A.AVGSALARYDEPT * 0.6 THEN A.SALARY * 1.05
                    ELSE A.AVGSALARYDEPT * 0.6
                END
            WHEN NVL(A.PREVIOUSDEPARTMENTALSALARY, 0) * 0.9 < A.SALARY AND A.MANAGERID <> 100 THEN A.SALARY * 1.03 
            ELSE A.SALARY
        END NEWSALARY,
        CONCAT(A.LOWERNAME, '@megacorp.com') NEWMAIL,
        CASE 
            WHEN A.SALARYRANKINDEPT = 1 AND A.TENUREYEARS > 3 THEN TRUE
            WHEN A.SALARY < 0.6 * A.AVGSALARYDEPT AND A.TENUREYEARS > 1 THEN TRUE
            WHEN NVL(A.PREVIOUSDEPARTMENTALSALARY, 0) * 0.9 < A.SALARY AND A.MANAGERID <> 100 THEN TRUE
            ELSE FALSE
        END UPDATED
    FROM LAGGED_SALARIES A
)
SELECT PREVIOUSDEPARTMENTALSALARY,
    FIRSTNAME,
    LASTNAME,
    LOWERNAME,
    TENUREYEARS,
    AVGSALARYDEPT,
    SALARYRANKINDEPT,
    CLEANNAME,NAMESEP,
    EMPLOYEEID,EMPLOYEENAME,
    JOBTITLE,MANAGERID,HIREDATE,SALARY,
    DEPARTMENTID,EMAIL,NEWSALARY,NEWMAIL,UPDATED
FROM PROPOSEDCHANGES;

SELECT * FROM ADVANCED_QUERYING.EMPLOYEE_ANALYSIS_DATA;

MERGE INTO ADVANCED_QUERYING.EMPLOYEES e
USING ADVANCED_QUERYING.EMPLOYEE_ANALYSIS_DATA p
ON (e.EMPLOYEEID = p.EMPLOYEEID)
WHEN MATCHED THEN UPDATE SET e.SALARY = p.NEWSALARY, e.EMAIL = p.NEWMAIL;

SELECT * FROM ADVANCED_QUERYING.EMPLOYEES;

COMMIT;

--      Tech Hierarchy: Display a hierarchical report for the 'Technology' department (departmentId 10). Show indented employee name, job title, their new salary, 
-- and their level in the hierarchy (LEVEL). Use START WITH for top managers in Tech and CONNECT BY PRIOR.
SELECT * FROM (
    SELECT LEVEL AS l, E.*, CONNECT_BY_ROOT MANAGERID MANAGER_OF_MANAGER, CONNECT_BY_ISLEAF
    FROM ADVANCED_QUERYING.EMPLOYEES E
    WHERE DEPARTMENTID = 10
    START WITH MANAGERID IS NULL OR MANAGERID = 100
    CONNECT BY PRIOR EMPLOYEEID = MANAGERID
) ORDER BY l, HIREDATE;
--      Top 2 Earners: List the top 2 highest-paid employees (name, department name, salary) per department after the adjustments. Use ROW_NUMBER() OVER().
SELECT * FROM (
SELECT e.*, 
ROW_NUMBER() OVER(PARTITION BY DEPARTMENTID ORDER BY SALARY) unique_rank FROM ADVANCED_QUERYING.EMPLOYEES e
) WHERE unique_rank < 3 ORDER BY DEPARTMENTID, UNIQUE_RANK;
--      Unchanged Salaries: Using the EmployeesOriginal table and the updated Employees table, list the employeeId, employeeName, and originalSalary of employees 
-- whose salary did not change during the MERGE operation. Remember to drop the EmployeesOriginal table at the end of your script.
SELECT * FROM ADVANCED_QUERYING.EMPLOYEE_ANALYSIS_DATA WHERE UPDATED;

DROP TABLE IF EXISTS ADVANCED_QUERYING.EMPLOYEE_ANALYSIS_DATA;
--      Concepts Integrated:
-- Current: CONNECT BY, LEVEL, START WITH, PRIOR, RANK/DENSE_RANK/ROW_NUMBER, LAG, SUM() OVER, AVG() OVER, MERGE.
-- Previous Oracle: PL/SQL anonymous block, CREATE TABLE AS SELECT, TO_DATE, SYSDATE, MONTHS_BETWEEN, NVL, CASE, LOWER, SUBSTR, INSTR, || (concat), MINUS (conceptually for comparison, direct join/where for implementation).
-- Foundational PostgreSQL (mirrored in Oracle): CTEs (WITH), Joins, Aggregates, WHERE, ORDER BY.