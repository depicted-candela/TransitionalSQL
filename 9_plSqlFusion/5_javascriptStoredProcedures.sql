        -- 5. JavaScript Stored Procedures (Oracle 23ai MLE)


-- The Multilingual Engine (MLE) in Oracle 23ai allows developers to define and execute JavaScript code directly within the database.

--      Exercise 5.1: Creating and Calling a Simple JavaScript Function
-- Problem: Create a JavaScript module that exports a function to format a username by combining a first and last name into a standard corporate email address. 
-- Then, create a SQL call specification for this function and execute it from a SQL query against the employees table.

-- (Connect as a user with DBA privileges or the PLSQLFUSION user if it has DROP ANY)
-- It's safest to run the drops as the object owner, PLSQLFUSION.

-- Clean up existing objects first
BEGIN
   EXECUTE IMMEDIATE 'DROP FUNCTION PLSQLFUSION.MAILER_FUNCTION';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP MLE MODULE PLSQLFUSION.MAILER';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -24201 THEN
            RAISE;
        END IF;
END;
/
-- Now, grant privileges and create the objects
-- (Run as SYS or a user with grant privileges)
GRANT CREATE PROCEDURE TO PLSQLFUSION;
GRANT EXECUTE ON JAVASCRIPT TO PLSQLFUSION;

-- (Connect as PLSQLFUSION to create the objects in its schema)
CREATE OR REPLACE MLE MODULE PLSQLFUSION.MAILER
LANGUAGE JAVASCRIPT AS 
    function mailCreator(firstName, lastName) {
        if (typeof firstName !== 'string' || typeof lastName !== 'string') return null;
        return firstName.toLowerCase() + '_' + lastName.toLowerCase() + '@corporation.org';
    }
    export { mailCreator }
/

CREATE OR REPLACE FUNCTION PLSQLFUSION.mailer_function(firstName IN VARCHAR2, lastName IN VARCHAR2)
RETURN VARCHAR2
AS MLE MODULE PLSQLFUSION.MAILER
SIGNATURE 'mailCreator(string, string)';
/
SELECT PLSQLFUSION.mailer_function(FIRSTNAME, LASTNAME) FROM PLSQLFUSION.EMPLOYEES;
-- Reference: Oracle Database JavaScript Developer's Guide.

--      Exercise 5.2: Complex JSON Validation
-- Problem: An event from a device is valid only if it has a temperature reading, a status of "active", and the device name matches the pattern Sensor-[A-Z][0-9].
DECLARE
    v_eventId SMALLINT := 1;
    v_isValid BOOLEAN;
BEGIN
    SELECT JSON_EXISTS(METRICS, '$.temperature') AND JSON_VALUE(METRICS, '$.status') = 'active' AND REGEXP_LIKE(DEVICE, 'Sensor-[A-Z][0-9]') INTO v_isValid
    FROM PLSQLFUSION.EVENTLOGS WHERE EVENTID = v_eventId;
    DBMS_OUTPUT.PUT_LINE('Device ');
    IF v_isValid THEN DBMS_OUTPUT.PUT_LINE('valid of event ('||v_eventId||')'); ELSE DBMS_OUTPUT.PUT_LINE('invalid of event ('||v_eventId||')'); END IF;
END;
/

CREATE OR REPLACE MLE MODULE PLSQLFUSION.VALIDATION_LOGIC_MOD LANGUAGE JAVASCRIPT AS
    function isValidEvent(metrics, device) {
        const deviceRegex = /^Sensor-[A-Z][0-9]$/;
        if (!deviceRegex.test(device)) return false;
        if (metrics === null) return false;
        if (!("temperature" in metrics)) return false;
        if (!("active" in metrics) || metrics.active !== "active") return false;
        return true;
    }
    export { isValidEvent }
/

CREATE OR REPLACE FUNCTION PLSQLFUSION.isValidEventJS("metrics" JSON, device IN VARCHAR2) RETURN BOOLEAN
AS MLE MODULE PLSQLFUSION.VALIDATION_LOGIC_MOD
SIGNATURE 'isValidEvent(any, string)';
/

SELECT PLSQLFUSION.isValidEventJS(METRICS, DEVICE) isValidEvent
FROM PLSQLFUSION.EVENTLOGS;

-- Implement this validation first using only PL/SQL, and then contrast it with a more concise and readable JavaScript implementation using MLE.
