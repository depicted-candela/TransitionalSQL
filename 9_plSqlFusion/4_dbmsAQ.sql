4. DBMS_AQ: Oracle Advanced Queuing
Oracle Advanced Queuing (AQ) is a database-integrated, transactional message queuing system.

Exercise 4.1: Enqueue and Dequeue a Transactional Message
Problem: Create a queue for processing new orders. Enqueue a message representing a new order payload. Then, create a separate block to dequeue the message. Demonstrate the transactional integrity by rolling back a dequeue operation, and then successfully dequeuing it in a new transaction.

Reference: Transactional Event Queues and Advanced Queuing User's Guide.
Exercise 4.2: The "Queue Table" Anti-Pattern
Problem: Implement a job processing mechanism using the processingQueue table. Write a PL/SQL block that attempts to find and process a 'NEW' job. Highlight the challenges with locking and race conditions inherent in this manual approach, then contrast it with the simplicity of DBMS_AQ.DEQUEUE.