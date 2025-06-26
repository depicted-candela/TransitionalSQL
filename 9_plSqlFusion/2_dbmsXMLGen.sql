        -- 2. DBMS_XMLGEN: Legacy XML Generation


-- Important: The DBMS_XMLGEN package is deprecated in Oracle Database 23ai. These exercises are for understanding legacy code. For new development, always use modern 
-- SQL/XML functions.

--      Exercise 2.1: Basic XML Generation
-- Problem: Use the deprecated DBMS_XMLGEN package to generate an XML document from the departments table for the 'Technology' department (ID 20).
DECLARE
    vXMLResult CLOB;
BEGIN
    vXMLResult := DBMS_XMLGEN.GETXML('SELECT * FROM PLSQLFUSION.DEPARTMENTS WHERE DEPARTMENTID = 20');
    DBMS_OUTPUT.PUT_LINE(vXMLResult);
END;
/
DECLARE
    vCtx DBMS_XMLGEN.ctxHandle;
    vXMLResult CLOB;
BEGIN
    vCtx := DBMS_XMLGEN.NEWCONTEXT('SELECT * FROM PLSQLFUSION.DEPARTMENTS');
    DBMS_XMLGEN.SETROWSETTAG(vCtx, 'DEPARTMENTS');
    DBMS_XMLGEN.SETROWTAG(vCtx, 'DEPARTMENT');
    vXMLResult := DBMS_XMLGEN.GETXML(vCtx);
    DBMS_OUTPUT.PUT_LINE('Departments XML: '||vXMLResult);
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Reference: PL/SQL Packages and Types Reference for DBMS_XMLGEN.

--      Exercise 2.2: The Pitfall of Forgetting to Close the Context
-- Problem: Explain the primary pitfall of using DBMS_XMLGEN. (This is a conceptual question, provide a textual explanation).
-- Answer: The primary pitfall is that legacy code will be unsupported in releases for the short term of ORACLE SQL db 23 ai, for enterprises paying for such services
-- is a waste of money the usage of not highly improbed features to be competitive in the market. You can conserve the legacy code as you can conserve the lagged
-- effect of not using the features your competitors use. Specifically SQL/XML functions (the updated alternatives) enables multiple combined solutions from aggregated
-- solutions or fine grained structures that SQL/XML facilitates

--      Exercise 2.3: Modern vs. Legacy XML Generation
-- Problem: Convert the task from Exercise 2.1 (generating XML for department 20) to use the modern, efficient, and standard SQL/XML functions.
DECLARE
    vXMLResult XMLTYPE;
BEGIN
    SELECT XMLELEMENT(
        "ROWSET", 
        XMLELEMENT("ROW", 
            XMLFOREST(
                departmentId AS "DEPARTMENTID", 
                departmentName AS "DEPARTMENTNAME", 
                managerId AS "MANAGERID"
            )
        )
    ) INTO vXMLResult
    FROM PLSQLFUSION.DEPARTMENTS 
    WHERE DEPARTMENTID = 20;
    DBMS_OUTPUT.PUT_LINE('Result is ');
    DBMS_OUTPUT.PUT_LINE(vXMLResult.getClobVal);
END;
/