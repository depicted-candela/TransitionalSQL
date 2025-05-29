<style>
    body {
        font-family: 'Oracle Sans', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.65;
        color: #e0e0e0; /* Soft white text */
        background-color: #1a1a24; /* Deep blue-black background */
        margin: 0;
        padding: 20px;
        background-image: radial-gradient(circle at 10% 20%, #2a2a3a 0%, transparent 20%),
                        radial-gradient(circle at 90% 80%, #2a2a3a 0%, transparent 20%);
        transition: all 0.3s ease-in-out;
    }
    
    .container {
        max-width: 950px;
        margin: auto;
        background-color: #252535; /* Slightly lighter than body */
        padding: 35px;
        border-radius: 6px;
        box-shadow: 0 4px 30px rgba(0, 0, 30, 0.5);
        border: 1px solid #3a3a4a; /* Subtle border */
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .container:hover {
        box-shadow: 0 6px 35px rgba(0, 80, 150, 0.3);
    }
    
    h1, h2, h3 {
        color: #4db8ff; /* Oracle brand blue */
        font-weight: 500;
        letter-spacing: 0.5px;
        transition: color 0.2s ease;
    }
    
    h1 {
        border-bottom: 2px solid #ff8c00; /* Oracle accent orange */
        padding-bottom: 12px;
        font-size: 2.6em;
        text-align: center;
        margin-bottom: 30px;
        text-shadow: 0 2px 4px rgba(0, 100, 200, 0.2);
    }
    
    h2 {
        font-size: 1.9em;
        margin-top: 35px;
        border-left: 4px solid #4db8ff;
        padding-left: 15px;
    }
    
    h3 {
        font-size: 1.5em;
        color: #6bd4ff; /* Lighter blue for h3 */
    }
    
    p, li {
        font-size: 1.05em;
        margin-bottom: 12px;
        color: #d0d0e0; /* Slightly brighter text */
    }
    
    code {
        font-family: 'Oracle Mono', 'Consolas', 'Monaco', monospace;
        background-color: #1e1e2e; /* Dark blue-gray */
        padding: 3px 8px;
        border-radius: 4px;
        font-size: 0.95em;
        color: #f0f0f0;
        border: 1px solid #3a3a5a;
        transition: all 0.2s ease;
    }
    
    code:hover {
        background-color: #252540;
    }
    
    pre {
        background-color: #1e1e2e;
        padding: 18px;
        border-radius: 6px;
        overflow-x: auto;
        border: 1px solid #3a3a5a;
        box-shadow: inset 0 1px 10px rgba(0, 0, 0, 0.3);
        transition: all 0.3s ease;
    }
    
    pre:hover {
        border-color: #4db8ff;
        box-shadow: inset 0 1px 15px rgba(0, 100, 200, 0.2);
    }
    
    pre code {
        background-color: transparent;
        padding: 0;
        border-radius: 0;
        font-size: 0.92em;
        border: none;
        color: #f0f0f0;
    }
    
    /* Oracle-themed boxes */
    .info-box, .tip-box, .objective-box, .sql-box {
        padding: 18px 20px;
        margin: 25px 0;
        border-radius: 6px;
        border-left: 5px solid;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .info-box {
        background-color: rgba(0, 100, 150, 0.1);
        border-color: #4db8ff; /* Oracle blue */
    }
    
    .info-box h3 {
        color: #4db8ff;
        margin-top: 0;
    }
    
    .tip-box {
        background-color: rgba(255, 140, 0, 0.08);
        border-color: #ff8c00; /* Oracle orange */
    }
    
    .tip-box h3 {
        color: #ff8c00;
        margin-top: 0;
    }
    
    .objective-box {
        background-color: rgba(0, 150, 100, 0.08);
        border-color: #00c176; /* Oracle green */
    }
    
    .objective-box h3 {
        color: #00c176;
        margin-top: 0;
    }
    
    .sql-box {
        background-color: rgba(77, 184, 255, 0.05);
        border-color: #4db8ff;
        border-left-width: 8px;
    }
    
    .sql-box h3 {
        color: #4db8ff;
        margin-top: 0;
    }
    
    .sql-box pre {
        background-color: rgba(0, 0, 0, 0.2);
    }
    
    .highlight-primary {
        color: #4db8ff;
        font-weight: 500;
        text-shadow: 0 0 8px rgba(77, 184, 255, 0.3);
    }
    
    .highlight-secondary {
        color: #ff8c00;
        font-weight: 500;
    }
    
    .emphasize {
        font-style: italic;
        color: #6bd4ff; /* Light Oracle blue */
        border-bottom: 1px dotted #6bd4ff;
        padding-bottom: 1px;
    }
    
    a {
        color: #4db8ff;
        text-decoration: none;
        transition: all 0.2s ease;
        font-weight: 500;
    }
    
    a:hover {
        color: #6bd4ff;
        text-decoration: underline;
        text-shadow: 0 0 8px rgba(77, 184, 255, 0.3);
    }
    
    /* Special Oracle SQL elements */
    .sql-keyword {
        color: #ff8c00; /* Oracle orange for keywords */
        font-weight: bold;
    }
    
    .sql-function {
        color: #6bd4ff; /* Light blue for functions */
    }
    
    .sql-comment {
        color: #7f7f9f; /* Gray for comments */
        font-style: italic;
    }
    
    /* Smooth scroll behavior */
    html {
        scroll-behavior: smooth;
    }
    
    /* Fade-in animation for content */
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .container > * {
        animation: fadeIn 0.5s ease-out forwards;
    }
</style>

<div class="container">

# Exercise Solutions: Advanced Oracle SQL

This document provides concise solutions to the exercises on Hierarchical Queries, Analytic Functions, and the `MERGE` statement. For full problem descriptions and dataset setup, please refer to the main exercise document.

<div class="rhyme">
The problems posed, the challenge met,<br>
Here lie the answers, clearly set.
</div>

</div>

<div class="container">

## Category: Hierarchical Queries (Oracle Specific)

### (i) Meanings, Values, Relations, and Advantages

**Solution HQ.1.1: Basic Employee Hierarchy**
```sql
SELECT
    LEVEL AS hierarchyLevel,
    LPAD(' ', (LEVEL - 1) * 4) || employeeName AS indentedName,
    employeeId,
    jobTitle,
    managerId,
    PRIOR employeeName AS managerName
FROM Employees
START WITH managerId IS NULL
CONNECT BY PRIOR employeeId = managerId
ORDER SIBLINGS BY employeeName;
```
*   **Explanation:** `START WITH` identifies root nodes. `CONNECT BY PRIOR` defines parent-child links. `LEVEL` shows depth. `PRIOR employeeName` fetches the manager's name from the parent row in the hierarchy. `ORDER SIBLINGS BY` sorts nodes at the same level.

**Solution HQ.1.2: Subordinates of a Specific Manager**
```sql
-- Subordinates of John Smith (employeeId 101), excluding John Smith
SELECT
    LEVEL -1 AS relativeLevel, -- Adjust level if John Smith is "level 0" for his team
    employeeId,
    employeeName,
    jobTitle
FROM Employees
START WITH employeeId = 101 -- Start with John Smith
CONNECT BY PRIOR employeeId = managerId
WHERE employeeId != 101 -- Exclude John Smith himself
ORDER BY relativeLevel, employeeName;

-- Alternative: John Smith included as level 1 of his own "sub-hierarchy"
SELECT
    LEVEL AS levelWithinSubtree,
    employeeId,
    employeeName,
    jobTitle
FROM Employees
START WITH employeeId = 101
CONNECT BY PRIOR employeeId = managerId
ORDER SIBLINGS BY employeeName;
```
*   **Explanation:** `START WITH employeeId = 101` begins traversal at John Smith. `LEVEL` is relative to this start. Filter with `WHERE employeeId != 101` if the starting person should be excluded.

### (ii) Disadvantages and Pitfalls

**Solution HQ.2.1: Handling Cycles in Data**
```sql
-- 1. Create a cycle (ensure employeeId 103 and 104 exist)
UPDATE Employees SET managerId = 104 WHERE employeeId = 103; -- Bob reports to Carol
UPDATE Employees SET managerId = 103 WHERE employeeId = 104; -- Carol reports to Bob (CYCLE!)
COMMIT;

-- 2. Query that would fail (ORA-01436)
-- SELECT employeeId, LEVEL FROM Employees START WITH managerId IS NULL CONNECT BY PRIOR employeeId = managerId;

-- 3. Query with NOCYCLE to prevent error and ISCYCLE to identify cycle members
SELECT
    employeeId,
    LPAD(' ', (LEVEL-1)*2) || employeeName AS empName,
    managerId,
    LEVEL,
    CONNECT_BY_ISCYCLE AS isCycleMarker -- 1 if this row closes a cycle
FROM Employees
START WITH employeeId IN (100, 101, 102, 103, 104) -- Start from various points to see effect
CONNECT BY NOCYCLE PRIOR employeeId = managerId
ORDER SIBLINGS BY employeeName;

-- 4. Restore data
UPDATE Employees SET managerId = 102 WHERE employeeId = 103; -- Bob Green reports to Alice Brown
UPDATE Employees SET managerId = 102 WHERE employeeId = 104; -- Carol White reports to Alice Brown
COMMIT;
```
*   **Explanation:** Cycles cause `ORA-01436`. `NOCYCLE` allows the query to run by not re-visiting nodes in a path. `CONNECT_BY_ISCYCLE` flags rows that would have completed a cycle.

### (iii) Contrasting with Inefficient Common Solutions

**Solution HQ.3.1: Finding All Subordinates - Efficient vs. Inefficient**
*   **Inefficient (Conceptual):** Multiple `SELECT` statements (one for each level) or a PL/SQL loop fetching children recursively. This involves many database calls or context switches.
*   **Efficient Oracle `CONNECT BY` Solution:**
```sql
-- Subordinates of John Smith (101), excluding John Smith
SELECT
    employeeId,
    employeeName,
    jobTitle,
    LEVEL - 1 AS depthFromJohnSmith
FROM Employees
START WITH employeeId = 101 -- Start with John Smith
CONNECT BY PRIOR employeeId = managerId
WHERE employeeId != 101 -- Exclude John Smith himself
ORDER BY depthFromJohnSmith, employeeName;
```
*   **Explanation:** `CONNECT BY` is a single, optimized SQL operation for hierarchies, far more efficient than iterative approaches for set-based retrieval.

</div>

<div class="container">

## Category: Analytic (Window) Functions

### (i) Meanings, Values, Relations, and Advantages

**Solution AF.1.1: Employee Ranking by Salary**
```sql
SELECT
    d.departmentName,
    e.employeeName,
    e.salary,
    ROW_NUMBER() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC, e.employeeId) AS rn,
    RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS denseRnk
FROM Employees e
JOIN Departments d ON e.departmentId = d.departmentId
ORDER BY d.departmentName, e.salary DESC;
```
*   **Explanation:** `PARTITION BY` divides data (by department). `ORDER BY` sorts within partitions (by salary). `ROW_NUMBER` is unique. `RANK` skips ranks after ties. `DENSE_RANK` doesn't skip ranks.

**Solution AF.1.2: Salary Comparison with Previous/Next Hired Employee**
```sql
SELECT
    d.departmentName,
    e.employeeName,
    e.hireDate,
    e.salary,
    LAG(e.employeeName, 1, 'N/A') OVER (PARTITION BY e.departmentId ORDER BY e.hireDate, e.employeeId) AS prevEmpName,
    LAG(e.salary, 1, 0) OVER (PARTITION BY e.departmentId ORDER BY e.hireDate, e.employeeId) AS prevEmpSalary,
    LEAD(e.employeeName, 1, 'N/A') OVER (PARTITION BY e.departmentId ORDER BY e.hireDate, e.employeeId) AS nextEmpName,
    LEAD(e.salary, 1, 0) OVER (PARTITION BY e.departmentId ORDER BY e.hireDate, e.employeeId) AS nextEmpSalary
FROM Employees e
JOIN Departments d ON e.departmentId = d.departmentId
ORDER BY d.departmentName, e.hireDate, e.employeeId;
```
*   **Explanation:** `LAG` accesses previous row's data, `LEAD` accesses next row's data within the partition, ordered by hire date. `employeeId` in `ORDER BY` handles tie-breaking for determinism.

**Solution AF.1.3: Running Total and Department Average Salary**
```sql
SELECT
    d.departmentName,
    e.employeeName,
    e.hireDate,
    e.salary,
    SUM(e.salary) OVER (PARTITION BY e.departmentId ORDER BY e.hireDate, e.employeeId ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runningTotalSalary,
    AVG(e.salary) OVER (PARTITION BY e.departmentId) AS departmentAvgSalary,
    SUM(e.salary) OVER (PARTITION BY e.departmentId) AS departmentTotalSalary
FROM Employees e
JOIN Departments d ON e.departmentId = d.departmentId
ORDER BY d.departmentName, e.hireDate, e.employeeId;
```
*   **Explanation:** `SUM(...) OVER (PARTITION BY ... ORDER BY ...)` calculates running total. `AVG(...) OVER (PARTITION BY ...)` calculates average for the partition. `SUM(...) OVER (PARTITION BY ...)` (no `ORDER BY`) gives total for partition.

### (ii) Disadvantages and Pitfalls

**Solution AF.2.1: Misinterpreting Ranking Functions**
```sql
SELECT
    d.departmentName,
    e.employeeName,
    e.salary,
    ROW_NUMBER() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC, e.employeeId) AS rn,
    RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS denseRnk
FROM Employees e
JOIN Departments d ON e.departmentId = d.departmentId
WHERE d.departmentName = 'Sales'
ORDER BY d.departmentName, e.salary DESC;
```
*   **Explanation:** For Sales Reps Grace (60k) and Henry (60k):
    *   `ROW_NUMBER`: Assigns unique numbers (e.g., 3, 4). Can be misleading for "tiers".
    *   `RANK`: Both get rank 3. Next rank would be 5 (if another distinct salary existed). Shows tier but has gaps.
    *   `DENSE_RANK`: Both get rank 3. Next rank would be 4. Best for sequential tier identification.
    *   **Pitfall:** Choosing the wrong function can lead to incorrect business interpretation (e.g., for bonuses).

**Solution AF.2.2: Impact of `PARTITION BY` and `ORDER BY`**
```sql
-- 1. Partitioned by department, ordered by hire date
SELECT employeeName, departmentId, hireDate, salary,
       LAG(salary, 1, 0) OVER (PARTITION BY departmentId ORDER BY hireDate, employeeId) AS lagSalaryDeptOrdered
FROM Employees ORDER BY departmentId, hireDate, employeeId;

-- 2. No partition, ordered by hire date globally
SELECT employeeName, departmentId, hireDate, salary,
       LAG(salary, 1, 0) OVER (ORDER BY hireDate, employeeId) AS lagSalaryGlobalOrdered
FROM Employees ORDER BY hireDate, employeeId;

-- 3. LAG/LEAD require ORDER BY. SUM() for demonstration:
-- ORA-30487 if ORDER BY is missing for LAG/LEAD:
-- SELECT LAG(salary, 1, 0) OVER (PARTITION BY departmentId) FROM Employees;

SELECT employeeName, departmentId, salary,
       SUM(salary) OVER (PARTITION BY departmentId) AS totalSalaryInDept, -- Sum for the partition
       SUM(salary) OVER () AS totalSalaryAllDepts, -- Sum for entire table
       SUM(salary) OVER (PARTITION BY departmentId ORDER BY hireDate, employeeId) AS runningTotalInDept -- Running sum
FROM Employees ORDER BY departmentId, hireDate, employeeId;
```
*   **Explanation:**
    *   `LAG/LEAD/RANK/ROW_NUMBER` *require* `ORDER BY` in the `OVER()` clause.
    *   Missing/incorrect `PARTITION BY` changes the window of calculation (e.g., global vs. per department).
    *   Missing/incorrect `ORDER BY` changes the meaning of "previous", "next", or ranking.
    *   For aggregates like `SUM()`, `ORDER BY` in `OVER()` creates a running/cumulative aggregate; without it, it's over the whole partition.

### (iii) Contrasting with Inefficient Common Solutions

**Solution AF.3.1: Calculating Rank - Efficient vs. Inefficient**
*   **Inefficient (Conceptual Correlated Subquery for DENSE_RANK):**
    ```sql
    -- SELECT e1.employeeName, d.departmentName, e1.salary,
    -- (SELECT COUNT(DISTINCT e2.salary) + 1
    --  FROM Employees e2
    --  WHERE e2.departmentId = e1.departmentId AND e2.salary > e1.salary) AS salaryRankInefficient
    -- FROM Employees e1 JOIN Departments d ON e1.departmentId = d.departmentId;
    ```
*   **Efficient Analytic Function Solution:**
```sql
SELECT
    e.employeeName,
    d.departmentName,
    e.salary,
    DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS salaryRankEfficient
FROM Employees e
JOIN Departments d ON e.departmentId = d.departmentId
ORDER BY d.departmentName, e.salary DESC;
```
*   **Explanation:** Correlated subquery runs for each row, very slow. Analytic functions process partitions efficiently in a single pass.

</div>

<div class="container">

## Category: Data Manipulation Language (DML) & Transaction Control

### (i) Meanings, Values, Relations, and Advantages

**Solution DML.1.1: Basic UPSERT with MERGE**
```sql
-- Verify initial state if needed
-- SELECT employeeId, jobTitle, salary, email FROM Employees WHERE employeeId IN (103, 501);

MERGE INTO Employees TGT
USING (
    SELECT employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email
    FROM EmployeeUpdates
    WHERE employeeId IN (103, 501) -- Bob Green (update), Nina Young (insert)
) SRC
ON (TGT.employeeId = SRC.employeeId)
WHEN MATCHED THEN
    UPDATE SET
        TGT.jobTitle = SRC.jobTitle,
        TGT.salary = SRC.salary,
        TGT.email = SRC.email
    -- Optional WHERE for update: TGT.jobTitle != SRC.jobTitle OR TGT.salary != SRC.salary ...
WHEN NOT MATCHED THEN
    INSERT (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
    VALUES (SRC.employeeId, SRC.employeeName, SRC.jobTitle, SRC.managerId, SRC.hireDate, SRC.salary, SRC.departmentId, SRC.email);

-- SELECT employeeId, jobTitle, salary, email FROM Employees WHERE employeeId IN (103, 501); -- Verify
-- DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows merged.');
ROLLBACK;
```
*   **Explanation:** `MERGE` combines `UPDATE` and `INSERT`. `USING` defines source. `ON` is the join. `WHEN MATCHED` for updates, `WHEN NOT MATCHED` for inserts.

**Solution DML.1.2: MERGE with Conditional Update and Delete**
```sql
-- Add record for deletion
INSERT INTO EmployeeUpdates (employeeId, changeReason) VALUES (104, 'Obsolete Role'); -- Carol White
COMMIT;

MERGE INTO Employees TGT
USING (
    SELECT eu.employeeId, eu.employeeName, eu.jobTitle, eu.salary, eu.email, eu.changeReason
    FROM EmployeeUpdates eu
    WHERE eu.employeeId IN (203, 104) -- Grace (conditional update), Carol (delete)
) SRC
ON (TGT.employeeId = SRC.employeeId)
WHEN MATCHED THEN
    UPDATE SET -- This clause is processed first if conditions met
        TGT.jobTitle = SRC.jobTitle,
        TGT.salary = SRC.salary,
        TGT.email = SRC.email
    WHERE
        SRC.employeeId = 203 AND SRC.salary > TGT.salary -- Update Grace only if new salary is higher
                                                        -- AND SRC.changeReason != 'Obsolete Role' (implicit if delete is separate or after)
    DELETE WHERE -- This clause can follow an update clause for the same matched row
        SRC.changeReason = 'Obsolete Role' AND TGT.employeeId = SRC.employeeId;


-- SELECT employeeId, jobTitle, salary FROM Employees WHERE employeeId IN (203, 104); -- Verify
-- DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows affected by MERGE.');
ROLLBACK;
DELETE FROM EmployeeUpdates WHERE employeeId = 104 AND changeReason = 'Obsolete Role';
COMMIT;
```
*   **Explanation:** `UPDATE` clause has its own `WHERE` for conditional updates. `DELETE WHERE` within `WHEN MATCHED` removes target rows based on source/target conditions.

### (ii) Disadvantages and Pitfalls

**Solution DML.2.1: Non-Deterministic Source for MERGE**
```sql
-- 1. Attempt MERGE with non-deterministic source (employeeId 105 has two rows in EmployeeUpdates)
-- This will raise ORA-30926:
-- MERGE INTO Employees TGT
-- USING (SELECT employeeId, salary FROM EmployeeUpdates WHERE employeeId = 105) SRC
-- ON (TGT.employeeId = SRC.employeeId)
-- WHEN MATCHED THEN UPDATE SET TGT.salary = SRC.salary;

-- 2. Corrected MERGE using ROW_NUMBER() to ensure deterministic source
MERGE INTO Employees TGT
USING (
    SELECT employeeId, salary FROM (
        SELECT eu.employeeId, eu.salary,
               ROW_NUMBER() OVER(PARTITION BY eu.employeeId ORDER BY eu.changeReason DESC) as rn -- Pick one
        FROM EmployeeUpdates eu
        WHERE eu.employeeId = 105
    )
    WHERE rn = 1 -- Guarantees one source row for employeeId 105
) SRC
ON (TGT.employeeId = SRC.employeeId)
WHEN MATCHED THEN
    UPDATE SET TGT.salary = SRC.salary
    WHERE TGT.salary IS NULL OR TGT.salary != SRC.salary; -- Only update if different or target is null

-- SELECT employeeId, salary FROM Employees WHERE employeeId = 105; -- Verify
-- DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows merged after fixing source.');
ROLLBACK;
```
*   **Explanation:** `ORA-30926` occurs if a target row matches multiple source rows. Fix by ensuring the `USING` clause provides unique rows per target join key, e.g., via aggregation or `ROW_NUMBER()`.

### (iii) Contrasting with Inefficient Common Solutions

**Solution DML.3.1: Synchronizing Data - MERGE vs. Procedural Logic**
*   **Inefficient (Conceptual):** Separate `IF EXISTS THEN UPDATE ELSE INSERT` PL/SQL block or multiple SQL statements. Less efficient due to context switching or multiple passes.
*   **Efficient Oracle `MERGE` Solution:**
```sql
MERGE INTO Employees TGT
USING (
    SELECT employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email
    FROM EmployeeUpdates
    WHERE employeeId IN (204, 501) -- Henry Wilson (match, salary no change), Nina Young (no match)
) SRC
ON (TGT.employeeId = SRC.employeeId)
WHEN MATCHED THEN
    UPDATE SET
        TGT.salary = SRC.salary, -- For Henry, 60000 = 60000
        TGT.jobTitle = COALESCE(SRC.jobTitle, TGT.jobTitle),
        TGT.email = COALESCE(SRC.email, TGT.email)
    WHERE -- IMPORTANT: Only update if there's an actual change
        TGT.salary IS DISTINCT FROM SRC.salary OR
        (SRC.jobTitle IS NOT NULL AND TGT.jobTitle IS DISTINCT FROM SRC.jobTitle) OR
        (SRC.email IS NOT NULL AND TGT.email IS DISTINCT FROM SRC.email)
WHEN NOT MATCHED THEN
    INSERT (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
    VALUES (SRC.employeeId, SRC.employeeName, SRC.jobTitle, SRC.managerId, SRC.hireDate, SRC.salary, SRC.departmentId, SRC.email);

-- SELECT employeeId, jobTitle, salary, email FROM Employees WHERE employeeId IN (204, 501); -- Verify
-- DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows merged.');
ROLLBACK;
```
*   **Explanation:** `MERGE` is atomic and optimized. The `WHERE` clause in `WHEN MATCHED THEN UPDATE` prevents unnecessary updates if values are identical, crucial for performance and auditing. `IS DISTINCT FROM` handles NULLs correctly in comparisons.

</div>

<div class="container">

## (iv) Hardcore Combined Problem Solution

```sql
-- Enable output to see messages
SET SERVEROUTPUT ON;

-- Create a baseline copy of Employees table
CREATE TABLE EmployeesOriginal AS SELECT * FROM Employees;

DECLARE
    vMergedRows NUMBER;
BEGIN
    WITH ProposedChanges AS (
        SELECT
            e.employeeId,
            e.employeeName,
            e.jobTitle,
            e.managerId AS currentManagerId,
            e.hireDate,
            e.salary AS currentSalary,
            e.departmentId,
            e.email AS currentEmail,
            d.departmentName,
            TRUNC(MONTHS_BETWEEN(SYSDATE, e.hireDate) / 12) AS tenureYears,
            DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS salaryRankInDept,
            AVG(e.salary) OVER (PARTITION BY e.departmentId) AS avgSalaryDept,
            LAG(e.salary, 1, e.salary) OVER (PARTITION BY e.departmentId ORDER BY e.salary ASC) AS justHigherSalaryInDeptAsc, -- for Rule 3
            -- Rule-based new salary calculation
            CASE
                -- Rule 1
                WHEN DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) = 1
                     AND (TRUNC(MONTHS_BETWEEN(SYSDATE, e.hireDate) / 12)) > 3
                THEN ROUND(e.salary * 1.07)
                -- Rule 2
                WHEN e.salary < (0.6 * AVG(e.salary) OVER (PARTITION BY e.departmentId))
                     AND (TRUNC(MONTHS_BETWEEN(SYSDATE, e.hireDate) / 12)) > 1
                THEN GREATEST(ROUND(e.salary * 1.05), ROUND(0.6 * AVG(e.salary) OVER (PARTITION BY e.departmentId)))
                -- Rule 3
                WHEN e.salary < 0.9 * (LAG(e.salary, 1, NULL) OVER (PARTITION BY e.departmentId ORDER BY e.salary ASC)) -- LAG from salary ASC gives next higher
                     AND e.managerId != 100
                     AND NOT (DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) = 1 AND (TRUNC(MONTHS_BETWEEN(SYSDATE, e.hireDate) / 12)) > 3)
                THEN ROUND(e.salary * 1.03)
                ELSE e.salary
            END AS newSalary,
            LOWER(SUBSTR(e.employeeName, 1, 1) ||
                  SUBSTR(e.employeeName, INSTR(e.employeeName, ' ') + 1)
                 ) || '@megacorp.com' AS newEmail
        FROM
            Employees e
        JOIN
            Departments d ON e.departmentId = d.departmentId
    )
    MERGE INTO Employees TGT
    USING ProposedChanges SRC
    ON (TGT.employeeId = SRC.employeeId)
    WHEN MATCHED THEN
        UPDATE SET
            TGT.salary = SRC.newSalary,
            TGT.email = SRC.newEmail
        WHERE
            TGT.salary IS DISTINCT FROM SRC.newSalary OR TGT.email IS DISTINCT FROM SRC.newEmail;

    vMergedRows := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('MERGE statement affected ' || vMergedRows || ' rows.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error during MERGE: ' || SQLERRM);
        RAISE;
END;
/

-- Post-Adjustment Reporting

-- a. Hierarchical report for 'Technology' department (ID 10)
DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Hierarchical Report for Technology Department ---');
SELECT
    LPAD(' ', (LEVEL - 1) * 4) || e.employeeName AS indentedEmployeeName,
    e.jobTitle,
    e.salary AS newSalary,
    LEVEL AS hierarchyLevel
FROM Employees e
START WITH e.departmentId = 10 AND e.managerId IS NULL -- Top managers in Tech
CONNECT BY PRIOR e.employeeId = e.managerId AND e.departmentId = 10 -- Stay within Tech
ORDER SIBLINGS BY e.employeeName;

-- b. Top 2 highest-paid employees per department
DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Top 2 Highest Paid Employees per Department (Post-Merge) ---');
WITH RankedEmployees AS (
    SELECT
        e.employeeName,
        d.departmentName,
        e.salary,
        ROW_NUMBER() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC, e.employeeId ASC) AS rn
    FROM Employees e
    JOIN Departments d ON e.departmentId = d.departmentId
)
SELECT departmentName, employeeName, salary
FROM RankedEmployees
WHERE rn <= 2
ORDER BY departmentName, salary DESC;

-- c. Employees whose salary did NOT change
DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Employees Whose Salary Did NOT Change ---');
SELECT eo.employeeId, eo.employeeName, eo.salary AS originalSalary
FROM EmployeesOriginal eo
JOIN Employees en ON eo.employeeId = en.employeeId
WHERE eo.salary = en.salary -- Direct comparison of salary values
ORDER BY eo.employeeId;

-- Cleanup original table
DROP TABLE EmployeesOriginal;
-- COMMIT; -- Final commit if not part of a larger script session
```
*   **Explanation Highlights:**
    *   A PL/SQL block manages the `MERGE` and transaction.
    *   `CREATE TABLE EmployeesOriginal AS SELECT * FROM Employees;` creates the baseline.
    *   The `ProposedChanges` CTE calculates `tenureYears`, `salaryRankInDept`, `avgSalaryDept`, `justHigherSalaryInDeptAsc` (using `LAG` with `ORDER BY salary ASC` to get the next higher salary), applies salary adjustment rules in a `CASE` statement, and formats `newEmail`.
    *   `MERGE` updates `Employees` if `newSalary` or `newEmail` differs from current values using `IS DISTINCT FROM` for robust NULL handling.
    *   **Tech Hierarchy Report:** Uses `START WITH` for department heads and `CONNECT BY PRIOR` for structure.
    *   **Top Earners:** `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` ranks, then filters for top 2.
    *   **Unchanged Salaries:** Joins `EmployeesOriginal` with the updated `Employees` table and compares salaries.
    *   `DROP TABLE EmployeesOriginal;` cleans up.

</div>

<div class="container">
<p>These solutions aim for clarity and demonstrate correct usage of the Oracle features. Remember to adapt and experiment to deepen your understanding!</p>
<div class="rhyme">
With syntax clear and logic sound,<br>
Oracle's power can be found.
</div>
</div>