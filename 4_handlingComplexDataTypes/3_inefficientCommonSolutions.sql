(iii) Contrasting with Inefficient Common Solutions
These exercises demonstrate scenarios where common, often less idiomatic, SQL approaches (especially from non-Oracle backgrounds or basic SQL knowledge) are inefficient compared to Oracle's specialized features for XMLTYPE and JSON.

Exercise 3.1: XML/JSON Parsing via String Manipulation vs. Native Functions

Problem: Imagine a PostgreSQL user accustomed to limited XML/JSONB functions, or a general SQL user who defaults to string manipulation.

Inefficient: Demonstrate how someone might try to extract the Rating and CustomerName from CustomerFeedbackXML by treating feedbackData as a CLOB and using SUBSTR and INSTR or REGEXP_SUBSTR.
Efficient (Oracle Idiomatic): Show the proper, efficient way to achieve the same result using XMLTYPE.EXTRACT() or XMLTABLE. Clearly explain why the latter is superior in Oracle.
Exercise 3.2: Building XML/JSON Manually vs. Declarative Functions

Problem: Imagine a situation where an Oracle developer, perhaps coming from a background of generating structured data programmatically or through concatenation, attempts to build XML or JSON strings using string concatenation or VARCHAR2 variables.

Inefficient: Describe how one might manually construct a simple XML string (e.g., <Project><ID>1</ID><Name>Project A</Name></Project>) from relational data using CONCAT or || operator.
Efficient (Oracle Idiomatic): Show the proper, efficient way to achieve the same result using XMLELEMENT and XMLFOREST (for XML) or JSON_OBJECT (for JSON). Explain why the latter is superior.