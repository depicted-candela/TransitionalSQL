<head>
    <link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/exercises.css">
</head>

<body>
<div class="container">

<h1>Oracle Blueprint: Must-Know Concepts for Consultants</h1>

<h2>Introduction & Learning Objectives</h2>
<p>
    Welcome to the practical exercises for <strong>Essential Oracle Database Concepts</strong>. This module is designed to solidify your understanding of the foundational pillars of the Oracle database architecture. For consultants transitioning from PostgreSQL, these exercises will not only reinforce familiar concepts but also illuminate the unique syntax, tools, and philosophies that define the Oracle environment.
</p>
<p>
    By completing this set of exercises, you will gain hands-on experience and be able to confidently:
</p>
<ul>
    <li>
        Navigate and query the <strong>Oracle Data Dictionary</strong> using <code>USER_</code>, <code>ALL_</code>, and <code>DBA_</code> views to inspect database metadata.
    </li>
    <li>
        Create, manage, and understand the relationships between core <strong>Schema Objects</strong>, including tables, views, sequences, and synonyms.
    </li>
    <li>
        Observe and explain Oracle's <strong>Multi-Version Concurrency Control (MVCC)</strong> and its impact on read consistency and locking behavior.
    </li>
    <li>
        Implement robust <strong>Transaction Management</strong> using <code>COMMIT</code>, <code>ROLLBACK</code>, and <code>SAVEPOINT</code> to ensure data integrity.
    </li>
</ul>

<div class="postgresql-bridge">
    <h5>Bridging from PostgreSQL</h5>
    <p>
        While you are familiar with the <code>information_schema</code>, identity columns, and transactional blocks in PostgreSQL, these exercises will focus on Oracle's counterparts: the powerful Data Dictionary views, the explicit use of <code>SEQUENCE</code> objects, the nuances of row-level locking, and the implementation of transactional control within PL/SQL contexts.
    </p>
</div>

<hr>

<h2>Prerequisites & Dataset Setup</h2>
<p>
    Before you begin, ensure you have a foundational understanding of basic SQL DML (<code>SELECT</code>, <code>INSERT</code>, <code>UPDATE</code>, <code>DELETE</code>) and DDL (<code>CREATE TABLE</code>) from your PostgreSQL experience. This module builds upon those fundamentals within the Oracle 23ai ecosystem.
</p>

<h3>Dataset Guidance</h3>
<p>
    The following script, <code>NewSchema.sql</code>, will create all necessary users, tables, sequences, and procedures for this entire exercise module. It is crucial to run this script in your Oracle environment before proceeding.
</p>
<ol>
    <li>
        Connect to your Oracle database as a user with administrative privileges (for example, <code>SYS</code> as <code>SYSDBA</code>).
    </li>
    <li>
        Execute the entire script below. It will create two users, <code>NewSchema</code> (your primary workspace) and <code>anotherSchema</code> (for cross-schema tests), and populate them with the required objects and data.
    </li>
</ol>
<pre><code class="language-sql">
-- Connect as a privileged user (e.g., SYS as SYSDBA) to run this script.

-- Drop users if they exist, to ensure a clean setup
BEGIN
   EXECUTE IMMEDIATE 'DROP USER NewSchema CASCADE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1918 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP USER anotherSchema CASCADE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1918 THEN
         RAISE;
      END IF;
END;
/

-- Create the primary user for our exercises
CREATE USER NewSchema IDENTIFIED BY Pa_s_sw_rd_1;
ALTER USER NewSchema QUOTA UNLIMITED ON users;
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM, UNLIMITED TABLESPACE TO NewSchema;

-- Create a second user for demonstrating cross-schema concepts
CREATE USER anotherSchema IDENTIFIED BY Pa_s_sw_rd_2;
ALTER USER anotherSchema QUOTA UNLIMITED ON users;
GRANT CONNECT, RESOURCE TO anotherSchema;

-- Grant DBA privileges to NewSchema to query DBA views and manage transactions.
-- In a real-world scenario, you would grant more granular privileges.
GRANT DBA TO NewSchema;

