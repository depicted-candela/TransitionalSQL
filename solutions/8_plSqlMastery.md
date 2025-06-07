<head>
    <link rel="stylesheet" href="../styles/lecture.css">
    <link rel="stylesheet" href="../styles/solutions.css">
</head>


<div class='container'>

# Solutions for PL/SQL Mastery: Power Moves with Collections and Dynamic SQL

## Introduction

Welcome to the solutions document for Study Chunk 8: PL/SQL Mastery. This section of your learning journey delves into Oracle's powerful capabilities for handling structured data within PL/SQL using Collections and Records, optimizing performance with Bulk Operations, and managing flexibility with Dynamic SQL.

Reviewing these solutions is not merely about checking right or wrong answers. It's a critical step for:

*   **Reinforcement:** Solidifying your understanding of how Oracle implements these concepts.
*   **Validation:** Confirming that your approach aligns with Oracle's idiomatic best practices.
*   **Deeper Understanding:** Exploring the "why" behind the solutions, understanding the nuances of Oracle's implementation, and learning about the specific advantages and potential pitfalls in the Oracle Database 23ai environment.

Even if your code ran without errors, take the time to read through the explanations. You might discover more efficient techniques, better ways to handle edge cases, or gain insight into Oracle's internal workings.

## Reviewing the Dataset

The exercises in this chunk utilize the standard dataset established at the beginning of this section of the course. It includes tables like `departments`, `employees`, `products`, `orders`, and `orderItems`, along with helper tables like `appSettings`, `customerLog`, `nestedData`, `varrayData`, `recordData`, `dynamicDataTarget`, and `ptfSourceData`, complete with necessary sequences and custom Oracle types (`nestedIntegerList`, `varrayStringList`, `productInfoRec`, `productInfoList`). This rich dataset provides the necessary context to practice the diverse applications of collections, bulk operations, and dynamic SQL in realistic (though simplified) scenarios.

```sql
-- =============================================================================
-- DATASET DEFINITION AND POPULATION (Repeated for easy reference)
-- =============================================================================

-- Drop existing tables to start fresh (using IF EXISTS, a 23ai feature)
DROP TABLE orderItems IF EXISTS;
DROP TABLE orders IF EXISTS;
DROP TABLE employees IF EXISTS;
DROP TABLE departments IF EXISTS;
DROP TABLE products IF EXISTS;
DROP TABLE appSettings IF EXISTS;
DROP TABLE customerLog IF EXISTS;
DROP TABLE nestedData IF EXISTS;
DROP TABLE varrayData IF EXISTS;
DROP TABLE recordData IF EXISTS;
DROP TABLE dynamicDataTarget IF EXISTS;
DROP TABLE ptfSourceData IF EXISTS;

-- Sequences for primary keys
DROP SEQUENCE employees_seq IF EXISTS;
DROP SEQUENCE orders_seq IF EXISTS;
DROP SEQUENCE products_seq IF EXISTS;
DROP SEQUENCE customerlog_seq IF EXISTS;
DROP SEQUENCE nesteddata_seq IF EXISTS;
DROP SEQUENCE varraydata_seq IF EXISTS;
DROP SEQUENCE recorddata_seq IF EXISTS;
DROP SEQUENCE dynamicdatatarget_seq IF EXISTS;
DROP SEQUENCE ptfsourcedata_seq IF EXISTS;

CREATE SEQUENCE employees_seq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE orders_seq START WITH 2000 INCREMENT BY 1;
CREATE SEQUENCE products_seq START WITH 3000 INCREMENT BY 1;
CREATE SEQUENCE customerlog_seq START WITH 4000 INCREMENT BY 1;
CREATE SEQUENCE nesteddata_seq START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE varraydata_seq START WITH 6000 INCREMENT BY 1;
CREATE SEQUENCE recorddata_seq START WITH 7000 INCREMENT BY 1;
CREATE SEQUENCE dynamicdatatarget_seq START WITH 8000 INCREMENT BY 1;
CREATE SEQUENCE ptfsourcedata_seq START WITH 9000 INCREMENT BY 1;


-- Departments table
CREATE TABLE departments (
    departmentId NUMBER(4) PRIMARY KEY,
    departmentName VARCHAR2(30) NOT NULL UNIQUE,
    location VARCHAR2(20)
);

-- Employees table (simplified HR schema)
CREATE TABLE employees (
    employeeId NUMBER(6) PRIMARY KEY,
    firstName VARCHAR2(20),
    lastName VARCHAR2(25) NOT NULL,
    email VARCHAR2(25) NOT NULL UNIQUE,
    phoneNumber VARCHAR2(20),
    hireDate DATE NOT NULL,
    jobId VARCHAR2(10),
    salary NUMBER(8,2),
    commissionPct NUMBER(2,2),
    managerId NUMBER(6),
    departmentId NUMBER(4) REFERENCES departments(departmentId)
);

-- Products table
CREATE TABLE products (
    productId NUMBER(6) PRIMARY KEY,
    productName VARCHAR2(50) NOT NULL UNIQUE,
    category VARCHAR2(20),
    price NUMBER(10,2) NOT NULL,
    stockQuantity NUMBER(6)
);

-- Orders table
CREATE TABLE orders (
    orderId NUMBER(6) PRIMARY KEY,
    customerId NUMBER(6), -- simplified customer ID (not linked to employees)
    orderDate DATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'Pending',
    totalAmount NUMBER(10,2) DEFAULT 0
);

-- Order Items table
CREATE TABLE orderItems (
    orderItemId NUMBER(10) PRIMARY KEY, -- using sequence, not composite key
    orderId NUMBER(6) REFERENCES orders(orderId),
    productId NUMBER(6) REFERENCES products(productId),
    quantity NUMBER(6) NOT NULL,
    unitPrice NUMBER(10,2) NOT NULL,
    itemAmount NUMBER(10,2) GENERATED ALWAYS AS (quantity * unitPrice) VIRTUAL -- Virtual column
);

-- Application Settings table (for dynamic DDL/DML examples)
CREATE TABLE appSettings (
    settingName VARCHAR2(50) PRIMARY KEY,
    settingValue VARCHAR2(255)
);

-- Customer Log table (for dynamic SQL examples, especially injection)
CREATE TABLE customerLog (
    logId NUMBER(10) PRIMARY KEY,
    logTimestamp TIMESTAMP DEFAULT SYSTIMESTAMP,
    customerName VARCHAR2(100),
    actionDetails VARCHAR2(4000)
);

-- Tables for Collections & Records
-- Nested Table type definition
CREATE OR REPLACE TYPE nestedIntegerList IS TABLE OF NUMBER;
/

-- Varray type definition
CREATE OR REPLACE TYPE varrayStringList IS VARRAY(10) OF VARCHAR2(50);
/

-- Record type definition (simplified)
CREATE OR REPLACE TYPE productInfoRec IS OBJECT (
    pId NUMBER,
    pName VARCHAR2(50),
    pPrice NUMBER(10,2)
);
/
-- Nested Table using the Record Type
CREATE OR REPLACE TYPE productInfoList IS TABLE OF productInfoRec;
/

-- Tables using collection types
CREATE TABLE nestedData (
    id NUMBER PRIMARY KEY,
    dataList nestedIntegerList
) NESTED TABLE dataList STORE AS nestedData_nt;

CREATE TABLE varrayData (
    id NUMBER PRIMARY KEY,
    dataArray varrayStringList
);

-- Table for Record type examples
CREATE TABLE recordData (
    id NUMBER PRIMARY KEY,
    info productInfoRec -- Column of a user-defined object type
);


-- Dynamic Data Target table (for dynamic DML/SELECT output)
CREATE TABLE dynamicDataTarget (
    id NUMBER PRIMARY KEY,
    stringValue VARCHAR2(100),
    numericValue NUMBER,
    dateValue DATE
);

-- Table for PTF Source Data
CREATE TABLE ptfSourceData (
    sourceId NUMBER PRIMARY KEY,
    sourceCategory VARCHAR2(20),
    sourceValue NUMBER,
    sourceDate DATE
);

-- Populate Tables

-- Departments
INSERT INTO departments VALUES (10, 'Administration', 'New York');
INSERT INTO departments VALUES (20, 'Marketing', 'California');
INSERT INTO departments VALUES (30, 'Purchasing', 'Washington');
INSERT INTO departments VALUES (40, 'Human Resources', 'Arizona');

-- Employees
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'John', 'Smith', 'jsmith@example.com', '555-1234', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 'MANAGER', 70000, NULL, NULL, 10);
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'Jane', 'Doe', 'jdoe@example.com', '555-5678', TO_DATE('2021-03-10', 'YYYY-MM-DD'), 'ANALYST', 60000, NULL, 1000, 10);
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'Peter', 'Jones', 'pjones@example.com', '555-8765', TO_DATE('2019-07-01', 'YYYY-MM-DD'), 'SALESREP', 55000, 0.1, 1000, 20);
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'Mary', 'Williams', 'mwilliams@example.com', '555-4321', TO_DATE('2022-05-20', 'YYYY-MM-DD'), 'CLERK', 40000, NULL, 1001, 20);
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'David', 'Brown', 'dbrown@example.com', '555-0987', TO_DATE('2018-11-11', 'YYYY-MM-DD'), 'MANAGER', 80000, NULL, NULL, 30);
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'Sarah', 'Davis', 'sdavis@example.com', '555-1122', TO_DATE('2023-02-28', 'YYYY-MM-DD'), 'ANALYST', 65000, NULL, 1004, 30);
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'Michael', 'Garcia', 'mgarcia@example.com', '555-3344', TO_DATE('2020-09-01', 'YYYY-MM-DD'), 'SALESREP', 58000, 0.15, 1004, 20);
INSERT INTO employees VALUES (employees_seq.NEXTVAL, 'Emily', 'Rodriguez', 'erodriguez@example.com', '555-5566', TO_DATE('2021-07-18', 'YYYY-MM-DD'), 'CLERK', 42000, NULL, 1005, 40);

-- Products
INSERT INTO products VALUES (products_seq.NEXTVAL, 'Laptop 15"', 'Electronics', 1200.00, 50);
INSERT INTO products VALUES (products_seq.NEXTVAL, 'Keyboard', 'Accessories', 75.00, 200);
INSERT INTO products VALUES (products_seq.NEXTVAL, 'Mouse', 'Accessories', 25.00, 300);
INSERT INTO products VALUES (products_seq.NEXTVAL, 'Monitor 27"', 'Electronics', 300.00, 80);
INSERT INTO products VALUES (products_seq.NEXTVAL, 'Webcam', 'Accessories', 50.00, 150);
INSERT INTO products VALUES (products_seq.NEXTVAL, 'Desk Chair', 'Office Furniture', 150.00, 30);
INSERT INTO products VALUES (products_seq.NEXTVAL, 'Notebook', 'Supplies', 5.00, 500);

-- Orders (simplified customer IDs)
INSERT INTO orders VALUES (orders_seq.NEXTVAL, 1, SYSDATE - 30, 'Shipped', 0); -- Will update total later
INSERT INTO orders VALUES (orders_seq.NEXTVAL, 2, SYSDATE - 20, 'Pending', 0);
INSERT INTO orders VALUES (orders_seq.NEXTVAL, 1, SYSDATE - 10, 'Processing', 0);
INSERT INTO orders VALUES (orders_seq.NEXTVAL, 3, SYSDATE - 5, 'Pending', 0);
INSERT INTO orders VALUES (orders_seq.NEXTVAL, 2, SYSDATE - 2, 'Pending', 0);

-- Order Items
-- Order 2000
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2000, 3000, 1, 1200.00);
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2000, 3001, 1, 75.00);
-- Order 2001
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2001, 3003, 2, 300.00);
-- Order 2002
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2002, 3000, 1, 1200.00);
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2002, 3001, 2, 75.00);
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2002, 3002, 1, 25.00);
-- Order 2003
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2003, 3006, 10, 5.00);
-- Order 2004
INSERT INTO orderItems VALUES (orderItems_seq.NEXTVAL, 2004, 3004, 1, 50.00);

-- Update order totals based on order items (manual for simplicity here)
UPDATE orders SET totalAmount = (SELECT SUM(itemAmount) FROM orderItems WHERE orderId = 2000) WHERE orderId = 2000;
UPDATE orders SET totalAmount = (SELECT SUM(itemAmount) FROM orderItems WHERE orderId = 2001) WHERE orderId = 2001;
UPDATE orders SET totalAmount = (SELECT SUM(itemAmount) FROM orderItems WHERE orderId = 2002) WHERE orderId = 2002;
UPDATE orders SET totalAmount = (SELECT SUM(itemAmount) FROM orderItems WHERE orderId = 2003) WHERE orderId = 2003;
UPDATE orders SET totalAmount = (SELECT SUM(itemAmount) FROM orderItems WHERE orderId = 2004) WHERE orderId = 2004;


-- App Settings (example)
INSERT INTO appSettings VALUES ('minimumStockForReorder', '50');

-- Customer Log (example entries for injection scenarios)
INSERT INTO customerLog VALUES (customerLog_seq.NEXTVAL, SYSTIMESTAMP, 'Alice', 'Logged in from IP 192.168.1.100');
INSERT INTO customerLog VALUES (customerLog_seq.NEXTVAL, SYSTIMESTAMP, 'Bob', 'Viewed order 2001');


-- Populate Nested/Varray/Record Data tables with some initial values
INSERT INTO nestedData VALUES (nestedData_seq.NEXTVAL, nestedIntegerList(10, 20, 30, 40, 50));
INSERT INTO nestedData VALUES (nestedData_seq.NEXTVAL, nestedIntegerList(1, 3, 5, 7, 9));
INSERT INTO nestedData VALUES (nestedData_seq.NEXTVAL, NULL); -- Example null collection

INSERT INTO varrayData VALUES (varrayData_seq.NEXTVAL, varrayStringList('Apple', 'Banana', 'Cherry'));
INSERT INTO varrayData VALUES (varrayData_seq.NEXTVAL, varrayStringList('Red', 'Green', 'Blue', 'Yellow'));
INSERT INTO varrayData VALUES (varrayData_seq.NEXTVAL, varrayStringList()); -- Example empty varray
INSERT INTO varrayData VALUES (varrayData_seq.NEXTVAL, NULL); -- Example null varray

INSERT INTO recordData VALUES (recordData_seq.NEXTVAL, productInfoRec(3000, 'Laptop 15"', 1200.00));
INSERT INTO recordData VALUES (recordData_seq.NEXTVAL, productInfoRec(3006, 'Notebook', 5.00));
INSERT INTO recordData VALUES (recordData_seq.NEXTVAL, NULL); -- Example null object column


-- Populate PTF Source Data
INSERT INTO ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'A', 100, SYSDATE - 10);
INSERT INTO ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'A', 150, SYSDATE - 5);
INSERT INTO ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'B', 200, SYSDATE - 8);
INSERT INTO ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'C', 50, SYSDATE - 15);
INSERT INTO ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'A', 120, SYSDATE - 3);
INSERT INTO ptfSourceData VALUES (ptfSourceData_seq.NEXTVAL, 'B', 220, SYSDATE - 2);

COMMIT;

-- Enable DBMS_OUTPUT for results
SET SERVEROUTPUT ON SIZE UNLIMITED;
```

