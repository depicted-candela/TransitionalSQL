<head>
    <link rel="stylesheet" href="../styles/lecture.css">
</head>

<div class="toc-popup-container">
    <input type="checkbox" id="tocToggleChunk7" class="toc-toggle-checkbox">
    <label for="tocToggleChunk7" class="toc-toggle-label">
        <span class="toc-icon-open"></span>
        Contents
    </label>
    <div class="toc-content">
        <ul>
            <li><a href="#chunk7Sec1">Section 1: What Are They? (Meanings & Values in Oracle)</a>
                <ul>
                    <li><a href="#chunk7Sec1Sub1">Packages</a></li>
                    <li><a href="#chunk7Sec1Sub2">Exception Handling</a></li>
                    <li><a href="#chunk7Sec1Sub3">Triggers</a></li>
                </ul>
            </li>
            <li><a href="#chunk7Sec2">Section 2: Relations: How They Play with Others (in Oracle)</a>
                <ul>
                    <li><a href="#chunk7Sec2Sub1">Packages Relations</a></li>
                    <li><a href="#chunk7Sec2Sub2">Exception Handling Relations</a></li>
                    <li><a href="#chunk7Sec2Sub3">Triggers Relations</a></li>
                </ul>
            </li>
            <li><a href="#chunk7Sec3">Section 3: How to Use Them: Structures & Syntax (in Oracle)</a>
                <ul>
                    <li><a href="#chunk7Sec3Sub1">Packages: Structures & Syntax</a></li>
                    <li><a href="#chunk7Sec3Sub2">Exception Handling: Structures & Syntax</a></li>
                    <li><a href="#chunk7Sec3Sub3">Triggers: Structures & Syntax</a></li>
                </ul>
            </li>
            <li><a href="#chunk7Sec4">Section 4: Why Use Them? (Advantages in Oracle)</a></li>
            <li><a href="#chunk7Sec5">Section 5: Watch Out! (Disadvantages & Pitfalls in Oracle)</a></li>
        </ul>
    </div>
</div>

<div class="container" id="chunk7Container">

<h1 id="chunk7Title">Chunk 7: PL/SQL Resilience: Packages, Errors, and Automation</h1>

<p>This chunk focuses on building robust and maintainable PL/SQL applications by leveraging Oracle's powerful features for code organization (Packages), error management (Exception Handling), and automated responses to database events (Triggers). If you think code's like a sturdy tower, then these are your best builders, ever.</p>

<h2 id="chunk7Sec1">Section 1: What Are They? (Meanings & Values in Oracle)</h2>

<h3 id="chunk7Sec1Sub1">Packages</h3>
<p>In Oracle PL/SQL, a <strong>Package</strong> is a schema object that groups logically related PL/SQL types, variables, constants, cursors, subprograms (procedures and functions), and exceptions.<sup id="fnref1_1"><a href="#fn1_1">1</a></sup> Think of it as a library or a module for your PL/SQL code. It's not just a folder, it's a vault of power, a coder's might, where logic's stored, both dark and bright!</p>
<ul>
    <li><strong>Meaning:</strong> Packages provide a way to encapsulate and organize related PL/SQL constructs. They consist of two distinct parts:
        <ul>
            <li><strong>Package Specification (Spec):</strong> This is the public interface of the package. It declares the types, variables, constants, exceptions, cursors, and subprogram headers (signatures) that are accessible from outside the package. It's like the blueprint, the contract, or the menu you show your users. What they see is what they get, and no peeking in the kitchen yet!</li>
            <li><strong>Package Body:</strong> This contains the implementation details of the cursors and subprograms declared in the specification. It can also contain private declarations (types, variables, subprograms) that are only accessible within the package body itself. This is where the magic happens, the secret sauce, hidden from prying application clauses.</li>
        </ul>
    </li>
    <li><strong>Values/Outputs:</strong>
        <ul>
            <li>A compiled package specification and body stored in the database.</li>
            <li>Publicly declared variables and constants hold values that can persist throughout a session (unless the package is </code>SERIALLY_REUSABLE</code> ).</li>
            <li>Public functions return values.</li>
            <li>Public procedures can modify database state or return values via <code>OUT</code> or <code>IN OUT</code> parameters.</li>
        </ul>
    </li>
    <li><strong>Overloading:</strong> Within a package, you can have multiple subprograms (procedures or functions) with the same name, as long as their parameter lists differ in number, order, or data type family. This is called overloading.<sup id="fnref1_2"><a href="#fn1_2">2</a></sup> It's like having twins with different skills, a handy trick that truly thrills!</li>
    <li><strong class="oracle-specific">Oracle 23ai Note:</strong> While no specific 23ai features directly overhaul package syntax, the stability and power of packages make them crucial for organizing code that might leverage new 23ai SQL and PL/SQL features.</li>
</ul>

<div class="postgresql-bridge">
<p><strong>PostgreSQL Bridge:</strong> PostgreSQL uses schemas to group related objects, including functions. You can create functions within a schema. However, Oracle Packages offer a more structured and powerful form of encapsulation. PostgreSQL doesn't have a direct equivalent to the "package body" concept for hiding implementation details in the same way, nor package-level variables that maintain state across calls within a session as seamlessly. PostgreSQL functions are generally standalone or grouped by schema, while Oracle packages provide a tighter, more controlled module with distinct public interfaces and private implementations. Think of schemas as neighborhoods, and packages as well-designed apartment buildings within those neighborhoods, each with its own rules and private spaces.</p>
</div>

<h3 id="chunk7Sec1Sub2">Exception Handling</h3>
<p>Exception handling in PL/SQL is a mechanism to deal with runtime errors (called exceptions) gracefully, allowing your program to continue, log the error, or perform cleanup actions instead of abruptly terminating.<sup id="fnref1_3"><a href="#fn1_3">3</a></sup> When errors knock, don't let your program block, with good exceptions, it'll tick like a clock!</p>
<ul>
    <li><strong>Meaning:</strong> An exception is an error condition that occurs during program execution. PL/SQL allows you to "catch" or "handle" these exceptions in a special <code>EXCEPTION</code> section of a PL/SQL block.</li>
    <li><strong>Values/Outputs:</strong>
        <ul>
            <li>When an exception is raised, normal execution stops, and control transfers to the exception-handling section.</li>
            <li></code>SQLCODE</code>: A function that returns the Oracle error number (ORA-xxxxx) associated with the most recent exception.</li>
            <li></code>SQLERRM</code>: A function that returns the error message associated with the most recent exception.</li>
        </ul>
    </li>
    <li><strong>Types of Exceptions:</strong>
        <ul>
            <li><strong>Predefined Exceptions:</strong> System-defined exceptions that have names (e.g., </code>NO_DATA_FOUND</code> , <code>TOO_MANY_ROWS</code> , <code>ZERO_DIVIDE</code> , <code>VALUE_ERROR</code> ). Oracle raises these automatically.<sup id="fnref1_4"><a href="#fn1_4">4</a></sup></li>
            <li><strong>User-Defined Exceptions:</strong> Exceptions explicitly declared by the programmer. These must be raised explicitly using the <code>RAISE</code> statement.<sup id="fnref1_5"><a href="#fn1_5">5</a></sup></li>
            <li><strong>Internally Defined (Unnamed) Exceptions:</strong> Other Oracle errors that don't have predefined names. These are typically handled with a <code>WHEN OTHERS</code> handler or by assigning a name using <code>PRAGMA EXCEPTION_INIT</code> .</li>
        </ul>
    </li>
    <li><strong><code>PRAGMA EXCEPTION_INIT</code>:</strong> A compiler directive that associates a user-defined exception name with a specific Oracle error number (ORA-xxxxx). This allows you to handle specific unnamed Oracle errors by name.<sup id="fnref1_6"><a href="#fn1_6">6</a></sup></li>
