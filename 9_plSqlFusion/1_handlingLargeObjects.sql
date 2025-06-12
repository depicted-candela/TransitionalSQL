        -- 1. DBMS_LOB: Handling Large Objects

--  (i) Meanings, Values, Relations, and Advantages

-- The DBMS_LOB package is Oracle's primary tool for programmatic manipulation of Large Object (LOB) data types like CLOB (Character LOB) and BLOB (Binary LOB). While
-- PostgreSQL handles large objects via its oid type and lo_* functions which require an lo_open/lo_close semantic, Oracle's DBMS_LOB is tightly integrated with PL/SQL 
-- and offers high-performance, chunk-based processing directly on LOB locators.

--      Exercise 1.1: Initializing and Writing to a CLOB
-- Problem: You need to add a new record for the 'High-Performance Servers' product line to the productCatalogs table. The catalogDescription (CLOB) column must first 
-- be initialized, then populated with an initial description, and finally, a marketing tagline must be appended.
SAVEPOINT newProductCatalog;
DECLARE
    vDescription CLOB;
    firstBuffer VARCHAR2(100) := 'Description for High-Performance Servers';
    marketingBuffer VARCHAR2(100) := 'Marketing tagline for High-Performance Servers';
BEGIN
    INSERT INTO PLSQLFUSION.PRODUCTCATALOGS(PRODUCTLINE, CATALOGDESCRIPTION) 
    VALUES('High-Performance Servers', EMPTY_CLOB())
    RETURNING CATALOGDESCRIPTION INTO vDescription;
    DBMS_LOB.WRITE(vDescription, LENGTH(firstBuffer), 1, firstBuffer);
    DBMS_LOB.WRITEAPPEND(vDescription, LENGTH(marketingBuffer), marketingBuffer);
    COMMIT;
END;
/
-- Reference: For more details on LOB operations, see the SecureFiles and Large Objects Developer's Guide (Chapter 7) and the PL/SQL Packages and Types Reference for 
-- DBMS_LOB.

--      Exercise 1.2: Reading a BLOB in Chunks
-- Problem: A 70-byte PDF document has been loaded into the catalogPDF (BLOB) for a new product line. Write a PL/SQL block to read the BLOB in 32-byte chunks and 
-- display the raw hex values of each chunk.
DECLARE
    pdf_raw     BLOB;
    offst       INTEGER := 1;
    chunk_size  INTEGER := 32;
    pdf_char    VARCHAR2(100) := 'Marketing tagline for High-Performance Servers';
BEGIN
    SAVEPOINT previousUpdating;
    BEGIN
        UPDATE PLSQLFUSION.PRODUCTCATALOGS SET CATALOGPDF = UTL_RAW.CAST_TO_RAW(pdf_char)
        WHERE CATALOGID = (SELECT CATALOGID FROM (SELECT CATALOGID FROM PLSQLFUSION.PRODUCTCATALOGS ORDER BY CATALOGID) WHERE ROWNUM = 1)
        RETURNING CATALOGPDF INTO pdf_raw;
    EXCEPTION 
        WHEN OTHERS THEN ROLLBACK TO previousUpdating; RAISE;
    END;
    COMMIT;
    WHILE offst < DBMS_LOB.GETLENGTH(pdf_raw) + 1 LOOP
        DBMS_LOB.READ(pdf_raw, chunk_size, offst, pdf_raw);
        DBMS_OUTPUT.PUT_LINE('Raw PDF: '||RAWTOHEX(pdf_raw));
        offst := offst + 32;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected error');
END;
/
ROLLBACK TO previousUpdating;


--  (ii) Disadvantages and Pitfalls

--      Exercise 1.3: The "Offset" Pitfall with Multi-Byte Characters
-- Problem: You need to replace the word "サーバー" (server) with "SYSTEM" in a Japanese CLOB. A developer incorrectly calculates the offset and amount in bytes instead
-- of characters. Demonstrate the pitfall and the correct solution.
DECLARE
    japanese CLOB := 'サーバー';
    jap_char NVARCHAR2(4) := 'サーバー';
    english_char NVARCHAR2(6) := 'SYSTEM';
    jap_bytes NUMBER;
    english_bytes NUMBER;