## Solution Structure Overview

For each problem, you will find the following:

1.  The **Problem Statement**: This is repeated from the exercises for easy reference.
2.  The **Solution Code**: The complete PL/SQL code block or procedure/package definition that solves the problem. This code adheres to Oracle's best practices and the specific requirements of the exercise.
3.  The **Explanation**: A detailed breakdown of the solution. This section explains:
    *   The logic behind the code.
    *   How the Oracle concepts (Collections, Records, Bulk Operations, Dynamic SQL) are applied.
    *   Any Oracle-specific syntax or behavior demonstrated.
    *   How the solution addresses the potential pitfalls or inefficient methods highlighted in the problem.
    *   Bridging explanations, connecting Oracle's approach to concepts you may know from PostgreSQL where applicable.
    *   Any relevant Oracle 23ai features utilized.
    *   Minimalist rhymes or subtle humor may be woven into explanations where they enhance clarity or memorability.

Compare the provided solutions and explanations to your own attempts. Focus not just on correctness, but on style, efficiency, and understanding the Oracle-specific features.

## Solutions to Exercises

### **Category: Collections & Records, Bulk Operations for Performance, Dynamic SQL**

#### **(i) Meanings, Values, Relations, and Advantages**

**Exercise 1.1: Oracle Collections - Basic Usage and Differences**

*   **Problem:** Oracle offers three types of collections: Associative Arrays, Varrays, and Nested Tables. Using the `nestedIntegerList` (Nested Table) and `varrayStringList` (Varray) types and the `productInfoRec` (Object Type) and `productInfoList` (Nested Table of Objects) types, create PL/SQL blocks to:
    *   Declare a variable of each type.
    *   Initialize each variable using a constructor where applicable. For Associative Arrays, populate with at least 3 key-value pairs (use PLS_INTEGER index).
    *   Demonstrate accessing elements using the correct index syntax for each type.
    *   Print the `COUNT` of elements in each populated collection.
    *   For the Associative Array, print the `FIRST` and `LAST` index. Use `NEXT` and `PRIOR` to navigate a couple of elements.
    *   For the Varray, demonstrate `EXTEND` by adding a NULL element.
    *   For the Nested Table (`nestedIntegerList`), demonstrate `DELETE` by deleting an element from the middle.
    *   *Bridge from PostgreSQL:* Conceptually, Oracle collections are used for storing multiple values, similar to PostgreSQL arrays. However, Oracle provides distinct types with different characteristics (fixed size vs. variable, indexing, storage). Focus on demonstrating these Oracle-specific types and methods.

*   **Solution 1.1:**

```sql
DECLARE
    -- Associative Array (Index-by Table)
    type integerMap IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    salaryMap integerMap;

    -- Varray
    type stringArray IS VARRAY(5) OF VARCHAR2(50);
    colorArray stringArray;

    -- Nested Table
    type numberList IS TABLE OF NUMBER;
    gradeList numberList;

    -- Nested Table of Objects (using previously defined types)
    productsList productInfoList;

    -- Loop variables
    idx PLS_INTEGER;
    v_item VARCHAR2(50);

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Collections Basic Usage ---');

    -- 1. Associative Array (Integer Indexed)
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Associative Array ---');
    salaryMap(101) := 70000;
    salaryMap(105) := 80000;
    salaryMap(103) := 55000;
    salaryMap(107) := 42000; -- Adding out of index order

    DBMS_OUTPUT.PUT_LINE('Salary Map COUNT: ' || salaryMap.COUNT);
    -- This COUNT, unlike PG array_length(), is a method
    DBMS_OUTPUT.PUT_LINE('Salary Map(103): ' || salaryMap(103)); -- Access by index

    -- Oracle specific navigation methods (FIRST, LAST, NEXT, PRIOR work on *existing* elements,
    -- great for sparse arrays like Associative Arrays or Nested Tables after DELETE)
    idx := salaryMap.FIRST;
    DBMS_OUTPUT.PUT_LINE('First index: ' || idx);
    DBMS_OUTPUT.PUT_LINE('Value at first index: ' || salaryMap(idx));

    idx := salaryMap.LAST;
    DBMS_OUTPUT.PUT_LINE('Last index: ' || idx);
    DBMS_OUTPUT.PUT_LINE('Value at last index: ' || salaryMap(idx));

    idx := salaryMap.NEXT(salaryMap.FIRST);
    DBMS_OUTPUT.PUT_LINE('Index after first: ' || idx);
    DBMS_OUTPUT.PUT_LINE('Value after first: ' || salaryMap(idx));

    idx := salaryMap.PRIOR(salaryMap.LAST);
    DBMS_OUTPUT.PUT_LINE('Index before last: ' || idx);
    DBMS_OUTPUT.PUT_LINE('Value before last: ' || salaryMap(idx));


    -- 2. Varray
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Varray (stringArray) ---');
    -- Initialize with constructor (size 4, max 5)
    colorArray := stringArray('Red', 'Green', 'Blue', 'Yellow');
    -- Varrays are fixed size (max) but variable current size (COUNT), indexed 1 to COUNT
    DBMS_OUTPUT.PUT_LINE('Color Array COUNT: ' || colorArray.COUNT);
    DBMS_OUTPUT.PUT_LINE('Color Array(3): ' || colorArray(3)); -- Access by index (1-based in Oracle)

    -- Demonstrate EXTEND (adds NULL if no element specified)
    colorArray.EXTEND;
    DBMS_OUTPUT.PUT_LINE('Color Array COUNT after EXTEND: ' || colorArray.COUNT);
    -- Accessing extended (NULL) element - will be NULL
    -- DBMS_OUTPUT.PUT_LINE('Color Array(5): ' || colorArray(5)); -- This would print NULL

    -- 3. Nested Table (numberList)
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Nested Table (numberList) ---');
    -- Initialize with constructor
    gradeList := numberList(85, 92, 78, 95, 88);
    -- Nested Tables are variable size (no max defined in type) and indexed 1 to COUNT initially
    DBMS_OUTPUT.PUT_LINE('Grade List COUNT: ' || gradeList.COUNT);
    DBMS_OUTPUT.PUT_LINE('Grade List(2): ' || gradeList(2)); -- Access by index (1-based in Oracle)

    -- Demonstrate DELETE (deletes element, indices are shifted in concept, but internal placeholder kept)
    gradeList.DELETE(3); -- Delete element at index 3
    DBMS_OUTPUT.PUT_LINE('Grade List COUNT after DELETE(3): ' || gradeList.COUNT);
    -- Check if element exists using EXISTS method (Oracle specific)
    IF gradeList.EXISTS(3) THEN
        DBMS_OUTPUT.PUT_LINE('Grade List(3) EXISTS: ' || gradeList(3));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Grade List(3) does NOT EXIST.');
    END IF;
     IF gradeList.EXISTS(2) THEN
        DBMS_OUTPUT.PUT_LINE('Grade List(2) EXISTS: ' || gradeList(2));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Grade List(2) does NOT EXIST.');
    END IF;
    -- Note: DELETE creates sparse collections for Nested Tables and Assoc Arrays (string or integer indexed),
    -- meaning indices can have gaps. Varrays, however, are always dense.

    -- 4. Nested Table of Objects (using previously defined types)
     DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Nested Table of Objects (productInfoList) ---');
     productsList := productInfoList(); -- Initialize as empty
     productsList.EXTEND(2); -- Extend to add space for 2 objects
     productsList(1) := productInfoRec(3000, 'Laptop 15"', 1200.00); -- Assign object using constructor
     productsList(2) := productInfoRec(3001, 'Keyboard', 75.00);

     DBMS_OUTPUT.PUT_LINE('Products List COUNT: ' || productsList.COUNT);
     DBMS_OUTPUT.PUT_LINE('Product 1 Name: ' || productsList(1).pName); -- Access field using dot notation
     DBMS_OUTPUT.PUT_LINE('Product 2 Price: ' || productsList(2).pPrice);

    <div class="oracle-specific">
    <p>Oracle's collection types offer more built-in methods (<code>COUNT</code>, <code>FIRST</code>, <code>LAST</code>, <code>NEXT</code>, <code>PRIOR</code>, <code>EXTEND</code>, <code>DELETE</code>, <code>EXISTS</code>) compared to standard PostgreSQL arrays. This gives you more direct programmatic control over collection manipulation within PL/SQL.</p>
    <p>The ability to define collections of user-defined records (like <code>productInfoList</code> of <code>productInfoRec</code>) is powerful for handling structured data sets directly within PL/SQL code.</p>
    </div>
    <div class="postgresql-bridge">
    <p>While PostgreSQL uses a single array type with varied dimensions and element types, Oracle provides distinct types (Associative Array, Varray, Nested Table) with specific behaviors regarding indexing, density, and storage. This requires choosing the right collection type for the job.</p>
    <p>PostgreSQL's array functions like <code>array_length()</code> are equivalent to Oracle's <code>COUNT</code> method. PostgreSQL array access uses <code>[index]</code> (0-based by default, or defined lower bound), while Oracle collections use <code>(index)</code> (1-based by default for Varrays/Nested Tables, flexible for Associative Arrays).</p>
     <p>Just like in PostgreSQL, handling potentially non-existent or null collection elements is key to prevent errors. Oracle gives you the <code>EXISTS</code> method and the <code>COLLECTION_IS_NULL</code> exception for robustness.</p>
    </div>

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- End Collections Basic Usage ---');

END;
/
```

**Exercise 1.2: Bulk Operations - BULK COLLECT and FORALL**

*   **Problem:** Efficient data processing between SQL and PL/SQL is crucial. Oracle provides `BULK COLLECT` and `FORALL` for this.
    *   Create a PL/SQL block to fetch the `employeeId` and `lastName` of all employees from the `employees` table into two separate associative arrays (`empIds`, `empNames`) using `BULK COLLECT`. Print the count of elements fetched.
    *   Create another PL/SQL block to fetch the `productName` and `price` of all products with a `stockQuantity` less than 100 into a Nested Table of `productInfoRec` objects (`lowStockProducts`) using `BULK COLLECT`. Print the name and price of the first three fetched products.
    *   Create a PL/SQL block that declares an associative array `reorderQuantities` (indexed by PLS_INTEGER, value is NUMBER) and populates it with new stock quantities for products that need reordering (e.g., `productId` 3001 needs 250, `productId` 3004 needs 180). Use a `FORALL` statement to update the `stockQuantity` in the `products` table based on this collection. Print the total number of rows updated using `SQL%ROWCOUNT`.
    *   Create a PL/SQL block that declares a Nested Table `orderItemsToDelete` (of NUMBER) and populate it with `orderItemId`s that are part of order `2004`. Use a `FORALL` statement to delete these items from the `orderItems` table. Print the total number of items deleted.
    *   *Bridge from PostgreSQL:* PostgreSQL arrays are single-dimensional, and bulk operations typically involve optimizing client-side libraries or using functions that return sets that can be used with `UPDATE FROM` for set-based logic. Oracle's `BULK COLLECT` and `FORALL` provide explicit server-side mechanisms for efficiently moving data collections between the SQL and PL/SQL engines. Demonstrate this efficiency gain conceptually by showing the concise code.

*   **Solution 1.2:**

