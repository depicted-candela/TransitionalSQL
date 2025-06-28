        -- Oracle Horizons: Connecting with Cutting-Edge Tech


--  Exercise IV: Hardcore Combined Problem

-- The Challenge: End-to-End Observable Asynchronous Order Fulfillment
-- Problem
-- The Horizons manufacturing system needs a fully observable, end-to-end, asynchronous process for component reservations when a new 'Gaming PC' order is placed. The 
-- system must be resilient and performant.

-- The Workflow:
-- A new order for a 'Gaming PC' is inserted into the customerOrders and orderDetails tables.
-- A PL/SQL procedure must be invoked to parse the order's detailXML. For each base component (leaf node) in the product hierarchy, it must enqueue a reservation 
-- request to the horizons.partRequestTopic.
-- A multi-threaded Java service using UCP must listen to this topic.
-- The Java service must use JDBC Pipelining to send all required inventory UPDATE DMLs for a given order to the database in a single, efficient batch.
-- The entire distributed flow, from the initial web request that calls the PL/SQL procedure to the final database commits by the Java service, must be traceable 
-- using a single trace ID via OpenTelemetry.
-- Tasks:
-- PL/SQL Package: Create a PL/SQL package HORIZONS.ORDERFULFILLMENT with a procedure processNewOrder(p_orderId IN NUMBER). This procedure must:

-- Use XMLTABLE to parse the orderDetails.detailXML.
-- For each part number found, use a hierarchical query (CONNECT BY ... ISLEAF) to find all its base components in productCatalog.
-- For each base component, enqueue a message of type PartRequestType to the horizons.partRequestTopic. The entire procedure must run within a single transaction.
-- Java Processor (Conceptual Code): Write the core logic for a Java consumer method. It should:

-- Receive a message from the JMS topic.
-- For the order, create a list of all required UPDATE statements for an assumed inventory table.
-- Use the 23ai JDBC Pipelining API (executeUpdateAsyncOracle) to send all UPDATEs asynchronously within a single transaction.

CREATE OR REPLACE PACKAGE HORIZONS.ORDERFULFILLMENT AS
    PROCEDURE PROCESSNEWORDER(p_orderId IN NUMBER);
END ORDERFULFILLMENT;
/

CREATE OR REPLACE PACKAGE BODY HORIZONS.ORDERFULFILLMENT AS
    PROCEDURE PROCESSNEWORDER(p_orderId IN NUMBER) IS
        l_enqueue_options    DBMS_AQ.enqueue_options_t;
        l_message_properties DBMS_AQ.message_properties_t;
        l_message_handle     RAW(16);
        l_reservationMsg     horizons.PartRequestType;
        l_orderXML           XMLTYPE;
    BEGIN
        -- Foundational Concept: Get the order's XML details using SELECT INTO
        SELECT detailXML INTO l_orderXML FROM horizons.orderDetails WHERE orderId = p_orderId;
        -- For each item in the order...
        -- XML Processing: Use XMLTABLE to shred the XML into a relational structure
        FOR orderItem IN (
        SELECT xt.partNumber, xt.quantity
        FROM XMLTABLE('/order/items/item' PASSING l_orderXML
                COLUMNS partNumber NUMBER PATH '@partNumber',
                        quantity   NUMBER PATH '@quantity') xt
        ) LOOP
        -- ...find all its leaf-node base components and enqueue a reservation for each.
        -- Hierarchical Query: Use CONNECT BY to traverse the product hierarchy
        FOR baseComponent IN (
            SELECT partId
            FROM horizons.productCatalog
            WHERE CONNECT_BY_ISLEAF = 1
            START WITH partId = orderItem.partNumber
            CONNECT BY PRIOR partId = parentPartId
        ) LOOP
            -- Create and enqueue the message object
            l_reservationMsg := horizons.PartRequestType(
                p_orderId,
                baseComponent.partId,
                orderItem.quantity,
                SYSTIMESTAMP
            );
            -- Oracle AQ: Enqueue the typed message.
            -- 23ai Observability: The trace context is propagated automatically.
            DBMS_AQ.ENQUEUE(
                queue_name         => 'horizons.partRequestTopic',
                enqueue_options    => l_enqueue_options,
                message_properties => l_message_properties,
                payload            => l_reservationMsg,
                msgid              => l_message_handle
            );
            DBMS_OUTPUT.PUT_LINE('Enqueued reservation for Order ' || p_orderId || ', Part ' || baseComponent.partId);
        END LOOP;
        END LOOP;
        -- The calling application is responsible for the COMMIT
    END PROCESSNEWORDER;
END ORDERFULFILLMENT;
/

-- Observability Explanation: Explain how the OpenTelemetry trace_id propagates through this entire system, from the initial JDBC call to the PL/SQL package, into the 
-- AQ message, and finally into the Java consumer. What is the key Oracle 23ai feature that makes this seamless?
-- Answer: The OpenTelemetry is a sort of middleware with multiple confs to be connected with multiple technologies including all the ORACLE technologies, in this 
-- context, a single trace_id belongs to a unique set of processes of different technologies, such centralization up to OpenTelemetry enables the observability of
-- all the processes where ORACLE or other brands communicate
-- ORACLE Diagnosibility features are centralized to be in a single log file for all the Java technologies in a single configurable path, scaling this with ORACLE
-- Cloud we get a centralized version of logging for ease of diagnosability