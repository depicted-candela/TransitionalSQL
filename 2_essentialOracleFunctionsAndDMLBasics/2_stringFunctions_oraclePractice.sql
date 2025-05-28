        -- 1. From PostgreSQL to SQL ORACLE with ORACLE DB


--  (ii) Disadvantages and Pitfalls

--      3.1 Exercise 2.1: Data Type Pitfalls and Misunderstandings
--          1. VARCHAR2 Size & Semantics: An EmployeeRoster firstName column is
-- VARCHAR2(10 BYTE). 
-- • What happens if you try to insert ’Christophe’ (10 chars, 10 bytes in ASCII)?
-- It will works because memory is enough to store 10 bytes
-- • What if you try to insert ’René’ (4 chars, but ’é’ can be 2 bytes in UTF8)?
-- It will succeed because were used 5 of 10 bytes.
-- • What is the pitfall if NLS_LENGTH_SEMANTICS is BYTE when dealing
-- with multi-byte characters?
-- Complex characters like ones from the chinese language will fail
-- if they exceed the stablished setted memory, thus the limit in BYTES must be 
-- just for very simplified texts like standardized names for default english
--          2. NUMBER Precision/Scale:
-- • If salary in EmployeeRoster was defined only as NUMBER (no preci-
-- sion/scale) and you inserted 12345.678912345, what would be stored?
-- What’s a potential pitfall of omitting precision/scale for financial data?
-- Answer: the decimal part of such real number will be ignored and the 
-- precision for generalized financial analysis will fail
-- • If commissionRate is NUMBER(4,2) and you attempt to insert 0.125 or
-- 10.50. What happens in each case? What if you try to insert 123.45?
-- Answer: 0.125 will be stored as 0.12, 10.50 as 10.50, 123.45 as 123.4
-- 3. Oracle DATE Time Component: A PostgreSQL user accustomed to DATE being
-- date-only inserts TO_DATE('2023-11-10', 'YYYY-MM-DD') into hireDate
-- (Oracle DATE). They later run SELECT * FROM EmployeeRoster WHERE hireDate
-- = TO_DATE('2023-11-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS');. Will
-- they find the record? Why or why not? What’s the pitfall?
-- Answer: will fail because values created with DATE in ORACLE are setted
-- to midnight if time was not previously provided  
-- 4. TIMESTAMPWITHLOCALTIMEZONE(TSLTZ):localEntryTimein ProductCatalog
-- is TIMESTAMP WITH LOCAL TIME ZONE.
-- • Session A (Time Zone ’America/New_York’) inserts TIMESTAMP '2023-11-10
-- 10:00:00 America/New_York'.
-- • Session B (Time Zone ’Europe/London’) queries this exact row. What time
-- will Session B see (conceptually, considering typical UTC offsets)?
-- Answer: will see Time Zone ’Europe/London’ because the variable is 
-- TIMESTAMP WITH LOCAL TIME ZONE.
-- • What is a potential pitfall if the database’s DBTIMEZONE is different from
-- the application server’s OS time zone, and TSLTZ data is inserted using
-- SYSTIMESTAMP without explicit time zone specification?
-- Answer: the time stored will be generalized to the application server's OS
-- time zone and the fine grained Time Zone for regionalized databases would
-- be unmeaningful

--      3.2 Exercise 2.2: NULL Handling Function Caveats
-- 1. NVL Type Conversion: What happens if you use NVL(salary, 'Not Available')
-- where salary is NUMBER(10,2)? 
-- Answer: data types are not coherent for the same NVL
-- Why is this a pitfall? How should it be corrected if the goal is a string output?
-- Answer: salary must be casted to string
-- 2. NVL2 TypeMismatch: Consider NVL2(hireDate, SYSDATE + 7, 'Not Hired
-- Yet'). hireDate is DATE. What is the likely data type of the result if hireDate
-- is NOT NULL?
-- SELECT SYSDATE + 7 FROM DUAL; -- returns DATE
-- What if it IS NULL? What’s the potential issue and how can Or-
-- acle try to resolve it (possibly leading to errors)?
-- Answer: the returned value will be 'Not Hired Yet', but since such value is not
-- casted to DATE, an error will appear
-- 3. COALESCE ArgumentEvaluation: While COALESCE returns the first non-NULL
-- expression, all expressions provided to it must be of data types that are implicitly
-- convertible to a common data type, determined by the first non-NULL expres-
-- sion. What error might occur with COALESCE(numericColumn, dateColumn,
-- 'textFallback') if numericColumn is NULL but dateColumn is not?
-- Answer: both numeric column and the last vale are not implicitly convertible to the 
-- common type DATE

--      3.3 Exercise 2.3: DECODE and ROWNUM Logic Traps
-- 1. DECODE’s NULL Handling: DECODE(colA, colB, 'Match', 'No Match').
-- If both colA and colB are NULL, what does this return? 
-- Answer: 'No Match'
-- How does this differ from CASE WHEN colA = colB THEN 'Match' ELSE 'No Match' END?
-- Answer: DECODE treats NULL = NULL as true while CASE do it as unknown
-- When could DECODE’s behavior be a pitfall?
-- Answer: when comparisons more complex than equalities are necessary, portability
-- is required or the ANSI logic (NULL = NULL as unknown) is required
-- 2. ROWNUM for Pagination - Incorrect Attempt: A developer wants to display the
-- 3rd and 4th products from ProductCatalog (in order of productId). They
-- write:
SELECT productName 
FROM ProductCatalog 
WHERE ROWNUM BETWEEN 3 AND 4
ORDER BY productId;
-- Why will this query return no rows?
-- Answer: the query returns nothing because the filter filters after to the
-- creation of the ranking number, thus nothing is selected because there
-- is nothing to select
-- 3. ROWNUM with ORDER BY - Misconception: What is the output of the fol-
-- lowing query? 
SELECT productName, ROWNUM FROM ProductCatalog WHERE ROWNUM <= 10 ORDER
BY productName DESC;
-- Is it guaranteed to be the two products whose names are last
-- alphabetically? Explain.
-- Answer: it's not guaranteed because the ORDER is made previous to the
-- filter