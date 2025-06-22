        -- Part 3: Schema Privileges and Multicloud Authentication ✅☁️🔑


--  (i) Meanings, Values, Relations, and Advantages

--      Problem 3.1: Using Schema Privileges
-- The devUser needs to be able to query any table in the operationsData schema, both now and in the future, for development and debugging purposes.

-- Step A (As securityAdmin): Grant the developer the appropriate schema-level privilege.
CONNECT SECURITYADMIN/PwdForSecAdmin_04;
GRANT SELECT ANY TABLE ON SCHEMA OPERATIONSDATA TO DEVUSER;
-- Step B (As devUser): Verify that the user can query the existing SupplyInventory table.
CONNECT DEVUSER/PwdForDevUser_03;
SELECT * FROM OPERATIONSDATA.SUPPLYINVENTORY;
-- Step C (As operationsData): Create a new table in the operationsData schema.
CONNECT OPERATIONSDATA/PwdForOpsData_05;
CREATE TABLE TableStepC (operation VARCHAR2(50), costs NUMBER(10,2));
INSERT INTO TableStepC(operation, costs) VALUES ('Operation 1', 1000.00);
COMMIT;
-- Step D (As devUser): Verify that the user can immediately query the new table without any additional grants being issued. This 
-- demonstrates the key advantage.
CONNECT DEVUSER/PwdForDevUser_03;
SELECT * FROM OPERATIONSDATA.TableStepC;
-- Documentation Reference:

-- This problem involves a new feature in Oracle 23ai. To understand the prerequisites, consult these essential documents:
-- Security Guide, Chapter 4: Configuring Privilege and Role Authorization - Section 4.7, "Managing Schema Privileges," explains the 
-- concept and the required privileges.
-- SQL Language Reference, GRANT Statement - The syntax diagram on page 18-33 shows the new grant_schema_privileges clause, and the 
-- "Prerequisites" on page 18-38 confirms the necessary rights.
-- PostgreSQL Bridge: This single Oracle command, GRANT SELECT ANY TABLE ON SCHEMA..., is a more direct equivalent to the combination of 
-- PostgreSQL's GRANT USAGE ON SCHEMA and ALTER DEFAULT PRIVILEGES. It simplifies granting ongoing access to all of an application's 
-- tables.