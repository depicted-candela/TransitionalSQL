**Chunk 7: PL/SQL Resilience: Packages, Errors, and Automation**
*   **Categories to be Studied:**
    *   Packages: Specification, body, benefits, overloading
    *   Exception Handling: Predefined exceptions, user-defined exceptions, SQLCODE, SQLERRM, PRAGMA EXCEPTION_INIT
    *   Triggers: DML triggers, :NEW and :OLD qualifiers, conditional predicates

Let's break down each category and map it to the relevant documentation:

---

**1. Packages: Specification, body, benefits, overloading**

*   **Primary Reference (for learning PL/SQL package creation and concepts):**
    *   [Oracle® Database PL/SQL Language Reference, Chapter 11: PL/SQL Packages](books/oracle-database-pl-sql-language-reference/ch11_packages.pdf)
        *   _Relevance:_ This is the primary guide for understanding what packages are, their benefits, how to create their specifications and bodies, instantiation, state, and guidelines for writing them. It also covers `SERIALLY_REUSABLE` packages.
    *   [Oracle® Database PL/SQL Language Reference, Chapter 9: PL/SQL Subprograms, section "Overloaded Subprograms"](books/oracle-database-pl-sql-language-reference/ch09_subprograms.pdf)
        *   _Relevance:_ While `Overloaded Subprograms` are discussed generally here, overloading is a key concept heavily utilized within PL/SQL packages for creating flexible APIs.

*   **Supporting Reference (for understanding Oracle-supplied packages by example):**
    *   [Oracle® Database PL/SQL Packages and Types Reference, Chapter 1: Introduction to Oracle Supplied PL/SQL Packages & Types](books/database-pl-sql-packages-and-types-reference/ch01_introduction_to_oracle_supplied_pl_sql_packages_and_types.pdf)
        *   _Relevance:_ This book demonstrates how Oracle itself utilizes packages. Chapter 1 offers a general overview of package components, how to use them, and the separation of specification and body. Studying this reinforces the concepts taught in the Language Reference through real-world examples from Oracle's own library.

---

**2. Exception Handling: Predefined exceptions, user-defined exceptions, SQLCODE, SQLERRM, PRAGMA EXCEPTION_INIT**

*   **Primary Reference:**
    *   [Oracle® Database PL/SQL Language Reference, Chapter 12: PL/SQL Error Handling](books/oracle-database-pl-sql-language-reference/ch12_error-handling.pdf)
        *   _Relevance:_ This chapter is the definitive source for PL/SQL error handling. It covers an overview of exception handling, categories of exceptions, internally and user-defined exceptions, how to raise them (using `RAISE` and `RAISE_APPLICATION_ERROR`), exception propagation, and retrieving error details using `SQLCODE` and `SQLERRM`. The concept of `PRAGMA EXCEPTION_INIT` is typically found within sections discussing user-defined exceptions.

*   **Supporting Reference (for exceptions specific to supplied packages):**
    *   [Oracle® Database PL/SQL Packages and Types Reference](books/database-pl-sql-packages-and-types-reference/database-pl-sql-packages-and-types-reference.pdf)
        *   _Relevance:_ While this book doesn't teach general exception handling, individual chapters for Oracle-supplied packages (e.g., [Chapter 287: UTL_COMPRESS](books/database-pl-sql-packages-and-types-reference/ch287_utl_compress.pdf), [Chapter 289: UTL_FILE](books/database-pl-sql-packages-and-types-reference/ch289_utl_file.pdf), [Chapter 290: UTL_HTTP](books/database-pl-sql-packages-and-types-reference/ch290_utl_http.pdf)) contain sections detailing the *exceptions specific to that package*. This is vital for comprehensive error handling when *using* these packages.

---

**3. Triggers: DML triggers, :NEW and :OLD qualifiers, conditional predicates**

*   **Primary Reference:**
    *   [Oracle® Database PL/SQL Language Reference, Chapter 10: PL/SQL Triggers](books/oracle-database-pl-sql-language-reference/ch10_triggers.pdf)
        *   _Relevance:_ This is the core reference for understanding Oracle PL/SQL triggers. It covers the overview, reasons for use, details on DML triggers (BEFORE/AFTER, row/statement level), conditional predicates (`WHEN` clause), and the essential `:NEW` and `:OLD` pseudorecords for accessing data in row-level triggers.

*   **Secondary Reference (Practical Introduction & Tutorials):**
    *   [Oracle® Database Get Started with Oracle Database Development, Chapter 6: Using Triggers](books/get-started-oracle-database-development/get-started-guide_ch06_using-triggers.pdf)
        *   _Relevance:_ Provides a practical, step-by-step introduction to triggers, including tutorials on creating DML triggers and understanding `:NEW` and `:OLD` through examples, making the concepts more concrete.

---

**Summary of Key Books for Chunk 7:**

*   **[Oracle® Database PL/SQL Language Reference](books/oracle-database-pl-sql-language-reference/database-pl-sql-language-reference.pdf):** This is your **PRIMARY** resource for learning the syntax, semantics, and core concepts of creating and using Packages, Exception Handling, and Triggers in PL/SQL.
*   **[Oracle® Database PL/SQL Packages and Types Reference](books/database-pl-sql-packages-and-types-reference/database-pl-sql-packages-and-types-reference.pdf):** This book is crucial for understanding **Oracle's supplied packages** by example and learning about their specific exceptions.
*   **[Oracle® Database Get Started with Oracle Database Development](books/get-started-oracle-database-development/get-started-oracle-database-development.pdf):** Useful for practical tutorials and introductory examples, especially for Triggers.

For Chunk 7, you will heavily rely on the **PL/SQL Language Reference** for the foundational knowledge of building these resilient PL/SQL components. The **Packages and Types Reference** will then serve as your guide to the vast library of pre-built tools (packages) Oracle provides, and how to handle their specific behaviors and exceptions.