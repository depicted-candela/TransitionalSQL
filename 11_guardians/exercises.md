<head>
    <link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/exercises.css">
</head>
<body>
    <div class="container">
        <h1>Guardians of Oracle: Security Features That Protect</h1>
        <h3>Study Chunk 11</h3>
        <h2>Introduction & Learning Objectives</h2>
        <p>
            Welcome to the practical exercises for <strong>Study Chunk 11: Guardians of Oracle</strong>. This module moves beyond standard <code>GRANT</code> and <code>REVOKE</code> commands to explore Oracle's powerful, built-in security features that allow you to create a robust, multi-layered defense directly within the database.
        </p>
        <p>
            For those transitioning from PostgreSQL, these exercises will highlight Oracle's unique, proactive security mechanisms. While PostgreSQL relies heavily on row-level security policies and external tools for advanced protection, you will practice Oracle's kernel-level features that offer a different and often more integrated approach to data protection.
        </p>
        <div class="oracle-specific">
            <p><strong>Learning Objectives:</strong></p>
            <ul>
                <li>Implement and manage <strong>Oracle SQL Firewall</strong> to create an allow-list of approved SQL, providing a first line of defense against SQL injection.</li>
                <li>Apply <strong>Data Redaction</strong> policies to dynamically mask sensitive data for specific user roles, without altering the underlying data.</li>
                <li>Configure and use <strong>Column-Level Auditing</strong> to create highly focused audit trails on critical data points, minimizing noise.</li>
                <li>Master the new 23ai <strong>Schema Privileges</strong> to grant broad, yet contained, access to application schemas, simplifying privilege management.</li>
                <li>Conceptually understand how <strong>Multicloud Authentication</strong> centralizes user management and enhances security.</li>
            </ul>
        </div>
        <h2>Prerequisites & Setup</h2>
        <p>
            Before beginning, ensure you have a solid understanding of the concepts from the preceding chunks, especially:
        </p>
        <ul>
            <li><strong>Chunk 1-3:</strong> Core Oracle SQL syntax, DML, and transaction control.</li>
            <li><strong>Chunk 5-8:</strong> PL/SQL fundamentals, including procedures and packages.</li>
            <li><strong>Chunk 10:</strong> Essential Oracle Database Concepts, particularly schema objects and the data dictionary.</li>
        </ul>
        <h3>Dataset Setup</h3>
        <p>
            The following exercises require a specific set of users and tables. Please connect to your Oracle 23ai database as a user with administrative privileges (such as <code>SYSTEM</code>) and execute the entire script block below. This will create the necessary users and the <code>guardians</code> and <code>operationsData</code> schemas with their respective tables.
        </p>
        <div class="caution">
            <p><strong>Important:</strong> You must run this setup script before attempting any of the exercises. The problems are designed to work with this specific dataset.</p>
        </div>
        <pre><code><span class="sql-comment">-- DCL for Main Schema and Supporting Users</span>
CREATE USER guardians IDENTIFIED BY YourSecurePassword_123;
GRANT CONNECT, RESOURCE, CREATE VIEW TO guardians;
ALTER USER guardians QUOTA UNLIMITED ON users;
CREATE USER appUser IDENTIFIED BY PwdForAppUser_01;
GRANT CONNECT, UNLIMITED TABLESPACE TO appUser;
CREATE USER analystUser IDENTIFIED BY PwdForAnalyst_02;
GRANT CONNECT TO analystUser;
CREATE USER devUser IDENTIFIED BY PwdForDevUser_03;
GRANT CONNECT TO devUser;
<span class="sql-comment">-- A highly privileged user to manage security features</span>
CREATE USER securityAdmin IDENTIFIED BY PwdForSecAdmin_04;
GRANT CONNECT,
      AUDIT_ADMIN,                    <span class="sql-comment">-- For managing audit policies</span>
      EXEMPT REDACTION POLICY,        <span class="sql-comment">-- To see original data, bypassing redaction</span>
      ADMINISTER SQL FIREWALL,        <span class="sql-comment">-- To manage SQL Firewall</span>
      CREATE ANY AUDIT POLICY,
      AUDIT_VIEWER TO securityAdmin;
