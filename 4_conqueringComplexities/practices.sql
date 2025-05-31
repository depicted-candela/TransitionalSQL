SELECT ProductName, DBMS_LOB.GETLENGTH(DescriptionText) AS TextLength, DBMS_LOB.GETLENGTH(ProductImage) AS ImageSize
FROM conquering_complexities_lecture.ProductInventory
WHERE ProductID = 101;

SELECT DBMS_LOB.SUBSTR(DescriptionText, 20, 1) AS Snippet
FROM conquering_complexities_lecture.ProductInventory
WHERE ProductID = 101;

-- DECLARE myClob CLOB; BEGIN 
--     SELECT DescriptionText INTO myClob 
--     FROM conquering_complexities_lecture.ProductInventory 
--     WHERE ProductID = 101 FOR UPDATE;
--     DBMS_LOB.WRITEAPPEND(myClob, LENGTH(' Appended Info.'), ' Appended Info.'); 
--     COMMIT;
-- END;

DECLARE
  v_lob_loc       BLOB;
  v_buffer        RAW(20); -- Buffer to hold 20 bytes
  v_amount        INTEGER := 20; -- Amount to read
  v_offset        INTEGER := 1;  -- Starting from the beginning
  v_product_name  VARCHAR2(100);
BEGIN
  SELECT PRODUCTIMAGE, PRODUCTNAME
  INTO v_lob_loc, v_product_name
  FROM conquering_complexities_lecture.PRODUCTINVENTORY
  WHERE ProductID = 101;

  IF v_lob_loc IS NOT NULL THEN
    DBMS_LOB.READ(
      lob_loc => v_lob_loc,
      amount  => v_amount,  -- This can be modified by the procedure to actual amount read
      offset  => v_offset,
      buffer  => v_buffer
    );

    DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_product_name);
    DBMS_OUTPUT.PUT_LINE('First ' || v_amount || ' bytes of image: ' || RAWTOHEX(v_buffer));
  ELSE
    DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_product_name || ' has no image.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Product ID 101 not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


SELECT * FROM conquering_complexities_lecture.PRODUCTINVENTORY WHERE ProductID = 101;

SET SERVEROUTPUT ON;
DECLARE
    vDescription CLOB;
    vTempClob CLOB;
    vBuffer VARCHAR2(100);
    vAmount INTEGER := 50;
    vOffset INTEGER := 1;
BEGIN
    -- Get the LOB locator
    SELECT DescriptionText INTO vDescription
    FROM conquering_complexities_lecture.ProductInventory WHERE ProductID = 101;

    DBMS_OUTPUT.PUT_LINE('Original Length: ' || DBMS_LOB.GETLENGTH(vDescription));
    vBuffer := DBMS_LOB.SUBSTR(vDescription, vAmount, vOffset);
    DBMS_OUTPUT.PUT_LINE('First 50 Chars: ' || vBuffer);

    -- To modify, typically use a temporary LOB or select FOR UPDATE
    DBMS_LOB.CREATETEMPORARY(vTempClob, TRUE);
    DBMS_LOB.COPY(vTempClob, vDescription, DBMS_LOB.GETLENGTH(vDescription)); -- Copy original
    
    DBMS_LOB.WRITEAPPEND(vTempClob, LENGTH(' **NEWLY APPENDED SECTION.**'), ' **NEWLY APPENDED SECTION.**');
    DBMS_OUTPUT.PUT_LINE('New Temp Length: ' || DBMS_LOB.GETLENGTH(vTempClob));
    DBMS_OUTPUT.PUT_LINE('New Temp First 100 Chars: ' || DBMS_LOB.SUBSTR(vTempClob, 100, 1));

    -- If you wanted to update the table:
    UPDATE conquering_complexities_lecture.ProductInventory SET DescriptionText = vTempClob WHERE ProductID = 101;
    COMMIT;

    DBMS_LOB.FREETEMPORARY(vTempClob);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF DBMS_LOB.ISTEMPORARY(vTempClob) = 1 THEN
            DBMS_LOB.FREETEMPORARY(vTempClob);
        END IF;
END;
/

-- Creating XMLTYPE from string
DECLARE
    myXML XMLTYPE;
    mySimpleXML XMLTYPE;
BEGIN
    myXML := XMLTYPE.CREATEXML('<customer><id>1</id><name>John Doe</name></customer>');
    mySimpleXML := XMLTYPE('<customer><id>1</id><name>John Doe</name></customer>');
    DBMS_OUTPUT.PUT_LINE('My XML' || myXML.getClobVal());
    DBMS_OUTPUT.PUT_LINE('My simple XML' || mySimpleXML.getClobVal());
