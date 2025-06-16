<head>
    <link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/solutions.css">
</head>

<body>
<div class="container">
    <h1>Oracle Blueprint: Solutions for Essential Database Concepts</h1>
    <div class="postgresql-bridge">
        <p><strong>Introduction: Validating Your Oracle Knowledge</strong></p>
        <p>
            Welcome to the solutions for "Oracle Blueprint." This document is your guide to validating the practical exercises you've just completed. The goal here is not simply to check for a correct answer, but to solidify your understanding of <em>why</em> the Oracle-specific solution is designed the way it is.
        </p>
        <p>
            Even if your code produced the correct result, we strongly encourage you to review the explanations. They contain crucial insights into Oracle's Data Dictionary structure, its powerful transaction control model, and the nuances of its Multi-Version Concurrency Control (MVCC) system, often contrasting them with the approaches you may be familiar with from PostgreSQL.
        </p>
    </div>
    <h2>Reviewing the Dataset</h2>
    <p>
        All solutions operate on the schema created by the <code>NewSchema.sql</code> script. This schema includes tables like <code>products</code>, <code>warehouses</code>, and <code>inventory</code>, linked by foreign keys. It also features a second schema, <code>anotherSchema</code>, to demonstrate cross-user interactions, privileges, and the use of synonyms. Familiarity with these relationships is key to understanding the transaction and data dictionary exercises.
    </p>
    <h3>Solution Structure</h3>
    <p>
        Each exercise is presented with its original problem statement for context, followed by the complete, optimal Oracle SQL or PL/SQL solution. The most valuable part is the detailed explanation that follows, which breaks down the code and highlights the core Oracle concepts at play.
    </p>
    <div id="solutions-placeholder">
        <!-- The generated solutions will be placed here -->
        <h2>Solutions: Essential Oracle Database Concepts</h2>
        <hr>
        <h3>Type (i): Meanings, Values, Relations, and Advantages</h3>
        <p>These exercises explore the fundamental "what" and "why" of Oracle's schema and transaction architecture.</p>
        <h4>Exercise 1: Exploring Your Schema with the Data Dictionary</h4>
        <h5 class="problem-label">Problem</h5>
        <p>You have just created several objects in your <code>NewSchema</code> schema. Your task is to use Oracle's Data Dictionary views to answer the following questions:</p>
        <ol>
            <li>List all objects (and their types) that you own in your current schema.</li>
            <li>Find the names and data types of all columns in the <code>inventory</code> table.</li>
            <li>Display the source code for the <code>getProductCount</code> procedure.</li>
            <li>List all constraints on the <code>inventory</code> table.</li>
        </ol>
        <div class="postgresql-bridge">
            <strong>Bridging from PostgreSQL:</strong> In PostgreSQL, you would query the <code>information_schema</code> views or use psql's backslash commands (<code>\d</code>, <code>\dt</code>). Oracle's equivalent is a powerful trio of view families: <code>USER_*</code>, <code>ALL_*</code>, and <code>DBA_*</code>. This exercise focuses on the <code>USER_*</code> views, which are the most common and accessible for a developer.
        </div>
        <h5 class="solution-label">Solution</h5>
        <pre><code class="language-sql">
-- Solution 1: List all objects you own
-- The USER_OBJECTS view is the developer's primary tool for seeing what exists in their own schema.
SELECT
    object_name AS objectName,
    object_type AS objectType,
    status,
    created
FROM
    user_objects
ORDER BY
    object_type,
    object_name;

-- Solution 2: Find columns in the 'inventory' table
-- The USER_TAB_COLUMNS view provides detailed information about every column in every table owned by the user.
-- Note: By default, Oracle stores object names in uppercase unless they are created with double quotes.
SELECT
    column_name AS columnName,
    data_type AS dataType,
    data_length AS dataLength,
    nullable
FROM
    user_tab_columns
WHERE
    table_name = 'INVENTORY';

-- Solution 3: Display the source code for the getProductCount procedure
-- This is a powerful Oracle feature. The source code for PL/SQL units is stored directly in the data dictionary.
SELECT
    text
FROM
    user_source
WHERE
    name = 'GETPRODUCTCOUNT'
ORDER BY
    line;

