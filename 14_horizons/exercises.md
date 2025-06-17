<head>
<link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/exercises.css">
</head>
<body>

<div class="container">
<h1>Oracle Horizons: Connecting with Cutting-Edge Tech</h1>

<p>
Welcome to a practical exploration of Oracle's powerful interfacing technologies. This module bridges the gap between the database and the application layer, a critical skill for any database developer or consultant. Here, you'll move beyond pure SQL and PL/SQL to see how the database connects with the outside world using industry-standard and Oracle-specific methods. We'll focus on Java connectivity, XML processing, and enterprise messaging, all enhanced with the latest features from Oracle Database 23ai.
</p>
</div>

<div class="container">
<h2>Learning Objectives</h2>
<p>
Upon completing these exercises, you will have solidified your understanding of Oracle's interfacing capabilities and will be able to effectively:
</p>
<ul>
    <li>
        <strong>Master Java Connectivity</strong>: Implement robust and performant database connections from Java applications using the Oracle JDBC driver and understand the value and configuration of Oracle's Universal Connection Pool (UCP).
    </li>
    <li>
        <strong>Bridge from PostgreSQL Experience</strong>: Differentiate between PostgreSQL's external pooling (like <code>PgBouncer</code>) and Oracle's integrated solutions like Database Resident Connection Pooling (DRCP), appreciating the architectural advantages of the latter.
    </li>
    <li>
        <strong>Leverage Native XML Processing</strong>: Store, query, and manipulate XML data efficiently using the native <code>XMLTYPE</code> and the powerful SQL/XML standard functions like <code>XMLTABLE</code>, a significant step up from treating XML as plain text in a <code>CLOB</code>.
    </li>
    <li>
        <strong>Implement Asynchronous Operations</strong>: Build highly scalable applications by applying Oracle 23ai's new JDBC Pipelining for asynchronous database calls and by using Oracle Advanced Queuing (AQ) as a powerful, transactional JMS messaging provider.
    </li>
    <li>
        <strong>Utilize 23ai Cutting-Edge Features</strong>: Apply and explain the advantages of new 23ai features, including Multi-Pool DRCP for resource management, database driver pipelining for performance, multicloud configuration for flexibility, and OpenTelemetry support for end-to-end system observability.
    </li>
</ul>
</div>

<div class="container">
<h2>Prerequisites & Setup</h2>
<p>
Before you begin, ensure you have a solid grasp of the concepts from the preceding modules in this course. Your knowledge of PostgreSQL will be a valuable foundation, but these exercises specifically test Oracle's unique implementations.
</p>

<h3>Essential Prior Knowledge</h3>
<ul>
    <li>
        <p><strong>Core Oracle SQL</strong>: All concepts from <strong>Study Chunks 1-4</strong>, especially <a href="../3_advancedQueryingTechniques/1_hierarchicalQueries.sql">Hierarchical Queries</a>.</p>
    </li>
    <li>
        <p><strong>PL/SQL Mastery</strong>: A firm understanding of PL/SQL blocks, procedures, packages, and exception handling from <strong>Study Chunks 5-8</strong> is required for the hardcore problem.</p>
    </li>
    <li>
        <p><strong>Complex Data Types</strong>: Familiarity with Oracle's handling of <code>XMLTYPE</code> from <strong>Study Chunk 4</strong> is necessary.</p>
    </li>
</ul>

<h3>Dataset Setup</h3>
<p>
These exercises use a unified dataset designed for the <code>horizons</code> schema. This script defines the necessary tables, object types, and Advanced Queuing (AQ) components.
</p>

<ol>
    <li>
        <p>Ensure you are connected to your Oracle Database 23ai instance as the <code>horizons</code> user.</p>
    </li>
    <li>
        <p>Execute the entire script below in a tool like SQL Developer or SQL*Plus. The script is idempotent, meaning it will safely clean up and recreate objects if run multiple times.</p>
    </li>
</ol>

<div class="oracle-specific">
<p><strong>Setup Script: <code>horizons_connectivity_setup.sql</code></strong></p>
<p>This script establishes the <code>productCatalog</code> (hierarchical), <code>customerOrders</code>, and <code>orderDetails</code> (using <code>XMLTYPE</code>) tables. It also configures the <code>PartRequestType</code> object and the corresponding Oracle Advanced Queue (<code>partRequestTopic</code>) that we will use as a JMS Topic.</p>
</div>

