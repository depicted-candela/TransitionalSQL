-- Drop tables to ensure a clean slate for re-execution
DROP TABLE handling_complex_datatype.ProjectTeamJSON CASCADE CONSTRAINTS;
DROP TABLE handling_complex_datatype.CustomerFeedbackXML CASCADE CONSTRAINTS;
DROP TABLE handling_complex_datatype.ProjectDetails CASCADE CONSTRAINTS;
DROP TABLE handling_complex_datatype.CompanyEmployees CASCADE CONSTRAINTS;

-- 1. handling_complex_datatype.CompanyEmployees Table
CREATE TABLE handling_complex_datatype.CompanyEmployees (
    employeeId       NUMBER PRIMARY KEY,
    employeeName     VARCHAR2(100) NOT NULL,
    department       VARCHAR2(50),
    hireDate         DATE,
    salary           NUMBER(10, 2)
);

-- 2. handling_complex_datatype.ProjectDetails Table (Includes CLOB and BLOB)
CREATE TABLE handling_complex_datatype.ProjectDetails (
    projectId          NUMBER PRIMARY KEY,
    projectName        VARCHAR2(200) NOT NULL,
    projectStatus      VARCHAR2(20),
    startDate          DATE,
    endDate            DATE,
    projectDescription CLOB, -- For detailed project specifications (large text)
    projectDiagram     BLOB  -- For binary project diagrams or images (large binary)
);

-- 3. handling_complex_datatype.CustomerFeedbackXML Table (Includes XMLTYPE)
CREATE TABLE handling_complex_datatype.CustomerFeedbackXML (
    feedbackId         NUMBER PRIMARY KEY,
    projectId          NUMBER NOT NULL,
    feedbackData       XMLTYPE, -- For customer feedback in XML format
    submissionDate     TIMESTAMP,
    CONSTRAINT fkProjectFeedback FOREIGN KEY (projectId) REFERENCES handling_complex_datatype.ProjectDetails(projectId)
);

-- 4. handling_complex_datatype.ProjectTeamJSON Table (Includes JSON)
CREATE TABLE handling_complex_datatype.ProjectTeamJSON (
    assignmentId     NUMBER PRIMARY KEY,
    projectId        NUMBER NOT NULL,
    teamConfig       JSON, -- For flexible team configurations in JSON format
    assignedDate     DATE,
    CONSTRAINT fkProjectTeam FOREIGN KEY (projectId) REFERENCES handling_complex_datatype.ProjectDetails(projectId)
);

DROP SEQUENCE IF EXISTS employeeIdSeq;
DROP SEQUENCE IF EXISTS projectIdSeq;
DROP SEQUENCE IF EXISTS feedbackIdSeq;
DROP SEQUENCE IF EXISTS assignmentIdSeq;

-- Sequences for Primary Keys
CREATE SEQUENCE employeeIdSeq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE projectIdSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE feedbackIdSeq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE assignmentIdSeq START WITH 1 INCREMENT BY 1;

-- Populate handling_complex_datatype.CompanyEmployees
INSERT INTO handling_complex_datatype.CompanyEmployees (employeeId, employeeName, department, hireDate, salary) VALUES (employeeIdSeq.NEXTVAL, 'Alice Wonderland', 'Engineering', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 75000.00);
INSERT INTO handling_complex_datatype.CompanyEmployees (employeeId, employeeName, department, hireDate, salary) VALUES (employeeIdSeq.NEXTVAL, 'Bob The Builder', 'Operations', TO_DATE('2019-03-20', 'YYYY-MM-DD'), 60000.00);
INSERT INTO handling_complex_datatype.CompanyEmployees (employeeId, employeeName, department, hireDate, salary) VALUES (employeeIdSeq.NEXTVAL, 'Charlie Chaplin', 'Engineering', TO_DATE('2021-06-01', 'YYYY-MM-DD'), 80000.00);
INSERT INTO handling_complex_datatype.CompanyEmployees (employeeId, employeeName, department, hireDate, salary) VALUES (employeeIdSeq.NEXTVAL, 'Diana Prince', 'HR', TO_DATE('2018-11-10', 'YYYY-MM-DD'), 70000.00);
INSERT INTO handling_complex_datatype.CompanyEmployees (employeeId, employeeName, department, hireDate, salary) VALUES (employeeIdSeq.NEXTVAL, 'Eve Harrington', 'Engineering', TO_DATE('2022-02-28', 'YYYY-MM-DD'), 72000.00);
INSERT INTO handling_complex_datatype.CompanyEmployees (employeeId, employeeName, department, hireDate, salary) VALUES (employeeIdSeq.NEXTVAL, 'Frank Sinatra', 'Marketing', TO_DATE('2020-09-05', 'YYYY-MM-DD'), 65000.00);
INSERT INTO handling_complex_datatype.CompanyEmployees (employeeId, employeeName, department, hireDate, salary) VALUES (employeeIdSeq.NEXTVAL, 'Grace Hopper', 'Engineering', TO_DATE('2017-07-22', 'YYYY-MM-DD'), 95000.00);

