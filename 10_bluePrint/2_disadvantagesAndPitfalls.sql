        -- Oracle Blueprint


--  Disadvantages and Pitfalls
-- These exercises highlight potential issues and limitations to be aware of when working with these concepts in Oracle.

--      Exercise 1: The Danger of Cascading Drops
-- Problem:
-- You've created the anotherSchema user who owns the confidentialData table. What is the potential pitfall of dropping this user using the CASCADE option? Write the 
-- SQL to demonstrate this and verify the outcome.
SELECT * FROM ANOTHERSCHEMA.CONFIDENTIALDATA;
-- Answer: such schema was made to create referenced synonyms from the Blueprint schema were the meanings in Confidential Data could be for specific applications
-- focused on security using synonyms in uniquely meaningful ways for coherent usages in security applications. Thus a cascaded deletion could damage severely 
-- important applications 
-- Caution: This is a destructive operation. The purpose is to understand the risk. The provided setup script can be used to recreate the user and their objects 
-- afterward.

--      Exercise 2: The Blocked Update (Row-Level Locking)
-- Problem:
-- This exercise demonstrates a common pitfall for new developers: a "hanging" application due to a lock. For a deeper understanding, refer to the Oracle Concepts 
-- guide on Locking Mechanisms.

-- In Session 1: Start a transaction by updating the quantityOnHand for product 100 in warehouse 1 to 45. Do not commit.
SELECT * FROM BLUEPRINT.PRODUCTS;
SELECT * FROM BLUEPRINT.INVENTORY;

UPDATE BLUEPRINT.INVENTORY SET QUANTITYONHAND = 45 WHERE PRODUCTID = 100;
-- In Session 2: Immediately try to update the quantityOnHand for the exact same product in the same warehouse to 40.
-- Describe what happens in Session 2. Why does this occur?
-- Answer: because the row updated in session 1 is locked as is not committed, new updates of such rows must be blocked as the row is committed to avoid unmeaningful
-- changes if concurrency is enabled without logical limits like row locking
-- What happens in Session 2 after you issue a ROLLBACK in Session 1?
ROLLBACK;
-- The DML operation is performed in the second session.