<pre><code>
-- DDL and DML for the 'horizons' user schema.
-- This script is idempotent and can be run multiple times.

-- Clean up existing objects to ensure a clean slate
BEGIN
   FOR r IN (SELECT object_name, object_type FROM user_objects WHERE object_type IN ('TABLE', 'PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TYPE', 'QUEUE', 'QUEUE TABLE', 'SEQUENCE')) LOOP
      BEGIN
         -- Using IF EXISTS for robust cleanup (Oracle 23ai feature)
         EXECUTE IMMEDIATE 'DROP ' || r.object_type || ' IF EXISTS "' || r.object_name || '"' ||
                           CASE WHEN r.object_type = 'TABLE' THEN ' PURGE' ELSE '' END;
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not drop ' || r.object_type || ' ' || r.object_name);
      END;
   END LOOP;
END;
/

-- TYPES
-- An object type for our messaging queue payload, required for Oracle AQ/JMS
CREATE OR REPLACE TYPE horizons.PartRequestType AS OBJECT (
  orderId         NUMBER(10),
  partId          NUMBER(10),
  quantity        NUMBER(5),
  requestTimestamp TIMESTAMP WITH TIME ZONE
);
/

-- TABLE DEFINITIONS
-- Hierarchical product catalog using modern DDL features
CREATE TABLE horizons.productCatalog (
  partId          NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  partName        VARCHAR2(100) NOT NULL,
  parentPartId    NUMBER REFERENCES horizons.productCatalog(partId),
  isReservable    BOOLEAN DEFAULT TRUE NOT NULL -- New 23ai BOOLEAN type
) ANNOTATIONS (DisplayName 'Master Product Hierarchy', Version '1.1');
COMMENT ON TABLE horizons.productCatalog IS 'Hierarchical bill of materials for all products.';

-- Main order table
CREATE TABLE horizons.customerOrders (
  orderId         NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  orderDate       DATE DEFAULT SYSDATE,
  customerName    VARCHAR2(100),
  orderStatus     VARCHAR2(20) DEFAULT 'PENDING'
);

-- Order details stored efficiently as native XMLTYPE, required for XML processing exercises
CREATE TABLE horizons.orderDetails (
  orderId         NUMBER PRIMARY KEY REFERENCES horizons.customerOrders(orderId),
  detailXML       XMLTYPE
);

-- Configuration table for multicloud feature exercise
CREATE TABLE horizons.appConfiguration (
    configKey       VARCHAR2(100) PRIMARY KEY,
    configValue     VARCHAR2(500)
);
COMMENT ON TABLE horizons.appConfiguration IS 'Stores config data, potentially sourced from Azure or OCI';

-- ADVANCED QUEUING (AQ) SETUP for JMS exercises
-- 1. Create a queue table to hold the messages
BEGIN
  DBMS_AQADM.CREATE_QUEUE_TABLE(
    queue_table        => 'horizons.partRequestQueueTable',
    queue_payload_type => 'horizons.PartRequestType',
    multiple_consumers => TRUE, -- Important for topic-like behavior in JMS
    comment            => 'Queue table for component reservation requests'
  );
END;
/

-- 2. Create the actual queue (will be treated as a JMS Topic)
BEGIN
  DBMS_AQADM.CREATE_QUEUE(
    queue_name  => 'horizons.partRequestTopic',
    queue_table => 'horizons.partRequestQueueTable'
  );
END;
/

-- 3. Start the queue for enqueue and dequeue operations
BEGIN
  DBMS_AQADM.START_QUEUE(queue_name => 'horizons.partRequestTopic', enqueue => TRUE, dequeue => TRUE);
END;
/

-- DATA POPULATION
INSERT INTO horizons.productCatalog (partId, partName, parentPartId) VALUES (1, 'Gaming PC', NULL);
INSERT INTO horizons.productCatalog (partId, partName, parentPartId) VALUES (10, 'Motherboard Assembly', 1);
INSERT INTO horizons.productCatalog (partId, partName, parentPartId) VALUES (20, 'CPU', 10);
INSERT INTO horizons.productCatalog (partId, partName, parentPartId) VALUES (30, 'RAM 32GB Kit', 10);
INSERT INTO horizons.productCatalog (partId, partName, parentPartId) VALUES (40, 'GPU', 1);

