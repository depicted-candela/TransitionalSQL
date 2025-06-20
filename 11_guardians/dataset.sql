-- ===================================================================================
-- Oracle 23ai Security Features Demo - CORRECTED AND FINAL Setup Script
--
-- INSTRUCTIONS: Run this as a privileged user (e.g., SYS or SYSTEM).
-- ===================================================================================

-- Clean up old users to ensure a fresh start
DROP USER guardians CASCADE;
DROP USER appUser CASCADE;
DROP USER securityAdmin CASCADE;
DROP USER operationsData CASCADE;
DROP USER devUser CASCADE;
DROP USER analystUser CASCADE;

-- ===================================================================================
-- PART 1: User Creation and System Privileges (CORRECTED)
-- ===================================================================================

-- DCL for Main Schema and Supporting Users
CREATE USER guardians IDENTIFIED BY YourSecurePassword_123;
GRANT CONNECT, RESOURCE, CREATE VIEW TO guardians;
ALTER USER guardians QUOTA UNLIMITED ON users;

CREATE USER appUser IDENTIFIED BY PwdForAppUser_01;
GRANT CONNECT, UNLIMITED TABLESPACE TO appUser;

CREATE USER analystUser IDENTIFIED BY PwdForAnalyst_02;
GRANT CONNECT TO analystUser;

CREATE USER devUser IDENTIFIED BY PwdForDevUser_03;
GRANT CONNECT TO devUser;

CREATE USER operationsData IDENTIFIED BY PwdForOpsData_05;
GRANT CONNECT, RESOURCE, CREATE TABLE TO operationsData;
ALTER USER operationsData QUOTA UNLIMITED ON users;

-- A highly privileged user to manage security features
CREATE USER securityAdmin IDENTIFIED BY PwdForSecAdmin_04;
GRANT CONNECT,
      AUDIT_ADMIN,
      EXEMPT REDACTION POLICY,
      ADMINISTER SQL FIREWALL,
      AUDIT_VIEWER,
      -- =====================================================================
      -- FIX 1: ADDED PRIVILEGE TO CREATE REDACTION POLICIES
      -- This privilege is required to create redaction policies on objects
      -- in another user's schema (e.g., guardians.SensitiveData).
      -- =====================================================================
      ADMINISTER REDACTION POLICY TO securityAdmin;

-- Grant execute on required packages
GRANT EXECUTE ON DBMS_REDACT TO securityAdmin;
GRANT EXECUTE ON DBMS_SQL_FIREWALL TO securityAdmin;
-- =====================================================================
-- FIX 2: ADDED PRIVILEGE TO FLUSH THE AUDIT TRAIL
-- This privilege is required to execute procedures in the DBMS_AUDIT_MGMT
-- package, such as flushing the trail for immediate viewing.
-- =====================================================================
GRANT EXECUTE ON DBMS_AUDIT_MGMT TO securityAdmin;

COMMIT;

-- Part 1 Complete. Please disconnect and run the original Part 2 as GUARDIANS,
-- and the original Part 3 as OPERATIONSDATA.

-- ===================================================================================
-- PART 2: Main Schema Objects and Grants
-- PURPOSE: Creates the primary tables, populates them, and grants access to other users.
-- RUN AS: The GUARDIANS user.
-- ===================================================================================

-- DDL for Table Structures
CREATE TABLE guardians.SensitiveData (
    agentId              NUMBER PRIMARY KEY,
    agentName            VARCHAR2(100),
    socialSecurityNumber VARCHAR2(11) NOT NULL UNIQUE,
    salary               NUMBER(10, 2),
    isCovert             NUMBER(1) DEFAULT 0 NOT NULL, -- Using NUMBER(1) for boolean for max compatibility
    missionNotes         CLOB,
    CONSTRAINT chk_isCovert CHECK (isCovert IN (0, 1)) -- 0 for false, 1 for true
);

CREATE TABLE guardians.MissionLogs (
    logId        NUMBER GENERATED ALWAYS AS IDENTITY,
    agentId      NUMBER,
    logTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    logEntry     VARCHAR2(4000),
    CONSTRAINT fkAgentId FOREIGN KEY (agentId) REFERENCES guardians.SensitiveData(agentId)
);

-- DML for Populating Data
INSERT INTO guardians.SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) VALUES (1, 'James Bond', '123-45-6789', 150000.00, 0, 'Notes on project Spectre.');
INSERT INTO guardians.SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) VALUES (2, 'Jason Bourne', '987-65-4321', 145000.00, 1, 'Treadstone asset details.');
INSERT INTO guardians.SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) VALUES (3, 'Evelyn Salt', '555-44-3322', 162000.00, 1, 'Deep cover operation notes.');

INSERT INTO guardians.MissionLogs(agentId, logEntry) VALUES (1, 'Initial briefing for Operation Skyfall complete.');
INSERT INTO guardians.MissionLogs(agentId, logEntry) VALUES (2, 'Acquired target package from Berlin safe house.');

-- Grant necessary object privileges on the tables owned by GUARDIANS
GRANT SELECT ON guardians.SensitiveData TO analystUser;
GRANT SELECT, INSERT ON guardians.MissionLogs TO appUser;
GRANT SELECT, INSERT ON guardians.SensitiveData TO appUser;

COMMIT;

-- Part 2 Complete. Please disconnect and connect as OPERATIONSDATA.


-- ===================================================================================
-- PART 3: Supporting Schema Objects
-- PURPOSE: Creates and populates tables in a different schema.
-- RUN AS: The OPERATIONSDATA user.
-- ===================================================================================

CREATE TABLE operationsData.SupplyInventory (
    supplyId NUMBER PRIMARY KEY,
    itemName VARCHAR2(100),
    quantity NUMBER
);

INSERT INTO operationsData.SupplyInventory (supplyId, itemName, quantity) VALUES (1, 'Encrypted Communicator', 50);
INSERT INTO operationsData.SupplyInventory (supplyId, itemName, quantity) VALUES (2, 'GPS Tracker', 200);

COMMIT;

-- Part 3 Complete. The database is now fully set up for the exercises.
-- ===================================================================================