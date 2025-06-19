        -- Oracle Blueprint


--  Type (iii): Contrasting with Inefficient Common Solutions
-- These exercises contrast a common but less efficient approach with the idiomatic, high-performance Oracle way.

--      Exercise 1: Mass Deletion - DELETE vs. TRUNCATE
-- Problem:
-- Imagine the inventoryLog table has grown to millions of rows, and you need to purge all of them as part of a monthly maintenance job.

-- Write the "common" SQL statement to remove all rows from a table, which is functionally correct but inefficient for this task.

SELECT * FROM BLUEPRINT.INVENTORYLOG;
BEGIN
    SAVEPOINT functionallyCorrect;
    DELETE FROM BLUEPRINT.INVENTORYLOG;
    ROLLBACK TO functionallyCorrect;
END;
/

SELECT * FROM BLUEPRINT.INVENTORYLOG;
SAVEPOINT efficient;
TRUNCATE TABLE BLUEPRINT.INVENTORYLOG;
SELECT * FROM BLUEPRINT.INVENTORYLOG;

-- Write the more efficient, Oracle-idiomatic statement for this task.
-- Explain the key differences in how Oracle processes these two statements and why the second is vastly more performant for this specific use case (clearing an entire 
-- table). Your explanation should cover DML vs. DDL, UNDO/REDO generation, triggers, and storage reclamation (High Water Mark). Reference: See the "Truncating Tables 
-- and Clusters" section in the DBA Guide.
-- Answer: these two approaches differ vastly because the first it's more business oriented than the another one because the last is specific for cleaning or freeing
-- storage when highly repetitive data is unnecessary and massive, like logs for patterns measured within minutes
-- Thus, because the first approach is more bussiness oriented, all the logics addressed to it is performed, for example when an item is sold, it must be deleted
-- but such deletion triggers a stock updating of related categories. These procedures the fined-grained properties of single row selection
-- DROP also is efficient cleaning all data like TRUNCATE with the additional requirement of reconstructing the table that arriving operations requires always to 
-- exists
-- UNDO/REDO operations works for fine grained DML like DELETE because logics could be for that rather than REDO of just massive operations like TRUNCATE, otherwise
-- with DDL like DROP and CREATE is not possible the usage of REDOs. Because to have memory for UNDO/REDO operations is resource consuming it's necessary to select
-- well the best approach to avoid slowed systems.