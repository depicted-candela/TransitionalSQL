        -- The Grand Finale: A Hardcore Combined Problem

-- ARCHIEVEQUEUETABLE, DEPARTMENTS, EMPLOYEES, EVENTLOGS, PRODUCTCATALOGS

-- This final challenge requires you to integrate all the concepts from this section—JavaScript MLE, DBMS_LOB, DBMS_AQ, UTL_FILE, and legacy packages—along with 
-- previous course knowledge like hierarchical queries and transaction control.

-- Problem: Automated Employee Onboarding & Auditing
-- You are tasked with building a new, automated employee onboarding and auditing system. The process involves multiple steps:
-- JavaScript Validation & Processing: An HR system provides new employee data as a JSON object. Create a JavaScript function processNewHire that validates the JSON 
-- (must contain firstName, lastName, and a valid email) and calculates a firstYearBonus which is 10% of the salary. The function should return a new JSON object 
-- containing the original data plus the calculated bonus.

-- PL/SQL Orchestration: Create a PL/SQL procedure onboardEmployee that accepts the new hire JSON as a CLOB.
--     It should first call the processNewHire JS function to validate and enrich the data.
--     If successful, it must insert the new employee into the employees table.
--     It must then generate a multi-line welcome letter as a CLOB using DBMS_LOB. The letter should include the employee's full name and their management chain, 
--     retrieved via a hierarchical query (CONNECT BY).

-- Legacy XML Archival: 
-- For compliance with a legacy system, the welcome letter CLOB must be converted to an XML document using the deprecated DBMS_XMLGEN package. The root element should 
-- be and each line should be in a element.
-- Asynchronous Messaging: The generated XML CLOB must then be enqueued into an onboardingArchiveQueue using DBMS_AQ for a separate archival process to handle.

BEGIN
    DBMS_AQADM.CREATE_QUEUE_TABLE('PLSQLFUSION.onboardingArchiveQueue', 'RAW');
    -- DBMS_AQADM.CREATE_QUEUE('ONBOARDINGS', 'PLSQLFUSION.onboardingArchiveQueue');
    -- DBMS_AQADM.START_QUEUE('PLSQLFUSION.ONBOARDINGS');
END;
/

CREATE OR REPLACE DIRECTORY UTL_FILE_DIR AS '/media/oracle_test_data';
GRANT READ, WRITE ON DIRECTORY UTL_FILE_DIR TO PLSQLFUSION;

CREATE OR REPLACE PACKAGE PLSQLFUSION.EMPLOYEE_ONBOARDING_PKG AS
    PROCEDURE onboardEmployee(
        p_new_hire_json IN CLOB,
        l_employee_id OUT PLSQLFUSION.EMPLOYEES.EMPLOYEEID%TYPE,
        l_department_name OUT PLSQLFUSION.DEPARTMENTS.DEPARTMENTNAME%TYPE,
        v_manager_name OUT PLSQLFUSION.EMPLOYEES.FIRSTNAME%TYPE
    );
END EMPLOYEE_ONBOARDING_PKG;
/

