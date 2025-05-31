        -- Sub-Category 3: JSON Data Type & Querying (including 23ai features)


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 3.1.1: Oracle JSON Fundamentals and 23ai Enhancements
-- Problem:
-- Why is storing JSON in Oracle's native JSON data type generally preferred over storing it in a VARCHAR2 or CLOB? Mention at least three advantages.
-- Answer: Becuase is has a lot of features for searching, validations and indexing. VARCHAR2 or CLOB are mere plain texts without hierarchies to search in
-- How does Oracle's native JSON type (especially the binary format in 23ai) compare to PostgreSQL's jsonb?
-- Answer: They're similar for their patterns called paths for searching and relational representation, they also use binary representation for fast OSON
-- computations with smaller storage
-- List the Oracle SQL/JSON functions primarily used for: 
-- a. Extracting a single scalar value from JSON; EXTRACT with text()
-- b. Extracting a JSON object or array (a fragment) from JSON; JSON_QUERY addressing up to the value storing the array
-- c. Shredding a JSON array of objects into relational rows/columns. JSON_TABLE specifying the srouce json column and the paths up to the different new
-- columns to be used relationally, Also possible with JSON_QUERY using the @ symbol appropriately
-- d. Constructing a JSON object from key-value pairs: with JSON_OBJECT for pairing as a wrapper and JSON as constructor
-- e. Constructing a JSON array from elements: with JSON_ARRAY and JSON_ARRAYAGG
-- Write a SQL query to display ProductName and the fccId (from ComplianceInfoJSON) for all products where rohsCompliant is true in their ComplianceInfoJSON.
SELECT PRODUCTNAME, JSON_VALUE(COMPLIANCEINFOJSON, '$.fccId') FCCID
FROM CONQUERINGCOMPLEXITIES.PRODUCTS
WHERE JSON_EXISTS(COMPLIANCEINFOJSON, '$.rohsCompliant?(@ == true)');
-- (Oracle 23ai - JSON Relational Duality Views) What is the primary goal of JSON Relational Duality Views? How do they benefit application developers
-- working with both JSON and relational paradigms?
-- Answer: is for ease of updating with specialized functions transforming JSON to tables that relationally updated are also updated in their original JSON
-- format and conversely solving synchronization and concurrency problems
-- (Oracle 23ai - JSON Collection Tables) Briefly explain the concept of a "JSON Collection Table" in Oracle 23ai. How does the ProductReviewsJSONCollection 
-- table in our dataset exemplify this?
-- Answer: they're very simplified ways to create entirely JSON focused tables, similar to NO SQL where most data is differently structured. Could work for web pages
-- with highly dynamic inputs or logs of computational systems
-- (Oracle 23ai - JSON Binary Data Type) What is the default internal storage format for the JSON data type in Oracle 23ai, and why is this format 
-- advantageous for performance?
-- Answer: is binary and works because optimizes spaces and structures prone to be indexed


-- (ii) Disadvantages and Pitfalls (JSON)

SELECT PRODUCTNAME, COMPLIANCEINFOJSON.UnitPrice, JSON_VALUE(COMPLIANCEINFOJSON, '$.fccId') FCCID
FROM CONQUERINGCOMPLEXITIES.PRODUCTS
WHERE JSON_EXISTS(COMPLIANCEINFOJSON, '$.rohsCompliant?(@ == true)');

--      Exercise 3.2.1: JSON Handling Challenges
-- Problem:
-- When using dot-notation (e.g., myJsonColumn.path.to.value) to access JSON elements in Oracle, what happens if an intermediate path element is an array rather than 
-- an object, or if a path element does not exist? How can this lead to unexpected results or errors?
-- Answer: if the intermediate path element is an array are necessary the symbols [] to indicate which element is the one to be accessed if the path does not exist 
-- (case sensitive) nothing will be represented
SELECT p.REVIEWDATA.rating, p.REVIEWDATA.productID, p.REVIEWDATA.productid, p.REVIEWDATA.tags, p.REVIEWDATA.tags[0],
    JSON_VALUE(p.REVIEWDATA, '$.comment' RETURNING CHARACTER(100)) as C, p.REVIEWDATA
FROM CONQUERINGCOMPLEXITIES.PRODUCTREVIEWSJSONCOLLECTION p;
SELECT
    cp.CustomerID,
    cp.FirstName,
    cp.LastName,
    cp.PREFERENCESJSON.language
FROM CONQUERINGCOMPLEXITIES.CustomerProfiles cp
WHERE cp.PreferencesJSON.language = 'en_US';

-- What is a potential pitfall of using JSON_VALUE to extract a very long string from a JSON document without specifying an adequate RETURNING data type size?
-- Answer: if the string is higher for the limit of the expected to be returned value NULL appears
-- (Oracle 23ai - JSON Relational Duality Views) While Duality Views offer great flexibility, what is a key consideration or potential complexity  regarding 
-- transactional consistency when updates are made through the JSON document view versus direct DML on underlying relational tables?
-- Answer: when things are not well simplified, the duality to eixsts will require overheaded computing and memory


-- (iii) Contrasting with Inefficient Common Solutions (JSON)

--      Exercise 3.3.1: String Searching in JSON vs. Native JSON Path Expressions
-- Scenario: You need to find all customers from CustomerProfiles whose PreferencesJSON indicates their preferred language is 'en_US'. The relevant 
-- JSON part is {"language": "en_US"}.
-- Inefficient Approach: Storing PreferencesJSON as VARCHAR2 and using LIKE '%"language": "en_US"%'.
-- Problem:
-- Explain why using LIKE on a VARCHAR2 column to find specific JSON key-value pairs is unreliable and inefficient. Give two reasons for unreliability 
-- and one for inefficiency.
-- Answer: this is highly inefficient because such query needs to search linearly over almost the entire json object up to got such specific element, also is
-- unreliable because could exists multiple values for 'language', depending on its containing context will differ a lot
-- Provide the efficient and reliable Oracle SQL query using native JSON functions to find these customers.
SELECT CUSTOMERID, FIRSTNAME, LASTNAME, PREFERENCESJSON
FROM CONQUERINGCOMPLEXITIES.CUSTOMERPROFILES
WHERE JSON_EXISTS(PREFERENCESJSON, '$.language?(@ == "en_US")');