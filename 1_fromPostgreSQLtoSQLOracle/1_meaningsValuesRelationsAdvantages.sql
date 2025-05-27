-- 1. From PostgreSQL to SQL ORACLE with ORACLE DB


--  1 Meanings, Values, Relations, and Advantages

--      2.1 Exercise 1.1: Understanding Oracle Data Types & Bridging from
-- PostgreSQL

-- 1. VARCHAR2 vs. NVARCHAR2:
-- • Explain the core difference between VARCHAR2 and NVARCHAR2 in Oracle.
-- Answer: they differ because NVARCHAR2 accepts more characters than latin or
-- custom characters for simplified english, it accepts asian characters,
-- germanic special symbols, the russian and hindi languages, etc 
-- • The EmployeeRostertable has firstName(VARCHAR2) and bio(NVARCHAR2).
-- Why might bio be NVARCHAR2 while firstName (in many Western con-
-- texts) might be VARCHAR2?
-- Answer: it's normal that multinational enterprises centralizing clients
-- asks for the english version of their names to save the memory that
-- VARCHAR2 allows; nevertheless, the best deescription that somebody could
-- about himself it's normally done with the native or most used language,
-- that's way bio must be NVARCHAR2
-- • In PostgreSQL, you commonly use VARCHAR or TEXT. How does VARCHAR2
-- relate, and what Oracle-specific considerations are there for character data?
-- Answer: VARCHAR is for varying characters with a limited scoped of characters
-- but varying, TEXT also allows multilanguage characters without memory limits,
-- property not achieved by NVARCHAR2 but performed with CLOB.
-- Though there exists something making more special to VARCHAR2: its overloaded definition using
-- limits by bytes or number of characters, the first one more oriented to 
-- memory intesive tasks but limiting the size of a word if characters are too
-- high in size, using the maximum number of characters is another way making
-- more flexible character writing for international projects.

-- 2. NUMBER Type:
-- • Oracle’s NUMBER type is used for employeeId and salary in EmployeeRoster.
-- Illustrate how NUMBER definition (NUMBER(6) vs NUMBER(10,2)) achieves
-- this.
-- The first pattern is an integer number from 0 up to 999999, the second one
-- goes from 00000000.00 up to 99999999.99 modeling monetary values
-- • What PostgreSQL types (e.g., INTEGER, NUMERIC) would correspond to
-- these uses? What is an advantage of Oracle’s unified NUMBER type?
-- There exists to much definitions to get the definitions that the patterns 
-- in NUMBER gives: REAL, INTEGER, DOUBLE, NUMERIC, many variations of INT. 
-- Oracle's NUMBER is a highly overloaded method for 4 numeric patterns

-- 3. DATE Type:
-- • Retrieve employeeId and hireDate for ’Steven King’. Note the format.
SELECT employeeId, hireDate, TO_CHAR(hireDate, 'YYYY-MM-DD HH24:MI:SS') formatted_Date
FROM basic_oracle_uniqueness.EmployeeRoster
WHERE firstName = 'Steven' AND lastName = 'King';
-- Despite dates appear as DD/MM/YYYY in the table, they're presented as 17-JUN-03
-- as a format
-- • PostgreSQL’s DATE type stores only date. Oracle’s DATE stores date and
-- time. What PostgreSQL type is Oracle’s DATE most analogous to? How
-- could this difference impact data migration or queries if not handled care-
-- fully?
-- Answer: the PostgreSQL type for Oracle's DATE is TIMESTAMP. DATE in PGL
-- does not have accuracy for times, Oracle's DATE without time are set to mid
-- night. Thus, the migrations must be castings or destructurings with specfic 
-- types to construct the expected type for the best design.

-- 4. TIMESTAMP Variations:
-- • From ProductCatalog, select productName, lastStockCheck(TIMESTAMP),
-- nextShipmentDue(TIMESTAMP WITH TIME ZONE), and localEntryTime
-- (TIMESTAMP WITH LOCAL TIME ZONE) for ’Oracle Database 19c’.
SELECT PRODUCTNAME, LASTSTOCKCHECK, NEXTSHIPMENTDUE, LOCALENTRYTIME
FROM basic_oracle_uniqueness.ProductCatalog WHERE PRODUCTNAME = 'Oracle Database 19c';
-- • Briefly explain the advantage of each TIMESTAMP variant chosen for these
-- columns. (You may want to run ALTER SESSION SET NLS_TIMESTAMP_FORMAT
-- = 'YYYY-MM-DD HH24:MI:SS.FF';and ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT
-- = 'YYYY-MM-DD HH24:MI:SS.FF TZR'; for clarity).
-- Answer: the advantages of Last Srock Check is for analytical logging of active
-- workers; next shipment due is useful to understand when the sender will send
-- new materials in their time to understand better when things will happend; and
-- localentrytime will serve to understand patterns between shipment due and 
-- local entry time if they're required

--      2.2 Exercise 1.2: DUALTableandNULLHandling(NVL,NVL2, COALESCE)

-- 1. DUAL Table:
-- • What is the DUAL table in Oracle? Give two common use cases.
-- Answer: is the way to assign constants to queries using ORACLE SQL internals
-- coming from a unifier table. Is not necessary with PL/SQL.
-- • In PostgreSQL, SELECT 1+1; works. How do you achieve this in Oracle
-- and why is DUAL needed?
-- SELECT 1+1 AS query_constant; -- does not need the DUAL table, just make the calculation
SELECT 1+1 FROM DUAL; -- Makes an internal process to centralize things repeatly used

