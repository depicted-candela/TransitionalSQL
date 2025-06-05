        -- Category: Triggers: DML triggers, :NEW and :OLD qualifiers, conditional predicates


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 1.7: Basic AFTER INSERT Trigger
-- Problem: Create an AFTER INSERT ON Orders FOR EACH ROW trigger named trgLogNewOrder. This trigger should insert a record into the AuditLog table with tableName = 
-- 'Orders', operationType = 'INSERT', and recordId = :NEW.orderId.
-- Test by inserting a new order into the Orders table.
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgLogNewOrder
AFTER INSERT ON PLSQLRESILIENCE.Orders
FOR EACH ROW
DECLARE
    tName VARCHAR(30) := 'Orders'; oType VARCHAR(20) := 'INSERT'; rId NUMBER;
    DataException EXCEPTION;
    PRAGMA EXCEPTION_INIT(DataException, -1);
BEGIN
    IF :NEW.ORDERID = NULL THEN RAISE_APPLICATION_ERROR(-1, 'Audit log is not possible for a NULL orderId'); END IF;
    rId := :NEW.ORDERID;
    INSERT INTO PLSQLRESILIENCE.AUDITLOG(TABLENAME, OPERATIONTYPE, RECORDID)
    VALUES (tName, oType, rId);
    DBMS_OUTPUT.PUT_LINE('New Order added and recorded in Audit Log with recordid as '||rId);
END trgLogNewOrder;
/
INSERT INTO PLSQLRESILIENCE.ORDERS(ORDERID, CUSTOMERID, STATUS) VALUES (3, 10, 'Delivered');
COMMIT;
-- Focus: Basic DML trigger syntax, AFTER INSERT timing, FOR EACH ROW, and usage of :NEW qualifier. Refer to PL/SQL Language Reference, Chapter 10, "DML Triggers" 
-- (p. 10-4) and "Correlation Names and Pseudorecords" (p. 10-28).

--      Exercise 1.8: BEFORE UPDATE Trigger with :OLD and :NEW
-- Problem: Create a BEFORE UPDATE OF salary ON Employees FOR EACH ROW trigger named trgPreventSalaryDecrease. This trigger should prevent any update that attempts to 
-- decrease an employee's salary. If a decrease is attempted, it should use RAISE_APPLICATION_ERROR with a custom error number (-20003) and a message "Salary decrease 
-- not allowed."
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgPreventSalaryDecrease
BEFORE UPDATE OF SALARY ON PLSQLRESILIENCE.EMPLOYEES
FOR EACH ROW
DECLARE 
    DecreasedSalaryException EXCEPTION;
    PRAGMA EXCEPTION_INIT(DecreasedSalaryException, -3);
BEGIN
    IF :OLD.SALARY > :NEW.SALARY THEN 
        RAISE_APPLICATION_ERROR(-20003, 'Salary decrease not allowed.'); 
    END IF;
END trgPreventSalaryDecrease;
/

UPDATE PLSQLRESILIENCE.EMPLOYEES SET SALARY = 58000 WHERE EMPLOYEEID = 101;
COMMIT;
-- Test by attempting to decrease an employee's salary and then by increasing it.
-- Focus: BEFORE UPDATE timing, accessing :OLD.salary and :NEW.salary, and raising an application error to prevent DML. Refer to Get Started with Oracle Database 
-- Development, Chapter 6, "About OLD and NEW Pseudorecords" (p. 6-3).

--      Exercise 1.9: Trigger with Conditional Predicates
-- Problem: Create an AFTER UPDATE ON Products FOR EACH ROW trigger named trgLogSignificantPriceChange. This trigger should log to AuditLog only if the unitPrice 
-- changes by more than 20% (either increase or decrease). The operationType should be 'PRICE_ADJUST'. Use the UPDATING('unitPrice') conditional predicate in 
-- conjunction with your percentage check in the trigger body.
-- Test with various price updates.
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgLogSignificantPriceChange
AFTER UPDATE OF UNITPRICE ON PLSQLRESILIENCE.PRODUCTS
FOR EACH ROW
WHEN (OLD.UNITPRICE * 1.2 <= NEW.UNITPRICE OR OLD.UNITPRICE * 0.8 >= NEW.UNITPRICE)
BEGIN
    CASE
        WHEN UPDATING('UNITPRICE')
            THEN INSERT INTO PLSQLRESILIENCE.AUDITLOG(TABLENAME, OPERATIONTYPE, RECORDID) VALUES ('PRODUCTS', 'PRICEADJST', :NEW.PRODUCTID);
            IF :OLD.UNITPRICE * 1.2 <= :NEW.UNITPRICE THEN
                DBMS_OUTPUT.PUT_LINE('Audit log added for unit price %20 higher than the previous one: '||:OLD.UNITPRICE||' to '||:NEW.UNITPRICE);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Audit log added for unit price %20 lower than the previous one: '||:OLD.UNITPRICE||' to '||:NEW.UNITPRICE);
            END IF;
    END CASE;