```sql
DECLARE
    -- Collections for BULK COLLECT
    type empIdList IS TABLE OF employees.employeeId%TYPE INDEX BY PLS_INTEGER;
    type empNameList IS TABLE OF employees.lastName%TYPE INDEX BY PLS_INTEGER;
    empIds empIdList;
    empNames empNameList;

    -- Collection of records for BULK COLLECT
    lowStockProducts productInfoList; -- Using the previously defined type

    -- Collection for FORALL UPDATE
    type quantityMap IS TABLE OF products.stockQuantity%TYPE INDEX BY PLS_INTEGER;
    reorderQuantities quantityMap;

    -- Collection for FORALL DELETE
    orderItemsToDelete nestedIntegerList := nestedIntegerList(); -- Initialize as empty

    -- Loop variable
    i PLS_INTEGER;
    totalUpdatedRows PLS_INTEGER;
    totalDeletedItems PLS_INTEGER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Bulk Operations ---');

    -- 1. BULK COLLECT into associative arrays
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- BULK COLLECT into Assoc Arrays ---');
    -- In PostgreSQL, you might fetch row by row or use a function returning a set/array
    -- Oracle's BULK COLLECT is a direct PL/SQL feature for efficient fetching
    SELECT employeeId, lastName
    BULK COLLECT INTO empIds, empNames
    FROM employees;

    DBMS_OUTPUT.PUT_LINE('Fetched ' || empIds.COUNT || ' employees.');
    -- Example: Print first few fetched items (assoc arrays might not be sequential from fetch)
    IF empIds.COUNT > 0 THEN
        i := empIds.FIRST;
        DBMS_OUTPUT.PUT_LINE('First employee fetched: ID=' || empIds(i) || ', Name=' || empNames(i));
         IF empIds.COUNT > 1 THEN
            i := empIds.NEXT(i);
            DBMS_OUTPUT.PUT_LINE('Second employee fetched: ID=' || empIds(i) || ', Name=' || empNames(i));
        END IF;
    END IF;


    -- 2. BULK COLLECT into Nested Table of Objects
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- BULK COLLECT into Nested Table of Objects ---');
    -- Fetch products with low stock
    SELECT productInfoRec(productId, productName, price) -- Use the constructor
    BULK COLLECT INTO lowStockProducts
    FROM products
    WHERE stockQuantity < 100; -- Filter in SQL before fetching

    DBMS_OUTPUT.PUT_LINE('Fetched ' || lowStockProducts.COUNT || ' low stock products.');
    IF lowStockProducts.COUNT > 0 THEN
        FOR i IN 1 .. LEAST(lowStockProducts.COUNT, 3) LOOP -- Use 1-based index for nested table
            DBMS_OUTPUT.PUT_LINE('Product ' || i || ': ' || lowStockProducts(i).pName || ' (Price: ' || lowStockProducts(i).pPrice || ')');
        END LOOP;
    END IF;

    -- 3. FORALL UPDATE
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- FORALL UPDATE ---');
    -- Populate collection with update data (product ID as index, new quantity as value)
    reorderQuantities(3001) := 250; -- Keyboard
    reorderQuantities(3004) := 180; -- Webcam

    -- FORALL is Oracle's bulk DML statement, much faster than row-by-row updates in a loop
    FORALL i IN reorderQuantities.FIRST .. reorderQuantities.LAST
        UPDATE products
        SET stockQuantity = reorderQuantities(i)
        WHERE productId = i; -- Use the collection index as the product ID

    totalUpdatedRows := SQL%ROWCOUNT; -- Get the total number of rows affected by the FORALL statement
    DBMS_OUTPUT.PUT_LINE('FORALL updated ' || totalUpdatedRows || ' products.');

    -- 4. FORALL DELETE
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- FORALL DELETE ---');
    -- Populate collection with order item IDs to delete
    SELECT orderItemId
    BULK COLLECT INTO orderItemsToDelete
    FROM orderItems
    WHERE orderId = 2004; -- Get items for order 2004

    DBMS_OUTPUT.PUT_LINE('Order 2004 had ' || orderItemsToDelete.COUNT || ' items to delete.');

    IF orderItemsToDelete.COUNT > 0 THEN
        -- Delete items using FORALL and the nested table collection
        FORALL i IN orderItemsToDelete.FIRST .. orderItemsToDelete.LAST
            DELETE FROM orderItems
            WHERE orderItemId = orderItemsToDelete(i); -- Use collection value as item ID

        totalDeletedItems := SQL%ROWCOUNT; -- Get the total number of rows affected
        DBMS_OUTPUT.PUT_LINE('FORALL deleted ' || totalDeletedItems || ' order items.');
    ELSE
         DBMS_OUTPUT.PUT_LINE('No items to delete for order 2004.');
    END IF;

    -- Commit the changes made by the FORALL statements
    COMMIT;

    <div class="oracle-specific">
    <p><code>BULK COLLECT</code> is the perfect wingman for fetching data from SQL into PL/SQL collections efficiently. It minimizes context switches compared to row-by-row fetches, especially for large result sets.</p>
    <p><code>FORALL</code> is the powerhouse for bulk DML operations (<code>INSERT</code>, <code>UPDATE</code>, <code>DELETE</code>, <code>MERGE</code>). It sends collections of data from PL/SQL to SQL in one go, drastically reducing the back-and-forth overhead. Think of it as hitting the gym for your DML – it bulks up performance! 🏋️‍♀️</p>
     <p>Using <code>SQL%ROWCOUNT</code> after a <code>FORALL</code> statement gives you the total count of rows affected by the entire bulk operation, neat and sweet.</p>
    </div>
    <div class="postgresql-bridge">
    <p>While PostgreSQL relies on client-side batching or clever set-based SQL (`UPDATE FROM`, `INSERT FROM SELECT`), Oracle's <code>BULK COLLECT</code> and <code>FORALL</code> provide built-in PL/SQL language features for achieving server-side bulk data movement and DML, often making the code more explicit and contained within the database layer.</p>
    <p>PostgreSQL's array types are more flexible in terms of indexing and density by default, whereas Oracle separates these characteristics into different collection types (Associative Array, Nested Table, Varray).</p>
    </div>

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- End Bulk Operations ---');

END;
/
```

**Exercise 1.3: Dynamic SQL - EXECUTE IMMEDIATE for DDL and DML**

*   **Problem:** Sometimes the exact SQL statement is not known until runtime. Oracle provides `EXECUTE IMMEDIATE` and `DBMS_SQL` for this. Focus on `EXECUTE IMMEDIATE` here.
    *   Create a PL/SQL block that takes a table name (VARCHAR2) as input and dynamically drops that table using `EXECUTE IMMEDIATE`. Use the `IF EXISTS` clause (23ai feature) within the dynamic SQL string. Test it by trying to drop a table that exists (`dynamicDataTarget`) and one that doesn't (`nonExistentTable`).
    *   Create a PL/SQL block that takes a `customerName` (VARCHAR2) and `actionDetails` (VARCHAR2) as input and dynamically inserts a row into the `customerLog` table using `EXECUTE IMMEDIATE`. Use bind variables (`:1`, `:2`) in the dynamic string and the `USING` clause. Demonstrate inserting a log entry.
    *   Create a PL/SQL block that takes an `employeeId` (NUMBER) and a `newSalary` (NUMBER) as input and dynamically updates the `salary` for that employee in the `employees` table using `EXECUTE IMMEDIATE`. Use bind variables (`:newSal`, `:empId`) in the dynamic string (demonstrating named binds) and the `USING` clause. Demonstrate updating an employee's salary. Print the old and new salary using a subsequent `SELECT INTO` (this part can be static).
    *   *Bridge from PostgreSQL:* In PostgreSQL, you might use `EXECUTE format(...)` or prepare statements with dynamic parameters. `EXECUTE IMMEDIATE` is Oracle's standard way for simple dynamic SQL, using bind variables via the `USING` clause, which is similar in concept to prepared statements. Demonstrate the Oracle syntax and bind variable usage.

*   **Solution 1.3:**

```sql
-- Create table first for drop example
CREATE TABLE dynamicDataTarget (
    id NUMBER PRIMARY KEY,
    stringValue VARCHAR2(100),
    numericValue NUMBER,
    dateValue DATE
);
/

DECLARE
    v_tableName VARCHAR2(30);
    v_sqlStmt VARCHAR2(100);

    v_customerName VARCHAR2(100);
    v_actionDetails VARCHAR2(4000);
    v_logId NUMBER;

    v_employeeId employees.employeeId%TYPE;
    v_newSalary employees.salary%TYPE;
    v_oldSalary employees.salary%TYPE;
    v_employeeLastName employees.lastName%TYPE;
    v_selectStmt VARCHAR2(100);

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Dynamic SQL (EXECUTE IMMEDIATE) ---');

    -- 1. Dynamic DDL (DROP TABLE IF EXISTS)
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Dynamic DDL ---');
    v_tableName := 'dynamicDataTarget';
    -- Construct DDL string using concatenation (table name must be part of the string)
    v_sqlStmt := 'DROP TABLE ' || v_tableName || ' IF EXISTS'; -- Use 23ai IF EXISTS
    DBMS_OUTPUT.PUT_LINE('Executing: ' || v_sqlStmt);
    EXECUTE IMMEDIATE v_sqlStmt; -- EXECUTE IMMEDIATE runs the dynamic DDL
    DBMS_OUTPUT.PUT_LINE('Table ' || v_tableName || ' dropped (if existed).');

    v_tableName := 'nonExistentTable';
    v_sqlStmt := 'DROP TABLE ' || v_tableName || ' IF EXISTS';
    DBMS_OUTPUT.PUT_LINE('Executing: ' || v_sqlStmt);
    EXECUTE IMMEDIATE v_sqlStmt;
    DBMS_OUTPUT.PUT_LINE('Table ' || v_tableName || ' attempted to drop (should not error due to IF EXISTS).');

    -- Recreate the table for subsequent examples
    v_sqlStmt := 'CREATE TABLE dynamicDataTarget (id NUMBER PRIMARY KEY, stringValue VARCHAR2(100), numericValue NUMBER, dateValue DATE)';
    DBMS_OUTPUT.PUT_LINE('Executing: ' || v_sqlStmt);
    EXECUTE IMMEDIATE v_sqlStmt;
    DBMS_OUTPUT.PUT_LINE('Table dynamicDataTarget recreated.');

    -- 2. Dynamic DML (INSERT) with Bind Variables
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Dynamic INSERT with Bind Variables ---');
    v_customerName := 'Charlie';
    v_actionDetails := 'Placed new order.';
    -- Use placeholders (:1, :2) in the dynamic string
    v_sqlStmt := 'INSERT INTO customerLog (logId, logTimestamp, customerName, actionDetails) VALUES (customerLog_seq.NEXTVAL, SYSTIMESTAMP, :1, :2)';

    DBMS_OUTPUT.PUT_LINE('Executing: ' || v_sqlStmt || ' USING ''' || v_customerName || ''', ''' || v_actionDetails || '''');
    EXECUTE IMMEDIATE v_sqlStmt USING v_customerName, v_actionDetails; -- Provide values for placeholders via USING clause (positional)
    DBMS_OUTPUT.PUT_LINE('Log entry inserted.');

    -- Verify insertion (static select)
    SELECT logId INTO v_logId FROM customerLog WHERE customerName = 'Charlie' ORDER BY logTimestamp DESC FETCH FIRST 1 ROW ONLY; -- 23ai FETCH FIRST
    DBMS_OUTPUT.PUT_LINE('Inserted logId: ' || v_logId);


    -- 3. Dynamic DML (UPDATE) with Named Bind Variables
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Dynamic UPDATE with Named Bind Variables ---');
    v_employeeId := 1000; -- John Smith
    v_newSalary := 75000;
    -- Use named placeholders (:newSal, :empId) in the dynamic string
    v_sqlStmt := 'UPDATE employees SET salary = :newSal WHERE employeeId = :empId';

    -- Get old salary first (static)
    SELECT salary, lastName INTO v_oldSalary, v_employeeLastName FROM employees WHERE employeeId = v_employeeId;
    DBMS_OUTPUT.PUT_LINE('Old salary for ' || v_employeeLastName || ': ' || v_oldSalary);

    DBMS_OUTPUT.PUT_LINE('Executing: ' || v_sqlStmt || ' USING :newSal=' || v_newSalary || ', :empId=' || v_employeeId);
    -- Provide values for named placeholders via USING clause (can use name or position)
    EXECUTE IMMEDIATE v_sqlStmt USING :newSal v_newSalary, :empId v_employeeId; -- Using named association for clarity

    -- Verify update (static)
    SELECT salary INTO v_oldSalary FROM employees WHERE employeeId = v_employeeId; -- Fetch updated salary into old variable
    DBMS_OUTPUT.PUT_LINE('New salary for ' || v_employeeLastName || ': ' || v_oldSalary);

    -- Rollback the change
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Rolled back salary update.');

    <div class="oracle-specific">
    <p><code>EXECUTE IMMEDIATE</code> is Oracle's simplest form of Native Dynamic SQL. It compiles and runs a dynamic SQL statement in one go.</p>
    <p>Key to safe and efficient dynamic SQL is using **bind variables** (<code>:name</code> or <code>:position</code>) for values that are not known until runtime. These are passed separately in the <code>USING</code> clause and prevent SQL injection, while also allowing Oracle to reuse the parsed statement (improving performance via soft parsing).</p>
    <p>Dynamic DDL (like <code>DROP TABLE</code>) must be built by concatenating the object name directly into the string, as object names cannot be bind variables. Oracle 23ai's <code>IF EXISTS</code> is a nice touch for more robust dynamic DDL.</p>
    </div>
    <div class="postgresql-bridge">
    <p>Oracle's <code>EXECUTE IMMEDIATE</code> with the <code>USING</code> clause is conceptually similar to PostgreSQL's <code>EXECUTE format(...)</code> combined with parameter substitution (e.g., <code>$1</code>, <code>$2</code>) in prepared statements or `EXECUTE` blocks, offering a way to safely pass values without concatenation.</p>
     <p>Both RDBMS require care when constructing dynamic SQL, but Oracle provides dedicated syntax (`EXECUTE IMMEDIATE`, <code>DBMS_SQL</code>) compared to PostgreSQL's reliance on `EXECUTE` and the generic `format()` function.</p>
    </div>

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- End Dynamic SQL (EXECUTE IMMEDIATE) ---');

END;
/
```