</ul>

<div class="postgresql-bridge">
<p><strong>PostgreSQL Bridge:</strong> PostgreSQL also has robust exception handling within its procedural language (PL/pgSQL) using <code>BEGIN...EXCEPTION...END</code> blocks. The concepts are very similar:
    <ul>
        <li>PostgreSQL uses <code>SQLSTATE</code> (a five-character code defined by the SQL standard) and </code>SQLERRM</code> (the error message) within the <code>EXCEPTION</code> block. Oracle's </code>SQLCODE</code> is Oracle-specific, though <code>SQLSTATE</code> is also available in Oracle.</li>
        <li>PostgreSQL has predefined condition names (e.g., <code>no_data_found</code> , <code>too_many_rows</code> ).</li>
        <li>You can raise user-defined exceptions in PostgreSQL using <code>RAISE EXCEPTION 'message' USING ERRCODE = 'XXXXX';</code> or by condition name.</li>
        <li>The <code>PRAGMA EXCEPTION_INIT</code> in Oracle is a way to give a PL/SQL-friendly name to a specific ORA- error, which is a bit more direct than always checking <code>SQLSTATE</code> or </code>SQLCODE</code> for specific internal errors if you want to name them.</li>
    </ul>
The core idea of trapping and handling errors is the same. The main differences lie in the specific functions (</code>SQLCODE</code> vs. <code>SQLSTATE</code> primarily) and the mechanism for naming Oracle-specific internal errors (<code>PRAGMA EXCEPTION_INIT</code> ).
</p>
</div>

<h3 id="chunk7Sec1Sub3">Triggers</h3>
<p>A <strong>Trigger</strong> in Oracle is a stored PL/SQL block that is automatically executed (or "fired") in response to a specific database event.<sup id="fnref1_7"><a href="#fn1_7">7</a></sup> They're like silent guardians, watching your data, springing to action when events meet their strata.</p>
<ul>
    <li><strong>Meaning:</strong> Triggers are used to automate actions based on events such as Data Manipulation Language (DML) operations (</code>INSERT</code> , <code>UPDATE</code> , <code>DELETE</code> ), Data Definition Language (DDL) statements (<code>CREATE</code> , <code>ALTER</code> , <code>DROP</code> ), or database events (like <code>LOGON</code> , <code>LOGOFF</code> , <code>STARTUP</code> , <code>SHUTDOWN</code> , <code>SERVERERROR</code> ).</li>
    <li><strong>DML Triggers:</strong> These are the most common for application logic. They can be defined to fire:
        <ul>
            <li><strong>Timing:</strong> <code>BEFORE</code> or <code>AFTER</code> the DML statement executes.</li>
            <li><strong>Level:</strong> <code>FOR EACH ROW</code> (row-level trigger, fires once for each affected row) or at the <code>STATEMENT</code> level (fires once for the DML statement, regardless of how many rows are affected).</li>
        </ul>
    </li>
    <li><strong><code>:NEW</code> and <code>:OLD</code> Qualifiers (Pseudorecords):</strong> Within a row-level DML trigger, Oracle provides two special records:<sup id="fnref1_8"><a href="#fn1_8">8</a></sup>
        <ul>
            <li><code>:OLD</code>: Contains the values of the row *before* the DML operation. For </code>INSERT</code> triggers, all fields in <code>:OLD</code> are NULL.</li>
            <li><code>:NEW</code>: Contains the values of the row *after* the DML operation (for </code>INSERT</code> and <code>UPDATE</code> ) or the values being inserted. For <code>DELETE</code> triggers, all fields in <code>:NEW</code> are NULL. For <code>BEFORE UPDATE</code> triggers, you can modify <code>:NEW</code> values before they are written to the table.</li>
        </ul>
    </li>
    <li><strong>Conditional Predicates:</strong> Within a DML trigger body, you can use <code>INSERTING</code> , <code>UPDATING</code> , or <code>DELETING</code> boolean conditions to determine which DML operation fired the trigger, especially if the trigger is defined for multiple DML events (e.g., <code>AFTER INSERT OR UPDATE OR DELETE</code> ).<sup id="fnref1_9"><a href="#fn1_9">9</a></sup> You can also use <code>UPDATING('columnName')</code> to check if a specific column was part of an <code>UPDATE</code> statement.</li>
    <li><strong class="oracle-specific">Oracle 23ai Note:</strong> While the core trigger mechanism remains, using them in conjunction with new 23ai features like SQL Firewall (for security-related actions) or JSON Relational Duality Views (if DML on the view needs custom handling on base tables) might present new use cases.</li>
</ul>

<div class="postgresql-bridge">
<p><strong>PostgreSQL Bridge:</strong> PostgreSQL also has powerful trigger functionality. Key similarities and differences:
    <ul>
        <li><strong>Syntax:</strong> The <code>CREATE TRIGGER</code> syntax is different. PostgreSQL triggers call a special type of function (trigger function) that returns <code>TRIGGER</code> or <code>NULL</code> . Oracle PL/SQL triggers contain the procedural logic directly within the trigger body.</li>
        <li><strong><code>:NEW</code> and <code>:OLD</code> Analogs:</strong> PostgreSQL trigger functions have access to <code>NEW</code> and <code>OLD</code> record variables, similar to Oracle's <code>:NEW</code> and <code>:OLD</code> pseudorecords.</li>
        <li><strong>Conditional Predicates:</strong> In PostgreSQL, the trigger function can inspect <code>TG_OP</code> (a special variable containing 'INSERT', 'UPDATE', 'DELETE', or 'TRUNCATE') to determine the operation. This is analogous to Oracle's <code>INSERTING</code> , <code>UPDATING</code> , <code>DELETING</code> predicates. PostgreSQL doesn't have a direct equivalent to <code>UPDATING('columnName')</code> within the trigger function itself, though you could compare <code>NEW.columnName</code> with <code>OLD.columnName</code> to infer an update to a specific column.</li>
    </ul>
The fundamental purpose and capabilities of DML triggers are quite similar. The primary difference is the syntax and the way the trigger logic is implemented (inline PL/SQL block in Oracle vs. a separate trigger function in PostgreSQL).
</p>
</div>

<h2 id="chunk7Sec2">Section 2: Relations: How They Play with Others (in Oracle)</h2>

