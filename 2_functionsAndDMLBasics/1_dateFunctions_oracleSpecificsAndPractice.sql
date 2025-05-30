        -- 1. Date Functions (Oracle Specifics & Practice)


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 1.1.1: Oracle Current Date/Time Functions and Conversions
-- Problem:
-- a. Display the current system date and time using SYSDATE.
-- SELECT SYSDATE FROM DUAL;
-- b. Display the current session date using CURRENT_DATE. (PostgreSQL equivalent: CURRENT_DATE)
-- SELECT CURRENT_DATE FROM DUAL;
-- c. Display the current system timestamp with time zone using SYSTIMESTAMP. (PostgreSQL equivalent: 
--      NOW() or CURRENT_TIMESTAMP (with time zone))
-- SELECT DBTIMEZONE, SYSTIMESTAMP, TO_CHAR(SYSTIMESTAMP, 'TZH:TZM') TIME_ZONE FROM DUAL;
-- d. Display the current session timestamp using CURRENT_TIMESTAMP. 
--      (Oracle's CURRENT_TIMESTAMP returns TIMESTAMP WITH TIME ZONE based on session settings).
SELECT CURRENT_TIMESTAMP FROM DUAL;
-- e. Alice Smith (employeeId 101) was hired on '2020-01-15'. Convert this string to an Oracle DATE type and display it. 
SELECT FIRSTNAME, LASTNAME, TO_DATE('2020-01-15', 'YYYY-MM-DD') ORACLE_DATE
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
--      Explain the importance of TO_DATE and format models in Oracle compared to PostgreSQL's potentially more lenient string-to-date casting.
-- f. Display Alice Smith's hire date in the format 'Day, DDth Month YYYY, HH24:MI:SS'. Explain how TO_CHAR with date format models works in Oracle.
SELECT TO_CHAR('Day, DDth Month YYYY, HH24:MI:SS') CHARED_DATE
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
-- There exists a rich variety of format to represent dates, they depend and are based by real world demands
-- from world standards. That's why TO_CHAR with date formats models for ORACLE is stricter

--      Exercise 1.1.2: Oracle Date Arithmetic and Interval Functions
-- Problem:
-- a. Calculate the date 6 months after Alice Smith's (employeeId 101) hire date using ADD_MONTHS.
SELECT ADD_MONTHS(HIREDATE, 6) NEXT_MONTHS, HIREDATE CURRENT_MONTH 
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
-- b. Calculate the number of months between Bob Johnson's (employeeId 102) hire date and Alice Smith's hire date using MONTHS_BETWEEN.
SELECT MONTHS_BETWEEN((SELECT HIREDATE FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101), HIREDATE)
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES 
WHERE EMPLOYEEID = 102;
-- c. Find the last day of the month for Alice Smith's hire date using LAST_DAY.
SELECT LAST_DAY(HIREDATE) HIRING_MONTH_LAST_DAY CHARED_DATE
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
-- d. Find the date of the next Friday after Alice Smith's hire date using NEXT_DAY.
SELECT NEXT_DAY(HIREDATE, 'Friday') HIRING_NEXT_FRIDAY 
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
-- e. Show Alice Smith's hire date truncated to the beginning of the year and rounded to the nearest year. (Illustrates TRUNC(date,'YYYY') 
-- and ROUND(date,'YYYY')).
SELECT ROUND(TRUNC(HIREDATE, 'YEAR'), 'YEAR') AUTODESCRIBED, ROUND(TRUNC(HIREDATE, 'YYYY'), 'YYYY') FORMATTED
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
-- f. Add 10 days to Alice Smith's hire date using simple date arithmetic. (Known from PG, syntax: date + number).
SELECT HIREDATE + 10 ADDED_HIREDATE, HIREDATE
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
-- g. Subtract Alice Smith's hire date from Bob Johnson's hire date to find the difference in days. (Known from PG, syntax: date - date).
SELECT 
        HIREDATE - (SELECT HIREDATE FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 102) DIFFERENCE_IN_DAYS
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 101;
-- h. The 'Omega System Upgrade' project (projectId 1) has a deadlineTimestamp. Add an interval of '3 days and 5 hours and 30 minutes' to 
-- this deadline using an Oracle INTERVAL DAY TO SECOND type. Contrast Oracle's INTERVAL syntax with PostgreSQL's.
SELECT DEADLINETIMESTAMP + INTERVAL '3 05:30:00' DAY TO SECOND 
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTS WHERE PROJECTNAME = 'Omega System Upgrade';


