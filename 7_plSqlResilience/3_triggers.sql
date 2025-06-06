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


--      (iv) Hardcore Combined Problem

-- Problem: Comprehensive Order Processing and Auditing
-- You are tasked with creating a robust order processing system. This involves a package to handle new orders, ensure product availability, update stock, and log 
-- activities. Additionally, a trigger will independently audit product stock changes.

-- Part 1: Order Management Package (`OrderProcessingPkg`)
-- Create a package named OrderProcessingPkg.
--     Package Specification:
--         Declare a public record type OrderItemRec with fields productId NUMBER and quantity NUMBER.
--         Declare a public collection type OrderItemList as a TABLE OF OrderItemRec INDEX BY PLS_INTEGER.
--         Declare two public user-defined exceptions: e_insufficient_stock EXCEPTION; and e_product_not_found EXCEPTION;. Use PRAGMA EXCEPTION_INIT to associate 
--         e_insufficient_stock with -20010 and e_product_not_found with -20011.
--         Declare a public procedure CreateNewOrder with the following parameters:
--             p_customer_id IN Orders.customerId%TYPE
--             p_items IN OrderItemList (the collection of order items)
--             p_order_id OUT Orders.orderId%TYPE (to return the ID of the newly created order)
--     Package Body:
--         Implement a private procedure LogOrderAttempt:
--         Parameters: p_customer_id IN NUMBER, p_status IN VARCHAR2, p_error_message IN VARCHAR2 DEFAULT NULL, p_product_id_issue IN NUMBER DEFAULT NULL
--             This procedure will insert a record into AuditLog.
--             tableName = 'Orders'
--             operationType: 'ORDER_ATTEMPT_SUCCESS' if p_status is 'SUCCESS', 'ORDER_ATTEMPT_FAIL_STOCK' if error due to stock, 'ORDER_ATTEMPT_FAIL_PRODUCT' if 
--             product not found, 'ORDER_ATTEMPT_FAIL_OTHER' otherwise.
--             recordId: NULL (as order might not be created yet).
--             details: A composite message including customer ID, product ID if relevant, and p_error_message.
--     Implement the public procedure CreateNewOrder:
--         Start a new transaction (conceptually - PL/SQL procedures run within the caller's transaction unless autonomous).
--         Declare local variables for current product price, available stock.
--         Loop through each item in p_items:
--             Attempt to select unitPrice and stockQuantity from Products for item.productId.
--                 If product not found (NO_DATA_FOUND), call LogOrderAttempt with appropriate status, then RAISE e_product_not_found;
--             If item.quantity > available stock, call LogOrderAttempt, then RAISE e_insufficient_stock;
--         If all items are validated (no exceptions raised so far):
--             Generate a new orderId using orderSeq.NEXTVAL and assign to p_order_id.
--             Insert a new row into the Orders table (customerId from parameter, orderDate = SYSDATE, status = 'Pending').
--             Loop through p_items again:
--                 Fetch current unitPrice for item.productId.
--                 Insert a row into OrderItems (using orderItemSeq.NEXTVAL, the new orderId, item.productId, item.quantity, and the fetched unitPrice).
--                 Update Products table: decrement stockQuantity by item.quantity for item.productId.
--             Call LogOrderAttempt with status 'SUCCESS' and the new p_order_id.
--             COMMIT the transaction.
--         Exception Handling Section for CreateNewOrder:
--             WHEN e_insufficient_stock THEN
--                 ROLLBACK;
--                 RAISE_APPLICATION_ERROR(-20010, 'Order failed: Insufficient stock for one or more products.');
--             WHEN e_product_not_found THEN
--                 ROLLBACK;
--                 RAISE_APPLICATION_ERROR(-20011, 'Order failed: Product not found.');
--             WHEN OTHERS THEN
--                 Call LogOrderAttempt with error status, SQLCODE || ': ' || SQLERRM as the message.
--                 ROLLBACK;
--                 RAISE; -- Re-raise the original exception.

ALTER TABLE PLSQLRESILIENCE.AUDITLOG MODIFY OPERATIONTYPE VARCHAR2(50 BYTE);
ALTER TABLE PLSQLRESILIENCE.AUDITLOG ADD DETAILS VARCHAR2(200 BYTE);

CREATE OR REPLACE PACKAGE PLSQLRESILIENCE.OrderProcessingPkg AS
    TYPE OrderItemRect IS RECORD (productId PLSQLRESILIENCE.PRODUCTS.PRODUCTID%TYPE, quantity PLSQLRESILIENCE.PRODUCTS.STOCKQUANTITY%TYPE);
    TYPE OrderItemList IS TABLE OF OrderItemRect INDEX BY PLS_INTEGER;
    e_insufficient_stock EXCEPTION;
    e_product_not_found EXCEPTION;
    e_invalid_quantity EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_insufficient_stock, -10);
    PRAGMA EXCEPTION_INIT(e_product_not_found, -11);
    PRAGMA EXCEPTION_INIT(e_invalid_quantity, -12);
    PROCEDURE CreateNewOrder(
        p_customer_id IN PLSQLRESILIENCE.ORDERS.CUSTOMERID%TYPE, 
        p_items IN OrderItemList, 
        p_order_id OUT PLSQLRESILIENCE.ORDERS.OrderId%TYPE
    );