CREATE OR REPLACE PACKAGE BODY PLSQLFUSION.EMPLOYEE_ONBOARDING_PKG AS

    FUNCTION processNewHire(
        p_employee_info   IN CLOB
    ) RETURN CLOB
    AS MLE MODULE PLSQLFUSION.EMPLOYEE_ONBOARDING_AUDITING_SYSTEM_MOD
    SIGNATURE 'processNewHire(string)';

    PROCEDURE archive_onboarding_details (
        p_employee_id     IN PLSQLFUSION.EMPLOYEES.EMPLOYEEID%TYPE,
        p_first_name      IN PLSQLFUSION.EMPLOYEES.FIRSTNAME%TYPE,
        p_last_name       IN PLSQLFUSION.EMPLOYEES.LASTNAME%TYPE,
        p_email           IN PLSQLFUSION.EMPLOYEES.EMAIL%TYPE,
        p_hire_date       IN PLSQLFUSION.EMPLOYEES.HIREDATE%TYPE,
        p_salary          IN PLSQLFUSION.EMPLOYEES.SALARY%TYPE,
        p_department_name IN PLSQLFUSION.DEPARTMENTS.DEPARTMENTNAME%TYPE,
        p_manager_name    IN PLSQLFUSION.EMPLOYEES.FIRSTNAME%TYPE,
        v_welcome_letter  OUT CLOB
    ) AS
        -- Message and Document Variables
        v_message         VARCHAR2(4000);
        v_xml_doc         XMLTYPE;
        -- Variables for DBMS_XMLDOM
        l_doc             DBMS_XMLDOM.DOMDocument;
        l_root_node       DBMS_XMLDOM.DOMNode;
        l_new_node        DBMS_XMLDOM.DOMNode;
        -- Variables for DBMS_XMLGEN
        vCtx              DBMS_XMLGEN.ctxHandle;
        -- Variables for Asynchronous Queueing
        enqueue_options     DBMS_AQ.ENQUEUE_OPTIONS_T;
        message_properties  DBMS_AQ.MESSAGE_PROPERTIES_T;
        message_handle      RAW(16);
        payload             BLOB;
        queue_name          VARCHAR2(40);
    BEGIN
        -- Construct the welcome message string
        v_message := 'WELCOME ' || p_first_name || ' ' || p_last_name || CHR(10) || CHR(10)
            || 'Your email is: ' || p_email || CHR(10)
            || 'Keep in mind your hiring date: ' || TO_CHAR(p_hire_date, 'FMMonth DD, YYYY') || CHR(10)
            || 'Your salary is: ' || TO_CHAR(p_salary, 'FM999G999D00') || CHR(10)
            || 'You will work in the ' || p_department_name || ' department, reporting to ' || p_manager_name || '.';

        -- Create and populate the temporary CLOB. The caller is responsible for freeing it.
        DBMS_LOB.CREATETEMPORARY(v_welcome_letter, TRUE);
        DBMS_LOB.WRITEAPPEND(v_welcome_letter, LENGTH(v_message), v_message);

        DBMS_OUTPUT.PUT_LINE('--- Original CLOB Content ---');
        DBMS_OUTPUT.PUT_LINE(v_welcome_letter);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');

        -- Convert the CLOB to an XML document line by line
        vCtx := DBMS_XMLGEN.NEWCONTEXT(
            'SELECT TRIM(REGEXP_SUBSTR(:clob_data, ''[^''||CHR(10)||'']+'', 1, LEVEL)) AS line
             FROM DUAL
             CONNECT BY LEVEL <= REGEXP_COUNT(:clob_data, CHR(10)) + 1'
        );
        DBMS_XMLGEN.SETBINDVALUE(vCtx, 'clob_data', v_welcome_letter);
        DBMS_XMLGEN.SETROWSETTAG(vCtx, 'WelcomeLetter');
        DBMS_XMLGEN.SETROWTAG(vCtx, 'Line');
        v_xml_doc := DBMS_XMLGEN.GETXMLTYPE(vCtx);
        DBMS_XMLGEN.closeContext(vCtx);

        -- Create a DOM from the welcome letter XML to append more data
        l_doc := DBMS_XMLDOM.newDOMDocument(v_xml_doc);

        -- Get the employee's management hierarchy as a separate XML document
        DECLARE
            v_hierarchy_xml XMLTYPE;
            v_hierarchy_ctx DBMS_XMLGEN.ctxHandle;
            l_hierarchy_doc DBMS_XMLDOM.DOMDocument;
        BEGIN
            v_hierarchy_ctx := DBMS_XMLGEN.newContext(
                'SELECT LEVEL, employeeid, managerid
                 FROM PLSQLFUSION.EMPLOYEES
                 START WITH employeeid = :emp_id
                 CONNECT BY PRIOR managerid = employeeid'
            );
            DBMS_XMLGEN.setBindValue(v_hierarchy_ctx, 'emp_id', p_employee_id);
            v_hierarchy_xml := DBMS_XMLGEN.getXMLType(v_hierarchy_ctx);
            DBMS_XMLGEN.closeContext(v_hierarchy_ctx);
            
            -- Append the hierarchy XML to the main document's root
            l_root_node := DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(l_doc));
            l_hierarchy_doc := DBMS_XMLDOM.NEWDOMDOCUMENT(v_hierarchy_xml);
            l_new_node  := DBMS_XMLDOM.IMPORTNODE(l_doc, DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(l_hierarchy_doc)), TRUE);
            l_new_node  := DBMS_XMLDOM.APPENDCHILD(l_root_node, l_new_node);
            DBMS_XMLDOM.FREEDOCUMENT(l_hierarchy_doc);

            -- Finalize and get the combined XML
            v_xml_doc := DBMS_XMLDOM.getXMLType(l_doc);
        END;

        DBMS_XMLDOM.FREEDOCUMENT(l_doc);
        
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Final Combined XML Document ---');
        DBMS_OUTPUT.PUT_LINE(v_xml_doc.getClobVal());
        
        -- Asynchronous Messaging: Enqueue the generated XML for the archival process.
        -- NOTE: Creating a queue every time is not ideal. This should be part of a setup script.
        queue_name := 'PLSQLFUSION.ONBOARDING_ID'||p_employee_id;
        -- Attempt to create the queue, but handle the "already exists" error gracefully
        BEGIN
            DBMS_AQADM.CREATE_QUEUE(queue_name, 'PLSQLFUSION.onboardingArchiveQueue');
        EXCEPTION
             WHEN OTHERS THEN -- Typically ORA-24006: cannot create QUEUE, QUEUE_TABLE already exists
                IF SQLCODE = -24006 THEN NULL; -- Ignore if queue already exists
                ELSE RAISE;
                END IF;
        END;
        DBMS_AQADM.START_QUEUE(queue_name);
        payload := v_xml_doc.getBlobVal(csid => NLS_CHARSET_ID('AL32UTF8'));
        DBMS_AQ.ENQUEUE(
            queue_name         => queue_name, 
            enqueue_options    => enqueue_options, 
            message_properties => message_properties, 
            payload            => payload, 
            msgid              => message_handle
        );
        -- The commit for the enqueue will be handled by the calling procedure.
        
        -- <<<<<<<<< CHANGE: REMOVED THE FREETEMPORARY CALL FROM HERE >>>>>>>>>
        -- DBMS_LOB.FREETEMPORARY(v_welcome_letter);

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred during archival: ' || SQLERRM);
            -- The caller is responsible for freeing the LOB, even on error.
            ROLLBACK;
            RAISE; -- Re-raise the exception to the caller
    END archive_onboarding_details;

    PROCEDURE onboardEmployee(
        p_new_hire_json IN CLOB,
        l_employee_id OUT PLSQLFUSION.EMPLOYEES.EMPLOYEEID%TYPE,
        l_department_name OUT PLSQLFUSION.DEPARTMENTS.DEPARTMENTNAME%TYPE,
        v_manager_name OUT PLSQLFUSION.EMPLOYEES.FIRSTNAME%TYPE
    ) AS
        l_response          CLOB;
        l_first_name        PLSQLFUSION.EMPLOYEES.FIRSTNAME%TYPE;
        l_last_name         PLSQLFUSION.EMPLOYEES.LASTNAME%TYPE;
        l_email             PLSQLFUSION.EMPLOYEES.EMAIL%TYPE;
        l_hire_date         PLSQLFUSION.EMPLOYEES.HIREDATE%TYPE;
        l_salary            PLSQLFUSION.EMPLOYEES.SALARY%TYPE;
        l_manager_id        PLSQLFUSION.DEPARTMENTS.MANAGERID%TYPE;
        l_department_id     PLSQLFUSION.DEPARTMENTS.DEPARTMENTID%TYPE;
        l_record_count      NUMBER;
        v_welcome_letter    CLOB;
        v_xml_document      XMLTYPE;
        vFile UTL_FILE.FILE_TYPE; 
        vLogLine VARCHAR2(100);
    BEGIN
        BEGIN
            l_manager_id := JSON_VALUE(p_new_hire_json, '$.managerId');
            l_department_id := JSON_VALUE(p_new_hire_json, '$.departmentId');
            IF l_manager_id IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'Manager ID is missing or invalid in the provided JSON.'); END IF;
            IF l_department_id IS NULL THEN RAISE_APPLICATION_ERROR(-20002, 'Department ID is missing or invalid in the provided JSON.'); END IF;
        EXCEPTION 
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error type for input existance: '||SQLERRM); RAISE;
        END;
        BEGIN
            SELECT d.MANAGERID, FIRSTNAME INTO l_manager_id, v_manager_name 
            FROM PLSQLFUSION.DEPARTMENTS d
            JOIN PLSQLFUSION.EMPLOYEES e 
            ON d.MANAGERID = e.EMPLOYEEID
            WHERE d.MANAGERID = l_manager_id AND d.DEPARTMENTID = l_department_id;
            IF SQL%NOTFOUND THEN RAISE NO_DATA_FOUND; END IF;
            SELECT DEPARTMENTID, DEPARTMENTNAME INTO l_department_id, l_department_name 
            FROM PLSQLFUSION.DEPARTMENTS WHERE DEPARTMENTID = l_department_id;
            IF SQL%NOTFOUND THEN RAISE NO_DATA_FOUND; END IF;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Error type for fetching existance: '||SQLERRM); RAISE;
        END;
        l_response := processNewHire(p_new_hire_json);
        DBMS_OUTPUT.PUT_LINE('--- Onboarding Response ---');
        DBMS_OUTPUT.PUT_LINE('Status: ' || JSON_VALUE(l_response, '$.status'));
        DBMS_OUTPUT.PUT_LINE('Bonus: ' || JSON_VALUE(l_response, '$.firstYearBonus'));
        IF JSON_EXISTS(l_response, '$.error') THEN DBMS_OUTPUT.PUT_LINE('Error: ' || JSON_VALUE(l_response, '$.error')); END IF;
        DBMS_OUTPUT.PUT_LINE('Full JSON: ' || l_response);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
        IF JSON_EXISTS(l_response, '$.firstYearBonus') THEN
            l_employee_id := JSON_VALUE(l_response, '$.employeeId' RETURNING NUMBER);
            l_first_name := JSON_VALUE(l_response, '$.firstName');
            l_last_name := JSON_VALUE(l_response, '$.lastName');
            l_email := JSON_VALUE(l_response, '$.email');
            l_hire_date := TO_DATE(JSON_VALUE(l_response, '$.hireDate'), 'YYYY-MM-DD"T"HH24:MI:SS');
            l_salary := JSON_VALUE(l_response, '$.salary' RETURNING NUMBER);
            INSERT INTO PLSQLFUSION.EMPLOYEES(EMPLOYEEID, FIRSTNAME, LASTNAME, EMAIL, HIREDATE, SALARY, MANAGERID, DEPARTMENTID)
            VALUES(
                l_employee_id,
                l_first_name,
                l_last_name,
                l_email,
                l_hire_date,
                l_salary,
                l_manager_id,
                l_department_id
            );
            
            archive_onboarding_details(
                p_employee_id     => l_employee_id,
                p_first_name      => l_first_name,
                p_last_name       => l_last_name,
                p_email           => l_email,
                p_hire_date       => l_hire_date,
                p_salary          => l_salary,
                p_department_name => l_department_name,
                p_manager_name    => v_manager_name,
                v_welcome_letter  => v_welcome_letter -- This is now populated and valid
            );

            -- Now it's safe to use v_welcome_letter
            DECLARE
                vFile UTL_FILE.FILE_TYPE;
                -- Increase size to accommodate the CLOB content + message
                vLogLine VARCHAR2(4000) := 'Employee Id: '||l_first_name||' '||l_last_name||' Message: ';
            BEGIN
                -- This will now work correctly
                vLogLine := vLogLine || v_welcome_letter;
                vFile := UTL_FILE.FOPEN('UTL_FILE_DIR', 'onboarding.log', 'w');
                UTL_FILE.PUT_LINE(vFile, vLogLine || ' Logged at: ' || SYSTIMESTAMP);
                UTL_FILE.FCLOSE(vFile);

                -- <<<<<<<<< CHANGE: FREE THE LOB NOW THAT WE ARE DONE WITH IT >>>>>>>>>
                DBMS_LOB.FREETEMPORARY(v_welcome_letter);

            EXCEPTION
                WHEN UTL_FILE.INVALID_OPERATION THEN
                    DBMS_OUTPUT.PUT_LINE('File could not be opened for writing.');
                    IF UTL_FILE.IS_OPEN(vFile) THEN UTL_FILE.FCLOSE(vFile); END IF;
                    -- <<<<<<<<< CHANGE: FREE THE LOB IN EXCEPTION BLOCK TOO >>>>>>>>>
                    IF DBMS_LOB.ISTEMPORARY(v_welcome_letter) = 1 THEN DBMS_LOB.FREETEMPORARY(v_welcome_letter); END IF;
                    RAISE; -- Re-raise to the outer block
                WHEN OTHERS THEN
                    -- <<<<<<<<< CHANGE: FREE THE LOB IN EXCEPTION BLOCK TOO >>>>>>>>>
                    IF DBMS_LOB.ISTEMPORARY(v_welcome_letter) = 1 THEN DBMS_LOB.FREETEMPORARY(v_welcome_letter); END IF;
                    RAISE; -- Re-raise to the outer block
            END;
            
            -- Single commit at the end of the entire successful transaction
            COMMIT;

        END IF;
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error type: '||SQLERRM); 
            -- <<<<<<<<< CHANGE: ADDED LOB CLEANUP TO THE MAIN EXCEPTION HANDLER >>>>>>>>>
            IF DBMS_LOB.ISTEMPORARY(v_welcome_letter) = 1 THEN 
                DBMS_LOB.FREETEMPORARY(v_welcome_letter); 
            END IF;
            ROLLBACK; 
            RAISE;
    END onboardEmployee;