<h3 id="chunk7Sec2Sub1">Packages Relations</h3>
<ul>
    <li><strong>Within Packages:</strong>
        <ul>
            <li><strong>Specification and Body:</strong> The body implements what the specification declares. Public items in the spec are callable from the body. Private items in the body are only callable from within the same body.</li>
            <li><strong>Overloading:</strong> Overloaded subprograms within the same package (or package body) must have distinguishable parameter lists.</li>
            <li><strong>Package State:</strong> Public variables and constants in the specification, and private variables in the body, contribute to the package's state, which can be maintained across calls within the same session.</li>
        </ul>
    </li>
    <li><strong>With Previous Oracle Concepts (Chunks 1-6):</strong>
        <ul>
            <li><strong>PL/SQL Fundamentals (Chunk 5):</strong> Packages are a fundamental organizational unit for PL/SQL code, containing blocks, variables, conditional logic, and loops.
                <p class="rhyme">Packages group your PL/SQL art,<br>
                Giving structure, a brand new start.</p>
            </li>
            <li><strong>Cursors, Procedures, Functions (Chunk 6):</strong> Packages are the primary way to define and group related cursors, procedures, and functions, making them reusable and manageable. The <code>REF CURSOR</code> type, often used for returning result sets, is frequently declared within a package specification.</li>
            <li><strong>SQL within PL/SQL (Chunk 5):</strong> Procedures and functions within packages will invariably execute SQL DML and queries.</li>
            <li><strong>Data Types (Oracle Specific - Chunk 1, PL/SQL - Chunk 5):</strong> Package specifications often declare custom PL/SQL types (<code>RECORD</code> , collection types like <code>TABLE OF ... INDEX BY PLS_INTEGER</code> ) that are then used by public subprograms.</li>
        </ul>
    </li>
</ul>

<div class="postgresql-bridge">
<p><strong>Packages & PostgreSQL Bridge:</strong>
    <ul>
        <li>While PostgreSQL uses schemas for grouping, Oracle packages provide a tighter coupling of specification (public API) and body (implementation). This explicit separation and the ability to hide implementation details (private elements in the body) are stronger in Oracle packages.</li>
        <li>PostgreSQL functions can be overloaded based on argument types (similar to Oracle).</li>
        <li>The concept of "package state" (session-persistent variables within a package) is more explicit and structured in Oracle than typical session-level variables or temporary table workarounds in PostgreSQL for similar effects.</li>
    </ul>
</p>
</div>

<h3 id="chunk7Sec2Sub2">Exception Handling Relations</h3>
<ul>
    <li><strong>Within Exception Handling:</strong>
        <ul>
            <li><strong>Predefined, User-Defined, Internally Defined:</strong> These are categories of exceptions. Predefined and named internally defined (via <code>PRAGMA EXCEPTION_INIT</code> ) exceptions can be handled specifically by name. User-defined exceptions are always handled by name.</li>
            <li></code>SQLCODE</code> and </code>SQLERRM</code>:</strong> These functions provide information about the *current* exception being handled within an <code>EXCEPTION</code> block.</li>
            <li><strong><code>RAISE</code> Statement:</strong> Can be used to explicitly raise a user-defined exception, a predefined exception, or to re-raise the current exception within an exception handler.</li>
            <li><strong><code>PRAGMA EXCEPTION_INIT</code>:</strong> Links a user-declared exception name to an Oracle error number, allowing named handling of otherwise unnamed internal errors.</li>
        </ul>
    </li>
    <li><strong>With Previous Oracle Concepts (Chunks 1-6):</strong>
        <ul>
            <li><strong>PL/SQL Block Structure (Chunk 5):</strong> Exception handling is an optional part of any PL/SQL block (anonymous, procedure, function, trigger, package initialization).
                <p class="rhyme">In every block, where errors might creep,<br>
                An <code>EXCEPTION</code> clause, your sanity to keep.</p>
            </li>
            <li><strong>SQL within PL/SQL (Chunk 5):</strong> SQL statements executed within PL/SQL are common sources of exceptions (e.g., </code>NO_DATA_FOUND</code> from a </code>SELECT INTO</code> , </code>DUP_VAL_ON_INDEX</code> from an </code>INSERT</code> ).</li>
            <li><strong>Cursors (Chunk 6):</strong> Operations like <code>FETCH</code> ing past the end of a cursor can raise </code>NO_DATA_FOUND</code> . Implicit cursors also have attributes like <code>SQL%NOTFOUND</code> that can be checked to *prevent* exceptions.</li>
            <li><strong>Procedures & Functions (Chunk 6):</strong> These subprograms can (and should) have their own exception handling sections. Unhandled exceptions propagate up the call stack.</li>
            <li><strong>Packages (Current Chunk):</strong> Exceptions can be declared in package specifications (making them public) and raised/handled within package bodies or by code calling the package.</li>
        </ul>
    </li>
</ul>

<div class="postgresql-bridge">
<p><strong>Exception Handling & PostgreSQL Bridge:</strong>
    <ul>
        <li>Both systems use a <code>BEGIN...EXCEPTION...END</code> block structure.</li>
        <li>PostgreSQL's <code>SQLSTATE</code> and </code>SQLERRM</code> are analogous to Oracle's </code>SQLCODE</code> (though <code>SQLSTATE</code> is standard and also available in Oracle) and </code>SQLERRM</code> .</li>
        <li>Both allow handling predefined conditions/exceptions by name (e.g., </code>NO_DATA_FOUND</code> ).</li>
        <li>Raising user-defined exceptions is supported in both, though the syntax differs.</li>
        <li>Oracle's <code>PRAGMA EXCEPTION_INIT</code> provides a convenient way to give a PL/SQL name to any ORA-xxxxx error, which is a very Oracle-centric feature. PostgreSQL would typically involve checking <code>SQLSTATE</code> or </code>SQLERRM</code> for specific error codes/messages to achieve similar targeted handling of internal errors.</li>
    </ul>
</p>
</div>

<h3 id="chunk7Sec2Sub3">Triggers Relations</h3>
<ul>
    <li><strong>Within Triggers:</strong>
        <ul>
            <li><strong><code>:NEW</code> and <code>:OLD</code> Qualifiers:</strong> These are only meaningful and available in row-level DML triggers. They provide access to the row data being affected.</li>
            <li><strong>Conditional Predicates (<code>INSERTING</code> , <code>UPDATING</code> , <code>DELETING</code> ):</strong> Used within the trigger body to execute different logic based on the DML operation that fired the trigger. Particularly useful when a single trigger is defined for multiple DML events.</li>
            <li><strong>Trigger Timing (<code>BEFORE</code>/<code>AFTER</code> ) and Level (<code>ROW</code>/<code>STATEMENT</code> ):</strong> These define when and how often the trigger fires.</li>
        </ul>
    </li>
    <li><strong>With Previous Oracle Concepts (Chunks 1-6):</strong>
        <ul>
            <li><strong>PL/SQL Block Structure (Chunk 5):</strong> A trigger body is essentially a PL/SQL block, containing declarative, executable, and optionally, exception-handling sections.</li>
            <li><strong>SQL DML (Chunk 2):</strong> DML triggers fire in response to </code>INSERT</code> , <code>UPDATE</code> , or <code>DELETE</code> statements on a table or view.
                <p class="rhyme">When DML commands on tables descend,<br>
                Triggers awaken, their logic to send.</p>
            </li>
            <li><strong>Data Types, Variables, Conditional/Iterative Control (Chunks 1, 5):</strong> These are used within the trigger body to implement its logic.</li>
            <li><strong>Procedures & Functions (Chunk 6):</strong> Triggers can call stored procedures and functions (though with restrictions, e.g., transaction control).</li>
            <li><strong>Packages (Current Chunk):</strong> Triggers can call subprograms defined in packages. This is a common way to encapsulate complex trigger logic.</li>
            <li><strong>Exception Handling (Current Chunk):</strong> Triggers can (and should) include exception handlers to manage errors that occur during their execution.</li>
        </ul>
    </li>