#### **(ii) Disadvantages and Pitfalls**

**Exercise 2.1: Collection Pitfalls - Nulls, Non-Existence, and Type Mismatches**

*   **Problem:** Working with collections in Oracle can have subtle pitfalls, especially related to nulls, non-existent elements, and type compatibility.
    *   Create a Nested Table variable `sparseList` of numbers. Populate it with elements at indices 1, 5, and 10, leaving gaps. Attempt to access `sparseList(3)` directly without checking for existence. Handle the expected exception (`NO_DATA_FOUND` or `SUBSCRIPT_DOES_NOT_EXIST`). Then use the `EXISTS` method to check if element 3 exists.
    *   Declare a Nested Table variable `nullNestedTable` and assign `NULL` to it (making it atomically null). Attempt to use the `COUNT` method on `nullNestedTable`. Handle the expected exception (`COLLECTION_IS_NULL`). Use the `EXISTS` method on the same `nullNestedTable` (it should not raise an exception).
    *   Declare a Varray variable `stringVarray` of size 3. Initialize it with 3 elements. Attempt to `EXTEND` it to size 4. Handle the expected exception (`SUBSCRIPT_BEYOND_LIMIT`).
    *   Declare two Nested Table types, `typeA` and `typeB`, with identical structures (e.g., `TABLE OF NUMBER`). Declare variables `ntA` of `typeA` and `ntB` of `typeB`. Initialize `ntA`. Attempt to assign `ntA` to `ntB`. Explain the result. (*Bridge from PostgreSQL:* PostgreSQL arrays of the same base type are generally assignable).
    *   Create a PL/SQL block to fetch a row from the `orderItems` table into a record variable declared using `orderItems%ROWTYPE`. Attempt to insert this record directly into a table that has a `GENERATED ALWAYS` column (like `orderItems` itself). Explain the result.

*   **Solution 2.1:**

```sql
-- Ensure types and tables exist from dataset setup
-- CREATE OR REPLACE TYPE nestedIntegerList IS TABLE OF NUMBER;
-- /
-- CREATE OR REPLACE TYPE varrayStringList IS VARRAY(10) OF VARCHAR2(50);
-- /

DECLARE
    type numberList IS TABLE OF NUMBER;
    sparseList numberList := numberList(1=>10, 5=>50, 10=>100); -- Initialize with gaps

    nullNestedTable numberList; -- Declared, but null

    type smallStringArray IS VARRAY(3) OF VARCHAR2(10);
    stringVarray smallStringArray := smallStringArray('One', 'Two', 'Three');

    type typeA IS TABLE OF NUMBER;
    type typeB IS TABLE OF NUMBER; -- Identical structure
    ntA typeA := typeA(1, 2, 3);
    ntB typeB; -- Different type

    itemRow orderItems%ROWTYPE; -- Record includes virtual column
    dummyId NUMBER; -- Used for fetching into itemRow
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Collection Pitfalls ---');

    -- 1. Accessing Non-existent elements in sparse collection
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Sparse Collection Access ---');
    DBMS_OUTPUT.PUT_LINE('Sparse List Count: ' || sparseList.COUNT);
    DBMS_OUTPUT.PUT_LINE('Indices: ' || sparseList.FIRST || ' to ' || sparseList.LAST); -- LAST is the highest index

    BEGIN
        DBMS_OUTPUT.PUT_LINE('Attempting to access sparseList(3):');
        DBMS_OUTPUT.PUT_LINE(sparseList(3)); -- This will fail
    EXCEPTION
        WHEN NO_DATA_FOUND OR SUBSCRIPT_DOES_NOT_EXIST THEN
            DBMS_OUTPUT.PUT_LINE('Caught exception: Element at index 3 does not exist.');
    END;

    DBMS_OUTPUT.PUT_LINE('Checking sparseList.EXISTS(3): ' || CASE WHEN sparseList.EXISTS(3) THEN 'TRUE' ELSE 'FALSE' END);
    DBMS_OUTPUT.PUT_LINE('Checking sparseList.EXISTS(5): ' || CASE WHEN sparseList.EXISTS(5) THEN 'TRUE' ELSE 'FALSE' END);


    -- 2. Using methods on null collections
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Null Collection Methods ---');
    DBMS_OUTPUT.PUT_LINE('nullNestedTable IS NULL: ' || CASE WHEN nullNestedTable IS NULL THEN 'TRUE' ELSE 'FALSE' END); -- Correct way to check null

    BEGIN
        DBMS_OUTPUT.PUT_LINE('Attempting to get COUNT of nullNestedTable:');
        DBMS_OUTPUT.PUT_LINE(nullNestedTable.COUNT); -- This will fail
    EXCEPTION
        WHEN COLLECTION_IS_NULL THEN
            DBMS_OUTPUT.PUT_LINE('Caught exception: Cannot use COUNT on a null collection.');
    END;

    DBMS_OUTPUT.PUT_LINE('Checking nullNestedTable.EXISTS(1): ' || CASE WHEN nullNestedTable.EXISTS(1) THEN 'TRUE' ELSE 'FALSE' END); -- EXISTS works on null collection

    -- 3. Varray SUBSCRIPT_BEYOND_LIMIT
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Varray Limit ---');
    DBMS_OUTPUT.PUT_LINE('Varray max size: ' || stringVarray.LIMIT);
    DBMS_OUTPUT.PUT_LINE('Varray current size: ' || stringVarray.COUNT);

    BEGIN
        DBMS_OUTPUT.PUT_LINE('Attempting to EXTEND varray beyond limit...');
        stringVarray.EXTEND; -- This will fail as max size is 3
    EXCEPTION
        WHEN SUBSCRIPT_BEYOND_LIMIT THEN
            DBMS_OUTPUT.PUT_LINE('Caught exception: Cannot EXTEND varray beyond its declared limit.');
    END;

    -- 4. Collection Type Mismatch for Assignment
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Collection Type Mismatch ---');
    DBMS_OUTPUT.PUT_LINE('ntA is of type typeA, ntB is of type typeB.');
    DBMS_OUTPUT.PUT_LINE('Attempting assignment: ntB := ntA;');
    BEGIN
        ntB := ntA; -- This will fail
    EXCEPTION
        WHEN OTHERS THEN -- ORA-06550 PLS-00382 expression of wrong type
            DBMS_OUTPUT.PUT_LINE('Caught exception: Cannot assign collection variable ntA to ntB due to type mismatch (even if structure is identical).');
            DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE || ', Message: ' || SQLERRM);
    END;

    -- 5. %ROWTYPE Record with Virtual Columns Pitfall
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- %ROWTYPE with Virtual Column ---');
    -- Fetch a row including the virtual column
    SELECT * INTO itemRow FROM orderItems WHERE orderItemId = orderItems_seq.FIRST FETCH FIRST 1 ROW ONLY;
    DBMS_OUTPUT.PUT_LINE('Fetched item ' || itemRow.orderItemId || ', Virtual Column itemAmount: ' || itemRow.itemAmount);

    -- Attempt to insert this record directly into a table with a virtual column (like orderItems itself)
    -- Using a temporary table similar to orderItems but without the sequence default
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE tempOrderItemsInsert IF EXISTS';
        EXECUTE IMMEDIATE 'CREATE TABLE tempOrderItemsInsert (orderItemId NUMBER PRIMARY KEY, orderId NUMBER, productId NUMBER, quantity NUMBER NOT NULL, unitPrice NUMBER(10,2) NOT NULL, itemAmount NUMBER(10,2) GENERATED ALWAYS AS (quantity * unitPrice) VIRTUAL)';

        DBMS_OUTPUT.PUT_LINE('Attempting INSERT INTO tempOrderItemsInsert VALUES itemRow;');
        -- This syntax INSERT ... VALUES recordName is not allowed when the record includes a virtual column
        -- The next line will raise an error ORA-54013
        -- INSERT INTO tempOrderItemsInsert VALUES itemRow; -- This fails as expected

        -- Workaround: Insert field by field, EXCLUDING the virtual column
        EXECUTE IMMEDIATE 'INSERT INTO tempOrderItemsInsert (orderItemId, orderId, productId, quantity, unitPrice) VALUES (:1, :2, :3, :4, :5)'
        USING itemRow.orderItemId, itemRow.orderId, itemRow.productId, itemRow.quantity, itemRow.unitPrice;

        DBMS_OUTPUT.PUT_LINE('Successfully inserted row field by field, excluding virtual column.');
        EXECUTE IMMEDIATE 'DROP TABLE tempOrderItemsInsert IF EXISTS';

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught exception during %ROWTYPE insert attempt:');
            DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE || ', Message: ' || SQLERRM);
            -- Clean up temp table if it exists from failed create
            BEGIN EXECUTE IMMEDIATE 'DROP TABLE tempOrderItemsInsert IF EXISTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
    END;

    <div class="caution">
    <p>Be wary of null collections (atomically null) versus empty collections. Atomically null collections cannot be used with most collection methods (like <code>COUNT</code>, <code>FIRST</code>, <code>LAST</code>, <code>EXTEND</code>, <code>DELETE</code>) without raising <code>COLLECTION_IS_NULL</code>. Only <code>EXISTS</code> works on a null collection.</p>
    <p>Accessing elements in a sparse collection (Associative Array or Nested Table after <code>DELETE</code>) at an index that doesn't exist will raise <code>NO_DATA_FOUND</code> or <code>SUBSCRIPT_DOES_NOT_EXIST</code>. Always check with <code>EXISTS</code> first!</p>
    <p>Varrays have a fixed maximum size declared in their type definition. Trying to <code>EXTEND</code> beyond this limit will cause <code>SUBSCRIPT_BEYOND_LIMIT</code>. There's just no room for one more bloom! 🌼</p>
    <p>Oracle's PL/SQL collection variables require an **exact type match** for assignment, even if the structures defined for the types are identical. This is stricter than PostgreSQL's array compatibility.</p>
    <p>Records defined with <code>%ROWTYPE</code> that include a <code>GENERATED ALWAYS</code> virtual column cannot be inserted directly into a table using the <code>INSERT ... VALUES recordName</code> syntax. You must insert field by field, omitting the virtual column.</p>
    </div>
    <div class="postgresql-bridge">
    <p>PostgreSQL arrays handle non-existent elements by returning NULL (or an error if configured strictly) when accessed out of bounds, but they don't have dedicated methods like Oracle's <code>EXISTS</code>. PostgreSQL arrays of the same element type are generally assignable, unlike Oracle's stricter collection type matching.</p>
    <p>PostgreSQL doesn't have explicit fixed-size arrays like Oracle Varrays or the concept of atomically null collections in the same way.</p>
    </div>


    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- End Collection Pitfalls ---');

END;
/
```

**Exercise 2.2: Bulk Operations Pitfalls - Exception Handling**

*   **Problem:** Bulk operations are efficient but require careful exception handling, as a single error within the batch can affect the entire `FORALL` statement.
    *   Create a PL/SQL block that declares an associative array `productUpdates` (indexed by PLS_INTEGER, value is VARCHAR2) and populates it with new `productName` values for products, including one value that is too long for the `productName` column (e.g., for `productId` 3000, set name to a very long string).
    *   Use a `FORALL` statement *without* the `SAVE EXCEPTIONS` clause to update the `productName` in the `products` table based on this collection. Include a simple `WHEN OTHERS` exception handler. Observe which updates (before and after the error) are rolled back.
    *   Repeat the previous block, but this time use the `FORALL ... SAVE EXCEPTIONS` clause. Handle the `ORA-24381` exception specifically. Inside the handler, loop through `SQL%BULK_EXCEPTIONS` to report the index and error code for each failed DML statement within the batch. Check the `products` table afterwards to see which updates succeeded and which failed.

*   **Solution 2.2:**

