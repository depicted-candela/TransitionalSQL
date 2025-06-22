        -- Part 4: Hardcore Combined Problem


--      Problem 4.1: The Guardians' Multi-Layered Defense Protocol
-- You are the lead security architect for the "Guardians" agency. You must implement a multi-layered security policy for a critical 
-- application. The application connects as appUser. Analysts connect as analystUser. A privileged security administrator, securityAdmin, 
-- oversees the configuration.

-- -- Requirements:

-- -- SQL Firewall: The appUser is only allowed to perform INSERT operations on guardians.MissionLogs and SELECT on agentId and agentName 
-- -- from guardians.SensitiveData. The application connects from the server at IP address 127.0.0.1. All other SQL or connections from 
-- -- other IPs must be blocked and logged.
-- -- CONNECT SECURITYADMIN/PwdForSecAdmin_04;
-- EXEC DBMS_SQL_FIREWALL.ENABLE;
-- EXEC DBMS_SQL_FIREWALL.CREATE_CAPTURE(username => 'APPUSER');

-- CONNECT ANALYSTUSER/PwdForAnalyst_02;
-- INSERT INTO GUARDIANS.MISSIONLOGS(AGENTID, LOGENTRY) VALUES (3, 'Hardcore entry');
-- SELECT AGENTNAME FROM GUARDIANS.SENSITIVEDATA;

-- CONNECT SECURITYADMIN/PwdForSecAdmin_04;
-- BEGIN
--   DBMS_SQL_FIREWALL.STOP_CAPTURE(username => 'APPUSER');
--   DBMS_SQL_FIREWALL.GENERATE_ALLOW_LIST('APPUSER');
--   DBMS_SQL_FIREWALL.ENABLE_ALLOW_LIST(username => 'APPUSER', enforce => DBMS_SQL_FIREWALL.ENFORCE_SQL, block = TRUE);
--   DBMS_SQL_FIREWALL.ADD_ALLOWED_CONTEXT(
--           username => 'APPUSER',
--           context_type => DBMS_SQL_FIREWALL.IP_ADDRESS,
--           value => '127.0.0.1'
--   );
--   DBMS_SQL_FIREWALL.APPEND_ALLOW_LIST(username => 'APPUSER', source => DBMS_SQL_FIREWALL.ALL_LOGS);
-- END;
-- /

-- -- -- Data Redaction: The analystUser must be able to query the SensitiveData table, but the data must be redacted as follows:
-- -- -- socialSecurityNumber must be partially redacted to show only the last 4 digits (e.g., 'XXX-XX-6789').
-- -- -- salary must be completely redacted, showing only the number 0.
-- -- -- The isCovert boolean column should be redacted to always show TRUE, regardless of its actual value.
-- -- -- This policy must only apply to the analystUser. The appUser should see the real data.
-- CONNECT SECURITYADMIN/PwdForSecAdmin_04;
-- BEGIN
--   DBMS_REDACT.ADD_POLICY(
--           object_schema         => 'GUARDIANS',
--           object_name           => 'SENSITIVEDATA',
--           policy_name           => 'SENSITIVE_DATA_REDACTION_HARDCORE_POLICY',
--           expression            => 'SYS_CONTEXT(''USERENV'', ''SESSION_USER'') = ''ANALYSTUSER''',
--           column_name           => 'SOCIALSECURITYNUMBER',
--           function_type         => DBMS_REDACT.PARTIAL,
--           function_parameters   => 'VVVFVVFVVVV,VVV|VV|VVVV,*,1,5'
--   );
--   DBMS_REDACT.ALTER_POLICY(
--           object_schema         => 'GUARDIANS',
--           object_name           => 'SENSITIVEDATA',
--           policy_name           => 'SENSITIVE_DATA_REDACTION_HARDCORE_POLICY',
--           action                => DBMS_REDACT.ADD_COLUMN,
--           column_name           => 'SALARY',
--           function_type         => DBMS_REDACT.FULL,
--           function_parameters   => '0'
--   );
--   DBMS_REDACT.ALTER_POLICY(
--           object_schema         => 'GUARDIANS',
--           object_name           => 'SENSITIVEDATA',
--           policy_name           => 'SENSITIVE_DATA_REDACTION_HARDCORE_POLICY',
--           action                => DBMS_REDACT.ADD_COLUMN,
--           column_name           => 'ISCOVERT',
--           function_type         => DBMS_REDACT.FULL,
--           function_parameters   => 'TRUE'
--   );
-- END;
-- -- -- Column-Level Auditing: Create a policy to generate an audit record for any user (including appUser and analystUser) who successfully 
-- -- -- SELECTs the missionNotes (CLOB) column from the SensitiveData table.
-- CREATE AUDIT POLICY generalized_audit_record ACTIONS SELECT(missionNotes) ON GUARDIANS.SENSITIVEDATA;
-- AUDIT POLICY generalized_audit_record BY APPUSER, ANALYSTUSER WHENEVER SUCCESSFUL;


