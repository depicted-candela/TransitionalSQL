        -- 3. UTL_FILE: Server-Side File I/O

-- The UTL_FILE package provides a secure way for PL/SQL to read and write OS files on the database server, managed through Oracle's DIRECTORY objects.

--      Exercise 3.1: Writing a Log File
-- Problem: Create a PL/SQL procedure that takes a message string and appends it, prefixed with a timestamp, to a log file named application.log in the UTL_FILE_DIR directory.

-- Reference: PL/SQL Packages and Types Reference for UTL_FILE.

--      Exercise 3.2: Handling `NO_DATA_FOUND` on Read
-- Problem: Write a PL/SQL block that reads the application.log file line by line until the end of the file is reached. Demonstrate how to properly handle the NO_DATA_FOUND exception, which is the expected way to detect the end of a file.