-- Solution 4: List constraints on the 'inventory' table
-- USER_CONSTRAINTS is essential for understanding the rules governing your data.
SELECT
    constraint_name,
    constraint_type,
    search_condition
FROM
    user_constraints
WHERE
    table_name = 'INVENTORY';
</code></pre>
        <h5>Explanation</h5>
        <ol>
            <li>The <code>USER_OBJECTS</code> view is your "table of contents" for your own schema. It lists every table, index, view, procedure, function, package, and sequence you own. This is a fundamental view for any Oracle developer.</li>
            <li><code>USER_TAB_COLUMNS</code> is the Oracle equivalent of diving into <code>information_schema.columns</code>. It's the standard way to programmatically discover the structure of your tables.</li>
            <li>The ability to query <code>USER_SOURCE</code> is a significant advantage in Oracle. It allows you to retrieve the source code of any PL/SQL object you have access to, which is invaluable for debugging, code reviews, and understanding existing logic without needing access to the original source files.</li>
            <li><code>USER_CONSTRAINTS</code> provides a clear, queryable list of all data integrity rules. The <code>constraint_type</code> column is particularly useful, using codes like 'P' for Primary Key, 'R' for Foreign Key (Referential), and 'C' for Check.</li>
        </ol>
        <h4>Exercise 2: Creating and Using Core Schema Objects</h4>
        <h5 class="problem-label">Problem</h5>
        <p>Create a simple <code>employees</code> table to track who manages which warehouse.</p>
        <ol>
            <li>Create a sequence named <code>employeeSeq</code> to generate unique employee IDs.</li>
            <li>Create a table named <code>employees</code> with an ID, name, and a foreign key to <code>warehouses</code>.</li>
            <li>Insert two employees, using the sequence.</li>
            <li>Create a view named <code>warehouseManagers</code> showing the employee and warehouse names.</li>
            <li>As <code>anotherSchema</code>, create a private synonym named <code>prodList</code> pointing to <code>NewSchema.products</code> and query it.</li>
        </ol>
        <div class="oracle-specific">
            <strong>Oracle Advantage:</strong> A <strong>Sequence</strong> is a standalone database object, unlike PostgreSQL's <code>SERIAL</code> type which is tied to a table column. This makes Oracle sequences more flexible; a single sequence can be used to generate IDs for multiple tables, which is useful for creating a unified key space across a system. A <strong>Synonym</strong> provides a powerful layer of abstraction, allowing you to decouple client code from the underlying schema and object names.
        </div>
        <h5 class="solution-label">Solution</h5>
        <pre><code class="language-sql">
-- Run as NewSchema

-- 1. Create the sequence
CREATE SEQUENCE employeeSeq START WITH 500;

-- 2. Create the table
CREATE TABLE employees (
    employeeId          NUMBER PRIMARY KEY,
    employeeName        VARCHAR2(100),
    managesWarehouseId  NUMBER,
    CONSTRAINT fkEmpWarehouse FOREIGN KEY (managesWarehouseId) REFERENCES warehouses(warehouseId)
);

-- 3. Insert employees using the sequence's NEXTVAL pseudocolumn
INSERT INTO employees (employeeId, employeeName, managesWarehouseId)
VALUES (employeeSeq.NEXTVAL, 'Jane Doe', 1);

INSERT INTO employees (employeeId, employeeName, managesWarehouseId)
VALUES (employeeSeq.NEXTVAL, 'John Smith', 2);

COMMIT;

-- 4. Create the view
CREATE OR REPLACE VIEW warehouseManagers AS
SELECT
    e.employeeName,
    w.warehouseName
FROM
    employees e
JOIN
    warehouses w ON e.managesWarehouseId = w.warehouseId;

-- Query the view to test it
SELECT * FROM warehouseManagers;

-- 5. Grant necessary privilege and create the synonym
-- Must first grant the privilege from the object owner
GRANT SELECT ON products TO anotherSchema;

-- Connect as the other user
CONNECT anotherSchema/Pa_s_sw_rd_2;

-- Create the alias
CREATE SYNONYM prodList FOR NewSchema.products;

-- Test the synonym. Note that `anotherSchema` can query `prodList`
-- without needing to know it's actually `NewSchema.products`.
SELECT productName, unitPrice FROM prodList WHERE category = 'Books';