-- PL/SQL & Logic: The logic for enabling/disabling these policies should be encapsulated in a package named security_policies owned by 
-- securityAdmin.


PROMPT --- +++++++++++++++++++++++++++++++++++++++++++++
CONNECT securityAdmin/PwdForSecAdmin_04;

CREATE OR REPLACE PACKAGE security_policies AS 
  PROCEDURE enable_sql_firewall;
  PROCEDURE enable_redaction_firewall;
  PROCEDURE enable_columnar_firewall;

  PROCEDURE disable_sql_firewall;
  PROCEDURE disable_redaction_firewall;
  PROCEDURE disable_columnar_firewall;

  PROCEDURE apply_all_policies;
  PROCEDURE remove_all_policies;
END security_policies;
/

CREATE OR REPLACE PACKAGE BODY security_policies AS

  PROCEDURE enable_sql_firewall IS
  BEGIN
    DBMS_SQL_FIREWALL.ENABLE;
    DBMS_SQL_FIREWALL.CREATE_CAPTURE(username => 'APPUSER');
  END;

  PROCEDURE enable_redaction_firewall IS
  BEGIN
    -- Requirement: Redact SSN to show only the last 4 digits.
    DBMS_REDACT.ADD_POLICY(
      object_schema         => 'GUARDIANS',
      object_name           => 'SENSITIVEDATA',
      policy_name           => 'HARDCORE_DATA_REDACTION_POLICY',
      expression            => 'SYS_CONTEXT(''USERENV'', ''SESSION_USER'') = ''ANALYSTUSER''',
      column_name           => 'SOCIALSECURITYNUMBER',
      function_type         => DBMS_REDACT.PARTIAL,
      function_parameters   => 'VVVFVVFVVVV,VVV|VV|VVVV,*,1,5'
    );
    
    -- Requirement: Redact SALARY to 0.
    DBMS_REDACT.ALTER_POLICY(
      object_schema         => 'GUARDIANS',
      object_name           => 'SENSITIVEDATA',
      policy_name           => 'HARDCORE_DATA_REDACTION_POLICY',
      action                => DBMS_REDACT.ADD_COLUMN,
      column_name           => 'SALARY',
      function_type         => DBMS_REDACT.FULL
    );

    -- Requirement: Redact isCovert to always show 'TRUE'.
    DBMS_REDACT.ALTER_POLICY(
      object_schema         => 'GUARDIANS',
      object_name           => 'SENSITIVEDATA',
      policy_name           => 'HARDCORE_DATA_REDACTION_POLICY',
      action                => DBMS_REDACT.ADD_COLUMN,
      column_name           => 'ISCOVERT',
      function_type         => DBMS_REDACT.REGEXP,
      regexp_pattern        => '^.*$',
      regexp_replace_string => 'TRUE'
    );
  END;

  PROCEDURE enable_columnar_firewall IS
  BEGIN

    EXECUTE IMMEDIATE 'CREATE AUDIT POLICY generalized_audit_record ACTIONS SELECT(MISSIONNOTES) ON GUARDIANS.SENSITIVEDATA';
    EXECUTE IMMEDIATE 'AUDIT POLICY generalized_audit_record WHENEVER SUCCESSFUL';

  END;

  PROCEDURE disable_sql_firewall IS
  BEGIN
    DBMS_SQL_FIREWALL.DISABLE_ALLOW_LIST(username => 'APPUSER');
    DBMS_SQL_FIREWALL.DROP_ALLOW_LIST(username => 'APPUSER');
    DBMS_SQL_FIREWALL.DROP_CAPTURE(username => 'APPUSER');
    DBMS_SQL_FIREWALL.DISABLE;
  END;

  PROCEDURE disable_redaction_firewall IS
  BEGIN
    DBMS_REDACT.DROP_POLICY(object_schema => 'GUARDIANS', object_name => 'SENSITIVEDATA', policy_name => 'HARDCORE_DATA_REDACTION_POLICY');
  END;

  PROCEDURE disable_columnar_firewall IS
  BEGIN
    EXECUTE IMMEDIATE 'NOAUDIT POLICY generalized_audit_record';
    EXECUTE IMMEDIATE 'DROP AUDIT POLICY generalized_audit_record';
  END;

  PROCEDURE apply_all_policies IS
  BEGIN
    enable_sql_firewall;
    enable_redaction_firewall;
    enable_columnar_firewall;
  END apply_all_policies;

  PROCEDURE remove_all_policies IS
  BEGIN
    -- Added error handling for a cleaner teardown
    BEGIN disable_sql_firewall(); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN disable_redaction_firewall(); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN disable_columnar_firewall(); EXCEPTION WHEN OTHERS THEN NULL; END;
  END remove_all_policies;

