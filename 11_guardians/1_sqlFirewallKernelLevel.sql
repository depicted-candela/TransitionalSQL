        -- Part 1: SQL Firewall: Kernel-Level Protection 🔥


--  (i) Meanings, Values, Relations, and Advantages

--      Problem 1.1: Create and Enforce a Basic SQL Firewall Policy
-- The appUser is a service account for an application that should only ever insert into MissionLogs. It should never directly query the SensitiveData table. Your task 
-- is to create a SQL Firewall policy to enforce this behavior.

-- Step A (As securityAdmin): Enable SQL Firewall and start a "capture" session for the appUser to learn its normal behavior.
CONNECT securityAdmin/PwdForSecAdmin_04;
EXEC DBMS_SQL_FIREWALL.ENABLE;
EXEC DBMS_SQL_FIREWALL.CREATE_CAPTURE(username => 'APPUSER');
-- Step B (As appUser): Run the legitimate application query to populate the capture log.
CONNECT appUser/PwdForAppUser_01;
INSERT INTO GUARDIANS.MissionLogs(AGENTID, logEntry) VALUES (3, 'Testing for logs');
COMMIT;
-- Step C (As securityAdmin): Stop the capture, generate the allow-list, and enforce the policy in "BLOCK" mode.
CONNECT securityAdmin/PwdForSecAdmin_04;
EXEC DBMS_SQL_FIREWALL.STOP_CAPTURE(username => 'APPUSER');
EXEC DBMS_SQL_FIREWALL.GENERATE_ALLOW_LIST('APPUSER');
EXEC DBMS_SQL_FIREWALL.ENABLE_ALLOW_LIST(username => 'APPUSER', enforce => DBMS_SQL_FIREWALL.ENFORCE_SQL, block => TRUE);
-- Step D (As appUser): Verify that the legitimate query still works, but an unauthorized query (attempting to select from SensitiveData) is now blocked.
CONNECT appUser/PwdForAppUser_01;
INSERT INTO GUARDIANS.MissionLogs(AGENTID, logEntry) VALUES (3, 'Testing for logs');
COMMIT;
SELECT * FROM GUARDIANS.MISSIONLOGS;
-- For a deep dive into SQL Firewall concepts and the DBMS_SQL_FIREWALL package, consult the Oracle SQL Firewall User's Guide, Chapter 1: Overview.


--  (ii) Disadvantages and Pitfalls

--      Problem 1.2: The Pitfall of an Incomplete Capture
-- You have been asked to create a policy for analystUser. The analyst's only approved job is to query agent names. You run a quick capture session. However, you 
-- forget that the analyst also has a legitimate, but rarely used, query to count the total number of agents. Demonstrate the pitfall of enforcing a policy based on an 
-- incomplete capture.
CONNECT SECURITYADMIN/PwdForSecAdmin_04;
EXEC DBMS_SQL_FIREWALL.ENABLE;
EXEC DBMS_SQL_FIREWALL.CREATE_CAPTURE(username => 'ANALYSTUSER');
CONNECT ANALYSTUSER/PwdForAnalyst_02;
SELECT ISCOVERT FROM GUARDIANS.SENSITIVEDATA;
CONNECT SECURITYADMIN/PwdForSecAdmin_04;
EXEC DBMS_SQL_FIREWALL.STOP_CAPTURE(username => 'ANALYSTUSER');
EXEC DBMS_SQL_FIREWALL.GENERATE_ALLOW_LIST('ANALYSTUSER');
EXEC DBMS_SQL_FIREWALL.ENABLE_ALLOW_LIST(username => 'ANALYSTUSER', enforce => DBMS_SQL_FIREWALL.ENFORCE_SQL, block => TRUE);
CONNECT ANALYSTUSER/PwdForAnalyst_02;
SELECT COUNT(AGENTID) TOTAL_NUMBER FROM GUARDIANS.SENSITIVEDATA;
UPDATE GUARDIANS.SENSITIVEDATA SET SALARY = 151000 WHERE AGENTID = 1;
COMMIT;
ROLLBACK;
CONNECT ANALYSTUSER/PwdForAnalyst_02;
SELECT * FROM DBA_SQL_FIREWALL_VIOLATIONS;


--  (iii) Contrasting with Inefficient Common Solutions

--      Problem 1.3: The Inefficient Trigger-Based "Firewall"
-- Before SQL Firewall, a common (and inefficient) way to monitor queries was to use a DML trigger. Create a solution using a trigger that attempts to log all SQL run 
-- by appUser. After implementing it, consider why this is vastly inferior to SQL Firewall in terms of performance, completeness, and security.

--      Two equivalent approaches

-- With connections
CONNECT guardians/YourSecurePassword_123;
CREATE TABLE AppUserQueryLog (logTime TIMESTAMP, sqlText VARCHAR2(4000));
CREATE OR REPLACE TRIGGER LogAppUserDML
AFTER INSERT OR UPDATE OR DELETE ON MissionLogs
DECLARE
  v_sql_text VARCHAR2(4000);
BEGIN
  -- Unreliable method to capture SQL, and only works for DML on this one table
  FOR r IN (SELECT sql_text FROM v$sql WHERE sql_id = (SELECT prev_sql_id FROM v$session WHERE audsid = USERENV('SESSIONID')))
  LOOP
    v_sql_text := r.sql_text;
    EXIT; -- Get the first one found
  END LOOP;
  INSERT INTO AppUserQueryLog (logTime, sqlText) VALUES (SYSTIMESTAMP, v_sql_text);
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Through trees
CREATE TABLE guardians.AppUserQueryLog (logTime TIMESTAMP, sqlText VARCHAR2(4000));
CREATE OR REPLACE TRIGGER guardians.LogAppUserDML
AFTER INSERT OR UPDATE OR DELETE ON MissionLogs
DECLARE
  v_sql_text VARCHAR2(4000);
BEGIN
  -- Unreliable method to capture SQL, and only works for DML on this one table
  FOR r IN (SELECT sql_text FROM v$sql WHERE sql_id = (SELECT prev_sql_id FROM v$session WHERE audsid = USERENV('SESSIONID')))
  LOOP
    v_sql_text := r.sql_text;
    EXIT; -- Get the first one found
  END LOOP;
  INSERT INTO guardians.AppUserQueryLog (logTime, sqlText) VALUES (SYSTIMESTAMP, v_sql_text);
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
-- Answer: logging all SQL statements by an user performed in an entire dataset is a highly verbose and energy-consuming task because every tasks or query must be
-- informed in its body for logging and matched with all the allowed queries, imagine yourself doind that for every task and every user and every table.
-- Because all meaningful activities are objectified in the sense of security just attacks are meaningful to be logged and stored to see vulnerability patterns. Thus 
-- the firewall pattern gets all the patterns not presented in the Firewall capturing process. 