END OrderProcessingPkg;
/

CREATE OR REPLACE PACKAGE BODY PLSQLRESILIENCE.OrderProcessingPkg AS
    PROCEDURE LogOrderAttempt(
        p_customer_id IN NUMBER, 
        p_status IN VARCHAR2, 
        p_error_message IN VARCHAR2 DEFAULT NULL, 
        p_product_id_issue IN NUMBER DEFAULT NULL
    ) IS BEGIN
        INSERT INTO PLSQLRESILIENCE.AUDITLOG(TABLENAME, OPERATIONTYPE, DETAILS) VALUES (
            'Orders', 
            CASE 
                WHEN p_status = 'SUCCESS' THEN 'ORDER_ATTEMPT_SUCCESS' 
                WHEN p_error_message = 'error due to stock%' THEN 'ORDER_ATTEMPT_FAIL_STOCK'
                WHEN p_error_message LIKE 'product not found%' THEN 'ORDER_ATTEMPT_FAIL_PRODUCT'
                ELSE 'ORDER_ATTEMPT_FAIL_OTHER'
            END,
            p_customer_id||', '||p_status||', '||p_product_id_issue||', '||p_error_message
        );
    END;
    
    PROCEDURE CreateNewOrder(
        p_customer_id IN PLSQLRESILIENCE.ORDERS.CUSTOMERID%TYPE, 
        p_items IN OrderItemList, 
        p_order_id OUT PLSQLRESILIENCE.ORDERS.OrderId%TYPE
    ) 
    IS  currentIndex PLS_INTEGER;
        currentItem OrderItemRect;
        pUnitPrice PLSQLRESILIENCE.PRODUCTS.UNITPRICE%TYPE;
        pStockQuantity PLSQLRESILIENCE.PRODUCTS.STOCKQUANTITY%TYPE;
        pCustomerId PLSQLRESILIENCE.EMPLOYEES.EMPLOYEEID%TYPE := 100;
    BEGIN
        currentIndex := p_items.FIRST;
        SAVEPOINT starting;
        WHILE currentIndex IS NOT NULL LOOP
            currentItem := p_items(currentIndex);
            BEGIN
                SELECT UNITPRICE, STOCKQUANTITY INTO pUnitPrice, pStockQuantity 
                FROM PLSQLRESILIENCE.PRODUCTS WHERE PRODUCTID = currentItem.productId;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                    LogOrderAttempt(pCustomerId, 'ERROR', 'product not found (ID: '||TO_CHAR(currentItem.productId)||')');
                    RAISE e_product_not_found; 
            END;
            IF currentItem.quantity > pStockQuantity THEN 
                LogOrderAttempt(pCustomerId, 'ERROR', 'error due to stock (ID: '||TO_CHAR(currentItem.productId)||')');
                RAISE e_insufficient_stock;
            END IF;
            currentIndex := p_items.NEXT(currentIndex);
        END LOOP;
        p_order_id := PLSQLRESILIENCE.orderSeq.NEXTVAL;
        INSERT INTO PLSQLRESILIENCE.ORDERS(ORDERID, CUSTOMERID) VALUES (p_order_id, p_customer_id);
        currentIndex := p_items.FIRST;
        WHILE currentIndex IS NOT NULL LOOP
            currentItem := p_items(currentIndex);
            BEGIN
                SELECT STOCKQUANTITY, UNITPRICE INTO pStockQuantity, pUnitPrice
                FROM PLSQLRESILIENCE.PRODUCTS WHERE PRODUCTID = currentItem.productId;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN RAISE e_product_not_found;
            END;
            INSERT INTO PLSQLRESILIENCE.ORDERITEMS(ORDERITEMID, ORDERID, PRODUCTID, QUANTITY, ITEMPRICE)
            VALUES (PLSQLRESILIENCE.orderItemSeq.NEXTVAL, p_order_id, currentItem.productId, pStockQuantity, pUnitPrice);
            UPDATE PLSQLRESILIENCE.PRODUCTS SET STOCKQUANTITY = pStockQuantity - currentItem.quantity WHERE PRODUCTID = currentItem.productId;
            LogOrderAttempt(pCustomerId, 'SUCCESS', p_customer_id);
            COMMIT;
            currentIndex := p_items.NEXT(currentIndex);
        END LOOP;
    EXCEPTION 
        WHEN e_product_not_found THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20010, 'Order failed: Insufficient stock for one or more products.');
        WHEN e_insufficient_stock THEN
            ROLLBACK; 
            RAISE_APPLICATION_ERROR(-20011, 'Order failed: Product not found.');
        WHEN OTHERS THEN 
            LogOrderAttempt(pCustomerId, 'ERROR', SQLCODE || ': ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END;
END OrderProcessingPkg;
/
-- Part 2: Product Stock Audit Trigger (`trgAuditStockChange`)
--     Create a DML trigger named trgAuditStockChange.
--         It should fire AFTER UPDATE OF stockQuantity ON Products.
--         It must be a FOR EACH ROW trigger.
--         Trigger Body:
--             If UPDATING('stockQuantity') AND :NEW.stockQuantity <> :OLD.stockQuantity (to ensure actual change):
--                 Insert a record into AuditLog:
--                     tableName = 'Products'
--                     operationType = 'STOCK_UPDATE'
--                     recordId = :NEW.productId
--                     oldValue = TO_CLOB(:OLD.stockQuantity)
--                     newValue = TO_CLOB(:NEW.stockQuantity)
--                     details = 'Stock quantity changed for product ' || :NEW.productName
CREATE OR REPLACE TRIGGER PLSQLRESILIENCE.trgAuditStockChange
AFTER UPDATE OF STOCKQUANTITY ON PLSQLRESILIENCE.PRODUCTS
FOR EACH ROW
BEGIN
    IF UPDATING('STOCKQUANTITY') AND :NEW.STOCKQUANTITY <> :OLD.STOCKQUANTITY 
        THEN INSERT INTO PLSQLRESILIENCE.AUDITLOG(TABLENAME, OPERATIONTYPE, RECORDID, OLDVALUE, NEWVALUE, DETAILS)
        VALUES('Products', 'STOCK_UPDATE', :NEW.PRODUCTID, TO_CLOB(:OLD.STOCKQUANTITY), TO_CLOB(:NEW.STOCKQUANTITY), 'Stock quantity changed for product '||:NEW.productName);
    END IF;
END;
/

-- Part 3: Testing Anonymous Block
--     Write a PL/SQL anonymous block to test the functionality:
--     Enable SERVEROUTPUT.
--     Declare variables: v_items OrderProcessingPkg.OrderItemList;, v_new_order_id Orders.orderId%TYPE;.
--     Find product IDs for 'Laptop Pro' (stock 50), 'Wireless Mouse' (stock 200), 'Keyboard Ultra' (stock 10), and 'Monitor HD' (stock 0).
--     Test Case 1: Successful Order
--         Populate v_items: 1 Laptop Pro, 2 Wireless Mouse.
--         Call OrderProcessingPkg.CreateNewOrder(p_customer_id => 123, p_items => v_items, p_order_id => v_new_order_id);
--         DBMS_OUTPUT.PUT_LINE('Successful order created with ID: ' || v_new_order_id);
--     Test Case 2: Insufficient Stock
--         Populate v_items: 50 Keyboard Ultra (stock is 10).
--         Wrap the call to CreateNewOrder in a BEGIN...EXCEPTION block to catch OrderProcessingPkg.e_insufficient_stock (or the ORA-20010 error).
--         DBMS_OUTPUT.PUT_LINE('Caught insufficient stock: ' || SQLERRM);
--     Test Case 3: Product Not Found
--         Populate v_items: 1 item with a non-existent productId (e.g., 9999).
--         Wrap the call to CreateNewOrder in a BEGIN...EXCEPTION block to catch OrderProcessingPkg.e_product_not_found (or ORA-20011).
--         DBMS_OUTPUT.PUT_LINE('Caught product not found: ' || SQLERRM);
--     After all tests, query Orders, OrderItems, Products (to check stock levels), and AuditLog to verify all operations and logging.

SET SERVEROUTPUT ON;
DECLARE
    v_idx PLS_INTEGER;
    TYPE OrderItemRect IS RECORD (
        productId PLSQLRESILIENCE.PRODUCTS.PRODUCTID%TYPE,
        quantity PLSQLRESILIENCE.PRODUCTS.STOCKQUANTITY%TYPE
    );
    TYPE OrderItemList IS TABLE OF OrderItemRect INDEX BY VARCHAR2(50);
    v_new_order_id PLSQLRESILIENCE.Orders.ORDERID%TYPE;
    case_1 PLSQLRESILIENCE.OrderProcessingPkg.OrderItemList;
    case_2 PLSQLRESILIENCE.OrderProcessingPkg.OrderItemList;
    case_3 PLSQLRESILIENCE.OrderProcessingPkg.OrderItemList;
    v_product_id PLSQLRESILIENCE.PRODUCTS.PRODUCTID%TYPE;
    v_quantity PLSQLRESILIENCE.PRODUCTS.STOCKQUANTITY%TYPE;
    v_laptop_id    PLSQLRESILIENCE.Products.productId%TYPE;
    v_mouse_id     PLSQLRESILIENCE.Products.productId%TYPE;
    v_keyboard_id  PLSQLRESILIENCE.Products.productId%TYPE;
    v_monitor_id   PLSQLRESILIENCE.Products.productId%TYPE;
BEGIN
    -- Lookup product IDs by name
    SELECT productId INTO v_laptop_id FROM PLSQLRESILIENCE.Products WHERE productName = 'Laptop Pro';
    SELECT productId INTO v_mouse_id FROM PLSQLRESILIENCE.Products WHERE productName = 'Wireless Mouse';
    SELECT productId INTO v_keyboard_id FROM PLSQLRESILIENCE.Products WHERE productName = 'Keyboard Ultra';
    SELECT productId INTO v_monitor_id FROM PLSQLRESILIENCE.Products WHERE productName = 'Monitor HD';

    -- Test Case 1: Successful Order (1 Laptop Pro, 2 Wireless Mouse)
    case_1(1).productId := v_laptop_id;
    case_1(1).quantity := 50;
    case_1(2).productId := v_mouse_id;
    case_1(2).quantity := 200;
    BEGIN
        PLSQLRESILIENCE.OrderProcessingPkg.CreateNewOrder(
            p_customer_id => 123,
            p_items       => case_1,
            p_order_id    => v_new_order_id
        );
        DBMS_OUTPUT.PUT_LINE('Successful order created with ID: ' || v_new_order_id);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 1: ' || SQLERRM);
    END;
    -- Test case 2; Insufficient Stock
    case_2(1).quantity := 10;
    case_2(1).productId := v_keyboard_id;
    BEGIN
        PLSQLRESILIENCE.OrderProcessingPkg.CreateNewOrder(
            p_customer_id => 123,
            p_items       => case_2,
            p_order_id    => v_new_order_id
        );
        DBMS_OUTPUT.PUT_LINE('Successful order created with ID: ' || v_new_order_id);
    EXCEPTION
        WHEN PLSQLRESILIENCE.OrderProcessingPkg.e_insufficient_stock 
            THEN DBMS_OUTPUT.PUT_LINE('Caught insufficient stock: ' || SQLERRM);
    END;
    -- Test case 3: Product Not Found
    case_3(1).quantity := 10;
    case_3(1).productId := 9999;
    BEGIN
        PLSQLRESILIENCE.OrderProcessingPkg.CreateNewOrder(
            p_customer_id => 123,
            p_items       => case_3,
            p_order_id    => v_new_order_id
        );
        DBMS_OUTPUT.PUT_LINE('Successful order created with ID: ' || v_new_order_id);
    EXCEPTION
        WHEN PLSQLRESILIENCE.OrderProcessingPkg.e_product_not_found 
            THEN DBMS_OUTPUT.PUT_LINE('Caught product not found: ' || SQLERRM);
    END;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Product not found');
    WHEN INVALID_NUMBER THEN 
        DBMS_OUTPUT.PUT_LINE('A quantity cant be les than zero, but is ('||v_quantity||')');
END;
/

ROLLBACK;