        -- PL/SQL Fundamentals


--  (ii) Disadvantages and Pitfalls

-- Exercise 2.1: PL/SQL Block - Unhandled Exceptions Pitfall
-- Problem: Write a PL/SQL block that attempts to select salary into a NUMBER variable for an employeeId that does not exist (e.g., 999). Do not include an EXCEPTION 
-- block initially. Observe the error. Then, modify the block to include a WHEN OTHERS THEN handler that prints a generic error message.

-- Disadvantage/Pitfall: Without an `EXCEPTION` block, a runtime error (like `NO_DATA_FOUND`) will halt the PL/SQL block's execution and propagate the error to the 
-- calling environment. This is often undesirable in production applications where graceful error handling is needed. Even with a `WHEN OTHERS` handler, not knowing 
-- the specific error can make debugging harder.

-- Exercise 2.2: Variables & Constants - %TYPE/%ROWTYPE and Dropped Columns
-- Problem:
-- Create a temporary table tempEmployees by copying employeeId, firstName, lastName, salary from employees.
-- Write a PL/SQL block that declares a record empRec tempEmployees%ROWTYPE and selects data into it. Print empRec.salary.
-- Outside the PL/SQL block, alter tempEmployees to drop the salary column.
-- Re-run the PL/SQL block. Observe the error.
-- Disadvantage/Pitfall: While `%ROWTYPE` adapts to data type changes or column additions, if a column referenced by the PL/SQL code (either directly or via 
-- `%ROWTYPE` field access) is dropped from the table, the PL/SQL block will become invalid and fail at compile-time or runtime when it's recompiled/executed. The block needs to be manually updated.

-- Exercise 2.3: Conditional Control - CASE Statement without ELSE and No Match
-- Problem: Write a PL/SQL block that uses a CASE statement to categorize an employee's jobTitle. Declare a variable jobCategory VARCHAR2(30). Fetch the jobTitle for 
-- employeeId = 101 ('Clerk'). The CASE statement should have WHEN clauses for 'Sales Manager' and 'Developer', but not for 'Clerk', and no ELSE clause. Attempt to 
-- print jobCategory. What happens?
-- Disadvantage/Pitfall: If a `CASE` statement does not find any matching `WHEN` condition and there is no `ELSE` clause, it raises a `CASE_NOT_FOUND` exception 
-- (ORA-06592). This must be handled if such scenarios are possible.

-- Exercise 2.4: Iterative Control - Infinite Basic LOOP
-- Problem: Write a PL/SQL block using a basic LOOP that intends to print a counter from 1 to 5. Deliberately forget to include the EXIT condition or the counter 
-- increment. What is the pitfall? (You might need to manually stop execution in your SQL client). Then, correct the loop.
-- Disadvantage/Pitfall: A basic `LOOP` without a proper `EXIT` condition (or a condition that never becomes true due to logic errors like not incrementing a counter) 
-- will result in an infinite loop, consuming resources and potentially requiring manual intervention to stop.

-- Exercise 2.5: SQL within PL/SQL - SELECT INTO with Multiple Rows
-- Problem: Write a PL/SQL block that attempts to use SELECT INTO to fetch lastName from the employees table where departmentId = 40 into a single scalar variable 
-- empLastName employees.lastName%TYPE. What is the pitfall? Handle the specific exception.
-- Disadvantage/Pitfall: If a `SELECT INTO` statement returns more than one row, it raises the predefined `TOO_MANY_ROWS` exception (ORA-01422). `SELECT INTO` is 
-- designed for queries expected to return exactly one row.