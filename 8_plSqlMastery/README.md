<head>
    <link rel="stylesheet" href="../styles/lecture.css">
</head>

<div class="toc-popup-container">
    <input type="checkbox" id="tocToggleChunk8" class="toc-toggle-checkbox">
    <label for="tocToggleChunk8" class="toc-toggle-label">
        <span class="toc-icon-open"></span>
        Contents
    </label>
    <div class="toc-content">
        <ul>
            <li><a href="#section1">Section 1: What Are They? (Meanings & Values in Oracle)</a>
                <ul>
                    <li><a href="#section1sub1">Collections & Records</a></li>
                    <li><a href="#section1sub2">Bulk Operations</a></li>
                    <li><a href="#section1sub3">Dynamic SQL</a></li>
                </ul>
            </li>
            <li><a href="#section2">Section 2: Relations: How They Play with Others (in Oracle)</a></li>
            <li><a href="#section3">Section 3: How to Use Them: Structures & Syntax (in Oracle)</a>
                <ul>
                    <li><a href="#section3sub1">Collections</a></li>
                    <li><a href="#section3sub2">Bulk Operations</a></li>
                    <li><a href="#section3sub3">Dynamic SQL</a></li>
                </ul>
            </li>
             <li><a href="#section4">Section 4: Why Use Them? (Advantages in Oracle)</a></li>
            <li><a href="#section5">Section 5: Watch Out! (Disadvantages & Pitfalls in Oracle)</a></li>
        </ul>
    </div>
</div>

<div class='container'>

# PL/SQL Mastery: Power Moves with Collections, Bulk Operations, and Dynamic SQL

Welcome, PostgreSQL maestros, to a delve into Oracle's procedural powerhouse! In this chunk, we master powerful PL/SQL constructs that handle complex data structures and supercharge performance. Think of this as adding precision tools and velocity engines to your coding craft. With care, we'll wield these powers, ensuring our applications **shine** and **align** with the Oracle design.

<div class="rhyme">
Collections gather, data in a heap,
Bulk operations make the engine leap.
Dynamic SQL adapts to needs unseen,
Oracle's power, sharp and keen.
</div>

## <a id="section1"></a>Section 1: What Are They? (Meanings & Values in Oracle)

Oracle PL/SQL gives us potent ways to handle groups of data and craft flexible SQL statements at runtime.

### <a id="section1sub1"></a>Collections & Records

In PL/SQL, we're not limited to simple scalar variables. We have composite data types:

*   **Collections**: Ordered groups of elements of the same data type. Think of them like arrays or lists you know from PostgreSQL, but with Oracle's own flavors and special methods<sup class="footnote-ref"><a href="#fn1_1" id="fnref1_1">[1]</a></sup>. Oracle offers three main types:
    *   `ASSOCIATIVE ARRAYS`: (Formerly known as PL/SQL Tables or Index-By Tables). Key-value pairs indexed by `PLS_INTEGER` or `VARCHAR2`. They are sparse (can have gaps in indices) and stored in memory for the session. They're perfect for lookups or passing data between PL/SQL and the SQL engine.
    *   `VARRAY`: (Variable-Size Array). Ordered collections with a declared maximum size. They are always dense (no gaps in indices) and indexed by `PLS_INTEGER` starting from 1. Varrays are stored as single objects in the database when used as a table column.
    *   `NESTED TABLES`: Ordered collections that can store an unspecified number of rows. They are dense initially but can become sparse if elements are deleted. Nested tables are stored in a separate 'store table' in the database when used as a table column, allowing for more complex querying and manipulation than Varrays.

*   **Records**: Composite variables storing data values of potentially different types, akin to structs or row types in PostgreSQL<sup class="footnote-ref"><a href="#fn1_2" id="fnref1_2">[2]</a></sup>. You can declare a record based on a table row structure (`%ROWTYPE`) or define your own custom structure (`RECORD` type). Records are great for holding related data, like a full or partial row fetched from a table.

<div class="postgresql-bridge">
    <p>PostgreSQL has powerful array types and supports row types directly. Oracle's approach separates collections into distinct types (`ASSOCIATIVE ARRAY`, `VARRAY`, `NESTED TABLE`) with differing storage behaviors and features. Oracle's `%ROWTYPE` is similar in concept to PostgreSQL's row type, allowing you to declare variables that match table structures.</p>
</div>

### <a id="section1sub2"></a>Bulk Operations

Moving data between the PL/SQL engine (where procedural logic lives) and the SQL engine (where data lives) involves context switches. For large datasets, doing this row by row becomes a performance bottleneck. Bulk operations minimize these context switches by processing collections of rows in a single round trip.

*   `BULK COLLECT`: Used in `SELECT INTO` or `FETCH` statements to retrieve an entire result set (or a batch) into a PL/SQL collection variable in a single operation<sup class="footnote-ref"><a href="#fn1_3" id="fnref1_3">[3]</a></sup>. This drastically reduces the number of trips from the SQL engine to the PL/SQL engine for data fetching.
*   `FORALL`: Used with `INSERT`, `UPDATE`, or `DELETE` statements to send an entire collection of data from PL/SQL to the SQL engine for batch processing<sup class="footnote-ref"><a href="#fn1_4" id="fnref1_4">[4]</sup></a>. This reduces the number of trips from the PL/SQL engine to the SQL engine for DML operations.

### <a id="section1sub3"></a>Dynamic SQL

Sometimes, the full text of a SQL statement isn't known until your program runs. Maybe the table name, the `WHERE` clause, or the columns being selected change based on user input or application logic. Dynamic SQL allows you to build and execute SQL statements stored as text strings at runtime.

*   `EXECUTE IMMEDIATE`: Oracle's primary way to execute dynamic SQL (or anonymous PL/SQL blocks) for DDL, DML, or single-row `SELECT INTO` statements. It's simpler than `DBMS_SQL` for basic cases and supports bind variables via the `USING` clause<sup class="footnote-ref"><a href="#fn1_5" id="fnref1_5">[5]</a></sup>.
*   `DBMS_SQL` package: A more powerful and flexible API for executing dynamic SQL. You use distinct procedures (`OPEN_CURSOR`, `PARSE`, `BIND_VARIABLE`, `EXECUTE`, `FETCH_ROWS`, `COLUMN_VALUE`, `CLOSE_CURSOR`) to manage the dynamic cursor explicitly<sup class="footnote-ref"><a href="#fn1_6" id="fnref1_6">[6]</a></sup>. It's necessary when the number or types of columns or bind variables are unknown at compile time, or when you need to perform complex dynamic operations like describing columns dynamically. It can also convert its cursors to `SYS_REFCURSOR`s.

<div class="postgresql-bridge">
    <p>PostgreSQL uses functions like <code>EXECUTE</code> with <code>format()</code> and parameterized statements ($1, $2, etc.) to handle dynamic SQL. Oracle's <code>EXECUTE IMMEDIATE</code> is a direct equivalent for many uses. The <code>DBMS_SQL</code> package provides a more granular API, similar in concept to low-level database interfaces or meta-commands for handling truly dynamic query structures.</p>
</div>

## <a id="section2"></a>Section 2: Relations: How They Play with Others (in Oracle)

These concepts don't exist in a vacuum; they interact powerfully with each other and the PL/SQL features we've already explored.