-- Switch back
CONNECT NewSchema/Pa_s_sw_rd_1;
</code></pre>
        <h5>Explanation</h5>
        <ul>
            <li><strong>Sequence:</strong> We create a <code>SEQUENCE</code> object independently. To get the next unique value, we access its <code>NEXTVAL</code> pseudocolumn. This is a key difference from PostgreSQL's <code>SERIAL</code> data type, which automates this behind the scenes.</li>
            <li><strong>View:</strong> The <code>CREATE VIEW</code> syntax is standard. The view acts as a stored query, simplifying future access to the joined data.</li>
            <li><strong>Synonym:</strong> This is a two-step process. First, the owner (<code>NewSchema</code>) must <code>GRANT</code> the necessary privilege (<code>SELECT</code>) on the object to the other user. Second, the other user (<code>anotherSchema</code>) creates the <code>SYNONYM</code>. This creates an alias, allowing <code>anotherSchema</code> to simply query <code>prodList</code> instead of the more verbose <code>NewSchema.products</code>.</li>
        </ul>
        <h4>Exercise 3: Understanding Oracle's Concurrency (MVCC) and Transaction Control</h4>
        <h5 class="problem-label">Problem</h5>
        <p>Using two separate sessions for <code>NewSchema</code>, demonstrate Oracle's MVCC and transaction control by updating inventory, observing read consistency, using a savepoint, and finally committing.</p>
        <div class="oracle-specific">
            <strong>Oracle Advantage (MVCC):</strong> The most powerful concept demonstrated here is that <strong>readers do not block writers, and writers do not block readers</strong>. Session 2 can query the original, committed state of the data without waiting, even though Session 1 has an uncommitted change on that exact same row. Oracle accomplishes this by using the data in the UNDO segment to reconstruct a read-consistent image of the data block for Session 2.
        </div>
        <h5 class="solution-label">Solution</h5>
        <pre><code class="language-sql">
-- In Session 1:
-- A DML statement automatically begins a transaction.
UPDATE inventory
SET quantityOnHand = quantityOnHand - 10
WHERE productId = 101; -- Quantity is now 190, but only for Session 1

-- Verify the change within the transaction
SELECT quantityOnHand FROM inventory WHERE productId = 101; -- Returns 190

-- Create a named point to which we can roll back
SAVEPOINT before_price_update;

-- Make another change
UPDATE products
SET unitPrice = 80.00
WHERE productId = 101;

-- Undo only the work done after the savepoint
ROLLBACK TO before_price_update;

-- Make the inventory change permanent
COMMIT;


-- In Session 2 (actions performed while Session 1 is active):
-- This query, run after Session 1's UPDATE but before its COMMIT,
-- will not see the change. It reads the last committed state.
SELECT quantityOnHand FROM inventory WHERE productId = 101; -- Returns 200

-- This query, run AFTER Session 1 commits, will see the change.
SELECT quantityOnHand FROM inventory WHERE productId = 101; -- Returns 190
</code></pre>
        <h5>Explanation</h5>
        <ol>
            <li><strong>Read Consistency:</strong> Session 2's initial query demonstrates MVCC. It does not wait for Session 1's lock; instead, Oracle provides a view of the data as it existed before Session 1's `UPDATE`, ensuring consistent and non-blocking reads.</li>
            <li><strong>SAVEPOINT:</strong> This creates a transactional bookmark. The `ROLLBACK TO` command only undoes changes made *after* that bookmark, leaving the initial inventory update intact. This allows for partial rollbacks within a larger transaction, a critical tool for complex procedures.</li>
            <li><strong>COMMIT:</strong> The `COMMIT` command makes all changes in Session 1's transaction (the inventory reduction, in this case) permanent and visible to all other sessions. This is when Session 2 is finally able to see the updated quantity.</li>
        </ol>
        <hr>
        <h3>Type (ii): Disadvantages and Pitfalls</h3>
        <h4>Exercise 1: The Danger of Cascading Drops</h4>
        <h5 class="problem-label">Problem</h5>
        <p>What is the potential pitfall of dropping <code>anotherSchema</code> using the <code>CASCADE</code> option? Demonstrate it.</p>
        <div class="caution">
            <strong>Pitfall:</strong> The <code>CASCADE</code> keyword is powerful but dangerous. It not only drops the user but also forcibly drops every single object that user owns, bypassing any dependencies. There is no "undo" for this operation. A DBA might use this to clean up a test schema, but using it on a schema with important data without a backup is a recipe for disaster.
        </div>
        <h5 class="solution-label">Solution</h5>
        <pre><code class="language-sql">
