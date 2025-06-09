
-- Collections

-- Declaring Collections
DECLARE
    -- Associative Arrays (Index-by Table)
    TYPE empSalaryMap IS TABLE OF plsqlmastery_lecture.lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;
    mySalaries empSalaryMap;
    TYPE cityMap IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(10);
    branchCities cityMap;
    -- Varray (requires a type definition)
    TYPE colorArray IS VARRAY(3) OF VARCHAR2(10);
    primaryColors colorArray;
    -- Nested Table (requires a type definition)
    TYPE productPriceList IS TABLE OF plsqlmastery_lecture.lectureProducts.price%TYPE;
    currentPrices productPriceList;
    -- Nested Table of Records (requires object type definition)
    -- TYPE lectureProductRec IS OBJECT ( prodId NUMBER, prodName VARCHAR2(50), prodPrice NUMBER(10,2) ); -- Defined above
    TYPE lectureProductTab IS TABLE OF plsqlmastery_lecture.lectureProductRec;
   productDetails lectureProductTab;
BEGIN
    -- Collections are declared, ready for population.
    NULL; -- Placeholder
END;
/

-- Initializing Collections
DECLARE
    TYPE colorArray IS VARRAY(3) OF VARCHAR2(10);
    -- Initialize with constructor (size 3, max 3)
    primaryColors colorArray := colorArray('Red', 'Green', 'Blue');

    TYPE productPriceList IS TABLE OF plsqlmastery_lecture.lectureProducts.price%TYPE;
    -- Initialize with constructor (size 2)
    currentPrices productPriceList := productPriceList(100.00, 250.00);

    TYPE lectureProductTab IS TABLE OF plsqlmastery_lecture.lectureProductRec;
    -- Initialize nested table of objects
    productDetails lectureProductTab := lectureProductTab( 
        plsqlmastery_lecture.lectureProductRec(1, 'Alpha', 100), 
        plsqlmastery_lecture.lectureProductRec(2, 'Beta', 200) 
    );

    -- Associative arrays are populated by assignment, no constructor needed
    TYPE empSalaryMap IS TABLE OF plsqlmastery_lecture.lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;
    mySalaries empSalaryMap;
BEGIN
    -- Populate associative array
    mySalaries(100) := 24000;
    mySalaries(102) := 17000;

    DBMS_OUTPUT.PUT_LINE('Varray Count: ' || primaryColors.COUNT);
    DBMS_OUTPUT.PUT_LINE('Nested Table Count: ' || currentPrices.COUNT);
    DBMS_OUTPUT.PUT_LINE('Assoc Array Count: ' || mySalaries.COUNT);
    DBMS_OUTPUT.PUT_LINE('Nested Table of Objects Count: ' || productDetails.COUNT);
END;
/

-- Accessing Collection Elements
DECLARE
  TYPE colorArray IS VARRAY(3) OF VARCHAR2(10);
  primaryColors colorArray := colorArray('Red', 'Green', 'Blue');
  TYPE productPriceList IS TABLE OF  plsqlmastery_lecture.lectureProducts.price%TYPE;
  currentPrices productPriceList := productPriceList(100.00, 250.00);
  TYPE empSalaryMap IS TABLE OF plsqlmastery_lecture.lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;
  mySalaries empSalaryMap;
BEGIN
  mySalaries(100) := 24000;
  mySalaries(102) := 17000;

  DBMS_OUTPUT.PUT_LINE('Second color: ' || primaryColors(2)); -- Varray (1-based index)
  DBMS_OUTPUT.PUT_LINE('First price: ' || currentPrices(1)); -- Nested Table (1-based index)
  DBMS_OUTPUT.PUT_LINE('Salary for emp 100: ' || mySalaries(100)); -- Associative Array (user-defined index)

  -- Accessing fields in a collection of records/objects
  -- Using object constructor
  DBMS_OUTPUT.PUT_LINE('Prod ID from nested object: ' ||  plsqlmastery_lecture.lectureProductRec(1000, 'Laptop', 1200.00).prodId); 
END;
/

-- Collection Methods
DECLARE
    TYPE productPriceList IS TABLE OF plsqlmastery_lecture.lectureProducts.price%TYPE;
    currentPrices productPriceList := productPriceList(100.00, 250.00, 300.00, 400.00);
    idx PLS_INTEGER;
    TYPE productArray IS VARRAY(4) OF VARCHAR(30);
    mainProducts productArray := productArray('automatic content generator', 'advicer', 'productivity');