*   **Collections & Records** are fundamental data structures that you define and use *within* PL/SQL variables<sup class="footnote-ref"><a href="#fn1_7" id="fnref1_7">[7]</a></sup>. They store the results of queries, hold data for DML operations, and are passed as parameters to procedures and functions, often defined in package specifications<sup class="footnote-ref"><a href="#fn1_8" id="fnref1_8">[8]</a></sup>.
*   **Bulk Operations** (`BULK COLLECT`, `FORALL`) are specifically designed to work *with* PL/SQL collection variables. `BULK COLLECT` populates collections from SQL queries or fetches (using cursors), and `FORALL` sends the data stored in collections to the SQL engine for DML. This relationship is key to bridging the gap efficiently between the data layer and the procedural layer. Bulk exceptions are handled using the exception handling framework<sup class="footnote-ref"><a href="#fn1_9" id="fnref1_9">[9]</a></sup>.
*   **Dynamic SQL** allows you to run SQL statements whose text is determined at runtime. These dynamic statements can interact with collections and records.
    *   You can use `EXECUTE IMMEDIATE SELECT ... BULK COLLECT INTO ...` or `OPEN FOR ... BULK COLLECT INTO ...` to fetch data into collections dynamically.
    *   You can use `EXECUTE IMMEDIATE INSERT/UPDATE/DELETE ... VALUES/SET ...` with data from scalar variables, or build more complex dynamic DML with `DBMS_SQL` which can handle binding collection data (`BIND_ARRAY`) or even record data (`BIND_VARIABLE_PKG`) in advanced scenarios<sup class="footnote-ref"><a href="#fn1_10" id="fnref1_10">[10]</a></sup>.
    *   Dynamic SQL statements themselves can raise exceptions that you handle using the standard PL/SQL exception handling block. Bind variables, a crucial security feature for dynamic SQL, are simply PL/SQL variables whose values are passed to the dynamic statement's placeholders.
*   These techniques are typically implemented *within* PL/SQL blocks, procedures, functions, and packages, leveraging conditional control structures (IF/CASE) and loops (FOR/WHILE) to control the flow of data processing and handle different scenarios<sup class="footnote-ref"><a href="#fn1_11" id="fnref1_11">[11]</a></sup>. Cursors are fundamental to fetching data, and `BULK COLLECT` is often used with explicit cursors or cursor FOR loops for efficient retrieval. DML and TCL statements are the core operations performed by Bulk Operations and Dynamic SQL.

<div class="rhyme">
From blocks they arise, with functions they fly,
Through packages they structure, beneath the sky.
When data takes wing, in bulk they descend,
And statements can shift, right to the end.
</div>

## <a id="section3"></a>Section 3: How to Use Them: Structures & Syntax (in Oracle)

Let's get practical and see how these concepts are used in Oracle SQL and PL/SQL.

First, a small dataset to play with in our examples:

```sql
-- Minimalist Dataset for Lecture Examples
-- Only includes tables/columns needed for direct lecture examples

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureDepartments';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureEmployees';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureProducts';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureCustomerLog';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureNestedData';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureVarrayData';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureRecordData';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lectureDynamicTarget';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE lectureEmployeesSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE lectureProductsSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE lectureCustomerLogSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE lectureNestedDataSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE lectureVarrayDataSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE lectureRecordDataSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE lectureDynamicTargetSeq';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/

CREATE SEQUENCE lectureEmployeesSeq START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE lectureProductsSeq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE lectureCustomerLogSeq START WITH 2000 INCREMENT BY 1;
CREATE SEQUENCE lectureNestedDataSeq START WITH 3000 INCREMENT BY 1;
CREATE SEQUENCE lectureVarrayDataSeq START WITH 4000 INCREMENT BY 1;
CREATE SEQUENCE lectureRecordDataSeq START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE lectureDynamicTargetSeq START WITH 6000 INCREMENT BY 1;


CREATE TABLE lectureDepartments ( departmentId NUMBER PRIMARY KEY, departmentName VARCHAR2(30) );
INSERT INTO lectureDepartments VALUES (10, 'IT');
INSERT INTO lectureDepartments VALUES (20, 'Sales');
COMMIT;

CREATE TABLE lectureEmployees ( employeeId NUMBER PRIMARY KEY, lastName VARCHAR2(25), salary NUMBER(8,2), departmentId NUMBER REFERENCES lectureDepartments(departmentId));
INSERT INTO lectureEmployees VALUES (lectureEmployeesSeq.NEXTVAL, 'King', 24000, 10);
INSERT INTO lectureEmployees VALUES (lectureEmployeesSeq.NEXTVAL, 'Khoo', 3100, 20);
INSERT INTO lectureEmployees VALUES (lectureEmployeesSeq.NEXTVAL, 'Kochhar', 17000, 10);
INSERT INTO lectureEmployees VALUES (lectureEmployeesSeq.NEXTVAL, 'Raphaely', 11000, 20);
COMMIT;


CREATE TABLE lectureProducts ( productId NUMBER PRIMARY KEY, productName VARCHAR2(50), price NUMBER(10,2), stockQuantity NUMBER );
INSERT INTO lectureProducts VALUES (lectureProductsSeq.NEXTVAL, 'Laptop', 1200.00, 50);
INSERT INTO lectureProducts VALUES (lectureProductsSeq.NEXTVAL, 'Keyboard', 75.00, 200);
INSERT INTO lectureProducts VALUES (lectureProductsSeq.NEXTVAL, 'Monitor', 300.00, 80);
INSERT INTO lectureProducts VALUES (lectureProductsSeq.NEXTVAL, 'Mouse', 25.00, 300);
COMMIT;


CREATE TABLE lectureCustomerLog ( logId NUMBER PRIMARY KEY, logTimestamp TIMESTAMP, customerName VARCHAR2(100), actionDetails VARCHAR2(4000));
COMMIT; -- Empty for now

-- Define Types for Collection/Record Tables

-- Nested Table Type
CREATE OR REPLACE TYPE lectureIntegerList IS TABLE OF NUMBER;
/
CREATE TABLE lectureNestedData ( id NUMBER PRIMARY KEY, dataList lectureIntegerList ) NESTED TABLE dataList STORE AS lectureNestedDataNt;
INSERT INTO lectureNestedData VALUES (lectureNestedDataSeq.NEXTVAL, lectureIntegerList(10, 20, 30));
INSERT INTO lectureNestedData VALUES (lectureNestedDataSeq.NEXTVAL, lectureIntegerList(1, 5, 10, 15));
COMMIT;

-- Varray Type
CREATE OR REPLACE TYPE lectureStringArray IS VARRAY(5) OF VARCHAR2(50);
/
CREATE TABLE lectureVarrayData ( id NUMBER PRIMARY KEY, dataArray lectureStringArray );
INSERT INTO lectureVarrayData VALUES (lectureVarrayDataSeq.NEXTVAL, lectureStringArray('Apple', 'Banana', 'Cherry'));
INSERT INTO lectureVarrayData VALUES (lectureVarrayDataSeq.NEXTVAL, lectureStringArray('Red', 'Green', 'Blue', 'Yellow'));
COMMIT;

-- Record Type (Object Type)
CREATE OR REPLACE TYPE lectureProductRec IS OBJECT ( prodId NUMBER, prodName VARCHAR2(50), prodPrice NUMBER(10,2) );
/
CREATE TABLE lectureRecordData ( id NUMBER PRIMARY KEY, prodInfo lectureProductRec );
INSERT INTO lectureRecordData VALUES (lectureRecordDataSeq.NEXTVAL, lectureProductRec(1000, 'Laptop', 1200.00));
INSERT INTO lectureRecordData VALUES (lectureRecordDataSeq.NEXTVAL, lectureProductRec(1003, 'Mouse', 25.00));
COMMIT;

-- Dynamic Data Target table
CREATE TABLE lectureDynamicTarget ( id NUMBER PRIMARY KEY, stringValue VARCHAR2(100), numericValue NUMBER );
COMMIT;

```

