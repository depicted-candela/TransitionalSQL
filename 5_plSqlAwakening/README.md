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
      /* user-select: none; */ /* Allow text selection */
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
  sup.footnote-ref a { /* Style for the [1], [2] in text */
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
  .footnotes li a[href^="#fnref"] { /* Style for the ↩ return arrow */
      margin-left: 5px;
      font-size: 1.2em; /* Make arrow a bit bigger */
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
  /* --- Styles for Fixed Table of Contents Popup --- */
  .toc-popup-container {
      position: fixed;
      top: 20px;
      right: 20px;
      width: 280px; /* Adjust as needed */
      background-color: var(--code-background); /* Using existing dark theme color */
      border: 1px solid var(--primary-color);
      border-radius: 8px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.4);
      z-index: 1000; /* Ensure it's above other content */
      transition: all 0.3s ease-in-out;
      overflow: hidden; /* Important for the toggle effect */
  }

  .toc-toggle-checkbox {
      display: none; /* Hide the actual checkbox */
  }

  .toc-toggle-label {
      display: block;
      background-color: var(--primary-color);
      color: var(--background-color); /* Text color for label */
      padding: 10px 15px;
      cursor: pointer;
      font-family: var(--header-font);
      font-weight: bold;
      border-bottom: 1px solid var(--code-border);
      transition: background-color 0.3s ease;
  }

  .toc-toggle-label:hover {
      background-color: var(--secondary-color);
  }

  .toc-content {
      max-height: 0; /* Initially hidden */
      padding: 0 15px;
      overflow-y: auto; /* Scroll if content is too long */
      transition: max-height 0.4s ease-out, padding 0.4s ease-out;
  }

  .toc-toggle-checkbox:checked ~ .toc-content {
      max-height: 70vh; /* Adjust max expanded height as needed */
      padding: 15px; /* Padding when open */
  }

  .toc-toggle-label .toc-icon-close {
      display: none;
  }
  .toc-toggle-label .toc-icon-open {
      display: inline;
  }

  .toc-toggle-checkbox:checked ~ .toc-toggle-label .toc-icon-close {
      display: inline;
  }
  .toc-toggle-checkbox:checked ~ .toc-toggle-label .toc-icon-open {
      display: none;
  }

  .toc-content h4 {
      color: var(--accent-color);
      margin-top: 0;
      margin-bottom: 10px;
      font-size: 1.2em;
      border-bottom: 1px solid var(--secondary-color);
      padding-bottom: 5px;
  }

  .toc-content ul {
      list-style-type: none;
      padding-left: 0;
      margin-top: 0;
  }

  .toc-content ul li {
      margin-bottom: 8px;
  }

  .toc-content ul li a {
      text-decoration: none;
      color: var(--text-color); /* Using existing text color */
      font-size: 0.95em;
      transition: color 0.2s ease, padding-left 0.2s ease;
      display: block; /* Makes the whole area clickable */
      padding: 3px 0;
  }

  .toc-content ul li a:hover {
      color: var(--primary-color);
      padding-left: 5px; /* Slight indent on hover */
  }

  /* Nested ULs for sub-sections */
  .toc-content ul ul {
      padding-left: 15px; /* Indent sub-items */
      margin-top: 5px;
      margin-bottom: 5px;
  }

  .toc-content ul ul li a {
      font-size: 0.9em; /* Slightly smaller for sub-items */
      color: var(--footnote-color); /* Subtler color for sub-items */
  }

  .toc-content ul ul li a:hover {
      color: var(--secondary-color);
  }

  /* Adjustments for smaller screens */
  @media (max-width: 768px) {
    .toc-popup-container {
        width: 240px; /* Slightly smaller on mobile */
        top: 10px;
        right: 10px;
    }
    .toc-content {
        /* max-height controlled by checkbox state */
    }
    .toc-toggle-checkbox:checked ~ .toc-content {
        max-height: 60vh; /* Adjust for mobile */
    }
  }
</style>

<div id="toc-popup" class="toc-popup-container">
    <input type="checkbox" id="toc-toggle" class="toc-toggle-checkbox">
    <label for="toc-toggle" class="toc-toggle-label">
        <span class="toc-icon-open">☰ Contents</span>
        <span class="toc-icon-close">✖ Close</span>
    </label>
    <div class="toc-content">
        <h4>PL/SQL Awakening</h4>
        <ul>
            <li><a href="#section-1-what-are-they-meanings-values-in-oracle">1. Meanings & Values</a>
                <ul>
                    <li><a href="#s1-1-pl-sql-block-structure">1.1 Block Structure</a></li>
                    <li><a href="#s1-2-variables-constants">1.2 Variables & Constants</a></li>
                    <li><a href="#s1-3-conditional-control">1.3 Conditional Control</a></li>
                    <li><a href="#s1-4-iterative-control-loops">1.4 Iterative Control</a></li>
                    <li><a href="#s1-5-sql-within-pl-sql">1.5 SQL within PL/SQL</a></li>
                    <li><a href="#s1-6-dbmsoutputputline">1.6 DBMS_OUTPUT</a></li>
                    <li><a href="#s1-7-sql-transpiler-oracle-23ai-feature">1.7 SQL Transpiler (23ai)</a></li>
                </ul>
            </li>
            <li><a href="#section-2-relations-how-they-play-with-others-in-oracle">2. Relations</a></li>
            <li><a href="#section-3-how-to-use-them-structures-syntax-in-oracle">3. Structures & Syntax</a>
                 <ul>
                    <li><a href="#s3-1-pl-sql-block-structure">3.1 Block Structure</a></li>
                    <li><a href="#s3-2-variables-constants">3.2 Variables & Constants</a></li>
                    <li><a href="#s3-3-conditional-control">3.3 Conditional Control</a></li>
                    <li><a href="#s3-4-iterative-control-loops">3.4 Iterative Control</a></li>
                    <li><a href="#s3-5-sql-within-pl-sql">3.5 SQL within PL/SQL</a></li>
                    <li><a href="#s3-6-dbmsoutputputline">3.6 DBMS_OUTPUT</a></li>
                </ul>
            </li>
            <li><a href="#section-4-bridging-from-postgresql-to-oracle-sql-with-oracle-db-23ai-for-pl-sql-fundamentals">4. Bridging from PostgreSQL</a></li>
            <li><a href="#section-5-why-use-them-advantages-in-oracle">5. Advantages</a></li>
            <li><a href="#section-6-watch-out-disadvantages-pitfalls-in-oracle">6. Disadvantages & Pitfalls</a></li>
        </ul>
    </div>
</div>

<div class="container">

# PL/SQL Awakening: Foundations of Oracle Programming

Welcome, PostgreSQL voyager, to the shores of Oracle PL/SQL! This realm, while sharing a common SQL ancestry, has its own powerful spells and structures. Fear not, for your existing knowledge is a sturdy vessel. We'll navigate Oracle's procedural waters, ensuring your transition is smooth and your skills, soon super.

</div>

<div class="container">

<h2 id="section-1-what-are-they-meanings-values-in-oracle">Section 1: What Are They? (Meanings & Values in Oracle)</h2>

Let's decipher the Oracle scrolls, one fundamental concept at a time. We'll see what they mean, what they do, and how they shine, especially compared to what you knew in PostgreSQL's design.

<h3 id="s1-1-pl-sql-block-structure">1.1 PL/SQL Block Structure</h3>

The PL/SQL block is the cornerstone of Oracle's procedural logic, a well-defined home for your code, so it's never tragic. It's where you'll declare variables, write executable statements, and handle any runtime commotions (exceptions, that is!).

*   **Core Meaning:** A PL/SQL block is a unit of code that can be as simple as an anonymous block executed on the fly, or as complex as a stored procedure, function, or package. It provides structure and scope for your procedural logic.
*   **Fundamental Keywords:**
    *   `DECLARE` (Optional): This keyword signals the start of the declarative section. Here, you introduce variables, constants, cursors, user-defined types, and exceptions that are local to the block. If you have nothing to declare, this section you can mock (by omitting it).
    *   `BEGIN`: This keyword marks the start of the executable section, the main body of your block where the action happens, like a well-oiled clock. This part is mandatory.
    *   `EXCEPTION` (Optional): This keyword initiates the exception-handling section. If runtime errors occur in the `BEGIN` block, control jumps here. You can define handlers for specific errors or a general `WHEN OTHERS` for any unforeseen error. It's your safety net, so your program doesn't fret.
    *   `END;`: This mandatory keyword marks the termination of the PL/SQL block. Every `BEGIN` must have a corresponding `END;`, keeping things neat and tidy, not remotely bendy.
    *   `/` (Forward Slash): In tools like SQL*Plus or SQL Developer, the forward slash on a new line tells the tool to execute the PL/SQL block you've just defined. It's not part of PL/SQL syntax itself, but a common tool command, well defined.

*   **Typical Value/Output:** A PL/SQL block doesn't "return" a value in the same way a SQL query does. Its execution can result in:
    *   Data manipulation (DML operations like INSERT, UPDATE, DELETE).
    *   Output to a buffer (using `DBMS_OUTPUT.PUT_LINE`).
    *   Modifications to PL/SQL variables.
    *   Raising or handling exceptions.
    *   Calling other subprograms.

*   **PostgreSQL Bridge:**
    You're familiar with `DO $$ BEGIN ... END $$;` blocks in PostgreSQL for anonymous code. Oracle's structure is more explicit with `DECLARE`, `BEGIN`, `EXCEPTION`, and `END;`.<sup class="footnote-ref"><a href="#fn1" id="fnref1">1</a></sup> The concept of a block for procedural logic is similar, but Oracle's exception handling is integrated directly into this structure.

    <div class="postgresql-bridge">
    <p><strong>PostgreSQL Bridge: Anonymous Blocks</strong></p>
    <p>In PostgreSQL, you'd use a <code>DO</code> statement:
    <pre><code class="language-sql">DO $$
    DECLARE
      my_message TEXT := 'Hello from PostgreSQL!';
    BEGIN
      RAISE NOTICE '%', my_message;
    END $$;
        </code></pre>
        Oracle's equivalent anonymous block:
        <pre><code class="language-sql">
    SET SERVEROUTPUT ON;
    DECLARE
      myMessage VARCHAR2(50) := 'Hello from Oracle PL/SQL!';
    BEGIN
      DBMS_OUTPUT.PUT_LINE(myMessage);
    END;
    /
    </code></pre>
    The structure is distinct, with Oracle's being more modular and clear with its sections, you'll concur.
    </div>

<h3 id="s1-2-variables-constants">1.2 Variables & Constants</h3>

In PL/SQL, variables are named storage locations whose values can change during program execution. Constants are like variables, but their values are set at declaration and cannot be altered, which is quite the elation!

*   **Scalar Types:** These are single-value data types.<sup class="footnote-ref"><a href="#fn2" id="fnref2">2</a></sup>
    *   `NUMBER`: For numeric data, including integers and fixed/floating-point numbers. *PG equivalent: `INTEGER`, `NUMERIC`, `DECIMAL`, `REAL`, `DOUBLE PRECISION`.*
    *   `VARCHAR2(size)`: For variable-length character strings. *PG equivalent: `VARCHAR(n)`, `TEXT`.* Oracle's `VARCHAR2` is the go-to string type, it's a true hype.
    *   `DATE`: Stores both date and time components. *PG equivalent: `TIMESTAMP` (though Oracle's `DATE` has its own behaviors).*
    *   `BOOLEAN`: Stores `TRUE`, `FALSE`, or `NULL`. Oracle 23ai now supports `BOOLEAN` as a SQL data type, which PL/SQL has long embraced with ease.<sup class="footnote-ref"><a href="#fn3" id="fnref3">3</a></sup>
    *   Others include `CHAR`, `NVARCHAR2`, `CLOB`, `BLOB`, `TIMESTAMP`, etc.

*   **%TYPE Attribute:**
    *   **Core Meaning:** This attribute allows you to declare a variable with the same data type and size as a previously declared variable or a database column.<sup class="footnote-ref"><a href="#fn2" id="fnref2">2</a></sup>
    *   **Typical Value:** The variable declared using `%TYPE` will be ableto hold values compatible with the source item's type. It ensures that if the source column changes, your code won't gripe.
    *   **Syntax:** `variableName table.column%TYPE;` or `variableName anotherVariable%TYPE;`

*   **%ROWTYPE Attribute:**
    *   **Core Meaning:** This attribute allows you to declare a record variable that has the same structure (fields and data types) as a row in a specified table or view, or as a defined cursor.<sup class="footnote-ref"><a href="#fn2" id="fnref2">2</a></sup>
    *   **Typical Value:** The record variable can hold an entire row of data. Its fields are accessed using `recordName.fieldName`. A great feature, it's certainly no sin.
    *   **Syntax:** `recordVariable table%ROWTYPE;` or `recordVariable cursorName%ROWTYPE;`

*   **Constants:**
    *   **Core Meaning:** Declared with the `CONSTANT` keyword, their value cannot be changed after initialization.
    *   **Syntax:** `constantName CONSTANT datatype := value;`

*   **PostgreSQL Bridge:**
    PostgreSQL supports variable declarations in its procedural languages (like PL/pgSQL) with types matching columns (e.g., `myVar myTable.myColumn%TYPE;`) and records (e.g., `myRec myTable%ROWTYPE;`). Oracle's syntax and use of `%TYPE` and `%ROWTYPE` are almost identical, providing a familiar paradigm, no need for a totem.

<h3 id="s1-3-conditional-control">1.3 Conditional Control</h3>

Conditional control structures allow your PL/SQL code to make decisions and execute different paths based on specific conditions. It's logic's finest petition!

*   **IF-THEN-ELSIF-ELSE Statement:**<sup class="footnote-ref"><a href="#fn4" id="fnref4">4</a></sup>
    *   **Core Meaning:** Executes a sequence of statements depending on the truth value of one or more conditions.
    *   **Structure:**
        ```sql
        IF condition1 THEN
           statements1;
        ELSIF condition2 THEN
           statements2;
        ELSE
           statements_else;
        END IF;
        ```
    *   `ELSIF` and `ELSE` are optional. You can have multiple `ELSIF` clauses. When a condition is `TRUE`, its corresponding statements execute, and control skips the rest of the `IF` structure, like a well-aimed gesture.

*   **CASE Statement & CASE Expression:**<sup class="footnote-ref"><a href="#fn4" id="fnref4">4</a></sup>
    *   **Core Meaning:**
        *   **CASE Statement:** Selects a sequence of statements to execute from several alternatives, based on the value of a selector or a set of conditions. It's a control flow structure.
        *   **CASE Expression:** Evaluates to a single value based on conditions. It can be used within SQL statements or PL/SQL assignments.
    *   **Simple CASE Statement/Expression (with selector):**
        ```sql
        -- CASE Statement
        CASE selector
            WHEN value1 THEN statements1;
            WHEN value2 THEN statements2;
            ELSE statements_else;
        END CASE;

        -- CASE Expression
        variable := CASE selector
                        WHEN value1 THEN result1
                        WHEN value2 THEN result2
                        ELSE result_else
                    END;
        ```
    *   **Searched CASE Statement/Expression (with conditions):**
        ```sql
        -- Searched CASE Statement
        CASE
            WHEN condition1 THEN statements1;
            WHEN condition2 THEN statements2;
            ELSE statements_else;
        END CASE;

        -- Searched CASE Expression
        variable := CASE
                        WHEN condition1 THEN result1
                        WHEN condition2 THEN result2
                        ELSE result_else
                    END;
        ```
    *   If no `WHEN` condition is met and no `ELSE` is provided, a `CASE_NOT_FOUND` exception is raised for CASE statements. CASE expressions will return `NULL` in such a scenario, so be wary or prepare for a scare.

*   **PostgreSQL Bridge:**
    PostgreSQL's `IF ELSIF ELSE END IF` and `CASE WHEN condition THEN result ... ELSE result END` (for expressions) or `CASE WHEN condition THEN statements ... ELSE statements END CASE` (for statements in PL/pgSQL) are very similar to Oracle's. The core logic is transferable; it's the syntax that needs a gentle pair of pliers.

<h3 id="s1-4-iterative-control-loops">1.4 Iterative Control (Loops)</h3>

Loops allow you to execute a sequence of statements repeatedly. Oracle PL/SQL provides several loop structures, each with its own master feature.<sup class="footnote-ref"><a href="#fn5" id="fnref5">5</a></sup>

*   **Basic LOOP:**
    *   **Core Meaning:** A simple loop that repeats statements until an explicit `EXIT`, `EXIT WHEN`, `RETURN`, or `GOTO` transfers control outside the loop, or an exception is raised.
    *   **Structure:**
        ```sql
        [<<label_name>>]
        LOOP
           statements;
           -- Must include an EXIT condition
           IF condition THEN
              EXIT; -- or EXIT label_name;
           END IF;
           -- Or: EXIT WHEN condition;
        END LOOP [label_name];
        ```
    *   Without an exit mechanism, it's an infinite loop, a developer's grimace.

*   **WHILE LOOP:**
    *   **Core Meaning:** Repeats statements as long as a specified condition is `TRUE`. The condition is evaluated *before* each iteration.
    *   **Structure:**
        ```sql
        [<<label_name>>]
        WHILE condition LOOP
           statements;
        END LOOP [label_name];
        ```
    *   If the condition is initially `FALSE` or `NULL`, the loop body never executes, which is quite cool.

*   **FOR LOOP (Numeric Range):**
    *   **Core Meaning:** Iterates over a specified range of integers. The loop counter is implicitly declared as a `PLS_INTEGER` and is local to the loop.
    *   **Structure:**
        ```sql
        [<<label_name>>]
        FOR counter_variable IN [REVERSE] lower_bound .. upper_bound LOOP
           statements; -- counter_variable is usable here
        END LOOP [label_name];
        ```
    *   The `counter_variable` increments (or decrements if `REVERSE` is used) automatically. You cannot assign a value to it inside the loop; doing so will cause a compile-time stoop.

*   **PostgreSQL Bridge:**
    PostgreSQL's PL/pgSQL also has `LOOP ... END LOOP` (with `EXIT WHEN`), `WHILE ... LOOP ... END LOOP`, and `FOR integer_var IN [REVERSE] start .. finish [BY step] LOOP ... END LOOP`. Oracle's syntax is very similar, making this a smooth transition for your mission. A key difference: in Oracle's numeric `FOR` loop, the loop counter is *implicitly* declared.

<h3 id="s1-5-sql-within-pl-sql">1.5 SQL within PL/SQL</h3>

PL/SQL seamlessly integrates SQL statements, allowing you to manipulate and query database data directly within your procedural code. It's a marriage, quite bold!<sup class="footnote-ref"><a href="#fn6" id="fnref6">6</a></sup>

*   **Implicit `SELECT INTO`:**
    *   **Core Meaning:** Used to retrieve data from a single row of a query result into PL/SQL variables or a record.
    *   **Structure:**
        ```sql
        SELECT column1, column2, ...
        INTO variable1, variable2, ... | record_variable
        FROM table_name
        WHERE condition; -- Condition should ideally ensure only one row is returned
        ```
    *   **Important:** If the `SELECT` statement returns no rows, a `NO_DATA_FOUND` exception is raised. If it returns more than one row, a `TOO_MANY_ROWS` exception is raised. Your exception handling game must be praised.

*   **DML Operations:**
    *   **Core Meaning:** You can directly embed `INSERT`, `UPDATE`, `DELETE`, and `MERGE` (Oracle specific) statements within your PL/SQL blocks.
    *   **Values:** These statements can use PL/SQL variables as part of their `VALUES` clauses, `SET` clauses, or `WHERE` conditions.
    *   **Example (INSERT):**
        ```sql
        DECLARE
          newDeptId NUMBER := 60;
          newDeptName VARCHAR2(50) := 'Logistics';
        BEGIN
          INSERT INTO departments (departmentId, departmentName)
          VALUES (newDeptId, newDeptName);
          COMMIT; -- Or handle transaction control appropriately
        END;
        /
        ```

*   **Transaction Control:**
    *   `COMMIT`: Makes permanent any database changes made during the current transaction.
    *   `ROLLBACK`: Undoes any database changes made during the current transaction.
    *   `SAVEPOINT name`: Marks a point in a transaction to which you can later roll back.
    *   These are used just like in standard SQL, but their placement in PL/SQL controls the transactional scope of your procedural logic, a very important topic.

*   **PostgreSQL Bridge:**
    PL/pgSQL also allows direct embedding of SQL, including `SELECT INTO` (with similar `NOT FOUND` behavior if `STRICT` is used or checked via `FOUND` variable) and DML. Transaction control commands (`COMMIT`, `ROLLBACK`) are also available. The fundamental concept of mixing procedural logic with SQL is shared, no need to feel despaired.

<h3 id="s1-6-dbmsoutputputline">1.6 DBMS_OUTPUT.PUT_LINE</h3>

This is Oracle's go-to procedure for printing messages from your PL/SQL code, primarily for debugging or displaying simple informational output. It's a developer's humble abode.<sup class="footnote-ref"><a href="#fn7" id="fnref7">7</a></sup>

*   **Core Meaning:** A procedure within the Oracle-supplied `DBMS_OUTPUT` package that writes data to a buffer. Client tools like SQL*Plus or SQL Developer can then be configured to display the contents of this buffer.
*   **Syntax:** `DBMS_OUTPUT.PUT_LINE(item);`
    *   `item`: Can be a string literal, variable, or expression that evaluates to a character string, number, or date. Other types are often implicitly converted.
*   **Enabling Output:** In SQL*Plus or SQL Developer, you usually need to execute `SET SERVEROUTPUT ON [SIZE n]` before running PL/SQL blocks that use it. The `SIZE` option (e.g., `SIZE 1000000`) sets the buffer size in bytes. If the buffer is too small, messages can be lost, or an error tossed.
*   **Typical Value:** `DBMS_OUTPUT.PUT_LINE` itself doesn't return a value; its side effect is placing data into a server-side buffer.

*   **PostgreSQL Bridge:**
    The closest equivalent in PostgreSQL's PL/pgSQL is `RAISE NOTICE 'message %', variable;`. Both serve a similar purpose for outputting information during procedural execution, though Oracle's `DBMS_OUTPUT` is a package procedure while `RAISE NOTICE` is a language statement, a distinction that's not major.

    <div class="postgresql-bridge">
    <p><strong>PostgreSQL Bridge: Simple Output</strong></p>
    PostgreSQL's `RAISE NOTICE`:
    <pre><code class="plpgsql">
    DO $$
    DECLARE
      userName TEXT := 'PostgresUser';
    BEGIN
      RAISE NOTICE 'User: %', userName;
    END $$;
        </code></pre>
        Oracle's `DBMS_OUTPUT.PUT_LINE`:
        <pre><code class="language-sql">
    SET SERVEROUTPUT ON;
    DECLARE
      userName VARCHAR2(30) := 'OracleUser';
    BEGIN
      DBMS_OUTPUT.PUT_LINE('User: ' || userName);
    END;
    /
    </code></pre>
    The goal's the same, a message to proclaim!
    </div>

<h3 id="s1-7-sql-transpiler-oracle-23ai-feature">1.7 SQL Transpiler (Oracle 23ai Feature)</h3>

This is an Oracle 23ai optimizer feature that works behind the scenes, a modern database's clever means.<sup class="footnote-ref"><a href="#fn8" id="fnref8">8</a></sup>

*   **Core Meaning:** The SQL Transpiler is a component of the Oracle Database optimizer that can automatically convert PL/SQL functions (especially those that are predominantly SQL-based) into equivalent SQL expressions or subqueries *when those functions are called from SQL statements*.
*   **Typical Value/Output:** The "output" is an optimized execution plan for the SQL query that called the PL/SQL function. The end result is potentially faster query execution.
*   **Analogy:** Imagine you wrote a small recipe (PL/SQL function) for making a simple sauce. When you ask the chef (SQL engine) to make a big dish that needs this sauce, instead of the chef constantly referring back to your separate recipe card, the transpiler (a smart kitchen assistant) rewrites your sauce instructions directly into the main dish's recipe, making the whole cooking process smoother and quicker.
*   **How it relates to PL/SQL Fundamentals:** While you don't directly "use" the transpiler as a syntax element, understanding its existence encourages writing PL/SQL functions that are "transpiler-friendly." This often means functions that:
    *   Primarily encapsulate SQL logic.
    *   Have minimal complex procedural logic not easily translatable to SQL.
    *   Are deterministic (given the same inputs, always produce the same output without side effects).
    *   By writing clear, SQL-centric PL/SQL functions, you provide the transpiler a better chance to optimize, it's truly a dancer!

This is a conceptual advantage; you won't write `PRAGMA TRANSPILE_ME_FASTER`. The database does its best to make your faster code master.

</div>

<div class="container">

<h2 id="section-2-relations-how-they-play-with-others-in-oracle">Section 2: Relations: How They Play with Others (in Oracle)</h2>

PL/SQL concepts don't live in isolation; they form a fellowship, a coding nation.

*   **Block Structure as the Foundation:** The `DECLARE`, `BEGIN`, `EXCEPTION`, `END` structure is the fundamental container for *all* other PL/SQL fundamental concepts. Variables and constants are defined in `DECLARE`. Conditional and iterative controls, as well as SQL statements, reside in `BEGIN`. `DBMS_OUTPUT.PUT_LINE` is typically called from `BEGIN` (or `EXCEPTION`). This structure is your PL/SQL's main station.
*   **Variables & Constants within Controls and SQL:** Variables and constants declared are then used within `IF`, `CASE`, and `LOOP` conditions and bodies. They are also directly used in embedded SQL statements (`SELECT INTO`, `INSERT`, `UPDATE`, `DELETE`) to pass data to and from the SQL engine. It's a two-way elation.
*   **Conditional Control Guiding Iteration and SQL:** `IF` and `CASE` statements often determine whether a loop should execute, how many times, or whether a specific DML operation should occur. For example, you might loop `WHILE` a condition (checked by `IF` logic implicitly) is true. This guidance is key to its elation.
*   **Iterative Control Processing SQL Results:** Loops are essential for processing results from cursors (covered later, but `FOR` loops can iterate over implicit cursors from `SELECT` statements). A common pattern is to loop through a set of IDs and perform DML for each.
*   **SQL within PL/SQL as the Workhorse:** Most non-trivial PL/SQL blocks will interact with the database using SQL. `SELECT INTO` populates variables that are then used in conditional or iterative logic. DML statements modify data based on the PL/SQL flow.
*   **`DBMS_OUTPUT.PUT_LINE` for Visibility:** This procedure is used across all other fundamental concepts to provide insights into variable values, control flow paths taken, or results of SQL operations during development and debugging. It’s your debugging observation.

**Relation to Previous Oracle Topics (from Transitional SQL Syllabus):**

*   **Data Types (Oracle Specific):** Variables and constants in PL/SQL will use Oracle-specific data types like `VARCHAR2`, `NUMBER`, `DATE`, and the new 23ai `BOOLEAN` (when used as a SQL type). Understanding these types from the "Key Differences" section is crucial.
*   **DUAL Table:** Often used with `SELECT INTO` for assigning results of function calls or expressions to variables if a `FROM` clause is syntactically needed but no actual table is queried (e.g., `SELECT SYSDATE INTO myDate FROM DUAL;`). Oracle 23ai's `SELECT without FROM` clause reduces this need.
*   **NULL Handling (`NVL`, `NVL2`, `COALESCE`):** These functions will be used within PL/SQL expressions and embedded SQL to manage `NULL` values appropriately when assigning to variables or using them in conditions.
*   **Conditional Expressions (`DECODE`, `CASE` expression):** While PL/SQL has `CASE` *statements*, the `CASE` *expression* (and older `DECODE`) learned in "Key Differences" can be used within SQL statements embedded in PL/SQL or in PL/SQL assignments.
*   **`ROWNUM`:** Can be used in `WHERE` clauses of `SELECT INTO` statements within PL/SQL to ensure only one row is fetched, preventing `TOO_MANY_ROWS` exceptions.
*   **Oracle 23ai New SQL Features:**
    *   **Boolean Data Type:** Can be directly declared and used for PL/SQL variables.
    *   **`SELECT without FROM` Clause:** Can simplify assignments of expressions to variables (e.g., `myVar := (SELECT 1+1);` in 23ai, versus `SELECT 1+1 INTO myVar FROM DUAL;` in older versions or when multiple values are projected).

**Transitional Context (PostgreSQL Analogues):**

*   **PL/SQL Block vs. PostgreSQL `DO` block/PL/pgSQL Functions:** As mentioned, the overall concept of a procedural block is similar. PostgreSQL's PL/pgSQL functions also have `DECLARE`, `BEGIN`, `EXCEPTION`, `END`. The key is Oracle's specific keywords and the ubiquity of anonymous blocks for simple tasks.
*   **Variable Declaration:** `%TYPE` and `%ROWTYPE` are conceptually identical to their PostgreSQL counterparts, making this a very smooth transition. Oracle's scalar types like `VARCHAR2` and `NUMBER` map to PostgreSQL's `VARCHAR`/`TEXT` and `INTEGER`/`NUMERIC`.
*   **Conditional/Iterative Control:** The `IF`, `CASE`, `LOOP`, `WHILE`, `FOR` constructs have direct, syntactically very similar counterparts in PL/pgSQL. Users will feel at home here, just needing to adapt to minor Oracle syntax details (e.g., `ELSIF` vs `ELSIF`).
*   **SQL in PL/SQL:** Embedding SQL is fundamental to both. `SELECT INTO` is a shared concept. DML operations are also directly usable in both.
*   **Output:** `DBMS_OUTPUT.PUT_LINE` is Oracle's version of `RAISE NOTICE` for simple debugging output.

The SQL Transpiler, a 23ai gem, may take your PL/SQL and make it pure SQL then!

</div>

<div class="container">

<h2 id="section-3-how-to-use-them-structures-syntax-in-oracle">Section 3: How to Use Them: Structures & Syntax (in Oracle)</h2>

Now, let's get practical. How do these concepts look in actual Oracle PL/SQL code? Grab your wands (keyboards), it's time for some coding lore!

*(Ensure `SET SERVEROUTPUT ON;` is executed in your SQL client like SQL*Plus or SQL Developer to see `DBMS_OUTPUT.PUT_LINE` messages.)*

<h3 id="s3-1-pl-sql-block-structure">3.1 PL/SQL Block Structure</h3>

**Basic Anonymous Block:**
The simplest form, often used for testing or one-off scripts.

```sql
-- Basic Anonymous Block
DECLARE
  message VARCHAR2(100);
  numValue NUMBER;
BEGIN
  message := 'Oracle PL/SQL is neat!';
  numValue := 10 * 5;
  DBMS_OUTPUT.PUT_LINE(message);
  DBMS_OUTPUT.PUT_LINE('Calculated Value: ' || numValue);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
```
*   **Usage:** Standalone execution in a SQL client.
*   **PostgreSQL Bridge:** Similar to `DO $$ ... $$;` but with distinct `DECLARE`, `BEGIN`, `EXCEPTION` sections.
*   **Rhyme:** When errors arise, don't show surprise, `EXCEPTION` handles all your cries.

**Nested Blocks:**
Blocks can be nested within other blocks. Variables in an outer block are visible to inner blocks, unless an inner block redeclares them.

```sql
DECLARE
  outerVar VARCHAR2(30) := 'I am Outer';
BEGIN
  DBMS_OUTPUT.PUT_LINE('Outer Block: ' || outerVar);

  DECLARE
    innerVar VARCHAR2(30) := 'I am Inner';
    outerVar VARCHAR2(30) := 'Inner''s Outer'; -- Redeclares outerVar
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inner Block: ' || outerVar); -- Refers to inner's outerVar
    DBMS_OUTPUT.PUT_LINE('Inner Block: ' || innerVar);
    -- To access the original outerVar, you'd need to label the outer block
    -- and qualify: labelName.outerVar
  END;

  DBMS_OUTPUT.PUT_LINE('Outer Block again: ' || outerVar); -- Refers to original outerVar
END;
/
```
*   **Usage:** To control variable scope and error handling at a more granular level.
*   **Rhyme:** With blocks nested deep, secrets they keep, scopes define what variables you reap.

<h3 id="s3-2-variables-constants">3.2 Variables & Constants</h3>

**Scalar Variable Declaration and Assignment:**

```sql
DECLARE
  employeeName VARCHAR2(100);
  hireYear NUMBER(4);
  isActive BOOLEAN; -- Oracle 23ai BOOLEAN
  hourlyRate NUMBER(5,2) := 25.50; -- Initialization
BEGIN
  employeeName := 'John Doe';
  hireYear := 2023;
  isActive := TRUE;

  DBMS_OUTPUT.PUT_LINE('Employee: ' || employeeName);
  DBMS_OUTPUT.PUT_LINE('Hired: ' || hireYear || ', Active: ' || CASE WHEN isActive THEN 'Yes' ELSE 'No' END);
  DBMS_OUTPUT.PUT_LINE('Rate: ' || hourlyRate);
  
  -- Or older way for expression assignment:
  SELECT hourlyRate * 1.1 INTO hourlyRate FROM DUAL; 
  DBMS_OUTPUT.PUT_LINE('New Rate: ' || hourlyRate);
END;
/
```

**Using %TYPE:**
Ensures variable type matches a column or another variable.

```sql
DECLARE
  empLastName employees.lastName%TYPE;
  empSalary employees.salary%TYPE;
  empId NUMBER := 101;
BEGIN
  SELECT lastName, salary
  INTO empLastName, empSalary
  FROM employees
  WHERE employeeId = empId;

  DBMS_OUTPUT.PUT_LINE('Employee: ' || empLastName || ', Salary: ' || empSalary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' not found.');
END;
/
```
*   **Rhyme:** With `%TYPE` so grand, your code stays in hand, if table structures expand.

**Using %ROWTYPE:**
Creates a record variable matching a table's row structure.

```sql
DECLARE
  empRecord employees%ROWTYPE;
  empId NUMBER := 102;
BEGIN
  SELECT *
  INTO empRecord
  FROM employees
  WHERE employeeId = empId;

  DBMS_OUTPUT.PUT_LINE('Fetched: ' || empRecord.firstName || ' ' || empRecord.lastName);
  DBMS_OUTPUT.PUT_LINE('Job: ' || empRecord.jobTitle || ', Salary: ' || empRecord.salary);
  DBMS_OUTPUT.PUT_LINE('Is Active: ' || CASE WHEN empRecord.isActive THEN 'Yes' ELSE 'No' END);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || empId || ' not found.');
END;
/
```
*   **Rhyme:** `%ROWTYPE` is keen, fetching whole rows, a beautiful scene.

**Constant Declaration:**

```sql
DECLARE
  PI CONSTANT NUMBER := 3.14159;
  SITE_NAME CONSTANT VARCHAR2(50) := 'My Awesome App';
  MAX_LOGIN_ATTEMPTS CONSTANT PLS_INTEGER := 3;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Value of PI: ' || PI);
  DBMS_OUTPUT.PUT_LINE('Welcome to ' || SITE_NAME);
  -- PI := 3.14; -- This would cause a compile-time error
END;
/
```

<h3 id="s3-3-conditional-control">3.3 Conditional Control</h3>

**IF-THEN-ELSIF-ELSE Statement:**

```sql
DECLARE
  employeeSalary employees.salary%TYPE;
  performanceRating VARCHAR2(10) := 'Good'; -- Could be 'Excellent', 'Good', 'Average'
  empId NUMBER := 101;
BEGIN
  SELECT salary INTO employeeSalary FROM employees WHERE employeeId = empId;

  IF performanceRating = 'Excellent' THEN
    employeeSalary := employeeSalary * 1.10; -- 10% raise
    DBMS_OUTPUT.PUT_LINE('Excellent performance! New salary: ' || employeeSalary);
  ELSIF performanceRating = 'Good' THEN
    employeeSalary := employeeSalary * 1.05; -- 5% raise
    DBMS_OUTPUT.PUT_LINE('Good performance. New salary: ' || employeeSalary);
  ELSE
    employeeSalary := employeeSalary * 1.02; -- 2% raise
    DBMS_OUTPUT.PUT_LINE('Standard review. New salary: ' || employeeSalary);
  END IF;
END;
/
```

**CASE Statement (Selector Form):**

```sql
DECLARE
  grade CHAR(1) := 'B';
  remarks VARCHAR2(50);
BEGIN
  CASE grade
    WHEN 'A' THEN remarks := 'Outstanding!';
    WHEN 'B' THEN remarks := 'Very Good.';
    WHEN 'C' THEN remarks := 'Satisfactory.';
    WHEN 'D' THEN remarks := 'Needs Improvement.';
    ELSE remarks := 'Grade not recognized.';
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Grade ' || grade || ': ' || remarks);
END;
/
```

**CASE Statement (Searched Form):**

```sql
DECLARE
  itemPrice NUMBER := 150;
  discountRate NUMBER;
BEGIN
  CASE
    WHEN itemPrice > 200 THEN discountRate := 0.15;
    WHEN itemPrice > 100 AND itemPrice <= 200 THEN discountRate := 0.10;
    WHEN itemPrice > 50  AND itemPrice <= 100 THEN discountRate := 0.05;
    ELSE discountRate := 0;
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Item Price: ' || itemPrice || ', Discount Rate: ' || (discountRate*100) || '%');
END;
/
```

**CASE Expression:**

```sql
DECLARE
  employeeCount NUMBER;
  companySize VARCHAR2(10);
BEGIN
  SELECT COUNT(*) INTO employeeCount FROM employees;

  companySize := CASE
                   WHEN employeeCount > 1000 THEN 'Large'
                   WHEN employeeCount > 100  THEN 'Medium'
                   ELSE 'Small'
                 END;
  DBMS_OUTPUT.PUT_LINE('Number of Employees: ' || employeeCount || ', Company Size: ' || companySize);
END;
/
```
*   **Rhyme:** With `IF` or `CASE`, set your own pace, choosing the logic for each place.

<h3 id="s3-4-iterative-control-loops">3.4 Iterative Control (Loops)</h3>

**Basic LOOP with EXIT WHEN:**

```sql
DECLARE
  counter NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Basic Loop - Iteration: ' || counter);
    EXIT WHEN counter >= 3;
    counter := counter + 1;
  END LOOP;
END;
/
```

**WHILE LOOP:**

```sql
DECLARE
  counter NUMBER := 1;
  maxIterations NUMBER := 3;
BEGIN
  WHILE counter <= maxIterations LOOP
    DBMS_OUTPUT.PUT_LINE('WHILE Loop - Iteration: ' || counter);
    counter := counter + 1;
  END LOOP;
END;
/
```

**Numeric FOR LOOP:**

```sql
BEGIN
  FOR i IN 1..3 LOOP -- i is implicitly declared as PLS_INTEGER
    DBMS_OUTPUT.PUT_LINE('FOR Loop - Iteration: ' || i);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- Reverse ---');
  FOR j IN REVERSE 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE('FOR Loop (Reverse) - Iteration: ' || j);
  END LOOP;
END;
/
```
*   **Rhyme:** `FOR`, `WHILE`, or basic `LOOP` shown, make your code iterate till task is sown.

<h3 id="s3-5-sql-within-pl-sql">3.5 SQL within PL/SQL</h3>

**Implicit SELECT INTO:**

```sql
DECLARE
  empFirstName employees.firstName%TYPE;
  empLastName  employees.lastName%TYPE;
  targetEmpId  NUMBER := 101;
BEGIN
  SELECT firstName, lastName
  INTO empFirstName, empLastName
  FROM employees
  WHERE employeeId = targetEmpId;

  DBMS_OUTPUT.PUT_LINE('Employee ' || targetEmpId || ': ' || empFirstName || ' ' || empLastName);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee ' || targetEmpId || ' not found.');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Error: Query returned multiple rows for employee ' || targetEmpId);
END;
/
```

**DML Operations (INSERT, UPDATE, DELETE):**

```sql
DECLARE
  newDeptId departments.departmentId%TYPE := 99;
  newDeptName departments.departmentName%TYPE := 'Innovation';
  rowsAffected NUMBER;
BEGIN
  -- INSERT
  INSERT INTO departments (departmentId, departmentName, location)
  VALUES (newDeptId, newDeptName, 'Remote');
  rowsAffected := SQL%ROWCOUNT; -- Attribute for DML
  DBMS_OUTPUT.PUT_LINE('INSERTed ' || rowsAffected || ' row(s).');
  COMMIT;

  -- UPDATE
  UPDATE departments
  SET location = 'Global Remote'
  WHERE departmentId = newDeptId;
  rowsAffected := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('UPDATEd ' || rowsAffected || ' row(s).');
  COMMIT;

  -- DELETE
  DELETE FROM departments
  WHERE departmentId = newDeptId;
  rowsAffected := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('DELETEd ' || rowsAffected || ' row(s).');
  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Error: Department ID ' || newDeptId || ' already exists.');
    ROLLBACK;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An SQL error occurred: ' || SQLERRM);
    ROLLBACK;
END;
/
```
*   **Rhyme:** With SQL in your block, data you'll unlock, `INSERT`, `UPDATE`, around the clock!

<h3 id="s3-6-dbmsoutputputline">3.6 DBMS_OUTPUT.PUT_LINE</h3>

Used in most examples above for displaying results.

```sql
SET SERVEROUTPUT ON SIZE 1000000; -- Enable and set buffer size

DECLARE
  currentAction VARCHAR2(100) := 'Initializing Process';
  itemCount PLS_INTEGER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Starting script execution.');
  DBMS_OUTPUT.PUT_LINE('Current Action: ' || currentAction);

  FOR i IN 1..5 LOOP
    itemCount := itemCount + i;
    DBMS_OUTPUT.PUT_LINE('Loop iteration ' || i || ', itemCount is now: ' || itemCount);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Process completed. Final itemCount: ' || itemCount);
END;
/
```
*   **Practice:** Commonly used inside loops to trace execution or in exception handlers to output error details.
*   **SQL Transpiler Note:** `DBMS_OUTPUT.PUT_LINE` is a procedural call for side effects (output). It's not part of logic that the SQL Transpiler would convert into a SQL expression if this block were a function called from SQL. The transpiler focuses on the data-retrieval or data-transformation logic of the function.
*   **Rhyme:** For messages to show, or where values go, `DBMS_OUTPUT` helps you to know.

</div>

<div class="container">

<h2 id="section-4-bridging-from-postgresql-to-oracle-sql-with-oracle-db-23ai-for-pl-sql-fundamentals">Section 4: Bridging from PostgreSQL to Oracle SQL with ORACLE DB 23ai for PL/SQL Fundamentals</h2>

Your PostgreSQL experience with procedural logic (like PL/pgSQL functions or `DO` blocks) provides a strong head start. Many concepts are analogous, but Oracle PL/SQL has its own distinct flavor and a more formalized block structure for anonymous code.

<div class="postgresql-bridge">
<p><strong>PostgreSQL vs. Oracle: Procedural Block Fundamentals</strong></p>
<p>Think of Oracle PL/SQL as a more structured sibling to PostgreSQL's PL/pgSQL, especially for anonymous tasks you've known.</p>

| Feature                     | PostgreSQL (PL/pgSQL in `DO` or function) | Oracle PL/SQL (Anonymous Block)                               | Key Differences & Nuances                                                                                                                               |
| :-------------------------- | :---------------------------------------- | :------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Block Delimiters**        | `DO $$ ... $$;` or `CREATE FUNCTION ... AS $$ ... $$ LANGUAGE plpgsql;` | `DECLARE ... BEGIN ... EXCEPTION ... END; /`               | Oracle's anonymous block has optional `DECLARE` and `EXCEPTION` sections explicitly keyworded. The `/` executes the block in many clients.                 |
| **Variable Declaration**    | `var_name type;` or `var_name table.col%TYPE;` | `variableName datatype;` or `variableName table.column%TYPE;` | `%TYPE` and `%ROWTYPE` are virtually identical. Oracle uses `VARCHAR2` predominantly for strings. Native SQL `BOOLEAN` type is new in Oracle 23ai.     |
| **Assignment**              | `var_name := value;` or `var_name = value;` | `variableName := expression;`                                 | Oracle strictly uses `:=` for assignment in PL/SQL.                                                                                                     |
| **Conditional: IF**         | `IF ... THEN ... ELSIF ... THEN ... ELSE ... END IF;` | `IF ... THEN ... ELSIF ... THEN ... ELSE ... END IF;`         | Syntax is extremely similar. Oracle uses `ELSIF`.                                                                                                       |
| **Conditional: CASE Stmt**  | `CASE selector WHEN val1 THEN ... ELSE ... END CASE;` or `CASE WHEN cond1 THEN ... END CASE;` | `CASE selector WHEN value1 THEN ... ELSE ... END CASE;` or `CASE WHEN condition1 THEN ... END CASE;` | Very similar. Oracle raises `CASE_NOT_FOUND` if no `WHEN` matches and no `ELSE` in a CASE *statement*. CASE *expressions* return `NULL`.                  |
| **Loop: Basic**             | `LOOP ... EXIT WHEN ... END LOOP;`          | `LOOP ... EXIT WHEN ... END LOOP;`                            | Identical concept and similar syntax.                                                                                                                   |
| **Loop: WHILE**             | `WHILE condition LOOP ... END LOOP;`        | `WHILE condition LOOP ... END LOOP;`                          | Identical concept and similar syntax.                                                                                                                   |
| **Loop: Numeric FOR**       | `FOR i IN [REVERSE] start..end [BY step] LOOP ... END LOOP;` | `FOR i IN [REVERSE] lower_bound..upper_bound LOOP ... END LOOP;` | Loop counter `i` is implicitly declared in Oracle. No explicit `BY step` in Oracle's basic numeric `FOR` loop (step is always 1). For custom steps, other loop types are used or a more complex iterator. |
| **SQL Integration**         | `SELECT ... INTO var;` DML is direct.     | `SELECT ... INTO variable;` DML is direct.                      | Both integrate SQL seamlessly. Oracle raises `NO_DATA_FOUND` / `TOO_MANY_ROWS` for `SELECT INTO` issues which must be handled. PostgreSQL's `SELECT INTO` in PL/pgSQL has a `STRICT` option or `FOUND` variable for similar checks. |
| **Simple Output/Debug**     | `RAISE NOTICE 'Message: %', var;`         | `DBMS_OUTPUT.PUT_LINE('Message: ' || variable);`                 | `DBMS_OUTPUT` writes to a server buffer, requiring client enabling (`SET SERVEROUTPUT ON`). `RAISE NOTICE` is more directly an informational message.       |
| **Transaction Control**     | `COMMIT; ROLLBACK;` (within functions if not managed externally) | `COMMIT; ROLLBACK; SAVEPOINT name;`                           | Similar. Oracle PL/SQL gives fine-grained control within blocks.                                                                                        |

**Key Takeaways for Transitioning:**

*   **Block Structure:** Embrace Oracle's `DECLARE`, `BEGIN`, `EXCEPTION`, `END;` structure. It's more formal than PostgreSQL's `DO` blocks for anonymous execution.
*   **Assignment:** Always use `:=` in PL/SQL.
*   **`VARCHAR2` vs. `VARCHAR`/`TEXT`:** Get used to `VARCHAR2` as the standard Oracle string type.
*   **`ELSIF`:** Note the spelling for `IF` statements.
*   **`DBMS_OUTPUT`:** Remember to `SET SERVEROUTPUT ON`. It's your friend for quick checks, a reliable bond.
*   **Error Handling:** Oracle's `EXCEPTION` block is powerful and a standard part of PL/SQL structure. `NO_DATA_FOUND` and `TOO_MANY_ROWS` from `SELECT INTO` are common exceptions to handle.
*   **SQL Transpiler (23ai):** Be aware that Oracle 23ai may optimize PL/SQL functions (especially those primarily wrapping SQL) called from SQL statements by converting them into SQL. This is an internal optimization, but writing clean, SQL-centric functions can make them more amenable to it.

This structured approach, once you pen, makes Oracle's PL/SQL a powerful friend!
</div>

</div>

<div class="container">

<h2 id="section-5-why-use-them-advantages-in-oracle">Section 4: Why Use Them? (Advantages in Oracle)</h2>

Why bother with these PL/SQL fundamentals? Because they form the bedrock of server-side programming in Oracle, offering a host of advantages, making your database logic less gory.

1.  **Procedural Logic within the Database:**
    *   **Advantage:** Allows complex business rules, calculations, and data transformations to be executed directly on the database server, close to the data. This reduces network traffic compared to fetching data to an application layer, processing it, and sending it back. It's a performance story.
    *   *PostgreSQL Context:* Similar to PL/pgSQL functions, but PL/SQL is Oracle's native and deeply integrated procedural language.

2.  **Structured Code (DECLARE, BEGIN, EXCEPTION, END):**
    *   **Advantage:** Enforces a clean separation of variable declarations, executable logic, and error handling. This improves code readability, maintainability, and makes debugging less of a calamity.
    *   This clear structure makes for code that's easy to parse, and less likely to cause you a farce.

3.  **Strong Typing with `%TYPE` and `%ROWTYPE`:**
    *   **Advantage:** These attributes make your PL/SQL code adaptive to changes in table structures. If a column's data type or size changes, variables declared with `%TYPE` or records with `%ROWTYPE` automatically inherit the new definition upon recompilation. This significantly reduces maintenance and the risk of runtime type-mismatch errors. Your code stays in sync, on the brink of perfection, I think!

4.  **Robust Error Handling (EXCEPTION Block):**
    *   **Advantage:** Provides a structured way to catch and handle runtime errors gracefully. Instead of the program crashing, you can log errors, perform cleanup actions, or attempt recovery. This leads to more resilient and user-friendly applications, a delightful creation.

5.  **Modular Code with Local Scopes:**
    *   **Advantage:** Variables declared within a block are local to that block (and any nested blocks). This prevents naming conflicts and allows for modular design where sections of code operate with their own set of variables without unintentionally affecting others.

6.  **Seamless SQL Integration:**
    *   **Advantage:** SQL is a first-class citizen in PL/SQL. You can directly embed DML statements (`INSERT`, `UPDATE`, `DELETE`, `MERGE`) and `SELECT INTO` queries. PL/SQL variables can be used directly in these SQL statements as bind variables, which is efficient and secure (helps prevent SQL injection). This tight integration is quite proficient.

7.  **Performance for Iterative SQL Operations:**
    *   **Advantage:** While set-based SQL is generally preferred, sometimes iterative processing is necessary. PL/SQL loops (`FOR`, `WHILE`, basic `LOOP`) combined with SQL allow for controlled row-by-row processing when required. (Later, you'll learn about `BULK COLLECT` and `FORALL` for even better performance in such scenarios).

8.  **Conditional Logic for Complex Rules:**
    *   **Advantage:** `IF-THEN-ELSIF-ELSE` and `CASE` statements/expressions allow you to implement sophisticated business logic and decision-making directly within the database. This keeps the rules centralized and consistent, it's a real database sensation.

9.  **`DBMS_OUTPUT` for Development and Debugging:**
    *   **Advantage:** A simple and effective way to trace execution flow, inspect variable values, and display informational messages during the development and debugging phases. Though not for production UI, it's a dev's true oasis.

10. **Potential SQL Transpiler Benefits (Oracle 23ai):**
    *   **Advantage:** For PL/SQL functions that are primarily SQL-centric and called from SQL, the SQL Transpiler can automatically convert them into pure SQL expressions. This reduces context switching between PL/SQL and SQL engines, potentially leading to significant performance gains without manual code changes. It's optimization that truly amazes!

These fundamentals, when you master with grace, put powerful Oracle programming in its place!

</div>

<div class="container">

<h2 id="section-6-watch-out-disadvantages-pitfalls-in-oracle">Section 5: Watch Out! (Disadvantages & Pitfalls in Oracle)</h2>

While PL/SQL fundamentals are powerful, a few goblins and gremlins lurk in the shadows. Awareness is your best defense, so your code doesn't become dense.

1.  **Unhandled Exceptions in Blocks:**
    *   **Pitfall:** If a runtime error occurs in the `BEGIN` section of a PL/SQL block, and there's no corresponding handler in the `EXCEPTION` section (or no `EXCEPTION` section at all), the error propagates outwards. If unhandled at the top level, it halts execution and returns an error to the client.
    *   **Rhyme:** An error unkempt, your program's attempt, will abruptly be tempt...ed to stop.

2.  **`NO_DATA_FOUND` and `TOO_MANY_ROWS` with `SELECT INTO`:**
    *   **Pitfall:** Using `SELECT INTO` without ensuring the query returns *exactly one row* is a classic trap.
        *   If zero rows are returned, `NO_DATA_FOUND` (ORA-01403) is raised.
        *   If more than one row is returned, `TOO_MANY_ROWS` (ORA-01422) is raised.
    *   **Recommendation:** Always include exception handlers for these when using `SELECT INTO`, or design queries to guarantee a single row (e.g., using primary keys or aggregate functions like `COUNT(*)`).
    *   **Rhyme:** `SELECT INTO` needs one row, it's true, else exceptions are coming for you!

3.  **Overuse or Misuse of `DBMS_OUTPUT.PUT_LINE`:**
    *   **Pitfall:** While great for debugging, `DBMS_OUTPUT.PUT_LINE` should not be used for application logic that returns data to a client application or for building UIs. It writes to a server-side buffer, and client tools need to be configured to fetch and display it. It also adds overhead.
    *   **Performance:** Excessive `DBMS_OUTPUT` calls, especially in loops, can significantly slow down execution.
    *   **Rhyme:** For debug, it's a star, but for app data, it won't get you far.

4.  **Infinite Loops:**
    *   **Pitfall:** Especially with basic `LOOP` structures, forgetting to include a reliable `EXIT` condition or failing to modify the loop control variable correctly within a `WHILE` or basic `LOOP` can lead to infinite loops. This consumes server resources and may require manual intervention.
    *   **Rhyme:** A loop without end, your CPU it will bend, a DBA's patience, it will transcend.

5.  **Scope and Naming Conflicts:**
    *   **Pitfall:** Redeclaring a variable in a nested block with the same name as one in an outer block hides the outer variable. If you intend to use the outer variable, you must qualify it with the outer block's label (if it has one). This can lead to subtle bugs if not managed.
    *   **Rhyme:** Same name in a nested art, can tear your logic far apart.

6.  **`%TYPE` and `%ROWTYPE` Brittleness with Dropped Columns:**
    *   **Pitfall:** While `%TYPE` and `%ROWTYPE` adapt to data type and size changes, if a column that your PL/SQL code *explicitly references by name* (e.g., `myRecord.droppedColumn`) is dropped from the underlying table, the PL/SQL unit will become invalid and fail upon recompilation/execution.
    *   **Rhyme:** `%ROWTYPE` is grand, but if columns disband, your code may not stand.

7.  **CASE Statement without ELSE and No Match:**
    *   **Pitfall:** If a `CASE` *statement* (not expression) encounters a selector value for which no `WHEN` clause matches, and no `ELSE` clause is provided, it raises the `CASE_NOT_FOUND` exception (ORA-06592).
    *   **Rhyme:** `CASE` needs a way out, or it will shout, `CASE_NOT_FOUND`, there is no doubt!

8.  **Implicit Conversions:**
    *   **Pitfall:** PL/SQL performs implicit data type conversions when possible (e.g., `VARCHAR2` to `NUMBER`). While convenient, these can sometimes lead to unexpected results or performance issues if not what was intended. Relying on them too much can make code harder to understand.
    *   **Rhyme:** Let types implicitly sway, errors might play, or performance decay.

9.  **Transaction Control Mismanagement:**
    *   **Pitfall:** Forgetting `COMMIT` means changes are not saved. Incorrect `ROLLBACK` might undo wanted work. Overly long transactions (not committing frequently enough in batch jobs) can lead to resource contention (locks, undo tablespace). This is more of a general SQL/PLSQL issue but critical in procedural blocks.
    *   **Rhyme:** `COMMIT` with a plan, or your data's a sham, `ROLLBACK` if you can't stand the jam.

10. **SQL Transpiler Assumptions (Oracle 23ai):**
    *   **Pitfall (Conceptual):** While the SQL Transpiler is an optimization, relying on it to fix fundamentally inefficient PL/SQL logic (e.g., row-by-row processing where set-based SQL is possible) is not a good strategy. Write efficient PL/SQL and SQL first; the transpiler is a bonus for applicable functions called from SQL.
    *   **Rhyme:** Transpiler's quite smart, plays a good part, but don't give it code that's falling apart.

Being mindful of these pitfalls will help you write more robust, efficient, and maintainable Oracle PL/SQL code. Good luck on your Oracle programming quest, may your code always be blessed!

</div>

<div class="footnotes">
  <hr>
  <ol>
    <li id="fn1">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 2, "Overview of PL/SQL" and Chapter 14, "Block". This details the structure including <code>DECLARE</code>, <code>BEGIN</code>, <code>EXCEPTION</code>, and <code>END</code> keywords. <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch02_overview-of-plsql.pdf" title="Jump to Oracle PL/SQL Overview">↩</a></p>
    </li>
    <li id="fn2">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 3, "PL/SQL Language Fundamentals" (for variables, constants, %TYPE) and Chapter 4, "PL/SQL Data Types". Chapter 14 also covers "Scalar Variable Declaration" and "%ROWTYPE Attribute". <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch03_language-fundamentals.pdf" title="Jump to PL/SQL Language Fundamentals">↩</a></p>
    </li>
    <li id="fn3">
      <p>Oracle Database New Features Guide, 23ai, Chapter 1, "SQL BOOLEAN Data Type". Details the introduction of the SQL standard BOOLEAN type. PL/SQL has had a BOOLEAN type for procedural logic prior to this. <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch01_changes-in-release.pdf" title="Jump to 23ai New Features in PL/SQL Reference">↩</a></p>
    </li>
    <li id="fn4">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 5, "PL/SQL Control Statements" (for IF and CASE statements) and Chapter 3 "Expressions" (for CASE expressions). Chapter 14 also details "IF Statement" and "CASE Statement". <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch05_control-statements.pdf" title="Jump to PL/SQL Control Statements">↩</a></p>
    </li>
    <li id="fn5">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 5, "PL/SQL Control Statements" (for LOOP, WHILE, FOR loops). Chapter 14 also details "Basic LOOP Statement", "WHILE LOOP Statement", and "FOR LOOP Statement". <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch05_control-statements.pdf" title="Jump to PL/SQL Control Statements for Loops">↩</a></p>
    </li>
    <li id="fn6">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 7, "PL/SQL Static SQL". This covers embedding SQL DML, SELECT INTO, and transaction control. <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch07_static-sql.pdf" title="Jump to PL/SQL Static SQL">↩</a></p>
    </li>
    <li id="fn7">
      <p>Oracle Database PL/SQL Language Reference, 23ai, Chapter 2, "Overview of PL/SQL" (Input and Output section mentions DBMS_OUTPUT). The `DBMS_OUTPUT` package itself is detailed in the "Oracle Database PL/SQL Packages and Types Reference". <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch02_overview-of-plsql.pdf" title="Jump to DBMS_OUTPUT mention in Overview">↩</a></p>
    </li>
    <li id="fn8">
      <p>Oracle Database New Features Guide, 23ai, Chapter 1, "SQL Transpiler". Also mentioned in Oracle Database PL/SQL Language Reference, 23ai, Chapter 1. <a href="https://github.com/depicted-candela/TransitionalSQL/tree/main/books/oracle-database-pl-sql-language-reference/ch01_changes-in-release.pdf" title="Jump to SQL Transpiler in PL/SQL Reference Changes">↩</a></p>
    </li>
  </ol>
</div>