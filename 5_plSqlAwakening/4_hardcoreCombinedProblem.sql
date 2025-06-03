        -- Awakening PL/SQL

--  (iv) Hardcore Combined Problem

--      Problem Statement: You are tasked with generating a summary report and performing some data updates for employees. Create a single PL/SQL anonymous block to achieve the following:

-- Declarations:
    -- Declare a constant bonusThresholdDate of type DATE, initialized to '01-JAN-2021'.
    -- Declare a variable vProcessedCount of type PLS_INTEGER, initialized to 0.
    -- Declare a record empBonusInfo with fields: empId NUMBER, fullName VARCHAR2(100), yearsOfService NUMBER, potentialBonus NUMBER(10,2), 
    -- departmentLocation VARCHAR2(100).
    -- Declare an XMLTYPE variable employeeReportXML.
    -- Declare a BOOLEAN variable isHighPerformer initialized to FALSE (Oracle 23ai BOOLEAN type).
-- Processing Logic (within a loop for employees in department 'IT' or 'SALES'):
    -- For each employee in the 'IT' or 'SALES' departments hired before bonusThresholdDate:
        -- Increment vProcessedCount.
        -- Concatenate firstName and lastName into empBonusInfo.fullName.
        -- Calculate empBonusInfo.yearsOfService as the integer part of years between their hireDate and SYSDATE. (Hint: MONTHS_BETWEEN / 12, TRUNC).
        -- Determine empBonusInfo.potentialBonus based on jobTitle using a CASE expression:
            -- 'IT Manager': salary * 0.15
            -- 'Sales Manager': salary * 0.20
            -- 'Developer': salary * 0.10
            -- 'Sales Representative': salary * 0.12
            -- Others in IT/Sales: salary * 0.05
        -- Using SELECT INTO, fetch the location of their department into empBonusInfo.departmentLocation.
        -- Conditional Update & Output:
            -- If yearsOfService is greater than 3 AND potentialBonus is greater than 10000:
                -- Set isHighPerformer to TRUE.
                -- Update the employee's commissionPct by adding 0.01 to their current commission (use NVL to handle NULL commission, treating NULL as 0 for addition). 
                --  Cap the new commission at 0.25.
                -- Log a message to salesLog like: 'High performer bonus review for [fullName], New Commission: [new_commission_value]'.
                -- Print (DBMS_OUTPUT) empBonusInfo.fullName, empBonusInfo.yearsOfService, empBonusInfo.potentialBonus, empBonusInfo.departmentLocation, and "High 
                --  Performer".
            -- Else:
                -- Set isHighPerformer to FALSE.
                -- Log a message to salesLog like: 'Standard review for [fullName]'.
                -- Print (DBMS_OUTPUT) empBonusInfo.fullName, empBonusInfo.yearsOfService, empBonusInfo.potentialBonus, empBonusInfo.departmentLocation, and "Standard 
                --  Performer".
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    bonusThresholdDate DATE := TO_DATE('01-JAN-2021', 'DD-month-YYYY');
    vProcessedCount PLS_INTEGER := 0;
    isHighPerformer BOOLEAN := FALSE;
    TYPE empBonusInfoType IS RECORD (
        empId NUMBER,
        fullName VARCHAR2(100), 
        yearsOfService NUMBER, 
        potentialBonus NUMBER(10,2), 
        departmentLocation VARCHAR2(100)
    );
    empBonusInfo empBonusInfoType;
    employeeReportXML XMLTYPE;
    commission PLSQLAWAKENING.EMPLOYEES.COMMISSIONPCT%TYPE;