### <a id="section3sub1"></a>Collections

Collections (Associative Arrays, Varrays, Nested Tables) and Records are declared and manipulated within PL/SQL blocks<sup class="footnote-ref"><a href="#fn1_12" id="fnref1_12">[12]</a></sup>.

#### Declaring Collections

```sql
DECLARE
  -- Associative Array (Index-by Table)
  TYPE empSalaryMap IS TABLE OF lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;
  mySalaries empSalaryMap;

  TYPE cityMap IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(10);
  branchCities cityMap;

  -- Varray (requires a type definition)
  TYPE colorArray IS VARRAY(3) OF VARCHAR2(10);
  primaryColors colorArray;

  -- Nested Table (requires a type definition)
  TYPE productPriceList IS TABLE OF lectureProducts.price%TYPE;
  currentPrices productPriceList;

  -- Nested Table of Records (requires object type definition)
  -- TYPE lectureProductRec IS OBJECT ( prodId NUMBER, prodName VARCHAR2(50), prodPrice NUMBER(10,2) ); -- Defined above
  TYPE lectureProductTab IS TABLE OF lectureProductRec;
  productDetails lectureProductTab;

BEGIN
  -- Collections are declared, ready for population.
  NULL; -- Placeholder
END;
/
```

#### Initializing Collections

Collections are typically initialized using a constructor (for Varrays and Nested Tables) or by assigning elements (for Associative Arrays). An uninitialized collection variable is `NULL`.

```sql
DECLARE
  TYPE colorArray IS VARRAY(3) OF VARCHAR2(10);
  -- Initialize with constructor (size 3, max 3)
  primaryColors colorArray := colorArray('Red', 'Green', 'Blue');

  TYPE productPriceList IS TABLE OF lectureProducts.price%TYPE;
  -- Initialize with constructor (size 2)
  currentPrices productPriceList := productPriceList(100.00, 250.00);

   TYPE lectureProductTab IS TABLE OF lectureProductRec;
  -- Initialize nested table of objects
  productDetails lectureProductTab := lectureProductTab( lectureProductRec(1, 'Alpha', 100), lectureProductRec(2, 'Beta', 200) );

  -- Associative arrays are populated by assignment, no constructor needed
  TYPE empSalaryMap IS TABLE OF lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;
  mySalaries empSalaryMap;
BEGIN
  -- Populate associative array
  mySalaries(100) := 24000;
  mySalaries(102) := 17000;

  DBMS_OUTPUT.PUT_LINE('Varray Count: ' || primaryColors.COUNT);
  DBMS_OUTPUT.PUT_LINE('Nested Table Count: ' || currentPrices.COUNT);
  DBMS_OUTPUT.PUT_LINE('Assoc Array Count: ' || mySalaries.COUNT);
  DBMS_OUTPUT.PUT_LINE('Nested Table of Objects Count: ' || productDetails.COUNT);
END;
/
```

#### Accessing Collection Elements

Elements are accessed using parentheses `()` with the index. Indices for Varrays and Nested Tables start at 1. Associative Arrays use the index specified during population.

```sql
DECLARE
  TYPE colorArray IS VARRAY(3) OF VARCHAR2(10);
  primaryColors colorArray := colorArray('Red', 'Green', 'Blue');

  TYPE productPriceList IS TABLE OF lectureProducts.price%TYPE;
  currentPrices productPriceList := productPriceList(100.00, 250.00);

  TYPE empSalaryMap IS TABLE OF lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;
  mySalaries empSalaryMap;

BEGIN
  mySalaries(100) := 24000;
  mySalaries(102) := 17000;

  DBMS_OUTPUT.PUT_LINE('Second color: ' || primaryColors(2)); -- Varray (1-based index)
  DBMS_OUTPUT.PUT_LINE('First price: ' || currentPrices(1)); -- Nested Table (1-based index)
  DBMS_OUTPUT.PUT_LINE('Salary for emp 100: ' || mySalaries(100)); -- Associative Array (user-defined index)

  -- Accessing fields in a collection of records/objects
  DBMS_OUTPUT.PUT_LINE('Prod ID from nested object: ' || lectureProductRec(1000, 'Laptop', 1200.00).prodId); -- Using object constructor

END;
/
```

#### Collection Methods

Oracle provides built-in methods for collections, distinct from the SQL functions you might use on PostgreSQL arrays (e.g., `array_length`).

*   `COUNT`: Number of elements currently in the collection.
*   `LIMIT`: Maximum number of elements (only for Varrays).
*   `FIRST`, `LAST`: First/last index in the collection.
*   `NEXT(n)`, `PRIOR(n)`: Index after/before index `n`. Useful for sparse collections (Assoc Arrays, Nested Tables after delete).
*   `EXISTS(n)`: Checks if an element exists at index `n` (does not raise error on null collection).
*   `EXTEND`, `EXTEND(n)`, `EXTEND(n, i)`: Add elements to the end (Nested Tables, Varrays).
*   `TRIM`, `TRIM(n)`: Remove elements from the end (Nested Tables, Varrays).
*   `DELETE`, `DELETE(n)`, `DELETE(m, n)`: Remove elements (all collection types).

```sql
DECLARE
  TYPE productPriceList IS TABLE OF lectureProducts.price%TYPE;
  currentPrices productPriceList := productPriceList(100.00, 250.00, 300.00, 400.00);
  idx PLS_INTEGER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Initial Count: ' || currentPrices.COUNT);
  currentPrices.DELETE(2); -- Delete element at index 2
  DBMS_OUTPUT.PUT_LINE('Count after DELETE(2): ' || currentPrices.COUNT); -- Count changes
  DBMS_OUTPUT.PUT_LINE('First index: ' || currentPrices.FIRST); -- Still 1
  DBMS_OUTPUT.PUT_LINE('Last index: ' || currentPrices.LAST); -- Still 4
  DBMS_OUTPUT.PUT_LINE('Element at index 3 exists? ' || CASE WHEN currentPrices.EXISTS(3) THEN 'TRUE' ELSE 'FALSE' END); -- TRUE
  DBMS_OUTPUT.PUT_LINE('Element at index 2 exists? ' || CASE WHEN currentPrices.EXISTS(2) THEN 'TRUE' ELSE 'FALSE' END); -- FALSE

  currentPrices.EXTEND; -- Add one null element
  DBMS_OUTPUT.PUT_LINE('Count after EXTEND: ' || currentPrices.COUNT); -- Count increases
  DBMS_OUTPUT.PUT_LINE('Last index after EXTEND: ' || currentPrices.LAST); -- Index increases

  currentPrices.TRIM(1); -- Remove last element
  DBMS_OUTPUT.PUT_LINE('Count after TRIM(1): ' || currentPrices.COUNT); -- Count decreases
  DBMS_OUTPUT.PUT_LINE('Last index after TRIM(1): ' || currentPrices.LAST); -- Index decreases

END;
/
```

