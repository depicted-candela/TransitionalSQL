-- Drop tables if they exist (for re-runnability)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.EmployeeUpdatesForMerge';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.AuditLog';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.ProjectAssignments';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.Projects';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.Employees';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.Departments';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.ProductCatalogA';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE essential_functions_dmlbasics.ProductCatalogB';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
-- essential_functions_dmlbasics.Departments Table
CREATE TABLE essential_functions_dmlbasics.Departments (
   departmentId NUMBER PRIMARY KEY,
   departmentName VARCHAR2(100) NOT NULL,
   locationCity VARCHAR2(50)
);


-- essential_functions_dmlbasics.Employees Table
CREATE TABLE essential_functions_dmlbasics.Employees (
employeeId NUMBER PRIMARY KEY,
firstName VARCHAR2(50) NOT NULL,
lastName VARCHAR2(50) NOT NULL,
email VARCHAR2(100) UNIQUE,
jobTitle VARCHAR2(100),
hireDate DATE,
birthDate DATE,
salary NUMBER(10, 2),
commissionPct NUMBER(4, 2),
departmentId NUMBER,
managerId NUMBER,
CONSTRAINT fk_emp_department FOREIGN KEY (departmentId) REFERENCES essential_functions_dmlbasics.Departments(departmentId),
CONSTRAINT fk_emp_manager FOREIGN KEY (managerId) REFERENCES essential_functions_dmlbasics.Employees(employeeId)
);


-- essential_functions_dmlbasics.Projects Table
CREATE TABLE essential_functions_dmlbasics.Projects (
projectId NUMBER PRIMARY KEY,
projectName VARCHAR2(100) NOT NULL,
startDate DATE,
endDate DATE,
deadlineTimestamp TIMESTAMP,
projectStatus VARCHAR2(20) DEFAULT 'Pending'
);


-- essential_functions_dmlbasics.ProjectAssignments Table
CREATE TABLE essential_functions_dmlbasics.ProjectAssignments (
assignmentId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
projectId NUMBER NOT NULL,
employeeId NUMBER NOT NULL,
assignmentDate DATE DEFAULT SYSDATE,
role VARCHAR2(50),
CONSTRAINT fk_pa_project FOREIGN KEY (projectId) REFERENCES essential_functions_dmlbasics.Projects(projectId),
CONSTRAINT fk_pa_employee FOREIGN KEY (employeeId) REFERENCES essential_functions_dmlbasics.Employees(employeeId),
CONSTRAINT uk_project_employee UNIQUE (projectId, employeeId)
);


-- essential_functions_dmlbasics.ProductCatalogA Table
CREATE TABLE essential_functions_dmlbasics.ProductCatalogA (
productId VARCHAR2(10) PRIMARY KEY,
productName VARCHAR2(100) NOT NULL,
category VARCHAR2(50),
listPrice NUMBER(8,2)
);


-- essential_functions_dmlbasics.ProductCatalogB Table
CREATE TABLE essential_functions_dmlbasics.ProductCatalogB (
productId VARCHAR2(10) PRIMARY KEY,
productName VARCHAR2(100) NOT NULL,
category VARCHAR2(50),
listPrice NUMBER(8,2)
);


-- essential_functions_dmlbasics.AuditLog Table
CREATE TABLE essential_functions_dmlbasics.AuditLog (
logId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
tableName VARCHAR2(100),
operationType VARCHAR2(10), -- INSERT, UPDATE, DELETE
operationTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
userId VARCHAR2(30) DEFAULT USER,
details CLOB
);


-- essential_functions_dmlbasics.EmployeeUpdatesForMerge Table (Source for MERGE)
CREATE TABLE essential_functions_dmlbasics.EmployeeUpdatesForMerge (
employeeId NUMBER PRIMARY KEY,
newJobTitle VARCHAR2(100),
newSalary NUMBER(10, 2),
newDepartmentId NUMBER
);

-- Dataset Population (DML)

-- Populate essential_functions_dmlbasics.Departments
INSERT INTO essential_functions_dmlbasics.Departments (departmentId, departmentName, locationCity) VALUES (10, 'Technology', 'New York');
INSERT INTO essential_functions_dmlbasics.Departments (departmentId, departmentName, locationCity) VALUES (20, 'Human Resources', 'London');
INSERT INTO essential_functions_dmlbasics.Departments (departmentId, departmentName, locationCity) VALUES (30, 'Sales', 'Paris');
INSERT INTO essential_functions_dmlbasics.Departments (departmentId, departmentName, locationCity) VALUES (40, 'Marketing', 'New York');
-- Populate essential_functions_dmlbasics.Employees
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (101, 'Alice', 'Smith', 'alice.smith@example.com', 'DBA', TO_DATE('2020-01-15', 'YYYY-MM-DD'), TO_DATE('1990-05-20', 'YYYY-MM-DD'), 90000, 0.10, 10, NULL);
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (102, 'Bob', 'Johnson', 'bob.johnson@example.com', 'Developer', TO_DATE('2019-03-01', 'YYYY-MM-DD'), TO_DATE('1985-08-15', 'YYYY-MM-DD'), 80000, NULL, 10, 101);
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (103, 'Carol', 'Williams', 'carol.w@example.com', 'HR Manager', TO_DATE('2021-07-22', 'YYYY-MM-DD'), TO_DATE('1992-11-30', 'YYYY-MM-DD'), 75000, 0.05, 20, NULL);
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (104, 'David', 'Brown', 'david.b@example.com', 'Sales Lead', TO_DATE('2018-05-10', 'YYYY-MM-DD'), TO_DATE('1980-02-25', 'YYYY-MM-DD'), 95000, 0.15, 30, NULL); -- Salary is 95000
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (105, 'Eve', 'Davis', 'eve.davis@example.com', 'Marketing Specialist', TO_DATE('2022-01-10', 'YYYY-MM-DD'), TO_DATE('1995-07-07', 'YYYY-MM-DD'), 65000, NULL, 40, NULL);
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (106, 'Frank', 'Miller', 'frank.miller@example.com', ' Developer ', TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('1998-01-10', 'YYYY-MM-DD'), 70000, 0.02, 10, 102);
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId)
VALUES (107, 'Grace', 'Wilson', 'grace.w@example.com', 'Sales Intern', TO_DATE('2023-08-15', 'YYYY-MM-DD'), TO_DATE('2000-03-12', 'YYYY-MM-DD'), 40000, NULL, 30, 104);
INSERT INTO essential_functions_dmlbasics.Employees (employeeId, firstName, lastName, email, jobTitle, hireDate, birthDate, salary, commissionPct, departmentId, managerId) -- Added for Hardcore problem
VALUES (109, 'Kevin', 'Spacey', 'kevin.s@example.com', 'Senior Developer', TO_DATE('2019-07-01', 'YYYY-MM-DD'), TO_DATE('1988-04-10', 'YYYY-MM-DD'), 82000, NULL, 10, 101);


