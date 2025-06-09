        -- Collections & Records, Bulk Operations for Performance, Dynamic SQL


--  (iv) Hardcore Combined Problem
--      Exercise 4.1: Order Processing, Stock Management, Logging, and Dynamic Reporting
-- Design a complex PL/SQL package that simulates part of an order processing workflow. The package should include procedures and use various concepts learned: 
-- collections, records, bulk operations, dynamic SQL, cursors, functions, exception handling, and leverage relevant aspects of the dataset and previous modules.

--      Package orderProcessor Requirements:
-- Collection Types: Define necessary collection types within the package specification (e.g., for lists of product IDs, quantities, order item details). Use 
-- appropriate types (Associative Array, Nested Table, Varray) based on the data structure and required operations. Define a RECORD type for processing order items.
-- Bulk Fetch: Create a packaged function getLowStockProductIds that uses BULK COLLECT to fetch the productId of all products where stockQuantity is below a threshold 
-- (e.g., 100) into a collection and returns this collection.
-- Bulk Update: Create a packaged procedure processOrderItems that takes an orderId (NUMBER) as input.
    -- Inside processOrderItems, use a cursor to select orderItemId, productId, and quantity for all items in the given order.
    -- Fetch these items into collections using BULK COLLECT.
    -- Implement stock deduction: For each item, update the products table to reduce the stockQuantity by the item's quantity. Use a FORALL statement for this batch 
    -- update. 
    -- Include SAVE EXCEPTIONS and handle ORA-24381 to report items that failed (e.g., if stock goes negative). Log failures using DBMS_OUTPUT.
    -- Use the RETURNING INTO BULK COLLECT clause in the FORALL update to get the new stockQuantity for the updated products into another collection.
    -- Update the orders table to change the status to 'Processed' *only if* all stock updates for that order succeeded. If there were *any* bulk exceptions, set the 
    -- status to 'Stock Issue' instead.
-- Dynamic Logging: Create a packaged procedure logCustomerAction that takes customerId (NUMBER), actionType (VARCHAR2), and actionDetails (VARCHAR2) as input. 
    -- Dynamically insert a row into the customerLog table using EXECUTE IMMEDIATE. The customerName column in customerLog should be populated by dynamically selecting 
    -- the lastName from the employees table based on customerId (assuming customerId maps to employeeId for simplicity in this dataset context). Handle NO_DATA_FOUND 
    -- if the customerId is not found in employees. Use bind variables for all data inputs in the dynamic SQL string.