--  (ii) Disadvantages and Pitfalls

--      Exercise 1.2.1: Date Function Pitfalls
-- Problem:

-- a. A developer tries to find all employees hired in '2020' using TO_CHAR(hireDate, 'YYYY') = '2020'. Explain why this is inefficient for 
-- indexed hireDate columns and suggest a better Oracle-idiomatic way.
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES 
WHERE HIREDATE < TO_DATE('2021-01-01', 'YYYY-MM-DD')
    AND HIREDATE >= TO_DATE('2021-01-01', 'YYYY-MM-DD');
-- This query creates a SARGable statement because makes direct comparisons prone to use directly indexes created in HIREDATE
-- b. A junior DBA attempts to set the endDate of project 'Mobile App Development' (projectId 3) to be exactly one year from its startDate using 
-- startDate + 365. What is a potential issue with this approach, especially concerning leap years? How would ADD_MONTHS be better?
SELECT ADD_MONTHS(DEADLINETIMESTAMP, 12) FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTS;
-- Because a symbol can be treated as a constant just if there is not more representations of itself and the definition of a year in months is
-- always constant, 12 months must be used to represent a year for date arithmetics
-- c. What is a potential issue if NEXT_DAY(some_date, 'MONDAY') is used in an application deployed across regions with different NLS_DATE_LANGUAGE 
-- settings? How can this be made more robust?
-- Answer: The problem lies that 'MONDAY' is not the universal name for the first day of a week in the gregorian system, different languages across regions
-- necessarily use different words for the same statement. To centralize these behaviors around english is useful the usage of 
-- NEXT_DAY(date, <day>, 'NLS_DATE_LANGUAGE = AMERICAN') where NLS_DATE_LANGUAGE is optional but safer for international projects
-- d. Oracle's DATE type stores both date and time. A query WHERE hireDate = TO_DATE('2020-01-15', 'YYYY-MM-DD') is used to find employees hired on 
-- January 15, 2020. Why might this query miss employees hired on that day? What is a correct way to find all employees hired on a specific day, 
-- regardless of time?
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES
WHERE HIREDATE < TO_DATE('2021-01-16', 'YYYY-MM-DD') AND HIREDATE >= TO_DATE('2021-01-15', 'YYYY-MM-DD');
-- Because TO_DATE('2021-01-15', 'YYYY-MM-DD') is fine grained in ORACLE SQL, a query using it will just return
-- hirings made on the midnight


--  (iii) Contrasting with Inefficient Common Solutions
--      Exercise 1.3.1: Date Range Queries - Inefficient vs. Efficient
-- Problem:

-- A developer needs to find all projects that had a startDate within the calendar year 2023.
-- Inefficient Approach: They write a query using EXTRACT(YEAR FROM startDate) = 2023 or TO_CHAR(startDate, 'YYYY') = '2023'.
-- Show this inefficient approach.
-- Explain why it's inefficient in Oracle, especially if startDate is indexed.
-- Provide the efficient, Oracle-idiomatic solution using date range comparisons that can leverage indexes.
SELECT * 
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTS 
WHERE EXTRACT(YEAR FROM startDate) = 2023 or TO_CHAR(startDate, 'YYYY') = '2023';
-- A query to be sargable needs the left value (the one stored in the table) to be
-- directly comparable with a constant value, note that both comparisons at left
-- are not comparable
SELECT STARTDATE
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTS
WHERE 
    STARTDATE >= TO_DATE('2023-01-01', 'YYYY-MM-DD') 
    AND STARTDATE < TO_DATE('2024-01-01', 'YYYY-MM-DD');