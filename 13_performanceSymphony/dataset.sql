-- Run this part as SYS or a user with DBA privileges
DROP USER performanceSymphony CASCADE;
CREATE USER performanceSymphony IDENTIFIED BY YourPassword;
GRANT CONNECT, RESOURCE, DBA TO performanceSymphony;
ALTER USER performanceSymphony QUOTA UNLIMITED ON USERS;

-- Connect as the performanceSymphony user to create the objects
-- conn performanceSymphony/YourPassword

CREATE TABLE performanceSymphony.employees (
    employeeId      NUMBER(6) NOT NULL,
    firstName       VARCHAR2(20),
    lastName        VARCHAR2(25) NOT NULL,
    email           VARCHAR2(25) NOT NULL,
    jobId           VARCHAR2(10) NOT NULL,
    salary          NUMBER(8,2),
    managerId       NUMBER(6),
    departmentId    NUMBER(4),
    status          VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    hireDate        DATE NOT NULL
);

CREATE TABLE performanceSymphony.departments (
    departmentId    NUMBER(4) NOT NULL,
    departmentName  VARCHAR2(30) NOT NULL,  
    locationId      NUMBER(4)
);

CREATE TABLE performanceSymphony.jobHistory (
    employeeId      NUMBER(6) NOT NULL,
    startDate       DATE NOT NULL,
    endDate         DATE NOT NULL,
    jobId           VARCHAR2(10) NOT NULL,
    departmentId    NUMBER(4)
);

-- Populate with data to illustrate performance concepts

-- performanceSymphony.departments Table
INSERT INTO performanceSymphony.departments VALUES (10, 'Administration', 1700);
INSERT INTO performanceSymphony.departments VALUES (20, 'Marketing', 1800);
INSERT INTO performanceSymphony.departments VALUES (30, 'Purchasing', 1700);
INSERT INTO performanceSymphony.departments VALUES (40, 'Human Resources', 2400);
INSERT INTO performanceSymphony.departments VALUES (50, 'Shipping', 1500);
INSERT INTO performanceSymphony.departments VALUES (60, 'IT', 1400);
INSERT INTO performanceSymphony.departments VALUES (70, 'Public Relations', 1700);
INSERT INTO performanceSymphony.departments VALUES (80, 'Sales', 2500);
INSERT INTO performanceSymphony.departments VALUES (90, 'Executive', 1700);
INSERT INTO performanceSymphony.departments VALUES (100, 'Finance', 1700);
INSERT INTO performanceSymphony.departments VALUES (110, 'Accounting', 1700);
INSERT INTO performanceSymphony.departments VALUES (120, 'Treasury', 1700);
INSERT INTO performanceSymphony.departments VALUES (130, 'Corporate Tax', 1700);
INSERT INTO performanceSymphony.departments VALUES (140, 'Control And Credit', 1700);
INSERT INTO performanceSymphony.departments VALUES (150, 'Shareholder Services', 1700);
INSERT INTO performanceSymphony.departments VALUES (160, 'Benefits', 1700);
INSERT INTO performanceSymphony.departments VALUES (170, 'Manufacturing', 1700);
INSERT INTO performanceSymphony.departments VALUES (180, 'Construction', 1700);
INSERT INTO performanceSymphony.departments VALUES (190, 'Contracting', 1700);
INSERT INTO performanceSymphony.departments VALUES (200, 'Operations', 1700);
INSERT INTO performanceSymphony.departments VALUES (210, 'IT Support', 1700);
INSERT INTO performanceSymphony.departments VALUES (220, 'NOC', 1700);
INSERT INTO performanceSymphony.departments VALUES (230, 'IT Helpdesk', 1700);
INSERT INTO performanceSymphony.departments VALUES (240, 'Government Sales', 1700);
INSERT INTO performanceSymphony.departments VALUES (250, 'Retail Sales', 1700);
INSERT INTO performanceSymphony.departments VALUES (260, 'Recruiting', 1700);
INSERT INTO performanceSymphony.departments VALUES (270, 'Payroll', 1700);

-- performanceSymphony.employees Table
-- Skewed data: a large number of performanceSymphony.employees are 'SA_REP'
BEGIN
    FOR i IN 1..2000 LOOP
        INSERT INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, departmentId, status, hireDate)
        VALUES (i, 'John'||i, 'Doe'||i, 'JDOE'||i, 'SA_REP', 6000 + (10*i), 80, 'ACTIVE', TO_DATE('2022-01-01', 'YYYY-MM-DD') + i);
    END LOOP;
    INSERT INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, status, hireDate)
    VALUES (2001, 'Jane', 'Smith', 'JSMITH', 'IT_PROG', 9000, NULL, 60, 'ACTIVE', TO_DATE('2021-05-15', 'YYYY-MM-DD'));
    INSERT INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, status, hireDate)
    VALUES (2002, 'Peter', 'Jones', 'PJONES', 'IT_PROG', 8500, NULL, 60, 'ACTIVE', TO_DATE('2020-03-20', 'YYYY-MM-DD'));
    INSERT INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, status, hireDate)
    VALUES (2003, 'Mary', 'Jane', 'MJANE', 'MK_MAN', 14000, NULL, 20, 'ACTIVE', TO_DATE('2019-11-10', 'YYYY-MM-DD'));
    INSERT INTO performanceSymphony.employees (employeeId, firstName, lastName, email, jobId, salary, managerId, departmentId, status, hireDate)
    VALUES (2004, 'Manager', 'Case', 'MCASE', 'SA_MAN', 15000, NULL, 80, 'active', TO_DATE('2018-01-01', 'YYYY-MM-DD'));
END;
/

COMMIT;