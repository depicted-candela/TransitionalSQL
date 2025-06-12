The Grand Finale: A Hardcore Combined Problem
This final challenge requires you to integrate all the concepts from this section—JavaScript MLE, DBMS_LOB, DBMS_AQ, UTL_FILE, and legacy packages—along with previous course knowledge like hierarchical queries and transaction control.

Problem: Automated Employee Onboarding & Auditing
You are tasked with building a new, automated employee onboarding and auditing system. The process involves multiple steps:

JavaScript Validation & Processing: An HR system provides new employee data as a JSON object. Create a JavaScript function processNewHire that validates the JSON (must contain firstName, lastName, and a valid email) and calculates a firstYearBonus which is 10% of the salary. The function should return a new JSON object containing the original data plus the calculated bonus.
PL/SQL Orchestration: Create a PL/SQL procedure onboardEmployee that accepts the new hire JSON as a CLOB.
It should first call the processNewHire JS function to validate and enrich the data.
If successful, it must insert the new employee into the employees table.
It must then generate a multi-line welcome letter as a CLOB using DBMS_LOB. The letter should include the employee's full name and their management chain, retrieved via a hierarchical query (CONNECT BY).
Legacy XML Archival: For compliance with a legacy system, the welcome letter CLOB must be converted to an XML document using the deprecated DBMS_XMLGEN package. The root element should be and each line should be in a element.
Asynchronous Messaging: The generated XML CLOB must then be enqueued into an onboardingArchiveQueue using DBMS_AQ for a separate archival process to handle.
Server-Side Logging: Finally, the onboardEmployee procedure must write a summary log message to the server file onboarding.log using UTL_FILE, recording the new employee's ID and the message ID of the enqueued AQ message.