INSERT INTO horizons.customerOrders (customerName) VALUES ('Alice');
INSERT INTO horizons.orderDetails (orderId, detailXML) VALUES (
  (SELECT orderId FROM customerOrders WHERE customerName = 'Alice'),
  XMLTYPE('&lt;order anbr="ORD201"&gt;
             &lt;items&gt;
               &lt;item partNumber="20" quantity="1"/&gt;
               &lt;item partNumber="30" quantity="2"/&gt;
             &lt;/items&gt;
           &lt;/order&gt;')
);

INSERT INTO horizons.customerOrders (customerName) VALUES ('Bob');
INSERT INTO horizons.orderDetails (orderId, detailXML) VALUES (
  (SELECT orderId FROM customerOrders WHERE customerName = 'Bob'),
  XMLTYPE('&lt;order anbr="ORD202"&gt;
             &lt;items&gt;
               &lt;item partNumber="40" quantity="1"/&gt;
             &lt;/items&gt;
           &lt;/order&gt;')
);

INSERT INTO horizons.appConfiguration (configKey, configValue) VALUES ('azure.config.connectionstring', 'Endpoint=https://myapp.azconfig.io;Id=xxxx;Secret=xxxx');
INSERT INTO horizons.appConfiguration (configKey, configValue) VALUES ('oci.objectstorage.bucket.uri', 'oci://my-bucket@my-tenancy/config/app.json');

COMMIT;

-- Grant necessary privileges for subsequent exercises
GRANT EXECUTE ON horizons.PartRequestType TO PUBLIC;
BEGIN
  DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'horizons.partRequestTopic', 'PUBLIC');
  DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'horizons.partRequestTopic', 'PUBLIC');
END;
/
</code></pre>
</div>

<div class="container">
<h2>Practical Exercises</h2>

<h3>Exercise I: Meanings, Values, Relations, and Advantages</h3>

<h4>Exercise 1.1: JDBC, UCP, and New Connection Management</h4>
<p class="problem-label">Problem</p>
<p>
A Java development team is building a high-throughput order processing service against the <code>horizons</code> schema.
</p>
<ol>
  <li>
      <p><strong>Meaning &amp; Value</strong>: Explain the meaning of "connection pooling" and its primary value for an application. Provide a simple Java code example showing how to obtain a connection from Oracle's Universal Connection Pool (UCP).</p>
  </li>
  <li>
      <p><strong>Relational (PostgreSQL Bridge)</strong>: PostgreSQL deployments often use PgBouncer for server-side connection pooling. Oracle offers Database Resident Connection Pooling (DRCP). Explain the core architectural difference and the value of Oracle's new <strong>Multi-Pool DRCP</strong> feature.</p>
  </li>
  <li>
      <p><strong>Advantage (23ai Feature)</strong>: The team has heard about Oracle 23ai's <strong>Implicit Connection Pooling</strong>. Explain how this feature simplifies the developer's code compared to the explicit UCP setup shown in part 1.</p>
  </li>
</ol>


<h4>Exercise 1.2: The Value of Oracle <code>XMLTYPE</code></h4>
<p class="problem-label">Problem</p>
<p>Using the <code>horizons.orderDetails</code> table:</p>
<ol>
  <li>
      <p><strong>Meaning</strong>: What is the fundamental difference between storing order details in a <code>CLOB</code> versus the <code>XMLTYPE</code> data type?</p>
  </li>
  <li>
      <p><strong>Value &amp; Syntax</strong>: Write an Oracle SQL query using <code>XMLTABLE</code> to shred the XML data from the order with <code>anbr</code> attribute 'ORD201', returning a relational rowset with columns <code>partNumber</code> and <code>quantity</code>.</p>
  </li>
  <li>
      <p><strong>Advantage</strong>: Contrast the query from part 2 with how you would parse this data if it were stored in a <code>CLOB</code>. Why is the <code>XMLTYPE</code> approach superior for querying and data manipulation?</p>
  </li>
</ol>


