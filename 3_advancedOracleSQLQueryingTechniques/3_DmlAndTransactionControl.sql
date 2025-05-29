--      Data Manipulation Language (DML) & Transaction Control (Practice in Oracle)
-- (MERGE statement (Oracle Specific))

--  (i) Meanings, Values, Relations, and Advantages
        -- Exercise DML.1.1: Basic UPSERT with MERGE
-- Problem: Synchronize the Employees table with data from EmployeeUpdates.
-- SET AUTOCOMMIT OFF;
-- SAVEPOINT after_employee_updating;

-- MERGE INTO ADVANCED_QUERYING.EMPLOYEES E
-- USING (
--     SELECT l.EMPLOYEEID, l.EMPLOYEENAME, l.JOBTITLE, l.MANAGERID, l.HIREDATE, l.SALARY, l.DEPARTMENTID, l.EMAIL, l.CHANGEREASON
--     FROM (
--         SELECT eo.*, ROW_NUMBER() OVER(PARTITION BY EMPLOYEEID ORDER BY eo.HIREDATE, eo.SALARY, eo.CHANGEREASON) uniqueness
--         FROM ADVANCED_QUERYING.EMPLOYEEUPDATES eo
--     ) l WHERE l.uniqueness = 1
-- ) EU
-- ON (E.EMPLOYEEID = EU.EMPLOYEEID)
-- WHEN MATCHED 
--     THEN UPDATE SET JOBTITLE = EU.JOBTITLE, SALARY = EU.SALARY, EMAIL = EU.EMAIL
--     DBMS_OUTPUT.PUT_LINE('Not necessary the final rollback because 2 employees were recognized');
-- WHEN NOT MATCHED THEN
--     INSERT (EMPLOYEEID, EMPLOYEENAME, JOBTITLE, MANAGERID, HIREDATE, SALARY, DEPARTMENTID, EMAIL)
--     VALUES (EU.EMPLOYEEID, EU.EMPLOYEENAME, EU.JOBTITLE, EU.MANAGERID, EU.HIREDATE, EU.SALARY, EU.DEPARTMENTID, EU.EMAIL);
--     DBMS_OUTPUT.PUT_LINE('Not necessary the final rollback because 2 employees were recognized');

-- SELECT * FROM ADVANCED_QUERYING.EMPLOYEES;

-- COMMIT;
-- If an employee from EmployeeUpdates exists in Employees (match on employeeId), update their jobTitle, salary, and email.
-- If an employee from EmployeeUpdates does not exist in Employees, insert them as a new record.
-- Focus on records for Bob Green (employeeId 103 - for update) and Nina Young (employeeId 501 - for insert) from the EmployeeUpdates table. After running the 
-- MERGE, verify the changes and then ROLLBACK.
-- Bridging Focus: PostgreSQL users achieve UPSERT using INSERT ... ON CONFLICT DO UPDATE. MERGE is Oracle's more versatile equivalent.
-- Concepts: MERGE INTO, USING, ON, WHEN MATCHED THEN UPDATE, WHEN NOT MATCHED THEN INSERT.

        -- Exercise DML.1.2: MERGE with Conditional Update and Delete
-- Problem: Use MERGE to update Employees based on EmployeeUpdates:
-- For 'Grace Davis' (employeeId 203), if her proposed salary in EmployeeUpdates is higher than her current salary, update her jobTitle, salary, and email.
-- Add a record to EmployeeUpdates for Carol White (employeeId 104) with changeReason = 'Obsolete Role'. Then, for any employee in EmployeeUpdates (matched with 
-- Employees) tagged with changeReason = 'Obsolete Role', delete them from the Employees table.
-- Perform these actions in a single MERGE statement. Verify changes and then ROLLBACK. Clean up the added 'Obsolete Role' record from EmployeeUpdates.
-- Concepts: MERGE with conditional UPDATE (using WHERE in UPDATE clause) and WHEN MATCHED THEN DELETE.
SELECT * FROM ADVANCED_QUERYING.;


--  (ii) Disadvantages and Pitfalls
        -- Exercise DML.2.1: Non-Deterministic Source for MERGE
-- Problem: The EmployeeUpdates table currently has two entries for employeeId = 105 (David Black) with different salaries.
-- Attempt to use this non-deterministic source in a MERGE statement to update Employees.salary. Observe and explain the ORA-30926 error.
-- Modify the USING clause of your MERGE statement to deterministically pick one of the update records for employeeId 105 (e.g., based on changeReason) to 
-- prevent the error. Execute the corrected MERGE, verify, and then ROLLBACK.
-- Concepts: ORA-30926: unable to get a stable set of rows in the source tables, ensuring deterministic source data for MERGE.


--  (iii) Contrasting with Inefficient Common Solutions
        -- Exercise DML.3.1: Synchronizing Data - MERGE vs. Procedural Logic
-- Problem: Synchronize Employees with EmployeeUpdates for employeeId = 204 (Henry Wilson - salary review, no change initially) and employeeId = 501 (Nina 
-- Young - new hire). The EmployeeUpdates record for Henry Wilson (204) has a salary of 60000.
-- First, describe conceptually (pseudo-code) how one might do this inefficiently using separate UPDATE and INSERT statements, perhaps with existence checks or 
-- within a PL/SQL loop.
-- Then, provide the efficient Oracle MERGE solution. Ensure the MERGE only updates Henry Wilson if there is an actual change to his salary or other specified 
-- fields. Verify results and ROLLBACK.
-- Concepts: MERGE efficiency and atomicity vs. multiple DMLs/PL/SQL.