```sql
DECLARE
    type nameMap IS TABLE OF products.productName%TYPE INDEX BY PLS_INTEGER;
    productUpdates nameMap;

    i PLS_INTEGER;
    errorIndex PLS_INTEGER;
    errorCode PLS_INTEGER;
    errorMessage VARCHAR2(200);

    -- Define exception for ORA-24381 (raised by FORALL SAVE EXCEPTIONS)
    forallErrors EXCEPTION;
    PRAGMA EXCEPTION_INIT(forallErrors, -24381);

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Bulk Operations Exception Handling ---');

    -- Populate collection, including one invalid value
    productUpdates(3001) := 'Standard Keyboard'; -- Valid update 1
    productUpdates(3000) := 'ThisProductNameIsDefinitelyTooLongForAVarchar2ColumnOfSize50ToStoreEffectivelyAndItWillCauseAnError'; -- Invalid update 2
    productUpdates(3002) := 'Ergonomic Mouse'; -- Valid update 3
    -- Note: The order of execution within the FORALL batch is not guaranteed,
    -- but the errors reported by SAVE EXCEPTIONS will have an index corresponding
    -- to the index in the collection range used by FORALL.

    -- 1. FORALL WITHOUT SAVE EXCEPTIONS
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- FORALL without SAVE EXCEPTIONS ---');

    -- Restore initial product names for the first test
     UPDATE products SET productName = 'Keyboard' WHERE productId = 3001;
     UPDATE products SET productName = 'Laptop 15"' WHERE productId = 3000;
     UPDATE products SET productName = 'Mouse' WHERE productId = 3002;
     COMMIT;
     DBMS_OUTPUT.PUT_LINE('Product names reset. Attempting FORALL update without SAVE EXCEPTIONS...');

    BEGIN
        -- Without SAVE EXCEPTIONS, the first error encountered stops the entire FORALL batch
        -- and rolls back all changes made *within that batch* up to the point of the error.
        FORALL i IN productUpdates.FIRST .. productUpdates.LAST
            UPDATE products
            SET productName = productUpdates(i)
            WHERE productId = i;
        -- This line should not be reached if an error occurs
        DBMS_OUTPUT.PUT_LINE('FORALL completed successfully (unexpected).');
        COMMIT; -- Commit changes if it somehow succeeds
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught exception during FORALL: ' || SQLERRM);
            -- The changes attempted by the FORALL batch are automatically rolled back
            -- to the state before the FORALL statement began if an unhandled exception occurs.
            DBMS_OUTPUT.PUT_LINE('Checking product names after error (should be rolled back to original):');
             FOR i IN productUpdates.FIRST .. productUpdates.LAST LOOP
                 BEGIN
                     -- Use PRIOR/NEXT or a simple loop from FIRST to LAST depending on collection density/index type
                     SELECT productName INTO productUpdates(i) FROM products WHERE productId = productUpdates.PRIOR(i) + 1; -- Fetch current names, crude way
                     DBMS_OUTPUT.PUT_LINE('  ID ' || productUpdates.PRIOR(i) + 1 || ': ' || productUpdates(i));
                 EXCEPTION WHEN NO_DATA_FOUND THEN NULL; -- Ignore if index not in map
                 END;
            END LOOP;
            ROLLBACK; -- Explicit rollback after OTHERS handler is still good practice for the overall transaction context
    END;

    -- 2. FORALL WITH SAVE EXCEPTIONS
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- FORALL with SAVE EXCEPTIONS ---');
    -- Restore product names again for the second test
     UPDATE products SET productName = 'Keyboard' WHERE productId = 3001;
     UPDATE products SET productName = 'Laptop 15"' WHERE productId = 3000;
     UPDATE products SET productName = 'Mouse' WHERE productId = 3002;
     COMMIT;
     DBMS_OUTPUT.PUT_LINE('Product names reset. Attempting FORALL update WITH SAVE EXCEPTIONS...');

    BEGIN
        -- SAVE EXCEPTIONS allows the FORALL to attempt ALL DMLs in the batch.
        -- If any fail, it stores the error info in SQL%BULK_EXCEPTIONS and raises ORA-24381 at the end of the batch.
        FORALL i IN productUpdates.FIRST .. productUpdates.LAST SAVE EXCEPTIONS
            UPDATE products
            SET productName = productUpdates(i)
            WHERE productId = i;

        DBMS_OUTPUT.PUT_LINE('FORALL completed successfully (unexpected - should raise ORA-24381 due to long name).');
        COMMIT; -- If somehow it succeeds, commit

    EXCEPTION
        WHEN forallErrors THEN
            DBMS_OUTPUT.PUT_LINE('Caught ORA-24381 exception (FORALL completed with errors).');
            DBMS_OUTPUT.PUT_LINE('Number of stock update errors: ' || SQL%BULK_EXCEPTIONS.COUNT);
            -- Loop through the errors collected in the implicit cursor attribute SQL%BULK_EXCEPTIONS
            FOR i IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
                errorIndex := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX; -- Index in the FORALL loop (1, 2, or 3 in this case)
                errorCode := SQL%BULK_EXCEPTIONS(i).ERROR_CODE;
                errorMessage := SQLERRM(-errorCode); -- Get the error message

                -- Retrieve the actual data that caused the failure using the errorIndex
                -- Note: productUpdates(errorIndex) will give you the input value from the collection at the index where the DML *attempt* failed.
                -- This index corresponds to the index in the FORALL loop's collection range.
                -- If FORALL iterates from 1 to N, SQL%BULK_EXCEPTIONS(i).ERROR_INDEX is the loop index (1..N).
                DBMS_OUTPUT.PUT_LINE('  Error ' || i || ': Collection Index=' || errorIndex ||
                                    ', Error Code=' || errorCode ||
                                    ', Message=' || errorMessage ||
                                    ', Data Attempted: Product ID ' || productUpdates.PRIOR(errorIndex) + 1 || -- Assuming sequential indices starting from 1
                                    ', New Name: "' || productUpdates(errorIndex) || '"');
            END LOOP;
            -- Check product names after SAVE EXCEPTIONS FORALL (valid ones should be updated)
            DBMS_OUTPUT.PUT_LINE('Checking product names after SAVE EXCEPTIONS FORALL:');
            -- In a FORALL with SAVE EXCEPTIONS, the DMLs that *succeeded* are *NOT* automatically rolled back.
            -- They are part of the current transaction and will be committed or rolled back with the main transaction.
             FOR i IN productUpdates.FIRST .. productUpdates.LAST LOOP
                 BEGIN
                     SELECT productName INTO productUpdates(i) FROM products WHERE productId = productUpdates.PRIOR(i) + 1; -- Fetch current names
                     DBMS_OUTPUT.PUT_LINE('  ID ' || productUpdates.PRIOR(i) + 1 || ': ' || productUpdates(i));
                 EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
                 END;
            END LOOP;
            -- Commit or Rollback the transaction as needed based on overall success criteria.
            -- For this exercise, we commit to show that the valid updates persisted.
            COMMIT;

        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught unexpected exception during FORALL WITH SAVE EXCEPTIONS: ' || SQLERRM);
             ROLLBACK; -- Rollback if an unexpected error occurred
    END;

    <div class="caution">
    <p>Using <code>FORALL</code> without <code>SAVE EXCEPTIONS</code> is a recipe for disappointment if any batch item might fail! One bad apple, one bad batch! 🍎 Batch failure leads to rolling back the whole batch.</p>
    <p><code>SAVE EXCEPTIONS</code> is your friend for resilience. It allows valid DMLs in the batch to succeed while reporting failures. You then handle the specific errors using <code>SQL%BULK_EXCEPTIONS</code> after the batch finishes. This gives you fine-grained control over which changes to keep.</p>
    </div>

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- End Bulk Operations Exception Handling ---');

END;
/
```

**Exercise 2.3: Dynamic SQL Pitfalls - SQL Injection and String Concatenation**

*   **Problem:** Using string concatenation to build dynamic SQL is a major security vulnerability (SQL Injection) and can also cause parsing inefficiencies.
    *   Create a PL/SQL procedure `getLogEntryVulnerable` that takes `logId` (NUMBER) and `customerName` (VARCHAR2) as input. Build a dynamic `SELECT ... INTO` statement for `customerLog` by *directly concatenating* the inputs into the `WHERE` clause. Select `actionDetails` into an `OUT` parameter. Print the constructed query string before executing it.
    *   Test `getLogEntryVulnerable` with a valid `logId` (e.g., from the initial dataset) and `customerName` (e.g., 'Alice').
    *   Test `getLogEntryVulnerable` with a malicious `customerName` input designed for SQL Injection, such as `'Alice' OR 1=1 --`. Observe the printed query and the result. Explain why this is vulnerable.
    *   Create a *safe* version of the procedure `getLogEntrySafe` that uses `EXECUTE IMMEDIATE` with **bind variables** (`:logId`, `:custName`) for the `logId` and `customerName` inputs. Print the query string (it should show placeholders). Test it with the same malicious input. Observe the printed query and the result. Explain why this approach prevents injection.
    *   *Bridge from PostgreSQL:* PostgreSQL is also vulnerable to SQL injection when concatenating strings. The `format()` function or prepared statements with parameters (`$1`, `$2`, etc.) are the safe equivalents. Oracle's `EXECUTE IMMEDIATE` with `USING` and `DBMS_SQL` with bind variables are the standard safe methods.

*   **Solution 2.3:**

```sql
-- Note: Re-run dataset setup if you ran Exercise 1.3 and rolled back,
-- or if you want to ensure log entries are present for testing.
-- COMMIT; -- Ensure log entries from setup or previous exercises are saved.

CREATE OR REPLACE PROCEDURE getLogEntryVulnerable (
    p_logId IN NUMBER,
    p_customerName IN VARCHAR2,
    p_actionDetails OUT VARCHAR2
)
IS
    v_sqlStmt VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Vulnerable Dynamic SQL ---');
    -- Vulnerable: Directly concatenating user input into the SQL string.
    -- This allows the user input to be interpreted as SQL code.
    v_sqlStmt := 'SELECT actionDetails FROM customerLog WHERE logId = ' || p_logId ||
                 ' AND customerName = ''' || p_customerName || '''';

    DBMS_OUTPUT.PUT_LINE('Constructed Query: ' || v_sqlStmt);

    EXECUTE IMMEDIATE v_sqlStmt INTO p_actionDetails;

    DBMS_OUTPUT.PUT_LINE('Resulting actionDetails: ' || p_actionDetails);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the given criteria.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE getLogEntrySafe (
    p_logId IN NUMBER,
    p_customerName IN VARCHAR2,
    p_actionDetails OUT VARCHAR2
)
IS
    v_sqlStmt VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Safe Dynamic SQL (Bind Variables) ---');
    -- Safe: Using bind variables (:name or :position) as placeholders in the SQL string.
    -- The actual values are passed separately via the USING clause.
    v_sqlStmt := 'SELECT actionDetails FROM customerLog WHERE logId = :logId AND customerName = :custName';

    DBMS_OUTPUT.PUT_LINE('Constructed Query (with placeholders): ' || v_sqlStmt);
    DBMS_OUTPUT.PUT_LINE('Binding logId: ' || p_logId || ', custName: ' || p_customerName);

    EXECUTE IMMEDIATE v_sqlStmt INTO p_actionDetails USING :logId p_logId, :custName p_customerName; -- Provide values for placeholders via USING clause

    DBMS_OUTPUT.PUT_LINE('Resulting actionDetails: ' || p_actionDetails);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for the given criteria.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- Test calls for getLogEntryVulnerable
DECLARE
    v_details VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Testing getLogEntryVulnerable ---');
    -- Test with valid input
    -- Assuming logId 4000 exists for Alice
    getLogEntryVulnerable(4000, 'Alice', v_details);

    -- Test with malicious input (SQL Injection attempt)
    -- Input: ' OR 1=1 --
    -- Concatenated query becomes: SELECT actionDetails FROM customerLog WHERE logId = 4000 AND customerName = '' OR 1=1 --''
    -- The '' closes the string literal, OR 1=1 is always true, -- comments out the rest of the line.
    -- Effective WHERE: WHERE logId = 4000 AND ('' OR 1=1) which simplifies to WHERE logId = 4000
     getLogEntryVulnerable(4000, ''' OR 1=1 --', v_details);

    DBMS_OUTPUT.PUT_LINE(CHR(10));
END;
/

-- Test calls for getLogEntrySafe
DECLARE
    v_details VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Testing getLogEntrySafe ---');
    -- Test with valid input
    getLogEntrySafe(4000, 'Alice', v_details);

    -- Test with malicious input (SQL Injection attempt)
    -- Input: ' OR 1=1 --
    -- This string is passed as a literal *value* to the :custName bind variable.
    -- The database does NOT interpret the quotes, OR, or -- as SQL syntax.
    -- Effective WHERE: WHERE logId = 4000 AND customerName = ''' OR 1=1 --'
    -- This will find no rows unless a customer *actually* has that bizarre name.
     getLogEntrySafe(4000, ''' OR 1=1 --', v_details);

    DBMS_OUTPUT.PUT_LINE(CHR(10));
END;
/

<div class="caution">
<p>Direct string concatenation for dynamic SQL (shown in <code>getLogEntryVulnerable</code>) is the primary cause of **SQL Injection**. User input can contain malicious code (like `' OR 1=1 --'`) that alters the intended query logic. A simple concatenation can turn your careful <code>WHERE</code> clause into Swiss cheese! 🧀</p>
</div>
<div class="oracle-specific">
<p>Using **bind variables** with <code>EXECUTE IMMEDIATE</code> (shown in <code>getLogEntrySafe</code>) is the **most effective guard** against SQL injection. The database treats bind variable values purely as data, never as executable code. This approach is also generally more efficient as it allows Oracle to reuse the parsed statement definition for subsequent executions with different values (soft parsing).</p>
<p>Oracle's SQL Firewall (an Oracle 23ai feature) adds another layer of protection by analyzing SQL statements before they reach the parser, helping to detect and block potentially malicious dynamic SQL constructed even with some concatenation, but bind variables are the first line of defense!</p>
</div>
<div class="postgresql-bridge">
<p>SQL injection is a risk in PostgreSQL dynamic queries built with concatenation too. PostgreSQL's equivalent safe method is typically using parameterized queries with <code>$N</code> placeholders or the <code>format()</code> function. Oracle's `EXECUTE IMMEDIATE ... USING` serves the same crucial purpose as safe parameter binding in PostgreSQL.</p>
</div>

DBMS_OUTPUT.PUT_LINE(CHR(10));
```

