--  (iv) Hardcore Combined Problem

--      Problem 4.1: Comprehensive Product Analysis and Reporting
-- Scenario: You are tasked with creating a comprehensive analysis system for product data, orders, and employee information. This involves LOB manipulation, XML and
-- JSON processing, leveraging Oracle 23ai features, and generating reports.
-- Tasks:
-- Data Preparation & 23ai Boolean Usage:
    -- Write an UPDATE statement to ensure the ProductName 'SuperPhone X' is renamed to 'SuperPhone X v2' and its IsActive status (an Oracle 23ai BOOLEAN type) is TRUE.
    -- Ensure 'Smart Coffee Maker' has IsActive = FALSE.
SET AUTOCOMMIT OFF;
UPDATE CONQUERINGCOMPLEXITIES.PRODUCTS 
SET PRODUCTNAME = 'SuperPhone X v2', ISACTIVE = TRUE
WHERE PRODUCTNAME = 'SuperPhone X';
COMMIT;
UPDATE CONQUERINGCOMPLEXITIES.PRODUCTS
SET ISACTIVE = FALSE
WHERE PRODUCTNAME = 'Smart Coffee Maker';
COMMIT;
SELECT * FROM CONQUERINGCOMPLEXITIES.PRODUCTS WHERE PRODUCTNAME IN ('SuperPhone X v2', 'Smart Coffee Maker');

-- JSON Relational Duality View for Employees (Oracle 23ai):
    -- Create a JSON Relational Duality View named EmployeeDataDV over the EmployeesRelational table (joined with DepartmentsRelational).

-- The JSON documents exposed by this view should have a structure like:
-- {
--   "employeeId": "<EmployeeID>",
--   "fullName": "<FirstName> <LastName>",
--   "jobTitle": "<JobTitle>",
--   "email": "<Email>",
--   "department": {
--     "name": "<DepartmentName>",
--     "location": "<Location>"
--   },
--   "profileDetails": "<EmployeeProfileJSON (the entire JSON object from the table)>"
-- }
-- The view should allow updates to an employee's jobTitle and email through the JSON interface.
-- LOB and XML Processing - Order Summary Procedure:

CREATE OR REPLACE JSON RELATIONAL DUALITY VIEW CONQUERINGCOMPLEXITIES.EmployeeDataDV AS 
SELECT JSON {
    '_id'       : e.EMPLOYEEID,
    'fullName'  : (e.FIRSTNAME ||' '|| e.LASTNAME),
    'jobTitle'  : e.jobTitle WITH UPDATE,
    'email'     : e.EMAIL WITH UPDATE,
    'department': (
        SELECT JSON {'id': d.DEPARTMENTID, 'name': d.DEPARTMENTNAME, 'location': d.LOCATION}
        FROM CONQUERINGCOMPLEXITIES.DepartmentsRelational d
        WITH NOUPDATE NOINSERT NODELETE
        WHERE d.DEPARTMENTID = e.DEPARTMENTID
    ),
    'profileDetails': e.EmployeeProfileJSON
}
FROM CONQUERINGCOMPLEXITIES.EmployeesRelational e
WITH UPDATE INSERT DELETE;

SELECT * FROM CONQUERINGCOMPLEXITIES.EmployeeDataDV;


-- Create a PL/SQL stored procedure ProcessOrderSummaries that takes p_OrderID as input.
    -- Inside the procedure: 
    -- a. Fetch the OrderDetailsXML for the given p_OrderID. 
    -- b. Use XMLTABLE to extract all item productid, name, and quantity. 
    -- c. For each item, retrieve its ProductDescription (CLOB). 
    -- d. Create a temporary CLOB (vOrderSummaryCLOB). For each item in the order, append a line to vOrderSummaryCLOB in the format:
        -- "Item: [Item Name], Qty: [Quantity], Desc (first 50 chars): [First 50 chars of ProductDescription]". 
        -- Use DBMS_LOB functions for CLOB manipulation and DBMS_OUTPUT.PUT_LINE to display the final vOrderSummaryCLOB. Remember to handle LOB memory. 
    -- e. If the ShippingAddressJSON for the order contains an apartment key, print "Apartment delivery."
-- Complex Querying with JSON, XML, and Analytics:
-- Write a single SQL query (using CTEs where helpful) to produce a report. PostgreSQL users will be familiar with CTEs; the focus is on Oracle's complex data type 
-- functions.
-- The report should list:
    -- c.FirstName, c.LastName (Customer)
    -- o.OrderID
    -- o.OrderDate (formatted as 'DD-Mon-YYYY')
    -- p.ProductName (of the first item in the order XML, if any)
    -- p.UnitPrice (of that first item)
-- specs_processor (processor from TechnicalSpecsXML of that first item)
-- shipping_city (city from ShippingAddressJSON of the order)
-- customer_notification_pref (The value of notifications.email from customer's PreferencesJSON, display 'Email On' or 'Email Off').
-- order_rank_for_customer (Rank of this order by TotalAmount for that customer, earliest orders get lower rank in case of ties).
-- Filter for orders placed in October 2023.