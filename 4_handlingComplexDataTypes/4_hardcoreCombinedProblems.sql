(iv) Hardcore Combined Problem

This problem integrates concepts from the current categories (CLOB/BLOB, XMLTYPE, JSON) with previously learned Oracle SQL features (date functions, string functions, ROWNUM, MERGE, hierarchical queries, analytic functions) and foundational PostgreSQL concepts (CTEs, joins, subqueries, aggregates).

Exercise 4.1: Comprehensive Project Analysis & Transformation

Problem: Your task is to perform a comprehensive analysis and transformation of project data, leveraging all your Oracle SQL skills up to this point.

Part A: Project Health & Feedback Analysis

Objective: For each project, calculate its average feedback rating and identify if it has any "Critical" feedback comments. Also, determine the total length of its projectDescription (CLOB).
Requirements:
Use a Common Table Expression (CTE) to first process CustomerFeedbackXML to extract feedback details (projectId, customerName, rating, and each comment's text and category). Identify comments with Category equal to 'Critical'.
Join this CTE with ProjectDetails.
For each project, select projectId, projectName, projectStatus.
Calculate averageRating (rounded to 2 decimal places) for each project.
Include a hasCriticalFeedback flag (VARCHAR2 'Yes'/'No') if any critical comments exist for the project.
Include descriptionLength (length of the CLOB projectDescription).
Filter results to include only projects that are 'Completed' or 'In Progress'.
Order the final result by averageRating (descending) and projectId.
Part B: Team Skill Gap Identification (JSON & Relational Integration)

Objective: Identify projects whose primary team lead (from JSON) has a certain skill (SQL) and where a project member (from JSON) lacks a specific skill (React).
Requirements:
Use JSON_TABLE to shred ProjectTeamJSON to get projectId, teamLeadId, teamLeadName, and all memberId, memberName, memberRole, and memberSkills (as a JSON array).
Join this with CompanyEmployees to get the department of the teamLead.
Filter for projects where the teamLead is in the 'Engineering' department.
Identify members whose role is 'Frontend Developer' but whose skills array does not contain 'React'. List these projects and members.
For the identified members, use ROW_NUMBER() (an analytic function) to assign a rank to them within their project based on their memberName (alphabetical).
Part C: Dynamic Project Status Update & XML Reporting

Objective: Update project statuses based on feedback and team configurations, and then generate a consolidated XML report.
Requirements:
Use the MERGE statement to update ProjectDetails.projectStatus.
Merge Condition: Update projects if their averageRating (from Part A's logic) is less than 3, change status to 'Needs Review'. OR if estimatedHours (from teamConfig JSON) is greater than 1000 AND budgetStatus is 'OverBudget', change status to 'Risk'. (If both conditions apply, 'Risk' takes precedence).
After the MERGE, generate a single XML document using XMLELEMENT, XMLFOREST, XMLAGG that summarizes all projects.
XML Structure: Root element AllProjectsReport. Each Project element should include projectId, projectName, projectStatus, hasCriticalFeedback (from Part A), and a TeamLeadDetails section (derived from ProjectTeamJSON using JSON_VALUE) containing teamLeadName and teamLeadRole.
Use SYSDATE in the XML for a reportGeneratedDate attribute on the root.
Part D: Hierarchical Feedback Comments (Revisited and Filtered)

Objective: Display feedback comments for a specific project hierarchically, using CONNECT BY.
Requirements:
Select all comments for projectId = 1.
Treat comments as having a conceptual parent-child relationship based on CommentSeq: CommentSeq N is a child of CommentSeq N-1.
Use CONNECT BY PRIOR and LEVEL to display the comments hierarchically.
Order the hierarchy by CommentSeq.
Include Text, Category, and Issue for each comment.