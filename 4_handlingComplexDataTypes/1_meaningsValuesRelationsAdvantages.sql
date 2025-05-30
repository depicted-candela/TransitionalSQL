        -- Handling Complex Data Types


    -- (i) Meanings, Values, Relations, and Advantages
-- These exercises emphasize Oracle's native handling of complex data types, contrasting with PostgreSQL's TEXT/BYTEA or XML/JSONB equivalents by highlighting 
-- Oracle's specific functions and integrated features.

--      Exercise 1.1: Understanding and Querying CLOB/BLOB Data Types
-- Problem: Explain the purpose of CLOB and BLOB data types in Oracle. Demonstrate how to insert and retrieve data from CLOB and BLOB columns. Show how to check
-- the LENGTH of the data in these columns. Conceptually, describe how one would handle complex manipulations for BLOB data in Oracle (hinting at future PL/SQL). In PostgreSQL, TEXT and BYTEA are typically used for large character/binary data. CLOB/BLOB in Oracle are specifically designed for very large objects, potentially stored out-of-row, offering better performance for extreme sizes and dedicated API for manipulation.
-- Answer: BLOB* is to compress data up to their binary form to save memory. CLOB* aggregates multilingual characters in very large formats with limits
-- *: default up to 4GB but customizable
INSERT INTO HANDLING_COMPLEX_DATATYPE.PROJECTDETAILS(
    PROJECTID, PROJECTNAME, PROJECTSTATUS, STARTDATE, ENDDATE, PROJECTDESCRIPTION, PROJECTDIAGRAM)
VALUES (
    5, 
    'Project to add', 
    'Completed', 
    SYSDATE, 
    SYSDATE + 1, 
    TO_CLOB('O AISDJOASIDJF OIJFDASOD FJASODF IAJS FO AISDJOASIDJF FO AISDJOASIDJF OIJFDASOD FJASODF IAJS F'),
    UTL_RAW.CAST_TO_RAW('203427039452780345287340589023742908357823094578230492783')
);
COMMIT;
SELECT LENGTH(PROJECTDESCRIPTION), DBMS_LOB.GETLENGTH(PROJECTDIAGRAM) 
FROM HANDLING_COMPLEX_DATATYPE.PROJECTDETAILS;

--      Exercise 1.2: Mastering XMLTYPE Storage and Basic XPath Querying
-- Problem: Explain why Oracle's XMLTYPE is advantageous for storing XML compared to a CLOB. Demonstrate how to create an XMLTYPE instance from a VARCHAR2 
-- string. Write queries using XMLTYPE.EXTRACT() (with getStringVal() or getNumberVal()) and XMLTYPE.EXISTSNODE() with XPath expressions to retrieve specific 
-- values and check for the existence of nodes within the CustomerFeedbackXML table. PostgreSQL has an XML data type, and an xpath() function. Oracle's XMLTYPE 
-- is a powerful object type with methods, providing more integrated SQL/XML capabilities. EXTRACT and EXISTSNODE are key Oracle-specific methods.
-- Answer: XML is focused on structured formats coming from different origins like web pages and apis, because they're structured, performance can be thought
-- there because mathematical algorithms exists in well designed structures, that's why Oracle's have a complete series of specialized indexes for them; 
-- another story is for CLOB because they're not structured as objects but as mere giant texts, thus full text searching is possible there but existance filters
-- are highly inferior contrasted with the ones for XML structures.
SELECT XMLTYPE('<Core><Nested1>1209381</Nested1><Nested2>aoifjdaoisdjf</Nested2></Core>') XMLDATA FROM DUAL;

SELECT 
    EXTRACTVALUE(FEEDBACKDATA, '/Feedback/CustomerName/text()') AS CustomerName,
    EXTRACT(FEEDBACKDATA, '/Feedback/Comments/CommentSeq') AS AllCommentSeqs,
    EXTRACT(FEEDBACKDATA, '/Feedback/Comments/CommentSeq/text()') AS ConcatCommentSeqs,
    EXTRACT(FEEDBACKDATA, '/Feedback/Comments/Text/text()') AS UngroupedComments,
    EXTRACT(FEEDBACKDATA, '/Feedback/Comments/CommentSeq[text()=1]/text()') AS SingularComments,
    EXTRACT(FEEDBACKDATA, '/Feedback/Comments/CommentSeq[text()!=1]/text()') AS NotSingularComments,
    EXTRACT(FEEDBACKDATA, '/Feedback/Comments/Category[text()="Critical"]/text()') AS CriticalComments,
    EXTRACT(FEEDBACKDATA, '/Feedback/Rating/text()').getNumberVal() AS Rating,
    EXTRACT(FEEDBACKDATA, '/Feedback/Rating/@scale') AS RatingScales,
    EXTRACT(FEEDBACKDATA, '/Feedback/Rating[@type="overall_satisfaction"]/text()').getNumberVal() AS TypeComments
FROM HANDLING_COMPLEX_DATATYPE.CUSTOMERFEEDBACKXML;

SELECT * FROM HANDLING_COMPLEX_DATATYPE.CUSTOMERFEEDBACKXML;

SELECT 
    XMLQUERY('/Feedback/CustomerName/text()' PASSING FEEDBACKDATA RETURNING CONTENT) AS CustomerName,
    EXISTSNODE(FEEDBACKDATA, '/Feedback/Comments[@status="new"]') WITHNEWCOMMENTS
FROM HANDLING_COMPLEX_DATATYPE.CUSTOMERFEEDBACKXML;

SELECT XMLQUERY('/Feedback/Comments/text()' PASSING FEEDBACKDATA RETURNING CONTENT) AS AllCommentsTextSequence
FROM HANDLING_COMPLEX_DATATYPE.CUSTOMERFEEDBACKXML;

--      Exercise 1.3: Shredding XML with XMLTABLE and Constructing XML with XMLELEMENT, XMLFOREST, XMLAGG
-- Problem: XMLTABLE is a crucial function for transforming XML data into a relational view, which is often needed for reporting or integration. XMLELEMENT, 
-- XMLFOREST, and XMLAGG are essential for generating XML from relational data.
-- Use XMLTABLE to extract CustomerId, CustomerName, Rating, and all Comment texts and their Category for each feedback entry in CustomerFeedbackXML.
-- Using XMLELEMENT, XMLFOREST, and XMLAGG, construct an XML document that summarizes project details. For each project, include projectId, projectName, 
-- projectStatus. Also, include a FeedbackSummary element that lists the average rating for that project (from CustomerFeedbackXML), and a count of critical 
-- comments. PostgreSQL has an xmltable() function, but its syntax and capabilities might differ slightly. XMLELEMENT, XMLFOREST, XMLAGG are highly idiomatic 
-- Oracle SQL/XML functions.

--      Exercise 1.4: Exploring Oracle's Native JSON Data Type and Functions
-- Problem: Oracle provides a native JSON data type (similar to PostgreSQL's JSONB).
-- Show how to query JSON data using dot notation (. operator) and JSON_VALUE, JSON_QUERY.
-- Use JSON_TABLE to shred the teamConfig JSON data from ProjectTeamJSON into relational rows for projectId, teamLeadName, and the name and role of each member.
-- Use JSON_OBJECT and JSON_ARRAY to construct a new JSON document from selected CompanyEmployees data. PostgreSQL also has robust JSON functionality (JSONB, 
-- JSON_EXTRACT_PATH, etc.). The key here is to practice Oracle's specific function names and syntax, noting similarities in concept.