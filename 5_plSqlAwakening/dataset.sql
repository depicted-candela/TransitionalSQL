
-- plsqlawakening.departments Table
CREATE TABLE plsqlawakening.departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    locationCity VARCHAR2(100) -- Renamed from 'location' for clarity
);

-- plsqlawakening.employees Table
CREATE TABLE plsqlawakening.employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    hireDate DATE,
    jobTitle VARCHAR2(100),
    salary NUMBER(10, 2) CHECK (salary > 0),
    commissionPct NUMBER(4, 2) CHECK (commissionPct >= 0 AND commissionPct < 1), -- Commission as a percentage
    departmentId NUMBER,
    isActive BOOLEAN DEFAULT TRUE, -- Oracle 23ai BOOLEAN type
    CONSTRAINT fkEmployeesDepartment FOREIGN KEY (departmentId) REFERENCES plsqlawakening.departments(departmentId)
);

-- Job Grades Table (for conditional logic, typically not directly joined but used for lookup)
CREATE TABLE plsqlawakening.jobGrades (
    gradeLevel VARCHAR2(2) PRIMARY KEY,
    lowestSal NUMBER(10, 2),
    highestSal NUMBER(10, 2)
);

-- plsqlawakening.products Table
CREATE TABLE plsqlawakening.products (
    productId NUMBER PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    category VARCHAR2(50),
    unitPrice NUMBER(8, 2) CHECK (unitPrice >= 0),
    stockQuantity NUMBER DEFAULT 0 CHECK (stockQuantity >= 0)
);

-- Sales Orders Table
CREATE TABLE plsqlawakening.salesOrders (
    orderId NUMBER PRIMARY KEY,
    customerId NUMBER, -- Simplified: assuming customerId is just a numeric identifier
    orderDate DATE DEFAULT SYSDATE,
    orderStatus VARCHAR2(20) CHECK (orderStatus IN ('Pending', 'Shipped', 'Completed', 'Cancelled'))
);

-- Order Items Table
CREATE TABLE plsqlawakening.orderItems (
    orderItemId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incrementing PK
    orderId NUMBER NOT NULL,
    productId NUMBER NOT NULL,
    quantity NUMBER CHECK (quantity > 0),
    priceAtOrder NUMBER(8, 2) CHECK (priceAtOrder >= 0), -- Price when the order was placed
    CONSTRAINT fkOrderItemsOrder FOREIGN KEY (orderId) REFERENCES plsqlawakening.salesOrders(orderId),
    CONSTRAINT fkOrderItemsProduct FOREIGN KEY (productId) REFERENCES plsqlawakening.products(productId)
);

