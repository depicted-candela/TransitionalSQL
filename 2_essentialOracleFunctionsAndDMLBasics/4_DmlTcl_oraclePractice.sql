        -- 3. Data Manipulation Language (DML) & Transaction Control (Practice in Oracle)


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 4.1.1: Oracle DML and Transaction Control Basics
-- Problem:
-- a. INSERT: Add a new department 'Operations' (departmentId 60) located in 'Chicago' to the Departments table.
-- INSERT INTO ESSENTIAL_FUNCTIONS_DMLBASICS.DEPARTMENTS (DEPARTMENTID, DEPARTMENTNAME, LOCATIONCITY) VALUES (60, 'Operations', 'Chicago');
-- b. SAVEPOINT: Create a savepoint named pre_salary_update.
-- SAVEPOINT pre_salary_update;
-- c. UPDATE: Increase the salary of all employees in the 'Technology' department (departmentId 10) by 5%. Use the ROUND function to ensure the new salary has 
-- -- two decimal places.
UPDATE ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES e
SET SALARY = e.SALARY * 1.05
WHERE DEPARTMENTID = 10;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES;
-- d. DELETE: Remove any assignments from ProjectAssignments for employee Frank Miller (employeeId 106). Then, delete Frank Miller from the Employees table.
DELETE FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTASSIGNMENTS WHERE EMPLOYEEID = 106;
DELETE FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES
WHERE EMPLOYEEID = 106;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 106;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTASSIGNMENTS WHERE EMPLOYEEID = 106;
-- e. ROLLBACK TO SAVEPOINT: It was decided not to delete Frank Miller yet. Rollback the changes to pre_salary_update. Verify Frank Miller and his assignments 
-- are back, but the salary updates for Tech employees persist. *(Adjust savepoint placement if necessary for intended demonstration)*
ROLLBACK;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.PROJECTASSIGNMENTS WHERE EMPLOYEEID = 106;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES WHERE EMPLOYEEID = 106;
-- f. COMMIT: Make the salary updates permanent.
UPDATE ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES e
SET SALARY = ROUND(e.SALARY * 1.05, 2)
WHERE DEPARTMENTID = 10;
COMMIT;
SELECT * FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EMPLOYEES;
-- g. MERGE (Oracle Specific Advantage): Use the EmployeeUpdatesForMerge table (populated earlier) to update existing employees or insert new ones into the 
-- Employees table.

-- If an employeeId from EmployeeUpdatesForMerge exists in Employees, update their jobTitle, salary, and departmentId.
-- If an employeeId does not exist, insert a new employee record: firstName='NewEmp', lastName='ViaMerge', email as employeeId || '@merge.com', and other 
-- details from EmployeeUpdatesForMerge, hireDate as SYSDATE.
-- Explain the advantage of MERGE over separate UPDATE and INSERT statements (atomicity, performance, readability). Contrast with PostgreSQL's INSERT ... 
-- ON CONFLICT.
SAVEPOINT previous_to_merge;
MERGE INTO ESSENTIAL_FUNCTIONS_DMLBASICS.Employees e
USING ESSENTIAL_FUNCTIONS_DMLBASICS.EmployeeUpdatesForMerge u
    ON (e.employeeId = u.employeeId)
WHEN MATCHED THEN
    UPDATE SET
        e.jobTitle = u.newJobTitle,
        e.salary = u.newSalary,
        e.departmentId = u.newDepartmentId
WHEN NOT MATCHED THEN
    INSERT (employeeId, firstName, lastName, email, jobTitle, salary, departmentId, hireDate)
    VALUES (u.employeeId, 'NewEmp', 'ViaMerge', u.employeeId || '@merge.com', u.newJobTitle, u.newSalary, u.newDepartmentId, SYSDATE);
COMMIT;


--  (ii) Disadvantages and Pitfalls