<span class="sql-comment">-- Grant execute on required packages</span>
GRANT EXECUTE ON DBMS_REDACT TO securityAdmin;
GRANT EXECUTE ON DBMS_SQL_FIREWALL TO securityAdmin;
<span class="sql-comment">-- A schema to demonstrate schema-level privileges</span>
CREATE USER operationsData IDENTIFIED BY PwdForOpsData_05;
GRANT CONNECT, RESOURCE TO operationsData;
ALTER USER operationsData QUOTA UNLIMITED ON users;
GRANT CREATE TABLE TO operationsData; <span class="sql-comment">-- Allow this user to create new tables for the exercise</span>
<span class="sql-comment">-- Grant necessary base object privileges for setup</span>
GRANT SELECT ON guardians.SensitiveData TO analystUser;
GRANT SELECT, INSERT ON guardians.MissionLogs TO appUser;
GRANT SELECT, INSERT ON guardians.SensitiveData TO appUser;
COMMIT;
<span class="sql-comment">-- DDL for Table Structures (run as GUARDIANS)</span>
CONNECT guardians/YourSecurePassword_123;
CREATE TABLE SensitiveData (
    agentId NUMBER PRIMARY KEY,
    agentName VARCHAR2(100),
    socialSecurityNumber VARCHAR2(11) NOT NULL UNIQUE,
    salary NUMBER(10, 2),
    isCovert BOOLEAN, <span class="sql-comment">-- New 23ai data type</span>
    missionNotes CLOB
);
CREATE TABLE MissionLogs (
    logId NUMBER GENERATED ALWAYS AS IDENTITY,
    agentId NUMBER,
    logTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    logEntry VARCHAR2(4000),
    CONSTRAINT fkAgentId FOREIGN KEY (agentId) REFERENCES SensitiveData(agentId)
);
COMMIT;
<span class="sql-comment">-- DDL for operationsData schema (run as operationsData)</span>
CONNECT operationsData/PwdForOpsData_05;
CREATE TABLE SupplyInventory (
    supplyId NUMBER PRIMARY KEY,
    itemName VARCHAR2(100),
    quantity NUMBER
);
INSERT INTO SupplyInventory (supplyId, itemName, quantity) VALUES (1, 'Encrypted Communicator', 50);
INSERT INTO SupplyInventory (supplyId, itemName, quantity) VALUES (2, 'GPS Tracker', 200);
COMMIT;
<span class="sql-comment">-- DML for Populating Data (run as GUARDIANS)</span>
CONNECT guardians/YourSecurePassword_123;
INSERT INTO SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) VALUES (1, 'James Bond', '123-45-6789', 150000.00, FALSE, 'Notes on project Spectre.');
INSERT INTO SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) VALUES (2, 'Jason Bourne', '987-65-4321', 145000.00, TRUE, 'Treadstone asset details.');
INSERT INTO SensitiveData (agentId, agentName, socialSecurityNumber, salary, isCovert, missionNotes) VALUES (3, 'Evelyn Salt', '555-44-3322', 162000.00, TRUE, 'Deep cover operation notes.');
INSERT INTO MissionLogs(agentId, logEntry) VALUES (1, 'Initial briefing for Operation Skyfall complete.');
INSERT INTO MissionLogs(agentId, logEntry) VALUES (2, 'Acquired target package from Berlin safe house.');
COMMIT;
</code></pre>
        <hr>
        <h2>Let the Exercises Begin!</h2>
        <p>The following problems are designed to give you hands-on experience with Oracle's advanced security features. Attempt each one in your own environment before reviewing the solutions.</p>
        <!-- INSERTED EXERCISES START HERE -->
        <h3>Part 1: SQL Firewall: Kernel-Level Protection 🔥</h3>
        <h4>(i) Meanings, Values, Relations, and Advantages</h4>
        <h5><span class="problem-label">Problem 1.1:</span> Create and Enforce a Basic SQL Firewall Policy</h5>
        <p>
            The <code>appUser</code> is a service account for an application that should only ever insert into <code>MissionLogs</code>. It should never directly query the <code>SensitiveData</code> table. Your task is to create a SQL Firewall policy to enforce this behavior.
        </p>
        <ul>
            <li><strong>Step A (As <code>securityAdmin</code>):</strong> Enable SQL Firewall and start a "capture" session for the <code>appUser</code> to learn its normal behavior.</li>
            <li><strong>Step B (As <code>appUser</code>):</strong> Run the legitimate application query to populate the capture log.</li>
            <li><strong>Step C (As <code>securityAdmin</code>):</strong> Stop the capture, generate the allow-list, and enforce the policy in "BLOCK" mode.</li>
            <li><strong>Step D (As <code>appUser</code>):</strong> Verify that the legitimate query still works, but an unauthorized query (attempting to select from <code>SensitiveData</code>) is now blocked.</li>
        </ul>
        <div class="oracle-specific">
            <p><strong>Documentation Reference:</strong></p>
            For a deep dive into SQL Firewall concepts and the <code>DBMS_SQL_FIREWALL</code> package, consult the <a href="../books/oracle-database-sql-firewall-users-guide/03_ch01_overview-of-oracle-sql-firewall.pdf">Oracle SQL Firewall User's Guide, Chapter 1: Overview</a>.
        </div>
        <h4>(ii) Disadvantages and Pitfalls</h4>
        <h5><span class="problem-label">Problem 1.2:</span> The Pitfall of an Incomplete Capture</h5>
        <p>
            You have been asked to create a policy for <code>analystUser</code>. The analyst's only approved job is to query agent names. You run a quick capture session. However, you forget that the analyst also has a legitimate, but rarely used, query to count the total number of agents. Demonstrate the pitfall of enforcing a policy based on an incomplete capture.
        </p>
        <h4>(iii) Contrasting with Inefficient Common Solutions</h4>
        <h5><span class="problem-label">Problem 1.3:</span> The Inefficient Trigger-Based "Firewall"</h5>
        <p>
            Before SQL Firewall, a common (and inefficient) way to monitor queries was to use a DML trigger. Create a solution using a trigger that attempts to log all SQL run by <code>appUser</code>. After implementing it, consider why this is vastly inferior to SQL Firewall in terms of performance, completeness, and security.
        </p>
        <h3>Part 2: Data Redaction & Column-Level Auditing 🎭🕵️</h3>
        <h4>(i) Meanings, Values, Relations, and Advantages</h4>
        <h5><span class="problem-label">Problem 2.1:</span> Implement Data Redaction and Column-Level Auditing</h5>
        <p>
            Protect the sensitive data accessed by the <code>analystUser</code> while auditing access to critical notes.
        </p>
        <ul>
            <li><strong>Step A (As <code>securityAdmin</code>):</strong> Create a Data Redaction policy on the <code>guardians.SensitiveData</code> table. The policy must apply only to <code>analystUser</code> and should:
                <ol>
                    <li>Partially redact the <code>socialSecurityNumber</code> column to show only the last four digits (e.g., 'XXX-XX-6789').</li>
                    <li>Completely redact the <code>salary</code> column, showing only the number <code>0</code>.</li>
                </ol>
            </li>
            <li><strong>Step B (As <code>securityAdmin</code>):</strong> Create a Unified Audit Policy named <code>salary_access_audit</code> that audits any <code>SELECT</code> on the <code>guardians.SensitiveData.salary</code> column.</li>
            <li><strong>Step C (As <code>analystUser</code>):</strong> Query the <code>SensitiveData</code> table to see the redacted data.</li>
            <li><strong>Step D (As <code>securityAdmin</code>):</strong> Query the audit trail to see the record generated by the analyst's query.</li>
        </ul>
        <div class="oracle-specific">
            <p><strong>Documentation Reference:</strong></p>
            For the full syntax of Data Redaction policies and auditing, refer to the <a href="../books/database-security-guide/ch01_12-managing-security-for-application-developers.pdf">Security Guide, Chapter 12: Managing Security for Application Developers</a> and the <a href="../books/database-pl-sql-packages-and-types-reference/ch159_dbms_redact.pdf">DBMS_REDACT chapter in the PL/SQL Packages Reference</a>.
        </div>
        <h3>Part 3: Schema Privileges and Multicloud Authentication ✅☁️🔑</h3>
        <h4>(i) Meanings, Values, Relations, and Advantages</h4>
        <h5><span class="problem-label">Problem 3.1:</span> Using Schema Privileges</h5>
        <p>
            The <code>devUser</code> needs to be able to query any table in the <code>operationsData</code> schema, both now and in the future, for development and debugging purposes.
        </p>
        <ul>
            <li><strong>Step A (As <code>securityAdmin</code>):</strong> Grant the developer the appropriate schema-level privilege.</li>
            <li><strong>Step B (As <code>devUser</code>):</strong> Verify that the user can query the existing <code>SupplyInventory</code> table.</li>
            <li><strong>Step C (As <code>operationsData</code>):</strong> Create a <strong>new</strong> table in the <code>operationsData</code> schema.</li>
            <li><strong>Step D (As <code>devUser</code>):</strong> Verify that the user can <strong>immediately</strong> query the new table without any additional grants being issued. This demonstrates the key advantage.</li>
        </ul>
        <div class="postgresql-bridge">
            <p><strong>PostgreSQL Bridge:</strong> This single Oracle command, <code>GRANT SELECT ANY TABLE ON SCHEMA...</code>, is a more direct equivalent to the combination of PostgreSQL's <code>GRANT USAGE ON SCHEMA</code> and <code>ALTER DEFAULT PRIVILEGES</code>. It simplifies granting ongoing access to all of an application's tables.</p>
        </div>
        <h3>Part 4: Hardcore Combined Problem</h3>
        <h5><span class="problem-label">Problem 4.1:</span> The Guardians' Multi-Layered Defense Protocol</h5>
        <p>
            You are the lead security architect for the "Guardians" agency. You must implement a multi-layered security policy for a critical application. The application connects as <code>appUser</code>. Analysts connect as <code>analystUser</code>. A privileged security administrator, <code>securityAdmin</code>, oversees the configuration.
        </p>
        <p><strong>Requirements:</strong></p>
        <ol>
            <li>
                <strong>SQL Firewall:</strong> The <code>appUser</code> is only allowed to perform <code>INSERT</code> operations on <code>guardians.MissionLogs</code> and <code>SELECT</code> on <code>agentId</code> and <code>agentName</code> from <code>guardians.SensitiveData</code>. The application connects from the server at IP address <code>127.0.0.1</code>. All other SQL or connections from other IPs must be <strong>blocked and logged</strong>.
            </li>
            <li>
                <strong>Data Redaction:</strong> The <code>analystUser</code> must be able to query the <code>SensitiveData</code> table, but the data must be redacted as follows:
                <ul>
                    <li><code>socialSecurityNumber</code> must be partially redacted to show only the last 4 digits (e.g., 'XXX-XX-6789').</li>
                    <li><code>salary</code> must be completely redacted, showing only the number <code>0</code>.</li>
                    <li>The <code>isCovert</code> boolean column should be redacted to always show <code>TRUE</code>, regardless of its actual value.</li>
                    <li>This policy must <strong>only</strong> apply to the <code>analystUser</code>. The <code>appUser</code> should see the real data.</li>
                </ul>
            </li>
            <li>
                <strong>Column-Level Auditing:</strong> Create a policy to generate an audit record for <em>any</em> user (including <code>appUser</code> and <code>analystUser</code>) who successfully <code>SELECT</code>s the <code>missionNotes</code> (CLOB) column from the <code>SensitiveData</code> table.
            </li>
            <li>
                <strong>PL/SQL & Logic:</strong> The logic for enabling/disabling these policies should be encapsulated in a package named <code>security_policies</code> owned by <code>securityAdmin</code>.
            </li>
            <li>
                <strong>Test Plan:</strong> Create a test script that demonstrates the successful implementation of all security layers.
            </li>
        </ol>
        <!-- INSERTED EXERCISES END HERE -->
        <hr>
        <h2>Tips for Success & Learning</h2>
        <ul>
            <li><strong>Experiment:</strong> After solving a problem, try modifying it. What happens if you change a redaction type? What if the SQL Firewall policy is set to <code>LOG</code> instead of <code>BLOCK</code>?</li>
            <li><strong>Read the Manuals:</strong> The provided links are your best friends. The Oracle documentation is comprehensive and will often explain the "why" behind the syntax.</li>
            <li><strong>Understand the "Why":</strong> Don't just copy-paste the solutions. Make sure you understand why each command is used and what effect it has. This is crucial for applying these concepts to real-world job scenarios.</li>
        </ul>
        <h2>Conclusion & Next Steps</h2>
        <p>
            Congratulations on completing this intensive security module! You have now practiced some of the most powerful and modern security features that Oracle Database offers. By implementing defense-in-depth within the database itself, you can build far more secure and compliant applications.
        </p>
        <p>
            You are now ready to tackle the next phase of your Oracle journey. Prepare to dive into <strong>Study Chunk 12: Speed Unleashed: Oracle Indexing and Query Insights</strong>, where you will learn how to optimize the performance of the queries you've just learned to secure.
        </p>
    </div>
</body>