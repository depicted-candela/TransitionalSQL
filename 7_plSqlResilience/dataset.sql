-- Drop tables if they exist to ensure a clean slate
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.OrderItems';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Orders';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Products';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.AuditLog';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Employees';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE plsqlresilience.Departments';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Drop sequences if they exist
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.Departmentseq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.Employeeseq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.Productseq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.Orderseq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE plsqlresilience.OrderItemseq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Create Tables
CREATE TABLE plsqlresilience.Departments (
    departmentId NUMBER PRIMARY KEY,
    departmentName VARCHAR2(100) NOT NULL,
    locationCity VARCHAR2(100) -- Changed from 'location' to avoid reserved word issues in some tools
);

CREATE TABLE plsqlresilience.Employees (
    employeeId NUMBER PRIMARY KEY,
    firstName VARCHAR2(50),
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    salary NUMBER(10, 2),
    departmentId NUMBER,
    hireDate DATE DEFAULT SYSDATE,
    CONSTRAINT fkEmployeeDepartment FOREIGN KEY (departmentId) REFERENCES plsqlresilience.Departments(departmentId)
);

CREATE TABLE plsqlresilience.Products (
    productId NUMBER PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    unitPrice NUMBER(10, 2) CHECK (unitPrice > 0),
    stockQuantity NUMBER DEFAULT 0 CHECK (stockQuantity >= 0)
);

CREATE TABLE plsqlresilience.Orders (
    orderId NUMBER PRIMARY KEY,
    customerId NUMBER,
    orderDate DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE plsqlresilience.OrderItems (
    orderItemId NUMBER PRIMARY KEY,
    orderId NUMBER NOT NULL,
    productId NUMBER NOT NULL,
    quantity NUMBER CHECK (quantity > 0),
    itemPrice NUMBER(10, 2),
    CONSTRAINT fkOrderItemOrder FOREIGN KEY (orderId) REFERENCES plsqlresilience.Orders(orderId),
    CONSTRAINT fkOrderItemProduct FOREIGN KEY (productId) REFERENCES plsqlresilience.Products(productId)
);

CREATE TABLE plsqlresilience.AuditLog (
    logId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tableName VARCHAR2(50),
    operationType VARCHAR2(10),
    changedBy VARCHAR2(100) DEFAULT USER,
    changeTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    oldValue CLOB, -- Changed to CLOB for potentially larger values
    newValue CLOB, -- Changed to CLOB
    recordId VARCHAR2(100)
);

-- Create Sequences
CREATE SEQUENCE plsqlresilience.Departmentseq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.Employeeseq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.Productseq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.Orderseq START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE plsqlresilience.OrderItemseq START WITH 10000 INCREMENT BY 1;

-- Populate plsqlresilience.Departments
INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity) VALUES (plsqlresilience.departmentSeq.NEXTVAL, 'Sales', 'New York');
INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity) VALUES (plsqlresilience.departmentSeq.NEXTVAL, 'HR', 'London');
INSERT INTO plsqlresilience.Departments (departmentId, departmentName, locationCity) VALUES (plsqlresilience.departmentSeq.NEXTVAL, 'IT', 'Bangalore');

-- Populate plsqlresilience.Employees
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.employeeSeq.NEXTVAL, 'John', 'Doe', 'john.doe@example.com', 60000, 1, TO_DATE('2022-01-15', 'YYYY-MM-DD'));
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.employeeSeq.NEXTVAL, 'Jane', 'Smith', 'jane.smith@example.com', 75000, 1, TO_DATE('2021-03-22', 'YYYY-MM-DD'));
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.employeeSeq.NEXTVAL, 'Alice', 'Wonder', 'alice.wonder@example.com', 50000, 2, TO_DATE('2022-07-10', 'YYYY-MM-DD'));
INSERT INTO plsqlresilience.Employees (employeeId, firstName, lastName, email, salary, departmentId, hireDate) VALUES (plsqlresilience.employeeSeq.NEXTVAL, 'Bob', 'Builder', 'bob.builder@example.com', 90000, 3, TO_DATE('2020-11-01', 'YYYY-MM-DD'));

-- Populate plsqlresilience.Products
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.productSeq.NEXTVAL, 'Laptop Pro', 1200, 50);
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.productSeq.NEXTVAL, 'Wireless Mouse', 25, 200);
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.productSeq.NEXTVAL, 'Keyboard Ultra', 75, 10);
INSERT INTO plsqlresilience.Products (productId, productName, unitPrice, stockQuantity) VALUES (plsqlresilience.productSeq.NEXTVAL, 'Monitor HD', 300, 0); -- Out of stock for exception handling

COMMIT;