#### Declaring Records

Records can be declared based on table/view rows (`%ROWTYPE`) or custom structures (`RECORD`).

```sql
DECLARE
  -- Record based on a table row
  empRow lectureEmployees%ROWTYPE;

  -- Record based on a custom structure
  TYPE addressRec IS RECORD (
    street VARCHAR2(100),
    city VARCHAR2(50),
    zipCode VARCHAR2(10)
  );
  empAddress addressRec;

  -- Record containing another record (nested record)
  TYPE empContactRec IS RECORD (
    employeeInfo lectureEmployees%ROWTYPE, -- Nested %ROWTYPE record
    addressInfo addressRec -- Nested custom record
  );
  fullEmpContact empContactRec;

   -- Record using object type (defined above)
  productInfo lectureProductRec;

BEGIN
  -- Records are declared. Fields are null by default unless initialized in type definition.
  NULL; -- Placeholder
END;
/
```

#### Accessing Record Fields

Fields are accessed using dot notation (`.`).

```sql
DECLARE
  empRow lectureEmployees%ROWTYPE;

  TYPE addressRec IS RECORD (
    street VARCHAR2(100),
    city VARCHAR2(50)
  );
  empAddress addressRec;

  TYPE empContactRec IS RECORD (
    employeeInfo lectureEmployees%ROWTYPE,
    addressInfo addressRec
  );
  fullEmpContact empContactRec;

  productInfo lectureProductRec; -- Using object type
BEGIN
  -- Populate fields
  empRow.employeeId := 101;
  empRow.lastName := 'Doe'; -- Note: %ROWTYPE gets column names

  empAddress.street := '123 Main St';
  empAddress.city := 'Anytown';

  fullEmpContact.employeeInfo.employeeId := 102; -- Access nested field
  fullEmpContact.addressInfo.city := 'Otherville'; -- Access nested field

  productInfo := lectureProductRec(1000, 'Laptop', 1200.00); -- Initialize object type record
  productInfo.prodPrice := 1100.00; -- Access field of object type record

  DBMS_OUTPUT.PUT_LINE('Employee Last Name: ' || empRow.lastName);
  DBMS_OUTPUT.PUT_LINE('Employee Address City: ' || fullEmpContact.addressInfo.city);
  DBMS_OUTPUT.PUT_LINE('Product Info Price: ' || productInfo.prodPrice);
END;
/
```

### <a id="section3sub2"></a>Bulk Operations

Bulk operations significantly improve performance for batch processing between PL/SQL and SQL.

#### BULK COLLECT

Used in `SELECT INTO` or `FETCH`. Fetches results into one or more collection variables<sup class="footnote-ref"><a href="#fn1_13" id="fnref1_13">[13]</a></sup>.

```sql
DECLARE
  -- Collections to hold results
  TYPE empIdList IS TABLE OF lectureEmployees.employeeId%TYPE INDEX BY PLS_INTEGER;
  TYPE empNameList IS TABLE OF lectureEmployees.lastName%TYPE INDEX BY PLS_INTEGER;
  TYPE empSalaryList IS TABLE OF lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;

  allEmpIds empIdList;
  allEmpNames empNameList;
  allEmpSalaries empSalaryList;

  -- Collection of records to hold results
  TYPE empRecList IS TABLE OF lectureEmployees%ROWTYPE INDEX BY PLS_INTEGER; -- Or Nested Table
  allEmpRecords empRecList;

  -- Cursor for FETCH BULK COLLECT
  CURSOR c_highSalaryEmps IS
    SELECT employeeId, lastName, salary
    FROM lectureEmployees
    WHERE salary > 10000;

  TYPE highSalaryEmpRecList IS TABLE OF c_highSalaryEmps%ROWTYPE INDEX BY PLS_INTEGER;
  highSalaryEmpRecords highSalaryEmpRecList;
  fetchLimit CONSTANT PLS_INTEGER := 2; -- Fetch in batches of 2

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- BULK COLLECT ---');

  -- BULK COLLECT with SELECT INTO (fetches all rows at once)
  SELECT employeeId, lastName, salary
  BULK COLLECT INTO allEmpIds, allEmpNames, allEmpSalaries
  FROM lectureEmployees;

  DBMS_OUTPUT.PUT_LINE('Fetched ' || allEmpIds.COUNT || ' employees using SELECT BULK COLLECT.');
  IF allEmpIds.COUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('First employee: ID=' || allEmpIds(allEmpIds.FIRST) || ', Name=' || allEmpNames(allEmpNames.FIRST));
  END IF;

  -- BULK COLLECT with SELECT INTO into collection of records
   SELECT * -- Select all columns to match %ROWTYPE record structure
  BULK COLLECT INTO allEmpRecords
  FROM lectureEmployees;

  DBMS_OUTPUT.PUT_LINE('Fetched ' || allEmpRecords.COUNT || ' employees into collection of records.');
  IF allEmpRecords.COUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('First employee record (ID, Name): ' || allEmpRecords(allEmpRecords.FIRST).employeeId || ', ' || allEmpRecords(allEmpRecords.FIRST).lastName);
  END IF;


  -- BULK COLLECT with FETCH (fetches in batches)
  DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- FETCH BULK COLLECT ---');
  OPEN c_highSalaryEmps;
  LOOP
    FETCH c_highSalaryEmps BULK COLLECT INTO highSalaryEmpRecords LIMIT fetchLimit;
    EXIT WHEN highSalaryEmpRecords.COUNT = 0;

    DBMS_OUTPUT.PUT_LINE('Fetched batch of ' || highSalaryEmpRecords.COUNT || ' high salary employees.');
    -- Process the batch (e.g., print some details)
    FOR i IN highSalaryEmpRecords.FIRST .. highSalaryEmpRecords.LAST LOOP
      DBMS_OUTPUT.PUT_LINE('  ID: ' || highSalaryEmpRecords(i).employeeId || ', Salary: ' || highSalaryEmpRecords(i).salary);
    END LOOP;
  END LOOP;
  CLOSE c_highSalaryEmps;

END;
/
```

#### FORALL

Used for batch `INSERT`, `UPDATE`, `DELETE`, or `MERGE` statements using data from a collection<sup class="footnote-ref"><a href="#fn1_14" id="fnref1_14">[14]</a></sup>.

