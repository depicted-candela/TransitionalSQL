-- In ORACLE SQL schemas are users, then they must be created not necessarily with password

-- Connect as SYSTEM or SYS AS SYSDBA to run these commands

-- Drop the user if it already exists (optional, for a clean start)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER plsqlmastery_lecture CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN -- ORA-01918: user '...' does not exist
            RAISE;
        END IF;
END;
/

-- Create the user (this is your schema)
CREATE USER  plsqlmastery_lecture
IDENTIFIED BY 123                    -- <<< CHANGE THIS PASSWORD!
DEFAULT TABLESPACE USERS             -- Or your preferred default tablespace
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;            -- Or a specific quota on the tablespace

-- Grant necessary privileges
GRANT CONNECT, RESOURCE TO  plsqlmastery_lecture;
-- RESOURCE role includes: CREATE CLUSTER, CREATE INDEXTYPE, CREATE OPERATOR,
-- CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE, CREATE TRIGGER, CREATE TYPE.

-- If you plan to create views:
GRANT CREATE VIEW TO  plsqlmastery_lecture;

-- If you plan to use database links (not in your script, but for completeness):
GRANT CREATE DATABASE LINK TO  plsqlmastery_lecture;

-- If you need to run ALTER SESSION (like for TIME_ZONE):
GRANT ALTER SESSION TO  plsqlmastery_lecture;

-- HIGHLY IMPORTANT: Defines your time zone for inner calculations. This should work if 'Etc/GMT-5' is in your DB's list
ALTER SESSION SET TIME_ZONE = 'Etc/GMT-5';

COMMIT;