CREATE OR REPLACE PACKAGE PLSQLMASTERY.orderProcessor AS
    TYPE productIdsT IS TABLE OF PLSQLMASTERY.PRODUCTS.PRODUCTID%TYPE;
    productIds productIdsT;
    TYPE newStockQtysT IS TABLE OF PLSQLMASTERY.PRODUCTS.STOCKQUANTITY%TYPE INDEX BY PLS_INTEGER;
    TYPE orderItemsR IS RECORD (
        orderID PLSQLMASTERY.ORDERITEMS.ORDERID%TYPE,
        orderItemId PLSQLMASTERY.ORDERITEMS.ORDERITEMID%TYPE,
        productId PLSQLMASTERY.ORDERITEMS.PRODUCTID%TYPE,
        quantity PLSQLMASTERY.ORDERITEMS.QUANTITY%TYPE
    );
    TYPE updatedProductsT IS TABLE OF PLSQLMASTERY.PRODUCTS.STOCKQUANTITY%TYPE INDEX BY PLS_INTEGER;
    updatedProducts updatedProductsT;
    TYPE orderItemsT IS TABLE OF orderItemsR;
    orderItems orderItemsT;
    TYPE failedOrdersT IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
    failedOrders failedOrdersT;
    CURSOR fetcher(p_orderId NUMBER) IS (
        SELECT ORDERID, ORDERITEMID, PRODUCTID, QUANTITY 
        FROM PLSQLMASTERY.ORDERITEMS 
        WHERE ORDERID = p_orderId
    );
    FUNCTION getLowStockProductIds(threeshold SMALLINT) RETURN productIdsT;
    PROCEDURE processOrderItems(ordrId IN PLSQLMASTERY.ORDERS.ORDERID%TYPE, orderItems OUT orderItemsT, updatedProducts OUT updatedProductsT);
    PROCEDURE logCustomerAction(customerId IN PLSQLMASTERY.ORDERS.CUSTOMERID%TYPE, actionType IN VARCHAR2, actionDetails IN VARCHAR2);
    FUNCTION getProductsAbovePrice(minPrice IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE tests(threeshold SMALLINT := 100, orderId SMALLINT := 2002);
END orderProcessor;
/

CREATE OR REPLACE PACKAGE BODY PLSQLMASTERY.orderProcessor AS

    FUNCTION getLowStockProductIds(threeshold SMALLINT) RETURN productIdsT IS
    BEGIN 
        SELECT PRODUCTID BULK COLLECT INTO productIds 
        FROM PLSQLMASTERY.PRODUCTS 
        WHERE STOCKQUANTITY < threeshold;
        RETURN productIds;
    END getLowStockProductIds;

    PROCEDURE processOrderItems(ordrId IN PLSQLMASTERY.ORDERS.ORDERID%TYPE, orderItems OUT orderItemsT, updatedProducts OUT updatedProductsT) IS
    newStockQtys newStockQtysT;
    failedOrders failedOrdersT;
    orderStatus VARCHAR2(50);
    BEGIN
        OPEN fetcher(ordrId);
            FETCH fetcher BULK COLLECT INTO orderItems;
        CLOSE fetcher;
        SAVEPOINT notMassiveUpdating;
        BEGIN
            FORALL i IN orderItems.FIRST..orderItems.LAST SAVE EXCEPTIONS
                UPDATE PLSQLMASTERY.PRODUCTS 
                    SET STOCKQUANTITY = STOCKQUANTITY - orderItems(i).quantity 
                WHERE PRODUCTID = orderItems(i).productId
                RETURNING STOCKQUANTITY BULK COLLECT INTO newStockQtys;
        EXCEPTION
            WHEN 
                OTHERS THEN 
                IF SQLCODE = -24381 THEN 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM);
                    DBMS_OUTPUT.PUT_LINE('There exists '||SQL%BULK_EXCEPTIONS.COUNT||' errors in the massive forall updating');
                    FOR x IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
                        DBMS_OUTPUT.PUT_LINE('For the row '||x||'the error is '||SQL%BULK_EXCEPTIONS(x).ERROR_CODE);
                        failedOrders(orderItems(SQL%BULK_EXCEPTIONS(x).ERROR_INDEX).ORDERID) := TRUE;
                    END LOOP;
                END IF;
        END;
        FOR x IN 1..orderItems.COUNT LOOP
            updatedProducts(orderItems(x).productId) := newStockQtys(x);
            IF NOT failedOrders.EXISTS(orderItems(x).orderId) THEN failedOrders(orderItems(x).productId) := FALSE;
            END IF;
        END LOOP;
        FOR i IN failedOrders.FIRST .. failedOrders.LAST LOOP
            IF failedOrders.EXISTS(i) THEN
                orderStatus := CASE failedOrders(i)
                    WHEN TRUE THEN 'Stock Issue'
                    ELSE 'Processed'
                END;
                UPDATE PLSQLMASTERY.ORDERS
                SET STATUS = orderStatus
                WHERE ORDERID = i;
                DBMS_OUTPUT.PUT_LINE('Order Id '||i||' updated as '||orderStatus);
            END IF;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
    END processOrderItems;

    PROCEDURE logCustomerAction(
        customerId IN PLSQLMASTERY.ORDERS.CUSTOMERID%TYPE, 
        actionType IN VARCHAR2, 
        actionDetails IN VARCHAR2
    ) IS
        statment VARCHAR2(100) := 'INSERT INTO PLSQLMASTERY.CUSTOMERLOG(CUSTOMERNAME, ACTIONDETAILS) VALUES(:customerName, :details)';
        fullName VARCHAR2(50);
        ordrId NUMBER;
    BEGIN
        BEGIN
            SELECT FIRSTNAME||' '||LASTNAME, ORDERID INTO fullName, ordrId
            FROM PLSQLMASTERY.ORDERS 
            NATURAL JOIN PLSQLMASTERY.EMPLOYEES 
            WHERE EMPLOYEEID = customerId;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No data found for employee id: '||customerId);
            RAISE;
        END;
        EXECUTE IMMEDIATE statment USING fullName, actionType||': '||actionDetails;
        DBMS_OUTPUT.PUT_LINE('Processed order '||ordrId);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Customer id: '||customerId||' is necessary but it does not exists');
        RAISE;
    END;