```sql
DECLARE
  -- Collection to hold product IDs and new stock quantities
  TYPE productIdList IS TABLE OF lectureProducts.productId%TYPE INDEX BY PLS_INTEGER;
  TYPE newStockList IS TABLE OF lectureProducts.stockQuantity%TYPE INDEX BY PLS_INTEGER;

  productsToUpdate productIdList;
  newStockQuantities newStockList;

  TYPE deletedLogIdsList IS TABLE OF lectureCustomerLog.logId%TYPE INDEX BY PLS_INTEGER;
  logIdsToDelete deletedLogIdsList;

  -- Collection for RETURNING INTO BULK COLLECT
  TYPE updatedStockList IS TABLE OF lectureProducts.stockQuantity%TYPE INDEX BY PLS_INTEGER;
  resultingStock updatedStockList;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- FORALL ---');

  -- Populate collections for update
  productsToUpdate(1) := 1000; -- Laptop
  productsToUpdate(2) := 1002; -- Monitor

  newStockQuantities(1) := 60; -- Increase stock
  newStockQuantities(2) := 90;

   -- Get current stock quantities for comparison
  DECLARE
      currentStock NUMBER;
  BEGIN
      SELECT stockQuantity INTO currentStock FROM lectureProducts WHERE productId = 1000;
      DBMS_OUTPUT.PUT_LINE('Current stock for Product 1000 (Laptop): ' || currentStock);
       SELECT stockQuantity INTO currentStock FROM lectureProducts WHERE productId = 1002;
      DBMS_OUTPUT.PUT_LINE('Current stock for Product 1002 (Monitor): ' || currentStock);
  END;


  -- FORALL UPDATE
  -- The index 'i' iterates through the collection, and collection_name(i) provides the value
  -- RETURNING INTO BULK COLLECT gets results from the DML back into another collection
  FORALL i IN productsToUpdate.FIRST .. productsToUpdate.LAST
    UPDATE lectureProducts
    SET stockQuantity = newStockQuantities(i)
    WHERE productId = productsToUpdate(i)
    RETURNING stockQuantity BULK COLLECT INTO  resultingStock(i); -- Use the same index 'i'

  DBMS_OUTPUT.PUT_LINE('Updated ' || SQL%ROWCOUNT || ' products using FORALL.'); -- SQL%ROWCOUNT for total rows

  -- Display resulting stock from RETURNING INTO
  DBMS_OUTPUT.PUT_LINE('Resulting stock quantities from RETURNING INTO:');
   FOR i IN  resultingStock.FIRST ..  resultingStock.LAST LOOP
       DBMS_OUTPUT.PUT_LINE('  Index ' || i || ': ' ||  resultingStock(i));
   END LOOP;

  -- Populate collection for delete (get some log IDs)
  INSERT INTO lectureCustomerLog VALUES (lectureCustomerLogSeq.NEXTVAL, SYSTIMESTAMP, 'TestCustomer', 'Action 1');
  INSERT INTO lectureCustomerLog VALUES (lectureCustomerLogSeq.NEXTVAL, SYSTIMESTAMP, 'TestCustomer', 'Action 2');
  COMMIT;

  SELECT logId BULK COLLECT INTO logIdsToDelete FROM lectureCustomerLog WHERE customerName = 'TestCustomer';
  DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Deleting ' || logIdsToDelete.COUNT || ' log entries using FORALL DELETE.');

  -- FORALL DELETE
  FORALL i IN logIdsToDelete.FIRST .. logIdsToDelete.LAST
    DELETE FROM lectureCustomerLog
    WHERE logId = logIdsToDelete(i);

  DBMS_OUTPUT.PUT_LINE('Deleted ' || SQL%ROWCOUNT || ' log entries using FORALL.');

  COMMIT;

END;
/
```

### <a id="section3sub3"></a>Dynamic SQL

Dynamic SQL is used when the SQL statement isn't fully defined until runtime.

#### EXECUTE IMMEDIATE

Simplest way for DDL, DML, and single-row `SELECT INTO`<sup class="footnote-ref"><a href="#fn1_15" id="fnref1_15">[15]</a></sup>. Supports bind variables via `USING`.

```sql
DECLARE
  v_tableName VARCHAR2(30);
  v_sqlStmt VARCHAR2(200);
  v_logDetail VARCHAR2(50);
  v_logId lectureCustomerLog.logId%TYPE;

  v_empId lectureEmployees.employeeId%TYPE := 101; -- Assuming 101 exists
  v_newSalary lectureEmployees.salary%TYPE := 4000;
  v_currentSalary lectureEmployees.salary%TYPE;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- EXECUTE IMMEDIATE ---');

  -- Dynamic DDL
  v_tableName := 'lectureDynamicTarget';
  v_sqlStmt := 'ALTER TABLE ' || v_tableName || ' ADD (tempColumn VARCHAR2(20))';
  DBMS_OUTPUT.PUT_LINE('Executing DDL: ' || v_sqlStmt);
  EXECUTE IMMEDIATE v_sqlStmt;
  DBMS_OUTPUT.PUT_LINE('Added tempColumn to ' || v_tableName || '.');

  -- Dynamic DML (INSERT) with bind variables
  v_logDetail := 'Logged in.';
  v_sqlStmt := 'INSERT INTO lectureCustomerLog (logId, logTimestamp, customerName, actionDetails) VALUES (lectureCustomerLogSeq.NEXTVAL, SYSTIMESTAMP, :1, :2)';
  DBMS_OUTPUT.PUT_LINE('Executing INSERT: ' || v_sqlStmt || ' using binds');
  EXECUTE IMMEDIATE v_sqlStmt USING 'John Doe', v_logDetail; -- Positional binds

  -- Dynamic DML (UPDATE) with named bind variables
  v_sqlStmt := 'UPDATE lectureEmployees SET salary = :newSalary WHERE employeeId = :empId';
   DBMS_OUTPUT.PUT_LINE('Executing UPDATE: ' || v_sqlStmt || ' using named binds');
  EXECUTE IMMEDIATE v_sqlStmt USING :newSalary v_newSalary, :empId v_empId; -- Named binds

  -- Dynamic SELECT INTO (single row) with bind variable
  v_sqlStmt := 'SELECT salary FROM lectureEmployees WHERE employeeId = :empId';
   DBMS_OUTPUT.PUT_LINE('Executing SELECT INTO: ' || v_sqlStmt || ' using bind');
  EXECUTE IMMEDIATE v_sqlStmt INTO v_currentSalary USING v_empId; -- INTO clause for SELECT results
  DBMS_OUTPUT.PUT_LINE('Updated salary for emp ' || v_empId || ' is ' || v_currentSalary);


  -- Clean up the added column
  v_sqlStmt := 'ALTER TABLE ' || v_tableName || ' DROP COLUMN tempColumn';
  DBMS_OUTPUT.PUT_LINE('Executing DDL: ' || v_sqlStmt);
  EXECUTE IMMEDIATE v_sqlStmt;
  DBMS_OUTPUT.PUT_LINE('Dropped tempColumn.');

  COMMIT;

END;
/
```

#### DBMS_SQL Package

For more complex dynamic SQL, especially when the structure (columns, binds) is unknown at compile time, or for converting to/from `SYS_REFCURSOR`.

