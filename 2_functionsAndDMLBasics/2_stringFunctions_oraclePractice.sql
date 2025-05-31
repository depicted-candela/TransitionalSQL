                -- 2. String Functions (Practice in Oracle)


--      (i) Meanings, Values, Relations, and Advantages
--              Exercise 2.1.1: Basic Oracle String Manipulation
-- Problem:
-- a. Concatenate the firstName, a space, and the lastName of employee Bob Johnson (employeeId 102) using the || operator. Also show it using nested 
-- CONCAT functions. Explain why || is generally preferred in Oracle.
SELECT FIRSTNAME || ' ' || LASTNAME FULLNAME, CONCAT(CONCAT(FIRSTNAME, ' '), LASTNAME) CONCAT_FULLNAME 
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 102;
-- The second approach is highly verbose
-- b. For employee Alice Smith (employeeId 101), extract the username part (before '@') from her email address. Use SUBSTR and INSTR.
SELECT SUBSTR(EMAIL, 0, INSTR(EMAIL, '@') - 1), EMAIL
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES 
WHERE EMPLOYEEID = 101;
-- c. Find the length of Frank Miller's (employeeId 106) jobTitle after removing leading/trailing spaces. Use LENGTH and TRIM.
SELECT FIRSTNAME, LASTNAME, LENGTH(TRIM(FIRSTNAME||LASTNAME)) FranksLength
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 106;
-- d. Display the projectName for projectId 1 ('Omega System Upgrade') with 'System' replaced by 'Platform'. Use REPLACE.
SELECT REPLACE(PROJECTNAME, 'System', 'Platform') REPLACEMENT
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTS WHERE PROJECTID = 1;
-- e. (Oracle Specific Nuance for INSTR) Find the starting position of the second occurrence of 'e' (case-insensitive) in the firstName 'Eve' (employeeId 105). 
-- Use INSTR with its occurrence parameter. How might you achieve case-insensitivity directly in INSTR or by combining functions?
-- Answer: must be used LOWER in variable sides of a comparison


--      (ii) Disadvantages and Pitfalls
--              Exercise 2.2.1: String Function Pitfalls in Oracle
-- Problem:
-- a. A query WHERE jobTitle = 'Developer' is intended to find all types of developers (e.g., 'Senior Developer', 'Developer Lead'). Why will this fail? 
-- What Oracle functions/operators should be used for substring or pattern matching?
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE JOBTITLE LIKE '%Developer%';                -- All these ways are correct but the first one is
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE INSTR(LOWER(JOBTITLE), 'developer');        -- the best
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE INSTR(LOWER(JOBTITLE), 'developer') > 0;
-- b. Oracle treats empty strings ('') in VARCHAR2 columns as NULL. A developer writes SELECT firstName || details || lastName FROM someTable where details can 
-- sometimes be an empty string from source data that becomes NULL. What is the result compared to PostgreSQL where '' is not NULL?
-- Answer: Oracle differs of PGL not nulling a completely concatenated operation if just one is null, instead treat it as the empty version of PostgreSQL
-- c. If SUBSTR(string, start_pos, length) is used and start_pos is 0 or negative, or length is negative, how does Oracle's SUBSTR behave? Contrast with 
-- PostgreSQL's SUBSTRING if known behavior differs.
-- Answer: 0 as start_pos means the string beginning with the same behavior with 1; with < 0 means starting from the end counting such negative number from 
-- the end; negative lenghts give NULL as result


--      (iii) Contrasting with Inefficient Common Solutions
--              Exercise 2.3.1: Complex String Parsing - Iterative SUBSTR/INSTR vs. REGEXP_SUBSTR
-- Problem:
-- The Projects table has projectName 'Omega System Upgrade, Phase 2, Alpha Release'. You need to extract the third comma-separated value ('Alpha Release' after 
-- trimming).
-- Inefficient/Complex Common Solution: A developer might use multiple nested calls to INSTR to find the positions of the first, second, and third commas, and 
-- then SUBSTR to extract the segment, followed by TRIM. This can become very complex and error-prone.
-- Show conceptually how this might look (you don't need to write the fully working deeply nested version if it's too verbose, just outline the logic).
-- Explain its disadvantages (readability, maintainability, error-proneness).
-- Present the efficient and often clearer Oracle-idiomatic solution using REGEXP_SUBSTR.
SELECT LTRIM(SUBSTR(PROJECTNAME, INSTR(PROJECTNAME, ',', 1, 2) + 1, LENGTH(PROJECTNAME))) EXTRACTED, PROJECTNAME
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTS 
WHERE PROJECTNAME = 'Omega System Upgrade, Phase 2, Alpha Release';