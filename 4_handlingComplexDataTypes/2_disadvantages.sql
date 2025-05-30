(ii) Disadvantages and Pitfalls
These exercises highlight common issues and limitations when working with CLOB/BLOB, XMLTYPE, and JSON in Oracle, focusing on performance, direct manipulation, and data integrity aspects.

Exercise 2.1: CLOB/BLOB Limitations and Performance Considerations

Problem: While CLOB/BLOB are good for large data, they have limitations.

Explain why CLOB/BLOB columns cannot be used directly in ORDER BY or GROUP BY clauses.
Demonstrate a pitfall: trying to use standard string functions (SUBSTR with large offsets, INSTR) directly on CLOB values without considering implicit conversions or DBMS_LOB. What happens if you try to apply UPPER directly to a large CLOB? (Hint: it might work for smaller CLOBs due to implicit conversion to VARCHAR2, but fails for larger ones).
Describe conceptually when using VARCHAR2/RAW might be preferred over CLOB/BLOB.
Exercise 2.2: XMLTYPE and JSON Data Type Performance and Schema Challenges

Problem: While powerful, XMLTYPE and JSON data types introduce new performance and management considerations.

Describe a performance pitfall when querying XMLTYPE data with complex or inefficient XPath expressions, especially on large XML documents, and how Oracle addresses this (conceptually: XML indexes).
What is a major challenge regarding schema evolution when storing JSON data in a column with no explicit schema definition? How might this be managed?
Demonstrate a query that might be inefficient if not properly indexed: trying to find XML/JSON data based on a deeply nested element's value.
