-- Main Dataset for 23ai SQL Features
SET SERVEROUTPUT ON;

-- Recreate the user for a clean slate
BEGIN
    EXECUTE IMMEDIATE 'DROP USER future CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/

CREATE USER future IDENTIFIED BY YourPassword;
-- Grant essential roles and privileges
GRANT CONNECT, RESOURCE, AQ_ADMINISTRATOR_ROLE TO future;
ALTER USER future QUOTA UNLIMITED ON USERS;
GRANT CREATE TYPE, CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE TO future;
GRANT EXECUTE ON DBMS_AQADM TO future;
GRANT EXECUTE ON DBMS_AQ TO future;

CREATE TABLE future.employees (
    employeeId      NUMBER PRIMARY KEY,
    firstName       VARCHAR2(50),
    lastName        VARCHAR2(50),
    departmentId    NUMBER,
    salary          NUMBER(10, 2),
    hireDate        DATE
);

CREATE TABLE future.departments (
    departmentId    NUMBER PRIMARY KEY,
    departmentName  VARCHAR2(100),
    locationCity    VARCHAR2(100)
);

CREATE TABLE future.performanceReviews (
    reviewId        NUMBER PRIMARY KEY,
    employeeId      NUMBER,
    reviewDate      DATE,
    reviewScore     VARCHAR2(20)
);

CREATE TABLE future.archivedEmployees (
    employeeId      NUMBER,
    lastName        VARCHAR2(50),
    archiveDate     DATE
);

CREATE TABLE future.regionalSales (
    region          VARCHAR2(50),
    product         VARCHAR2(50),
    salesAmount     NUMBER(12, 2)
);

CREATE TABLE future.projectTasks (
    taskId        NUMBER PRIMARY KEY,
    taskName      VARCHAR2(100),
    isCompleted   BOOLEAN,
    startDate     TIMESTAMP,
    endDate       TIMESTAMP
);

CREATE TABLE future.hcEmployees (
    employeeId      NUMBER,
    employeeName    VARCHAR2(100),
    departmentId    NUMBER,
    salary          NUMBER(10, 2),
    isActive        BOOLEAN
);
CREATE TABLE future.hcDepartments (
departmentId    NUMBER,
departmentName  VARCHAR2(100)
);


CREATE TABLE future.hcProjects (
projectId       NUMBER,
projectName     VARCHAR2(100),
startDate       TIMESTAMP,
endDate         TIMESTAMP,
budget          NUMBER
);


CREATE TABLE future.hcAssignments (
employeeId      NUMBER,
projectId       NUMBER
);

-- Populate Data
INSERT INTO future.departments VALUES (10, 'Sales', 'New York');
INSERT INTO future.departments VALUES (20, 'Engineering', 'San Francisco');
INSERT INTO future.departments VALUES (30, 'HR', 'New York');

INSERT INTO future.employees VALUES (101, 'Alice', 'Smith', 10, 75000, DATE '2022-01-15');
INSERT INTO future.employees VALUES (102, 'Bob', 'Johnson', 10, 80000, DATE '2021-03-22');
INSERT INTO future.employees VALUES (103, 'Charlie', 'Williams', 20, 120000, DATE '2020-05-10');
INSERT INTO future.employees VALUES (104, 'Diana', 'Brown', 30, 65000, DATE '2023-07-01');

INSERT INTO future.performanceReviews VALUES (1, 101, DATE '2023-12-20', 'Good');
INSERT INTO future.performanceReviews VALUES (2, 102, DATE '2023-12-21', 'Below Average');
INSERT INTO future.performanceReviews VALUES (3, 103, DATE '2023-12-15', 'Excellent');
INSERT INTO future.performanceReviews VALUES (4, 104, DATE '2023-12-22', 'Good');

INSERT INTO future.regionalSales VALUES ('North', 'Gadget', 1500);
INSERT INTO future.regionalSales VALUES ('North', 'Widget', 2200);
INSERT INTO future.regionalSales VALUES ('South', 'Gadget', 1800);
INSERT INTO future.regionalSales VALUES ('South', 'Widget', 3100);
INSERT INTO future.regionalSales VALUES ('North', 'Gadget', 1600);

INSERT INTO future.projectTasks VALUES (1, 'Initial Analysis',      TRUE,  TIMESTAMP '2023-01-10 09:00:00', TIMESTAMP '2023-01-15 17:00:00');
INSERT INTO future.projectTasks VALUES (2, 'Design Phase',        TRUE,  TIMESTAMP '2023-01-16 09:00:00', TIMESTAMP '2023-01-28 18:00:00');
INSERT INTO future.projectTasks VALUES (3, 'Development Sprint 1',  TRUE,  TIMESTAMP '2023-02-01 09:00:00', TIMESTAMP '2023-02-14 17:30:00');
INSERT INTO future.projectTasks VALUES (4, 'Development Sprint 2',  FALSE, TIMESTAMP '2023-02-15 09:00:00', NULL);
INSERT INTO future.projectTasks VALUES (5, 'Testing',               FALSE, TIMESTAMP '2023-03-01 09:00:00', NULL);
INSERT INTO future.projectTasks VALUES (6, 'Documentation',         TRUE,  TIMESTAMP '2023-01-20 10:00:00', TIMESTAMP '2023-02-20 12:00:00');

INSERT INTO future.hcDepartments VALUES (100, 'Innovation');
INSERT INTO future.hcDepartments VALUES (200, 'Logistics');


INSERT INTO future.hcEmployees VALUES (1, 'John Doe', 100, 90000, TRUE);
INSERT INTO future.hcEmployees VALUES (2, 'Jane Smith', 100, 95000, TRUE);
INSERT INTO future.hcEmployees VALUES (3, 'Peter Jones', 200, 80000, FALSE);


INSERT INTO future.hcProjects VALUES (1001, 'Quantum Leap', TIMESTAMP '2023-01-15 00:00:00', TIMESTAMP '2023-04-20 00:00:00', 50000);
INSERT INTO future.hcProjects VALUES (1002, 'Project Phoenix', TIMESTAMP '2023-05-01 00:00:00', TIMESTAMP '2023-11-10 00:00:00', 150000);
INSERT INTO future.hcProjects VALUES (1003, 'Helios Initiative', TIMESTAMP '2023-06-22 00:00:00', NULL, 250000);


INSERT INTO future.hcAssignments VALUES (1, 1001);
INSERT INTO future.hcAssignments VALUES (1, 1002);
INSERT INTO future.hcAssignments VALUES (2, 1002);
INSERT INTO future.hcAssignments VALUES (2, 1003);

COMMIT;