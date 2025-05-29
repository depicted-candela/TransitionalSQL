        -- Hierarchical Queries (Oracle Specific)


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise HQ.1.1: Basic Employee Hierarchy
-- Problem: Display the complete organizational hierarchy. For each employee, show their ID, name, job title, manager's ID, and their 
-- level in the hierarchy. The top-level manager(s) should be at LEVEL 1. Indent the employee names based on their level for readability.
-- Bridging Focus: PostgreSQL users would typically use a WITH RECURSIVE CTE for this. Demonstrate the Oracle CONNECT BY syntax as a 
-- more concise alternative for this common task.
-- Concepts: START WITH, CONNECT BY PRIOR, LEVEL, LPAD (for formatting).
SELECT 
    LEVEL, JOBTITLE, MANAGERID,
    EMPLOYEEID, LPAD(' ', LEVEL*2) || EMPLOYEENAME INDENTED_NAME
FROM ADVANCED_QUERYING.EMPLOYEES
START WITH MANAGERID IS NULL
CONNECT BY PRIOR EMPLOYEEID = MANAGERID;

--      Exercise HQ.1.2: Subordinates of a Specific Manager
-- Problem: List all direct and indirect subordinates of 'John Smith' (employeeId 101). Include their employee ID, name, job title, and
-- their level relative to John Smith (John Smith being effectively level 0 for his own sub-hierarchy, his direct reports level 1, etc.).
-- Concepts: START WITH (specific employee), CONNECT BY, LEVEL.
SELECT LEVEL - 1, EMPLOYEEID, EMPLOYEENAME, JOBTITLE
FROM ADVANCED_QUERYING.EMPLOYEES 
START WITH EMPLOYEEID = 101 
CONNECT BY PRIOR EMPLOYEEID = MANAGERID;


--  (ii) Disadvantages and Pitfalls

--      Exercise HQ.2.1: Handling Cycles in Data
-- Problem: Introduce a cyclical management relationship (e.g., Bob Green manages Carol White, and Carol White manages Bob Green). 
-- Then, attempt to query the hierarchy. Observe the error. Finally, use NOCYCLE and CONNECT_BY_ISCYCLE to handle and identify the cycle.
-- Remember to restore the data to its original state after this exercise.
-- Concepts: Cycles, ORA-01436: CONNECT BY loop in user data, NOCYCLE, CONNECT_BY_ISCYCLE.
SET AUTOCOMMIT OFF;
SAVEPOINT wihtout_cycles;
UPDATE ADVANCED_QUERYING.EMPLOYEES SET MANAGERID = 104 WHERE EMPLOYEEID = 103;
UPDATE ADVANCED_QUERYING.EMPLOYEES SET MANAGERID = 103 WHERE EMPLOYEEID = 104;

SELECT * FROM ADVANCED_QUERYING.EMPLOYEES 
WHERE EMPLOYEEID IN (103, 104);

SELECT LEVEL, e.*                       -- This generates the expected result
FROM ADVANCED_QUERYING.EMPLOYEES e
START WITH MANAGERID = 103
CONNECT BY PRIOR EMPLOYEEID =  MANAGERID;

SELECT LEVEL, e.*                       -- This avoids cycles with NOCYCLE as an adjective of the hierarchized comparison logic
FROM ADVANCED_QUERYING.EMPLOYEES e
START WITH MANAGERID = 103
CONNECT BY NOCYCLE PRIOR EMPLOYEEID =  MANAGERID;

SELECT LEVEL, CONNECT_BY_ISCYCLE, e.*   -- Here is represented the search up to the first level in cycles, thus the fix must be done
FROM ADVANCED_QUERYING.EMPLOYEES e      -- for all those cycles of first level and then iterate recursively or iteratively as necessary
START WITH MANAGERID = 103              -- to solve the cycles found
CONNECT BY NOCYCLE PRIOR EMPLOYEEID = MANAGERID;

ROLLBACK;


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise HQ.3.1: Finding All Subordinates - Efficient vs. Inefficient
-- Problem: Retrieve all direct and indirect subordinates for 'John Smith' (employeeId 101).
-- First, describe (pseudo-code or conceptual) how one might do this inefficiently using multiple self-joins or a procedural loop (common for those unfamiliar 
-- with hierarchical queries).
-- Then, write the efficient Oracle CONNECT BY query.
-- Concepts: CONNECT BY efficiency vs. iterative/multi-join approaches.
-- Answer: the self-join solution must be done starting with EMPLOYEEID = 101 and then nesting up to the end, the problem here is that if its not known
-- how many self joins are necessary the N + 1 will not the only problem, also could be dramatical hard for the engineer to know how many times needs to
-- copy the self joins if the nesting is significantly big
-- In the other case, the engineer does not need to copy all such times the same self join but the code for a PL/SQL loop is significantly bigger
SELECT * 
FROM ADVANCED_QUERYING.EMPLOYEES            -- This clever alternative soves the N+1 problem as is hihgly simplified
START WITH EMPLOYEEID = 101
CONNECT BY PRIOR EMPLOYEEID = MANAGERID;