END EMPLOYEE_ONBOARDING_PKG;
/

SET SERVEROUTPUT ON;
DECLARE
    -- Input data for the new hire
    v_employee_id   SMALLINT := 6;
    v_first_name    VARCHAR2(10) := 'depicted';
    v_last_name     VARCHAR2(10) := 'candela';
    v_email         VARCHAR2(50) := 'd.c@example.com';
    v_hire_date     DATE := DATE '2025-06-13';
    v_salary        NUMBER := 15000;
    v_department_id SMALLINT := 10;
    v_manager_id    SMALLINT := 1;
    -- Variables to receive the OUT parameters from the procedure
    v_new_employee_id PLSQLFUSION.EMPLOYEES.EMPLOYEEID%TYPE;
    v_department_name PLSQLFUSION.DEPARTMENTS.DEPARTMENTNAME%TYPE;
    v_manager_name    PLSQLFUSION.EMPLOYEES.FIRSTNAME%TYPE;
    v_welcome_letter  CLOB;
BEGIN
    PLSQLFUSION.EMPLOYEE_ONBOARDING_PKG.ONBOARDEMPLOYEE(
        p_new_hire_json => TO_CLOB(
            JSON_OBJECT(
                'employeeId'   VALUE v_employee_id,
                'firstName'    VALUE v_first_name, 
                'lastName'     VALUE v_last_name, 
                'email'        VALUE v_email, 
                'hireDate'     VALUE v_hire_date,
                'salary'       VALUE v_salary,
                'departmentId' VALUE v_department_id,
                'managerId'    VALUE v_manager_id
            )
        ),
        l_employee_id => v_new_employee_id,
        l_department_name => v_department_name,
        v_manager_name => v_manager_name
    );
    -- The procedure now handles all output, but we can confirm the OUT parameters here.
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Test block execution completed.');
    DBMS_OUTPUT.PUT_LINE('New Employee ID: ' || v_new_employee_id);
    DBMS_OUTPUT.PUT_LINE('Returned Department: ' || v_department_name);
    DBMS_OUTPUT.PUT_LINE('Returned Manager: ' || v_manager_name);
    DBMS_OUTPUT.PUT_LINE('------------------------------------');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        -- Free any resources that might be open
        IF DBMS_LOB.ISTEMPORARY(v_welcome_letter) = 1 THEN DBMS_LOB.FREETEMPORARY(v_welcome_letter); END IF;
        RAISE;
