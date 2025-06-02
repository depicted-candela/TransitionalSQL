-- Oracle SQL DDL and DML for PL/SQL Fundamentals Lecture Examples

-- Drop tables if they exist to ensure a clean setup
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlawakeninglecture.orderItems';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlawakeninglecture.salesOrders';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlawakeninglecture.salesLog';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlawakeninglecture.products';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlawakeninglecture.employees';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlawakeninglecture.departments';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlawakeninglecture.jobGrades';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/


-- DDL: Create Tables

CREATE TABLE plsqlawakeninglecture.departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    location VARCHAR2(100)
);

COMMENT ON TABLE plsqlawakeninglecture.departments IS 'Stores department information.';
COMMENT ON COLUMN plsqlawakeninglecture.departments.departmentId IS 'Primary key for plsqlawakeninglecture.departments.';
COMMENT ON COLUMN plsqlawakeninglecture.departments.departmentName IS 'Name of the department.';
COMMENT ON COLUMN plsqlawakeninglecture.departments.location IS 'Location of the department.';


CREATE TABLE plsqlawakeninglecture.employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    hireDate DATE,
    jobTitle VARCHAR2(100),
    salary NUMBER(10, 2) CHECK (salary > 0),
    commissionPct NUMBER(4, 2), -- Percentage, e.g., 0.10 for 10%
    departmentId NUMBER,
    isActive BOOLEAN DEFAULT TRUE, -- Oracle 23ai BOOLEAN type
    CONSTRAINT fkEmployeesDepartment FOREIGN KEY (departmentId) REFERENCES plsqlawakeninglecture.departments(departmentId)
);

COMMENT ON TABLE plsqlawakeninglecture.employees IS 'Stores employee information.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.employeeId IS 'Primary key for plsqlawakeninglecture.employees.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.firstName IS 'First name of the employee.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.lastName IS 'Last name of the employee.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.email IS 'Email address of the employee, must be unique.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.hireDate IS 'Date when the employee was hired.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.jobTitle IS 'Job title of the employee.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.salary IS 'Monthly salary of the employee.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.commissionPct IS 'Commission percentage for sales plsqlawakeninglecture.employees.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.departmentId IS 'Foreign key linking to the plsqlawakeninglecture.departments table.';
COMMENT ON COLUMN plsqlawakeninglecture.employees.isActive IS 'Indicates if the employee account is currently active (Oracle 23ai BOOLEAN).';


CREATE TABLE plsqlawakeninglecture.jobGrades (
    gradeLevel VARCHAR2(2) PRIMARY KEY,
    lowestSal NUMBER(10, 2),
    highestSal NUMBER(10, 2)
);
COMMENT ON TABLE plsqlawakeninglecture.jobGrades IS 'Defines salary ranges for different job grade levels.';

CREATE TABLE plsqlawakeninglecture.products (
    productId NUMBER PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    category VARCHAR2(50),
    unitPrice NUMBER(8, 2) CHECK (unitPrice >= 0),
    stockQuantity NUMBER DEFAULT 0 CHECK (stockQuantity >= 0)
);
COMMENT ON TABLE plsqlawakeninglecture.products IS 'Stores product information.';

CREATE TABLE plsqlawakeninglecture.salesLog (
    logId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    logMessage VARCHAR2(255),
    logTime TIMESTAMP DEFAULT SYSTIMESTAMP
);
COMMENT ON TABLE plsqlawakeninglecture.salesLog IS 'Simple log table for recording PL/SQL actions.';

CREATE TABLE plsqlawakeninglecture.salesOrders (
    orderId NUMBER PRIMARY KEY,
    customerId NUMBER, -- Assuming customer IDs exist elsewhere or are simple numbers
    orderDate DATE DEFAULT SYSDATE,
    orderStatus VARCHAR2(20) CHECK (orderStatus IN ('Pending', 'Shipped', 'Completed', 'Cancelled'))
);
COMMENT ON TABLE plsqlawakeninglecture.salesOrders IS 'Stores sales order header information.';

CREATE TABLE plsqlawakeninglecture.orderItems (
    orderItemId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    orderId NUMBER NOT NULL,
    productId NUMBER NOT NULL,
    quantity NUMBER NOT NULL CHECK (quantity > 0),
    pricePerUnit NUMBER(8, 2) NOT NULL, -- Price at the time of sale
    CONSTRAINT fkOrderItemsOrder FOREIGN KEY (orderId) REFERENCES plsqlawakeninglecture.salesOrders(orderId),
    CONSTRAINT fkOrderItemsProduct FOREIGN KEY (productId) REFERENCES plsqlawakeninglecture.products(productId)
);
COMMENT ON TABLE plsqlawakeninglecture.orderItems IS 'Stores line items for each sales order.';


-- DML: Populate Tables