</ul>

<div class="postgresql-bridge">
<p><strong>Triggers & PostgreSQL Bridge:</strong>
    <ul>
        <li>The core concept of automating actions based on DML events is shared.</li>
        <li>PostgreSQL's <code>NEW</code> and <code>OLD</code> record variables in trigger functions are direct analogs to Oracle's <code>:NEW</code> and <code>:OLD</code> pseudorecords.</li>
        <li>PostgreSQL's <code>TG_OP</code> variable (containing 'INSERT', 'UPDATE', 'DELETE', or 'TRUNCATE') in a trigger function serves a similar purpose to Oracle's <code>INSERTING</code> , <code>UPDATING</code> , <code>DELETING</code> conditional predicates.</li>
        <li>The primary structural difference is that Oracle trigger logic is usually inline within the <code>CREATE TRIGGER</code> statement, whereas PostgreSQL triggers execute a separate pre-defined trigger function.</li>
        <li>Both systems support <code>BEFORE</code>/<code>AFTER</code> and <code>ROW</code>/<code>STATEMENT</code> level triggers.</li>
    </ul>
</p>
</div>

<h2 id="chunk7Sec3">Section 3: How to Use Them: Structures & Syntax (in Oracle)</h2>

<h3 id="chunk7Sec3Sub1">Packages: Structures & Syntax</h3>
<p>Packages are foundational for organizing PL/SQL code.<sup id="fnref1_10"><a href="#fn1_10">10</a></sup></p>

<h4>Package Specification (<strong><code>CREATE PACKAGE</code></strong>)</h4>
Defines the public interface. What's on the menu, plain to see, for other modules, and for thee.</p>

```sql
CREATE OR REPLACE PACKAGE packageName [AUTHID DEFINER | CURRENT_USER] AS
  -- Public type declarations
  TYPE publicRecordType IS RECORD (col1 NUMBER, col2 VARCHAR2(50));
  TYPE publicTableType IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;

  -- Public variable/constant declarations
  gPublicVariable NUMBER := 10;
  gcPublicConstant CONSTANT VARCHAR2(30) := 'DefaultValue';

  -- Public exception declarations
  eCustomException EXCEPTION;

  -- Public cursor declarations (specification only)
  CURSOR cPublicCursor (pDepartmentId IN Departments.departmentId%TYPE) RETURN Employees%ROWTYPE;

  -- Public subprogram (procedure/function) declarations (headers only)
  PROCEDURE PublicProcedure (pParam1 IN VARCHAR2, pParam2 OUT NUMBER);
  FUNCTION PublicFunction (pParam1 IN NUMBER) RETURN BOOLEAN;

  -- Overloaded subprogram declarations
  PROCEDURE ProcessData (pData IN NUMBER);
  PROCEDURE ProcessData (pData IN VARCHAR2);

END packageName;
/
```
<div class="oracle-specific">
<p><strong>Oracle Specific Notes for Package Specification:</strong>
    <ul>
        <li><code>AUTHID DEFINER</code> | <code>CURRENT_USER</code>: Specifies whether the package runs with the privileges of its definer (default) or the invoker. (Covered in Chunk 9).</li>
        <li><code>ACCESSIBLE BY</code> (plsql_unit [, plsql_unit ] ...): (Oracle 12c+) Restricts which other PL/SQL units can access this package.</li>
        <li>Type declarations like <code>TABLE OF ... INDEX BY PLS_INTEGER</code> define associative arrays.</li>
        <li>Cursor declarations in the spec only show the <code>RETURN</code> type, not the <code>SELECT</code>statement.</li>
    </ul>
</p>
</div>

<h4>Package Body (<strong><code>CREATE PACKAGE BODY</code></strong>)</h4>
Contains the implementation of subprograms and cursors declared in the specification, plus any private declarations. The kitchen's secrets, kept from view, where all the complex logic's true.</p>

```sql
CREATE OR REPLACE PACKAGE BODY packageName AS
  -- Private variable/constant declarations (only accessible within this body)
  gPrivateVariable NUMBER := 0;
  gcPrivateConstant CONSTANT NUMBER := 3.14159;

  -- Private type declarations
  TYPE privateHelperRecord IS RECORD (tempData VARCHAR2(10));

  -- Private subprogram declarations (optional, if defined later in body)
  FUNCTION PrivateHelperFunction (pInput IN NUMBER) RETURN VARCHAR2;

  -- Implementation of public cursors
  CURSOR cPublicCursor (pDepartmentId IN Departments.departmentId%TYPE) RETURN Employees%ROWTYPE IS
    SELECT * FROM Employees WHERE departmentId = pDepartmentId;

  -- Implementation of public subprograms
  PROCEDURE PublicProcedure (pParam1 IN VARCHAR2, pParam2 OUT NUMBER) IS
  BEGIN
    -- Implementation logic
    pParam2 := LENGTH(pParam1) + gPrivateVariable;
  END PublicProcedure;

  FUNCTION PublicFunction (pParam1 IN NUMBER) RETURN BOOLEAN IS
  BEGIN
    -- Implementation logic
    RETURN pParam1 > gcPrivateConstant;
  END PublicFunction;

  -- Implementation of overloaded subprograms
  PROCEDURE ProcessData (pData IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Processing NUMBER: ' || pData);
  END ProcessData;

  PROCEDURE ProcessData (pData IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Processing VARCHAR2: ' || pData);
  END ProcessData;

  -- Definition of private subprograms
  FUNCTION PrivateHelperFunction (pInput IN NUMBER) RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Private helper processed: ' || TO_CHAR(pInput);
  END PrivateHelperFunction;

BEGIN
  -- Optional: Package initialization block (runs once per session when package is first referenced)
  gPublicVariable := gPublicVariable + 5;
  DBMS_OUTPUT.PUT_LINE('Package ' || packageName || ' initialized.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error initializing package ' || packageName || ': ' || SQLERRM);
END packageName;
/
```
<div class="oracle-specific">
<p><strong>Oracle Specific Notes for Package Body:</strong>
    <ul>
        <li>The body must implement all subprograms and cursors declared in the specification.</li>
        <li>The initialization block (between <code>BEGIN</code> and <code>END packageName;</code> ) is executed only once per session when an element of the package is first accessed. Useful for setting up package state.</li>
    </ul>
</p>
</div>

<h4>Calling Packaged Elements</h4>
Use dot notation: <code>packageName.elementName</code> .</p>