-- Connect as the NewSchema user to create the objects
CONNECT NewSchema/Pa_s_sw_rd_1;

-- Sequences for Primary Keys
CREATE SEQUENCE productSeq START WITH 100 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE warehouseSeq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE inventoryLogSeq START WITH 1 INCREMENT BY 1 NOCACHE;

-- Tables
CREATE TABLE products (
    productId          NUMBER(10) PRIMARY KEY,
    productName        VARCHAR2(100) NOT NULL,
    description        VARCHAR2(500),
    category           VARCHAR2(50),
    unitPrice          NUMBER(8, 2) CHECK (unitPrice > 0)
);

CREATE TABLE warehouses (
    warehouseId        NUMBER(5) PRIMARY KEY,
    warehouseName      VARCHAR2(100) UNIQUE NOT NULL,
    location           VARCHAR2(200)
);

-- This table is central for concurrency and transaction exercises
CREATE TABLE inventory (
    warehouseId        NUMBER(5) NOT NULL,
    productId          NUMBER(10) NOT NULL,
    quantityOnHand     NUMBER(8) DEFAULT 0 NOT NULL,
    lastUpdated        TIMESTAMP WITH LOCAL TIME ZONE DEFAULT SYSTIMESTAMP,
    CONSTRAINT pkInventory PRIMARY KEY (warehouseId, productId),
    CONSTRAINT fkInvWarehouse FOREIGN KEY (warehouseId) REFERENCES warehouses(warehouseId),
    CONSTRAINT fkInvProduct FOREIGN KEY (productId) REFERENCES products(productId)
);

CREATE TABLE inventoryLog (
    logId              NUMBER PRIMARY KEY,
    productId          NUMBER(10),
    changeType         VARCHAR2(20),
    quantityChange     NUMBER(8),
    logTimestamp       DATE
);

-- Populate with data
INSERT INTO warehouses (warehouseId, warehouseName, location) VALUES (warehouseSeq.NEXTVAL, 'Main Warehouse', 'New York');
INSERT INTO warehouses (warehouseId, warehouseName, location) VALUES (warehouseSeq.NEXTVAL, 'West Coast Depot', 'Los Angeles');

INSERT INTO products (productId, productName, description, category, unitPrice) VALUES (productSeq.NEXTVAL, 'Oracle DB License', '1-year enterprise license', 'Software', 4500.00);
INSERT INTO products (productId, productName, description, category, unitPrice) VALUES (productSeq.NEXTVAL, 'PL/SQL Stored Procedure Guide', 'Advanced PL/SQL programming book', 'Books', 75.50);
INSERT INTO products (productId, productName, description, category, unitPrice) VALUES (productSeq.NEXTVAL, 'High-Performance Keyboard', 'Mechanical keyboard for developers', 'Hardware', 150.00);

INSERT INTO inventory (warehouseId, productId, quantityOnHand) VALUES (1, 100, 50);
INSERT INTO inventory (warehouseId, productId, quantityOnHand) VALUES (1, 101, 200);
INSERT INTO inventory (warehouseId, productId, quantityOnHand) VALUES (2, 102, 150);

-- Create objects in the second schema for synonym/privilege examples
CONNECT anotherSchema/Pa_s_sw_rd_2;

CREATE TABLE confidentialData (
    dataId             NUMBER PRIMARY KEY,
    secretInfo         VARCHAR2(100)
);

INSERT INTO confidentialData (dataId, secretInfo) VALUES (1, 'Project Phoenix Details');

GRANT SELECT ON confidentialData TO NewSchema;

-- Switch back to the main user
CONNECT NewSchema/Pa_s_sw_rd_1;

COMMIT;

-- Create a procedure for a Data Dictionary example
CREATE OR REPLACE PROCEDURE getProductCount(p_category IN VARCHAR2, p_count OUT NUMBER) IS
BEGIN
    SELECT COUNT(*)
    INTO p_count
    FROM products
    WHERE category = p_category;
END;
/
</code></pre>
<hr>

