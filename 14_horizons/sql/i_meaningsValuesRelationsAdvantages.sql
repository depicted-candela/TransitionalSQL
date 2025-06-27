        -- Oracle Horizons: Connecting with Cutting-Edge Tech


--  Exercise I: Meanings, Values, Relations, and Advantages


--      Exercise 1.1: JDBC, UCP, and New Connection Management
-- Problem
-- A Java development team is building a high-throughput order processing service against the horizons schema.
-- Meaning & Value: Explain the meaning of "connection pooling" and its primary value for an application. Provide a simple Java code example showing how to obtain a 
-- connection from Oracle's Universal Connection Pool (UCP).
--  Answer: The connection pool is a tool to keep alive specific sessions with known credentials to enhance the ease and speed of access to the aforemetioned sessions
-- for the specified users with their credentials 
-- The connection pool enables the application to be connected immediately to the database with credentials of specific users or roles stored in a data
-- storage of confs
-- Relational (PostgreSQL Bridge): PostgreSQL deployments often use PgBouncer for server-side connection pooling. Oracle offers Database Resident Connection Pooling 
-- (DRCP). Explain the core architectural difference and the value of Oracle's new Multi-Pool DRCP feature.
--  Answer: The core difference is that the DRCP has incorporated default configured resources for a small number of specific connections, enabling fast connections
-- for specific users like admins, or highly relevant app ends, something special about its centalized nature is how process are simplified reducing communication
-- costs, the pgBouncer serves as a gate from different messaging technologies like Kafka, requiring to be configured and programmed, ORACLE simplifies a lot processes
-- there but with high migration costs up to another dataset. The fine-grained control given by pgBouncer and external technologies like Kafka is reached by The 
-- Multi-Pool DRCP architecture enabling multiple confs for necessarily different pools by meanings and utilities (resources, priorizations, etc)
-- Advantage (23ai Feature): The team has heard about Oracle 23ai's Implicit Connection Pooling. Explain how this feature simplifies the developer's code compared to 
-- the explicit UCP setup shown in part 1.
--  Answer: it's a feature that understands when an application starts and ends their database processes, with a certain map of the expected, necessary and sufficient
-- operations that an app requires to be useful for stakeholders, like a standardized and followed protocol

--      Exercise 1.2: The Value of Oracle XMLTYPE
-- Problem
-- Using the horizons.orderDetails table:
-- Meaning: What is the fundamental difference between storing order details in a CLOB versus the XMLTYPE data type?
-- Answer: A CLOB value is essentially a binary set of characters without the structurally ordered data in chunks prone to be searched and indexed through algorithms
-- Value & Syntax: Write an Oracle SQL query using XMLTABLE to shred the XML data from the order with anbr attribute 'ORD201', returning a relational rowset with 
-- columns partNumber and quantity.
WITH ANBR_ORD201 AS (
    SELECT * FROM HORIZONS.ORDERDETAILS WHERE XMLEXISTS('/order[@anbr="ORD201"]' PASSING DETAILXML)
)
SELECT ORDERID, xt.*
    FROM ANBR_ORD201 od, 
        XMLTABLE('/order/items/item'
            PASSING od.DETAILXML 
            COLUMNS 
                PARTNUMBER NUMBER PATH '@partNumber',
                QUANTITY NUMBER PATH '@quantity'
        ) xt;
-- Advantage: Contrast the query from part 2 with how you would parse this data if it were stored in a CLOB. Why is the XMLTYPE approach superior for querying and data 
-- manipulation?
-- Answer: XMLTYPE is insanely superior because of its structured approach storing things, CLOB is just a binary character concatenation, the techniques to be applied
-- in them are extremally different, the first prone to be processed by their structural patterns

--      Exercise 1.3: Asynchronous Pipelining vs. Standard Batching
-- Problem
-- A Java application needs to run three independent DML statements against the horizons schema in the most efficient manner possible to reduce application-side 
-- blocking.
-- Relational: How does Oracle's 23ai JDBC Pipelining feature differ fundamentally from standard JDBC batching (addBatch/executeBatch)?
-- Answer: the difference lies in the asynchronous nature of the pipelining, where JDBC batching sends many requests and waits for their responses, and pipelining
-- sends multiple requests trusting they'll be well received without errors (to assure this are necessary fine grained tests), thus resources are freed and more 
-- requests are sent
-- Value (Code Snippet): Write a conceptual Java snippet using the 23ai JDBC API to pipeline three independent UPDATE statements on the productCatalog table.
-- Advantage: What is the primary advantage of using pipelining for application throughput and scalability?
-- Answer: pipelining sends multiple requests trusting they'll be well received without errors (to assure this are necessary fine grained tests), thus resources 
-- are freed and more requests are sent

--      Exercise 1.4: Oracle AQ/JMS and OpenTelemetry Observability
-- Problem
-- Consider a workflow where a PL/SQL procedure enqueues a message to horizons.partRequestTopic, which is then dequeued and processed by a Java application.
-- Meaning (JMS Bridge): Explain how Oracle Advanced Queuing (AQ) can function as a Java Message Service (JMS) provider. What is the relationship between an AQ 
-- queue table and a JMS Topic/Queue?
-- Answer: Oracle AQ is a sort of consecutive storage of structured data waiting to be processed and accumulable coming from fused ORACLE Pooling and Pipelining
-- technologies for always available services where the AQ acts a sequential organizer of the coming requests, in such order the JDBC API with its aforementioned
-- technologies acts as a JMS provider because working together enqueue, dequeue, process and get all the messages in a queue table to show historials
-- Value (23ai Feature): Explain the concept of OpenTelemetry Trace Context Propagation and how Oracle 23ai supports it automatically through AQ.
-- Answer: OpenTelemetry trace and is informed about every part of a process from its beginning to its end -highly important for enormous systems needing logs
-- when a process is failing and nobody knows where happens-, is supported with AQ because of their sequential properties, necessarily modeling the nature of
-- systemic processes
-- Advantage: What is the main benefit of having this end-to-end trace context for a developer or SRE debugging a performance issue in this distributed system?
-- Answer: when a system is really big, tends to be distributed, this means many interconnected services along different machines, when added to frontend
-- is harder to follow all the operations performed by all users, centralizing all the operations with sequential processes in an ORACLE QA means precise 
-- logging and control of where could exists performance or blocking problems