```sql
-- Example usage
SET SERVEROUTPUT ON;
DECLARE
  vResult NUMBER;
  vBool BOOLEAN;
  vEmpRecord Employees%ROWTYPE;
BEGIN
  -- Call public procedure
  EmployeeUtils.PublicProcedure('Test String', vResult);
  DBMS_OUTPUT.PUT_LINE('Result from PublicProcedure: ' || vResult);

  -- Call public function
  vBool := EmployeeUtils.PublicFunction(5);
  IF vBool THEN
    DBMS_OUTPUT.PUT_LINE('PublicFunction returned TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('PublicFunction returned FALSE');
  END IF;

  -- Call overloaded procedure
  EmployeeUtils.ProcessData(123);
  EmployeeUtils.ProcessData('Hello Oracle');

  -- Use public variable
  DBMS_OUTPUT.PUT_LINE('Public variable value: ' || EmployeeUtils.gPublicVariable);

  -- Use public cursor
  OPEN EmployeeUtils.cPublicCursor(pDepartmentId => 1); -- Assuming departmentId 1 exists
  LOOP
    FETCH EmployeeUtils.cPublicCursor INTO vEmpRecord;
    EXIT WHEN EmployeeUtils.cPublicCursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Fetched employee: ' || vEmpRecord.firstName || ' ' || vEmpRecord.lastName);
  END LOOP;
  CLOSE EmployeeUtils.cPublicCursor;

EXCEPTION
  WHEN EmployeeUtils.eCustomException THEN
    DBMS_OUTPUT.PUT_LINE('Caught custom package exception.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```

<h3 id="chunk7Sec3Sub2">Exception Handling: Structures & Syntax</h3>
<p>Gracefully manage runtime errors in PL/SQL blocks.<sup id="fnref1_11"><a href="#fn1_11">11</a></sup></p>

<h4>Basic Exception Block Structure</h4>

```sql
DECLARE
  -- Declarations
  vNumber NUMBER;
  vResult NUMBER;
BEGIN
  -- Executable statements
  vNumber := 0;
  vResult := 100 / vNumber; -- This will raise ZERO_DIVIDE
  DBMS_OUTPUT.PUT_LINE('Result: ' || vResult);

EXCEPTION
  WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('Error: Division by zero occurred.');
    DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE); -- Oracle error number
    DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM); -- Oracle error message
    vResult := NULL; -- Attempt to recover or set a default

  WHEN OTHERS THEN -- Catches all other exceptions
    DBMS_OUTPUT.PUT_LINE('An unexpected error occurred.');
    DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
    RAISE; -- Re-raise the current exception to propagate it
END;
/
```
<div class="oracle-specific">
<p><strong>Oracle Specific Notes:</strong>
    <ul>
        <li></code>SQLCODE</code>: Returns the numeric Oracle error code. For user-defined exceptions, it returns +1 unless associated with an Oracle error via <code>PRAGMA EXCEPTION_INIT</code> .</li>
        <li></code>SQLERRM</code>: Returns the error message. For user-defined exceptions, it returns "User-Defined Exception" unless associated.</li>
        <li><code>WHEN OTHERS</code> THEN: A catch-all handler. It's good practice to log the error (</code>SQLCODE</code> , </code>SQLERRM</code> ) and then either <code>RAISE</code>; (to propagate) or handle it definitively.</li>
    </ul>
</p>
</div>

<h4>User-Defined Exceptions</h4>

```sql
DECLARE
  eInvalidSalary <code>EXCEPTION</code>; -- Declare the exception
  vSalary NUMBER := -100;
BEGIN
  IF vSalary < 0 THEN
    <code>RAISE</code> eInvalidSalary; -- Explicitly raise the exception
  END IF;
  DBMS_OUTPUT.PUT_LINE('Salary is valid.');
EXCEPTION
  WHEN eInvalidSalary THEN
    DBMS_OUTPUT.PUT_LINE('Error: Invalid salary amount provided.');
END;
/
```