END;
/

CREATE OR REPLACE MLE MODULE PLSQLFUSION.EMPLOYEE_ONBOARDING_AUDITING_SYSTEM_MOD LANGUAGE JAVASCRIPT AS

    function isValidOracleDate(dateStr) {
        // Regex for YYYY-MM-DD or YYYY-MM-DDTHH:MI:SS
        const isoRegex = /^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2})?$/;
        if (!isoRegex.test(dateStr)) return false;
        
        const date = new Date(dateStr);
        // Check if the date object is valid
        return !isNaN(date.getTime());
    }

    function processNewHire(employeeInfo) {
        let obj;
        try {
            obj = JSON.parse(employeeInfo);
        } catch (e) {
            return JSON.stringify({ status: "Failed", error: "Invalid JSON format." });
        }

        // Corrected: Use JS comments (//) instead of SQL comments (--)
        // Field Presence Validation
        const requiredFields = ["employeeId", "firstName", "lastName", "email", "hireDate", "salary", "managerId", "departmentId"];
        for (const field of requiredFields) {
            if (!(field in obj)) {
                obj.status = "Failed";
                obj.error = `Validation failed: Missing required field '${field}'.`;
                return JSON.stringify(obj);
            }
        }
        // Data Format and Value Validation
        const emailRegex = /^[a-z]+\.[a-z]+@example\.com$/;
        if (!emailRegex.test(obj.email)) {
            obj.status = "Failed";
            obj.error = `Validation failed: Invalid email format for '${obj.email}'.`;
            return JSON.stringify(obj);
        }
        if (!isValidOracleDate(obj.hireDate)) {
            obj.status = "Failed";
            obj.error = `Validation failed: Invalid hireDate format for '${obj.hireDate}'. Use 'YYYY-MM-DD'.`;
            return JSON.stringify(obj);
        }
        // Business Logic
        obj.firstYearBonus = obj.salary * 0.1;
        obj.status = "Validation Successful";
        return JSON.stringify(obj);
    }

export { processNewHire }
/