BEGIN
    SAVEPOINT pre;
    FOR rec IN (
        SELECT *
        FROM PLSQLAWAKENING.EMPLOYEES
        NATURAL JOIN PLSQLAWAKENING.DEPARTMENTS
        WHERE DEPARTMENTNAME IN ('IT', 'SALES')
    ) LOOP
        empBonusInfo.fullName := rec.firstName || ' ' || rec.lastName;
        empBonusInfo.yearsOfService := TRUNC(MONTHS_BETWEEN(bonusThresholdDate, rec.hireDate) / 12);
        empBonusInfo.potentialBonus := CASE 
            WHEN rec.JOBTITLE = 'IT Manager' THEN rec.SALARY * 0.15
            WHEN rec.JOBTITLE = 'Sales Manager' THEN rec.SALARY * 0.2
            WHEN rec.JOBTITLE = 'Developer' THEN rec.SALARY * 0.1
            WHEN rec.JOBTITLE = 'Sales Representative' THEN rec.SALARY * 0.12
            WHEN INSTR(rec.JOBTITLE, 'IT') > 0 OR INSTR(rec.JOBTITLE, 'SALES') > 0 THEN rec.SALARY * 0.05
            ELSE 0
        END;
        BEGIN 
            SELECT d.LOCATIONCITY
            INTO empBonusInfo.departmentLocation
            FROM PLSQLAWAKENING.DEPARTMENTS d WHERE d.DEPARTMENTID = rec.DEPARTMENTID;
        EXCEPTION
            WHEN CASE_NOT_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not department for ' || rec.firstName || ' ' || rec.lastName);
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not department for ' || rec.firstName || ' ' || rec.lastName);
            WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error searching department for ' || rec.firstName || ' ' || rec.lastName || ' as ' || SQLERRM);
        END;
        IF empBonusInfo.yearsOfService > 3 AND empBonusInfo.potentialBonus > 10000 
            THEN 
                isHighPerformer := TRUE;
                commission := NVL(rec.commissionPct, 0) + 0.01;
                commission := CASE WHEN commission > 0.25 THEN 0.25 ELSE commission END;
                UPDATE PLSQLAWAKENING.employees SET commissionPct = commission WHERE employeeId = rec.employeeId;
                DBMS_OUTPUT.PUT_LINE('High performer bonus review for [' || empBonusInfo.fullName || '], New Commission: [' || commission || ']');
                DBMS_OUTPUT.PUT_LINE(
                    empBonusInfo.fullName||', '||
                    empBonusInfo.yearsOfService||', '||
                    empBonusInfo.potentialBonus||', '||
                    empBonusInfo.departmentLocation||', '||
                    'High Performer'
                );
        ELSE
            isHighPerformer := FALSE;
            DBMS_OUTPUT.PUT_LINE('Standard review for [' || empBonusInfo.fullName || ']');
            DBMS_OUTPUT.PUT_LINE(
                empBonusInfo.fullName||', '||
                empBonusInfo.yearsOfService||', '||
                empBonusInfo.potentialBonus||', '||
                empBonusInfo.departmentLocation||', '||
                'Standard Performer'
            );
        END IF;
        vProcessedCount := vProcessedCount + 1;
        SELECT XMLELEMENT("EmployeeBonusReport", XMLELEMENT("ProcesssedCount", vProcessedCount))
        INTO employeeReportXML
        FROM DUAL;
        DBMS_OUTPUT.PUT_LINE('XML REPORT: ' || employeeReportXML.getClobVal());
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Committed changes');
EXCEPTION WHEN OTHERS THEN 
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Rolled back because of the error: ' || SQLERRM);
END;
/

-- XML Generation (after the loop):
-- Construct a simple XML document in employeeReportXML containing a root element <EmployeeBonusReport> with child elements <ProcessedCount> holding the value of 
-- vProcessedCount. (Hint: XMLElement, XMLForest).
-- Print this generated XML using DBMS_OUTPUT.PUT_LINE(employeeReportXML.getClobVal());.

-- Exception Handling:
-- Include a NO_DATA_FOUND handler in case an employee's department location cannot be found (though unlikely with FK).
-- Include a WHEN OTHERS handler to catch any other unexpected errors, printing the error code and message.

-- Transaction Control:
-- After the loop and XML generation, if no errors occurred, COMMIT the changes. Otherwise, ROLLBACK.