**Exercise 2.4: DBMS_SQL vs EXECUTE IMMEDIATE - When to Use Which (Conceptual)**

*   **Problem:** Both `EXECUTE IMMEDIATE` (Native Dynamic SQL) and `DBMS_SQL` can run dynamic SQL. Understand their conceptual differences and when each is appropriate in Oracle DB 23ai.
    *   Describe a scenario where you *must* use `DBMS_SQL` instead of `EXECUTE IMMEDIATE`. (Hint: Think about compile-time knowledge of the SQL structure).
    *   Describe a scenario where you *must* use Native Dynamic SQL (`EXECUTE IMMEDIATE` or `OPEN FOR ... USING`) instead of `DBMS_SQL`. (Hint: Think about processing fetched data).
    *   Describe a scenario where you might prefer `EXECUTE IMMEDIATE` over `DBMS_SQL` for simplicity and potentially better performance (for simple cases).
    *   *(Conceptual Exercise - No Code Needed)*

*   **Solution 2.4:**

*   **Scenario requiring `DBMS_SQL`:** You *must* use `DBMS_SQL` when the structure of the dynamic SQL statement is **not known at compile time**. This primarily applies to:
    *   Dynamic `SELECT` statements where the **number or data types of columns in the `SELECT` list** are unknown until runtime (e.g., building a report query where columns are selected based on user input). `DBMS_SQL` allows you to use `DESCRIBE_COLUMNS` at runtime to find out the structure and then define output variables accordingly (`DEFINE_COLUMN`) and fetch data (`COLUMN_VALUE`).
    *   Dynamic DML or `SELECT` statements where the **number or data types of bind variables** are unknown until runtime. `DBMS_SQL` allows binding variables programmatically without needing a fixed number of `:placeholders` at compile time.
    *   When a stored subprogram needs to return query results *implicitly* to a client (not through an `OUT REF CURSOR`). This requires the `DBMS_SQL.RETURN_RESULT` procedure.
    *   *(Reference: Oracle Database PL/SQL Packages and Types Reference, Chapter 187, DBMS_SQL Overview)*

*   **Scenario requiring Native Dynamic SQL (NDS) / `EXECUTE IMMEDIATE` or `OPEN FOR ... USING`:** You *must* use Native Dynamic SQL when you need to:
    *   Use **SQL cursor attributes** (`SQL%ROWCOUNT`, `SQL%FOUND`, `SQL%NOTFOUND`, `SQL%ISOPEN`) after executing a dynamic DML statement or a single-row `SELECT INTO`. These attributes only work with NDS statements.
    *   Fetch multiple rows from a dynamic `SELECT` statement **directly into a PL/SQL collection of records** using the `BULK COLLECT INTO` clause (e.g., `OPEN dynamic_cursor FOR dynamic_sql_string; FETCH dynamic_cursor BULK COLLECT INTO collection_of_records;`). `DBMS_SQL` can fetch into collections of scalar types but not collections of records.
    *   *(Reference: Oracle Database PL/SQL Language Reference, Chapter 8, Native Dynamic SQL)*

*   **Scenario preferring `EXECUTE IMMEDIATE`:** For simpler dynamic SQL statements where the structure is **known at compile time**, such as:
    *   Dynamic DDL (`CREATE`, `ALTER`, `DROP`).
    *   Simple dynamic DML (`INSERT`, `UPDATE`, `DELETE`, `MERGE`).
    *   Dynamic single-row `SELECT INTO`.
    `EXECUTE IMMEDIATE` uses simpler syntax, is generally easier to write and understand, and for these straightforward cases, often performs as well as or better than `DBMS_SQL` because Oracle's compiler can apply more optimizations. It's the go-to tool when `DBMS_SQL`'s runtime flexibility for unknown structures isn't required.

<div class="oracle-specific">
<p>Choosing between <code>EXECUTE IMMEDIATE</code> (NDS) and <code>DBMS_SQL</code> hinges on whether the structure of your dynamic SQL is fixed at compile time or needs to be discovered dynamically at runtime.</p>
<p>Think of NDS (<code>EXECUTE IMMEDIATE</code>, <code>OPEN FOR</code>) as the "known structure, easy API" path, while <code>DBMS_SQL</code> is the "unknown structure, more detailed API" path.</p>
</div>
<div class="postgresql-bridge">
<p>PostgreSQL doesn't have this strict dichotomy; dynamic execution with parameter binding is handled more uniformly, typically through server-side languages (`PL/pgSQL EXECUTE`) or client libraries. Oracle's separation of NDS and <code>DBMS_SQL</code> requires a deliberate choice based on the dynamic nature of the query structure itself.</p>
</div>

#### **(iii) Contrasting with Inefficient Common Solutions**

**Exercise 3.1: Row-by-Row Processing vs. Bulk Operations**

