        -- The Performance Symphony


-- 3. Contrasting with Inefficient Common Solutions

--      Exercise 3.1: Forcing a Plan with Hints vs. Robust Plan Management
-- Problem:
-- In the previous exercise (2.1), you identified that a TABLE ACCESS FULL would be better due to the stale statistics. A common, but often short-sighted, reaction is 
-- to force the better plan using a hint.
-- Using the state from the end of exercise 2.1 (large table, stale stats), modify the query to use the /*+ FULL(table_alias) */ hint to force a full table scan.
-- Examine the execution plan to confirm the hint worked.
EXPLAIN PLAN SET STATEMENT_ID = 'WITHOUT_GATHERED_STATISTICS' FOR
    SELECT /*+ FULL(e) */ * FROM PERFORMANCESYMPHONY.EMPLOYEES e WHERE SALARY > 10000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'WITHOUT_GATHERED_STATISTICS'));
-- Now, ROLLBACK or delete the large data load. The table is small again.
TRUNCATE TABLE PERFORMANCESYMPHONY.EMPLOYEES;
COMMIT;
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
SELECT * FROM PERFORMANCESYMPHONY.EMPLOYEES;
-- Execute the hinted query again on the small table.
EXPLAIN PLAN SET STATEMENT_ID = 'WITHOUT_GATHERED_STATISTICS' FOR
    SELECT /*+ FULL(e) */ * FROM PERFORMANCESYMPHONY.EMPLOYEES e WHERE SALARY > 10000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'WITHOUT_GATHERED_STATISTICS'));
-- Explain why the hinted query is now the inefficient common solution and what the Oracle-idiomatic, long-term solution is.
EXPLAIN PLAN SET STATEMENT_ID = 'WITHOUT_GATHERED_STATISTICS' FOR
    SELECT * FROM PERFORMANCESYMPHONY.EMPLOYEES e WHERE SALARY > 10000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'WITHOUT_GATHERED_STATISTICS'));
-- Answer: focing approaches is a hint when someone does not have enough context about a database, using the automatic ORACLE optimizer is the tool to be used by
-- design
-- Bridging from PostgreSQL: While PostgreSQL supports hints via extensions (like pg_hint_plan), they are not part of the core product and are often discouraged. 
-- Oracle has a long history with hints, but modern best practice, especially with 23ai, is to treat them as a temporary diagnostic tool, not a permanent fix. The 
-- idiomatic Oracle approach is to provide the optimizer with the best information (via statistics) and use features like SQL Plan Management to ensure stability.