-- Dynamic Reporting: Create a packaged function getProductsAbovePrice that takes minPrice (NUMBER). Builds a SELECT productId, productName, price 
    -- FROM products WHERE price > :minPrice. Use DBMS_SQL.OPEN_CURSOR, PARSE, BIND_VARIABLE, EXECUTE. Then use DBMS_SQL.TO_REFCURSOR to convert the `DBMS_SQL` cursor 
    -- number to a SYS_REFCURSOR and return it.

    FUNCTION getProductsAbovePrice(minPrice IN NUMBER) RETURN SYS_REFCURSOR IS
        statment VARCHAR2(250) := 'SELECT productId, productName, price FROM PLSQLMASTERY.PRODUCTS WHERE price > :minPrice';
        productFetcher INTEGER;
        v_result INTEGER;
        v_productId PLSQLMASTERY.PRODUCTS.PRODUCTID%TYPE;
        v_productName PLSQLMASTERY.PRODUCTS.PRODUCTNAME%TYPE;
        v_price PLSQLMASTERY.PRODUCTS.PRICE%TYPE;
        rc SYS_REFCURSOR;
    BEGIN
        productFetcher := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(productFetcher, statment, DBMS_SQL.NATIVE);
        DBMS_SQL.BIND_VARIABLE(productFetcher, ':minPrice', minPrice);
        DBMS_SQL.DEFINE_COLUMN(productFetcher, 1, v_productId);
        DBMS_SQL.DEFINE_COLUMN(productFetcher, 2, v_productName, 50);
        DBMS_SQL.DEFINE_COLUMN(productFetcher, 3, v_price);
        v_result := DBMS_SQL.EXECUTE(productFetcher);
        rc := DBMS_SQL.TO_REFCURSOR(productFetcher);
        RETURN rc;
    END;

    PROCEDURE tests(threeshold SMALLINT, orderId SMALLINT) IS
        productIds productIdsT;
        orderItems orderItemsT;
        updatedProducts updatedProductsT;
        v_productId PLSQLMASTERY.PRODUCTS.PRODUCTID%TYPE;
        v_productName PLSQLMASTERY.PRODUCTS.PRODUCTNAME%TYPE;
        v_price PLSQLMASTERY.PRODUCTS.PRICE%TYPE;
        rc SYS_REFCURSOR;
    BEGIN
        productIds := getLowStockProductIds(threeshold);
        DBMS_OUTPUT.PUT_LINE('PRODUCT IDS:');
        FOR x IN 1..productIds.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('ID: '||productIds(x));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        processOrderItems(orderId, orderItems, updatedProducts);

        DBMS_OUTPUT.PUT_LINE('ORDER ITEMs');
        FOR x IN INDICES OF orderItems LOOP
            DBMS_OUTPUT.PUT_LINE(
                'ORDER ITEM ID:'||orderItems(x).orderItemId||', PRODUCT ID:'||orderItems(x).productId||', QUANTITY:'||orderItems(x).quantity
            );
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('UPDATED PRODUCTs');
        FOR x IN INDICES OF updatedProducts LOOP
            DBMS_OUTPUT.PUT_LINE(
                'UPDATED PRODUCT ID:'||x||', UPDATED QUANTITY:'||TO_CHAR(updatedProducts(x))
            );
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('LOGGING CUSTOMER ACTIONS');
        -- logCustomerAction(1000, 'Purchase', '2 productivity subscriptions');
        -- logCustomerAction(9999, 'Purchase', '1 productivity subscriptions');

        DBMS_OUTPUT.PUT_LINE('Report cursor for products priced above $200');
        rc := getProductsAbovePrice(200);
        LOOP
            FETCH rc INTO v_productId, v_productName, v_price;
            EXIT WHEN rc%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('  Prod ID: ' || v_productId || ', Name: ' || v_productName || ', Price: ' || v_price);
        END LOOP;
    END;
    
END orderProcessor;
/

BEGIN
    PLSQLMASTERY.orderProcessor.tests();
END;
/

ROLLBACK;


-- Error Handling: Implement specific exception handlers within the package body for expected errors (like NO_DATA_FOUND, potentially others from constraints or logic 
-- checks you might add). Use SQLCODE and SQLERRM.
-- Main Block: Write an anonymous block to test the orderProcessor package.
-- Call processOrderItems for order 2002.
-- Call processOrderItems for order 2003.
-- Call logCustomerAction for a sample customer/employee ID (e.g., 1001) logging an action like 'Processed order 2002'.
-- Call logCustomerAction for an unknown customer ID (e.g., 9999).
-- Call getLowStockProductIds and print the resulting IDs.
-- Call getProductsAbovePrice to get a report cursor for products priced above $200, then fetch and print a few rows from the cursor.
-- Demonstrate a simple PTF concept using a conceptual query with the COLUMNS pseudo-operator as shown in the materials, without requiring a full PTF implementation.