<h4>Associating User-Defined Exception with Oracle Error (<strong><code>PRAGMA EXCEPTION_INIT</code></strong>)</h4>
This allows you to handle specific Oracle errors (that don't have a predefined PL/SQL name) with a custom, meaningful name.<sup id="fnref1_12"><a href="#fn1_12">12</a></sup></p>

```sql
DECLARE
  eDeadlockDetected <code>EXCEPTION</code>;
  <code>PRAGMA EXCEPTION_INIT</code>(eDeadlockDetected, -60); -- -60 is ORA-00060
  -- (Actual deadlock simulation is complex to demo simply here,
  -- this just shows the structure)
BEGIN
  -- Simulate some DML that *could* cause a deadlock
  -- For example, two sessions updating rows in different tables in opposite orders.
  DBMS_OUTPUT.PUT_LINE('Attempting operation that might deadlock...');
  -- In a real scenario, this block might contain DML that causes ORA-00060
  -- For now, we will just simulate raising it for demonstration
  <code>RAISE_APPLICATION_ERROR</code>(-20060, 'Simulated ORA-00060 for demo');

EXCEPTION
  WHEN eDeadlockDetected THEN -- This would catch ORA-00060
    DBMS_OUTPUT.PUT_LINE('Deadlock detected! Please try transaction again.');
  WHEN OTHERS THEN
    IF SQLCODE = -20060 THEN -- If not using PRAGMA EXCEPTION_INIT
         DBMS_OUTPUT.PUT_LINE('Deadlock detected via SQLCODE! Please try transaction again.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Another error: ' || SQLERRM);
    END IF;
END;
/
```
<div class="oracle-specific">
<p><strong>Oracle Specific Notes:</strong>
    <ul>
        <li><code>RAISE_APPLICATION_ERROR</code>(error_number, message_string): A procedure in the <code>DBMS_STANDARD</code> package (implicitly available) used to raise a user-defined error condition back to the client or calling environment. <code>error_number</code> must be between -20000 and -20999. This is often preferred for communicating application-specific errors.</li>
    </ul>
</p>
</div>

<h3 id="chunk7Sec3Sub3">Triggers: Structures & Syntax</h3>
<p>Automate actions based on database events.<sup id="fnref1_13"><a href="#fn1_13">13</a></sup></p>

<h4>DML Trigger (Row-Level, <code>AFTER INSERT</code> )</h4>
Fires after each row is inserted into the <code>Employees</code> table.</p>

```sql
CREATE OR REPLACE TRIGGER trgAfterInsertEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('New employee added: ' || :NEW.firstName || ' ' || :NEW.lastName);
  -- Example: Log to AuditLog table
  INSERT INTO AuditLog (tableName, operationType, recordId, newValue)
  VALUES ('Employees', 'INSERT', :NEW.employeeId, 
          'Name: ' || :NEW.firstName || ' ' || :NEW.lastName || ', Salary: ' || :NEW.salary);
END;
/

-- Test it:
INSERT INTO Employees (employeeId, firstName, lastName, email, salary, departmentId)
VALUES (employeeSeq.NEXTVAL, 'Test', 'User', 'test.user@example.com', 55000, 1);
COMMIT;
```
<div class="oracle-specific">
<p><strong>Oracle Specific Notes:</strong>
    <ul>
        <li><code>:NEW</code> refers to the new row values being inserted.</li>
        <li><code>FOR EACH ROW</code> makes it a row-level trigger. Without it, it's a statement-level trigger.</li>
        <li><code>AFTER INSERT</code> specifies the DML event and timing.</li>
    </ul>
</p>
</div>

<h4>DML Trigger (Row-Level, <code>BEFORE UPDATE</code> with Conditional Predicate)</h4>
Fires before a salary is updated, but only if the new salary is higher.</p>

```sql
CREATE OR REPLACE TRIGGER trgBeforeUpdateSalary
BEFORE UPDATE OF salary ON Employees
FOR EACH ROW
WHEN (NEW.salary > OLD.salary) -- Conditional Predicate
DECLARE
  vRaiseAmount NUMBER;
BEGIN
  vRaiseAmount := :NEW.salary - :OLD.salary;
  DBMS_OUTPUT.PUT_LINE('Employee ' || :OLD.employeeId || ' salary changing from ' ||
                       :OLD.salary || ' to ' || :NEW.salary || '. Raise: ' || vRaiseAmount);
  -- Example: You could modify :NEW.salary here if needed, e.g., cap the raise.
  -- :NEW.salary := LEAST(:NEW.salary, :OLD.salary * 1.10); -- Cap raise at 10%
END;
/

-- Test it:
UPDATE Employees SET salary = salary * 1.05 WHERE employeeId = 100;
UPDATE Employees SET salary = salary * 0.90 WHERE employeeId = 101; -- This won't fire the main body due to WHEN
COMMIT;
```
<div class="oracle-specific">
<p><strong>Oracle Specific Notes:</strong>
    <ul>
        <li><code>:OLD</code> refers to the row values before the update, <code>:NEW</code> to the proposed new values.</li>
        <li><code>UPDATE OF salary</code> means the trigger fires only if the <code>salary</code> column is part of the <code>UPDATE</code> statement's <code>SET</code> clause.</li>
        <li>The <code>WHEN (NEW.salary > OLD.salary)</code> clause is a SQL condition that is evaluated for each row. The trigger body only executes if this condition is true.</li>
    </ul>
</p>
</div>

<h4>DML Trigger (Statement-Level, <code>AFTER DELETE</code> with Conditional Predicates)</h4>
Fires once after a <code>DELETE</code> statement on <code>OrderItems</code> , or after an </code>INSERT</code> on <code>Orders</code> .</p>

```sql
CREATE OR REPLACE TRIGGER trgAfterOrderActivity
AFTER DELETE ON OrderItems
OR AFTER INSERT ON Orders
-- No FOR EACH ROW, so it's a STATEMENT-level trigger
DECLARE
  vOperation VARCHAR2(20);
BEGIN
  IF DELETING THEN
    vOperation := 'Deleted OrderItems';
  ELSIF INSERTING THEN
    vOperation := 'Inserted into Orders';
  END IF;

  DBMS_OUTPUT.PUT_LINE('Statement-level trigger fired: ' || vOperation);
  -- Log summary information if needed
  INSERT INTO AuditLog (tableName, operationType, recordId, newValue)
  VALUES ('Multiple', vOperation, 'N/A', 'Statement completed');
END;
/

-- Test it:
INSERT INTO Orders (orderId, customerId, status) VALUES (orderSeq.NEXTVAL, 100, 'Pending');
DELETE FROM OrderItems WHERE orderId = (SELECT MAX(orderId) FROM Orders); -- Assuming some items for a recent order
COMMIT;
```
<div class="oracle-specific">
<p><strong>Oracle Specific Notes:</strong>
    <ul>
        <li><code>DELETING</code> , <code>INSERTING</code> , <code>UPDATING</code> are boolean conditional predicates available in the trigger body to check the DML operation type.</li>
        <li>Statement-level triggers do not have access to <code>:OLD</code> or <code>:NEW</code> as they don't fire for individual rows.</li>
    </ul>
</p>
</div>

<div class="postgresql-bridge">
<p><strong>Triggers & PostgreSQL Bridge:</strong>
    <ul>
        <li>
            <strong>Syntax:</strong> The <code>CREATE TRIGGER</code> syntax is different. PostgreSQL requires a trigger function.<br>
            <br>
            <pre><code class="language-sql">-- PostgreSQL Equivalent Idea (Conceptual - actual function logic would be different)
CREATE OR REPLACE FUNCTION fn_log_employee_insert() RETURNS <code>TRIGGER</code> AS $$
BEGIN
  RAISE NOTICE 'New employee added: % %', NEW.firstName, NEW.lastName;
  <code>INSERT</code> INTO AuditLog (tableName, operationType, recordId, newValue)
  VALUES ('Employees', 'INSERT', NEW.employeeId, 
          'Name: ' || NEW.firstName || ' ' || NEW.lastName || ', Salary: ' || NEW.salary);
  <code>RETURN</code> NEW;
END;
$$ LANGUAGE plpgsql;

<code>CREATE TRIGGER</code> trg_after_insert_employee
<code>AFTER INSERT</code> ON Employees
<code>FOR EACH ROW</code> EXECUTE <code>FUNCTION</code> fn_log_employee_insert();
</code></pre>
        </li>
        <li><strong><code>:NEW</code>/<code>:OLD</code>:</strong> PostgreSQL trigger functions use <code>NEW</code> and <code>OLD</code> record variables, which are very similar to Oracle's pseudorecords.</li>
        <li><strong>Conditional Predicates:</strong> PostgreSQL uses the <code>TG_OP</code> special variable (<code>'INSERT'</code> , <code>'UPDATE'</code> , <code>'DELETE'</code> , or <code>'TRUNCATE'</code> ) inside the trigger function. The <code>WHEN</code> clause in PostgreSQL <code>CREATE TRIGGER</code> is for row-level conditions, similar to Oracle's <code>WHEN</code> clause.</li>
    </ul>
</p>
</div>

<h2 id="chunk7Sec4">Section 4: Why Use Them? (Advantages in Oracle)</h2>

<h3>Packages<sup id="fnref1_14"><a href="#fn1_14">14</a></sup>:</h3>
<ul>
    <li><strong>Modularity & Organization:</strong> Groups related PL/SQL elements, making code easier to understand, manage, and maintain. A well-named package tells a story, of logic grouped, avoiding coding gory.</li>
    <li><strong>Encapsulation & Information Hiding:</strong> The package body hides implementation details. You can change the body without affecting callers as long as the specification (public interface) remains the same. This protects your code's core, while letting interfaces explore.</li>
    <li><strong>Performance:</strong>
        <ul>
            <li>When a packaged subprogram is first called, the entire package is loaded into memory (SGA's shared pool), making subsequent calls to other subprograms in the same package faster (no disk I/O).</li>
            <li>Reduces reparsing if dependent objects change only within the package body but not the specification.</li>
        </ul>
    </li>
    <li><strong>Session State:</strong> Public variables and cursors in a package can maintain their state for the duration of a database session, allowing data to be shared across multiple calls to subprograms within that package without resorting to database tables for temporary storage. State can persist, a session's helpful tryst.</li>
    <li><strong>Overloading:</strong> Allows multiple subprograms with the same name but different parameter signatures, enhancing flexibility.</li>
    <li><strong>Easier Grant Management:</strong> Privileges can be granted on the package as a whole, rather than on individual procedures and functions.</li>
</ul>

<h3>Exception Handling<sup id="fnref1_15"><a href="#fn1_15">15</a></sup>:</h3>
<ul>
    <li><strong>Robustness:</strong> Allows programs to handle errors gracefully instead of crashing, leading to more reliable applications. When troubles rise, don't let your app capsize!</li>
    <li><strong>Clarity & Readability:</strong> Separates error-handling logic from the main program logic, making the main code cleaner and easier to follow.</li>
    <li><strong>Centralized Error Management:</strong> Common error conditions can be handled in a consistent way.</li>
    <li><strong>Specific Error Targeting:</strong> Ability to handle specific predefined or user-defined exceptions differently.</li>
    <li><strong>Diagnostic Information:</strong> </code>SQLCODE</code> and </code>SQLERRM</code> provide valuable information for logging and debugging errors.</li>
</ul>

<h3>Triggers<sup id="fnref1_16"><a href="#fn1_16">16</a></sup>:</h3>
<ul>
    <li><strong>Data Integrity & Business Rules Enforcement:</strong> Can enforce complex business rules that are difficult or impossible to implement with constraints alone. They ensure rules are followed, no matter how data's swallowed.</li>
    <li><strong>Automation:</strong> Automatically execute actions in response to database events, reducing the need for application code to perform these tasks.
        <p class="rhyme">Like clockwork precise, when data makes a move,<br>
        Triggers ignite, their purpose to prove.</p>
    </li>
    <li><strong>Auditing:</strong> Can automatically log changes to data, providing an audit trail.</li>
    <li><strong>Derived Data:</strong> Can automatically calculate and populate derived column values.</li>
    <li><strong>Centralized Logic:</strong> Logic defined in a trigger is executed regardless of which application or user performs the triggering DML, ensuring consistency.</li>
    <li><strong>Event Alerting/Publishing:</strong> Can be used to signal other applications or processes when specific database events occur (often in conjunction with Advanced Queuing).</li>
</ul>

<h2 id="chunk7Sec5">Section 5: Watch Out! (Disadvantages & Pitfalls in Oracle)</h2>

<h3>Packages:</h3></p>
<ul>
    <li><strong>State Invalidation:</strong> Recompiling a package body (even for a minor change) invalidates the package state for all current sessions using it. This can lead to <code>ORA-04068</code> errors if not handled, forcing sessions to re-initialize the package, potentially losing session-specific data stored in package variables.<sup id="fnref1_17"><a href="#fn1_17">17</a></sup> Recompile with care, or session states despair!</li>
    <li><strong>Large Package Overhead:</strong> Very large packages can consume significant memory when loaded. While generally beneficial, extremely large, infrequently used packages might be less efficient than smaller, more targeted ones.</li>
    <li><strong>Complexity:</strong> For very simple, standalone utilities, creating a full package (spec and body) might feel like overkill compared to a single standalone procedure or function (though the organizational benefits often outweigh this for anything beyond trivial cases).</li>
    <li><strong>Hidden Dependencies:</strong> If a package relies on many other database objects, changes to those objects can invalidate the package, requiring recompilation.</li>
</ul>

<h3>Exception Handling:</h3></p>
<ul>
    <li><strong>Overuse of <code>WHEN OTHERS</code>:</strong> Relying too heavily on <code>WHEN OTHERS</code> THEN <code>NULL</code>; or <code>WHEN OTHERS</code> THEN -- do nothing</code> can mask serious problems, making debugging very difficult. Errors get hidden, a coder's worst forbidden.</li>
    <li><strong>Performance Overhead:</strong> While necessary, excessive or poorly placed exception handling (e.g., an <code>EXCEPTION</code> block inside a tight loop that frequently raises and handles minor issues) can add performance overhead.</li>
    <li><strong>Transaction Control in Handlers:</strong> Improper use of <code>COMMIT</code> or <code>ROLLBACK</code> within an exception handler can lead to inconsistent data states or mask the original error's impact.</li>
    <li><strong>Loss of Original Error Stack:
</strong> Simply using <code>RAISE</code>; within an exception handler re-raises the current exception. However, if you <code>RAISE</code> some_other_exception;</code> , the original error stack might be lost unless care is taken to log it.</li>
    <li><strong>Scope of Exceptions:</strong> User-defined exceptions declared within a local block are not visible outside that block. If they propagate out, they can only be caught by a <code>WHEN OTHERS</code> handler in an outer block.</li>
</ul>

<h3>Triggers<sup id="fnref1_18"><a href="#fn1_18">18</a></sup>:</h3>
<ul>
    <li><strong>Performance Overhead:</strong> Triggers execute automatically and add overhead to DML operations. Poorly written or overly complex triggers can significantly degrade database performance. A trigger's might, can slow the darkest night.</li>
    <li><strong>Complexity and Debugging:</strong> The "invisible" execution of triggers can make application logic harder to follow and debug. Problems can be difficult to trace back to a specific trigger.</li>
    <li><strong>Cascading Triggers:</strong> One trigger can cause another trigger to fire, potentially leading to complex and hard-to-manage chains of events. Oracle has a limit on trigger cascade depth (typically 32 or 50 depending on version/settings) to prevent infinite loops.</li>
    <li><strong>Mutating Table Errors (<code>ORA-04091</code> ):</strong> A common pitfall. A row-level trigger cannot query or modify the same table that is currently being modified by the DML statement that fired the trigger. This requires careful design, often using compound triggers or temporary tables as workarounds.<sup id="fnref1_19"><a href="#fn1_19">19</a></sup>
        <p class="rhyme">The mutating table, a fearsome sight,<br>
        Locks up your trigger, with all of its might.</p>
    </li>
    <li><strong>Order of Execution:</strong> If multiple triggers of the same type (e.g., multiple <code>AFTER INSERT ROW</code> triggers) exist on a table, their order of execution is not guaranteed unless explicitly controlled using the <code>FOLLOWS</code> or <code>PRECEDES</code> clause (Oracle 11g+). Relying on a specific firing order without these clauses can lead to unpredictable behavior.</li>
    <li><strong>Difficulty in Disabling/Managing for Bulk Loads:</strong> While triggers can be disabled, doing so for large data loads and then re-enabling them requires careful management and consideration of data integrity during the disabled period. <code>SQL*Loader</code> direct path load automatically disables triggers.</li>
    <li><strong>Can Mask Application Logic:</strong> Business logic embedded deeply within triggers can make the overall application architecture less clear, as some processing happens " magically" at the database level.</li>
</ul>

</div> <!-- End of container -->

<div class="footnotes">
  <hr>
  <ol>
    <li id="fn1_1">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch11_packages.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 11: PL/SQL Packages">Oracle Database PL/SQL Language Reference, 23ai, Chapter 11: PL/SQL Packages, Section "What is a Package?" (p. 11-1)</a>. This chapter details the structure, creation, and usage of PL/SQL packages. <a href="#fnref1_1" title="Jump back to footnote 1 in the text">↩</a></p>
    </li>
    <li id="fn1_2">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch09_subprograms.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 9: PL/SQL Subprograms">Oracle Database PL/SQL Language Reference, 23ai, Chapter 9: PL/SQL Subprograms, Section "Overloaded Subprograms" (p. 9-29)</a>. Explains the rules and benefits of overloading. <a href="#fnref1_2" title="Jump back to footnote 2 in the text">↩</a></p>
    </li>
    <li id="fn1_3">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch12_error-handling.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 12: PL/SQL Error Handling">Oracle Database PL/SQL Language Reference, 23ai, Chapter 12: PL/SQL Error Handling, Section "Overview of Exception Handling" (p. 12-5)</a>. Introduces the concepts of exceptions and exception handlers. <a href="#fnref1_3" title="Jump back to footnote 3 in the text">↩</a></p>
    </li>
    <li id="fn1_4">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch12_error-handling.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 12: PL/SQL Error Handling">Oracle Database PL/SQL Language Reference, 23ai, Chapter 12: PL/SQL Error Handling, Section "Predefined Exceptions" (p. 12-11)</a>. Lists and describes Oracle's built-in exceptions. <a href="#fnref1_4" title="Jump back to footnote 4 in the text">↩</a></p>
    </li>
    <li id="fn1_5">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch12_error-handling.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 12: PL/SQL Error Handling">Oracle Database PL/SQL Language Reference, 23ai, Chapter 12: PL/SQL Error Handling, Section "User-Defined Exceptions" (p. 12-13)</a>. Explains how to declare and use custom exceptions. <a href="#fnref1_5" title="Jump back to footnote 5 in the text">↩</a></p>
    </li>
    <li id="fn1_6">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch12_error-handling.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 12: PL/SQL Error Handling">Oracle Database PL/SQL Language Reference, 23ai, Chapter 12: PL/SQL Error Handling, Section "Internally Defined Exceptions" (p. 12-9) and "EXCEPTION_INIT Pragma" (within related sections or Chapter 14)</a>. Describes associating names with ORA- errors. <a href="#fnref1_6" title="Jump back to footnote 6 in the text">↩</a></p>
    </li>
    <li id="fn1_7">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 10: PL/SQL Triggers">Oracle Database PL/SQL Language Reference, 23ai, Chapter 10: PL/SQL Triggers, Section "Overview of Triggers" (p. 10-1)</a>. Provides an introduction to database triggers. <a href="#fnref1_7" title="Jump back to footnote 7 in the text">↩</a></p>
    </li>
    <li id="fn1_8">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 10: PL/SQL Triggers">Oracle Database PL/SQL Language Reference, 23ai, Chapter 10: PL/SQL Triggers, Section "Correlation Names and Pseudorecords" (p. 10-28)</a>. Also see <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/get-started-oracle-database-development/get-started-guide_ch06_using-triggers.pdf" title="Get Started with Oracle Database Development, 23ai - Chapter 6: Using Triggers">Get Started with Oracle Database Development, 23ai, Chapter 6: Using Triggers, Section "About OLD and NEW Pseudorecords" (p. 6-3)</a>. <a href="#fnref1_8" title="Jump back to footnote 8 in the text">↩</a></p>
    </li>
    <li id="fn1_9">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 10: PL/SQL Triggers">Oracle Database PL/SQL Language Reference, 23ai, Chapter 10: PL/SQL Triggers, Section "Conditional Predicates for Detecting Triggering DML Statement" (p. 10-5)</a>. <a href="#fnref1_9" title="Jump back to footnote 9 in the text">↩</a></p>
    </li>
    <li id="fn1_10">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch11_packages.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 11: PL/SQL Packages">Oracle Database PL/SQL Language Reference, 23ai, Chapter 11: PL/SQL Packages</a>. <a href="#fnref1_10" title="Jump back to footnote 10 in the text">↩</a></p>
    </li>
    <li id="fn1_11">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch12_error-handling.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 12: PL/SQL Error Handling">Oracle Database PL/SQL Language Reference, 23ai, Chapter 12: PL/SQL Error Handling</a>. <a href="#fnref1_11" title="Jump back to footnote 11 in the text">↩</a></p>
    </li>
    <li id="fn1_12">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch14_language-elements.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 14: PL/SQL Language Elements">Oracle Database PL/SQL Language Reference, 23ai, Chapter 14: PL/SQL Language Elements, Section "EXCEPTION_INIT Pragma" (p. 14-74)</a>. <a href="#fnref1_12" title="Jump back to footnote 12 in the text">↩</a></p>
    </li>
    <li id="fn1_13">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 10: PL/SQL Triggers">Oracle Database PL/SQL Language Reference, 23ai, Chapter 10: PL/SQL Triggers</a>. Also see <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/get-started-oracle-database-development/get-started-guide_ch06_using-triggers.pdf" title="Get Started with Oracle Database Development, 23ai - Chapter 6: Using Triggers">Get Started with Oracle Database Development, 23ai, Chapter 6: Using Triggers</a> for introductory tutorials. <a href="#fnref1_13" title="Jump back to footnote 13 in the text">↩</a></p>
    </li>
    <li id="fn1_14">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch11_packages.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 11: PL/SQL Packages">Oracle Database PL/SQL Language Reference, 23ai, Chapter 11: PL/SQL Packages, Section "Reasons to Use Packages" (p. 11-2)</a>. <a href="#fnref1_14" title="Jump back to footnote 14 in the text">↩</a></p>
    </li>
    <li id="fn1_15">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch12_error-handling.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 12: PL/SQL Error Handling">Oracle Database PL/SQL Language Reference, 23ai, Chapter 12: PL/SQL Error Handling, Section "Advantages of Exception Handlers" (p. 12-7)</a>. <a href="#fnref1_15" title="Jump back to footnote 15 in the text">↩</a></p>
    </li>
    <li id="fn1_16">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 10: PL/SQL Triggers">Oracle Database PL/SQL Language Reference, 23ai, Chapter 10: PL/SQL Triggers, Section "Reasons to Use Triggers" (p. 10-2)</a>. <a href="#fnref1_16" title="Jump back to footnote 16 in the text">↩</a></p>
    </li>
     <li id="fn1_17">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch11_packages.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 11: PL/SQL Packages">Oracle Database PL/SQL Language Reference, 23ai, Chapter 11: PL/SQL Packages, Section "Package State" (p. 11-7)</a>. This section discusses ORA-04068. <a href="#fnref1_17" title="Jump back to footnote 17 in the text">↩</a></p>
    </li>
    <li id="fn1_18">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 10: PL/SQL Triggers">Oracle Database PL/SQL Language Reference, 23ai, Chapter 10: PL/SQL Triggers, Section "Trigger Restrictions" (p. 10-41) and "Trigger Design Guidelines" (p. 10-39)</a>. <a href="#fnref1_18" title="Jump back to footnote 18 in the text">↩</a></p>
    </li>
    <li id="fn1_19">
      <p><a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf" title="Oracle Database PL/SQL Language Reference, 23ai - Chapter 10: PL/SQL Triggers">Oracle Database PL/SQL Language Reference, 23ai, Chapter 10: PL/SQL Triggers, Section "Mutating-Table Restriction" (p. 10-42)</a>. <a href="#fnref1_19" title="Jump back to footnote 19 in the text">↩</a></p>
    </li>
  </ol>
</div>