<h2>Exercises</h2>
<p>This section is divided into four types of exercises, each designed to test a different aspect of your understanding. Please attempt to solve each problem before reviewing the provided solutions.</p>

<h3>Type (i): Meanings, Values, Relations, and Advantages</h3>
<p>These exercises focus on exploring the "what" and "why" of Oracle's schema objects and metadata views, emphasizing the syntax and advantages, especially when compared to a PostgreSQL background.</p>

<div class="exercise">
  <h4>Exercise 1: Exploring Your Schema with the Data Dictionary</h4>
  <p class="problem-label">Problem:</p>
  <p>You have just created several objects in your <code>NewSchema</code> schema. Your task is to use Oracle's Data Dictionary views to answer the following questions. For deeper understanding of the Data Dictionary, consult the <a href="../books/database-concepts/ch09_data-dictionary-dynamic-performance-views.pdf">Oracle® Database Concepts guide on Data Dictionary and Dynamic Performance Views</a>.</p>
  <ol>
    <li>List all objects (and their types) that you own in your current schema.</li>
    <li>Find the names and data types of all columns in the <code>inventory</code> table.</li>
    <li>Display the source code for the <code>getProductCount</code> procedure.</li>
    <li>List all constraints on the <code>inventory</code> table.</li>
  </ol>
  <div class="postgresql-bridge">
    <p><strong>Bridging from PostgreSQL:</strong> In PostgreSQL, you would query the <code>information_schema</code> views (like <code>information_schema.tables</code>, <code>information_schema.columns</code>) or use psql's backslash commands (<code>\d</code>, <code>\dt</code>, <code>\df</code>). This exercise practices the Oracle way of retrieving this metadata using its powerful set of <code>USER_*</code>, <code>ALL_*</code>, and <code>DBA_*</code> views.</p>
  </div>
</div>

<div class="exercise">
  <h4>Exercise 2: Creating and Using Core Schema Objects</h4>
  <p class="problem-label">Problem:</p>
  <p>Create a simple <code>employees</code> table to track who manages which warehouse. Refer to the <a href="../books/get-started-oracle-database-development/get-started-guide_ch04_creating-managing-schema-objects.pdf">Get Started Guide on Creating and Managing Schema Objects</a> for practical examples.</p>
  <ol>
    <li>Create a sequence named <code>employeeSeq</code> to generate unique employee IDs.</li>
    <li>Create a table named <code>employees</code> with columns for <code>employeeId</code> (PK), <code>employeeName</code>, and <code>managesWarehouseId</code> (FK to <code>warehouses</code>).</li>
    <li>Insert two employees, using the <code>employeeSeq</code> sequence for their IDs.</li>
    <li>Create a view named <code>warehouseManagers</code> that shows the employee name and the name of the warehouse they manage.</li>
    <li>As <code>anotherSchema</code>, you need frequent access to <code>NewSchema.products</code>. Create a private synonym named <code>prodList</code> in <code>anotherSchema</code>'s schema that points to <code>NewSchema.products</code>. Then, query your synonym.</li>
  </ol>
  <div class="postgresql-bridge">
    <p><strong>Bridging from PostgreSQL:</strong> This exercise contrasts Oracle's explicit <code>CREATE SEQUENCE</code> and <code>.NEXTVAL</code> usage with PostgreSQL's <code>SERIAL</code> or <code>IDENTITY</code> column types. It also introduces the concept of synonyms, which provide a powerful layer of abstraction not commonly used in PostgreSQL.</p>
  </div>
</div>