-- Sales Log Table (for DML and debugging examples)
CREATE TABLE plsqlawakening.salesLog (
    logId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    logMessage VARCHAR2(255),
    logTime TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Populate plsqlawakening.departments
INSERT INTO plsqlawakening.departments (departmentId, departmentName, locationCity) VALUES (10, 'Administration', 'New York');
INSERT INTO plsqlawakening.departments (departmentId, departmentName, locationCity) VALUES (20, 'Marketing', 'London');
INSERT INTO plsqlawakening.departments (departmentId, departmentName, locationCity) VALUES (30, 'Sales', 'Chicago');
INSERT INTO plsqlawakening.departments (departmentId, departmentName, locationCity) VALUES (40, 'IT', 'New York');
INSERT INTO plsqlawakening.departments (departmentId, departmentName, locationCity) VALUES (50, 'Finance', 'London');

-- Populate plsqlawakening.employees
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (101, 'John', 'Smith', 'john.smith@example.com', TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'IT Manager', 95000, NULL, 40, TRUE);
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (102, 'Alice', 'Johnson', 'alice.johnson@example.com', TO_DATE('2021-07-20', 'YYYY-MM-DD'), 'Marketing Manager', 85000, NULL, 20, TRUE);
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (103, 'Robert', 'Williams', 'bob.williams@example.com', TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Sales Manager', 80000, 0.15, 30, TRUE);
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (104, 'Eva', 'Brown', 'eva.brown@example.com', TO_DATE('2020-05-10', 'YYYY-MM-DD'), 'Admin Assistant', 52000, NULL, 10, TRUE);
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (105, 'Michael', 'Davis', 'michael.davis@example.com', TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'IT Programmer', 72000, NULL, 40, TRUE);
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (106, 'Sarah', 'Miller', 'sarah.miller@example.com', TO_DATE('2019-11-11', 'YYYY-MM-DD'), 'Sales Representative', 60000, 0.10, 30, TRUE);
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (107, 'David', 'Wilson', 'david.wilson@example.com', TO_DATE('2022-04-01', 'YYYY-MM-DD'), 'IT Programmer', 68000, NULL, 40, FALSE); -- Inactive employee
INSERT INTO plsqlawakening.employees (employeeId, firstName, lastName, email, hireDate, jobTitle, salary, commissionPct, departmentId, isActive)
VALUES (108, 'Linda', 'Garcia', 'linda.garcia@example.com', TO_DATE('2020-09-15', 'YYYY-MM-DD'), 'Accountant', 65000, NULL, 50, TRUE);


-- Populate Job Grades
INSERT INTO plsqlawakening.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('A', 30000, 55000);
INSERT INTO plsqlawakening.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('B', 55001, 75000);
INSERT INTO plsqlawakening.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('C', 75001, 90000);
INSERT INTO plsqlawakening.jobGrades (gradeLevel, lowestSal, highestSal) VALUES ('D', 90001, 120000);

-- Populate plsqlawakening.products
INSERT INTO plsqlawakening.products (productId, productName, category, unitPrice, stockQuantity) VALUES (1, 'Alpha Laptop', 'Electronics', 1200.00, 50);
INSERT INTO plsqlawakening.products (productId, productName, category, unitPrice, stockQuantity) VALUES (2, 'Beta Wireless Mouse', 'Electronics', 25.00, 15); -- Low stock
INSERT INTO plsqlawakening.products (productId, productName, category, unitPrice, stockQuantity) VALUES (3, 'Gamma Office Chair', 'Furniture', 150.00, 30);
INSERT INTO plsqlawakening.products (productId, productName, category, unitPrice, stockQuantity) VALUES (4, 'Delta Desk Lamp', 'Furniture', 45.00, 0); -- Out of stock
INSERT INTO plsqlawakening.products (productId, productName, category, unitPrice, stockQuantity) VALUES (5, 'Omega Keyboard', 'Electronics', 75.00, 100);

-- Populate Sales Orders
INSERT INTO plsqlawakening.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1001, 201, TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Shipped');
INSERT INTO plsqlawakening.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1002, 202, TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Pending');
INSERT INTO plsqlawakening.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1003, 201, TO_DATE('2023-10-10', 'YYYY-MM-DD'), 'Completed');
INSERT INTO plsqlawakening.salesOrders (orderId, customerId, orderDate, orderStatus) VALUES (1004, 203, TO_DATE('2023-10-12', 'YYYY-MM-DD'), 'Pending');

-- Populate Order Items
INSERT INTO plsqlawakening.orderItems (orderId, productId, quantity, priceAtOrder) VALUES (1001, 1, 1, 1200.00);
INSERT INTO plsqlawakening.orderItems (orderId, productId, quantity, priceAtOrder) VALUES (1001, 2, 2, 25.00);
INSERT INTO plsqlawakening.orderItems (orderId, productId, quantity, priceAtOrder) VALUES (1002, 3, 1, 150.00);
INSERT INTO plsqlawakening.orderItems (orderId, productId, quantity, priceAtOrder) VALUES (1003, 2, 5, 24.00); -- Discounted price for example
INSERT INTO plsqlawakening.orderItems (orderId, productId, quantity, priceAtOrder) VALUES (1003, 5, 1, 75.00);
INSERT INTO plsqlawakening.orderItems (orderId, productId, quantity, priceAtOrder) VALUES (1004, 1, 2, 1150.00); -- Discounted price

COMMIT;