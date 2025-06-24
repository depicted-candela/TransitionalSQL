        -- The Performance Symphony


--  4. Hardcore Combined Problem

--      Exercise 4.1: The Consultant's Challenge
-- Problem:
-- You are a consultant tasked with optimizing a critical reporting query at an e-commerce company. The query identifies all IT and Sales managers and their 
-- direct/indirect reports. The query's performance is unacceptable.

-- The problematic query:
SELECT LPAD(' ', (LEVEL-1)*2) || e.lastName as employee, e.jobId, d.departmentName
FROM PERFORMANCESYMPHONY.employees e, PERFORMANCESYMPHONY.departments d
WHERE e.departmentId = d.departmentId
START WITH e.jobId IN ('IT_PROG', 'SA_MAN')
CONNECT BY PRIOR e.employeeId = e.managerId;
-- Your Task:
-- Initial Diagnosis: Gather initial statistics on the tables. Run the query and generate its execution plan using DBMS_XPLAN.DISPLAY_CURSOR. Analyze the plan, paying 
-- special attention to the join methods and any findings in the SQL Analysis Report. What are the immediate problems you can spot?
BEGIN DBMS_STATS.GATHER_SCHEMA_STATS(ownname => 'PERFORMANCESYMPHONY'); END;
/
EXPLAIN PLAN SET STATEMENT_ID = 'INEFFICIENT_HIERARCHIZATION' FOR
SELECT LPAD(' ', (LEVEL-1)*2) || e.lastName as employee, e.jobId, d.departmentName
FROM PERFORMANCESYMPHONY.employees e, PERFORMANCESYMPHONY.departments d
WHERE e.departmentId = d.departmentId
START WITH e.jobId IN ('IT_PROG', 'SA_MAN')
CONNECT BY PRIOR e.employeeId = e.managerId;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'INEFFICIENT_HIERARCHIZATION', FORMAT => 'ALL'));
-- Hypothesize and Test: The query joins employees and departments. Looking at the plan from Step 1, you see a specific join method (e.g., HASH JOIN). Given the 
-- hierarchical nature, you suspect a NESTED LOOPS join might be better. Use the /*+ USE_NL(e d) */ hint to test this theory. Generate the new plan. Is it better?
EXPLAIN PLAN SET STATEMENT_ID = 'HIERARCHIZATION_NESTING_LOOPS' FOR
SELECT /*+ USE_NL(d e) */ LPAD(' ', (LEVEL-1)*2) || e.lastName as employee, e.jobId, d.departmentName
FROM PERFORMANCESYMPHONY.departments d, PERFORMANCESYMPHONY.employees e
WHERE e.departmentId = d.departmentId
START WITH e.jobId IN ('IT_PROG', 'SA_MAN')
CONNECT BY PRIOR e.employeeId = e.managerId;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'HIERARCHIZATION_NESTING_LOOPS', FORMAT => 'ALL'));
-- It's tremendously worst by 88.74% in costs because despite departments is small and employees is big, an index for employees does not exist
-- Why might this not be a good permanent solution?
-- Answer: included to the absence of an index, the number of departments grows to a singificant size, the nested loops as procedure tends to be worst than the hash 
-- join procedure
-- The Proper Fix: After a discussion with the business, you learn a massive new-hire event just concluded, primarily in the Sales department. Your statistics are now 
-- stale. Simulate this by updating the manager for 500 sales reps. Now, gather fresh statistics on the employees table. Re-run the original, un-hinted query and 
-- examine its new plan. How has the CBO's strategy changed now that it has accurate information?

-- Step 1: Simulate the data change.
-- We update 500 employees with the job ID 'SA_REP' who do not currently have a manager.
-- They will now report to the Sales Manager (employeeId 2004, jobId 'SA_MAN').
-- This directly impacts the hierarchical structure that the query traverses.
PROMPT Updating manager for 500 sales reps...
UPDATE performanceSymphony.employees
SET managerId = 2004
WHERE jobId = 'SA_REP'
  AND managerId IS NULL
  AND ROWNUM <= 500;
COMMIT;
PROMPT Update complete. 500 employees now report to the Sales Manager.
-- Step 2: Gather fresh table statistics.
-- With the data significantly changed, the old statistics are misleading.
-- We gather new statistics on the 'employees' table so the Cost-Based Optimizer (CBO)
-- is aware of the new data distribution.
PROMPT Gathering fresh statistics for the EMPLOYEES table...
BEGIN DBMS_STATS.GATHER_SCHEMA_STATS(ownname => 'PERFORMANCESYMPHONY'); END;
/
PROMPT Statistics gathering complete.
EXPLAIN PLAN SET STATEMENT_ID = 'WITH_UPDATE' FOR
SELECT LPAD(' ', (LEVEL-1)*2) || e.lastName as employee, e.jobId, d.departmentName
FROM PERFORMANCESYMPHONY.employees e, PERFORMANCESYMPHONY.departments d
WHERE e.departmentId = d.departmentId
START WITH e.jobId IN ('IT_PROG', 'SA_MAN')
CONNECT BY PRIOR e.employeeId = e.managerId;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(STATEMENT_ID => 'WITH_UPDATE', FORMAT => 'ALL'));
-- Long-Term Stability with 23ai's Philosophy: To prevent future performance regressions for this critical query, use Oracle's SQL Plan Management. Execute the query 
-- with the good plan so it's in the cursor cache. Then, use DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE to create a SQL Plan Baseline, capturing this known-good plan. 
-- Explain how this provides a more robust, long-term solution than hard-coded hints.