<div class="exercise">
  <h4>Exercise 3: Understanding Oracle's Concurrency (MVCC) and Transaction Control</h4>
  <p class="problem-label">Problem:</p>
  <p>This exercise demonstrates Oracle's Multi-Version Concurrency Control (MVCC) and transaction lifecycle. You will need two separate database connections/sessions (for example, two SQL Developer worksheets) connected as <code>NewSchema</code>. For detailed concepts, review the <a href="../books/database-concepts/ch12_data-concurrency-and-consistency.pdf">Data Concurrency and Consistency</a> and <a href="../books/database-concepts/ch13_transactions.pdf">Transactions</a> chapters from the Oracle Concepts guide.</p>
  <ol>
    <li><strong>In Session 1:</strong> Start a transaction by reducing the quantity of 'PL/SQL Stored Procedure Guide' (productId 101) by 10. <strong>Do not commit.</strong></li>
    <li><strong>In Session 1:</strong> Query the <code>inventory</code> table to see the new quantity. You should see the updated value.</li>
    <li><strong>In Session 2:</strong> While Session 1's transaction is still open, query the <code>inventory</code> table for the same product. What quantity do you see and why?</li>
    <li><strong>In Session 1:</strong> Create a <code>SAVEPOINT</code> named <code>before_price_update</code>.</li>
    <li><strong>In Session 1:</strong> Now, update the <code>unitPrice</code> of the same product to 80.00.</li>
    <li><strong>In Session 1:</strong> Realize the price update was a mistake and <code>ROLLBACK</code> to the <code>before_price_update</code> savepoint. Query the <code>inventory</code> and <code>products</code> tables. What are the current values?</li>
    <li><strong>In Session 1:</strong> <code>COMMIT</code> the transaction.</li>
    <li><strong>In Session 2:</strong> Query the <code>inventory</code> table again. What quantity do you see now and why?</li>
  </ol>
</div>

<h3>Type (ii): Disadvantages and Pitfalls</h3>
<p>These exercises highlight potential issues and limitations to be aware of when working with these concepts in Oracle.</p>

<div class="exercise">
    <h4>Exercise 1: The Danger of Cascading Drops</h4>
    <p class="problem-label">Problem:</p>
    <p>You've created the <code>anotherSchema</code> user who owns the <code>confidentialData</code> table. What is the potential pitfall of dropping this user using the <code>CASCADE</code> option? Write the SQL to demonstrate this and verify the outcome.</p>
    <div class="caution">
        <p><strong>Caution:</strong> This is a destructive operation. The purpose is to understand the risk. The provided setup script can be used to recreate the user and their objects afterward.</p>
    </div>
</div>

<div class="exercise">
    <h4>Exercise 2: The Blocked Update (Row-Level Locking)</h4>
    <p class="problem-label">Problem:</p>
    <p>This exercise demonstrates a common pitfall for new developers: a "hanging" application due to a lock. For a deeper understanding, refer to the <a href="../books/database-concepts/ch12_data-concurrency-and-consistency.pdf">Oracle Concepts guide on Locking Mechanisms</a>.</p>
    <ol>
        <li><strong>In Session 1:</strong> Start a transaction by updating the <code>quantityOnHand</code> for product 100 in warehouse 1 to 45. <strong>Do not commit.</strong></li>
        <li><strong>In Session 2:</strong> Immediately try to update the <code>quantityOnHand</code> for the <strong>exact same product in the same warehouse</strong> to 40.</li>
        <li>Describe what happens in Session 2. Why does this occur?</li>
        <li>What happens in Session 2 after you issue a <code>ROLLBACK</code> in Session 1?</li>
    </ol>
</div>

<h3>Type (iii): Contrasting with Inefficient Common Solutions</h3>
<p>These exercises contrast a common but less efficient approach with the idiomatic, high-performance Oracle way.</p>

<div class="exercise">
    <h4>Exercise 1: Mass Deletion - <code>DELETE</code> vs. <code>TRUNCATE</code></h4>
    <p class="problem-label">Problem:</p>
    <p>
        Imagine the <code>inventoryLog</code> table has grown to millions of rows, and you need to purge all of them as part of a monthly maintenance job.
    </p>
    <ol>
        <li>Write the "common" SQL statement to remove all rows from a table, which is functionally correct but inefficient for this task.</li>
        <li>Write the more efficient, Oracle-idiomatic statement for this task.</li>
        <li>Explain the key differences in how Oracle processes these two statements and why the second is vastly more performant for this specific use case (clearing an entire table). Your explanation should cover DML vs. DDL, UNDO/REDO generation, triggers, and storage reclamation (High Water Mark).
        <small>Reference: See the <a href="../books/database-administrators-guide/ch01_17-managing-schema-objects.pdf">"Truncating Tables and Clusters"</a> section in the DBA Guide.</small>
        </li>
    </ol>
