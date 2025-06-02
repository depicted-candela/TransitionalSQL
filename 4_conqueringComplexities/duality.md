<style>
    :root {
        /* --- Oracle Night Mode Palette --- */
        --primary-color: #4db8ff; /* Oracle brand blue */
        --secondary-color: #6bd4ff; /* Lighter Oracle blue */
        --accent-color: #ff8c00; /* Oracle accent orange */
        --background-color: #1a1a24; /* Deep blue-black */
        --text-color: #e0e0e0; /* Soft white text */
        
        --code-background: #1e1e2e; /* Dark blue-gray */
        --code-border: #3a3a5a; /* Medium blue-gray */
        --inline-code-text: #f0f0f0; /* Bright code text */
        
        --table-border: #4a4a6a; /* Blue-gray border */
        --table-header-bg: rgba(77, 184, 255, 0.15); /* Oracle blue tint */
        --table-header-text: var(--secondary-color); /* Light blue text */
        --table-cell-bg: #252535; /* Slightly lighter than main BG */
        
        --header-font: 'Oracle Sans', 'Helvetica Neue', Arial, sans-serif;
        --body-font: 'Georgia', Times, serif;
        --code-font: 'Oracle Mono', 'Consolas', 'Monaco', 'Courier New', monospace;
        
        /* Animation variables */
        --transition-speed: 0.4s;
        --hover-scale: 1.02;
        --glow-intensity: 0.6;

        /* Additional custom properties for specific callouts if needed */
        --oracle-specific-bg: rgba(255, 140, 0, 0.1);
        --oracle-specific-border: var(--accent-color);
        --postgresql-bridge-bg: rgba(0, 193, 118, 0.1);
        --postgresql-bridge-border: #00c176;
        --caution-bg: rgba(230, 76, 0, 0.1); /* More reddish orange for caution */
        --caution-border: #e64c00; /* Darker reddish orange */
        --footnote-color: #a0a0c0;
        --box-shadow-color: rgba(0,0,0,0.3);
    }

    @keyframes slideUp {
        from { 
            opacity: 0;
            transform: translateY(30px);
        }
        to { 
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes containerGlow {
        0% { box-shadow: 0 0 5px rgba(77, 184, 255, 0); }
        50% { box-shadow: 0 0 20px rgba(77, 184, 255, var(--glow-intensity)); }
        100% { box-shadow: 0 0 5px rgba(77, 184, 255, 0); }
    }

    body {
        font-family: var(--body-font);
        color: var(--text-color);
        background-color: var(--background-color);
        line-height: 1.7;
        margin: 0;
        padding: 25px;
        background-image: 
            radial-gradient(circle at 10% 20%, #2a2a3a 0%, transparent 20%),
            radial-gradient(circle at 90% 80%, #2a2a3a 0%, transparent 20%);
        overflow-x: hidden;
        font-size: 1.2rem;
        /* user-select: none; */
    }

    .container {
        max-width: 950px;
        margin: 2rem auto;
        background-color: #252535;
        padding: 35px;
        border-radius: 8px;
        box-shadow: 0 4px 30px rgba(0, 0, 30, 0.5);
        border: 1px solid transparent;
        animation: 
            slideUp 0.8s cubic-bezier(0.22, 1, 0.36, 1) forwards,
            containerGlow 3s ease-in-out 1s infinite;
        transition: 
            transform var(--transition-speed) ease,
            box-shadow var(--transition-speed) ease,
            border-color var(--transition-speed) ease;
        opacity: 0; /* Start invisible for animation */
    }

    .container:hover {
        border: 1px solid var(--primary-color);
        box-shadow: 
            0 0 25px rgba(77, 184, 255, 0.3),
            0 4px 30px rgba(0, 0, 30, 0.6);
        transform: translateY(-5px);
    }

    /* Content animations with staggered delays */
    .container > * {
        opacity: 0;
        animation: slideUp 0.6s cubic-bezier(0.22, 1, 0.36, 1) forwards;
    }

    .container > h1 { animation-delay: 0.3s; }
    .container > h2 { animation-delay: 0.4s; }
    .container > h3 { animation-delay: 0.5s; }
    .container > p { animation-delay: 0.6s; }
    .container > pre { animation-delay: 0.7s; }
    .container > table { animation-delay: 0.8s; }
    .container > .oracle-specific { animation-delay: 0.9s; }
    .container > ul, .container > ol { animation-delay: 0.65s; }
    .container > .postgresql-bridge { animation-delay: 0.9s; }
    .container > .caution { animation-delay: 0.9s; }

    h1, h2, h3, h4 {
        font-family: var(--header-font);
        color: var(--primary-color);
        transition: color var(--transition-speed) ease;
    }

    h1 {
        border-bottom: 4px solid var(--secondary-color);
        padding-bottom: 15px;
        font-size: 2.8em;
        text-align: center;
        letter-spacing: 1px;
        text-shadow: 0 2px 4px rgba(0, 100, 200, 0.2);
    }

    h2 {
        color: var(--secondary-color);
        font-size: 2.2em;
        border-bottom: 2px solid var(--accent-color);
        margin-top: 35px;
        padding-bottom: 8px;
        transform-origin: left;
        transition: transform 0.2s ease;
    }

    h2:hover {
        transform: scaleX(1.01);
    }

    h3 {
        color: var(--accent-color);
        font-size: 1.7em;
        margin-top: 25px;
        border-left: 4px solid var(--primary-color);
        padding-left: 10px;
        transition: all var(--transition-speed) ease;
    }
    h3:hover {
        border-left-color: var(--secondary-color);
        color: var(--primary-color);
    }

    p { 
        font-size: 1.15em; 
        margin-bottom: 12px;
    }

    li { 
        margin-bottom: 10px; 
    }

    ul {
        list-style-type: none; 
        padding-left: 0;
    }

    ul > li {
        font-size: 1.15em; 
        padding-left: 25px; 
        position: relative; 
        margin-bottom: 10px; 
    }

    ul > li::before {
        content: '►'; 
        color: var(--accent-color); 
        position: absolute;
        left: 0;
        top: 1px; 
        font-size: 1em; 
        transition: transform 0.2s ease-out, color 0.2s ease-out;
    }

    ul > li:hover::before {
        color: var(--primary-color);
        transform: scale(1.2) translateX(2px);
    }

    ul ul {
        margin-top: 8px;
        margin-bottom: 8px;
        padding-left: 0; 
    }

    ul ul > li { 
        font-size: 1.0em; 
        padding-left: 25px; 
        position: relative; 
        margin-bottom: 8px; 
    }

    ul ul > li::before {
        content: '–'; 
        color: var(--secondary-color);
        font-size: 1em; 
        position: absolute;
        left: 0;
        top: 0px; 
        transition: color 0.2s ease-out, transform 0.2s ease-out;
    }

    ul ul > li:hover::before {
        color: var(--primary-color);
        transform: none; 
    }

    ul ul ul {
        margin-top: 6px;
        margin-bottom: 6px;
        padding-left: 0; 
    }

    ul ul ul > li { 
        font-size: 0.9em; 
        padding-left: 25px;
        position: relative;
        margin-bottom: 6px;
    }

    ul ul ul > li::before {
        content: '·'; 
        color: var(--footnote-color);
        font-size: 1.1em; 
        position: absolute;
        left: 1px; 
        top: 0px;
        transition: color 0.2s ease-out;
    }

    ul ul ul > li:hover::before {
        color: var(--text-color);
        transform: none;
    }

    ol > li {
        font-size: 1em; 
        margin-bottom: 10px; 
        transition: opacity 0.3s ease-out;
    }

    ol > li::marker {
        transition: color 0.2s ease-out; 
    }

    ol > li:hover::marker {
        color: transparent; 
    }

    ol ol,
    ul ol { 
        list-style-type: none;   
        padding-left: 0;         
        margin-top: 8px;         
        margin-bottom: 8px;      
        counter-reset: nested-ol-counter; 
    }

    ol ol > li,
    ul ol > li { 
        font-size: 1.0em; 
        position: relative;
        padding-left: 25px;      
        margin-bottom: 8px;      
        counter-increment: nested-ol-counter; 
    }

    ol ol > li::before,
    ul ol > li::before { 
        content: counter(nested-ol-counter) ". "; 
        color: var(--secondary-color);           
        font-weight: normal;                     
        font-size: 1em; 
        position: absolute;
        left: 0;
        top: 0px;
    }

    ol ol > li:hover::before,
    ul ol > li:hover::before { 
        color: var(--primary-color);             
    }

    ol ol ol,
    ul ol ol,
    ol ul ol,
    ul ul ol {
        list-style-type: none;
        padding-left: 0;
        margin-top: 6px;
        margin-bottom: 6px;
        counter-reset: sub-sub-ol-counter;
    }

    ul ul ul > li, 
    ul ul ol > li,
    ul ol ul > li,
    ul ol ol > li,
    ol ul ul > li,
    ol ul ol > li,
    ol ol ul > li,
    ol ol ol > li {
        font-size: 0.9em; 
        position: relative;
        padding-left: 25px;
        margin-bottom: 6px;
    }
    
    ol ol ol > li,
    ul ol ol > li,
    ol ul ol > li,
    ul ul ol > li { 
         counter-increment: sub-sub-ol-counter;
    }

    ol ol ol > li::before,
    ul ol ol > li::before,
    ol ul ol > li::before,
    ul ul ol > li::before {
        content: counter(sub-sub-ol-counter, lower-alpha) ". "; 
        color: var(--footnote-color);
        font-size: 1em; 
        position: absolute;
        left: 0px; 
        top: 0px;
        transition: color 0.2s ease-out;
    }

    ol ol ol > li:hover::before,
    ul ol ol > li:hover::before,
    ol ul ol > li:hover::before,
    ul ul ol > li:hover::before {
        color: var(--text-color);
    }

    ul ul ul > li, ol ol ol > li, ul ol ul > li, ol ul ol > li, 
    ul ul ol > li, ol ul ul > li, ul ol ol > li, ol ol ul > li {
        font-size: 0.9em;
        position: relative;
        padding-left: 25px;
        margin-bottom: 6px;
    }

    code {
        font-family: var(--code-font);
        background-color: var(--code-background);
        padding: 3px 6px;
        border-radius: 4px;
        border: 1px solid var(--code-border);
        color: var(--inline-code-text);
        font-size: 0.95em; 
        transition: all var(--transition-speed) ease;
    }

    code:hover {
        background-color: #252540;
        border-color: var(--primary-color);
    }

    pre {
        background-color: var(--code-background);
        border: 1px solid var(--code-border);
        border-left: 5px solid var(--secondary-color);
        border-radius: 5px;
        padding: 18px;
        overflow-x: auto;
        box-shadow: 2px 2px 8px var(--box-shadow-color);
        font-size: 1em; 
        transition: all var(--transition-speed) ease;
    }

    pre:hover {
        border-color: var(--primary-color);
        box-shadow: 0 0 15px rgba(77, 184, 255, 0.3); 
    }

    pre code {
        font-family: var(--code-font);
        background-color: transparent;
        border: none;
        padding: 0;
        color: inherit;
        font-size: inherit; 
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 25px;
        box-shadow: 2px 2px 8px var(--box-shadow-color);
        transition: transform var(--transition-speed) ease, box-shadow var(--transition-speed) ease;
    }

    table:hover {
        transform: scale(1.005);
        box-shadow: 0 0 15px rgba(77, 184, 255, 0.3); 
    }

    th, td {
        border: 1px solid var(--table-border);
        padding: 12px;
        text-align: left;
        transition: background-color var(--transition-speed) ease;
    }

    th {
        background-color: var(--table-header-bg);
        color: var(--table-header-text);
        font-family: var(--header-font);
        font-size: 1.1em; 
    }

    td {
        background-color: var(--table-cell-bg);
    }

    tr:hover td {
        background-color: #2e2e3e;
    }

    .oracle-specific {
        background-color: var(--oracle-specific-bg);
        border-left: 6px solid var(--oracle-specific-border);
        padding: 12px 15px;
        margin: 18px 0;
        border-radius: 4px;
        transition: all var(--transition-speed) ease, box-shadow var(--transition-speed) ease;
    }

    .oracle-specific:hover {
        transform: translateX(5px);
        box-shadow: 3px 0 10px rgba(255, 140, 0, 0.2), 0 0 15px rgba(77, 184, 255, 0.3); 
    }

    .postgresql-bridge {
        background-color: var(--postgresql-bridge-bg);
        border-left: 6px solid var(--postgresql-bridge-border);
        padding: 12px 15px;
        margin: 18px 0;
        border-radius: 4px;
        transition: all var(--transition-speed) ease;
    }

    .postgresql-bridge:hover {
        transform: translateX(5px);
        box-shadow: 3px 0 10px rgba(0, 193, 118, 0.2);
    }

    .caution {
        background-color: var(--caution-bg);
        border-left: 6px solid var(--caution-border);
        padding: 12px 15px;
        margin: 18px 0;
        border-radius: 4px;
        transition: all var(--transition-speed) ease;
    }

    .caution:hover {
        transform: translateX(5px);
        box-shadow: 3px 0 10px rgba(230, 76, 0, 0.2); 
    }

    .rhyme {
        font-style: italic;
        color: var(--primary-color);
        margin-left: 25px;
        padding: 5px 0;
        border-left: 3px dotted var(--accent-color);
        padding-left: 10px;
        transition: all var(--transition-speed) ease;
    }

    .rhyme:hover {
        color: var(--secondary-color);
        border-left-color: var(--primary-color);
        transform: translateX(3px);
    }

    p > small {
        display: block;
        margin-top: 8px;
        font-size: 0.9em; 
        color: var(--footnote-color);
        transition: color var(--transition-speed) ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    @keyframes pulse {
        0% { box-shadow: 0 0 0 0 rgba(77, 184, 255, 0.4); }
        70% { box-shadow: 0 0 0 10px rgba(77, 184, 255, 0); }
        100% { box-shadow: 0 0 0 0 rgba(77, 184, 255, 0); }
    }
    html {
        scroll-behavior: smooth;
    }
    .sql-keyword {
        color: var(--accent-color);
        font-weight: bold;
    }
    .sql-function {
        color: var(--secondary-color);
    }
    .sql-comment {
        color: #7f7f9f;
        font-style: italic;
    }
    .footnotes {
      margin-top: 40px;
      padding-top: 20px;
      border-top: 1px solid var(--code-border);
    }
    .footnotes ol {
      padding-left: 20px;
      list-style-type: decimal;
    }
    .footnotes li {
      margin-bottom: 10px;
      color: var(--footnote-color);
      font-size: 0.9em;
    }
    .footnotes li p {
      margin: 0;
      font-size: 1em; /* Relative to li */
    }
    .footnotes a {
      color: var(--secondary-color);
      text-decoration: none;
    }
    .footnotes a:hover {
      color: var(--primary-color);
      text-decoration: underline;
    }
    sup.footnote-ref a {
        color: var(--accent-color);
        font-weight: bold;
        text-decoration: none;
        font-size: 0.8em;
        vertical-align: super;
        margin-left: 2px;
        padding: 1px 3px;
        border-radius: 3px;
        background-color: rgba(255, 140, 0, 0.1);
        transition: all 0.2s ease;
    }
    sup.footnote-ref a:hover {
        background-color: rgba(255, 140, 0, 0.3);
        color: var(--primary-color);
    }
    @media (max-width: 768px) {
        .container {
            padding: 20px;
            margin: 1rem auto;
        }
        :root {
            --glow-intensity: 0.3; 
        }
        body {
            font-size: 1.1rem; 
            padding: 15px;
        }
        h1 { font-size: 2.4em; }
        h2 { font-size: 1.9em; }
        h3 { font-size: 1.5em; }
        p { font-size: 1.05em; } 
    }
</style>


<div class="container">
<h1>Oracle JSON Relational Duality Views: A Comprehensive Summary</h1>

<p>This document summarizes key SQL concepts crucial for understanding and utilizing Oracle's JSON Relational Duality Views (JRDVs), particularly for those transitioning from PostgreSQL or learning advanced Oracle SQL. It addresses a common error and builds knowledge from fundamental syntax to complex, layered applications.</p>

<div class="caution">
    <h2>Addressing ORA-00958: Missing CHECK Keyword</h2>
    <p>The error <code>ORA-00958: missing CHECK keyword</code> typically arises from incorrect syntax in the <code>WITH ... OPTION</code> clause of a <code>CREATE VIEW</code> statement. In the context of JSON Relational Duality Views (JRDVs), the updatability annotations like <code>WITH NOINSERT NOUPDATE NODELETE</code> are applied directly to table references within the JRDV definition and <strong>do not</strong> use the <code>OPTION</code> keyword.</p>
    <p><strong>Incorrect Syntax Example (leading to ORA-00958):</strong></p>
    <pre><code class="language-sql">
<span class="sql-keyword">FROM</span> DEPARTMENTSRELATIONAL d
<span class="sql-keyword">WHERE</span> d.DEPARTMENTID = e.DEPARTMENTID
  <span class="sql-keyword">WITH</span> NOINSERT NOUPDATE NODELETE <span class="sql-keyword">OPTION</span> <span class="sql-comment">-- Incorrect use of OPTION</span>
    </code></pre>
    <p><strong>Corrected Syntax:</strong></p>
    <pre><code class="language-sql">
<span class="sql-keyword">FROM</span> DEPARTMENTSRELATIONAL d
<span class="sql-keyword">WHERE</span> d.DEPARTMENTID = e.DEPARTMENTID
  <span class="sql-keyword">WITH</span> NOINSERT NOUPDATE NODELETE <span class="sql-comment">-- Correct: annotations apply directly</span>
    </code></pre>
    <p>The standard Oracle view clause <code>WITH CHECK OPTION</code> (which ensures DML through the view adheres to its WHERE clause) is different from the JRDV-specific table-level updatability annotations.</p>
</div>

<h2>I. Essential Syntax and Core Oracle Concepts (Foundational Meanings)</h2>
<p>These are the fundamental building blocks, drawing from Oracle SQL basics and bridging concepts for PostgreSQL users.</p>

<ul>
    <li>
        <strong>Keywords & Symbols (Core Meanings):</strong>
        <ul>
            <li><code><span class="sql-keyword">CREATE VIEW</span> <view_name> <span class="sql-keyword">AS SELECT</span> ...</code>: Base DDL for views. JRDVs are a specialization.
                <ul><li><em>Value:</em> Abstraction, security, query simplification.</li></ul>
            </li>
            <li><code><span class="sql-keyword">SELECT</span></code>: Core of data retrieval.
                <ul><li><em>Value:</em> Specifies columns/expressions. JRDVs use it to define JSON structure.</li></ul>
            </li>
            <li><code><span class="sql-keyword">FROM</span> <table_name> [alias]</code>: Specifies data source(s).
                <ul><li><em>Value:</em> Data origin. JRDVs have a root table and can join others.</li></ul>
            </li>
            <li><code><span class="sql-keyword">WHERE</span> <condition></code>: Filters rows.
                <ul><li><em>Value:</em> Row selection. Used for joins in JRDV subqueries.</li></ul>
            </li>
            <li><code>||</code> (Concatenation Operator): Joins strings.
                <ul><li><em>Value:</em> Creating composite strings (e.g., for <code>fullName</code> in JRDVs).</li></ul>
            </li>
            <li><code>{ ... }</code> (in JRDV <code><span class="sql-keyword">SELECT JSON</span></code>): Denotes a JSON object constructor.
                <ul><li><em>Value:</em> Defines JSON object structure. Core to JRDV definition.</li></ul>
            </li>
            <li><code>[ ... ]</code> (in JRDV <code><span class="sql-keyword">SELECT JSON</span></code>): Denotes a JSON array constructor.
                <ul><li><em>Value:</em> Defines JSON array structure. Used for nesting multiple related records.</li></ul>
            </li>
            <li><code>'</code> (Single Quote): Delimits string literals and JSON field names within <code><span class="sql-keyword">SELECT JSON</span></code>.
                <ul><li><em>Value:</em> Literal definition. Essential for JRDV JSON syntax.</li></ul>
            </li>
            <li><code>.</code> (Dot/Period): Accesses table columns (<code>table_alias.column_name</code>) or JSON object members.
                <ul><li><em>Value:</em> Member access. Ubiquitous.</li></ul>
            </li>
            <li><code><span class="sql-comment">--</span></code> (Double Dash): Single-line comment.
                <ul><li><em>Value:</em> Code annotation.</li></ul>
            </li>
        </ul>
    </li>
    <li class="oracle-specific">
        <strong>Oracle Specific Data Types (Essential Meanings):</strong>
        <ul>
            <li><code><span class="sql-keyword">NUMBER</span></code>: For numeric data.
                <ul><li><em>Value:</em> Stores IDs, salaries. Maps to JSON numbers in JRDVs.</li></ul>
            </li>
            <li><code><span class="sql-keyword">VARCHAR2</span>(size [<span class="sql-keyword">BYTE</span> | <span class="sql-keyword">CHAR</span>])</code>: Variable-length character strings.
                <ul><li><em>Value:</em> Stores names, emails. Maps to JSON strings in JRDVs.</li></ul>
            </li>
            <li><code><span class="sql-keyword">DATE</span></code>: Stores date and time (to the second).
                <ul><li><em>Value:</em> Stores hire dates. Maps to JSON strings (typically ISO 8601) in JRDVs.</li></ul>
            </li>
            <li><code><span class="sql-keyword">JSON</span></code>: Native Oracle data type for storing JSON documents. <em>(Crucial for JRDVs)</em>
                <ul><li><em>Value:</em> Can be directly embedded into JRDV documents or used as a flex column source (e.g., your <code>EmployeeProfileJSON</code>).</li></ul>
            </li>
        </ul>
    </li>
    <li>
        <strong>Core DML & Transaction Control (Essential Meanings):</strong>
        <ul>
            <li><code><span class="sql-keyword">INSERT INTO</span> ... <span class="sql-keyword">VALUES</span> ...</code>, <code><span class="sql-keyword">UPDATE</span> ... <span class="sql-keyword">SET</span> ...</code>, <code><span class="sql-keyword">DELETE FROM</span> ...</code>: Standard data modification.
                <ul><li><em>Value:</em> JRDVs can be updatable, translating document operations into these DML statements.</li></ul>
            </li>
            <li><code><span class="sql-keyword">COMMIT</span></code>, <code><span class="sql-keyword">ROLLBACK</span></code>: Transaction control.
                <ul><li><em>Value:</em> Ensures data consistency when interacting with updatable JRDVs.</li></ul>
            </li>
        </ul>
    </li>
</ul>

<h2>II. Intermediate Layered Combinations & Concepts</h2>
<p>These concepts build upon the essentials and are directly applicable to constructing effective JRDVs.</p>

<ul>
    <li class="oracle-specific">
        <strong>JRDV Specific Keywords & Clauses (Intermediate Meanings):</strong>
        <ul>
            <li><code><span class="sql-keyword">CREATE JSON RELATIONAL DUALITY VIEW</span> <view_name> <span class="sql-keyword">AS</span></code>: The DDL for JRDVs.
                <ul><li><em>Value:</em> Defines a view offering dual relational/JSON access.</li></ul>
            </li>
            <li><code><span class="sql-keyword">SELECT JSON</span> { 'field': value, ... }</code>: Core declarative part defining the JSON document structure.
                <ul><li><em>Value:</em> Derives JSON from relational data.</li></ul>
            </li>
            <li><code><span class="sql-keyword">GENERATED USING</span> (SQL_expression | <span class="sql-keyword">PATH</span> 'json_path' | (SQL_query))</code>: Computes a JSON field value dynamically.
                <ul><li><em>Value:</em> Derives data not directly stored (e.g., <code>fullName</code>).</li></ul>
            </li>
            <li><code><span class="sql-keyword">WITH</span> <updatability_annotations></code> (e.g., <code><span class="sql-keyword">WITH UPDATE INSERT DELETE</span></code>, <code><span class="sql-keyword">WITH NOINSERT NOUPDATE NODELETE</span></code>): Applied to table references within the JRDV to control DML translation.
                <ul><li><em>Value:</em> Fine-grained control over view updatability for specific joined tables.</li></ul>
            </li>
            <li><code><span class="sql-keyword">AS FLEX COLUMN</span></code> (SQL) / <code>@flex</code> (GraphQL): Designates a <code><span class="sql-keyword">JSON</span> (<span class="sql-keyword">OBJECT</span>)</code> column to store unmapped fields from incoming documents.
                <ul><li><em>Value:</em> Adds schema flexibility for parts of the document.</li></ul>
            </li>
        </ul>
    </li>
    <li class="postgresql-bridge">
        <strong>Joins (Intermediate Meanings - Bridging from PostgreSQL):</strong>
        <ul>
            <li>Implicit Joins in JRDV Subqueries: The <code><span class="sql-keyword">WHERE</span> d.DEPARTMENTID = e.DEPARTMENTID</code> is an equi-join.
                <ul><li><em>Value:</em> Relates data from different tables to create nested JSON structures.</li></ul>
            </li>
        </ul>
    </li>
    <li class="postgresql-bridge">
        <strong>Subqueries (Intermediate Meanings - Bridging from PostgreSQL):</strong>
        <ul>
            <li>Subqueries in <code><span class="sql-keyword">SELECT</span></code> (for JRDV nested objects/arrays): The <code>(<span class="sql-keyword">SELECT JSON</span> { ... } <span class="sql-keyword">FROM</span> ...)</code> part is typically a correlated subquery.
                <ul><li><em>Value:</em> Primary mechanism for shaping complex, nested JRDV documents.</li></ul>
            </li>
        </ul>
    </li>
    <li class="oracle-specific">
        <strong>Oracle JSON Functions (Underlying Mechanics):</strong>
        <ul>
            <li>While <code><span class="sql-keyword">SELECT JSON</span> { ... }</code> is a shorthand, Oracle uses functions like <code><span class="sql-function">JSON_OBJECT</span></code>, <code><span class="sql-function">JSON_ARRAYAGG</span></code>, <code><span class="sql-function">JSON_VALUE</span></code>, <code><span class="sql-function">JSON_QUERY</span></code> internally.
                <ul><li><em>Value:</em> Understanding these helps with complex JSON tasks outside JRDVs or for debugging. JRDVs provide a declarative layer.</li></ul>
            </li>
        </ul>
    </li>
    <li class="oracle-specific">
        <strong>NULL Handling (Oracle Practice):</strong>
        <ul>
            <li><code><span class="sql-function">NVL</span>(expr1, expr2)</code>, <code><span class="sql-function">COALESCE</span>(expr1, expr2, ...)</code>: Handle NULLs gracefully.
                <ul><li><em>Value:</em> Can be used in <code><span class="sql-keyword">GENERATED USING</span></code> clauses or subqueries for default JSON values if relational columns are NULL.</li></ul>
            </li>
        </ul>
    </li>
    <li class="oracle-specific">
        <strong>Conditional Expressions (Oracle Practice):</strong>
        <ul>
            <li><code><span class="sql-keyword">CASE WHEN</span> ... <span class="sql-keyword">THEN</span> ... <span class="sql-keyword">ELSE</span> ... <span class="sql-keyword">END</span></code>, <code><span class="sql-function">DECODE</span>(...)</code>: Implement conditional logic.
                <ul><li><em>Value:</em> Useful in <code><span class="sql-keyword">GENERATED USING</span></code> to create fields based on conditions.</li></ul>
            </li>
        </ul>
    </li>
</ul>

<h2>III. Most Mixed and Useful Layered Combinations (Advanced Meanings)</h2>
<p>These combine multiple concepts for powerful outcomes with JRDVs.</p>

<ul>
    <li>
        <strong>Updatable JRDVs with Controlled Nesting and Field Generation:</strong>
        <ul>
            <li><em>Combination:</em> <code><span class="sql-keyword">CREATE JSON RELATIONAL DUALITY VIEW</span></code> + <code><span class="sql-keyword">SELECT JSON</span></code> with nested subqueries + <code><span class="sql-keyword">GENERATED USING</span></code> + table-level and subquery-level <code><span class="sql-keyword">WITH</span> <updatability_annotations></code>.
            <li><em>Meaning/Value:</em> Creates rich, structured JSON document views that are updatable, with precise control over how document operations affect underlying relational tables. Essential for modern applications needing document interfaces over relational stores. (e.g., Your <code>EmployeeDataDV</code> problem).</li>
        </ul>
    </li>
    <li>
        <strong>JRDVs with Embedded Existing JSON and Generated Content:</strong>
        <ul>
            <li><em>Combination:</em> <code><span class="sql-keyword">CREATE JSON RELATIONAL DUALITY VIEW</span></code> + <code><span class="sql-keyword">SELECT JSON</span></code> mapping a <code><span class="sql-keyword">JSON</span></code> type column directly + <code><span class="sql-keyword">GENERATED USING</span></code>.
            <li><em>Meaning/Value:</em> Seamlessly integrates pre-existing JSON structures (like <code>EmployeeProfileJSON</code>) with relational data and newly computed fields into a unified document view.</li>
        </ul>
    </li>
    <li class="oracle-specific">
        <strong>JRDVs for Exposing Hierarchical Data:</strong>
        <ul>
            <li><em>Combination:</em> <code><span class="sql-keyword">CREATE JSON RELATIONAL DUALITY VIEW</span></code> + <code><span class="sql-keyword">SELECT JSON</span></code> + subqueries potentially using Oracle's <code><span class="sql-keyword">CONNECT BY</span></code> clause for deep hierarchies.
            <li><em>Meaning/Value:</em> Presents complex relational hierarchies naturally as nested JSON. For simple parent-child, direct subquery joins suffice; for deeper trees, <code><span class="sql-keyword">CONNECT BY</span></code> within a JRDV subquery can gather related nodes.</li>
        </ul>
    </li>
    <li class="oracle-specific">
        <strong>JRDVs with Analytic Functions for Enhanced Reporting Documents:</strong>
        <ul>
            <li><em>Combination:</em> <code><span class="sql-keyword">CREATE JSON RELATIONAL DUALITY VIEW</span></code> + <code><span class="sql-keyword">SELECT JSON</span></code> + <code><span class="sql-keyword">GENERATED USING</span></code> clauses leveraging Oracle Analytic (Window) Functions (<code><span class="sql-function">RANK() OVER</span> (...)</code>, <code><span class="sql-function">SUM() OVER</span> (...)</code>) within their subqueries.
            <li><em>Meaning/Value:</em> Creates JSON documents with embedded calculated values like rankings or running totals, simplifying client-side logic for reporting.</li>
        </ul>
    </li>
    <li class="oracle-specific">
        <strong>JRDVs Incorporating Flex Columns for Dynamic Schema Extension:</strong>
        <ul>
            <li><em>Combination:</em> <code><span class="sql-keyword">CREATE JSON RELATIONAL DUALITY VIEW</span></code> + <code><span class="sql-keyword">SELECT JSON</span></code> + <code>p.json_flex_column <span class="sql-keyword">AS FLEX COLUMN</span></code>.
            <li><em>Meaning/Value:</em> Handles core structured data alongside dynamically evolving attributes. New, unmapped fields in incoming JSON are stored in the flex column, offering schema-on-write flexibility for parts of the document.</li>
        </ul>
    </li>
    <li>
        <strong>Secure, Role-Specific JRDVs:</strong>
        <ul>
            <li><em>Combination:</em> Multiple JRDVs over same base tables, each with different field selections, logic, and updatability + Oracle database privileges (<code><span class="sql-keyword">GRANT</span></code>).
            <li><em>Meaning/Value:</em> Delivers tailored and secure data access based on user roles.</li>
        </ul>
    </li>
</ul>

<h2>Advantages of JSON Relational Duality Views</h2>
<ul>
    <li><strong>Best of Both Worlds:</strong> Combines relational integrity (ACID, constraints, SQL) with document model flexibility (natural object mapping, hierarchical data).</li>
    <li><strong>Simplified Development:</strong> Easier for document-oriented applications to consume data, reducing ORM/ODM complexity.</li>
    <li><strong>Data Integrity:</strong> Relational constraints are enforced as data is stored relationally.</li>
    <li><strong>Powerful Querying:</strong> Full SQL power for analytics on underlying tables.</li>
    <li><strong>Schema Flexibility & Evolution:</strong>
        <ul>
            <li>Native <code><span class="sql-keyword">JSON</span></code> type columns allow storing schemaless or schema-validated JSON segments.</li>
            <li>Flex columns allow dynamic addition of fields to document objects without DDL changes.</li>
        </ul>
    </li>
    <li><strong>Performance:</strong> Potential for optimized query execution by Oracle.</li>
    <li><strong>Updatability & Concurrency:</strong> Can be made fully updatable, with built-in <code>etag</code> support for optimistic concurrency.</li>
</ul>

<h2>Disadvantages of JSON Relational Duality Views</h2>
<ul>
    <li><strong>Complexity for Purely Relational Use Cases:</strong> Adds an unnecessary layer if no document-style access is needed.</li>
    <li><strong>Learning Curve:</strong> Requires understanding both relational and JRDV-specific JSON mapping concepts.</li>
    <li><strong>Performance Considerations:</strong> Extreme normalization could lead to many joins for complex document construction; requires careful design and indexing.</li>
    <li><strong>View Definition Complexity:</strong> Defining highly nested JRDVs can become intricate.</li>
    <li class="oracle-specific"><strong>Oracle-Specific Feature:</strong> Not directly portable to other database systems.</li>
    <li><strong>Updatability Nuances:</strong> Developers must understand the rules and implications of updatability annotations and how they interact with underlying constraints.</li>
    <li><strong>Debugging DML:</strong> Tracing DML failures through the JRDV layer to the underlying relational cause might sometimes be less direct.</li>
</ul>

<p>JRDVs offer a powerful paradigm for modern data architectures, bridging relational reliability with document model agility. They are particularly effective for exposing existing relational data as JSON or for building new document-centric applications that benefit from a relational backbone.</p>
</div>