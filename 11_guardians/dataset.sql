-- ===================================================================================
-- Oracle 23ai Security Features Demo - FINAL CORRECTED Setup Script
-- ===================================================================================

-- ===================================================================================
-- PART 1: User Creation and System Privileges - CORRECTED
-- ===================================================================================

-- Clean up old users to ensure a fresh start
DROP USER guardians CASCADE;
DROP USER appUser CASCADE;
DROP USER securityAdmin CASCADE;
DROP USER operationsData CASCADE;
DROP USER devUser CASCADE;
DROP USER analystUser CASCADE;

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
    RESOURCE,
    AUDIT_ADMIN,
    EXEMPT REDACTION POLICY,
    ADMINISTER SQL FIREWALL,
    AUDIT_VIEWER,
    ADMINISTER REDACTION POLICY TO securityAdmin;

-- =====================================================================
-- CRITICAL FIX: Grant required privileges DIRECTLY, not just via roles,
-- so they are available inside Definer's Rights PL/SQL packages.
-- =====================================================================
GRANT CREATE PROCEDURE TO securityAdmin;
GRANT AUDIT SYSTEM TO securityAdmin;

-- Grant execute on required packages
GRANT EXECUTE ON DBMS_REDACT TO securityAdmin;
GRANT EXECUTE ON DBMS_SQL_FIREWALL TO securityAdmin;
GRANT EXECUTE ON DBMS_AUDIT_MGMT TO securityAdmin;
COMMIT;

-- ===================================================================================
-- PART 2: Main Schema Objects and Grants (Run as GUARDIANS)
-- ===================================================================================
CONNECT guardians/YourSecurePassword_123;

CREATE TABLE guardians.SensitiveData (
    agentId              NUMBER PRIMARY KEY,
    agentName            VARCHAR2(100),
    socialSecurityNumber VARCHAR2(11) NOT NULL UNIQUE,
    salary               NUMBER(10, 2),
    isCovert             VARCHAR(5) DEFAULT 'FALSE' NOT NULL,
    missionNotes         CLOB,
    CONSTRAINT chk_isCovert CHECK (isCovert IN ('FALSE', 'TRUE'))
);

CREATE TABLE guardians.MissionLogs (
    logId        NUMBER GENERATED ALWAYS AS IDENTITY,
    agentId      NUMBER,
    logTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    logEntry     VARCHAR2(4000),
    CONSTRAINT fkAgentId FOREIGN KEY (agentId) REFERENCES guardians.SensitiveData(agentId)
);

INSERT INTO guardians.SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) 
VALUES (1, 'James Bond', '123-45-6789', 150000.00, 'FALSE', 'Notes on project Spectre.');
INSERT INTO guardians.SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) 
VALUES (2, 'Jason Bourne', '987-65-4321', 145000.00, 'TRUE', 'Treadstone asset details.');
INSERT INTO guardians.SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) 
VALUES (3, 'Evelyn Salt', '555-44-3322', 162000.00, 'TRUE', 'Deep cover operation notes.');

INSERT INTO guardians.MissionLogs(agentId, logEntry) VALUES (1, 'Initial briefing for Operation Skyfall complete.');
INSERT INTO guardians.MissionLogs(agentId, logEntry) VALUES (2, 'Acquired target package from Berlin safe house.');

GRANT SELECT ON guardians.SensitiveData TO analystUser;
GRANT SELECT, INSERT ON guardians.MissionLogs TO appUser;
GRANT SELECT, INSERT ON guardians.SensitiveData TO appUser;
COMMIT;

-- ===================================================================================
-- PART 3: Supporting Schema Objects (Run as OPERATIONSDATA)
-- ===================================================================================
CONNECT operationsData/PwdForOpsData_05;

CREATE TABLE operationsData.SupplyInventory (
    supplyId NUMBER PRIMARY KEY,
    itemName VARCHAR2(100),
    quantity NUMBER
);

INSERT INTO operationsData.SupplyInventory (supplyId, itemName, quantity) VALUES (1, 'Encrypted Communicator', 50);
INSERT INTO operationsData.SupplyInventory (supplyId, itemName, quantity) VALUES (2, 'GPS Tracker', 200);
COMMIT;