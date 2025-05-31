-- For learning resource examples
CREATE TABLE IF NOT EXISTS conquering_complexities_lecture.ProductInventory (
    ProductID NUMBER PRIMARY KEY,
    ProductName VARCHAR2(100),
    DescriptionText CLOB,          -- General description
    ProductImage BLOB,             -- A small image
    SpecificationsXML XMLTYPE,     -- Technical details in XML
    AttributesJSON JSON            -- Key features in JSON
);

-- Let's ensure this table is empty before inserting for idempotency if re-run
-- In a real script, you might use IF NOT EXISTS for DDL, or TRUNCATE for DML
-- For simplicity here, we assume a clean slate or that inserts are safe.
-- If you run this multiple times, you might get ORA-00001 if ProductID is not unique.
-- Consider DELETE FROM conquering_complexities_lecture.ProductInventory; before inserts for easy re-runs of this block.

INSERT INTO conquering_complexities_lecture.ProductInventory (ProductID, ProductName, DescriptionText, ProductImage, SpecificationsXML, AttributesJSON)
VALUES (
    101,
    'Oracle Widget Pro',
    TO_CLOB('The Oracle Widget Pro is the latest innovation in widget technology. It offers unparalleled performance and a sleek design, suitable for all professional widgeteering tasks. This description is long enough to demonstrate CLOB usage effectively.'),
    UTL_RAW.CAST_TO_RAW('SampleImageDataOWP23AI'), -- Placeholder for actual BLOB data
    XMLTYPE.CREATEXML(
        '<widgetSpecs manufacturer="OracleCorp">
            <model>OWP-23ai</model>
            <dimensions unit="cm">
                <length>10</length>
                <width>5</width>
                <height>2</height>
            </dimensions>
            <material>Titanium Alloy</material>
            <features>
                <feature type="performance">High-Speed Processing</feature>
                <feature type="durability">Shock Resistant</feature>
            </features>
        </widgetSpecs>'
    ),
    JSON('{
        "color": "Oracle Red",
        "weightGrams": 150,
        "connectivity": ["USB-C", "WiFi 7", "NFC"],
        "ecoFriendly": true,
        "rating": {"stars": 4.8, "reviewCount": 250},
        "launchDate": "2023-05-30"
    }')
);

INSERT INTO conquering_complexities_lecture.ProductInventory (ProductID, ProductName, DescriptionText, ProductImage, SpecificationsXML, AttributesJSON)
VALUES (
    102,
    'DataStreamer Lite',
    TO_CLOB('DataStreamer Lite: efficient and compact. Ideal for personal data streaming needs. Comes with basic features and easy setup. Not as feature-rich as the Pro version, but great value for money.'),
    UTL_RAW.CAST_TO_RAW('AnotherImageDSL22'),
    XMLTYPE.CREATEXML(
        '<widgetSpecs manufacturer="DataSimple">
            <model>DSL-22</model>
            <dimensions unit="cm">
                <length>8</length>
                <width>4</width>
                <height>1.5</height>
            </dimensions>
            <material>Recycled Plastic</material>
            <features>
                <feature type="portability">Lightweight</feature>
                <feature type="power">Low Consumption</feature>
            </features>
        </widgetSpecs>'
    ),
    JSON('{
        "color": "Ocean Blue",
        "weightGrams": 90,
        "connectivity": ["USB-A"],
        "ecoFriendly": false,
        "rating": {"stars": 4.1, "reviewCount": 120},
        "launchDate": "2022-11-15"
    }')
);
COMMIT;

-- For JSON Relational Duality View Example (23ai)
CREATE TABLE IF NOT EXISTS conquering_complexities_lecture.EmployeeDirectory (
    EmployeeID NUMBER PRIMARY KEY,
    FullName VARCHAR2(100),
    JobRole VARCHAR2(100),
    DepartmentName VARCHAR2(50), -- Changed from Department
    ContactInfoJSON JSON
);

INSERT INTO conquering_complexities_lecture.EmployeeDirectory (EmployeeID, FullName, JobRole, DepartmentName, ContactInfoJSON)
VALUES (1, 'Ada Coder', 'Lead Developer', 'Technology', JSON('{"email": "ada.coder@example.com", "phone": "555-0101", "skills": ["Java", "PLSQL", "JSON"]}'));
INSERT INTO conquering_complexities_lecture.EmployeeDirectory (EmployeeID, FullName, JobRole, DepartmentName, ContactInfoJSON)
VALUES (2, 'Max Dataflow', 'DBA', 'Technology', JSON('{"email": "max.dataflow@example.com", "office": "B2-103", "certs": ["OCP", "AWS"]}'));
COMMIT;

-- For JSON Collection Table Example (23ai)
CREATE TABLE IF NOT EXISTS conquering_complexities_lecture.SensorReadings (
    ReadingID RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    DeviceID VARCHAR2(50),
    ReadingTime TIMESTAMP DEFAULT SYSTIMESTAMP,
    PayloadJSON JSON CHECK (PayloadJSON IS JSON) -- Enforces JSON structure
);

INSERT INTO conquering_complexities_lecture.SensorReadings (DeviceID, PayloadJSON)
VALUES ('TEMP-SENSOR-001', JSON('{"temperature": 25.5, "humidity": 60, "unit": "Celsius", "location": "ServerRoomA"}'));
INSERT INTO conquering_complexities_lecture.SensorReadings (DeviceID, PayloadJSON)
VALUES ('LIGHT-SENSOR-007', JSON('{"lux": 800, "uvIndex": 3, "status": "optimal", "location": "Greenhouse3"}'));
COMMIT;