-- Populate handling_complex_datatype.ProjectDetails (with CLOB and BLOB data)
-- For BLOB, we'll use UTL_RAW.CAST_TO_RAW for simple placeholder binary data.
INSERT INTO handling_complex_datatype.ProjectDetails (projectId, projectName, projectStatus, startDate, endDate, projectDescription, projectDiagram) VALUES (
    projectIdSeq.NEXTVAL,
    'E-commerce Platform Relaunch',
    'Completed',
    TO_DATE('2022-01-01', 'YYYY-MM-DD'),
    TO_DATE('2023-03-31', 'YYYY-MM-DD'),
    TO_CLOB('This project involved a complete overhaul and relaunch of the company''s existing e-commerce platform. Key features included a new user interface, improved backend scalability, integration with multiple payment gateways, and a revamped recommendation engine. The project aimed to enhance user experience, increase conversion rates, and support higher traffic volumes. It was a complex undertaking involving multiple teams and a phased deployment strategy. Extensive testing, including performance and security audits, was conducted throughout the development lifecycle.'),
    UTL_RAW.CAST_TO_RAW('4469616772616D41') -- 'DiagramA' in hex
);
INSERT INTO handling_complex_datatype.ProjectDetails (projectId, projectName, projectStatus, startDate, endDate, projectDescription, projectDiagram) VALUES (
    projectIdSeq.NEXTVAL,
    'Internal CRM System Upgrade',
    'In Progress',
    TO_DATE('2023-05-01', 'YYYY-MM-DD'),
    TO_DATE('2024-01-31', 'YYYY-MM-DD'),
    TO_CLOB('The CRM system upgrade focuses on migrating the legacy CRM application to a modern cloud-based solution. This includes data migration, custom module development for sales and support teams, and integration with existing marketing automation tools. A primary goal is to streamline customer interaction processes and provide better insights into customer data. User training and change management are significant components of this project.'),
    UTL_RAW.CAST_TO_RAW('4469616772616D42') -- 'DiagramB' in hex
);
INSERT INTO handling_complex_datatype.ProjectDetails (projectId, projectName, projectStatus, startDate, endDate, projectDescription, projectDiagram) VALUES (
    projectIdSeq.NEXTVAL,
    'Mobile App Development Phase 2',
    'On Hold',
    TO_DATE('2023-01-10', 'YYYY-MM-DD'),
    NULL, -- No end date yet
    TO_CLOB('Phase 2 of the mobile app development project involves adding advanced analytics features, push notification capabilities, and offline mode functionality. The initial phase focused on core user journeys. This phase aims to deepen user engagement and provide more personalized experiences. Technical challenges include optimizing data synchronization and ensuring cross-platform compatibility. The project is currently on hold pending resource allocation.'),
    UTL_RAW.CAST_TO_RAW('4469616772616D43') -- 'DiagramC' in hex
);
INSERT INTO handling_complex_datatype.ProjectDetails (projectId, projectName, projectStatus, startDate, endDate, projectDescription, projectDiagram) VALUES (
    projectIdSeq.NEXTVAL,
    'Data Warehouse Expansion',
    'Completed',
    TO_DATE('2021-08-01', 'YYYY-MM-DD'),
    TO_DATE('2022-05-15', 'YYYY-MM-DD'),
    TO_CLOB('This project expanded the existing data warehouse to incorporate new data sources from marketing automation and customer service platforms. It involved designing new ETL processes, optimizing data models for reporting, and enhancing data governance policies. The objective was to provide a more comprehensive view of customer data for business intelligence and strategic decision-making. Performance tuning of queries was also a key deliverable.'),
    UTL_RAW.CAST_TO_RAW('4469616772616D44') -- 'DiagramD' in hex
);