<h4>Exercise 1.3: Asynchronous Pipelining vs. Standard Batching</h4>
<p class="problem-label">Problem</p>
<p>A Java application needs to run three independent DML statements against the <code>horizons</code> schema in the most efficient manner possible to reduce application-side blocking.</p>
<ol>
  <li>
      <p><strong>Relational</strong>: How does Oracle's 23ai JDBC Pipelining feature differ fundamentally from standard JDBC batching (<code>addBatch</code>/<code>executeBatch</code>)?</p>
  </li>
  <li>
      <p><strong>Value (Code Snippet)</strong>: Write a conceptual Java snippet using the 23ai JDBC API to pipeline three independent <code>UPDATE</code> statements on the <code>productCatalog</code> table.</p>
  </li>
  <li>
      <p><strong>Advantage</strong>: What is the primary advantage of using pipelining for application throughput and scalability?</p>
  </li>
</ol>


<h4>Exercise 1.4: Oracle AQ/JMS and OpenTelemetry Observability</h4>
<p class="problem-label">Problem</p>
<p>Consider a workflow where a PL/SQL procedure enqueues a message to <code>horizons.partRequestTopic</code>, which is then dequeued and processed by a Java application.</p>
<ol>
  <li>
      <p><strong>Meaning (JMS Bridge)</strong>: Explain how Oracle Advanced Queuing (AQ) can function as a Java Message Service (JMS) provider. What is the relationship between an AQ queue table and a JMS Topic/Queue?</p>
  </li>
  <li>
      <p><strong>Value (23ai Feature)</strong>: Explain the concept of <strong>OpenTelemetry Trace Context Propagation</strong> and how Oracle 23ai supports it automatically through AQ.</p>
  </li>
  <li>
      <p><strong>Advantage</strong>: What is the main benefit of having this end-to-end trace context for a developer or SRE debugging a performance issue in this distributed system?</p>
  </li>
</ol>


<h3>Exercise II: Disadvantages and Pitfalls</h3>

<h4>Exercise 2.1: The Pitfall of Inefficient XML Querying</h4>
<p class="problem-label">Problem</p>
<p>
A developer needs to find the quantity for <code>partNumber</code> "40" for the order with <code>anbr</code> 'ORD202' from the <code>orderDetails</code> table. They write the following query, which works but is suboptimal because the <code>EXTRACTVALUE</code> function is deprecated.
</p>
<pre><code>-- Inefficient and Deprecated Query
SELECT EXTRACTVALUE(od.detailXML, '/order/items/item/@quantity') AS quantity
FROM horizons.orderDetails od
WHERE EXTRACTVALUE(od.detailXML, '/order/items/item/@partNumber') = '40'
  AND EXTRACTVALUE(od.detailXML, '/order/@anbr') = 'ORD202';
</code></pre>
<p>What is the primary performance pitfall of using this function-per-value approach, especially on documents with many attributes and nodes, compared to the modern SQL/XML standard functions?</p>


<h3>Exercise III: Contrasting with Inefficient Common Solutions</h3>

<h4>Exercise 3.1: The "DIY Queue" vs. Oracle AQ</h4>
<p class="problem-label">Problem</p>
<p>
A developer needs an asynchronous job queue. Instead of using Oracle AQ, they create a simple table: <code>jobQueue(jobId NUMBER, payload VARCHAR2(100), status VARCHAR2(10))</code>. The application <code>INSERT</code>s jobs with <code>status = 'NEW'</code>. A background process polls this table every 5 seconds with <code>SELECT ... FROM jobQueue WHERE status = 'NEW' FOR UPDATE SKIP LOCKED</code>.
</p>
<p>
Contrast this polling-based approach with using Oracle AQ (<code>DBMS_AQ.DEQUEUE</code>). Explain two significant advantages that AQ provides over this "Do-It-Yourself" table-based queue, demonstrating the loss of value from not using the Oracle-idiomatic feature.
</p>


