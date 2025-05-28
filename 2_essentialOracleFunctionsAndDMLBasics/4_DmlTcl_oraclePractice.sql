        -- 1. From PostgreSQL to SQL ORACLE with ORACLE DB


--  5 Hardcore Combined Problem

--      5.1 Exercise 4.1: Multi-Concept Oracle Challenge for ”Employee Per-
-- formance Review Prep”
-- Scenario: Management needs a preliminary report for performance reviews. The re-
-- port should identify the top 2 longest-serving ’Programmer’ employees from the ’IT’
-- department. For these employees, provide a ”Review Focus” and details about their
-- bio and tenure.
-- Requirements:
-- 1. Selection: Target ’Programmer’ employees in the ’IT’ department only.
-- 2. Output Columns:
-- • employeeId (NUMBER)
-- • employeeName (VARCHAR2, format: ’LastName, FirstName’)
-- • jobTitle (VARCHAR2)
-- • department (VARCHAR2)
-- • hireDateDisplay (VARCHAR2, formatted as ’Month DD, YYYY’, e.g.,
-- ’January 03, 2006’)
-- • yearsOfService(NUMBER, calculated to one decimal place from hireDate
-- to SYSDATE. Use MONTHS_BETWEEN and DUAL for SYSDATE if needed in
-- calculation context, though SYSDATE can be used directly).
-- • bioExtract (NVARCHAR2: If bio is not NULL, show the first 30 char-
-- acters of bio followed by ’...’. If bio is NULL, display ’No Bio on File’. Use
-- NVL or COALESCE and string functions).
-- • reviewFocus (VARCHAR2):
-- – Use a CASE expression.
-- – If commissionRate IS NOT NULL, focus is ’Sales & Technical Skills
-- Review’.
-- – Else (if commissionRate IS NULL):
-- ∗ Use DECODE on managerId. If managerId is 102, focus is ’Project
-- Leadership Potential’.
-- ∗ Otherwise (for other managers or NULL managerId for program-
-- mers), focus is ’Core Technical Deep Dive’.
-- 3. Top-NLogic: The final output must be strictly limited to the top 2 longest-serving
-- employees (earliest hireDate) based on the above criteria. Use ROWNUM cor-
-- rectly for this.
-- 4. Comments: Include a brief multi-line comment explaining the report’s purpose
-- and a single-line comment for the ROWNUM filtering logic.
-- 5. DUAL Table (Implicit/Explicit): Use of SYSDATE implicitly involves concepts
-- related to DUAL’s role in providing such values.
-- 11
-- Bridging from PostgreSQL: This problem involves concepts like string manipula-
-- tion (SUBSTR, concatenation), date calculations (MONTHS_BETWEEN vs. PostgreSQL
-- age/interval functions), conditional logic (CASE is similar, DECODE is new), NULL
-- handling (NVL/COALESCE vs. PG COALESCE), and Top-N queries (ROWNUM vs. PG
-- LIMIT).

SET DEFINE OFF;
/*This turn down setters like & within strings
and SET DEFINE ON; turns on setters like & within strings*/
SELECT * FROM (
    SELECT 
        employeeId, 
        CONCAT(FIRSTNAME, ', ', LASTNAME) EMPLOYEENAME, 
        jobTitle, 
        DEPARTMENTNAME, 
        TO_CHAR(HIREDATE, 'Month DD, YYYY') HIRE_DISPLAY,
        ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12) YEARSOFSERVICE,
        NVL2(BIO, SUBSTR(BIO, 0, 30), TO_NCHAR('No Bio on File')) BIOEXTRACT,
        CASE 
            WHEN COMMISSIONRATE IS NOT NULL THEN 'Sales \ Technical Skills Review'
            ELSE DECODE(MANAGERID, 102, 'Project Leadership Potentential', 'Core Technical Deep Dive')
        END REVIEWFOCUS
    FROM EMPLOYEEROSTER 
    WHERE DEPARTMENTNAME = 'IT' AND JOBTITLE = 'Programmer'
    ORDER BY HIREDATE DESC
) WHERE ROWNUM < 3;

SET DEFINE ON;