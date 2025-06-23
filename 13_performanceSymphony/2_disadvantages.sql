        -- The Performance Symphony


--  2. Disadvantages and Pitfalls

--      Exercise 2.1: The Pitfall of Stale Statistics
-- Problem:
-- An application's performance has suddenly degraded. The query in question retrieves ACTIVE employees with a high salary. Initially, the table had very few such 
-- employees, but after a large data load, the number has increased dramatically. The statistics have not been updated.
-- Delete the existing employees data. Insert a small, initial set of data where only 2 employees have a salary > 10000.
TRUNCATE TABLE PERFORMANCESYMPHONY.EMPLOYEES;
-- Populating the employees table with a small, initial dataset
-- Requirement: Only 2 employees have a salary > 10000
INSERT ALL
  INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, hireDate)
    VALUES (100, 'Steven', 'King', 'SKING', 'AD_PRES', 24000.00, NULL, 90, TO_DATE('17-JUN-2003', 'DD-MON-YYYY'))
  INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, hireDate)
    VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', 'AD_VP', 17000.00, 100, 90, TO_DATE('21-SEP-2005', 'DD-MON-YYYY'))
  INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, hireDate)
    VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', 'IT_PROG', 9000.00, 102, 60, TO_DATE('03-JAN-2006', 'DD-MON-YYYY'))
  INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, hireDate)
    VALUES (104, 'Bruce', 'Ernst', 'BERNST', 'IT_PROG', 6000.00, 103, 60, TO_DATE('21-MAY-2007', 'DD-MON-YYYY'))
  INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, hireDate)
    VALUES (114, 'Den', 'Raphaely', 'DRAPHEALY', 'PU_MAN', 9500.00, 100, 30, TO_DATE('07-DEC-2002', 'DD-MON-YYYY'))
  INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, status, hireDate)
    VALUES (124, 'Kevin', 'Mourgos', 'KMOURGOS', 'ST_MAN', 5800.00, 100, 50, 'INACTIVE', TO_DATE('16-NOV-2007', 'DD-MON-YYYY'))
SELECT 1 FROM DUAL;
COMMIT;

CREATE INDEX idxEmpSalary ON employees(salary);
-- Gather statistics on this small table.
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'PERFORMANCESYMPHONY',
        tabname => 'EMPLOYEES'
    );
END;
/
-- Now, simulate a large data load by inserting 50,000 new employees, all with salaries > 10000. Do not regather statistics.
INSERT INTO PERFORMANCESYMPHONY.EMPLOYEES (
    employeeId,
    firstName,
    lastName,
    email,
    jobId,
    salary,
    managerId,
    departmentId,
    hireDate
)
SELECT
    200000 + LEVEL AS employeeId,
    'FN' || TO_CHAR(200000 + LEVEL) AS firstName,
    'LN' || TO_CHAR(200000 + LEVEL) AS lastName,
    'USER' || TO_CHAR(200000 + LEVEL) AS email,
    -- Distribute new employees across a few job roles
    CASE MOD(LEVEL, 4)
        WHEN 0 THEN 'SA_REP'
        WHEN 1 THEN 'ST_CLERK'
        WHEN 2 THEN 'IT_PROG'
        ELSE 'MK_REP'
    END AS jobId,
    -- Generate a random salary between 10,001 and 25,000
    ROUND(DBMS_RANDOM.VALUE(10001, 25000), 2) AS salary,
    -- Assign them to one of the existing managers
    CASE MOD(LEVEL, 3)
        WHEN 0 THEN 101
        WHEN 1 THEN 114
        ELSE 100
    END AS managerId,
    -- Assign them to an existing department
    CASE MOD(LEVEL, 4)
        WHEN 0 THEN 30
        WHEN 1 THEN 50
        WHEN 2 THEN 60
        ELSE 90
    END AS departmentId,
    -- Generate a random hire date within the last 5 years
    SYSDATE - DBMS_RANDOM.VALUE(1, 365 * 5) AS hireDate
FROM DUAL
CONNECT BY LEVEL <= 50000;
COMMIT;

-- Run a query to select all employees with salary > 10000.
SELECT * FROM PERFORMANCESYMPHONY.EMPLOYEES WHERE SALARY > 10000;
-- Examine the execution plan. Explain why the optimizer chose this plan and why it is now a major performance pitfall.
EXPLAIN PLAN SET STATEMENT_ID = 'WITHOUT_GATHERED_STATISTICS' FOR
    SELECT * FROM PERFORMANCESYMPHONY.EMPLOYEES WHERE SALARY > 10000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'WITHOUT_GATHERED_STATISTICS'));
-- This exercise illustrates one of the most common causes of sudden performance degradation in real-world systems. Relying on outdated information leads the optimizer 
-- to make poor, costly decisions.
-- Answer: the optimizer does not know how to take the better decisions because statistics about table size are outdated, thus the optimizer does not know if it's
-- necessary or not to use the index on SALARY