-- Drop tables if they exist to ensure a clean setup
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlprecision.salaryAudit';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlprecision.employees';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlprecision.departments';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

-- Create tables
CREATE TABLE plsqlprecision.departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    location VARCHAR2(100)
);

CREATE TABLE plsqlprecision.employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    hireDate DATE,
    jobId VARCHAR2(50),
    salary NUMBER(10, 2),
    departmentId NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (departmentId) REFERENCES plsqlprecision.departments(departmentId)
);

CREATE TABLE plsqlprecision.salaryAudit (
    auditId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employeeId NUMBER,
    oldSalary NUMBER(10,2),
    newSalary NUMBER(10,2),
    changeDate TIMESTAMP DEFAULT SYSTIMESTAMP,
    changedBy VARCHAR2(100),
    notes VARCHAR2(255)
);

-- Populate tables
INSERT INTO plsqlprecision.departments (departmentId, departmentName, location) VALUES (10, 'Administration', 'New York');
INSERT INTO plsqlprecision.departments (departmentId, departmentName, location) VALUES (20, 'Marketing', 'London');
INSERT INTO plsqlprecision.departments (departmentId, departmentName, location) VALUES (30, 'IT', 'Berlin');
INSERT INTO plsqlprecision.departments (departmentId, departmentName, location) VALUES (40, 'Human Resources', 'New York');
INSERT INTO plsqlprecision.departments (departmentId, departmentName, location) VALUES (50, 'Sales', 'London');

INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (101, 'Alice', 'Smith', 'asmith@example.com', DATE '2020-01-15', 'ADMIN_ASST', 50000, 10);
INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (102, 'Bob', 'Johnson', 'bjohnson@example.com', DATE '2019-03-01', 'MKT_REP', 60000, 20);
INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (103, 'Carol', 'Williams', 'cwilliams@example.com', DATE '2021-07-20', 'IT_PROG', 75000, 30);
INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (104, 'David', 'Brown', 'dbrown@example.com', DATE '2018-05-10', 'HR_REP', 55000, 40);
INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (105, 'Eve', 'Davis', 'edavis@example.com', DATE '2022-01-30', 'IT_PROG', 80000, 30);
INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (106, 'Frank', 'Miller', 'fmiller@example.com', DATE '2020-11-01', 'SALES_REP', 65000, 50);
INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (107, 'Grace', 'Wilson', 'gwilson@example.com', DATE '2023-02-01', 'SALES_REP', 70000, 50);
INSERT INTO plsqlprecision.employees (employeeId, firstName, lastName, email, hireDate, jobId, salary, departmentId) VALUES (108, 'Henry', 'Moore', 'hmoore@example.com', DATE '2019-08-15', 'IT_ANALYST', 90000, 30);

COMMIT;