```sql
DECLARE
  v_curId INTEGER; -- DBMS_SQL cursor ID
  v_sqlStmt VARCHAR2(200);
  v_execResult INTEGER;
  v_refCursor SYS_REFCURSOR; -- Target REF CURSOR

  -- Variables for fetching results from DBMS_SQL cursor
  v_productId lectureProducts.productId%TYPE;
  v_productName lectureProducts.productName%TYPE;
  v_productPrice lectureProducts.price%TYPE;

  v_minPrice CONSTANT lectureProducts.price%TYPE := 100.00;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- DBMS_SQL Package ---');
  DBMS_OUTPUT.PUT_LINE('Querying products above price: ' || v_minPrice);

  -- 1. Open a DBMS_SQL cursor
  v_curId := DBMS_SQL.OPEN_CURSOR;
  DBMS_OUTPUT.PUT_LINE('Opened DBMS_SQL cursor: ' || v_curId);

  -- 2. Define the dynamic SQL statement
  v_sqlStmt := 'SELECT productId, productName, price FROM lectureProducts WHERE price > :minPrice';

  -- 3. Parse the statement
  DBMS_OUTPUT.PUT_LINE('Parsing statement: ' || v_sqlStmt);
  DBMS_SQL.PARSE(v_curId, v_sqlStmt, DBMS_SQL.NATIVE); -- DBMS_SQL.NATIVE is standard behavior

  -- 4. Bind variables (if any)
  DBMS_OUTPUT.PUT_LINE('Binding variable :minPrice');
  DBMS_SQL.BIND_VARIABLE(v_curId, ':minPrice', v_minPrice); -- Bind price to the placeholder

  -- 5. Define output columns (required for SELECT)
  -- This step would be dynamic if column names/types were unknown
  -- DBMS_OUTPUT.PUT_LINE('Defining columns...');
  -- DBMS_SQL.DEFINE_COLUMN(v_curId, 1, v_productId); -- Define column 1
  -- DBMS_SQL.DEFINE_COLUMN(v_curId, 2, v_productName, 50); -- Define column 2 (need size for VARCHAR2)
  -- DBMS_SQL.DEFINE_COLUMN(v_curId, 3, v_productPrice); -- Define column 3

  -- 6. Execute the statement
  DBMS_OUTPUT.PUT_LINE('Executing statement...');
  v_execResult := DBMS_SQL.EXECUTE(v_curId); -- For SELECT, this prepares the result set

  -- 7. (Optional) Convert DBMS_SQL cursor to SYS_REFCURSOR
  -- This is useful for passing a dynamic query result back from a function
  -- After conversion, the DBMS_SQL cursor ID is invalid
  DBMS_OUTPUT.PUT_LINE('Converting DBMS_SQL cursor to SYS_REFCURSOR...');
  v_refCursor := DBMS_SQL.TO_REFCURSOR(v_curId);
  DBMS_OUTPUT.PUT_LINE('Conversion complete.');
  -- DBMS_SQL.CLOSE_CURSOR(v_curId); -- No need, already converted/invalidated

  -- 8. Fetch and retrieve results from the SYS_REFCURSOR (back in Native Dynamic SQL context)
  -- Note: If not converting, you would use DBMS_SQL.FETCH_ROWS and DBMS_SQL.COLUMN_VALUE
  DBMS_OUTPUT.PUT_LINE('Fetching from SYS_REFCURSOR:');
  LOOP
      FETCH v_refCursor INTO v_productId, v_productName, v_productPrice;
      EXIT WHEN v_refCursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('  Prod ID: ' || v_productId || ', Name: ' || v_productName || ', Price: ' || v_productPrice);
  END LOOP;

  -- 9. Close the SYS_REFCURSOR
  CLOSE v_refCursor;

  DBMS_OUTPUT.PUT_LINE('Closed SYS_REFCURSOR.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    -- Clean up the DBMS_SQL cursor if still open
    IF DBMS_SQL.IS_OPEN(v_curId) THEN -- Use IS_OPEN before attempting close
      DBMS_SQL.CLOSE_CURSOR(v_curId);
      DBMS_OUTPUT.PUT_LINE('Cleaned up DBMS_SQL cursor due to error.');
    END IF;
    -- Clean up the REF CURSOR if still open
    IF v_refCursor%ISOPEN THEN
        CLOSE v_refCursor;
        DBMS_OUTPUT.PUT_LINE('Cleaned up SYS_REFCURSOR due to error.');
    END IF;
    RAISE; -- Re-raise the exception
END;
/
```

### <a id="section3sub4"></a>Polymorphic Table Functions (PTFs) - A 23ai Feature

A new feature in Oracle 23ai is Polymorphic Table Functions (PTFs)<sup class="footnote-ref"><a href="#fn1_16" id="fnref1_16">[16]</a></sup>. These are table functions whose column structure can adapt based on the input table structure. They are invoked in the `FROM` clause of a query and can use a `COLUMNS` pseudo-operator to specify columns dynamically.

```sql
-- Conceptual Example (PTF Definition is complex, usually in a package body)
-- Assuming a package 'lecturePtfPkg' and a PTF 'passthrough' exists,
-- that takes a table and COLUMNS input and returns the specified columns.

-- Example Definition Structure (Simplified)
CREATE OR REPLACE PACKAGE lecturePtfPkg AS
  FUNCTION passthrough(inputTable TABLE, cols COLUMNS) RETURN TABLE PIPELINED ROW POLYMORPHIC USING lecturePtfPkg;
END;
/
CREATE OR REPLACE PACKAGE BODY lecturePtfPkg AS
  -- DESCRIBE function required to determine output columns based on input cols
  FUNCTION describe(tab IN OUT DBMS_TF.TABLE_T, cols IN DBMS_TF.COLUMNS_T) RETURN DBMS_TF.DESCRIBE_T IS ... END;
  -- FETCH_ROWS function required to fetch data based on described columns
  PROCEDURE fetch_rows IS ... END;
  -- The PTF function itself just declares and points to the package implementation
  FUNCTION passthrough(inputTable TABLE, cols COLUMNS) RETURN TABLE PIPELINED ROW POLYMORPHIC USING lecturePtfPkg IS BEGIN RETURN; END;
END;
/


-- Example Usage in a Query (Assuming 'passthrough' PTF exists)
-- This query uses the conceptual PTF to select just employeeId and lastName
-- from lectureEmployees, effectively acting like a dynamic SELECT.
-- The COLUMNS pseudo-operator dynamically specifies which columns the PTF should handle.
-- This isn't standard SQL but a special syntax for PTF arguments.
SELECT employeeId, lastName
FROM lecturePtfPkg.passthrough(lectureEmployees, COLUMNS(employeeId, lastName))
WHERE employeeId = 100; -- You can filter results *after* the PTF

-- Another example: pass different columns
-- SELECT productId, productName, price
-- FROM lecturePtfPkg.passthrough(lectureProducts, COLUMNS(productId, productName, price))
-- WHERE price > 100;

```
<div class="postgresql-bridge">
    <p>PTFs are an Oracle-specific advanced feature, offering powerful ways to create dynamic, data-transforming functions callable directly in the <code>FROM</code> clause. PostgreSQL doesn't have a direct analogue to this polymorphic behavior and the <code>COLUMNS</code> operator; similar logic might involve dynamic SQL generation or complex set-returning functions.</p>
</div>


## <a id="section4"></a>Section 4: Why Use Them? (Advantages in Oracle)

Leveraging collections, bulk operations, and dynamic SQL brings significant benefits, particularly in Oracle enterprise environments like Flexcube:

*   **Performance Gains (Bulk Operations):** This is arguably the biggest win. By reducing context switches between PL/SQL and SQL, `BULK COLLECT` and `FORALL` drastically improve the performance of batch processing, which is common in financial applications or data migrations<sup class="footnote-ref"><a href="#fn1_17" id="fnref1_17">[17]</a></sup>. Data moves faster, and resource consumption decreases, a valuable trait for scalable applications<sup class="footnote-ref"><a href="#fn1_18" id="fnref1_18">[18]</a></sup>.
*   **Flexibility (Dynamic SQL):** Allows you to write generic procedures that can operate on different tables or filter data based on runtime conditions<sup class="footnote-ref"><a href="#fn1_19" id="fnref1_19">[19]</a></sup>. This is invaluable for building configurable applications or handling metadata-driven tasks. `EXECUTE IMMEDIATE` is simple for DDL, while `DBMS_SQL` handles complex scenarios gracefully.
*   **Code Readability and Organization (Collections & Records):** Using collections and records allows you to structure related data logically within your PL/SQL code. Instead of managing many individual scalar variables, you can work with composite variables, improving code clarity and maintenance. Records based on `%ROWTYPE` automatically adapt to table structure changes (mostly).
*   **Efficiency with Dynamic SQL Caching:** When you use bind variables with `EXECUTE IMMEDIATE` or `DBMS_SQL`, Oracle can cache the parsed dynamic statement. Repeated executions with different bind values only require a faster soft parse instead of a full hard parse, improving performance<sup class="footnote-ref"><a href="#fn1_20" id="fnref1_20">[20]</a></sup>.