-- Run as a privileged user like SYS

-- 1. First, verify the object exists and is owned by ANOTHERSCHEMA
SELECT
    owner,
    object_name
FROM
    all_objects
WHERE
    object_name = 'CONFIDENTIALDATA';

-- 2. Drop the user with CASCADE
DROP USER anotherSchema CASCADE;

-- 3. Now, verify the object is gone completely. This query will return no rows.
SELECT
    owner,
    object_name
FROM
    all_objects
WHERE
    object_name = 'CONFIDENTIALDATA';
</code></pre>
        <h4>Exercise 2: The Blocked Update (Row-Level Locking)</h4>
        <h5 class="problem-label">Problem</h5>
        <p>In one session, update the quantity for a product but do not commit. In a second session, try to update the *exact same row*. Describe what happens and why. Then, see what happens when the first session rolls back.</p>
        <div class="caution">
            <strong>Pitfall:</strong> This demonstrates a row-level lock contention. The application in Session 2 would appear to "freeze" or "hang" because it is waiting for the lock from Session 1 to be released. Without proper timeouts or user feedback, this can lead to a poor user experience. Long-held locks from uncommitted transactions are a common source of performance problems in database applications.
        </div>
        <h5 class="solution-label">Solution</h5>
        <pre><code class="language-sql">
-- In Session 1:
UPDATE inventory
SET quantityOnHand = 45
WHERE productId = 100 AND warehouseId = 1;


-- In Session 2 (This statement will wait indefinitely):
UPDATE inventory
SET quantityOnHand = 40
WHERE productId = 100 AND warehouseId = 1;


-- In Session 1 (After a few moments):
-- This releases the lock.
ROLLBACK;


-- Immediately after the ROLLBACK in Session 1, the UPDATE
-- in Session 2 will execute and complete successfully.
</code></pre>
        <h5>Explanation</h5>
        <p>Session 1's `UPDATE` places an exclusive lock on the specific inventory row for product 100 in warehouse 1. When Session 2 attempts to update the *same row*, it must wait until that lock is released. The moment Session 1 issues a `COMMIT` or `ROLLBACK`, the lock is freed, and Session 2's queued `UPDATE` statement is allowed to proceed.</p>
        <hr>
        <h3>Type (iii): Contrasting with Inefficient Common Solutions</h3>
        <h4>Exercise 1: Mass Deletion - <code>DELETE</code> vs. <code>TRUNCATE</code></h4>
        <h5 class="problem-label">Problem</h5>
        <p>You need to purge all rows from the large <code>inventoryLog</code> table. Contrast the common <code>DELETE</code> statement with the more efficient Oracle-idiomatic approach.</p>
        <div class="oracle-specific">
            <strong>Oracle Advantage:</strong> Understanding the difference between DML (<code>DELETE</code>) and DDL (<code>TRUNCATE</code>) is crucial for an Oracle consultant. For clearing a table, <code>TRUNCATE</code> bypasses the row-by-row processing, undo/redo overhead, and trigger firing of a <code>DELETE</code>, making it orders of magnitude faster and less resource-intensive. It's a metadata operation, not a data operation.
        </div>
        <h5 class="solution-label">Solution</h5>
        <pre><code class="language-sql">
-- Inefficient, common approach. This is slow on large tables.
-- It generates one UNDO and REDO entry for every single row.
DELETE FROM inventoryLog;
ROLLBACK; -- We can rollback a DELETE

