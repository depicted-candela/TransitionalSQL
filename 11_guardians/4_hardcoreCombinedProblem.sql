        -- Part 4: Hardcore Combined Problem


--      Problem 4.1: The Guardians' Multi-Layered Defense Protocol
-- You are the lead security architect for the "Guardians" agency. You must implement a multi-layered security policy for a critical application. The application connects as appUser. Analysts connect as analystUser. A privileged security administrator, securityAdmin, oversees the configuration.

-- Requirements:

-- SQL Firewall: The appUser is only allowed to perform INSERT operations on guardians.MissionLogs and SELECT on agentId and agentName from guardians.SensitiveData. The application connects from the server at IP address 127.0.0.1. All other SQL or connections from other IPs must be blocked and logged.
-- Data Redaction: The analystUser must be able to query the SensitiveData table, but the data must be redacted as follows:
-- socialSecurityNumber must be partially redacted to show only the last 4 digits (e.g., 'XXX-XX-6789').
-- salary must be completely redacted, showing only the number 0.
-- The isCovert boolean column should be redacted to always show TRUE, regardless of its actual value.
-- This policy must only apply to the analystUser. The appUser should see the real data.
-- Column-Level Auditing: Create a policy to generate an audit record for any user (including appUser and analystUser) who successfully SELECTs the missionNotes (CLOB) column from the SensitiveData table.
-- PL/SQL & Logic: The logic for enabling/disabling these policies should be encapsulated in a package named security_policies owned by securityAdmin.
-- Test Plan: Create a test script that demonstrates the successful implementation of all security layers.