-- 2. NVL Function:
-- • Display employeeId, firstName, salary, commissionRate, and a ”Guar-
-- anteed Pay” which is salary + (salary * commissionRate). If commissionRate
-- is NULL, it should be treated as 0. Use NVL.
SELECT employeeId, firstName, salary, commissionRate, 
salary + salary * NVL(commissionRate, 0) GuaranteedPay
FROM EMPLOYEEROSTER;
-- • How does NVL(expr1, expr2) compare to PostgreSQL’s COALESCE(expr1, expr2)?
-- Answer: is almost the same behavior and COALESCE is verbose but unlimited.
-- NVL and NVL2 are optimized for case handling for a single comparison and for
-- two values not necessarily the first argument.

-- 3. NVL2 Function:
-- • Display employeeId, firstName, and a commissionStatus. If commissionRate
-- is NOT NULL, commissionStatus should be ’Eligible for Commission
-- Bonus’. If commissionRate IS NULL, it should be ’Salary Only’. Use NVL2.
SELECT EMPLOYEEID, FIRSTNAME, NVL2(COMMISSIONRATE, 'Elegible for Commission Bonus', 'Salary Only') COMMISION_STATUS
FROM EMPLOYEEROSTER;
-- • How would you achieve the NVL2 logic using standard SQL constructs known
-- from PostgreSQL (like CASE)?
-- Answer: the verbose option shoule be CASE WHEN COMMISSIONRATE IS NOT THEN 'Elegible for Commission Bonus' ELSE 'Salary Only'
-- note the verbosity

-- 4. COALESCE Function:
-- • From ProductCatalog, display productId, productName, and the notes.
-- If notes is NULL, show ’No additional notes’. If notes is NULL and supplierInfo
-- also happens to be NULL (not in current data, but imagine), show ’Critical
-- info missing’. Use COALESCE.
SELECT 
    PRODUCTID, 
    PRODUCTNAME, 
    NOTES, 
    COALESCE(TO_NCHAR(NOTES), SUPPLIERINFO, TO_NCHAR('Critical info missing')) AS co 
FROM PRODUCTCATALOG;

--      2.3 Exercise 1.3: Conditional Logic (DECODE, CASE) & Comments

-- 1. DECODE vs. CASE:
-- • What is a key syntactical difference between Oracle’s DECODE function and
-- the standard CASE expression when performing multiple comparisons?
-- Answer: creates an analytical less verbose thread rather than a complex
-- CASE WHERE END nested series of statements, is clener and readable. Also
-- simplifies the case when NULL = NULL, making such comparison as TRUE, rather
-- than UNKNOWN with CASE
-- • Which is generally more readable and flexible for complex conditions?
-- Answer: DECODE

-- 2. DECODE Function:
-- • Using DECODE on EmployeeRoster, display firstName, jobTitle. Add
-- a new column jobLevel. If jobTitle is ’President’, jobLevel is ’Top
-- Tier’. If ’Administration VP’ or ’Finance Manager’, it’s ’Mid Tier’. If ’Pro-
-- grammer’, it’s ’Staff’. Otherwise, ’Other’.
SELECT FIRSTNAME, JOBTITLE, 
    DECODE(
        JOBTITLE,
        'President', 'Top Tier',
        'Administration VP', 'Mid Tier',
        'Finance Manager', 'Mid Tier',
        'Programmer', 'Staff',
        'Other'
        ) JOBLEVEL 
FROM EMPLOYEEROSTER;

-- 3. CASE Expression:
-- • Rewrite the query from (1.3.2) using a CASE expression (use a searched
-- CASE for clarity).
-- • From ProductCatalog, display productName, unitPrice, and a priceTag.
-- If unitPrice= 0, priceTagis ’Free’. If unitPrice> 0 AND unitPrice
-- <= 100, priceTag is ’Affordable’. If unitPrice > 100, priceTag is ’Pre-
-- mium’. Use a CASE expression.
-- 4. Comments:
-- • Add a single-line comment above your CASE expression query explaining
-- its purpose.
-- • Add a multi-line comment at the beginning of your SQL script file for this
-- exercise set, stating the Oracle concepts being practiced.

--      2.4 Exercise 1.4: ROWNUM Pseudo-column

-- 1. ROWNUM Basics:
-- • What is ROWNUM in Oracle? When is its value assigned to a row in a query’s
-- execution?
-- Answer: It's a simpler way of the ranking function ROW_NUM that calculates
-- the same enumeration but without the boilerplate of partitions and things
-- necessary for such analytical function, is a virtual column ranking rows
-- based on external orders of the query
-- • How does ROWNUM fundamentally differ from PostgreSQL’s LIMIT clause in
-- behavior, especially concerning ORDER BY?
-- Answer: LIMIT directly selects just a chuck of data to represet, in exchange
-- ROWNUM represent the entire data ranked by the order, to limit data by ranking
-- is necessary an additional query containing the previous one
-- 2. Top-N Query:
-- • Select the firstName, lastName, and salary of the 3 employees with the
-- highest salaries from EmployeeRoster. Ensure ROWNUM is used correctly
-- for this.
SELECT * FROM (
    SELECT FIRSTNAME, LASTNAME, SALARY, ROWNUM RANKING FROM EMPLOYEEROSTER ORDER BY SALARY DESC
) WHERE RANKING < 4;
-- 3. Pagination Emulation (Conceptual):
-- • Explain how you would select the employees who are, say, the 4th and 5th
-- highest paid (i.e., rows 4-5 in a list sorted by salary descending). You must
-- use ROWNUM.
SELECT * FROM (
    SELECT FIRSTNAME, LASTNAME, SALARY, ROWNUM RANKING FROM EMPLOYEEROSTER ORDER BY SALARY DESC
) WHERE RANKING IN (4, 5);