        -- Exception Handling: Predefined exceptions, user-defined exceptions, SQLCODE, SQLERRM, PRAGMA EXCEPTION_INIT

--  (i) Meanings, Values, Relations, and Advantages
--      Exercise 1.4: Handling Predefined Exceptions

-- Problem: Write a PL/SQL anonymous block that attempts to:
-- Select an employee's salary into a NUMBER variable for an employeeId that does not exist in the Employees table.
-- Handle the NO_DATA_FOUND predefined exception and print a user-friendly message.
-- Attempt to divide a number by zero.
-- Handle the ZERO_DIVIDE predefined exception and print a user-friendly message.
-- Focus: Understand how to catch and handle common predefined Oracle exceptions.
-- Relations:
-- Oracle: Directly uses predefined exceptions. PL/SQL Language Reference (F46753-09), Chapter 12, "Predefined Exceptions" (p. 12-11, Table 12-3 lists them).
-- PostgreSQL Bridge: PostgreSQL also has predefined exceptions (e.g., no_data_found, division_by_zero). The concept is similar, but the specific exception names and the EXCEPTION WHEN ... THEN syntax are key Oracle PL/SQL constructs.
-- Advantages Demonstrated: Graceful error recovery, providing better user experience than unhandled errors.
-- Exercise 1.5: Declaring and Raising User-Defined Exceptions

-- Problem:
-- Create a procedure CheckProductStock that takes pProductId and pQuantityRequired as input.
-- Inside the procedure, declare a user-defined exception named LowStockWarning.
-- If the stockQuantity for the given pProductId in the Products table is less than pQuantityRequired but greater than 0, raise LowStockWarning.
-- If stockQuantity is 0, raise the predefined NO_DATA_FOUND (or a different user-defined exception like OutOfStockError).
-- The procedure should have an exception block to handle LowStockWarning by printing "Warning: Low stock for product ID [ID]." and NO_DATA_FOUND by printing "Error: Product ID [ID] is out of stock." Write an anonymous block to test both scenarios (low stock and out of stock for Product ID 1002 'Wireless Mouse' and 1003 'Monitor HD' respectively, assuming initial quantities).
-- Focus: Learn how to declare, raise, and handle user-defined exceptions.
-- Relations:
-- Oracle: PL/SQL Language Reference (F46753-09), Chapter 12, "User-Defined Exceptions" (p. 12-13) and "Raising Exceptions Explicitly" (p. 12-15).
-- PostgreSQL Bridge: PostgreSQL's RAISE EXCEPTION is similar in concept. Oracle's DECLARE exception_name EXCEPTION; and RAISE exception_name; syntax is specific.
-- Advantages Demonstrated: Ability to create custom error conditions specific to application logic.
-- Exercise 1.6: Using SQLCODE, SQLERRM, and PRAGMA EXCEPTION_INIT

-- Problem:
-- Declare a user-defined exception NegativeSalaryError.
-- Use PRAGMA EXCEPTION_INIT to associate this exception with the Oracle error code -20002.
-- Create a procedure ValidateSalary that takes a newSalary as input. If newSalary is negative, raise NegativeSalaryError.
-- Write an anonymous block that calls ValidateSalary with a negative salary. The exception handler in the anonymous block should catch NegativeSalaryError and print the error code using SQLCODE and the error message using SQLERRM.
-- Focus: Understand how to use SQLCODE and SQLERRM for error diagnostics and PRAGMA EXCEPTION_INIT to map custom exceptions to Oracle error numbers.
-- Relations:
-- Oracle: PL/SQL Language Reference (F46753-09), Chapter 12, "Retrieving Error Code and Error Message" (p. 12-27) and "Naming Internally Defined Exception" (p. 12-10), which explains PRAGMA EXCEPTION_INIT.
-- PostgreSQL Bridge: PostgreSQL has SQLSTATE and SQLERRM available in its EXCEPTION block. Oracle's SQLCODE is an integer, and PRAGMA EXCEPTION_INIT provides a way to give a name to a specific ORA- error or a user-defined error number within the range -20000 to -20999.
-- Advantages Demonstrated: Standardized error reporting, ability to handle specific Oracle errors by custom names.
-- (ii) Disadvantages and Pitfalls (Exception Handling)
-- Exercise 2.3: Overuse of WHEN OTHERS

-- Problem: Write a procedure ProcessOrder that performs several DML operations (e.g., inserts into Orders, then OrderItems, then updates Products). Include a single WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An error occurred.'); exception handler at the end. Discuss the disadvantages of this approach. How could it be improved for better error diagnosis and recovery?
-- Focus: Highlight the pitfalls of catching all exceptions with a generic WHEN OTHERS without specific handling or re-raising.
-- Disadvantage/Pitfall: Masks the actual error, making debugging very difficult. The specific cause of the failure is lost. It might also prevent proper transaction rollback if the error is critical.
-- Relevant Docs: PL/SQL Language Reference (F46753-09), Chapter 12, "Guidelines for Avoiding and Handling Exceptions" (p. 12-9) - especially the point about writing handlers for named exceptions.
-- Exercise 2.4: Exception Propagation and Unhandled Exceptions

-- Problem:
-- Create a procedure InnerProc that attempts to insert a duplicate productId into the Products table (which will raise DUP_VAL_ON_INDEX due to the primary key constraint). InnerProc should not have an exception handler for DUP_VAL_ON_INDEX.
-- Create another procedure OuterProc that calls InnerProc. OuterProc should also not have an exception handler for DUP_VAL_ON_INDEX.
-- Write an anonymous block that calls OuterProc. This block should have an exception handler for DUP_VAL_ON_INDEX. Explain the flow of exception propagation. What happens if the anonymous block also doesn't handle it?
-- Focus: Demonstrate how unhandled exceptions propagate up the call stack.
-- Pitfall: If an exception propagates all the way to the client without being handled, it can result in an ungraceful application termination or a generic error message to the user.
-- Relevant Docs: PL/SQL Language Reference (F46753-09), Chapter 12, "Exception Propagation" (p. 12-19).
-- (iii) Contrasting with Inefficient Common Solutions (Exception Handling)
-- Exercise 3.2: Manual Error Checking vs. Exception Handling

-- Scenario: A requirement is to ensure that when a new employee is added, their salary is within a valid range for their department (e.g., min 30000, max 150000 for Sales).
-- Inefficient Common Solution (Problem): A developer writes a procedure AddEmployeeManualCheck that takes employee details. After the INSERT statement, they use several IF statements to check if SQL%ROWCOUNT = 1 (for successful insert) and then separately query the salary ranges and check if the inserted salary is valid. If not, they try to manually DELETE the inserted record and print error messages.
-- Oracle-Idiomatic Solution (Solution): Create a procedure AddEmployeeWithException that declares a user-defined exception InvalidSalaryRange. Before the INSERT, check the salary. If invalid, RAISE InvalidSalaryRange. The INSERT only happens if the salary is valid. The calling block can then handle InvalidSalaryRange. Alternatively, use a CHECK constraint on the table if the range is static, or a trigger to validate (covered next). For this exercise, focus on the procedural exception.
-- Discussion Point: Explain how exception handling simplifies the logic, makes it more readable, and centralizes error management compared to scattered IF checks and manual rollback/delete attempts.
-- Focus: Show that proactive validation and raising custom exceptions leads to cleaner and more robust code than reactive manual checks and cleanups.
-- Loss of Advantages (Inefficient): Code becomes cluttered with error checks, manual cleanup is error-prone, transaction atomicity might be compromised if cleanup fails.