END security_policies;
/

-- This will now execute successfully because all required privileges are in place.
BEGIN
  SECURITY_POLICIES.apply_all_policies();
END;
/

PROMPT --- Policies partially applied unless the SQL FIREWALL

CONNECT appUser/PwdForAppUser_01;
INSERT INTO GUARDIANS.MISSIONLOGS(AGENTID, LOGENTRY) VALUES (3, 'Hardcore entry');
SELECT AGENTNAME FROM GUARDIANS.SENSITIVEDATA;

CONNECT SECURITYADMIN/PwdForSecAdmin_04;
BEGIN
  DBMS_SQL_FIREWALL.STOP_CAPTURE(username => 'APPUSER');
  DBMS_SQL_FIREWALL.GENERATE_ALLOW_LIST('APPUSER');
  DBMS_SQL_FIREWALL.ENABLE_ALLOW_LIST(username => 'APPUSER', enforce => DBMS_SQL_FIREWALL.ENFORCE_SQL, block => TRUE);
  DBMS_SQL_FIREWALL.ADD_ALLOWED_CONTEXT(
    username => 'APPUSER',
    context_type => DBMS_SQL_FIREWALL.IP_ADDRESS,
    value => '127.0.0.1'
  );
END;
/

PROMPT --- Policies applied, NOW TESTING
-- VERIFICATION STAGE --
-- Verification 1 (SUCCESS): appUser runs allowed operations
CONNECT appUser/PwdForAppUser_01;
INSERT INTO guardians.MissionLogs(agentId, logEntry) VALUES (2, 'Another valid log.'); -- Succeeds
SELECT agentId, agentName FROM guardians.SensitiveData WHERE agentId = 2; -- Succeeds
-- Verification 2 (FAILURE): appUser attempts an unauthorized query
SELECT missionNotes FROM guardians.SensitiveData WHERE agentId = 1;
-- ORA-47605: SQL Firewall violation
-- Verification 3 (REDACTION): analystUser queries the data
CONNECT analystUser/PwdForAnalyst_02;
SELECT agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes FROM guardians.SensitiveData;
-- Expect redacted SSN, salary=0, isCovert=TRUE, and visible missionNotes
-- Verification 4 (AUDIT): securityAdmin checks the audit trail for missionNotes access
CONNECT securityAdmin/PwdForSecAdmin_04;
-- Wait a moment for audit trail to flush
SELECT dbusername, action_name, sql_text
FROM UNIFIED_AUDIT_TRAIL
WHERE unified_audit_policies = 'NOTES_ACCESS_AUDIT'
  AND dbusername = 'ANALYSTUSER'
ORDER BY event_timestamp DESC
FETCH FIRST 1 ROWS ONLY;
-- Should show the analyst's SELECT statement.
-- Final Cleanup (as securityAdmin)
CONNECT securityAdmin/PwdForSecAdmin_04;


PROMPT --- Removing policies
EXEC SECURITY_POLICIES.remove_all_policies();