-- Populate handling_complex_datatype.CustomerFeedbackXML (with XMLTYPE data)
INSERT INTO handling_complex_datatype.CustomerFeedbackXML (feedbackId, projectId, feedbackData, submissionDate) VALUES (
    feedbackIdSeq.NEXTVAL,
    1,
    XMLTYPE('<Feedback>
        <CustomerId>C101</CustomerId>
        <CustomerName>Alice Johnson</CustomerName>
        <Rating>5</Rating>
        <Comments>
            <CommentSeq>1</CommentSeq>
            <Text>Excellent platform, very responsive and intuitive.</Text>
            <Category>Positive</Category>
        </Comments>
        <Comments>
            <CommentSeq>2</CommentSeq>
            <Text>Wish there were more filtering options on product listings.</Text>
            <Category>Suggestion</Category>
            <Issue>UI Filter</Issue>
        </Comments>
        <SuggestsImprovements>true</SuggestsImprovements>
    </Feedback>'),
    TO_TIMESTAMP('2023-04-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS')
);
INSERT INTO handling_complex_datatype.CustomerFeedbackXML (feedbackId, projectId, feedbackData, submissionDate) VALUES (
    feedbackIdSeq.NEXTVAL,
    1,
    XMLTYPE('<Feedback>
        <CustomerId>C102</CustomerId>
        <CustomerName>Bob Williams</CustomerName>
        <Rating>4</Rating>
        <Comments>
            <CommentSeq>1</CommentSeq>
            <Text>Good performance, but experienced a small bug during checkout.</Text>
            <Category>Issue</Category>
            <Issue>Checkout Bug</Issue>
        </Comments>
        <SuggestsImprovements>true</SuggestsImprovements>
    </Feedback>'),
    TO_TIMESTAMP('2023-04-06 14:15:00', 'YYYY-MM-DD HH24:MI:SS')
);
INSERT INTO handling_complex_datatype.CustomerFeedbackXML (feedbackId, projectId, feedbackData, submissionDate) VALUES (
    feedbackIdSeq.NEXTVAL,
    2,
    XMLTYPE('<Feedback>
        <CustomerId>C201</CustomerId>
        <CustomerName>Carol Davis</CustomerName>
        <Rating>3</Rating>
        <Comments>
            <CommentSeq>1</CommentSeq>
            <Text>The new CRM is slow. Data entry takes too much time.</Text>
            <Category>Critical</Category>
            <Issue>Performance</Issue>
        </Comments>
        <SuggestsImprovements>false</SuggestsImprovements>
    </Feedback>'),
    TO_TIMESTAMP('2023-09-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS')
);
INSERT INTO handling_complex_datatype.CustomerFeedbackXML (feedbackId, projectId, feedbackData, submissionDate) VALUES (
    feedbackIdSeq.NEXTVAL,
    3,
    XMLTYPE('<Feedback>
        <CustomerId>C301</CustomerId>
        <CustomerName>David Lee</CustomerName>
        <Rating>5</Rating>
        <Comments>
            <CommentSeq>1</CommentSeq>
            <Text>Excited for Phase 2! Mobile app is already great.</Text>
            <Category>Positive</Category>
        </Comments>
    </Feedback>'),
    TO_TIMESTAMP('2023-02-01 11:45:00', 'YYYY-MM-DD HH24:MI:SS')
);
INSERT INTO handling_complex_datatype.CustomerFeedbackXML (feedbackId, projectId, feedbackData, submissionDate) VALUES (
    feedbackIdSeq.NEXTVAL,
    2,
    XMLTYPE('<Feedback>
        <CustomerId>C202</CustomerId>
        <CustomerName>Eve Brown</CustomerName>
        <Rating>2</Rating>
        <Comments>
            <CommentSeq>1</CommentSeq>
            <Text>User interface is confusing and not intuitive at all.</Text>
            <Category>Critical</Category>
            <Issue>Usability</Issue>
        </Comments>
        <Comments>
            <CommentSeq>2</CommentSeq>
            <Text>Training materials are insufficient.</Text>
            <Category>Critical</Category>
            <Issue>Training</Issue>
        </Comments>
        <SuggestsImprovements>true</SuggestsImprovements>
    </Feedback>'),
    TO_TIMESTAMP('2023-10-15 16:20:00', 'YYYY-MM-DD HH24:MI:SS')
);
INSERT INTO handling_complex_datatype.CustomerFeedbackXML (feedbackId, projectId, feedbackData, submissionDate) VALUES (
    feedbackIdSeq.NEXTVAL,
    2,
    XMLTYPE('<Feedback submissionDate="2023-10-26" version="1.0">
        <CustomerId>C202</CustomerId>
        <CustomerName>Eve Brown</CustomerName>
        <Rating scale="1-5" type="overall_satisfaction">2</Rating>
        <Comments id="Cmt1" type="usability_feedback" status="new">
            <Text>User interface is confusing and not intuitive at all.</Text>
            <Category priority="high">Critical</Category>
            <Issue area="UI">Usability</Issue>
        </Comments>
        <Comments id="Cmt2" type="training_feedback" status="under_review">
            <Text>Training materials are insufficient.</Text>
            <Category priority="medium">Critical</Category>
            <Issue area="Documentation">Training</Issue>
        </Comments>
        <Comments id="Cmt3" type="feature_request" status="new">
            <Text>Consider adding a dark mode option.</Text>
            <Category priority="low">Feature</Category>
            <Issue area="Aesthetics">Display</Issue>
        </Comments>
        <SuggestsImprovements>true</SuggestsImprovements>
        </Feedback>'),
    TO_TIMESTAMP('2023-10-15 16:20:00', 'YYYY-MM-DD HH24:MI:SS')
);

-- Populate handling_complex_datatype.ProjectTeamJSON (with JSON data)
INSERT INTO handling_complex_datatype.ProjectTeamJSON (assignmentId, projectId, teamConfig, assignedDate) VALUES (
    assignmentIdSeq.NEXTVAL,
    1,
    JSON('{
      "teamLead": {"employeeId": 100, "name": "Alice Wonderland", "role": "Project Lead"},
      "members": [
        {"employeeId": 102, "name": "Charlie Chaplin", "role": "Backend Developer", "skills": ["Java", "Oracle", "Spring"]},
        {"employeeId": 104, "name": "Eve Harrington", "role": "Frontend Developer", "skills": ["React", "CSS", "TypeScript"]}
      ],
      "estimatedHours": 1200,
      "budgetStatus": "OnBudget"
    }'),
    TO_DATE('2022-01-05', 'YYYY-MM-DD')
);
INSERT INTO handling_complex_datatype.ProjectTeamJSON (assignmentId, projectId, teamConfig, assignedDate) VALUES (
    assignmentIdSeq.NEXTVAL,
    2,
    JSON('{
      "teamLead": {"employeeId": 102, "name": "Charlie Chaplin", "role": "Technical Lead"},
      "members": [
        {"employeeId": 100, "name": "Alice Wonderland", "role": "Data Analyst", "skills": ["SQL", "ETL"]},
        {"employeeId": 106, "name": "Grace Hopper", "role": "Senior Developer", "skills": ["Python", "Cloud", "API"]}
      ],
      "estimatedHours": 800,
      "budgetStatus": "OverBudget"
    }'),
    TO_DATE('2023-05-10', 'YYYY-MM-DD')
);
INSERT INTO handling_complex_datatype.ProjectTeamJSON (assignmentId, projectId, teamConfig, assignedDate) VALUES (
    assignmentIdSeq.NEXTVAL,
    3,
    JSON('{
      "teamLead": {"employeeId": 104, "name": "Eve Harrington", "role": "Mobile Lead"},
      "members": [
        {"employeeId": 106, "name": "Grace Hopper", "role": "UX/UI Designer", "skills": ["Figma", "Sketch"]}
      ],
      "estimatedHours": 600,
      "budgetStatus": "UnderBudget"
    }'),
    TO_DATE('2023-01-15', 'YYYY-MM-DD')
);

COMMIT;