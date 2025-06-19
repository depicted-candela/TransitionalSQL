        -- Oracle Blueprint


--  Type (iv): Hardcore Combined Problem

-- This exercise integrates concepts from this module and assumes knowledge of basic DDL/DML. It is designed to be challenging and to test your ability to synthesize 
-- information.

--      Exercise: The Robust Archival Process
-- Problem:
-- You are tasked with creating a nightly archival process for a new e-commerce platform. The core tables are BLUEPRINT.orders and BLUEPRINT.orderItems. The business 
-- rule is that any order completed more than 365 days ago, along with its associated line items, should be moved to archive tables. The process must be robust, 
-- performant, and transactional.
TRUNCATE TABLE BLUEPRINT.orderItems;
TRUNCATE TABLE BLUEPRINT.orders;

CREATE TABLE BLUEPRINT.orders (
    orderId        NUMBER(10) PRIMARY KEY,
    customerId     NUMBER(10),
    orderDate      DATE DEFAULT SYSDATE,
    completionDate DATE,
    status         VARCHAR2(20) CHECK (status IN ('PENDING', 'SHIPPED', 'COMPLETED', 'CANCELLED'))
);
CREATE TABLE BLUEPRINT.orderItems (
    orderItemId    NUMBER(10) PRIMARY KEY,
    orderId        NUMBER(10) NOT NULL,
    productId      NUMBER(10) NOT NULL,
    quantity       NUMBER(5) NOT NULL,
    unitPriceAtSale NUMBER(8, 2) NOT NULL,
    CONSTRAINT fkOrderItemsOrders FOREIGN KEY (orderId) REFERENCES BLUEPRINT.orders(orderId) ON DELETE CASCADE,
    CONSTRAINT fkOrderItemsProducts FOREIGN KEY (productId) REFERENCES BLUEPRINT.products(productId)
);

DROP SEQUENCE orderSeq;
DROP SEQUENCE orderItemSeq;
CREATE SEQUENCE orderSeq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE orderItemSeq START WITH 1 INCREMENT BY 1 NOCACHE;

-- Populate with data
-- Populate data for the "Hardcore Combined Problem"
-- An old, completed order (eligible for archival)
INSERT INTO BLUEPRINT.orders (orderId, customerId, orderDate, completionDate, status) VALUES (orderSeq.NEXTVAL, 1, SYSDATE - 400, SYSDATE - 395, 'COMPLETED');
INSERT INTO BLUEPRINT.orderItems(orderItemId, orderId, productId, quantity, unitPriceAtSale) VALUES (orderItemSeq.NEXTVAL, 1, 100, 1, 4500.00);
INSERT INTO BLUEPRINT.orderItems(orderItemId, orderId, productId, quantity, unitPriceAtSale) VALUES (orderItemSeq.NEXTVAL, 1, 101, 2, 75.50);
-- Another old, completed order (eligible for archival)
INSERT INTO BLUEPRINT.orders (orderId, customerId, orderDate, completionDate, status) VALUES (orderSeq.NEXTVAL, 2, SYSDATE - 500, SYSDATE - 490, 'COMPLETED');
INSERT INTO BLUEPRINT.orderItems(orderItemId, orderId, productId, quantity, unitPriceAtSale) VALUES (orderItemSeq.NEXTVAL, 2, 102, 5, 145.00); -- Price was slightly different
-- A recent, completed order (NOT eligible for archival)
INSERT INTO BLUEPRINT.orders (orderId, customerId, orderDate, completionDate, status) VALUES (orderSeq.NEXTVAL, 1, SYSDATE - 15, SYSDATE - 10, 'COMPLETED');
INSERT INTO BLUEPRINT.orderItems(orderItemId, orderId, productId, quantity, unitPriceAtSale) VALUES (orderItemSeq.NEXTVAL, 3, 100, 1, 4500.00);
-- An order that is still pending (NOT eligible for archival)
INSERT INTO BLUEPRINT.orders (orderId, customerId, orderDate, completionDate, status) VALUES (orderSeq.NEXTVAL, 3, SYSDATE - 5, NULL, 'PENDING');
INSERT INTO BLUEPRINT.orderItems(orderItemId, orderId, productId, quantity, unitPriceAtSale) VALUES (orderItemSeq.NEXTVAL, 4, 101, 1, 75.50);
COMMIT;

TRUNCATE TABLE BLUEPRINT.archivedOrders;
TRUNCATE TABLE BLUEPRINT.archivedOrderItems;

CREATE TABLE BLUEPRINT.archivedOrders (
    orderId        NUMBER(10) PRIMARY KEY,
    customerId     NUMBER(10),
    orderDate      DATE DEFAULT SYSDATE,
    completionDate DATE,
    status         VARCHAR2(20) CHECK (status IN ('COMPLETED', 'CANCELLED'))
);