<div class="rhyme">
Efficiency speeds, where data flows free,
Flexibility bends, for all eyes to see.
Structure holds tight, keeps code aligned,
Performance will surely be defined.
</div>

## <a id="section5"></a>Section 5: Watch Out! (Disadvantages & Pitfalls in Oracle)

While powerful, these features require careful handling to avoid common mistakes and vulnerabilities:

*   **Collection Nulls and Non-Existence:** An uninitialized collection variable is `NULL`, not merely empty. Attempting to use methods like `COUNT`, `FIRST`, `LAST` (except `EXISTS`) on a null collection raises `COLLECTION_IS_NULL`<sup class="footnote-ref"><a href="#fn1_21" id="fnref1_21">[21]</a></sup>. Deleting elements from Nested Tables or Associative Arrays creates *sparse* collections; accessing a non-existent index raises `NO_DATA_FOUND` or `SUBSCRIPT_DOES_NOT_EXIST`<sup class="footnote-ref"><a href="#fn1_22" id="fnref1_22">[22]</a></sup>. Always check `IS NULL` before using methods and `EXISTS` before accessing elements if sparsity or nullability is possible.
*   **Collection Type Incompatibility:** Even if two collection types (especially Nested Tables or Varrays) have the exact same element type and structure, variables of different defined types are *not* assignable to each other. This is a strict type check<sup class="footnote-ref"><a href="#fn1_23" id="fnref1_23">[23]</a></sup>.
*   **Varray Fixed Size:** A Varray's maximum size is set when the type is defined and cannot be changed. Attempting to `EXTEND` beyond this limit raises `SUBSCRIPT_BEYOND_LIMIT`<sup class="footnote-ref"><a href="#fn1_24" id="fnref1_24">[24]</a></sup>.
*   **FORALL Exception Handling:** Without `SAVE EXCEPTIONS`, if *any* DML statement within a `FORALL` batch fails with an unhandled exception, the *entire* `FORALL` statement is stopped, and all preceding successful DMLs within that batch are rolled back<sup class="footnote-ref"><a href="#fn1_25" id="fnref1_25">[25]</a></sup>. Use `SAVE EXCEPTIONS` to process the whole batch and report failures afterward via `SQL%BULK_EXCEPTIONS`.
*   **Dynamic SQL Injection (Critical!):** Concatenating user-provided strings *directly* into dynamic SQL statement text is a major security vulnerability, allowing attackers to inject malicious SQL code<sup class="footnote-ref"><a href="#fn1_26" id="fnref1_26">[26]</a></sup>. **Always use bind variables** for all data inputs in dynamic SQL statements<sup class="footnote-ref"><a href="#fn1_27" id="fnref1_27">[27]</a></sup>. Validate dynamic object names (table names, column names) against the data dictionary if they must be dynamic.
*   **Parsing Overhead (Dynamic SQL):** If you don't use bind variables and instead concatenate literal values into the dynamic SQL string, Oracle treats each unique string as a new statement, requiring a hard parse every time. This negates the performance benefit of soft parsing and statement caching<sup class="footnote-ref"><a href="#fn1_28" id="fnref1_28">[28]</a></sup>.
*   **DBMS_SQL Complexity:** While powerful, the `DBMS_SQL` API is more verbose and complex than `EXECUTE IMMEDIATE`. Using it for simple cases adds unnecessary complexity.

<div class="caution">
    <p>Beware the traps, where code can stray,<br>Null collections bite, they say!<br>Injection's sting, a hacker's prize,<br>Use binds and checks, be ever wise!</p>
</div>

This concludes our deep dive into Oracle PL/SQL Collections & Records, Bulk Operations, and Dynamic SQL. Mastering these concepts will equip you with powerful tools for handling complex data flows and writing high-performance, flexible Oracle applications.

<div class="rhyme">
With bulk and dynamic, your code will soar high,
Through data's vast ocean, you'll gracefully fly.
Remember the pitfalls, the lessons we learned,
And Oracle's power, you'll surely have earned.
</div>