BEGIN
    DBMS_OUTPUT.PUT_LINE('Initial Count: ' || currentPrices.COUNT);
    currentPrices.DELETE(2); -- Delete element at index 2
    DBMS_OUTPUT.PUT_LINE('Count after DELETE(2): ' || currentPrices.COUNT); -- Count changes
    DBMS_OUTPUT.PUT_LINE('First index: ' || currentPrices.FIRST); -- Still 1
    DBMS_OUTPUT.PUT_LINE('Last index: ' || currentPrices.LAST); -- Still 4
    DBMS_OUTPUT.PUT_LINE('Element at index 3 exists? ' || CASE WHEN currentPrices.EXISTS(3) THEN 'TRUE' ELSE 'FALSE' END); -- TRUE
    DBMS_OUTPUT.PUT_LINE('Element at index 2 exists? ' || CASE WHEN currentPrices.EXISTS(2) THEN 'TRUE' ELSE 'FALSE' END); -- FALSE

    DBMS_OUTPUT.PUT_LINE('A limit for main products ' || mainProducts.LIMIT);
    DBMS_OUTPUT.PUT_LINE('A counter for main products ' || mainProducts.COUNT);

    currentPrices.EXTEND; -- Add one null element
    -- DBMS_OUTPUT.PUT_LINE('Current prices after EXTEND: ' || currentPrices);
    DBMS_OUTPUT.PUT_LINE('Count after EXTEND: ' || currentPrices.COUNT); -- Count increases
    DBMS_OUTPUT.PUT_LINE('Last index after EXTEND: ' || currentPrices.LAST); -- Index increases
    DBMS_OUTPUT.PUT_LINE('Last item after EXTEND: ' || currentPrices(currentPrices.LAST)); -- Last item

    currentPrices.EXTEND(2); -- Add one null element
    DBMS_OUTPUT.PUT_LINE('Count after EXTEND(2): ' || currentPrices.COUNT); -- Count increases
    DBMS_OUTPUT.PUT_LINE('Last index after EXTEND(2): ' || currentPrices.LAST); -- Index increases
    DBMS_OUTPUT.PUT_LINE('Last item after EXTEND(2): ' || currentPrices(currentPrices.LAST)); -- Last item
    DBMS_OUTPUT.PUT_LINE('Item 3 after to EXTEND(2): ' || currentPrices(3)); -- Third item

    currentPrices.EXTEND(2, 3); -- Add the third element twice at the end
    DBMS_OUTPUT.PUT_LINE('Count after EXTEND(2, 3): ' || currentPrices.COUNT); -- Count increases
    DBMS_OUTPUT.PUT_LINE('Last index after EXTEND(2, 3): ' || currentPrices.LAST); -- Index increases
    DBMS_OUTPUT.PUT_LINE('Last item after EXTEND(2, 3): ' || currentPrices(currentPrices.LAST)); -- Last item

    currentPrices.TRIM(1); -- Remove last element
    DBMS_OUTPUT.PUT_LINE('Count after TRIM(1): ' || currentPrices.COUNT); -- Count decreases
    DBMS_OUTPUT.PUT_LINE('Last index after TRIM(1): ' || currentPrices.LAST); -- Index decreases
END;
/

-- Declaring Records
DECLARE
    -- Record based on a table row
    empRow plsqlmastery_lecture.lectureEmployees%ROWTYPE;
    -- Record based on a custom structure
    TYPE addressRec IS RECORD (
        street VARCHAR2(100),
        city VARCHAR2(50),
        zipCode VARCHAR2(10)
    );
    empAddress addressRec;
    -- Record containing another record (nested record)
    TYPE empContactRec IS RECORD (
        employeeInfo plsqlmastery_lecture.lectureEmployees%ROWTYPE, -- Nested %ROWTYPE record
        addressInfo addressRec -- Nested custom record
    );
    fullEmpContact empContactRec;
    -- Record using object type (defined above)
    productInfo plsqlmastery_lecture.lectureProductRec;
BEGIN
    -- Records are declared. Fields are null by default unless initialized in type definition.
    NULL; -- Placeholder
END;
/

-- Accessing Record Fields
DECLARE
    empRow lectureEmployees%ROWTYPE;
    TYPE addressRec IS RECORD (
        street VARCHAR2(100),
        city VARCHAR2(50)
    );
    empAddress addressRec;
    TYPE empContactRec IS RECORD (
        employeeInfo lectureEmployees%ROWTYPE,
        addressInfo addressRec
    );
    fullEmpContact empContactRec;
    productInfo lectureProductRec; -- Using object type
