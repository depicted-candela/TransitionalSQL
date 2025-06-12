        -- 3. UTL_FILE: Server-Side File I/O

-- The UTL_FILE package provides a secure way for PL/SQL to read and write OS files on the database server, managed through Oracle's DIRECTORY objects.

--      Exercise 3.1: Writing a Log File
-- Problem: Create a PL/SQL procedure that takes a message string and appends it, prefixed with a timestamp, to a log file named application.log in the UTL_FILE_DIR 
-- directory.
CREATE OR REPLACE DIRECTORY UTL_FILE_DIR AS '/media/oracle_test_data';
GRANT READ, WRITE ON DIRECTORY UTL_FILE_DIR TO PLSQLFUSION;

CREATE OR REPLACE PROCEDURE PLSQLFUSION.writeAppLogging(
    message VARCHAR2 := 'Message for logging'
) IS vFile UTL_FILE.FILE_TYPE; 
    vLogLine VARCHAR2(100);
BEGIN
    vLogLine := message||TO_CHAR(SYSTIMESTAMP);
    vFile := UTL_FILE.FOPEN('UTL_FILE_DIR', 'application.log', 'a', 32767);
    UTL_FILE.PUT_LINE(vFile, vLogLine);
    UTL_FILE.FCLOSE(vFile);
EXCEPTION
    WHEN UTL_FILE.INVALID_PATH THEN DBMS_OUTPUT.PUT_LINE('The given path is invalid');
    WHEN OTHERS THEN 
        IF SQLCODE = -29434 THEN DBMS_OUTPUT.PUT_LINE('file does not exist');
        ELSE DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END IF;
END;
/

BEGIN PLSQLFUSION.writeAppLogging(); END;
/
-- Reference: PL/SQL Packages and Types Reference for UTL_FILE.

--      Exercise 3.2: Handling `NO_DATA_FOUND` on Read
CREATE OR REPLACE DIRECTORY UTL_FILE_DIR AS '/media/oracle_test_data';
GRANT READ, WRITE ON DIRECTORY UTL_FILE_DIR TO PLSQLFUSION;
DECLARE
    vFile UTL_FILE.FILE_TYPE;
    line VARCHAR2(32767);
BEGIN
    vFile := UTL_FILE.FOPEN('UTL_FILE_DIR', 'application.log', 'r');
    UTL_FILE.GET_LINE(vFile, line);
    WHILE line IS NOT NULL LOOP
        BEGIN
            DBMS_OUTPUT.PUT_LINE('The line was ' || line);
            UTL_FILE.GET_LINE(vFile, line);
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('End of the file'); EXIT;
        END;
    END LOOP;
END;
/
-- Problem: Write a PL/SQL block that reads the application.log file line by line until the end of the file is reached. Demonstrate how to properly handle the 
-- NO_DATA_FOUND exception, which is the expected way to detect the end of a file.