<head>
    <link rel="stylesheet" href="./styles/core.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code&family=Lato:wght@400;900&family=Roboto:ital,wght@0,400;1,400&display=swap" rel="stylesheet">
</head>
<body>
<div class="main-container">
    <!-- HERO SECTION -->
    <header class="hero-section">
        <p class="experience-tip">✨ Experience Tip: Pull this repository and enjoy it with VS Code ✨</p>
        <h1>Server Programming with Oracle (DB 23ai) PL/SQL</h1>
        <p class="subtitle">A Transition Guide for PostgreSQL Users 🚀</p>
        <p>Dive deep into database development with this guide, designed to help individuals proficient in PostgreSQL and analytical SQL step smoothly into server-side programming using Oracle Database and its potent procedural partner, PL/SQL.</p>
    </header>
    <!-- INFO GRID -->
    <section class="info-grid">
        <div class="info-card">
            <h3><span class="icon">🤔</span>Who is this for?</h3>
            <ul>
                <li>Developers and analysts fluent in PostgreSQL seeking to master Oracle PL/SQL.</li>
                <li>Individuals transitioning roles where Oracle database development is key.</li>
                <li>Anyone wanting to grasp Oracle's specific SQL extensions and server-side coding prowess.</li>
            </ul>
        </div>
        <div class="info-card">
            <h3><span class="icon">📚</span>Prerequisites</h3>
            <ul>
                <li>A firm footing in SQL, especially PostgreSQL's shape and thought.</li>
                <li>Familiarity with relational database rules (tables, joins, keys, etc.).</li>
                <li>Basic programming flow (variables, loops, conditionals) is a friend.</li>
            </ul>
        </div>
    </section>
    <!-- LEARNING OBJECTIVES -->
    <section>
        <h2 class="grid-header">✅ Learning Objectives</h2>
        <div class="feature-list-container">
            <ul>
                <li>Grasp and employ Oracle's unique SQL style and data kinds.</li>
                <li>Craft capable PL/SQL code, building blocks, procedures, functions, packages, and triggers.</li>
                <li>Guide data effectively with Oracle's DML, transaction handling, and advanced queries.</li>
                <li>Work with complex data types, notably XML, residing in Oracle.</li>
                <li>Understand and use Oracle's own concepts like the DUAL table and ROWNUM.</li>
                <li>Manage exceptions gracefully and use collections in PL/SQL.</li>
                <li>Implement techniques boosting performance, like bulk operations.</li>
                <li>Walk through and utilize the Oracle Data Dictionary.</li>
                <li>Gain a solid sense of Oracle performance tuning and reading EXPLAIN PLANs.</li>
                <li>Understand the conceptual weave of Oracle with tech like Java (JDBC) and XML.</li>
            </ul>
        </div>
    </section>
    <!-- COURSE STRUCTURE -->
    <section>
        <h2 class="grid-header">🏗️ Course Structure</h2>
        <div class="accordion">
            <!-- Chunk 1-4 -->
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">01</span>Crossing the Divide</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">ORACLE SQL & BRIDGING FROM POSTGRESQL</span>
                    <p>Here, we step across, finding Oracle's SQL voice for those who know PostgreSQL best.</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Key Differences & Core Syntax</li>
                        <li>Data Types <i>(Oracle Specific)</i>: VARCHAR2, NUMBER, DATE, TIMESTAMPs</li>
                        <li>DUAL Table <i>(Oracle Specific)</i></li>
                        <li>NULL Handling: NVL, NVL2, COALESCE</li>
                        <li>Conditional Expressions: DECODE, CASE</li>
                        <li>ROWNUM Pseudo-column <i>(Oracle Specific)</i></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">02</span>Essential Functions & DML</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                     <span class="parent-category">ORACLE SQL & BRIDGING FROM POSTGRESQL</span>
                    <p>Unlock key Oracle functions and master the foundational dance of Data Manipulation Language (DML).</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Date Functions: SYSDATE, TO_DATE, ADD_MONTHS, etc.</li>
                        <li>String Functions</li>
                        <li>Set Operators: MINUS</li>
                        <li>DML & Transaction Control: INSERT, UPDATE, DELETE, COMMIT, ROLLBACK</li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">03</span>Advanced Querying</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                     <span class="parent-category">ORACLE SQL & BRIDGING FROM POSTGRESQL</span>
                    <p>Ascend to advanced querying heights, tackling complex data patterns with Oracle's unique tools. 🏔️</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Hierarchical Queries <i>(Oracle Specific - Very Important)</i>: CONNECT BY, LEVEL, PRIOR</li>
                        <li>Analytic (Window) Functions: RANK, DENSE_RANK, LAG, LEAD</li>
                        <li>MERGE statement <i>(Oracle Specific)</i></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">04</span>Conquering Complexity</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                     <span class="parent-category">ORACLE SQL & BRIDGING FROM POSTGRESQL</span>
                    <p>Face the challenge of intricate data forms like XML and JSON, vital for systems like Flexcube, exploring Oracle's modern touch.</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Large Objects: CLOB, BLOB</li>
                        <li>XMLTYPE Data Type: Storage and Querying</li>
                        <li>JSON Data Type: Native Storage and Querying</li>
                        <li><b>Oracle 23ai Features</b>: JSON Relational Duality Views ✨, JSON Binary Type 💾</li>
                    </ul>
                </div>
            </details>
            <!-- Chunk 5-9 -->
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">05</span>PL/SQL Awakening</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">PL/SQL: ORACLE'S PROCEDURAL POWERHOUSE</span>
                    <p>Awaken your inner Oracle programmer. This chunk lays the ground for PL/SQL, from block shape to basic flow, introducing a new 23ai speed boost.</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>PL/SQL Block Structure: DECLARE, BEGIN, EXCEPTION, END</li>
                        <li>Variables & Constants: %TYPE, %ROWTYPE</li>
                        <li>Control Flow: IF, CASE, LOOPs</li>
                        <li>SQL within PL/SQL</li>
                        <li><b>Oracle 23ai Feature</b>: SQL Transpiler for optimization ⏩</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/oracle-database-pl-sql-language-reference/database-pl-sql-language-reference.pdf"><strong>Oracle® Database PL/SQL Language Reference</strong></a><span class="relevance">_Relevance:_ The core guide for PL/SQL syntax, block structure, and control flow.</span></li>
                        <li><a href="books/oracle-database-23ai-new-features-guide/oracle-database-23ai-new-features-guide.pdf"><strong>Oracle Database 23ai New Features Guide</strong></a><span class="relevance">_Relevance:_ Details the new SQL Transpiler feature.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">06</span>PL/SQL Precision</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">PL/SQL: ORACLE'S PROCEDURAL POWERHOUSE</span>
                    <p>Gain precision with PL/SQL cursors for fetching data and shaping reusable code blocks with procedures and functions.</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Cursors: Implicit, Explicit, Cursor FOR loops</li>
                        <li>Stored Procedures & Functions: Syntax, Parameter Modes (IN, OUT, IN OUT)</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/oracle-database-pl-sql-language-reference/database-pl-sql-language-reference.pdf"><strong>Oracle® Database PL/SQL Language Reference</strong></a><span class="relevance">_Relevance:_ The definitive reference for cursors and subprogram definitions.</span></li>
                        <li><a href="books/database-development-guide/database-development-guide.pdf"><strong>Oracle® Database Development Guide</strong></a><span class="relevance">_Relevance:_ Provides practical context and design patterns for procedures and functions.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">07</span>PL/SQL Resilience</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">PL/SQL: ORACLE'S PROCEDURAL POWERHOUSE</span>
                    <p>Build resilience in your code! Organize with packages, handle errors surely, and automate actions with triggers.🛡️</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Packages: Specification & Body, Overloading</li>
                        <li>Exception Handling: Predefined, User-defined, SQLCODE, SQLERRM</li>
                        <li>Triggers: DML Triggers, :NEW & :OLD qualifiers</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/oracle-database-pl-sql-language-reference/database-pl-sql-language-reference.pdf"><strong>Oracle® Database PL/SQL Language Reference</strong></a><span class="relevance">_Relevance:_ The complete guide to packages, exception handling syntax, and trigger creation.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">08</span>PL/SQL Mastery</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">PL/SQL: ORACLE'S PROCEDURAL POWERHOUSE</span>
                    <p>Master powerful PL/SQL moves! Handle complex data bunches and make things fly with bulk actions and dynamic SQL, key for big systems like Flexcube. 💪</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Collections & Records: Associative Arrays, Nested Tables, Varrays</li>
                        <li>Bulk Operations for Performance: BULK COLLECT, FORALL</li>
                        <li>Dynamic SQL: EXECUTE IMMEDIATE</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/oracle-database-pl-sql-language-reference/database-pl-sql-language-reference.pdf"><strong>Oracle® Database PL/SQL Language Reference</strong></a><span class="relevance">_Relevance:_ Your primary source for advanced data structures and high-performance PL/SQL techniques.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">09</span>PL/SQL Fusion</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">PL/SQL: ORACLE'S PROCEDURAL POWERHOUSE</span>
                    <p>Experience PL/SQL fusion! Explore standard packages for common tasks and see JavaScript step in as a code buddy in Oracle 23ai. 🤝</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Built-in Packages: DBMS_LOB, DBMS_XMLGEN, UTL_FILE, DBMS_AQ</li>
                        <li><b>Oracle 23ai Feature</b>: JavaScript Stored Procedures 🌐</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/database-pl-sql-packages-and-types-reference/database-pl-sql-packages-and-types-reference.pdf"><strong>Oracle® Database PL/SQL Packages and Types Reference</strong></a><span class="relevance">_Relevance:_ The encyclopedia for all `DBMS_` and `UTL_` packages.</span></li>
                        <li><a href="books/oracle-database-javascript-developers-guide/oracle-database-javascript-developers-guide.pdf"><strong>Oracle Database JavaScript Developer's Guide</strong></a><span class="relevance">_Relevance:_ The key guide for integrating JavaScript into the Oracle database.</span></li>
                    </ul>
                </div>
            </details>
            <!-- Chunk 10-13 -->
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">10</span>The Oracle Blueprint</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">ESSENTIAL ORACLE DATABASE CONCEPTS</span>
                    <p>Get the Oracle blueprint in your mind! This chunk brings vital database ideas for a consulting path – structure, data map, and fresh 23ai touches for schema and data. 🏛️</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Data Dictionary & Metadata Views: USER_, ALL_, DBA_</li>
                        <li>Schema Objects Overview: Tables, Views, Indexes, Sequences</li>
                        <li>Concurrency Control (MVCC) & Transaction Management</li>
                        <li><b>Oracle 23ai Features</b>: Usage Domains 🎯, Annotations ✍️, Wide Tables ↔️</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/database-concepts/database-concepts.pdf"><strong>Oracle® Database Concepts</strong></a><span class="relevance">_Relevance:_ Foundational knowledge on Oracle's architecture.</span></li>
                        <li><a href="books/database-reference/database-reference.pdf"><strong>Oracle® Database Reference</strong></a><span class="relevance">_Relevance:_ The source of truth for all Data Dictionary views.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">11</span>Guardians of Oracle</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">ESSENTIAL ORACLE DATABASE CONCEPTS</span>
                    <p>Stand guardian over your data! This chunk highlights database safety rules and new Oracle 23ai security shields, crucial for keeping sensitive info and systems safe. 🔒🛡️</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li><b>Oracle 23ai Feature</b>: SQL Firewall 🔥</li>
                        <li><b>Oracle 23ai Feature</b>: Column-Level Auditing 🕵️ & Data Redaction 🎭</li>
                        <li><b>Oracle 23ai Feature</b>: Multicloud Authentication ☁️🔑</li>
                        <li><b>Oracle 23ai Feature</b>: Schema Privileges ✅</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/database-security-guide/database-security-guide.pdf"><strong>Oracle® Database Security Guide</strong></a><span class="relevance">_Relevance:_ The primary source for all security-related features.</span></li>
                        <li><a href="books/oracle-database-sql-firewall-users-guide/oracle-database-sql-firewall-users-guide.pdf"><strong>Oracle Database SQL Firewall User's Guide</strong></a><span class="relevance">_Relevance:_ A deep dive into the powerful new SQL Firewall.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">12</span>Speed Unleashed</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">ORACLE PERFORMANCE & OPTIMIZATION BASICS</span>
                    <p>Unleash speed! This chunk digs into Oracle indexing tactics and how to peek into query speed using `EXPLAIN PLAN`, vital for making database work flow fast. 🏎️💨</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Indexing in Oracle: B-Tree, Bitmap, Function-Based, Composite</li>
                        <li>Understanding Oracle’s EXPLAIN PLAN: Generating & Interpreting</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/sql-tuning-guide/sql-tuning-guide.pdf"><strong>Oracle® Database SQL Tuning Guide</strong></a><span class="relevance">_Relevance:_ The go-to guide for understanding query optimization and execution plans.</span></li>
                        <li><a href="books/database-concepts/database-concepts.pdf"><strong>Oracle® Database Concepts</strong></a><span class="relevance">_Relevance:_ Explains the fundamental concepts behind different index types.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">13</span>Performance Symphony</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">ORACLE PERFORMANCE & OPTIMIZATION BASICS</span>
                    <p>Conduct a performance symphony! This chunk explores deeper query tuning, touching on optimizer hints and managing table stats, plus new 23ai speed gains. 🎼📈</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Basic Query Tuning: SARGable predicates, join efficiency</li>
                        <li>Optimizer Hints: Awareness and cautious use</li>
                        <li>Table Statistics & DBMS_STATS</li>
                        <li><b>Oracle 23ai Features</b>: Real-Time SQL Plan Management 🚦, SQL Analysis Report 🩺</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/sql-tuning-guide/sql-tuning-guide.pdf"><strong>Oracle® Database SQL Tuning Guide</strong></a><span class="relevance">_Relevance:_ The main source for advanced tuning, hints, and statistics management.</span></li>
                        <li><a href="books/database-pl-sql-packages-and-types-reference/database-pl-sql-packages-and-types-reference.pdf"><strong>Oracle® Database PL/SQL Packages and Types Reference</strong></a><span class="relevance">_Relevance:_ Details the `DBMS_STATS` package for statistics gathering.</span></li>
                    </ul>
                </div>
            </details>
            <!-- Chunk 14-15 -->
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">14</span>Oracle Horizons</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">(CONCEPTUAL) ORACLE & INTERFACING TECHNOLOGIES</span>
                    <p>Look to Oracle's horizons! This chunk explores how Oracle links with tech like Java and XML, message systems, and new 23ai bits making connections shine brighter. ✨🔗</p>
                    <h4>Categories to be Studied:</h4>
                    <ul>
                        <li>Oracle & Java Connectivity (JDBC)</li>
                        <li>Oracle & XML Processing</li>
                        <li>Oracle Advanced Queuing (AQ) & JMS</li>
                        <li><b>Oracle 23ai Features</b>: Enhanced Connection Pooling 🏊‍♂️, Async Pipelining 📊, OpenTelemetry 🔭</li>
                    </ul>
                     <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/jdbc-developers-guide/jdbc-developers-guide.pdf"><strong>Oracle® Database JDBC Developer's Guide</strong></a><span class="relevance">_Relevance:_ Essential for understanding Java-to-Oracle connectivity.</span></li>
                        <li><a href="books/database-transactional-event-queues-and-advanced-queuing-users-guide/database-transactional-event-queues-and-advanced-queuing-users-guide.pdf"><strong>Oracle ... Advanced Queuing User's Guide</strong></a><span class="relevance">_Relevance:_ The core document for understanding Oracle's messaging system.</span></li>
                        <li><a href="books/universal-connection-pool-developers-guide/universal-connection-pool-developers-guide.pdf"><strong>Oracle® Universal Connection Pool Developer's Guide</strong></a><span class="relevance">_Relevance:_ Key for understanding modern connection pooling features.</span></li>
                    </ul>
                </div>
            </details>
            <details class="accordion-item">
                <summary class="accordion-header">
                    <span class="accordion-title"><span class="chunk-number">15</span>Future of Oracle</span>
                    <span class="accordion-icon">+</span>
                </summary>
                <div class="accordion-body">
                    <span class="parent-category">ORACLE SQL & BRIDGING FROM POSTGRESQL</span>
                    <p>Peek into Oracle's future! This chunk shines solely on the vibrant new SQL features arriving in Oracle 23ai, showing Oracle's path towards modern, sharper SQL power. ⭐🔮</p>
                    <h4>New SQL Features in 23ai to be Studied:</h4>
                    <ul>
                        <li>Boolean Data Type ✅❌</li>
                        <li>Direct Joins for UPDATE/DELETE ➡️</li>
                        <li>GROUP BY Column Alias 🔡</li>
                        <li>IF [NOT] EXISTS for DDL 🚦</li>
                        <li>SELECT without FROM Clause ✨</li>
                        <li>Table Value Constructor 🛠️</li>
                    </ul>
                    <h4>Essential Reading:</h4>
                    <ul class="book-list">
                        <li><a href="books/oracle-database-23ai-new-features-guide/oracle-database-23ai-new-features-guide.pdf"><strong>Oracle Database 23ai New Features Guide</strong></a><span class="relevance">_Relevance:_ The first and most vital source for all new SQL power in Oracle 23ai.</span></li>
                        <li><a href="books/sql-language-reference/sql-language-reference.pdf"><strong>Oracle® Database SQL Language Reference</strong></a><span class="relevance">_Relevance:_ The definitive reference where these new features will be fully documented.</span></li>
                    </ul>
                </div>
            </details>
        </div>
    </section>
    <!-- HOW TO USE -->
    <section>
        <h2 class="grid-header">👇 How to Use This Repository</h2>
        <div class="how-to-guide">
            <div class="steps-container">
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <strong>Clone the Repository 📥</strong>
                        <p>Get a local copy of all the course materials and the essential PDF library.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <strong>Follow the Chunks 🪜</strong>
                        <p>Progress sequentially through the 15 numbered directories, as concepts build on each other.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <strong>Run Setup Scripts 🗂️</strong>
                        <p>In each chunk's directory, run `dataset.sql` or `NewSchema.sql` to prepare your database environment.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <strong>Do the Exercises 💪</strong>
                        <p>Tackle the problems in `exercises.md` to solidify your understanding. Then check your work in the `solutions/` folder.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">5</div>
                    <div class="step-content">
                        <strong>Consult the Library 🏛️</strong>
                        <p>Use the included `books/` directory. It's your offline, comprehensive source for deep dives into any Oracle topic.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">6</div>
                    <div class="step-content">
                        <strong>Practice Actively 🏃‍♂️</strong>
                        <p>The key to mastery is doing. Experiment, modify, and break the code. This is how you'll truly learn.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- FOOTER -->
    <footer class="site-footer">
        <p>This course material is open for all under the MIT License. Share the knowledge!</p>
        <p>Happy Learning! 😊</p>
    </footer>
</div>
</body>