<div class="footnotes">
  <hr>
  <ol>
    <li id="fn1_1">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Collection Types" (p. 6-2)</a>. This section introduces the three main collection types and their characteristics. <a href="#fnref1_1" title="Jump back to footnote 1 in the text">↩</a></p>
    </li>
    <li id="fn1_2">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Record Variables" (p. 6-50)</a>. Explains how to declare and use record variables. <a href="#fnref1_2" title="Jump back to footnote 2 in the text">↩</a></p>
    </li>
     <li id="fn1_3">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "FETCH Statement with BULK COLLECT Clause" (p. 8-33)</a>. Describes fetching multiple rows into collections using Native Dynamic SQL. <a href="#fnref1_3" title="Jump back to footnote 3 in the text">↩</a></p>
    </li>
    <li id="fn1_4">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "FORALL Statement" (p. 8-12)</a>. Provides syntax and details for the FORALL statement for bulk DML. <a href="#fnref1_4" title="Jump back to footnote 4 in the text">↩</a></p>
    </li>
     <li id="fn1_5">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "EXECUTE IMMEDIATE Statement" (p. 8-2)</a>. Details the syntax and usage of the EXECUTE IMMEDIATE statement. <a href="#fnref1_5" title="Jump back to footnote 5 in the text">↩</a></p>
    </li>
    <li id="fn1_6">
      <p><a href="/books/database-pl-sql-packages-and-types-reference/ch187_dbms_sql.pdf" title="Oracle Database PL/SQL Packages and Types Reference, 23ai - Chapter 187: DBMS_SQL Package">Oracle Database PL/SQL Packages and Types Reference, 23ai, Chapter 187: DBMS_SQL Package, Section "DBMS_SQL Overview" (p. 187-1)</a>. Provides an overview of the DBMS_SQL package and its purpose. <a href="#fnref1_6" title="Jump back to footnote 6 in the text">↩</a></p>
    </li>
    <li id="fn1_7">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records</a>. This entire chapter is dedicated to the definition and usage of collections and records within PL/SQL. <a href="#fnref1_7" title="Jump back to footnote 7 in the text">↩</a></p>
    </li>
    <li id="fn1_8">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Collection Types Defined in Package Specifications" (p. 6-49)</a>. Explains how collection types are defined and used in packages. <a href="#fnref1_8" title="Jump back to footnote 8 in the text">↩</a></p>
    </li>
     <li id="fn1_9">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "Handling FORALL Exceptions After FORALL Statement Completes" (p. 8-20)</a>. Details the usage of SAVE EXCEPTIONS and SQL%BULK_EXCEPTIONS. <a href="#fnref1_9" title="Jump back to footnote 9 in the text">↩</a></p>
    </li>
     <li id="fn1_10">
      <p><a href="/books/database-pl-sql-packages-and-types-reference/ch187_dbms_sql.pdf" title="Oracle Database PL/SQL Packages and Types Reference, 23ai - Chapter 187: DBMS_SQL Package">Oracle Database PL/SQL Packages and Types Reference, 23ai, Chapter 187: DBMS_SQL Package, Section "BIND_VARIABLE_PKG Procedure" (p. 187-33)</a>. Describes binding package-defined types like records or collections. <a href="#fnref1_10" title="Jump back to footnote 10 in the text">↩</a></p>
    </li>
    <li id="fn1_11">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch05_control-statements.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 5: PL/SQL Control Statements">Oracle Database PL/SQL Language Reference, 23ai, Chapter 5: PL/SQL Control Statements</a>. This chapter covers IF/CASE statements and various loop types, which are foundational for controlling execution flow when using collections, bulk ops, or dynamic SQL. <a href="#fnref1_11" title="Jump back to footnote 11 in the text">↩</a></p>
    </li>
    <li id="fn1_12">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Collection Variable Declaration" (p. 6-2)</a>. Details how to declare collection variables within a PL/SQL block. <a href="#fnref1_12" title="Jump back to footnote 12 in the text">↩</a></p>
    </li>
     <li id="fn1_13">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "BULK COLLECT Clause" (p. 8-25)</a>. Comprehensive details on the BULK COLLECT clause with examples. <a href="#fnref1_13" title="Jump back to footnote 13 in the text">↩</a></p>
    </li>
    <li id="fn1_14">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "FORALL Statement" (p. 8-12)</a>. Provides full syntax and examples for the FORALL statement. <a href="#fnref1_14" title="Jump back to footnote 14 in the text">↩</a></p>
    </li>
    <li id="fn1_15">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "EXECUTE IMMEDIATE Statement" (p. 8-2)</a>. Details the EXECUTE IMMEDIATE statement. <a href="#fnref1_15" title="Jump back to footnote 15 in the text">↩</a></p>
    </li>
    <li id="fn1_16">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch13_optimization-tuning.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 13: PL/SQL Optimization and Tuning">Oracle Database PL/SQL Language Reference, 23ai, Chapter 13: PL/SQL Optimization and Tuning, Section "Overview of Polymorphic Table Functions" (p. 13-53)</a>. Introduces the concept and usage of Polymorphic Table Functions. <a href="#fnref1_16" title="Jump back to footnote 16 in the text">↩</a></p>
    </li>
    <li id="fn1_17">
      <p><a href="/books/database-development-guide/ch03_performance_and_scalability.pdf" title="Oracle Database Development Guide, 23ai - Chapter 3: Performance and Scalability">Oracle Database Development Guide, 23ai, Chapter 3: Performance and Scalability, Section "Building Scalable Applications" (p. 8-1), Sub-section "About Bulk SQL" (p. 8-6)</a>. Explains how Bulk SQL reduces round trips and improves performance. <a href="#fnref1_17" title="Jump back to footnote 17 in the text">↩</a></p>
    </li>
    <li id="fn1_18">
      <p><a href="/books/database-concepts/ch08_application-data-usage.pdf" title="Oracle Database Concepts, 23ai - Chapter 8: Application Data Usage">Oracle Database Concepts, 23ai, Chapter 8: Application Data Usage, Section "Application Scalability" (p. 8-1)</a>. Discusses the concept of scalable applications and factors affecting scalability. <a href="#fnref1_18" title="Jump back to footnote 18 in the text">↩</a></p>
    </li>
     <li id="fn1_19">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "PL/SQL Dynamic SQL" (p. 8-1)</a>. Describes the reasons for using dynamic SQL when statement text is unknown at compile time. <a href="#fnref1_19" title="Jump back to footnote 19 in the text">↩</a></p>
    </li>
     <li id="fn1_20">
      <p><a href="/books/database-development-guide/ch03_performance_and_scalability.pdf" title="Oracle Database Development Guide, 23ai - Chapter 3: Performance and Scalability">Oracle Database Development Guide, 23ai, Chapter 3: Performance and Scalability, Section "Building Scalable Applications" (p. 8-1), Sub-section "About Shared SQL and Concurrency" (p. 8-10)</a>. Explains how using bind variables allows Oracle to share and reuse SQL statements. <a href="#fnref1_20" title="Jump back to footnote 20 in the text">↩</a></p>
    </li>
    <li id="fn1_21">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Collection Methods" (p. 6-32)</a>. Describes collection methods and the COLLECTION_IS_NULL exception for uninitialized/null collections. <a href="#fnref1_21" title="Jump back to footnote 21 in the text">↩</a></p>
    </li>
     <li id="fn1_22">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Collection Methods" (p. 6-32), Sub-section "EXISTS Collection Method" (p. 6-39)</a>. Explains the EXISTS method for checking element existence in sparse collections and the related exceptions. <a href="#fnref1_22" title="Jump back to footnote 22 in the text">↩</a></p>
    </li>
     <li id="fn1_23">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Assigning Values to Collection Variables" (p. 6-23), Sub-section "Data Type Compatibility" (p. 6-24)</a>. Explicitly states the rule that collection variables must have the exact same defined type for assignment. <a href="#fnref1_23" title="Jump back to footnote 23 in the text">↩</a></p>
    </li>
    <li id="fn1_24">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch06_collections-records.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 6: PL/SQL Collections and Records">Oracle Database PL/SQL Language Reference, 23ai, Chapter 6: PL/SQL Collections and Records, Section "Collection Methods" (p. 6-32), Sub-section "EXTEND Collection Method" (p. 6-38)</a>. Describes the EXTEND method for Varrays and Nested Tables and the SUBSCRIPT_BEYOND_LIMIT exception. <a href="#fnref1_24" title="Jump back to footnote 24 in the text">↩</a></p>
    </li>
     <li id="fn1_25">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "Native Dynamic SQL" (p. 8-2), Sub-section "Unhandled Exceptions in FORALL Statements" (p. 8-18)</a>. Explains the default behavior of FORALL without SAVE EXCEPTIONS. <a href="#fnref1_25" title="Jump back to footnote 25 in the text">↩</a></p>
    </li>
     <li id="fn1_26">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "SQL Injection" (p. 8-18)</a>. Details SQL Injection vulnerabilities and techniques. <a href="#fnref1_26" title="Jump back to footnote 26 in the text">↩</a></p>
    </li>
    <li id="fn1_27">
      <p><a href="/books/oracle-database-pl-sql-language-reference/ch08_dynamic-sql.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 8: Dynamic SQL">Oracle Database PL/SQL Language Reference, 23ai, Chapter 8: Dynamic SQL, Section "SQL Injection" (p. 8-18), Sub-section "Bind Variables" (p. 8-24)</a>. Emphasizes bind variables as the most effective guard against SQL Injection. <a href="#fnref1_27" title="Jump back to footnote 27 in the text">↩</a></p>
    </li>
    <li id="fn1_28">
      <p><a href="/books/database-development-guide/ch03_performance_and_scalability.pdf" title="Oracle Database Development Guide, 23ai - Chapter 3: Performance and Scalability">Oracle Database Development Guide, 23ai, Chapter 3: Performance and Scalability, Section "Building Scalable Applications" (p. 8-1), Sub-section "Using Bind Variables to Improve Scalability" (p. 8-1)</a>. Explains how bind variables facilitate soft parsing and improve scalability. <a href="#fnref1_28" title="Jump back to footnote 28 in the text">↩</a></p>
    </li>
  </ol>
</div>