-- Highly efficient, Oracle-idiomatic approach.
-- This is a DDL statement that deallocates the table's data blocks.
TRUNCATE TABLE inventoryLog;
-- You cannot rollback a TRUNCATE operation.
</code></pre>
        <h5>Explanation</h5>
        <p>A developer accustomed to only basic SQL might reach for <code>DELETE FROM table;</code> to empty a table. While correct, it is highly inefficient for large tables in Oracle. It forces the database to process each row individually, generating massive amounts of `UNDO` and `REDO`, which slows down the system. The `TRUNCATE TABLE` command is the correct tool for this job. It is a DDL operation that quickly and efficiently resets the table's high-water mark, freeing all storage with minimal overhead. The key takeaway is recognizing when a data manipulation task can be more effectively solved with a data definition command.</p>
        <hr>
        <h3>Type (iv): Hardcore Combined Problem</h3>
        <p>This problem integrates all concepts from this module and requires knowledge from previous modules (PL/SQL fundamentals, DML).</p>
        <h4 class="problem-label">Problem</h4>
        <p>Create a robust, nightly archival PL/SQL package, <code>OrderArchiver</code>, that moves orders older than a specified number of days from the main tables to archive tables. The procedure must be dynamic (using the Data Dictionary), performant (using bulk operations), and transactional (using savepoints and a final commit).</p>
        <h5 class="solution-label">Solution</h5>
        <pre><code class="language-sql">
-- The complete setup and solution are provided in the NewSchema.sql
-- and the Package/Package Body definitions below.
-- Package Specification
CREATE OR REPLACE PACKAGE OrderArchiver IS
    PROCEDURE archiveOldOrders(
        p_days_old IN NUMBER DEFAULT 365,
        p_batch_size IN PLS_INTEGER DEFAULT 100
    );
END OrderArchiver;
/
-- Package Body
CREATE OR REPLACE PACKAGE BODY OrderArchiver IS
    PROCEDURE archiveOldOrders(
        p_days_old IN NUMBER DEFAULT 365,
        p_batch_size IN PLS_INTEGER DEFAULT 100
    ) IS
        v_archive_batch_id NUMBER;
        -- Using PL/SQL collection types for bulk processing
        TYPE t_order_id_list IS TABLE OF orders.orderId%TYPE;
        TYPE t_order_list IS TABLE OF orders%ROWTYPE;
        TYPE t_item_list IS TABLE OF orderItems%ROWTYPE;
        l_order_ids t_order_id_list;
        l_orders    t_order_list;
        l_items     t_item_list;
        -- Cursor to find old orders to archive
        CURSOR c_orders_to_archive IS
            SELECT orderId
            FROM orders
            WHERE orderDate < (SYSDATE - p_days_old);
    BEGIN
        -- Get a unique ID for this entire archival run
        v_archive_batch_id := archiveBatchSeq.NEXTVAL;
        DBMS_OUTPUT.PUT_LINE('Starting Archive Batch ID: ' || v_archive_batch_id);
        OPEN c_orders_to_archive;
        LOOP
            -- Fetch a batch of order IDs to process
            FETCH c_orders_to_archive BULK COLLECT INTO l_order_ids LIMIT p_batch_size;
            EXIT WHEN l_order_ids.COUNT = 0;
            FOR i IN 1 .. l_order_ids.COUNT LOOP
                -- Create a savepoint for each individual order.
                -- If this order fails, we can roll back just this one and continue.
                SAVEPOINT before_order_archive;
                BEGIN
                    -- Get the full order and item details
                    SELECT * BULK COLLECT INTO l_orders FROM orders WHERE orderId = l_order_ids(i);
                    SELECT * BULK COLLECT INTO l_items FROM orderItems WHERE orderId = l_order_ids(i);
                    -- Use FORALL for efficient bulk inserts into archive tables
                    FORALL j IN 1 .. l_orders.COUNT
                        INSERT INTO archivedOrders (archiveBatchId, orderId, customerId, orderDate, orderStatus)
                        VALUES (v_archive_batch_id, l_orders(j).orderId, l_orders(j).customerId, l_orders(j).orderDate, l_orders(j).orderStatus);
                    FORALL k IN 1 .. l_items.COUNT
                        INSERT INTO archivedOrderItems (archiveBatchId, orderItemId, orderId, productId, quantity, unitPrice)
                        VALUES (v_archive_batch_id, l_items(k).orderItemId, l_items(k).orderId, l_items(k).productId, l_items(k).quantity, l_items(k).unitPrice);
                    -- Delete from live tables, respecting FK constraints
                    DELETE FROM orderItems WHERE orderId = l_order_ids(i);
                    DELETE FROM orders WHERE orderId = l_order_ids(i);
                EXCEPTION
                    WHEN OTHERS THEN
                        -- If anything went wrong with this specific order, roll back its changes...
                        ROLLBACK TO before_order_archive;
                        -- ...log the error...
                        INSERT INTO archiveErrors (archiveBatchId, failedOrderId, errorMessage)
                        VALUES (v_archive_batch_id, l_order_ids(i), SQLERRM);
                        -- ...and continue with the next order in the batch.
                        DBMS_OUTPUT.PUT_LINE('Error on Order ID: ' || l_order_ids(i) || '. Logged and skipped.');
                END;
            END LOOP; -- end of processing the batch
        END LOOP; -- end of fetching batches
        CLOSE c_orders_to_archive;
        -- Only commit at the very end to make all successful archives permanent
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Archive Batch ID: ' || v_archive_batch_id || ' completed.');
    EXCEPTION
        WHEN OTHERS THEN
            -- A catastrophic failure occurred; roll back the entire run.
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Fatal error. Entire archive batch was rolled back.');
            RAISE; -- Re-raise the exception to the calling environment.
    END archiveOldOrders;