END;
/

SAVEPOINT previousToPrice;
DECLARE 
    vProductId PLSQLRESILIENCE.PRODUCTS.PRODUCTID%TYPE := 1000;
    vUnitPrice PLSQLRESILIENCE.PRODUCTS.UNITPRICE%TYPE;
    CURSOR specificProduct IS (SELECT PRODUCTID, UNITPRICE FROM PLSQLRESILIENCE.PRODUCTS WHERE PRODUCTID = 1000);
BEGIN
    SELECT UNITPRICE INTO vUnitPrice FROM PLSQLRESILIENCE.PRODUCTS WHERE PRODUCTID = vProductId;
    UPDATE PLSQLRESILIENCE.PRODUCTS SET UNITPRICE = vUnitPrice * 1.2 WHERE PRODUCTID = vProductId;
    UPDATE PLSQLRESILIENCE.PRODUCTS SET UNITPRICE = vUnitPrice * 0.8 WHERE PRODUCTID = vProductId;
END;
/
ROLLBACK;

-- Focus: Using conditional predicates like UPDATING('columnName') combined with PL/SQL logic to control trigger firing conditions. Refer to PL/SQL Language Reference,
-- Chapter 10, "Conditional Predicates for Detecting Triggering DML Statement" (p. 10-5).


--  (ii) Disadvantages and Pitfalls

--      Exercise 2.5: Mutating Table Error (ORA-04091)
-- Problem: Attempt to create a trigger on the Employees table that, for each row being updated, queries the *same* Employees table to find the average salary of the 
-- employee's department and then tries to ensure the employee's new salary is not more than 1.5 times this average. For example:
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgCheckMaxSalary
BEFORE UPDATE OF salary ON PLSQLRESILIENCE.Employees
FOR EACH ROW
DECLARE vAvgDeptSalary NUMBER;
BEGIN
    SELECT AVG(salary) INTO vAvgDeptSalary 
    FROM PLSQLRESILIENCE.Employees 
    WHERE departmentId = :NEW.departmentId;
    IF :NEW.salary > (vAvgDeptSalary * 1.5) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Salary exceeds 1.5x department average.');
    END IF;
END;
/
-- SELECT DEPARTMENTID, AVG(SALARY) departmentalSalary FROM PLSQLRESILIENCE.EMPLOYEES GROUP BY DEPARTMENTID;
SAVEPOINT prev;
UPDATE PLSQLRESILIENCE.EMPLOYEES SET SALARY = 75000 WHERE EMPLOYEEID = 101;
ROLLBACK;
-- Execute an update statement that would fire this trigger. 
-- What error do you get and why? 
-- Answer: the error is 
    -- Error starting at line : 1 in command -
    -- UPDATE PLSQLRESILIENCE.EMPLOYEES SET SALARY = 75000 WHERE EMPLOYEEID = 101
    -- Error at Command Line : 1 Column : 24
    -- Error report -
    -- SQL Error: ORA-04091: table PLSQLRESILIENCE.EMPLOYEES is mutating, trigger/function may not see it
    -- ORA-06512: at "PLSQLRESILIENCE.TRGCHECKMAXSALARY", line 4
    -- ORA-04088: error during execution of trigger 'PLSQLRESILIENCE.TRGCHECKMAXSALARY'
-- This happens because a trigger can't query or modify the table where lies the trigger because the timepoint breaks the table in multiple times and then the query
-- or operation within the trigger does not know where to apply its behaviors
-- How can compound triggers (introduced conceptually in PL/SQL Language Reference, Chapter 10, "Compound DML Triggers", p.10-10) help solve this? 
-- (Detailed compound trigger implementation is beyond this chunk but understanding the problem is key).
-- Answer: they create intermediate or temporary tables or views with a specific timepoint where is possible to be clear over which version of the table the
-- query or operations will be done
-- Focus: Understanding the mutating table error (ORA-04091) which is a common pitfall when triggers query or modify the table they are defined on. Refer to PL/SQL 
-- Language Reference, Chapter 10, "Mutating-Table Restriction" (p. 10-42).