CREATE TABLE BLUEPRINT.archivedOrderItems (
    orderItemId    NUMBER(10) PRIMARY KEY,
    orderId        NUMBER(10) NOT NULL,
    productId      NUMBER(10) NOT NULL,
    quantity       NUMBER(5) NOT NULL,
    unitPriceAtSale NUMBER(8, 2) NOT NULL,
    CONSTRAINT fkArchivedOrderItemsOrders FOREIGN KEY (orderId) REFERENCES BLUEPRINT.archivedOrders(orderId) ON DELETE CASCADE,
    CONSTRAINT fkArchivedOrderItemsProducts FOREIGN KEY (productId) REFERENCES BLUEPRINT.products(productId)
);

DROP SEQUENCE archivedOrderSeq;
DROP SEQUENCE archivedOrderItemSeq;
CREATE SEQUENCE archivedOrderSeq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE archivedOrderItemSeq START WITH 1 INCREMENT BY 1 NOCACHE;
COMMIT;

-- Your Task: Create a PL/SQL package named OrderArchiver that contains a single procedure, archiveOldOrders.
ALTER SESSION SET CURRENT_SCHEMA = BLUEPRINT;

CREATE OR REPLACE PACKAGE BLUEPRINT.OrderArchiver IS
    PROCEDURE archiveOldOrders(parental_table IN VARCHAR2, child_plural_suffix IN VARCHAR2);
END OrderArchiver;
/

CREATE OR REPLACE PACKAGE BODY BLUEPRINT.OrderArchiver IS
    PROCEDURE archiveOldOrders(parental_table IN VARCHAR2, child_plural_suffix IN VARCHAR2) IS
        -- Static variables for clarity
        l_id_suffix           VARCHAR2(3)  := 'ID';
        l_archive_prefix      VARCHAR2(9)  := 'archived';
        -- Dynamically constructed names
        l_singular_parent     VARCHAR2(40) := SUBSTR(parental_table, 1, LENGTH(parental_table) - 1);
        l_child_table         VARCHAR2(40) := l_singular_parent || child_plural_suffix;
        l_parent_id_col       VARCHAR2(40) := l_singular_parent || l_id_suffix;
        l_child_parent_fk_col VARCHAR2(40) := l_singular_parent || l_id_suffix;
        -- Archive table names (now hardcoded as per the requirement)
        l_archived_parent_table VARCHAR2(50) := l_archive_prefix||parental_table;
        l_archived_child_table  VARCHAR2(50) := l_archive_prefix||l_child_table;
        -- Dynamic SQL statements
        l_insert_parent_archive_sql VARCHAR2(1000);
        l_insert_child_archive_sql  VARCHAR2(1000);
        l_delete_child_sql          VARCHAR2(1000);
        l_delete_parent_sql         VARCHAR2(1000);
        -- Collection for batching
        TYPE t_order_id_tab IS TABLE OF BLUEPRINT.ORDERS.ORDERID%TYPE;
        l_order_ids t_order_id_tab;
        -- Variable to hold the new PK for the archived order
        l_new_archive_order_id BLUEPRINT.ARCHIVEDORDERS.ORDERID%TYPE;
        -- Cursor to find old orders
        CURSOR c_old_orders IS
            SELECT OrderId
            FROM BLUEPRINT.ORDERS
            WHERE OrderDate < SYSDATE - 365;
        l_batch_size PLS_INTEGER := 100;
    BEGIN
        -- Build the dynamic SQL statements ONCE.
        -- These now include explicit column lists and use sequences.
        l_insert_parent_archive_sql := 'INSERT INTO ' || DBMS_ASSERT.ENQUOTE_NAME(l_archived_parent_table) ||
                                       ' (ORDERID, CUSTOMERID, ORDERDATE, COMPLETIONDATE, STATUS)' ||
                                       ' SELECT :new_id, CUSTOMERID, ORDERDATE, COMPLETIONDATE, STATUS' ||
                                       ' FROM ' || DBMS_ASSERT.ENQUOTE_NAME(parental_table) ||
                                       ' WHERE ' || DBMS_ASSERT.ENQUOTE_NAME(l_parent_id_col) || ' = :original_id';
        l_insert_child_archive_sql  := 'INSERT INTO ' || DBMS_ASSERT.ENQUOTE_NAME(l_archived_child_table) ||
                                       ' (ORDERITEMID, ORDERID, PRODUCTID, QUANTITY, UNITPRICEATSALE)' ||
                                       ' SELECT archivedOrderItemSeq.NEXTVAL, :new_id, PRODUCTID, QUANTITY, UNITPRICEATSALE' ||
                                       ' FROM ' || DBMS_ASSERT.ENQUOTE_NAME(l_child_table) ||
                                       ' WHERE ' || DBMS_ASSERT.ENQUOTE_NAME(l_child_parent_fk_col) || ' = :original_id';
        l_delete_child_sql          := 'DELETE FROM ' || DBMS_ASSERT.ENQUOTE_NAME(l_child_table) ||
                                       ' WHERE ' || DBMS_ASSERT.ENQUOTE_NAME(l_child_parent_fk_col) || ' = :id';
        l_delete_parent_sql         := 'DELETE FROM ' || DBMS_ASSERT.ENQUOTE_NAME(parental_table) ||
                                       ' WHERE ' || DBMS_ASSERT.ENQUOTE_NAME(l_parent_id_col) || ' = :id';
        DBMS_OUTPUT.PUT_LINE('Archiving from ' || parental_table || ' and ' || l_child_table);
        DBMS_OUTPUT.PUT_LINE('To ' || l_archived_parent_table || ' and ' || l_archived_child_table);
        OPEN c_old_orders;
        LOOP
            -- Fetch a batch of original order IDs
            FETCH c_old_orders BULK COLLECT INTO l_order_ids LIMIT l_batch_size;
            EXIT WHEN l_order_ids.COUNT = 0;
            DBMS_OUTPUT.PUT_LINE('Processing a batch of ' || l_order_ids.COUNT || ' orders.');
            FOR i IN 1 .. l_order_ids.COUNT LOOP
                SAVEPOINT before_order_archive;
                BEGIN
                    -- 1. Get a new, unique primary key for the archived order.
                    SELECT archivedOrderSeq.NEXTVAL INTO l_new_archive_order_id FROM dual;
                    -- 2. Archive the parent record using the new PK.
                    --    Binds: 1 (new id), 2 (original id)
                    EXECUTE IMMEDIATE l_insert_parent_archive_sql USING l_new_archive_order_id, l_order_ids(i);
                    -- 3. Archive the child records using the new FK.
                    --    Binds: 1 (new id), 2 (original id)
                    EXECUTE IMMEDIATE l_insert_child_archive_sql USING l_new_archive_order_id, l_order_ids(i);
                    -- 4. Delete original child records (identified by original ID).
                    EXECUTE IMMEDIATE l_delete_child_sql USING l_order_ids(i);
                    -- 5. Delete original parent record (identified by original ID).
                    EXECUTE IMMEDIATE l_delete_parent_sql USING l_order_ids(i);
                EXCEPTION
                    WHEN OTHERS THEN
                        ROLLBACK TO before_order_archive;
                        DBMS_OUTPUT.PUT_LINE('Error archiving original OrderID ' || l_order_ids(i) || ': ' || SQLERRM);
                END;
            END LOOP;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Batch committed.');
        END LOOP;
        CLOSE c_old_orders;
        DBMS_OUTPUT.PUT_LINE('Order archiving complete.');
    END archiveOldOrders;
