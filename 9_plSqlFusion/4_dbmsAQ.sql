        -- 4. DBMS_AQ: Oracle Advanced Queuing


-- Oracle Advanced Queuing (AQ) is a database-integrated, transactional message queuing system.

--      Exercise 4.1: Enqueue and Dequeue a Transactional Message
-- Problem: Create a queue for processing new orders. Enqueue a message representing a new order payload. Then, create a separate block to dequeue the message. 
-- Demonstrate the transactional integrity by rolling back a dequeue operation, and then successfully dequeuing it in a new transaction.
BEGIN
    DBMS_AQADM.DROP_QUEUE_TABLE('plsqlfusion.for_exercise_4_1', TRUE);
END;
/

BEGIN
    DBMS_AQADM.CREATE_QUEUE_TABLE(queue_table => 'plsqlfusion.for_exercise_4_1', queue_payload_type => 'RAW');
    DBMS_AQADM.CREATE_QUEUE(queue_name => 'order_payload', queue_table => 'plsqlfusion.for_exercise_4_1');
    DBMS_AQADM.START_QUEUE(queue_name => 'plsqlfusion.order_payload');
END;
/

DECLARE
    v_enqueue_options DBMS_AQ.enQueue_Options_t;
    v_message_properties DBMS_AQ.message_properties_t;
    v_payload RAW(100) := UTL_RAW.CAST_TO_RAW('My first message');
    v_message_handle RAW(16);
BEGIN
    DBMS_AQ.ENQUEUE(
        queue_name => 'plsqlfusion.order_payload', 
        enqueue_options => v_enqueue_options, 
        message_properties => v_message_properties, 
        payload => v_payload,
        msgid => v_message_handle
    );
    COMMIT;
END;
/

DECLARE
    dequeue_options DBMS_AQ.deQueue_Options_t;
    message_properties DBMS_AQ.message_properties_t;
    payload RAW(100);
    message_handle RAW(16);
BEGIN
    dequeue_options.wait := DBMS_AQ.FOREVER;
    dequeue_options.visibility := DBMS_AQ.ON_COMMIT;
    DBMS_AQ.DEQUEUE(
        queue_name => 'plsqlfusion.order_payload', 
        dequeue_options => dequeue_options,
        message_properties => message_properties, 
        payload => payload, 
        msgid => message_handle
    );
    ROLLBACK;
END;
/
-- Reference: Transactional Event Queues and Advanced Queuing User's Guide.

--      Exercise 4.2: The "Queue Table" Anti-Pattern
-- Problem: Implement a job processing mechanism using the processingQueue table. Write a PL/SQL block that attempts to find and process a 'NEW' job. Highlight the 
-- challenges with locking and race conditions inherent in this manual approach, then contrast it with the simplicity of DBMS_AQ.DEQUEUE.
-- Step 1: Add a job to the "bad" queue table
INSERT INTO processingQueue (payload) VALUES ('Process report for month-end close');
COMMIT;
-- Step 2: The inefficient/risky PL/SQL implementation
DECLARE
    vJobId processingQueue.jobId%TYPE;
    vPayload processingQueue.payload%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inefficient Anti-Pattern Attempt ---');
    -- This code is prone to race conditions if multiple sessions run it.
    -- It requires careful, manual locking and updating.
    SELECT jobId, payload INTO vJobId, vPayload
    FROM processingQueue WHERE status = 'NEW'
    ORDER BY createTimestamp FETCH FIRST 1 ROWS ONLY
    FOR UPDATE SKIP LOCKED;

    UPDATE processingQueue SET status = 'PROCESSING' WHERE jobId = vJobId;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Processing job ' || vJobId || ': ' || vPayload);
    UPDATE processingQueue SET status = 'DONE' WHERE jobId = vJobId;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Job ' || vJobId || ' finished.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No new jobs to process.');
END;
/

BEGIN
    DBMS_AQADM.DROP_QUEUE_TABLE('plsqlfusion.procssingQueue', TRUE);
END;
/

BEGIN
    DBMS_AQADM.CREATE_QUEUE_TABLE(queue_table => 'plsqlfusion.procssingQueue', queue_payload_type => 'RAW');
    DBMS_AQADM.CREATE_QUEUE(queue_name => 'NEW', queue_table => 'plsqlfusion.procssingQueue');
    DBMS_AQADM.START_QUEUE(queue_name => 'plsqlfusion.NEW');
END;
/

DECLARE
    v_enqueue_options DBMS_AQ.enQueue_Options_t;
    v_message_properties DBMS_AQ.message_properties_t;
    v_payload RAW(100) := UTL_RAW.CAST_TO_RAW('My first message');
    v_message_handle RAW(16);
BEGIN
    DBMS_AQ.ENQUEUE(
        queue_name => 'plsqlfusion.NEW', 
        enqueue_options => v_enqueue_options, 
        message_properties => v_message_properties, 
        payload => v_payload,
        msgid => v_message_handle
    );
    COMMIT;
END;
/

DECLARE
    v_dequeue_options DBMS_AQ.deQueue_Options_t;
    v_message_properties DBMS_AQ.message_properties_t;
    v_payload RAW(100) := UTL_RAW.CAST_TO_RAW('Payload');
    v_message_handle RAW(16);
BEGIN
    v_dequeue_options.wait := DBMS_AQ.FOREVER;
    v_dequeue_options.visibility := DBMS_AQ.ON_COMMIT;
    DBMS_AQ.DEQUEUE(
        queue_name => 'plsqlfusion.NEW', 
        dequeue_options => v_dequeue_options,
        message_properties => v_message_properties, 
        payload => v_payload, 
        msgid => v_message_handle
    );
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Rolled back the message: '||v_message_handle);
END;
/