BEGIN
    -- Populate fields
    empRow.employeeId := 101;
    empRow.lastName := 'Doe'; -- Note: %ROWTYPE gets column names
    empAddress.street := '123 Main St';
    empAddress.city := 'Anytown';
    fullEmpContact.employeeInfo.employeeId := 102; -- Access nested field
    fullEmpContact.addressInfo.city := 'Otherville'; -- Access nested field
    productInfo := lectureProductRec(1000, 'Laptop', 1200.00); -- Initialize object type record
    productInfo.prodPrice := 1100.00; -- Access field of object type record
    DBMS_OUTPUT.PUT_LINE('Employee Last Name: ' || empRow.lastName);
    DBMS_OUTPUT.PUT_LINE('Employee Address City: ' || fullEmpContact.addressInfo.city);
    DBMS_OUTPUT.PUT_LINE('Product Info Price: ' || productInfo.prodPrice);
END;
/


-- Bulk Operations

-- BULK COLLECT
DECLARE
    -- Collections to hold results
    TYPE empIdList IS TABLE OF plsqlmastery_lecture.lectureEmployees.employeeId%TYPE INDEX BY PLS_INTEGER;
    TYPE empNameList IS TABLE OF plsqlmastery_lecture.lectureEmployees.lastName%TYPE INDEX BY PLS_INTEGER;
    TYPE empSalaryList IS TABLE OF plsqlmastery_lecture.lectureEmployees.salary%TYPE INDEX BY PLS_INTEGER;
    allEmpIds empIdList;
    allEmpNames empNameList;
    allEmpSalaries empSalaryList;
    -- Collection of records to hold results
    TYPE empRecList IS TABLE OF plsqlmastery_lecture.lectureEmployees%ROWTYPE INDEX BY PLS_INTEGER; -- Or Nested Table
    allEmpRecords empRecList;
    -- Cursor for FETCH BULK COLLECT
    CURSOR c_highSalaryEmps IS
        SELECT employeeId, lastName, salary
        FROM plsqlmastery_lecture.lectureEmployees
        WHERE salary > 10000;
    TYPE highSalaryEmpRecList IS TABLE OF c_highSalaryEmps%ROWTYPE INDEX BY PLS_INTEGER;
    highSalaryEmpRecords highSalaryEmpRecList;
    fetchLimit CONSTANT PLS_INTEGER := 2; -- Fetch in batches of 2
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- BULK COLLECT ---');
    -- BULK COLLECT with SELECT INTO (fetches all rows at once)
    SELECT employeeId, lastName, salary
    BULK COLLECT INTO allEmpIds, allEmpNames, allEmpSalaries
    FROM plsqlmastery_lecture.lectureEmployees;
    DBMS_OUTPUT.PUT_LINE('Fetched ' || allEmpIds.COUNT || ' employees using SELECT BULK COLLECT.');
    IF allEmpIds.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('First employee: ID=' || allEmpIds(allEmpIds.FIRST) || ', Name=' || allEmpNames(allEmpNames.FIRST));
    END IF;
    -- BULK COLLECT with SELECT INTO into collection of records
    SELECT * -- Select all columns to match %ROWTYPE record structure
    BULK COLLECT INTO allEmpRecords
    FROM plsqlmastery_lecture.lectureEmployees;
    DBMS_OUTPUT.PUT_LINE('Fetched ' || allEmpRecords.COUNT || ' employees into collection of records.');
    IF allEmpRecords.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('First employee record (ID, Name): ' || allEmpRecords(allEmpRecords.FIRST).employeeId || ', ' || allEmpRecords(allEmpRecords.FIRST).lastName);
    END IF;
    -- BULK COLLECT with FETCH (fetches in batches)
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- FETCH BULK COLLECT ---');
    OPEN c_highSalaryEmps;
    LOOP
        FETCH c_highSalaryEmps BULK COLLECT INTO highSalaryEmpRecords LIMIT fetchLimit;
        EXIT WHEN highSalaryEmpRecords.COUNT = 0;
        DBMS_OUTPUT.PUT_LINE('Fetched batch of ' || highSalaryEmpRecords.COUNT || ' high salary employees.');
        -- Process the batch (e.g., print some details)
        FOR i IN highSalaryEmpRecords.FIRST .. highSalaryEmpRecords.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('  ID: ' || highSalaryEmpRecords(i).employeeId || ', Salary: ' || highSalaryEmpRecords(i).salary);
        END LOOP;
    END LOOP;
    CLOSE c_highSalaryEmps;
END;
/