-- Populate plsqlawakeninglecture.departments
INSERT INTO plsqlawakeninglecture.departments (departmentId, departmentName, location) VALUES (10, 'ADMINISTRATION', 'New York');
INSERT INTO plsqlawakeninglecture.departments (departmentId, departmentName, location) VALUES (20, 'MARKETING', 'London');
INSERT INTO plsqlawakeninglecture.departments (departmentId, departmentName, location) VALUES (30, 'SALES', 'Chicago');
INSERT INTO plsqlawakeninglecture.departments (departmentId, departmentName, location) VALUES (40, 'IT', 'Bengaluru');
INSERT INTO plsqlawakeninglecture.departments (departmentId, departmentName, location) VALUES (50, 'FINANCE', 'New York');

-- Populate plsqlawakeninglecture.employees
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (101, 'John', 'Smith', 'john.smith@example.com', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 'Clerk', 50000, NULL, 10, TRUE);
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (102, 'Jane', 'Doe', 'jane.doe@example.com', TO_DATE('2019-05-20', 'YYYY-MM-DD'), 'Sales Manager', 80000, 0.10, 30, TRUE);
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (103, 'Peter', 'Jones', 'peter.jones@example.com', TO_DATE('2021-08-01', 'YYYY-MM-DD'), 'Developer', 72000, NULL, 40, TRUE);
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (104, 'Alice', 'Brown', 'alice.brown@example.com', TO_DATE('2022-03-10', 'YYYY-MM-DD'), 'Marketing Specialist', 60000, 0.05, 20, FALSE); -- Inactive employee
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (105, 'Robert', 'Davis', 'robert.davis@example.com', TO_DATE('2018-11-01', 'YYYY-MM-DD'), 'IT Manager', 95000, NULL, 40, TRUE);
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (106, 'Emily', 'White', 'emily.white@example.com', TO_DATE('2023-01-20', 'YYYY-MM-DD'), 'Sales Representative', 55000, 0.15, 30, TRUE);
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (107, 'Michael', 'Green', 'michael.green@example.com', TO_DATE('2019-07-01', 'YYYY-MM-DD'), 'Developer', 78000, NULL, 40, TRUE);
INSERT INTO plsqlawakeninglecture.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (108, 'Sarah', 'Black', 'sarah.black@example.com', TO_DATE('2021-02-28', 'YYYY-MM-DD'), 'Accountant', 62000, NULL, 50, TRUE);


-- Populate Job Grades
INSERT INTO plsqlawakeninglecture.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('A', 30000, 50000);
INSERT INTO plsqlawakeninglecture.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('B', 50001, 70000);
INSERT INTO plsqlawakeninglecture.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('C', 70001, 90000);
INSERT INTO plsqlawakeninglecture.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('D', 90001, 120000);

-- Populate plsqlawakeninglecture.products
INSERT INTO plsqlawakeninglecture.products (productId, productName, category, unitPrice, stockQuantity) VALUES (1, 'Omega Laptop', 'Electronics', 1200.00, 50);
INSERT INTO plsqlawakeninglecture.products (productId, productName, category, unitPrice, stockQuantity) VALUES (2, 'Alpha Mouse', 'Electronics', 25.00, 200);
INSERT INTO plsqlawakeninglecture.products (productId, productName, category, unitPrice, stockQuantity) VALUES (3, 'Comfort Chair', 'Furniture', 150.00, 30);
INSERT INTO plsqlawakeninglecture.products (productId, productName, category, unitPrice, stockQuantity) VALUES (4, 'Bright Desk Lamp', 'Furniture', 45.00, 0); -- Out of stock
INSERT INTO plsqlawakeninglecture.products (productId, productName, category, unitPrice, stockQuantity) VALUES (5, 'Standard Keyboard', 'Electronics', 75.00, 120);

-- Populate Sales Orders
INSERT INTO plsqlawakeninglecture.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1001, 201, TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Shipped');
INSERT INTO plsqlawakeninglecture.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1002, 202, TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Pending');
INSERT INTO plsqlawakeninglecture.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1003, 201, TO_DATE('2023-10-10', 'YYYY-MM-DD'), 'Completed');
INSERT INTO plsqlawakeninglecture.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1004, 203, TO_DATE('2023-10-12', 'YYYY-MM-DD'), 'Pending');

-- Populate Order Items
INSERT INTO plsqlawakeninglecture.orderItems (orderId, productId, quantity, pricePerUnit) VALUES (1001, 1, 1, 1200.00);
INSERT INTO plsqlawakeninglecture.orderItems (orderId, productId, quantity, pricePerUnit) VALUES (1001, 2, 2, 25.00);
INSERT INTO plsqlawakeninglecture.orderItems (orderId, productId, quantity, pricePerUnit) VALUES (1002, 3, 1, 150.00);
INSERT INTO plsqlawakeninglecture.orderItems (orderId, productId, quantity, pricePerUnit) VALUES (1003, 2, 5, 24.00); -- Discounted price
INSERT INTO plsqlawakeninglecture.orderItems (orderId, productId, quantity, pricePerUnit) VALUES (1003, 5, 1, 70.00); -- Different price for same product on different order
INSERT INTO plsqlawakeninglecture.orderItems (orderId, productId, quantity, pricePerUnit) VALUES (1004, 1, 1, 1150.00);

COMMIT;