*   **Problem:** Processing data row by row between the SQL and PL/SQL engines is a common, intuitive approach but is highly inefficient for large datasets due to numerous context switches.
    *   Create a PL/SQL anonymous block that updates the `stockQuantity` for a list of product IDs provided in an associative array `productIdsToUpdate` (e.g., IDs 3000, 3002, 3005). Implement this using a standard `FOR LOOP` that iterates through the array and executes an individual `UPDATE` statement for each element inside the loop.
    *   Create a second PL/SQL anonymous block that achieves the *same update* for the *same list of products and new quantities* using a `FORALL` statement. Assume the new quantities are stored in an associative array `newQuantitiesMap` indexed by the product ID.
    *   Conceptually explain which approach is more efficient for a large number of updates (e.g., thousands of rows) and why (mention context switches).
    *   *(Note: You don't need to add instrumentation for timing for this exercise, the conceptual explanation is sufficient).*
    *   *Bridge from PostgreSQL:* Iterating and running single statements in a loop is inefficient in PostgreSQL too. PostgreSQL relies on client-side batching or writing C functions for truly high-performance bulk operations, or using set-returning functions and `UPDATE FROM` for set-based logic. Oracle's `FORALL` is a dedicated PL/SQL feature for server-side bulk DML.

*   **Solution 3.1:**

```sql
DECLARE
    -- Collection of Product IDs to update (used in the loop example)
    type productIdList IS TABLE OF products.productId%TYPE INDEX BY PLS_INTEGER;
    productIdsToUpdate productIdList;

    -- Collection of New Quantities (indexed by Product ID, used in FORALL example)
    type newQuantityMap IS TABLE OF products.stockQuantity%TYPE INDEX BY PLS_INTEGER;
    newQuantitiesMap newQuantityMap;

    i PLS_INTEGER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Row-by-Row vs. FORALL ---');

    -- Populate collections for updates
    productIdsToUpdate(1) := 3000; -- Laptop
    productIdsToUpdate(2) := 3002; -- Mouse
    productIdsToUpdate(3) := 3005; -- Desk Chair

    newQuantitiesMap(3000) := 60;
    newQuantitiesMap(3002) := 350;
    newQuantitiesMap(3005) := 40;

    -- Restore initial quantities first for demonstration
    UPDATE products SET stockQuantity = 50 WHERE productId = 3000;
    UPDATE products SET stockQuantity = 300 WHERE productId = 3002;
    UPDATE products SET stockQuantity = 30 WHERE productId = 3005;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Initial quantities: ID 3000=50, ID 3002=300, ID 3005=30');

    -- 1. Row-by-Row Update using FOR LOOP
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Row-by-Row Update ---');
    FOR i IN productIdsToUpdate.FIRST .. productIdsToUpdate.LAST LOOP
        -- This executes a separate UPDATE statement for each element, requiring a context switch
        -- between PL/SQL and SQL engines for every single row.
        UPDATE products
        SET stockQuantity = newQuantitiesMap(productIdsToUpdate(i)) -- Assuming newQuantitiesMap has matching data
        WHERE productId = productIdsToUpdate(i);
        -- COMMIT; -- Avoid commit inside loop for performance, but showing row-by-row structure
    END LOOP;
    COMMIT; -- Commit all changes after the loop

    DBMS_OUTPUT.PUT_LINE('Completed row-by-row updates.');
    SELECT stockQuantity INTO i FROM products WHERE productId = 3000; DBMS_OUTPUT.PUT_LINE('  ID 3000 stock: ' || i);
    SELECT stockQuantity INTO i FROM products WHERE productId = 3002; DBMS_OUTPUT.PUT_LINE('  ID 3002 stock: ' || i);
    SELECT stockQuantity INTO i FROM products WHERE productId = 3005; DBMS_OUTPUT.PUT_LINE('  ID 3005 stock: ' || i);

    -- Reset quantities for the next example
    UPDATE products SET stockQuantity = 50 WHERE productId = 3000;
    UPDATE products SET stockQuantity = 300 WHERE productId = 3002;
    UPDATE products SET stockQuantity = 30 WHERE productId = 3005;
    COMMIT;
     DBMS_OUTPUT.PUT_LINE('Quantities reset for FORALL example.');


    -- 2. Bulk Update using FORALL
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Bulk Update using FORALL ---');
    -- FORALL sends the entire collection to the SQL engine in one batch.
    -- This minimizes context switches and is much more efficient for many rows.
    FORALL i IN newQuantitiesMap.FIRST .. newQuantitiesMap.LAST
        UPDATE products
        SET stockQuantity = newQuantitiesMap(i)
        WHERE productId = i;

    COMMIT; -- Commit the changes

    DBMS_OUTPUT.PUT_LINE('Completed FORALL updates.');
    SELECT stockQuantity INTO i FROM products WHERE productId = 3000; DBMS_OUTPUT.PUT_LINE('  ID 3000 stock: ' || i);
    SELECT stockQuantity INTO i FROM products WHERE productId = 3002; DBMS_OUTPUT.PUT_LINE('  ID 3002 stock: ' || i);
    SELECT stockQuantity INTO i FROM products WHERE productId = 3005; DBMS_OUTPUT.PUT_LINE('  ID 3005 stock: ' || i);


    -- Conceptual Explanation:
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Conceptual Explanation ---');
    DBMS_OUTPUT.PUT_LINE('For updating many rows, the FORALL approach (Bulk SQL) is significantly more efficient.');
    DBMS_OUTPUT.PUT_LINE('The row-by-row FOR LOOP requires a context switch between the PL/SQL engine and the SQL engine for *each* row processed.');
    DBMS_OUTPUT.PUT_LINE('The FORALL statement sends the entire collection of data to the SQL engine in a *single batch*, drastically reducing the number of context switches and overhead.');
    DBMS_OUTPUT.PUT_LINE('This makes FORALL orders of magnitude faster for large bulk DML operations.');

    <div class="caution">
    <p>Using a <code>FOR LOOP</code> to run a DML statement for every row you process is often called "slow by slow" or "row-by-row" processing. It's like walking to the store to buy one apple, then walking back home, then walking back to buy another apple, etc. It's intuitive but inefficient for bulk tasks!</p>
    </div>
     <div class="oracle-specific">
     <p><code>FORALL</code> eliminates this "slow by slow" problem by sending the entire grocery list (the collection) to the store (the SQL engine) in one trip! Less back-and-forth means much faster execution for bulk DML.</p>
     </div>
    <div class="postgresql-bridge">
    <p>The inefficiency of row-by-row processing in a loop isn't unique to Oracle; it's a fundamental performance bottleneck in most RDBMS when mixing procedural code and SQL row by row. PostgreSQL users also know this and often use `UPDATE FROM` or client-side batching. Oracle's <code>FORALL</code> provides the server-side language construct explicitly for this bulk DML optimization.</p>
    </div>

END;
/
```

**Exercise 3.2: Manual Dynamic SQL String Building vs. Bind Variables**

*   **Problem:** Directly building SQL strings by concatenating application data (even if not malicious) prevents Oracle from effectively caching and reusing the parsed statement, leading to parsing overhead.
    *   Create a PL/SQL anonymous block that declares a loop counter variable `i`. Loop 100 times. Inside the loop, construct a dynamic `SELECT 1 FROM DUAL WHERE 1 = [loop counter]` statement by *concatenating* the loop counter (`TO_CHAR(i)`) into the string. Execute this statement using `EXECUTE IMMEDIATE`.
    *   Create a second PL/SQL anonymous block that loops 100 times and executes a dynamic `SELECT 1 FROM DUAL WHERE 1 = :value` statement using `EXECUTE IMMEDIATE` with a **bind variable** (`:value`) bound to the loop counter.
    *   Conceptually explain which approach is likely to have lower parsing overhead and better performance when executed repeatedly with different values, and why (mention soft parsing and statement caching).
    *   *(Conceptual Exercise - No Code Needed)*

*   **Solution 3.2:**

*   **Conceptual Explanation:**
    *   The first block, where the dynamic SQL string is built by concatenating the loop counter (`SELECT 1 FROM DUAL WHERE 1 = 1`, `SELECT 1 FROM DUAL WHERE 1 = 2`, ...), generates 100 **different** SQL statement strings from Oracle's perspective. Even though the structure is similar, the literal value embedded in the string makes each statement unique. Oracle's SQL engine will likely perform a **hard parse** for each of these 100 distinct strings the first time it encounters them (unless they are identical to something already in the shared pool, which is unlikely for sequential numbers). Hard parsing is a resource-intensive operation involving syntax checks, semantic checks, query optimization, and generating an execution plan. This is expensive!
    *   The second block, using `EXECUTE IMMEDIATE` with a bind variable (`SELECT 1 FROM DUAL WHERE 1 = :value`), executes the **same** SQL statement string repeatedly. The literal value is passed separately via the `USING` clause. The first time this statement string (`SELECT 1 FROM DUAL WHERE 1 = :value`) is executed, Oracle performs a hard parse. However, for subsequent executions with different bind variable values, Oracle can often perform a **soft parse**. A soft parse reuses the previously generated execution plan and the parsed representation stored in the shared pool, only needing to perform minimal checks and substitute the new bind variable value. This process is significantly faster and uses fewer resources than a hard parse. It's like finding your notes from the first time you studied, rather than starting fresh each time! 📚
    *   Therefore, the approach using **bind variables** will have significantly lower parsing overhead and better performance when executing the same logical query repeatedly with different input values, due to Oracle's ability to reuse the parsed statement and execution plan via soft parsing and statement caching. This is a fundamental principle for building scalable applications in Oracle.

<div class="caution">
<p>Building dynamic SQL with literal concatenation for values is a parsing penalty! Every unique string forces Oracle to potentially hard parse again, costing CPU and preventing efficient plan reuse.</p>
</div>
<div class="oracle-specific">
<p>Bind variables are the secret sauce for efficient dynamic SQL execution. They allow the SQL text to remain constant, enabling soft parsing and query plan caching for repeated executions with different input values. Use <code>EXECUTE IMMEDIATE ... USING</code> or <code>DBMS_SQL</code> with bind variables for values, always.</p>
</div>
<div class="postgresql-bridge">
<p>PostgreSQL also benefits greatly from using parameterized queries or the <code>format()</code> function to avoid re-parsing; concatenating literals into the SQL string is inefficient there too. The principle of separating SQL text from parameter values is key in both RDBMS for performance and security.</p>
</div>


#### **(iv) Hardcore Combined Problem**

**Exercise 4.1: Order Processing, Stock Management, Logging, and Dynamic Reporting**

*   **Problem:** Design a complex PL/SQL package that simulates part of an order processing workflow. The package should include procedures and use various concepts learned: collections, records, bulk operations, dynamic SQL, cursors, functions, exception handling, and leverage relevant aspects of the dataset and previous modules.

*   **Package `orderProcessor` Requirements:**
    1.  **Collection Types:** Define necessary collection types within the package specification (e.g., for lists of product IDs, quantities, order item details). Use appropriate types (Associative Array, Nested Table, Varray) based on the data structure and required operations (e.g., sparse access, sequential access, fixed size, bulk DML input/output). Define a RECORD type for processing order items.
    2.  **Bulk Fetch:** Create a packaged function `getLowStockProductIds` that uses `BULK COLLECT` to fetch the `productId` of all products where `stockQuantity` is below a threshold (e.g., 100) into a collection and returns this collection.
    3.  **Bulk Update:** Create a packaged procedure `processOrderItems` that takes an `orderId` (NUMBER) as input.
        *   Inside `processOrderItems`, use a cursor to select `orderItemId`, `productId`, and `quantity` for all items in the given order.
        *   Fetch these items into collections using `BULK COLLECT`.
        *   Implement stock deduction: For each item, update the `products` table to reduce the `stockQuantity` by the item's quantity. Use a `FORALL` statement for this batch update. Include `SAVE EXCEPTIONS` and handle `ORA-24381` to report items that failed (e.g., stock went below zero, which could be a constraint violation if added, or you can simulate an error based on a condition). Log failures using `DBMS_OUTPUT`.
        *   Use the `RETURNING INTO BULK COLLECT` clause in the `FORALL` update to get the new `stockQuantity` for the updated products into another collection.
        *   Update the `orders` table to change the `status` to 'Processed' *only if* all stock updates for that order succeeded. If there were *any* bulk exceptions, set the status to 'Stock Issue' instead.
    4.  **Dynamic Logging:** Create a packaged procedure `logCustomerAction` that takes `customerId` (NUMBER), `actionType` (VARCHAR2), and `actionDetails` (VARCHAR2) as input. Dynamically insert a row into the `customerLog` table using `EXECUTE IMMEDIATE`. The `customerName` column in `customerLog` should be populated by dynamically selecting the `lastName` from the `employees` table based on `customerId` (assuming customerId maps to employeeId for simplicity in this dataset context). Handle `NO_DATA_FOUND` if the `customerId` is not found in `employees`. Use **bind variables** for all data inputs in the dynamic SQL string.
    5.  **Dynamic Reporting (Optional but Recommended):** Create a packaged function `getProductsAbovePrice` that demonstrates `DBMS_SQL` to `SYS_REFCURSOR` conversion. Takes `minPrice` (NUMBER). Builds `SELECT productId, productName, price FROM products WHERE price > :minPrice`. Uses `DBMS_SQL.OPEN_CURSOR`, `PARSE`, `BIND_VARIABLE`, `EXECUTE`. Then `DBMS_SQL.TO_REFCURSOR` to convert and return. (Uses: Dynamic SQL (DBMS_SQL), Bind Variables, Conversion, Functions).
    6.  **Error Handling:** Implement specific exception handlers within the package body for expected errors (like `NO_DATA_FOUND`, potentially others from constraints or logic checks you might add). Use `SQLCODE` and `SQLERRM`.

*   **Main Block:** Write an anonymous block to test the `orderProcessor` package.
    *   Call `processOrderItems` for order `2002`.
    *   Call `processOrderItems` for order `2003` (the notebook order, which should test bulk updates for a larger quantity).
    *   Call `logCustomerAction` for a sample customer/employee ID (e.g., 1001) logging an action like 'Processed order 2002'.
    *   Call `logCustomerAction` for a sample customer/employee ID that does *not* exist (e.g., 9999) logging an action like 'Failed login.'.
    *   Call `getLowStockProductIds` and print the resulting IDs.
    *   Call `getProductsAbovePrice` to get a report cursor for products above $200, then fetch and print a few rows from the cursor.
    *   Include a simple conceptual demonstration of a PTF query using the `COLUMNS` pseudo-operator.

*   **Solution 4.1:**

```sql
-- Ensure types and tables exist from dataset setup
-- CREATE OR REPLACE TYPE nestedIntegerList IS TABLE OF NUMBER;
-- /
-- CREATE OR REPLACE TYPE varrayStringList IS VARRAY(10) OF VARCHAR2(50);
-- /
-- CREATE OR REPLACE TYPE productInfoRec IS OBJECT (
--     pId NUMBER,
--     pName VARCHAR2(50),
--     pPrice NUMBER(10,2)
-- );
-- /
-- CREATE OR REPLACE TYPE productInfoList IS TABLE OF productInfoRec;
-- /
-- CREATE TABLE customerLog ...
-- CREATE TABLE products ...
-- CREATE SEQUENCE customerlog_seq ...

CREATE OR REPLACE PACKAGE orderProcessor IS

    -- Collection types used by the package (publicly visible in spec)
    type orderItemIdList IS TABLE OF orderItems.orderItemId%TYPE INDEX BY PLS_INTEGER;
    type productIdList IS TABLE OF products.productId%TYPE INDEX BY PLS_INTEGER;
    type quantityList IS TABLE OF orderItems.quantity%TYPE INDEX BY PLS_INTEGER;
    type stockQuantityList IS TABLE OF products.stockQuantity%TYPE INDEX BY PLS_INTEGER; -- For RETURNING INTO

    -- Record type for order items (publicly visible in spec)
    type orderItemRec IS RECORD (
        itemId orderItems.orderItemId%TYPE,
        prodId orderItems.productId%TYPE,
        qty orderItems.quantity%TYPE
    );
    type orderItemTab IS TABLE OF orderItemRec INDEX BY PLS_INTEGER;

    -- Packaged function to get low stock products using BULK COLLECT
    FUNCTION getLowStockProductIds (p_threshold IN NUMBER) RETURN productIdList;

    -- Packaged procedure to process order items (deduct stock, update order status)
    PROCEDURE processOrderItems (p_orderId IN orders.orderId%TYPE);

    -- Packaged procedure for dynamic logging
    PROCEDURE logCustomerAction (p_customerId IN employees.employeeId%TYPE, p_actionType IN VARCHAR2, p_actionDetails IN VARCHAR2);

    -- Packaged function to demonstrate DBMS_SQL to SYS_REFCURSOR conversion
    FUNCTION getProductsAbovePrice (p_minPrice IN products.price%TYPE) RETURN SYS_REFCURSOR;

END orderProcessor;
/

CREATE OR REPLACE PACKAGE BODY orderProcessor IS

    -- Packaged function to get low stock products using BULK COLLECT
    FUNCTION getLowStockProductIds (p_threshold IN NUMBER) RETURN productIdList IS
        v_productIds productIdList; -- Local collection variable
    BEGIN
        -- BULK COLLECT: Efficiently fetch multiple rows into a collection
        SELECT productId
        BULK COLLECT INTO v_productIds
        FROM products
        WHERE stockQuantity < p_threshold;

        RETURN v_productIds;
    END getLowStockProductIds;

    -- Packaged procedure to process order items (deduct stock, update order status)
    PROCEDURE processOrderItems (p_orderId IN orders.orderId%TYPE) IS
        -- Collections for BULK COLLECT fetch
        v_itemIds orderItemIdList;
        v_prodIds productIdList;
        v_quantities quantityList;

        -- Collections for RETURNING INTO BULK COLLECT (indexed by loop index 'i')
        v_newStockQuantities stockQuantityList;

        -- Cursor to fetch order items
        CURSOR c_orderItems IS
            SELECT orderItemId, productId, quantity
            FROM orderItems
            WHERE orderId = p_orderId;

        -- Exception handling variables for SAVE EXCEPTIONS
        forallErrors EXCEPTION;
        PRAGMA EXCEPTION_INIT(forallErrors, -24381); -- ORA-24381 is the bulk error exception
        errorIndex PLS_INTEGER;
        errorCode PLS_INTEGER;
        errorMessage VARCHAR2(200);
        errorsFound BOOLEAN := FALSE;

    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Processing Order: ' || p_orderId || ' ---');

        -- Fetch order items into collections using BULK COLLECT with a cursor
        -- This is efficient for getting many rows from SQL to PL/SQL
        OPEN c_orderItems;
        FETCH c_orderItems BULK COLLECT INTO v_itemIds, v_prodIds, v_quantities;
        CLOSE c_orderItems;

        DBMS_OUTPUT.PUT_LINE('Fetched ' || v_itemIds.COUNT || ' items for order ' || p_orderId);

        -- Deduct stock using FORALL
        IF v_itemIds.COUNT > 0 THEN
            BEGIN
                -- FORALL: Efficiently perform batch DML (stock deduction)
                -- Iterates over the collection v_itemIds indices (from FIRST to LAST)
                -- SAVE EXCEPTIONS: Tells Oracle not to stop on the first DML error, but collect all errors.
                -- RETURNING INTO BULK COLLECT: Gets data back from the DML statement for each affected row.
                FORALL i IN v_itemIds.FIRST .. v_itemIds.LAST SAVE EXCEPTIONS
                    UPDATE products
                    SET stockQuantity = stockQuantity - v_quantities(i)
                    WHERE productId = v_prodIds(i)
                    RETURNING stockQuantity BULK COLLECT INTO v_newStockQuantities(i); -- Use the loop index 'i' for the returning collection

                DBMS_OUTPUT.PUT_LINE('FORALL stock deduction completed (potentially with errors).');

            EXCEPTION
                WHEN forallErrors THEN
                    errorsFound := TRUE;
                    DBMS_OUTPUT.PUT_LINE('FORALL stock deduction completed with errors.');
                    DBMS_OUTPUT.PUT_LINE('Number of stock update errors: ' || SQL%BULK_EXCEPTIONS.COUNT);
                    -- Loop through the errors collected in the implicit cursor attribute SQL%BULK_EXCEPTIONS
                    -- SQL%BULK_EXCEPTIONS(i).ERROR_INDEX corresponds to the index in the FORALL loop range (v_itemIds.FIRST .. v_itemIds.LAST)
                    FOR i IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
                        errorIndex := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX; -- Index in the collection batch
                        errorCode := SQL%BULK_EXCEPTIONS(i).ERROR_CODE;
                        errorMessage := SQLERRM(-errorCode); -- Get the error message from the code

                        -- Use the errorIndex to reference the original data from the input collections
                        DBMS_OUTPUT.PUT_LINE('  Error ' || i || ': Index in batch=' || errorIndex ||
                                        ', Item ID=' || v_itemIds(errorIndex) ||
                                        ', Product ID=' || v_prodIds(errorIndex) ||
                                        ', Quantity=' || v_quantities(errorIndex) ||
                                        ', Error: ' || errorMessage);
                        -- In a real system, you'd log this to a dedicated error table
                    END LOOP;
                WHEN OTHERS THEN
                    errorsFound := TRUE;
                    DBMS_OUTPUT.PUT_LINE('An unexpected error occurred during FORALL: ' || SQLERRM);
                    -- Log this unhandled error
            END;

            -- Update order status based on whether errors occurred
            IF errorsFound THEN
                 UPDATE orders
                 SET status = 'Stock Issue' -- Indicate problem
                 WHERE orderId = p_orderId;
                 DBMS_OUTPUT.PUT_LINE('Order status set to ''Stock Issue'' due to errors.');
                 -- Depending on business rules, you might ROLLBACK the whole transaction here
                 -- If you want to save successful updates, don't rollback here, but commit later.
            ELSE
                 UPDATE orders
                 SET status = 'Processed'
                 WHERE orderId = p_orderId;
                 DBMS_OUTPUT.PUT_LINE('Order status set to ''Processed''.');
                 -- Display resulting stock levels for updated products
                 DBMS_OUTPUT.PUT_LINE('Resulting stock quantities after successful updates:');
                 FOR i IN v_itemIds.FIRST .. v_itemIds.LAST LOOP
                     -- Need to check if this specific item's update succeeded if SAVE EXCEPTIONS was used.
                     -- For simplicity here, re-query to show actual current stock level after the FORALL
                     DECLARE currentStock products.stockQuantity%TYPE;
                     BEGIN
                         SELECT stockQuantity INTO currentStock FROM products WHERE productId = v_prodIds(i);
                         DBMS_OUTPUT.PUT_LINE('  Product ID ' || v_prodIds(i) || ' has new stock: ' || currentStock);
                     EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
                 END LOOP;
                 -- Commit changes (stock updates and order status)
                 COMMIT;
            END IF;


        ELSE
            DBMS_OUTPUT.PUT_LINE('No items to process for order ' || p_orderId || '. Status unchanged.');
             -- No commit needed if no items
        END IF;

    END processOrderItems;

    -- Packaged procedure for dynamic logging
    PROCEDURE logCustomerAction (p_customerId IN employees.employeeId%TYPE, p_actionType IN VARCHAR2, p_actionDetails IN VARCHAR2) IS
        v_customerName employees.lastName%TYPE;
        v_sqlSelectName VARCHAR2(4000);
        v_sqlInsertLog VARCHAR2(4000);
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Logging Customer Action ---');

        -- Dynamically select customer name using customerId (employeeId)
        BEGIN
            -- Build dynamic select string (column and table names are hardcoded)
            v_sqlSelectName := 'SELECT lastName FROM employees WHERE employeeId = :empId'; -- Use bind variable for the ID
            -- Use EXECUTE IMMEDIATE for dynamic single-row select
            EXECUTE IMMEDIATE v_sqlSelectName INTO v_customerName USING p_customerId; -- Bind ID value

            DBMS_OUTPUT.PUT_LINE('Found customer name: ' || v_customerName || ' for ID ' || p_customerId);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_customerName := 'Unknown Customer';
                DBMS_OUTPUT.PUT_LINE('Customer ID ' || p_customerId || ' not found in employees. Logging with placeholder name.');
            WHEN OTHERS THEN
                 v_customerName := 'Error Fetching Name';
                 DBMS_OUTPUT.PUT_LINE('Error fetching customer name for ID ' || p_customerId || ': ' || SQLERRM);
                 -- In a real application, you might re-raise or log this fetch error separately
        END;

        -- Dynamic INSERT using EXECUTE IMMEDIATE with bind variables
        v_sqlInsertLog := 'INSERT INTO customerLog (logId, logTimestamp, customerName, actionDetails) VALUES (customerLog_seq.NEXTVAL, SYSTIMESTAMP, :custName, :details)';
        DBMS_OUTPUT.PUT_LINE('Executing dynamic INSERT for log...');
        -- Use bind variables for the values being inserted
        EXECUTE IMMEDIATE v_sqlInsertLog USING v_customerName, p_actionDetails; -- Bind customer name and details

        DBMS_OUTPUT.PUT_LINE('Action logged: ' || p_actionType || ' for customer ID ' || p_customerId);
        COMMIT; -- Commit the log entry
    EXCEPTION
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('An error occurred during logging: ' || SQLERRM);
             ROLLBACK; -- Rollback the log transaction if it failed
    END logCustomerAction;


    -- Packaged function to demonstrate DBMS_SQL to SYS_REFCURSOR conversion
    -- This is useful when you need the runtime flexibility of DBMS_SQL (e.g., dynamic column list)
    -- but want to return a standard REF CURSOR that the caller can FETCH from using NDS.
    FUNCTION getProductsAbovePrice (p_minPrice IN products.price%TYPE) RETURN SYS_REFCURSOR IS
        v_curId INTEGER; -- DBMS_SQL cursor ID
        v_sqlStmt VARCHAR2(200);
        v_execResult INTEGER;
        v_refCursor SYS_REFCURSOR; -- REF CURSOR to return

        -- Variables for DESCRIBE_COLUMNS (optional for conversion, but good practice if columns were dynamic)
        -- v_colCnt INTEGER;
        -- v_descTab DBMS_SQL.DESC_TAB; -- Or DESC_TAB2/3/4

    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Dynamic Report (DBMS_SQL to SYS_REFCURSOR) ---');
        DBMS_OUTPUT.PUT_LINE('Getting products above price: ' || p_minPrice);

        -- 1. Use DBMS_SQL to build and execute the query
        v_curId := DBMS_SQL.OPEN_CURSOR; -- Open a DBMS_SQL cursor

        -- Build the dynamic SQL string (table and column names are hardcoded, price is bind variable)
        v_sqlStmt := 'SELECT productId, productName, price FROM products WHERE price > :minPrice';

        DBMS_OUTPUT.PUT_LINE('Parsing query: ' || v_sqlStmt);
        DBMS_SQL.PARSE(v_curId, v_sqlStmt, DBMS_SQL.NATIVE); -- Parse the statement

        DBMS_OUTPUT.PUT_LINE('Binding variable :minPrice with value ' || p_minPrice);
        -- Bind the price variable using DBMS_SQL
        DBMS_SQL.BIND_VARIABLE(v_curId, ':minPrice', p_minPrice);

        DBMS_OUTPUT.PUT_LINE('Executing query...');
        v_execResult := DBMS_SQL.EXECUTE(v_curId); -- Execute the statement

        -- Important: The DBMS_SQL cursor MUST be OPENed, PARSEd, and EXECUTEd before conversion to SYS_REFCURSOR.

        -- 2. Convert the DBMS_SQL cursor to a SYS_REFCURSOR
        -- This is the key step to switch from the DBMS_SQL API to the NDS REF CURSOR model.
        -- After this, the original v_curId becomes invalid and cannot be used with DBMS_SQL functions anymore.
        v_refCursor := DBMS_SQL.TO_REFCURSOR(v_curId);

        DBMS_OUTPUT.PUT_LINE('DBMS_SQL cursor converted to SYS_REFCURSOR.');
        -- DBMS_SQL.CLOSE_CURSOR(v_curId); -- This is not needed and would error after successful conversion

        RETURN v_refCursor; -- Return the REF CURSOR to the caller

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred during dynamic report generation: ' || SQLERRM);
            -- Attempt to close the DBMS_SQL cursor if it was opened and not yet converted/closed
            -- IS_OPEN works on the DBMS_SQL cursor ID
            IF DBMS_SQL.IS_OPEN(v_curId) THEN
                DBMS_SQL.CLOSE_CURSOR(v_curId);
                 DBMS_OUTPUT.PUT_LINE('Cleaned up DBMS_SQL cursor due to error.');
            END IF;
            -- In a real application, you might want to RAISE the exception or return NULL/handle it differently
            RAISE; -- Re-raise the exception
    END getProductsAbovePrice;


END orderProcessor;
/

-- Test the package in an anonymous block
DECLARE
    lowStockIds orderProcessor.productIdList;
    reportCursor SYS_REFCURSOR;
    pId products.productId%TYPE;
    pName products.productName%TYPE;
    pPrice products.price%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Testing orderProcessor Package ---');

    -- Test processing order 2002 (Laptop, Keyboard, Mouse - should succeed)
    orderProcessor.processOrderItems(2002);

    -- Test processing order 2003 (Notebooks - should succeed with current stock=500)
    -- To test SAVE EXCEPTIONS, uncomment the UPDATE below to lower stock first
    -- UPDATE products SET stockQuantity = 4 WHERE productId = 3006; COMMIT;
    -- DBMS_OUTPUT.PUT_LINE('Notebook stock temporarily set to 4.');
    orderProcessor.processOrderItems(2003); -- If stock was lowered, this will have an error

    -- Test logging
    orderProcessor.logCustomerAction(1001, 'OrderProcessed', 'Order 2002 processed successfully.');
    orderProcessor.logCustomerAction(9999, 'LoginAttempt', 'Failed login.'); -- Test logging with unknown customer ID

    -- Test getLowStockProductIds
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Getting Low Stock Products ---');
    lowStockIds := orderProcessor.getLowStockProductIds(100);
    DBMS_OUTPUT.PUT_LINE('Products with stock below 100: ' || lowStockIds.COUNT || ' found.');
    IF lowStockIds.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Low stock Product IDs:');
        -- Loop through associative array
        FOR i IN lowStockIds.FIRST .. lowStockIds.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || lowStockIds(i));
        END LOOP;
    END IF;

    -- Test getProductsAbovePrice (DBMS_SQL to SYS_REFCURSOR)
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Fetching Dynamic Report (Products above $200) ---');
    reportCursor := orderProcessor.getProductsAbovePrice(200);

    -- Fetch and print results from the REF CURSOR (caller side)
    -- This uses standard NDS FETCH syntax after conversion
    LOOP
        FETCH reportCursor INTO pId, pName, pPrice;
        EXIT WHEN reportCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('  Product ID: ' || pId || ', Name: ' || pName || ', Price: ' || pPrice);
    END LOOP;
    CLOSE reportCursor; -- Close the REF CURSOR

     DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- End Testing orderProcessor Package ---');

    -- Simple PTF Example (Demonstrate COLUMNS pseudo-operator and pipelining concept)
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Simple PTF Demonstration (Conceptual) ---');
    DBMS_OUTPUT.PUT_LINE('Polymorphic Table Functions (PTFs) allow table-like functions in FROM clause.');
    DBMS_OUTPUT.PUT_LINE('Oracle 23ai adds the COLUMNS pseudo-operator for explicit column selection.');
    DBMS_OUTPUT.PUT_LINE('Example query using a conceptual to_doc PTF (assuming it exists from samples) and COLUMNS:');
    -- This query cannot be run without the actual to_doc PTF implementation
    -- SELECT deptno, ename, document FROM to_doc(scott.emp, COLUMNS(empno,job,mgr,hiredate,sal,comm)) WHERE deptno IN (10, 30) ORDER BY 1, 2;
    DBMS_OUTPUT.PUT_LINE('  SELECT dname, loc FROM skip_col_pkg.skip_col(departments, COLUMNS(departmentId));'); -- PTF from materials

END;
/

```

## Key Takeaways & Best Practices

Reflecting on these solutions, several key practices stand out for Oracle PL/SQL mastery:

*   **Collections:** Choose the right tool for the job! Associative Arrays for sparse, flexible index lookup; Varrays for fixed-size, dense, sequential data; Nested Tables for variable-size, potentially sparse data, especially when interacting with database tables. Understand their methods like `COUNT`, `EXISTS`, `EXTEND`, and `DELETE` – they're built-in muscle for managing your data structures! 💪
*   **Bulk Operations:** When moving more than a handful of rows between SQL and PL/SQL, or performing DML on many rows, **always** think bulk. `BULK COLLECT` for fetching data *into* collections, and `FORALL` for DML *from* collections. This is where the performance really flies!
*   **Bulk Exception Handling:** For `FORALL`, `SAVE EXCEPTIONS` is your safety net. It lets the show go on! 🎭 Handle the collected exceptions afterwards to understand what went wrong without stopping the whole batch.
*   **Dynamic SQL:** Use `EXECUTE IMMEDIATE` for simple, known-structure dynamic SQL and DDL. For complex scenarios where query structure (columns, binds) is unknown at compile time, `DBMS_SQL` is the workhorse, offering introspection and flexible binding/fetching.
*   **Bind Variables:** This is non-negotiable for dynamic DML/queries with runtime values. Always use bind variables (`:name` or `:position`) with `EXECUTE IMMEDIATE USING` or `DBMS_SQL` to prevent SQL injection and enable efficient statement caching (soft parsing). Don't concatenate values into the SQL string – that's a rookie mistake that can cost you security and performance! 💥
*   **DBMS_SQL to NDS Conversion:** The ability to bridge between `DBMS_SQL` and Native Dynamic SQL (`SYS_REFCURSOR`) using `DBMS_SQL.TO_REFCURSOR` is a powerful pattern when you need the runtime flexibility of `DBMS_SQL` but want to return a standard cursor handle to the caller.

To truly internalize these concepts, try modifying the solutions. Experiment with different collection types, add more error handling scenarios, or build new dynamic queries. Re-typing the code yourself can also help solidify the syntax and structure in your mind. And remember, the Oracle documentation (linked in the syllabus) is your ultimate companion!

## Conclusion & Next Steps

Congratulations on completing the exercises and reviewing the solutions for PL/SQL Mastery! You've tackled some of the most powerful and essential features for building high-performance, flexible applications in Oracle Database. Understanding Collections, Bulk Operations, and Dynamic SQL is a significant step in your transition from PostgreSQL.

Prepare to dive into **Study Chunk 9: PL/SQL Fusion: Built-ins and JavaScript Synergy**. You'll explore Oracle's extensive library of built-in packages (which are heavily used in real-world applications, including potentially Flexcube interaction) and discover how Oracle Database 23ai integrates JavaScript as a procedural language, opening up new possibilities for server-side development.

Keep up the great work! Your journey to Oracle Database 23ai mastery continues.

</div>

</body>