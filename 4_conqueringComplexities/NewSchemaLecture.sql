-- In ORACLE SQL schemas are users, then they must be created not necessarily with password

-- Connect as SYSTEM or SYS AS SYSDBA to run these commands

-- Drop the user if it already exists (optional, for a clean start)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER conquering_complexities_lecture CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN -- ORA-01918: user '...' does not exist
            RAISE;
        END IF;
END;
/

-- Create the user (this is your schema)
CREATE USER conquering_complexities_lecture
IDENTIFIED BY 123                    -- <<< CHANGE THIS PASSWORD!
DEFAULT TABLESPACE USERS             -- Or your preferred default tablespace
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;            -- Or a specific quota on the tablespace

-- Grant necessary privileges
GRANT CONNECT, RESOURCE TO conquering_complexities_lecture;
-- RESOURCE role includes: CREATE CLUSTER, CREATE INDEXTYPE, CREATE OPERATOR,
-- CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE, CREATE TRIGGER, CREATE TYPE.

-- If you plan to create views:
GRANT CREATE VIEW TO conquering_complexities_lecture;

-- If you plan to use database links (not in your script, but for completeness):
GRANT CREATE DATABASE LINK TO conquering_complexities_lecture;

-- If you need to run ALTER SESSION (like for TIME_ZONE):
GRANT ALTER SESSION TO conquering_complexities_lecture;

-- HIGHLY IMPORTANT: Defines your time zone for inner calculations. This should work if 'Etc/GMT-5' is in your DB's list
ALTER SESSION SET TIME_ZONE = 'Etc/GMT-5';

COMMIT;