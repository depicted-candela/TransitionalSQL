# SQL Course Syllabi

Below are two syllabi presented as tree structures. The first outlines an Oracle SQL course designed to bridge knowledge from PostgreSQL and incorporate features of Oracle Database 23ai. The second serves as a reference for the prerequisite PostgreSQL knowledge assumed for the Oracle course.

## Oracle SQL Course Syllabus (Bridging from PostgreSQL & Oracle 23ai)

```text
├── Key Differences & Core Syntax
│   ├── Data Types *(Oracle Specific)*
│   │   ├── VARCHAR2, NVARCHAR2
│   │   ├── NUMBER (for integers and decimals)
│   │   ├── DATE (stores date and time)
│   │   ├── TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE
│   │   └── CLOB, BLOB (Large Objects - for XML/binary data mentioned in job)
│   ├── DUAL Table *(Oracle Specific)* (Uses for functions, SYSDATE, sequences)
│   ├── NULL Handling *(Practice in Oracle)*
│   │   ├── NVL, NVL2 *(Oracle Specific)*
│   │   └── COALESCE (Already known)
│   ├── Conditional Expressions *(Practice in Oracle)*
│   │   ├── DECODE function *(Oracle Specific - older, CASE is preferred)*
│   │   └── CASE (Already known)
│   ├── ROWNUM Pseudo-column *(Oracle Specific)* (For limiting rows, pagination - be aware of its behavior vs. ROW_NUMBER() OVER())
│   ├── Comments (-- and /* */ - Already known)
│   └── New SQL Features in 23ai *(Oracle 23ai Specific)*
│       ├── Boolean Data Type *(ISO SQL standard-compliant)*
│       ├── Direct Joins for UPDATE/DELETE *(Using FROM clause)*
│       ├── GROUP BY Column Alias *(Supports alias in GROUP BY, CUBE, ROLLUP)*
│       ├── IF [NOT] EXISTS for DDL *(Conditional checks for object existence)*
│       ├── INTERVAL Data Type Aggregations *(SUM/AVG over INTERVAL types)*
│       ├── RETURNING INTO Clause *(Enhanced for INSERT, UPDATE, DELETE)*
│       ├── SELECT without FROM Clause *(Expression-only queries)*
│       ├── SQL Time Buckets *(TIME_BUCKET operator for time series)*
│       └── Table Value Constructor *(VALUES clause for SELECT, INSERT, MERGE)*
├── Date Functions *(Oracle Specifics & Practice)*
│   ├── SYSDATE, CURRENT_DATE, SYSTIMESTAMP, CURRENT_TIMESTAMP *(Oracle Specific)*
│   ├── TO_DATE, TO_CHAR (Crucial for conversions; Oracle's format models are key)
│   ├── ADD_MONTHS, MONTHS_BETWEEN, LAST_DAY, NEXT_DAY, TRUNC, ROUND (for dates)
│   └── Date Arithmetic (date +/- number, date - date, INTERVAL types - known from PG, practice Oracle syntax)
├── String Functions *(Practice in Oracle - focus on any Oracle-unique powerful functions)*
│   └── (CONCAT, SUBSTR, INSTR, LENGTH, TRIM, UPPER, LOWER, REPLACE - most are standard, || for concat is common in Oracle)
├── Set Operators *(Practice in Oracle)*
│   └── MINUS *(Oracle Specific - equivalent to EXCEPT which you know)*
├── Hierarchical Queries *(Oracle Specific - Very Important)*
│   ├── CONNECT BY clause
│   ├── LEVEL pseudo-column
│   ├── PRIOR operator
│   └── START WITH clause
├── Analytic (Window) Functions *(Practice in Oracle Syntax)*
│   ├── Ranking: RANK, DENSE_RANK, ROW_NUMBER (Known from PG)
│   ├── Navigation: LAG, LEAD (Known from PG)
│   └── Aggregates: SUM() OVER (...), AVG() OVER (...) (Known from PG)
├── Data Manipulation Language (DML) & Transaction Control *(Practice in Oracle)*
│   ├── INSERT, UPDATE, DELETE, SELECT (Known)
│   ├── MERGE statement *(Oracle Specific - powerful for conditional insert/update)*
│   └── COMMIT, ROLLBACK, SAVEPOINT (Known concepts, practice in Oracle context)
├── Handling Complex Data Types (Job Relevance: XML)
│   ├── XMLTYPE Data Type *(Oracle Specific)*
│   │   ├── Basic storage and querying
│   │   ├── XMLTABLE, XMLELEMENT, XMLFOREST, XMLAGG (Key functions for XML processing)
│   │   ├── XPath expressions for navigation
│   │   └── Transportable Binary XML (TBX) *(Oracle 23ai Specific - Enhanced XML storage)*
│   ├── JSON Data Type *(Oracle Specific - if time permits, XML is explicit in job)*
│   │   ├── Native JSON storage and indexing (Oracle 12c+)
│   │   ├── JSON_TABLE, JSON_VALUE, JSON_QUERY, JSON_OBJECT, JSON_ARRAY
│   │   ├── JSON Relational Duality Views *(Oracle 23ai Specific - Unified relational/JSON access)*
│   │   ├── JSON Binary Data Type *(Oracle 23ai Specific - Optimized binary JSON format)*
│   │   └── JSON Collection Tables *(Oracle 23ai Specific - For document storage)*
│   └── Large Objects (CLOB, BLOB) *(Oracle Specific - revisit from Data Types)*
│       └── DBMS_LOB package basics (for manipulating LOBs in PL/SQL)
├── PL/SQL: Oracle's Procedural Powerhouse *(Core New Learning)*
│   ├── Fundamentals
│   │   ├── PL/SQL Block Structure (DECLARE, BEGIN, EXCEPTION, END)
│   │   ├── Variables & Constants (Scalar types, %TYPE, %ROWTYPE attributes)
│   │   ├── Conditional Control (IF-THEN-ELSIF-ELSE, CASE statements/expressions)
│   │   ├── Iterative Control (Loops: Basic LOOP, WHILE, FOR)
│   │   ├── SQL within PL/SQL (Implicit SELECT INTO, DML operations)
│   │   └── DBMS_OUTPUT.PUT_LINE (For debugging and simple output)
│   ├── Cursors
│   │   ├── Implicit Cursors (SQL%ROWCOUNT, SQL%FOUND, SQL%NOTFOUND, SQL%ISOPEN)
│   │   ├── Explicit Cursors (DECLARE, OPEN, FETCH, CLOSE, %ISOPEN, %FOUND, %NOTFOUND, %ROWCOUNT)
│   │   └── Cursor FOR Loops (Implicit open, fetch, close)
│   ├── Stored Procedures & Functions
│   │   ├── Syntax: CREATE [OR REPLACE] PROCEDURE/FUNCTION
│   │   ├── Parameter Modes: IN, OUT, IN OUT, DEFAULT values
│   │   ├── Executing Procedures & Functions (from SQL and PL/SQL)
│   │   └── RETURN statement (for Functions)
│   ├── Packages *(Oracle Specific - Fundamental for organizing PL/SQL)*
│   │   ├── Package Specification (Public declarations: types, variables, cursors, procedures, functions)
│   │   ├── Package Body (Implementation of procedures, functions; private elements)
│   │   ├── Benefits: Modularity, Encapsulation, Information Hiding, Performance (session-wide state)
│   │   └── Overloading procedures and functions within packages
│   ├── Exception Handling
│   │   ├── Predefined System Exceptions (e.g., NO_DATA_FOUND, TOO_MANY_ROWS, ZERO_DIVIDE, DUP_VAL_ON_INDEX)
│   │   ├── User-Defined Exceptions (DECLARE exception_name EXCEPTION; RAISE exception_name;)
│   │   ├── SQLCODE and SQLERRM functions
│   │   └── PRAGMA EXCEPTION_INIT (Associating user-defined exceptions with Oracle error numbers)
│   ├── Triggers *(Oracle Specific - Practice with DML Triggers)*
│   │   ├── DML Triggers (BEFORE/AFTER, FOR EACH ROW/STATEMENT on INSERT, UPDATE, DELETE)
│   │   ├── :NEW and :OLD pseudo-records for row-level triggers
│   │   └── Conditional Predicates (WHEN clause)
│   ├── Collections & Records *(Oracle Specific - Important for complex data structures in PL/SQL)*
│   │   ├── Associative Arrays (Index-by Tables: PLS_INTEGER or VARCHAR2 index)
│   │   ├── Nested Tables (Store as database objects or use within PL/SQL)
│   │   ├── Varrays (Variable-size arrays)
│   │   └── User-Defined Records (%ROWTYPE or custom structure)
│   ├── Bulk Operations for Performance *(Oracle Specific - Crucial for efficient processing)*
│   │   ├── BULK COLLECT clause (with SELECT INTO, FETCH INTO)
│   │   └── FORALL statement (for bulk DML: INSERT, UPDATE, DELETE)
│   ├── Dynamic SQL *(Oracle Specific - Use when static SQL is not possible)*
│   │   ├── EXECUTE IMMEDIATE statement (for DDL, DML, and single-row queries)
│   │   └── DBMS_SQL package (for more complex dynamic SQL with varying binds/defines)
│   ├── Built-in Packages (Awareness and usage for job tasks)
│   │   ├── DBMS_LOB (Revisit - essential for XML if stored in CLOBs)
│   │   ├── DBMS_XMLGEN, XMLDOM, XMLPARSER (For XML manipulation in PL/SQL - if needed for Flexcube/Java interaction)
│   │   ├── UTL_FILE (For server-side file I/O - context-dependent)
│   │   ├── DBMS_AQ (For Oracle Advanced Queuing - relevant if "JMS Queues" in job desc maps to Oracle AQ)
│   │   ├── JavaScript Stored Procedures *(Oracle 23ai Specific - Invoke JavaScript from SQL/PL/SQL)*
│   │   └── SQL Transpiler *(Oracle 23ai Specific - Automatic PL/SQL to SQL conversion)*
├── Essential Oracle Database Concepts (For Consulting Role)
│   ├── Oracle Data Dictionary & Metadata Views *(Oracle Specific)*
│   │   ├── Distinguishing USER_ (user's schema), ALL_ (accessible), DBA_ (privileged) views
│   │   ├── Key Views for a Developer/Consultant:
│   │   │   ├── *_TABLES, *_TAB_COLUMNS, *_VIEWS
│   │   │   ├── *_INDEXES, *_IND_COLUMNS
│   │   │   ├── *_CONSTRAINTS, *_CONS_COLUMNS
│   │   │   ├── *_SEQUENCES, *_SYNONYMS
│   │   │   ├── *_OBJECTS (To find any object in the schema)
│   │   │   └── *_SOURCE (To view PL/SQL code for procedures, functions, packages, triggers)
│   ├── Oracle Schema Objects Overview *(Practice in Oracle)*
│   │   ├── Tables, Views, Indexes, Sequences, Synonyms, Procedures, Functions, Packages, Triggers (understand their roles and basic DDL)
│   │   ├── Wide Tables *(Oracle 23ai Specific - Supports up to 4,096 columns)*
│   │   └── Value LOBs *(Oracle 23ai Specific - Read-only LOBs for temporary use)*
│   ├── Concurrency Control & Locking *(Conceptual Understanding)*
│   │   ├── Multi-Version Concurrency Control (MVCC) in Oracle (How Oracle handles read consistency)
│   │   └── Basic Locking (Row-level vs. Table-level locks - conceptual, for understanding potential performance issues)
│   ├── Transaction Management *(Practice in Oracle - Already known, but reinforce)*
│   │   └── COMMIT, ROLLBACK, SAVEPOINT
│   ├── Database Security *(Oracle 23ai Specific)*
│   │   ├── SQL Firewall *(Kernel-level protection against SQL injection)*
│   │   ├── Column-Level Auditing *(Fine-grained auditing)*
│   │   ├── Data Redaction *(Dynamic masking of sensitive data)*
│   │   ├── Multicloud Authentication *(Support for OCI IAM and Microsoft Entra ID)*
│   │   └── Schema Privileges *(Enhanced access control)*
│   ├── Metadata and Documentation *(Oracle 23ai Specific)*
│   │   ├── Usage Annotations *(Custom metadata for database objects)*
│   │   └── Usage Domains *(Document intended data usage)*
├── Oracle Performance & Optimization Basics
│   ├── Indexing in Oracle *(Leverage user's PG knowledge, focus on Oracle specifics)*
│   │   ├── B-Tree Indexes (Most common)
│   │   ├── Bitmap Indexes *(Oracle Specific - For low-cardinality columns in data warehousing/reporting)*
│   │   ├── Function-Based Indexes *(Oracle Specific - Indexing on expressions/functions)*
│   │   ├── Composite Indexes (Order matters - known concept)
│   │   └── Brief awareness: Index-Organized Tables (IOTs), Reverse Key Indexes, Compressed Indexes
│   ├── Understanding Oracle's EXPLAIN PLAN *(Oracle Specific)*
│   │   ├── How to generate: `EXPLAIN PLAN FOR ...` followed by `SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);`
│   │   ├── Reading the Execution Plan: Key operations (TABLE ACCESS FULL/BY INDEX ROWID, INDEX UNIQUE/RANGE SCAN, HASH JOIN, NESTED LOOPS, SORT, FILTER)
│   │   └── Interpreting Cardinality, Cost, and Time estimates
│   ├── Basic Query Tuning Considerations *(Practice in Oracle)*
│   │   ├── SARGable Predicates (Making WHERE clauses index-friendly - known concept)
│   │   ├── Efficient Joins (Planner usually handles, but understand join types)
│   │   └── Minimizing Data Processed (SELECT specific columns, filter early)
│   ├── Optimizer Hints *(Oracle Specific - Awareness and cautious use)*
│   │   └── Common hints (e.g., /*+ INDEX(table_alias index_name) */, /*+ FULL(table_alias) */, /*+ USE_NL(t1 t2) */)
│   ├── Table Statistics & DBMS_STATS *(Oracle Specific)*
│   │   ├── Importance of accurate statistics for the Cost-Based Optimizer (CBO)
│   │   └── DBMS_STATS package (e.g., GATHER_TABLE_STATS, GATHER_SCHEMA_STATS)
│   ├── Advanced Performance Features *(Oracle 23ai Specific)*
│   │   ├── Real-Time SQL Plan Management *(Automatic detection and repair of plan regressions)*
│   │   ├── True Cache *(In-memory cache for performance)*
│   │   ├── Fast Ingest Enhancements *(Support for partitioning and compression)*
│   │   └── SQL Analysis Report *(Helps identify common SQL issues)*
├── (Conceptual) Oracle & Interfacing Technologies (For Job Context)
│   ├── Oracle & Java Connectivity (JDBC) *(Job Context)*
│   │   └── How Java applications typically call PL/SQL Stored Procedures/Functions (CallableStatement)
│   ├── Oracle & XML Processing *(Job Context - Tie-in to XMLTYPE and PL/SQL)*
│   │   └── How PL/SQL can be used to generate or parse XML for Java/Flexcube layers
│   ├── Oracle Advanced Queuing (AQ) & JMS *(Job Context - If "JMS Queues" is a key part of the role)*
│   │   └── Conceptual understanding of AQ as a messaging system and its potential use as a JMS provider
│   ├── Enhanced Connection Management *(Oracle 23ai Specific)*
│   │   ├── Implicit Connection Pooling
│   │   ├── Multi-Pool DRCP
│   │   └── Per-PDB PRCP
│   ├── Database Driver Asynchronous Programming *(Oracle 23ai Specific)*
│   │   └── Pipelining for improved scalability and responsiveness
│   ├── Multicloud Configuration *(Oracle 23ai Specific)*
│   │   └── Support for Azure App Configuration and OCI Object Storage
│   └── Observability with OpenTelemetry *(Oracle 23ai Specific)*
│       └── Enhanced logging, debugging, and tracing for Java/.NET applications
```