END OrderArchiver;
/

DECLARE
    parental_table VARCHAR2(30);
BEGIN
    BLUEPRINT.OrderArchiver.archiveOldOrders('ORDERS', 'ITEMS');
END;
/

-- Requirements:
-- Metadata-Driven: The procedure should not have hardcoded table names for the child table. Instead, it should be designed to work on a base table (for example, 
-- BLUEPRINT.orders) and find its child table (orderItems) by querying the Data Dictionary views. Hint: Use USER_CONSTRAINTS to find foreign key relationships.
-- Schema Objects: Create the necessary archive tables (archivedOrders, archivedOrderItems) and a sequence (archiveBatchSeq) to generate a unique ID for each archival 
-- run.
-- Transaction Management: The entire archival run for all old BLUEPRINT.orders must be a single, logical transaction. However, you must implement a mechanism using SAVEPOINT 
-- so that if an error occurs while processing a single order (and its line items), only the changes for that specific order are rolled back. The procedure should then 
-- log the error to a separate archiveErrors table and continue processing the next order. The entire batch of successful archival operations should be made permanent 
-- with a final COMMIT at the very end. Reference: Consult the DML and Transactions chapter in the Get Started guide.

-- Concurrency Test (Conceptual): While your archival procedure is running, it should only lock the *specific old rows* it is processing. Explain how you would test 
-- that a separate session can still INSERT a brand-new order into the BLUEPRINT.orders and BLUEPRINT.orderItems tables without being blocked.
-- Answer: this test can be performed with a middleware activating the method for cleaning old orders and pushing a new one, because juust old rows are cleaned, such
-- scenario is not problematic