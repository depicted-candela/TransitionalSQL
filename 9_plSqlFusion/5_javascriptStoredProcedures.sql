5. JavaScript Stored Procedures (Oracle 23ai MLE)
The Multilingual Engine (MLE) in Oracle 23ai allows developers to define and execute JavaScript code directly within the database.

Exercise 5.1: Creating and Calling a Simple JavaScript Function
Problem: Create a JavaScript module that exports a function to format a username by combining a first and last name into a standard corporate email address. Then, create a SQL call specification for this function and execute it from a SQL query against the employees table.

Reference: Oracle Database JavaScript Developer's Guide.
Exercise 5.2: Complex JSON Validation
Problem: An event from a device is valid only if it has a temperature reading, a status of "active", and the device name matches the pattern Sensor-[A-Z][0-9]. Implement this validation first using only PL/SQL, and then contrast it with a more concise and readable JavaScript implementation using MLE.