--      Exercise 4.2.1: DML and Transaction Pitfalls
-- Problem:
-- a. A developer issues UPDATE Employees SET commissionPct = 0.05 WHERE departmentId = 30; but forgets to COMMIT. They then run a report query in the *same 
-- session* that relies on commissionPct. What value will the report see? What if another session runs the report? What happens if the first session closes 
-- without COMMIT?
-- Answer: when something is not committed, changes just appear in the session they were written, thus none despite the session were such updatings were
-- made will have the changes. If the session is closed not commiting the changes in stage, they will be lost
-- b. An intern accidentally runs DELETE FROM Projects; (without a WHERE clause). What is the immediate action they should take if this was unintended and no 
-- COMMIT has been issued?
-- Answer: SET AUTOCOMMIT OFF must be declared in all sessions to allow ROLLBACK to be used as a sort of Ctrl+z but for SQL. 
-- c. A MERGE statement's ON clause is ON (target.departmentId = source.departmentId). If departmentId is not unique in the source table for a given 
-- departmentId in the target, what error might occur and why?
-- Answer: a relation 1:N occurring means that the operation will fail returning the error 'ORA-30926: unable to get a stable set of rows in the source tables.'
-- d. A transaction starts, a savepoint S1 is created, some DML (DML1) occurs, another savepoint S2 is created, more DML (DML2) occurs. If ROLLBACK TO S1 is 
-- issued, what is the state of DML1 and DML2? What happens to savepoint S2?
-- Answer: if the rollback comes to S1, all changes (DMLs) after to it will be unset and unreachable because and the subsequent savepoints will be unreachable.


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 4.3.1: Conditional Insert/Update - MERGE vs. Separate UPDATE then INSERT (with NOT EXISTS)
-- Problem: You need to synchronize data from EmployeeUpdatesForMerge into Employees. If an employee exists (matched by employeeId), update their jobTitle and 
-- salary. If not, insert them.
-- Less Efficient/More Complex Common Solution: A developer might write two separate SQL statements:
-- An UPDATE statement for existing employees (perhaps using EXISTS or an updatable join).
-- An INSERT ... SELECT statement for new employees, using NOT EXISTS or a LEFT JOIN ... WHERE IS NULL to identify those not already present.
-- Show this two-statement SQL approach.
-- Explain its disadvantages (multiple table scans, potential for race conditions if not perfectly isolated, more complex logic).
-- Present the efficient, Oracle-idiomatic solution using MERGE.
-- Answer:
-- Inefficient, prone to be badly written and with race condition problems 
-- Step 1: Update existing employees
UPDATE ESSENTIAL_FUNCTIONS_DMLBASICS.Employees e
SET (jobTitle, salary, departmentId) = (
    SELECT u.newJobTitle, u.newSalary, u.newDepartmentId
    FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EmployeeUpdatesForMerge u
    WHERE u.employeeId = e.employeeId
) WHERE EXISTS (                -- Too much verbosity, uses two where satatemts to do the same
    SELECT 1
    FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EmployeeUpdatesForMerge u
    WHERE u.employeeId = e.employeeId
);
-- Step 2: Insert new employees
INSERT INTO ESSENTIAL_FUNCTIONS_DMLBASICS.Employees (employeeId, firstName, lastName, email, jobTitle, salary, departmentId, hireDate)
SELECT
    u.employeeId, 'Separate', 'SQL', u.employeeId || '@separate.com',
    u.newJobTitle, u.newSalary, u.newDepartmentId, SYSDATE
FROM ESSENTIAL_FUNCTIONS_DMLBASICS.EmployeeUpdatesForMerge u
WHERE NOT EXISTS (              -- With MERGE this is not necessary to be used again
    SELECT 1
    FROM ESSENTIAL_FUNCTIONS_DMLBASICS.Employees e
    WHERE e.employeeId = u.employeeId
);
COMMIT; -- After both operations
-- Efficient, cleaner, less verbose and solved for problemantic race conditions
MERGE INTO ESSENTIAL_FUNCTIONS_DMLBASICS.Employees e
USING ESSENTIAL_FUNCTIONS_DMLBASICS.EmployeeUpdatesForMerge u
    ON (e.employeeId = u.employeeId)
WHEN MATCHED THEN
    UPDATE SET
        e.jobTitle = u.newJobTitle,
        e.salary = u.newSalary,
        e.departmentId = u.newDepartmentId
WHEN NOT MATCHED THEN
    INSERT (employeeId, firstName, lastName, email, jobTitle, salary, departmentId, hireDate)
    VALUES (u.employeeId, 'NewEmp', 'ViaMerge', u.employeeId || '@merge.com', u.newJobTitle, u.newSalary, u.newDepartmentId, SYSDATE);