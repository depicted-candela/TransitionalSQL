        -- XMLTYPE Data Type


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise 2.1.1: XMLTYPE Fundamentals and Construction
-- Problem:
-- Compare storing XML data in an Oracle XMLTYPE column versus a CLOB column. 
-- What are the advantages of XMLTYPE, especially for querying and validation?
-- It's marvelous for application-based data where correct communication is paramount thus these types of validations gives to the interfaces enough logs
-- for users about their inputs and the security for data analysts about the simplification of highly advanced queries: querying not structured data could
-- be so hard, demanding and time consuming when first does the analysis of all the structures located in the same XML column. These standardize structures
-- not only gives the ease of analysis and communication but also the possibility to apply indexes because data is well defined.
-- How does this compare to PostgreSQL's xml type?
-- Answer: is similar in the way they can be accessed through XML paths but highly different because Oracle gives storing and performance boosts through
-- binary, CLOB and TBX transformations for the structured nature of their XML possibilities not only good for normal communication but better for Oracle's
-- native communication where functions for searching on them are better portable but only available with Oracle 
-- Explain the purpose of XMLELEMENT, XMLFOREST, and XMLAGG in Oracle. Provide a brief example of how each might be used.
-- Answer: XMLELEMENT is the essential entity for XML objects, XMLFOREST is a constructor for property-based elements (appropriate for indexes and fast
-- searching), XMLAGG is an aggregator function but for constructing well structured XML data types
-- Write a SQL query to retrieve the ProductName and its TechnicalSpecsXML. From the XML, extract:
-- The processor name (text of <processor>).
-- The RAM size (text of <ram>) and its unit (attribute @unit of <ram>). Use XMLQuery with XMLCast or XMLTABLE.
-- Using XMLELEMENT, XMLFOREST, and XMLAGG, construct an XML document listing all products from the 'Electronics' category. The root element should be 
-- <ElectronicProductsList>. Each product should be an <ProductEntry> element containing: Name (from ProductName). Price (from UnitPrice).
-- A nested <HardwareSpecs> element containing Processor and Storage (e.g., "256 GB") extracted from TechnicalSpecsXML.
-- (Oracle 23ai - TBX) What is Transportable Binary XML (TBX)? What problem does it aim to solve or improve upon compared to older binary XML storage?
SELECT CATEGORYNAME, XMLAGG(
        XMLELEMENT(
            "ElectronicProductsList",
            XMLELEMENT("ProductEntry", 
                XMLFOREST(
                    p.PRODUCTNAME AS "Name",
                    p.UNITPRICE   AS "Price",
                    XMLFOREST(t.RAM || ' ' || t.UNIT AS "Memory") AS "HardwareSpecs"
                )
            )
        )
        ORDER BY p.PRODUCTNAME
    ) AS TECHNICALSPECSX
FROM 
    CONQUERINGCOMPLEXITIES.PRODUCTS p,
    XMLTABLE(
        '/specs/ram'
        PASSING p.TECHNICALSPECSXML 
            COLUMNS 
                RAM SMALLINT PATH '.', 
                UNIT CHAR PATH '@unit'
        ) t
NATURAL JOIN CONQUERINGCOMPLEXITIES.PRODUCTCATEGORIES
WHERE CATEGORYNAME = 'Electronics'
GROUP BY CATEGORYNAME;


-- (ii) Disadvantages and Pitfalls (XMLTYPE)

--      Exercise 2.2.1: XMLTYPE Traps and Considerations
-- Problem:
-- If an XMLTYPE column is configured with STORE AS CLOB, what is a major performance drawback when executing XPath queries compared to STORE AS 
-- BINARY XML or TBX?
-- Answer: CLOB does not have the structured syntax that XML gives deespite store in itself XML as a string, then better options for optimizing XML
-- is BINARY XML or TBX because are structured binaries
-- A developer writes an XPath expression //product[@id='123']/name to use with XMLQuery. 
-- What potential issues could arise if the XML structure is inconsistent (e.g., some <product> elements lack an @id attribute, or name is sometimes 
-- an attribute instead of an element)? 
-- If there exists many structural variations for the same XML variable, then since queries generalizes structural patterns, just a portion of the
-- generalization will match, the rest will be avoided, that's why XML validations are necessary deespite introduce a little bit of work but using
-- AI the migrations are now possible in less time 
-- How can XMLTABLE help mitigate some of these issues when shredding XML?
-- Answer: XMLTABLE allows to get many patterns in different columns to join them all the generalization in a single table with relational operations
-- Why might creating an XMLIndex on an XMLTYPE column storing vastly different XML document structures (heterogeneous XML) be less effective or more
-- complex?
-- Answer: indexes are specific to given structures, they're like F1 cars over designed for specific scenarios (race tracks) not for all the streets,
-- thus if a index is designed for one of the variations, the remaining variations won't be searched fast and the meaning of that is the necessity
-- of an insane number of indexes, if too much indexes exist too much time will be necessary as each row is updated


-- (iii) Contrasting with Inefficient Common Solutions (XMLTYPE)

--      Exercise 2.3.1: Manual String Parsing of XML vs. XMLTABLE
-- Scenario: You have order details in Orders.OrderDetailsXML. You need to extract all product names and quantities for items in order 'ORD1001'. An 
-- example <item> element: <item productid="1" quantity="1"><name>SuperPhone X</name>...</item>.
-- Inefficient Approach (Conceptual): A developer unfamiliar with SQL/XML might fetch OrderDetailsXML as a string/CLOB and use INSTR and SUBSTR in 
-- PL/SQL to find occurrences of <item>, then further parse substrings to find <name> and quantity="..".
-- Problem: 
-- Describe two major drawbacks of attempting to parse XML using general string manipulation functions (like INSTR, SUBSTR) in Oracle.
-- Answer: imagine you have many boxes labeled sequentially with invisible numbers starting with 0 hiding specific objects, also you have a list with
-- the labeling numbers and the hiden object, but you want to extract specific ranges with meanings, for example a word, a sentence, an object. How
-- time consuming will be counting every box to extract specific rages and repeteadly? Now imagine each aggregation of things are contained by
-- meaningful boxes with clear names and each box with inner boxes. You just need to observe and select the objects not thinking a lot about where
-- they're specficically in an order but in an nested containing level
-- Provide the efficient Oracle-idiomatic SQL query using XMLTABLE to retrieve OrderID, item name (element content), and quantity (attribute value) 
-- for all items in the order where the XML's root order element has an id attribute 'ORD1001'.
SELECT
    o.OrderID,
    items.ItemName,
    items.ItemQuantity
FROM CONQUERINGCOMPLEXITIES.Orders o,
    XMLTABLE('/order/items/item'
        PASSING o.OrderDetailsXML
        COLUMNS
            ItemName     VARCHAR2(100) PATH 'name',
            ItemQuantity NUMBER        PATH '@quantity'
    ) items
WHERE XMLExists(o.OrderDetailsXML, '/order[@id="ORD1001"]');