## Reference PostgreSQL Course Syllabus (Prerequisite Knowledge)

```text
BASIC SQL
---------
├── Conditionals: WHERE
│   ├── BETWEEN, IN, NOT, LIKE, =, !=, <>, %
├── Conditionals: ORDER
│   └── LIMIT, OFFSET, DESC

INTERMEDIATE SQL
----------------
├── Aggregators: GROUP, HAVING
│   ├── SUM, AVG, MIN, MAX, etc
├── Conditionals: DISTINCT
├── Arithmetic: +, -, *, /, %, ^
├── Math Functions: ABS, ROUND, CEIL, FLOOR, POWER, MOD
├── Date Functions:
│   ├── creators: CURRENT_TIME, CURRENT_DATE, CURRENT TIMESTAMP
│   ├── comparators: <>, <, >, <=, >=,
│   ├── extractors: EXTRACT(), DATE_PART(), DATE_TRUNC()
│   ├── constants: INTERVAL
│   ├── formatters: ::, TO_*
│   │   ├── ::DATE, ::TIMESTAMP, TO_DATE, TO_TIMESTAMP
├── Casters: CAST, ::
├── Null Space: COALESCE, IFNULL, IS NULL, IS NOT NULL
├── Cases: for SELECT, for WHERE
├── Joins: INNER, LEFT, RIGHT, FULL OUTER

Complementary SQL for Basic and Intermediate Levels
---------------------------------------------------
Conditionals
├── Advanced WHERE Conditions
│   ├── Subqueries in WHERE
│   │   ├── IN
│   │   ├── EXISTS
│   │   ├── ANY
│   │   └── ALL
│   ├── IS DISTINCT FROM
│   └── IS NOT DISTINCT FROM
├── Advanced ORDER BY
│   ├── Ordering by multiple columns
│   ├── NULLS FIRST
│   └── NULLS LAST
Joins
├── CROSS JOIN
├── NATURAL JOIN
├── SELF JOIN
├── USING clause
Aggregators
├── COUNT(DISTINCT)
├── FILTER clause
Date Functions
├── Date arithmetic
├── OVERLAPS operator
Cases
├── Searched CASE expressions
├── CASE in ORDER BY
├── CASE in GROUP BY
Null Space
├── NULLIF
├── NULL handling in aggregations
├── NULL handling in sorting
Arithmetic and Math Functions
├── LOG
├── SQRT
String Functions
├── CONCAT
├── SUBSTRING
├── TRIM
├── UPPER
├── LOWER
├── POSITION
├── LENGTH
Set Operations
├── UNION
├── UNION ALL
├── INTERSECT
├── EXCEPT
Subqueries
├── Scalar subqueries
├── Correlated subqueries
├── Subqueries in FROM clause
├── Subqueries in SELECT clause

ADVANCED SQL
------------
Advanced Query Techniques
├── Other Query Clauses
│   ├── FETCH
│   │   └── ROW[S] ONLY
│   └── OFFSET
│       └── OFFSET count
├── LATERAL Joins
│   ├── Subquery correlation
│   └── Flexible joins
├── Common Table Expressions (CTEs)
│   ├── Basic CTEs (WITH clause)
│   ├── Nested CTEs
│   └── Recursive Queries
│       ├── Recursive CTEs (WITH RECURSIVE)
│       └── Hierarchical data handling
Data Transformation and Aggregation
├── Advanced Aggregate Functions
│   ├── STRING_AGG
│   ├── ARRAY_AGG
│   ├── JSON_AGG
│   ├── PERCENTILE_CONT
│   ├── CORR
│   └── REGR_SLOPE
├── Advanced Grouping Operations
│   └── GROUPING SETS, CUBE, and ROLLUP
├── Set Returning Functions
│   ├── generate_series
│   └── unnest
├── JSON and Array Functions
│   ├── json_extract_path
│   ├── json_array_elements
│   ├── json_build_object
│   ├── array_append
│   └── array_length
Analytical Constructs
├── Window Function Clauses
│   ├── OVER()
│   │   ├── PARTITION BY
│   │   ├── ORDER BY
│   │   └── ROWS/RANGE
│   ├── WINDOW
│   │   └── window_definition_name
│   └── QUALIFY
├── Window Functions
│   ├── Ranking Functions
│   │   ├── RANK
│   │   ├── DENSE_RANK
│   │   ├── ROW_NUMBER
│   │   ├── percent_rank
│   │   ├── cume_dist
│   │   └── ntile
│   ├── Aggregate Functions
│   │   ├── SUM
│   │   ├── AVG
│   │   ├── COUNT
│   │   ├── first_value
│   │   ├── last_value
│   │   └── nth_value
│   └── Navigation Functions
│       ├── LEAD
│       └── LAG
Query Optimization and Performance
├── Indexing Strategies
│   ├── B-tree indexes
│   ├── GIN indexes
│   └── GiST indexes
├── EXPLAIN Plans
│   ├── Query execution analysis
│   └── Cost estimation
├── Optimizing Window Functions and Aggregates
│   ├── Reducing computation overhead
│   └── Index usage with window functions