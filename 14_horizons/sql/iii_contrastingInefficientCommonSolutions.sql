        -- Oracle Horizons: Connecting with Cutting-Edge Tech


--  Exercise III: Contrasting with Inefficient Common Solutions

--      Exercise 3.1: The "DIY Queue" vs. Oracle AQ
-- Problem
-- A developer needs an asynchronous job queue. Instead of using Oracle AQ, they create a simple table: 
-- jobQueue(jobId NUMBER, payload VARCHAR2(100), status VARCHAR2(10)). 
-- The application INSERTs jobs with status = 'NEW'. 
-- A background process polls this table every 5 seconds with SELECT ... FROM jobQueue WHERE status = 'NEW' FOR UPDATE SKIP LOCKED.
-- Contrast this polling-based approach with using Oracle AQ (DBMS_AQ.DEQUEUE). Explain two significant advantages that AQ provides over this "Do-It-Yourself" 
-- table-based queue, demonstrating the loss of value from not using the Oracle-idiomatic feature.
-- Answer: the queues brings not only structured ways to process sequentially arriving procedures, they also are better than other cases locking the insertion or
-- updating of the table as is queried like `SELECT ... FROM jobQueue WHERE status = 'NEW' FOR UPDATE SKIP LOCKED.`
-- Also querying the table every 5 seconds to fetch data to see if messages are processed (answered) is a highly inefficient procedure, an AQ system solves these
-- problem types with event-driven events arising a signals just when the queue is updated or with timeouts avoiding system blockings
