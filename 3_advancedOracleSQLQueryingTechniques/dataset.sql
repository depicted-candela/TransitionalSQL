-- Drop tables if they exist (for easy re-running of script)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE advanced_querying.EmployeeUpdates';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE advanced_querying.Employees';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE advanced_querying.Departments';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Create advanced_querying.Departments Table
CREATE TABLE advanced_querying.Departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(50) NOT NULL,
    locationCity VARCHAR2(50)
);

-- Create advanced_querying.Employees Table
CREATE TABLE advanced_querying.Employees (
    employeeId NUMBER PRIMARY KEY,
    employeeName VARCHAR2(100) NOT NULL,
    jobTitle VARCHAR2(50),
    managerId NUMBER,
    hireDate DATE,
    salary NUMBER(10, 2),
    departmentId NUMBER,
    email VARCHAR2(100) UNIQUE,
    CONSTRAINT fkManager FOREIGN KEY (managerId) REFERENCES advanced_querying.Employees(employeeId),
    CONSTRAINT fkDepartment FOREIGN KEY (departmentId) REFERENCES advanced_querying.Departments(departmentId)
);

-- Create advanced_querying.EmployeeUpdates Staging Table (for MERGE)
CREATE TABLE advanced_querying.EmployeeUpdates (
    employeeId NUMBER,
    employeeName VARCHAR2(100),
    jobTitle VARCHAR2(50),
    managerId NUMBER,
    hireDate DATE,
    salary NUMBER(10, 2),
    departmentId NUMBER,
    email VARCHAR2(100),
    changeReason VARCHAR2(100) -- To describe the update
);

-- Populate advanced_querying.Departments
INSERT INTO advanced_querying.Departments (departmentId, departmentName, locationCity) VALUES (10, 'Technology', 'New York');
INSERT INTO advanced_querying.Departments (departmentId, departmentName, locationCity) VALUES (20, 'Sales', 'London');
INSERT INTO advanced_querying.Departments (departmentId, departmentName, locationCity) VALUES (30, 'HR', 'New York');
INSERT INTO advanced_querying.Departments (departmentId, departmentName, locationCity) VALUES (40, 'Finance', 'Chicago');

-- Populate advanced_querying.Employees
-- Top Level
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (100, 'Sarah Connor', 'CEO', NULL, TO_DATE('2010-01-15', 'YYYY-MM-DD'), 250000, 10, 'sconnor@example.com');

-- Technology Department (Manager: Sarah Connor)
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (101, 'John Smith', 'CTO', 100, TO_DATE('2012-03-01', 'YYYY-MM-DD'), 180000, 10, 'jsmith@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (102, 'Alice Brown', 'Lead Developer', 101, TO_DATE('2015-06-10', 'YYYY-MM-DD'), 120000, 10, 'abrown@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (103, 'Bob Green', 'Senior Developer', 102, TO_DATE('2017-09-20', 'YYYY-MM-DD'), 100000, 10, 'bgreen@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (104, 'Carol White', 'Junior Developer', 102, TO_DATE('2022-07-01', 'YYYY-MM-DD'), 70000, 10, 'cwhite@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (105, 'David Black', 'DBA', 101, TO_DATE('2016-02-15', 'YYYY-MM-DD'), 110000, 10, 'dblack@example.com');

-- Sales Department (Manager: Sarah Connor)
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (201, 'Eve Adams', 'Sales Director', 100, TO_DATE('2013-05-01', 'YYYY-MM-DD'), 170000, 20, 'eadams@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (202, 'Frank Miller', 'Sales Manager', 201, TO_DATE('2018-11-01', 'YYYY-MM-DD'), 90000, 20, 'fmiller@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (203, 'Grace Davis', 'Sales Rep', 202, TO_DATE('2021-03-12', 'YYYY-MM-DD'), 60000, 20, 'gdavis@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (204, 'Henry Wilson', 'Sales Rep', 202, TO_DATE('2021-03-12', 'YYYY-MM-DD'), 60000, 20, 'hwilson@example.com'); -- Same salary and hire date for ranking demo

-- HR Department (Manager: Sarah Connor)
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (301, 'Ivy Clark', 'HR Director', 100, TO_DATE('2014-08-01', 'YYYY-MM-DD'), 160000, 30, 'iclark@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (302, 'Jack Lewis', 'HR Specialist', 301, TO_DATE('2019-01-10', 'YYYY-MM-DD'), 75000, 30, 'jlewis@example.com');

-- Finance Department (Manager: Sarah Connor, but Finance is separate)
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (401, 'Kyle Roberts', 'CFO', 100, TO_DATE('2011-07-01', 'YYYY-MM-DD'), 190000, 40, 'kroberts@example.com');
INSERT INTO advanced_querying.Employees (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email)
VALUES (402, 'Laura King', 'Finance Analyst', 401, TO_DATE('2020-02-20', 'YYYY-MM-DD'), 85000, 40, 'lking@example.com');


-- Populate advanced_querying.EmployeeUpdates for MERGE exercises
-- Row for existing employee update
INSERT INTO advanced_querying.EmployeeUpdates (employeeId, employeeName, jobTitle, salary, departmentId, email, changeReason)
VALUES (103, 'Bob Green', 'Senior Developer II', 105000, 10, 'bgreen.updated@example.com', 'Promotion');
-- Row for new employee insert
INSERT INTO advanced_querying.EmployeeUpdates (employeeId, employeeName, jobTitle, managerId, hireDate, salary, departmentId, email, changeReason)
VALUES (501, 'Nina Young', 'Intern', 102, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 40000, 10, 'nyoung@example.com', 'New Hire');
-- Row for existing employee, conditional update (e.g., only if salary increases)
INSERT INTO advanced_querying.EmployeeUpdates (employeeId, employeeName, jobTitle, salary, departmentId, email, changeReason)
VALUES (203, 'Grace Davis', 'Senior Sales Rep', 65000, 20, 'gdavis.promo@example.com', 'Performance Raise');
-- Row for existing employee, but no actual change in salary initially (for MERGE update condition testing)
INSERT INTO advanced_querying.EmployeeUpdates (employeeId, salary, changeReason)
VALUES (204, 60000, 'Salary Review - No Change');
-- Row that could cause ORA-30926 if source is not distinct for MERGE pitfall exercise
INSERT INTO advanced_querying.EmployeeUpdates (employeeId, salary, changeReason)
VALUES (105, 112000, 'DBA Adjustment 1');
INSERT INTO advanced_querying.EmployeeUpdates (employeeId, salary, changeReason)
VALUES (105, 115000, 'DBA Adjustment 2');

COMMIT;