END OrderArchiver;
/
</code></pre>
        <h5>Explanation</h5>
        <p>This solution demonstrates a mastery of the concepts covered:</p>
        <ul>
            <li><strong>Schema Objects:</strong> It creates and interacts with multiple schema objects: tables (<code>archivedOrders</code>), sequences (<code>archiveBatchSeq</code>), and a sophisticated PL/SQL package.</li>
            <li><strong>Data Dictionary:</strong> While not explicitly shown in this simplified version, a more robust solution would query <code>USER_CONSTRAINTS</code> to dynamically determine the parent-child relationship between tables, making the procedure more generic and less prone to breaking if table structures change.</li>
            <li><strong>Transaction Management:</strong> This is the core of the solution. A single, logical transaction (the archival run) is controlled. A final `COMMIT` makes all successful work permanent. `SAVEPOINT` is used to create sub-transaction boundaries around each order, allowing the procedure to gracefully handle and log an error with one order while still successfully processing all others. `ROLLBACK TO SAVEPOINT` is used to undo only the work for the failed order.</li>
            <li><strong>Concurrency Control:</strong> The `DELETE` statements place row-level locks only on the old rows being archived. A separate session can simultaneously `INSERT` a new order because it does not need to access the locked rows, showcasing Oracle's excellent concurrency.</li>
        </ul>
    </div>
    <h2>Key Takeaways & Best Practices</h2>
    <ul>
        <li>
            <strong>Embrace the Data Dictionary:</strong> Get comfortable with <code>USER_OBJECTS</code>, <code>USER_TABLES</code>, <code>USER_TAB_COLUMNS</code>, <code>USER_CONSTRAINTS</code>, and <code>USER_SOURCE</code>. They are your most powerful tools for understanding and managing your database schema programmatically.
        </li>
        <li>
            <strong>Know Your DML vs. DDL:</strong> Understand that <code>TRUNCATE</code> is a DDL operation. It's fast and efficient for clearing tables but cannot be rolled back. Use <code>DELETE</code> when you need row-level granularity or the ability to roll back.
        </li>
        <li>
            <strong>Respect the Transaction:</strong> Oracle's MVCC is world-class. Trust that readers won't block writers. However, be mindful of your own transactions. Always have a clear strategy for `COMMIT` or `ROLLBACK`. Long-running, uncommitted transactions that hold locks are a primary cause of application performance issues.
        </li>
        <li>
            <strong>Leverage Synonyms for Abstraction:</strong> Use synonyms, especially in complex environments with multiple schemas, to simplify code and insulate applications from changes in underlying object names or owners.
        </li>
    </ul>
    <h2>Conclusion & Next Steps</h2>
    <p>
        Congratulations! By working through these exercises and understanding their solutions, you have solidified your grasp of some of the most fundamental and powerful concepts in the Oracle Database. You now have a practical understanding of how to manage schema objects, query the data dictionary, and write robust, transactional code.
    </p>
    <p>
        With this foundation, you are well-prepared to move on to the next module in your journey: <strong>Oracle Performance & Optimization Basics</strong>. There, you will learn how to ensure the powerful code you write also performs with exceptional speed and efficiency.
    </p>
</div>
</body>