END;
/

-- First occurrence of a feature in
SELECT
    pi.ProductName,
    xt.FeatureType,
    xt.FeatureDescription
FROM conquering_complexities_lecture.ProductInventory pi,
    XMLTABLE('/widgetSpecs/features/feature'
        PASSING pi.SpecificationsXML
        COLUMNS
            FeatureType        VARCHAR2(50)  PATH '@type',
            FeatureDescription VARCHAR2(100) PATH '.'
    ) xt
WHERE pi.ProductID = 101;


SELECT
    ProductName,
    XMLCAST(
        XMLQUERY('/widgetSpecs/model/text()'
            PASSING SpecificationsXML RETURNING CONTENT
        ) AS VARCHAR2(50)
    ) AS ModelName,
    XMLCAST(
        XMLQuery('/widgetSpecs/dimensions/length/text()'
            PASSING SpecificationsXML RETURNING CONTENT
        ) AS NUMBER
    ) AS LengthCM
FROM conquering_complexities_lecture.ProductInventory
WHERE ProductID IN (101, 102);

SELECT *
FROM conquering_complexities_lecture.PRODUCTINVENTORY
WHERE XMLExists(
    '/widgetSpecs/dimensions[@unit="cm"]'  -- This is the XPath string literal
    PASSING SPECIFICATIONSXML              -- This specifies the column containing the XML
);

SELECT ProductName
FROM conquering_complexities_lecture.ProductInventory
WHERE XMLExists(
        '/widgetSpecs/features/feature[@type="durability"]'
        PASSING SpecificationsXML
    );

SELECT SPECIFICATIONSXML FROM conquering_complexities_lecture.PRODUCTINVENTORY;


SELECT
    XMLELEMENT("ProductList",
        XMLAGG(
            XMLELEMENT("Product",
                XMLFOREST(
                    p.ProductID AS "ID",
                    p.ProductName AS "Name"
                ),
                -- Nesting SpecificationsXML directly if desired
                XMLELEMENT("Specs", p.SpecificationsXML) 
            ) ORDER BY p.ProductID
        )
    ).getClobVal() AS AllProductsXML
FROM conquering_complexities_lecture.ProductInventory p;


------ JSON

-- Column definition shown in ProductInventory table
    -- Creating JSON
SET SERVEROUTPUT ON;
DECLARE
    myJSON_as_clob CLOB;
    myJSON         JSON;
BEGIN
    myJSON := JSON(JSON_OBJECT('name' VALUE 'Gizmo', 'version' VALUE 2.1));
    DBMS_OUTPUT.PUT_LINE(JSON_SERIALIZE(myJSON PRETTY));
END;
/

SELECT
    pi.ProductName,
    pi.AttributesJSON.color AS ProductColor, -- Path to scalar
    pi.AttributesJSON.rating.stars AS RatingStars, -- Nested path
    pi.ATTRIBUTESJSON
FROM CONQUERING_COMPLEXITIES_LECTURE.ProductInventory pi;

SELECT
    ProductName,
    AttributesJSON,
    JSON_VALUE(AttributesJSON, '$.color') AS Color,
    JSON_VALUE(AttributesJSON, '$.weightGrams' RETURNING NUMBER) AS Weight,
    JSON_VALUE(AttributesJSON, '$.ecoFriendly' RETURNING VARCHAR2(5)) AS IsEcoFriendly,
    JSON_QUERY(AttributesJSON, '$.connectivity') AS Connectivity,
    JSON_QUERY(AttributesJSON, '$.connectivity[*]') AS Connectivity
FROM CONQUERING_COMPLEXITIES_LECTURE.ProductInventory;

SELECT
    pi.ProductName,
    JSON_QUERY(AttributesJSON, '$.connectivity') AS Connectivity,
    jt.Device1, jt.Device2, jt.Device3
FROM CONQUERING_COMPLEXITIES_LECTURE.ProductInventory pi,
    JSON_TABLE(pi.AttributesJSON, '$.connectivity'
        COLUMNS (
            Device1 VARCHAR2(20) PATH '$[0]',
            Device2 VARCHAR2(20) PATH '$[1]',
            Device3 VARCHAR2(20) PATH '$[2]'
        )
    ) jt
WHERE pi.ProductID = 101;