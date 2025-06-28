        -- Future of Oracle: SQL Innovations in 23ai



--  (i) Meanings, Values, Relations, and Advantages


--          Group 1: DDL and DML Enhancements
-- This group focuses on features that simplify how you define schema objects and modify data, making your code more robust and efficient.

--      Problem 1: Conditional DDL with IF EXISTS
-- Description: Write a script that first attempts to drop a table named future.tempProjects. The script should not fail if the table doesn't exist. Then, write a 
-- statement to create the same future.tempProjects table (with columns projectId NUMBER, projectName VARCHAR2(100)), but only if it does not already exist.
DROP TABLE IF EXISTS future.tempProjects;
CREATE TABLE IF NOT EXISTS Future.tempProjects (
    projectId NUMBER,
    projectName VARCHAR2(100)
);
--      Problem 2: Updating Records with a FROM Clause Join
-- Description: The company has decided to give a 5% salary cut to all employees in the 'Sales' department who received a 'Below Average' performance review. Write a 
-- single UPDATE statement to apply this change.
UPDATE FUTURE.EMPLOYEES SET SALARY = SALARY * 1.05 WHERE EMPLOYEEID IN (
SELECT EMPLOYEEID
FROM FUTURE.EMPLOYEES NATURAL JOIN FUTURE.DEPARTMENTS NATURAL JOIN FUTURE.PERFORMANCEREVIEWS 
WHERE DEPARTMENTNAME = 'Sales' AND REVIEWSCORE = 'Below Average');
COMMIT;
--      Problem 3: Using the RETURNING Clause to Capture Changed Data
-- Description: The HR department in 'New York' is being dissolved. All employees in that department must be deleted. As you delete them, you need to capture their 
-- employeeId and lastName into a log table (future.archivedEmployees). Use the DELETE statement with the RETURNING clause to accomplish this in a single step within 
-- a PL/SQL block.
SAVEPOINT problem_three;
DECLARE
    TYPE archivedEmployeesT IS TABLE OF FUTURE.archivedEmployees%ROWTYPE INDEX BY PLS_INTEGER;
    archivedEmployees archivedEmployeesT;
BEGIN
    DELETE FROM FUTURE.EMPLOYEES 
    WHERE EMPLOYEEID IN (
        SELECT EMPLOYEEID 
        FROM FUTURE.EMPLOYEES 
        NATURAL JOIN FUTURE.DEPARTMENTS 
        WHERE LOCATIONCITY = 'New York'
    ) RETURNING EMPLOYEEID, LASTNAME, SYSDATE BULK COLLECT INTO archivedEmployees;
    FORALL i IN INDICES OF archivedEmployees
        INSERT INTO FUTURE.ARCHIVEDEMPLOYEES VALUES archivedEmployees(i);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT ||' rows inserted');
END;
/
COMMIT;


--          Group 2: Querying Conveniences
-- This group covers new features that make writing common queries simpler, more intuitive, and more readable.

--      Problem 1: GROUP BY with an Alias
-- Description: Write a query that calculates the total sales for each region. In your SELECT list, alias the region column as salesRegion. Use this alias salesRegion
-- in the GROUP BY clause.
SELECT REGION SALESREGION, SUM(SALESAMOUNT) FROM FUTURE.REGIONALSALES GROUP BY SALESREGION;
--      Problem 2: SELECT without a FROM Clause
-- Description: Perform two simple calculations without referencing any table:
-- Find the result of SYSDATE + 7.
-- Calculate 100 * 1.05.
SELECT SYSDATE + 7;
SELECT 100 * 1.05;
-- Problem 3: Using the VALUES Clause to Construct an Inline Table
-- Description: You have a new set of product price points to analyze. Without creating a permanent table, construct a two-column, three-row result set using the 
-- VALUES clause for the following data: ('Gadget', 50.00), ('Widget', 75.50), ('Sprocket', 25.00). Then, join this on-the-fly table with your regionalSales table to 
-- show the total sales for each of these products.
SELECT PRODUCT, SUM(SALESAMOUNT) regionalSales FROM (
SELECT PRODUCT, SALESAMOUNT FROM FUTURE.REGIONALSALES
UNION ALL
SELECT PRODUCT, SALESAMOUNT FROM (VALUES('Gadget', 50.00), ('Widget', 75.50), ('Sprocket', 25.00)) r(product, salesAmount))
GROUP BY PRODUCT;


--          Group 3: Advanced Data Types and Functions
-- This group explores new data types and functions that enable more powerful and modern data modeling and analysis.

--      Problem 1: Using the Native BOOLEAN Data Type
-- Description: Query the future.projectTasks table to show the names of all tasks that have been marked as completed.
SELECT * FROM FUTURE.PROJECTTASKS WHERE ISCOMPLETED;
--      Problem 2: Aggregating INTERVAL Data Types
-- Description: For all completed tasks, calculate the total duration and the average duration. The duration of a task is the difference between its endDate and 
-- startDate.
SELECT AVG(ENDDATE - STARTDATE) FROM FUTURE.PROJECTTASKS WHERE ISCOMPLETED;
--      Problem 3: Grouping Data into Time Buckets
-- Description: You want to see how many tasks started in each 15-day period throughout the project's timeline. Use the TIME_BUCKET function to group the tasks. The 
-- "origin" of the bucketing should be the earliest task start date in the table. For more information on this function, see the Functions chapter in the SQL Language 
-- Reference.
DECLARE
    TYPE groupedTasks IS RECORD (start_time TIMESTAMP, tasks NUMBER);
    TYPE projectTasksT IS TABLE OF groupedTasks;
    projectTasks projectTasksT;
    earlierDate TIMESTAMP;
BEGIN
    SELECT STARTDATE INTO earlierDate FROM FUTURE.PROJECTTASKS ORDER BY STARTDATE FETCH NEXT 1 ROW ONLY;
    SELECT 
        TIME_BUCKET(STARTDATE, INTERVAL '15' DAY, earlierDate, START) start_time, COUNT(*) tasks 
        BULK COLLECT INTO projectTasks 
    FROM FUTURE.PROJECTTASKS
    GROUP BY TIME_BUCKET(STARTDATE, INTERVAL '15' DAY, earlierDate, START);
    FOR i IN 1..projectTasks.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('start time: '||projectTasks(i).start_time||', tasks: '||projectTasks(i).tasks);
    END LOOP;
END;
/