<h3>Exercise IV: Hardcore Combined Problem</h3>
<h4>The Challenge: End-to-End Observable Asynchronous Order Fulfillment</h4>
<p class="problem-label">Problem</p>
<p>
The Horizons manufacturing system needs a fully observable, end-to-end, asynchronous process for component reservations when a new 'Gaming PC' order is placed. The system must be resilient and performant.
</p>
<h5>The Workflow:</h5>
<ol>
  <li>A new order for a 'Gaming PC' is inserted into the <code>customerOrders</code> and <code>orderDetails</code> tables.</li>
  <li>A PL/SQL procedure must be invoked to parse the order's <code>detailXML</code>. For each base component (leaf node) in the product hierarchy, it must enqueue a reservation request to the <code>horizons.partRequestTopic</code>.</li>
  <li>A multi-threaded Java service using UCP must listen to this topic.</li>
  <li>The Java service must use JDBC Pipelining to send all required inventory <code>UPDATE</code> DMLs for a given order to the database in a single, efficient batch.</li>
  <li>The entire distributed flow, from the initial web request that calls the PL/SQL procedure to the final database commits by the Java service, must be traceable using a single trace ID via OpenTelemetry.</li>
</ol>
<h5>Tasks:</h5>
<ol>
  <li>
      <p><strong>PL/SQL Package</strong>: Create a PL/SQL package <code>horizons.orderFulfillment</code> with a procedure <code>processNewOrder(p_orderId IN NUMBER)</code>. This procedure must:</p>
      <ul>
          <li>Use <code>XMLTABLE</code> to parse the <code>orderDetails.detailXML</code>.</li>
          <li>For each part number found, use a hierarchical query (<code>CONNECT BY ... ISLEAF</code>) to find all its base components in <code>productCatalog</code>.</li>
          <li>For each base component, enqueue a message of type <code>PartRequestType</code> to the <code>horizons.partRequestTopic</code>. The entire procedure must run within a single transaction.</li>
      </ul>
  </li>
  <li>
      <p><strong>Java Processor (Conceptual Code)</strong>: Write the core logic for a Java consumer method. It should:</p>
      <ul>
          <li>Receive a message from the JMS topic.</li>
          <li>For the order, create a list of all required <code>UPDATE</code> statements for an assumed <code>inventory</code> table.</li>
          <li>Use the 23ai JDBC Pipelining API (<code>executeUpdateAsyncOracle</code>) to send all <code>UPDATE</code>s asynchronously within a single transaction.</li>
      </ul>
  </li>
  <li>
      <p><strong>Observability Explanation</strong>: Explain how the OpenTelemetry <code>trace_id</code> propagates through this entire system, from the initial JDBC call to the PL/SQL package, into the AQ message, and finally into the Java consumer. What is the key Oracle 23ai feature that makes this seamless?</p>
  </li>
</ol>

</div>

<div class="container">
<h2>Tips for Success</h2>
<ul>
    <li>
        <strong>Practice Makes Permanent</strong>: Don't just copy and paste the code. Type it out yourself to build muscle memory with Oracle's syntax and APIs.
    </li>
    <li>
        <strong>Consult the Source</strong>: The exercises include direct links to the official Oracle 23ai documentation. When you're unsure why something works, read the referenced chapter. It's the ultimate source of truth.
    </li>
    <li>
        <strong>Experiment and Extend</strong>: After solving a problem, try to modify it. What happens if the XML structure changes? How would you handle a different kind of JMS message? Experimentation is key to deep learning.
    </li>
    <li>
        <strong>Embrace the Oracle Way</strong>: Pay close attention to the exercises that contrast with common or PostgreSQL-specific solutions. Understanding *why* the Oracle-idiomatic approach is better is a crucial step in your transition.
    </li>
</ul>
<div class="rhyme">
To master tech that connects and serves,<br>
Practice the patterns your knowledge deserves.
</div>
</div>

<div class="container">
<h2>Conclusion & Next Steps</h2>
<p>
Congratulations on engaging with these critical interfacing concepts. You have now practiced how to make your Oracle database a powerful, performant, and observable hub for modern applications. You've seen how to connect with Java, process complex data with native XML tools, and build asynchronous workflows with enterprise-grade messaging.
</p>
<p>
With this foundation, you are well-prepared to tackle the next and final technical module in your journey:
</p>
<div class="postgresql-bridge">
    <p><strong>Next Up</strong>: <strong>Study Chunk 15: Future of Oracle: SQL Innovations in 23ai</strong></p>
    <p>Prepare to explore the most modern SQL features that Oracle 23ai has to offer, further enhancing your ability to write clean, powerful, and efficient database code.</p>
</div>
</div>
</body>