--      Exercise 2.6: Trigger Firing Order and Cascading Effects
-- Problem:
-- 1. Create a simple AFTER UPDATE ON Departments FOR EACH ROW trigger (`trgDeptUpdate) that prints "Department updated" to DBMS_OUTPUT.
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgDeptUpdate
AFTER UPDATE ON PLSQLRESILIENCE.Departments
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Department updated');
END;
/
-- 2. Create an AFTER UPDATE OF departmentId ON Employees FOR EACH ROW trigger (`trgEmpDeptFkUpdate) that prints "Employee's departmentId updated".
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgEmpDeptFkUpdate
AFTER UPDATE OF DEPARTMENTID ON PLSQLRESILIENCE.EMPLOYEES
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee`s departmentId updated');
END;
/
-- Now, write an UPDATE statement that changes a departmentId in the Departments table. Assume there's a foreign key with ON UPDATE CASCADE from Employees.departmentId 
-- to Departments.departmentId (though you don't need to create the FK with cascade for this exercise, just understand the hypothetical).
SAVEPOINT prev;
BEGIN
    UPDATE PLSQLRESILIENCE.DEPARTMENTS SET DEPARTMENTID = 3 WHERE DEPARTMENTID = 3;
    -- IF SQL%FOUND THEN UPDATE PLSQLRESILIENCE.EMPLOYEES SET DEPARTMENTID = 1 WHERE DEPARTMENTID = 1 AND ROWNUM = 1; END IF;
END;
/
ROLLBACK;
COMMIT;

-- Discuss the potential firing order and the "cascading" effect if the FK was set to cascade updates. What are the implications if one trigger's action inadvertently 
-- causes another trigger to fire multiple times?
-- Answer: A CASCADE means that updating a linked variable with cascade like DEPARTMENTS.DEPARMENTID into EMPLOYEES.DEPARTMENTID will change also the data in 
-- EMPLOYEES for such FK, thus trgEmpDeptFkUpdate fired
-- Focus: Understanding that triggers can cause other triggers to fire, and the order can sometimes be non-obvious or lead to performance issues if not designed 
-- carefully. Refer to PL/SQL Language Reference, Chapter 10, "Order in Which Triggers Fire" (p. 10-46).


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 3.3: Auditing via Application Code vs. Triggers
-- Scenario: Every time a product's stockQuantity is changed, an audit record needs to be created in AuditLog.
-- Inefficient Common Solution (Problem): The application developers are instructed to manually insert a record into AuditLog every time their Java or other 
-- application code updates the Products.stockQuantity. Describe the DML statement the application would execute and the subsequent INSERT into AuditLog.
-- Answer: the Java app must send two messages up to the database to do so and the database needs two operations to receive such messages
-- Oracle-Idiomatic Solution (Solution): Implement an AFTER UPDATE OF stockQuantity ON Products FOR EACH ROW trigger (similar to trgUpdateProductStockAudit from the 
-- hardcore problem) to automatically log these changes.
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgUpdateStockLog
AFTER UPDATE OF STOCKQUANTITY ON PLSQLRESILIENCE.PRODUCTS
FOR EACH ROW
BEGIN
    INSERT INTO PLSQLRESILIENCE.AUDITLOG(TABLENAME, OPERATIONTYPE, OLDVALUE, NEWVALUE, RECORDID)
    VALUES ('PRODUCTS', 'STCK CHNGD', :OLD.STOCKQUANTITY, :NEW.STOCKQUANTITY, :NEW.PRODUCTID);
    DBMS_OUTPUT.PUT_LINE('LOGGED STOCK QUANTITY UPDATED FOR PRODUCT '||:NEW.PRODUCTID);
END trgUpdateStockLog;
/

UPDATE PLSQLRESILIENCE.PRODUCTS SET STOCKQUANTITY = 151 WHERE PRODUCTID = 1000;
COMMIT;
-- Task: Discuss why the trigger-based approach is superior for this auditing requirement in terms of data integrity, consistency, and reduced application code 
-- complexity/redundancy.
-- Focus: Highlighting the reliability and data-centricity of triggers for auditing over manual application-level logging, which can be inconsistent or bypassed.