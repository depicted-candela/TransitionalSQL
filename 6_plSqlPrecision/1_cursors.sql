        -- Cursors - Implicit Cursors, Explicit Cursors, Cursor FOR Loops)


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise C1: Problem: Write a PL/SQL anonymous block that attempts to update the salary of an employee with employeeId = 999 (who does not exist) by increasing
--  it by 10%. After the UPDATE statement, use Oracle's implicit cursor attributes to display:
-- Whether any row was found and updated (SQL%FOUND).
-- Whether no row was found and updated (SQL%NOTFOUND).
-- The number of rows affected (SQL%ROWCOUNT).
SET SERVEROUTPUT ON;
DECLARE 
    empId PLSQLPRECISION.EMPLOYEES.SALARY%TYPE := 999;
    foundRow BOOLEAN;
    notFoundRow BOOLEAN;
BEGIN
    SAVEPOINT prev;
    UPDATE PLSQLPRECISION.EMPLOYEES SET SALARY = SALARY * 1.1 WHERE employeeId = empId;
    IF SQL%FOUND 
        THEN DBMS_OUTPUT.PUT_LINE('ROWS FOUND');
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||'FOUND ROWS');
    ELSE
        IF SQL%NOTFOUND THEN DBMS_OUTPUT.PUT_LINE('ROWS NOT FOUND'); END IF;
    END IF;
    ROLLBACK;
END;
/

--      Exercise C2: Problem: Write a PL/SQL anonymous block that declares an explicit cursor to fetch the firstName, lastName, and salary of all employees in the 'IT'
-- department. Loop through the cursor, fetching one row at a time, and display the details. Ensure the cursor is properly opened and closed. Use %TYPE for variable 
-- declarations.
DECLARE
    CURSOR fetcher IS (
        SELECT FIRSTNAME, LASTNAME, SALARY 
        FROM PLSQLPRECISION.EMPLOYEES 
        NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'IT'
    );
    TYPE fetching IS RECORD (
        FIRSTNAME PLSQLPRECISION.EMPLOYEES.FIRSTNAME%TYPE,
        LASTNAME PLSQLPRECISION.EMPLOYEES.LASTNAME%TYPE,
        SALARY PLSQLPRECISION.EMPLOYEES.SALARY%TYPE
    );
    fetchingData fetching;
