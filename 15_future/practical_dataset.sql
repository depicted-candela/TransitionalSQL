-- Main Dataset for 23ai SQL Features
SET SERVEROUTPUT ON;

-- Recreate the user for a clean slate
BEGIN
    EXECUTE IMMEDIATE 'DROP USER practical_future CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/

CREATE USER practical_future IDENTIFIED BY YourPassword;
-- Grant essential roles and privileges
GRANT CONNECT, RESOURCE, AQ_ADMINISTRATOR_ROLE TO practical_future;
ALTER USER practical_future QUOTA UNLIMITED ON USERS;
GRANT CREATE TYPE, CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE TO practical_future;
GRANT EXECUTE ON DBMS_AQADM TO practical_future;
GRANT EXECUTE ON DBMS_AQ TO practical_future;

CREATE TABLE practical_future.employees (
    employeeId      NUMBER PRIMARY KEY,
    firstName       VARCHAR2(50),
    lastName        VARCHAR2(50),
    departmentId    NUMBER,
    salary          NUMBER(10, 2),
    hireDate        DATE
);

CREATE TABLE practical_future.departments (
    departmentId    NUMBER PRIMARY KEY,
    departmentName  VARCHAR2(100),
    locationCity    VARCHAR2(100)
);

CREATE TABLE practical_future.projectTasks (
    taskId        NUMBER PRIMARY KEY,
    taskName      VARCHAR2(100),
    isCompleted   BOOLEAN, -- New 23ai Feature
    startDate     TIMESTAMP,
    endDate       TIMESTAMP
);

CREATE TABLE practical_future.archivedEmployees (
    employeeId      NUMBER,
    lastName        VARCHAR2(50),
    archiveDate     DATE
);

-- Populate Data
INSERT INTO practical_future.departments VALUES (10, 'Sales', 'New York');
INSERT INTO practical_future.departments VALUES (20, 'Engineering', 'San Francisco');

INSERT INTO practical_future.employees VALUES (101, 'Alice', 'Smith', 10, 75000, DATE '2022-01-15');
INSERT INTO practical_future.employees VALUES (102, 'Bob', 'Johnson', 10, 80000, DATE '2021-03-22');
INSERT INTO practical_future.employees VALUES (103, 'Charlie', 'Williams', 20, 120000, DATE '2020-05-10');

INSERT INTO practical_future.projectTasks VALUES (1, 'Initial Analysis', TRUE, TIMESTAMP '2023-01-10 09:00:00', TIMESTAMP '2023-01-15 17:00:00');
INSERT INTO practical_future.projectTasks VALUES (2, 'Design Phase', TRUE, TIMESTAMP '2023-01-16 09:00:00', TIMESTAMP '2023-01-28 18:00:00');
INSERT INTO practical_future.projectTasks VALUES (3, 'Development Sprint 1', FALSE, TIMESTAMP '2023-02-01 09:00:00', NULL);

COMMIT;