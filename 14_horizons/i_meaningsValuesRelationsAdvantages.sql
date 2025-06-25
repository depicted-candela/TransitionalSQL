-- Oracle Horizons: Connecting with Cutting-Edge Tech


--  Exercise I: Meanings, Values, Relations, and Advantages


--      Exercise 1.1: JDBC, UCP, and New Connection Management
-- Problem
-- A Java development team is building a high-throughput order processing service against the horizons schema.
-- Meaning & Value: Explain the meaning of "connection pooling" and its primary value for an application. Provide a simple Java code example showing how to obtain a 
-- connection from Oracle's Universal Connection Pool (UCP).
-- Answer: The connection pool enables the application to be connected immediately to the database with credentials of specific users or roles 
-- Relational (PostgreSQL Bridge): PostgreSQL deployments often use PgBouncer for server-side connection pooling. Oracle offers Database Resident Connection Pooling 
-- (DRCP). Explain the core architectural difference and the value of Oracle's new Multi-Pool DRCP feature.
-- Advantage (23ai Feature): The team has heard about Oracle 23ai's Implicit Connection Pooling. Explain how this feature simplifies the developer's code compared to 
-- the explicit UCP setup shown in part 1.

--      Exercise 1.2: The Value of Oracle XMLTYPE
-- Problem
-- Using the horizons.orderDetails table:
-- Meaning: What is the fundamental difference between storing order details in a CLOB versus the XMLTYPE data type?
-- Value & Syntax: Write an Oracle SQL query using XMLTABLE to shred the XML data from the order with anbr attribute 'ORD201', returning a relational rowset with 
-- columns partNumber and quantity.
-- Advantage: Contrast the query from part 2 with how you would parse this data if it were stored in a CLOB. Why is the XMLTYPE approach superior for querying and data 
-- manipulation?

--      Exercise 1.3: Asynchronous Pipelining vs. Standard Batching
-- Problem
-- A Java application needs to run three independent DML statements against the horizons schema in the most efficient manner possible to reduce application-side 
-- blocking.
-- Relational: How does Oracle's 23ai JDBC Pipelining feature differ fundamentally from standard JDBC batching (addBatch/executeBatch)?
-- Value (Code Snippet): Write a conceptual Java snippet using the 23ai JDBC API to pipeline three independent UPDATE statements on the productCatalog table.
-- Advantage: What is the primary advantage of using pipelining for application throughput and scalability?

--      Exercise 1.4: Oracle AQ/JMS and OpenTelemetry Observability
-- Problem
-- Consider a workflow where a PL/SQL procedure enqueues a message to horizons.partRequestTopic, which is then dequeued and processed by a Java application.
-- Meaning (JMS Bridge): Explain how Oracle Advanced Queuing (AQ) can function as a Java Message Service (JMS) provider. What is the relationship between an AQ queue 
-- table and a JMS Topic/Queue?
-- Value (23ai Feature): Explain the concept of OpenTelemetry Trace Context Propagation and how Oracle 23ai supports it automatically through AQ.
-- Advantage: What is the main benefit of having this end-to-end trace context for a developer or SRE debugging a performance issue in this distributed system?