</div>

<h3>Type (iv): Hardcore Combined Problem</h3>
<p>This exercise integrates concepts from this module and assumes knowledge of basic DDL/DML. It is designed to be challenging and to test your ability to synthesize information.</p>

<div class="exercise">
    <h4>Exercise: The Robust Archival Process</h4>
    <p class="problem-label">Problem:</p>
    <p>You are tasked with creating a nightly archival process for a new e-commerce platform. The core tables are <code>orders</code> and <code>orderItems</code>. The business rule is that any order completed more than 365 days ago, along with its associated line items, should be moved to archive tables. The process must be robust, performant, and transactional.</p>
    <p><strong>Your Task:</strong> Create a PL/SQL package named <code>OrderArchiver</code> that contains a single procedure, <code>archiveOldOrders</code>.</p>
    <h5>Requirements:</h5>
    <ul>
        <li>
            <strong>Metadata-Driven:</strong> The procedure should not have hardcoded table names for the child table. Instead, it should be designed to work on a base table (for example, `orders`) and find its child table (`orderItems`) by querying the Data Dictionary views.
            <small>Hint: Use <code>USER_CONSTRAINTS</code> to find foreign key relationships.</small>
        </li>
        <li>
            <strong>Schema Objects:</strong> Create the necessary archive tables (<code>archivedOrders</code>, <code>archivedOrderItems</code>) and a sequence (<code>archiveBatchSeq</code>) to generate a unique ID for each archival run.
        </li>
        <li>
            <strong>Transaction Management:</strong> The entire archival run for all old orders must be a single, logical transaction. However, you must implement a mechanism using <code>SAVEPOINT</code> so that if an error occurs while processing a single order (and its line items), only the changes for that specific order are rolled back. The procedure should then log the error to a separate <code>archiveErrors</code> table and continue processing the next order. The entire batch of successful archival operations should be made permanent with a final <code>COMMIT</code> at the very end.
            <small>Reference: Consult the <a href="../books/get-started-oracle-database-development/get-started-guide_ch03_dml-statements-transactions.pdf">DML and Transactions</a> chapter in the Get Started guide.</small>
        </li>
        <li>
            <strong>Concurrency Test (Conceptual):</strong> While your archival procedure is running, it should only lock the *specific old rows* it is processing. Explain how you would test that a separate session can still <code>INSERT</code> a brand-new order into the <code>orders</code> and <code>orderItems</code> tables without being blocked.
        </li>
    </ul>
</div>

<hr>

<h2>Tips for Success & Learning</h2>
<ul>
    <li>
        <strong>Experiment:</strong> After solving a problem, try variations. What happens if you change a data type? What if a constraint is disabled? This experimentation builds deeper understanding.
    </li>
    <li>
        <strong>Consult the Docs:</strong> Use the linked PDF chapters as your primary reference. The official Oracle documentation is the ultimate source of truth. The goal is to learn how to find answers efficiently.
    </li>
    <li>
        <strong>Understand the "Why":</strong> Don't just find a working solution. Make sure you can explain *why* it works and why an alternative might be less efficient or incorrect. This is a key skill for a consultant.
    </li>
    <li>
        <strong>Use Two Sessions:</strong> For the concurrency and locking exercises, having two separate sessions (like two worksheet tabs in SQL Developer) is essential to see the concepts in action.
    </li>
</ul>

<h2>Conclusion & Next Steps</h2>
<p>
    Mastering these foundational concepts—how the database describes itself, how its objects relate, and how it ensures data integrity through transactions and concurrency control—is non-negotiable for any Oracle professional. You have now practiced the core principles that underpin almost every interaction with an Oracle database.
</p>
<p>
    With this foundation, you are now prepared to explore the next essential area for a consultant: **Oracle Performance & Optimization Basics**.
</p>

</div>
</body>