BEGIN
    OPEN fetcher;
    LOOP
        FETCH fetcher INTO fetchingData;
        EXIT WHEN fetcher%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Row: ('||fetchingData.FIRSTNAME||', '||fetchingData.LASTNAME||', '||fetchingData.SALARY);
    END LOOP;
    CLOSE fetcher;
END;
/

--      Exercise C3: Problem: Rewrite the previous exercise (C2) using a cursor FOR loop to display the firstName, lastName, and salary of all employees in the 'IT' 
-- department.
BEGIN
    FOR x IN (SELECT FIRSTNAME, LASTNAME, SALARY 
        FROM PLSQLPRECISION.EMPLOYEES 
        NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'IT'
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Row: ('||x.FIRSTNAME||', '||x.LASTNAME||', '||x.SALARY);
    END LOOP;
END;
/

--      Exercise C4: Problem: Explain the meaning and demonstrate the use of SQL%ISOPEN with an implicit cursor and an explicit cursor. Why does SQL%ISOPEN always 
-- return FALSE for implicit cursors after the SQL statement execution?
-- Answer: SQL%ISOPEN is used to check if the cursor is currently open. An implicit cursor has well defined begin and end points within itself (its declaration), 
-- because a declaration does not have a separate open and close phase, it is always closed after the SQL statement execution.
DECLARE     -- Explicit cursor example
    CURSOR fetcher IS (
        SELECT FIRSTNAME, LASTNAME, SALARY 
        FROM PLSQLPRECISION.EMPLOYEES 
        NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'IT'
    );
    TYPE fetching IS RECORD (
        FIRSTNAME PLSQLPRECISION.EMPLOYEES.FIRSTNAME%TYPE,
        LASTNAME PLSQLPRECISION.EMPLOYEES.LASTNAME%TYPE,
        SALARY PLSQLPRECISION.EMPLOYEES.SALARY%TYPE
    );
    fetchingData fetching;
BEGIN
    OPEN fetcher;
    LOOP
        FETCH fetcher INTO fetchingData;
        EXIT WHEN fetcher%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Row: ('||fetchingData.FIRSTNAME||', '||fetchingData.LASTNAME||', '||fetchingData.SALARY);
    END LOOP;
    CLOSE fetcher;
END;
/

BEGIN   -- Implicit cursor example
    FOR x IN (SELECT FIRSTNAME, LASTNAME, SALARY 
        FROM PLSQLPRECISION.EMPLOYEES 
        NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'IT'
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Row: ('||x.FIRSTNAME||', '||x.LASTNAME||', '||x.SALARY);
    END LOOP;
END;
/


--  (ii) Disadvantages and Pitfalls

--      Exercise C5: Problem: Write a PL/SQL block that declares an explicit cursor but forgets to close it after processing. Then, write another PL/SQL block that 
-- tries to open the same named cursor again (simulate this by running the first block, then the second in a SQL*Plus session or similar tool where session state 
-- persists for cursors if not properly managed). What is the potential issue here, and what Oracle error might you encounter?
DECLARE     -- Explicit cursor example
    CURSOR fetcher IS (
        SELECT FIRSTNAME, LASTNAME, SALARY 
        FROM PLSQLPRECISION.EMPLOYEES 
        NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'IT'
    );
    TYPE fetching IS RECORD (
        FIRSTNAME PLSQLPRECISION.EMPLOYEES.FIRSTNAME%TYPE,
        LASTNAME PLSQLPRECISION.EMPLOYEES.LASTNAME%TYPE,
        SALARY PLSQLPRECISION.EMPLOYEES.SALARY%TYPE
    );
    fetchingData fetching;
BEGIN
    OPEN fetcher;
    LOOP
        FETCH fetcher INTO fetchingData;
        EXIT WHEN fetcher%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Row: ('||fetchingData.FIRSTNAME||', '||fetchingData.LASTNAME||', '||fetchingData.SALARY);
    END LOOP;
    OPEN fetcher; -- This will cause an error because the cursor is already open and not closed.: ORA-06511: PL/SQL: cursor already open
    LOOP
        FETCH fetcher INTO fetchingData;
        EXIT WHEN fetcher%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Row: ('||fetchingData.FIRSTNAME||', '||fetchingData.LASTNAME||', '||fetchingData.SALARY);
    END LOOP;
END;
/

--      Exercise C6: Problem: A PL/SQL block uses SELECT ... INTO to fetch an employee's salary. What are two common exceptions (pitfalls) that can occur with 
-- SELECT ... INTO if the WHERE clause is not carefully constructed, and how can an explicit cursor or cursor FOR loop mitigate one of them?
-- Answer: Two common exceptions are:
-- 1. NO_DATA_FOUND: This occurs when the SELECT statement does not return any rows. An explicit cursor or cursor FOR loop can handle this by checking for %NOTFOUND.
-- 2. TOO_MANY_ROWS: This occurs when the SELECT statement returns more than one row. An explicit cursor or cursor FOR loop can handle this by iterating through all
--    rows instead of expecting a single row.

--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise C7: Problem: A developer needs to process all employees from the 'Sales' department. They write a PL/SQL block that first counts the total number of 
-- 'Sales' employees using one SELECT COUNT(*) query, and then uses this count in a WHILE loop with an explicit cursor, fetching one employee at a time and manually 
-- incrementing a counter to stop the loop. Demonstrate this potentially less efficient approach. Then, provide the more Oracle-idiomatic and efficient solution using 
-- a cursor FOR loop or an explicit cursor with EXIT WHEN %NOTFOUND. Explain why the latter is generally preferred.
DECLARE
    CURSOR salesCursor IS (
        SELECT FIRSTNAME, LASTNAME, SALARY 
        FROM PLSQLPRECISION.EMPLOYEES 
        NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'Sales'
    );
    TYPE salesDataType IS RECORD (
        FIRSTNAME PLSQLPRECISION.EMPLOYEES.FIRSTNAME%TYPE,
        LASTNAME PLSQLPRECISION.EMPLOYEES.LASTNAME%TYPE,
        SALARY PLSQLPRECISION.EMPLOYEES.SALARY%TYPE
    );
    salesData salesDataType;
    totalSalesEmployees NUMBER;
    counter NUMBER := 0;
BEGIN
    -- Inefficient approach: Count first, then loop
    SELECT COUNT(*) INTO totalSalesEmployees FROM PLSQLPRECISION.EMPLOYEES 
    NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'Sales';
    DBMS_OUTPUT.PUT_LINE('Total Sales Employees: ' || totalSalesEmployees);
    OPEN salesCursor;
    WHILE counter < totalSalesEmployees LOOP
        FETCH salesCursor INTO salesData;
        EXIT WHEN salesCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee: (' || salesData.FIRSTNAME || ', ' || salesData.LASTNAME || ', ' || salesData.SALARY || ')');
        counter := counter + 1;
    END LOOP;
    CLOSE salesCursor;
    -- Efficient approach: Using cursor FOR loop
    DBMS_OUTPUT.PUT_LINE('Using cursor FOR loop:');
    FOR x IN (SELECT * FROM PLSQLPRECISION.EMPLOYEES NATURAL JOIN PLSQLPRECISION.DEPARTMENTS WHERE DEPARTMENTNAME = 'Sales') LOOP
        DBMS_OUTPUT.PUT_LINE('Employee: (' || x.FIRSTNAME || ', ' || x.LASTNAME || ', ' || x.SALARY || ')');
    END LOOP;
END;
/