-- Populate essential_functions_dmlbasics.Projects
INSERT INTO essential_functions_dmlbasics.Projects (projectId, projectName, startDate, endDate, deadlineTimestamp, projectStatus)
VALUES (1, 'Omega System Upgrade', TO_DATE('2023-01-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-12-31 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'In Progress');
INSERT INTO essential_functions_dmlbasics.Projects (projectId, projectName, startDate, endDate, deadlineTimestamp, projectStatus)
VALUES (2, 'New Website Launch', TO_DATE('2023-03-01', 'YYYY-MM-DD'), TO_DATE('2023-09-30', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-09-30 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');
INSERT INTO essential_functions_dmlbasics.Projects (projectId, projectName, startDate, deadlineTimestamp, projectStatus)
VALUES (3, 'Mobile App Development', TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-05-31 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pending');
INSERT INTO essential_functions_dmlbasics.Projects (projectId, projectName, startDate, endDate, deadlineTimestamp, projectStatus)
VALUES (4, 'Data Warehouse Migration', TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2023-05-30', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-05-30 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');


-- Populate essential_functions_dmlbasics.ProjectAssignments
INSERT INTO essential_functions_dmlbasics.ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (1, 101, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Lead DBA');
INSERT INTO essential_functions_dmlbasics.ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (1, 102, TO_DATE('2023-01-20', 'YYYY-MM-DD'), 'Senior Developer');
INSERT INTO essential_functions_dmlbasics.ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (2, 105, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Marketing Lead');
INSERT INTO essential_functions_dmlbasics.ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (3, 102, TO_DATE('2023-06-05', 'YYYY-MM-DD'), 'Lead Developer');
INSERT INTO essential_functions_dmlbasics.ProjectAssignments (projectId, employeeId, assignmentDate, role) VALUES (3, 106, TO_DATE('2023-06-10', 'YYYY-MM-DD'), 'Junior Developer');


-- Populate essential_functions_dmlbasics.ProductCatalogA
INSERT INTO essential_functions_dmlbasics.ProductCatalogA (productId, productName, category, listPrice) VALUES ('ORA101', 'Oracle Database 21c', 'Software', 5000);
INSERT INTO essential_functions_dmlbasics.ProductCatalogA (productId, productName, category, listPrice) VALUES ('ORA102', 'Oracle WebLogic Server', 'Software', 3000);
INSERT INTO essential_functions_dmlbasics.ProductCatalogA (productId, productName, category, listPrice) VALUES ('SRV201', 'Dell PowerEdge R750', 'Hardware', 7500);
INSERT INTO essential_functions_dmlbasics.ProductCatalogA (productId, productName, category, listPrice) VALUES ('BK001', 'Oracle SQL Performance Tuning', 'Book', 70);


-- Populate essential_functions_dmlbasics.ProductCatalogB
INSERT INTO essential_functions_dmlbasics.ProductCatalogB (productId, productName, category, listPrice) VALUES ('ORA101', 'Oracle Database 21c', 'Software', 4950); -- Different Price
INSERT INTO essential_functions_dmlbasics.ProductCatalogB (productId, productName, category, listPrice) VALUES ('SRV201', 'Dell PowerEdge R750', 'Hardware', 7500);
INSERT INTO essential_functions_dmlbasics.ProductCatalogB (productId, productName, category, listPrice) VALUES ('PGSQL10', 'PostgreSQL Advanced Server', 'Software', 2500);
INSERT INTO essential_functions_dmlbasics.ProductCatalogB (productId, productName, category, listPrice) VALUES ('BK002', 'PostgreSQL Administration Guide', 'Book', 60);


-- Populate essential_functions_dmlbasics.EmployeeUpdatesForMerge
INSERT INTO essential_functions_dmlbasics.EmployeeUpdatesForMerge (employeeId, newJobTitle, newSalary, newDepartmentId) VALUES (102, 'Senior Software Engineer', 85000, 10); -- Existing employee, update
INSERT INTO essential_functions_dmlbasics.EmployeeUpdatesForMerge (employeeId, newJobTitle, newSalary, newDepartmentId) VALUES (106, 'Software Engineer', 72000, 10); -- Existing employee, update salary
INSERT INTO essential_functions_dmlbasics.EmployeeUpdatesForMerge (employeeId, newJobTitle, newSalary, newDepartmentId) VALUES (108, 'Data Analyst', 60000, 10); -- New employee, insert
COMMIT;