BEGIN
    jap_bytes := DBMS_LOB.GETLENGTH(UTL_RAW.CAST_TO_RAW(japanese));
    english_bytes := DBMS_LOB.GETLENGTH(UTL_RAW.CAST_TO_RAW(english_char));
    -- DBMS_OUTPUT.PUT_LINE('English chars: '||english_char);
    DBMS_LOB.FRAGMENT_REPLACE(japanese, jap_bytes, jap_bytes, 1, english_char);
END;
/
-- Pitfall: This obviously will fail because of the difference between japanaese and english characters always will fail
-- ORA-06502: PL/SQL: value or conversion error: character string buffer too small

DECLARE
    vJapaneseDesc CLOB;
    vBuffer VARCHAR2(100);
    vOriginalText NVARCHAR2(100) := 'これは高性能のサーバーです。';
    vProductLine VARCHAR2(15) := 'Japanese Manual';
    vToExchange NVARCHAR2(4) := 'サーバー';
    vForExchanging VARCHAR2(6) := 'SYSTEM';
    vStartingPosition NUMBER;
BEGIN
    DELETE plsqlfusion.productCatalogs WHERE productLine = vProductLine;
    INSERT INTO plsqlfusion.productCatalogs(productLine, catalogDescription)
    VALUES (vProductLine, vOriginalText)
    RETURNING catalogDescription INTO vJapaneseDesc;
    vStartingPosition := DBMS_LOB.INSTR(vOriginalText, vToExchange, 1, 1);
    DBMS_LOB.FRAGMENT_REPLACE(
        vJapaneseDesc, 
        DBMS_LOB.GETLENGTH(vToExchange), 
        DBMS_LOB.GETLENGTH(vForExchanging), 
        vStartingPosition, vForExchanging
    );
    -- DBMS_OUTPUT.PUT_LINE(DBMS_LOB.GETLENGTH(UTL_RAW.CAST_TO_RAW(vToExchange)));
    -- DBMS_LOB.FRAGMENT_REPLACE(
    --     vJapaneseDesc,
    --     DBMS_LOB.GETLENGTH(UTL_RAW.CAST_TO_RAW(vToExchange)), 
    --     DBMS_LOB.GETLENGTH(UTL_RAW.CAST_TO_RAW(vForExchanging)), 
    --     vStartingPosition, vForExchanging
    --     );  -- This raise the error ORA-43883: Invalid SECUREFILE LOB DELTA UPDATE operation attempted.
    -- -- ORA-06512: at "SYS.DBMS_LOB", line 1945
    COMMIT;
END;
/


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise 1.4: Building a Large Report
-- Problem: Generate a 100KB report string by concatenating a small string 2,500 times. Contrast the inefficient PL/SQL string concatenation method with the efficient 
-- DBMS_LOB.CREATETEMPORARY method.
DECLARE
    startTime NUMBER;
    endTime NUMBER;
    cIterations CONSTANT INTEGER := 2500;
    counter INTEGER := 1;
    smallString VARCHAR2(12) := 'SMALL STRING';
    concatenation VARCHAR2(32767 BYTE);
    optimalConcat CLOB;
BEGIN
    startTime := DBMS_UTILITY.GET_CPU_TIME;
    WHILE counter < cIterations * 10 + 1 LOOP
        concatenation := concatenation || smallString;
        counter := counter + 1;
    END LOOP;
    endTime := DBMS_UTILITY.GET_CPU_TIME;
    DBMS_OUTPUT.PUT_LINE('Suboptimal concatenation: '||LENGTH(concatenation));
    DBMS_OUTPUT.PUT_LINE('Done in: ');
    DBMS_OUTPUT.PUT_LINE(endTime - startTime);
    DBMS_OUTPUT.PUT_LINE(' secs');

    DBMS_LOB.CREATETEMPORARY(optimalConcat, TRUE);
    counter := 1;
    startTime := DBMS_UTILITY.GET_CPU_TIME;
    WHILE counter < cIterations * 10 + 1 LOOP
        DBMS_LOB.WRITEAPPEND(optimalConcat, LENGTH(smallString), smallString);
        counter := counter + 1;
    END LOOP;
    endTime := DBMS_UTILITY.GET_CPU_TIME;
    DBMS_OUTPUT.PUT_LINE('Optimal concatenation size: '||DBMS_LOB.GETLENGTH(optimalConcat));
    DBMS_OUTPUT.PUT_LINE('Done in: ');
    DBMS_OUTPUT.PUT_LINE(endTime - startTime);
    DBMS_OUTPUT.PUT_LINE(' secs');
    DBMS_LOB.FREETEMPORARY(optimalConcat);
END;
/