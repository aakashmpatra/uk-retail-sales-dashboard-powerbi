-- Total rows
SELECT COUNT(*) AS total_rows
FROM online_retail;

-- Date Range
SELECT
MIN(InvoiceDate) AS min_date,
MAX(InvoiceDate) AS max_date
FROM online_retail;

-- Unique Customers
SELECT COUNT(DISTINCT CustomerID) AS uique_customers
FROM online_retail;

-- Unique Countries
SELECT COUNT(DISTINCT Country) AS unique_countries
FROM online_retail;

-- Missing CustomerID
SELECT COUNT(*) FROM online_retail
WHERE CustomerID IS NULL;

--Missing Description
SELECT COUNT(*) FROM online_retail
WHERE Description IS NULL OR TRIM(Description) = '';

-- When quantity is negative, came back because of return or cancellation
SELECT COUNT(*) FROM online_retail
WHERE Quantity < 0;

-- Missing InvoiceNo
SELECT COUNT(*) FROM online_retail
WHERE InvoiceNo IS NULL
OR TRIM(InvoiceNo) = '';

-- from negatives that may be returns, refunds, 
-- cancellations, all invoices start with C
SELECT * FROM online_retail
WHERE Quantity < 0
LIMIT 10;

--checking total count of cancellations
SELECT COUNT(*) FROM online_retail
WHERE InvoiceNo LIKE 'C%';

--Zero Quantity
SELECT COUNT(*)
FROM online_retail
WHERE Quantity = 0;

-- Zero or negative price
SELECT COUNT(*)
FROM online_retail
WHERE Unitprice <= 0;

-- Negative quantity but not cancelled invoice
SELECT COUNT(*)
FROM online_retail
WHERE Quantity < 0
AND InvoiceNo NOT LIKE 'C%';

--Couplre more checks
SELECT * 
FROM online_retail
WHERE UnitPrice < 0;

SELECT *
FROM online_retail
WHERE Quantity < 0
AND InvoiceNo NOT LIKE 'C%'
LIMIT 20;

-- Investigate zero or negative price to find anomalies
-- free items, adjustments or data entry issues.SELECT DISTINCT UnitPrice
FROM online_retail
WHERE UnitPrice <=0;

-- There is a negative unit price, check what that can be about
SELECT *
FROm online_retail
WHERE UnitPrice = -11062.06;

--Check if data contains other adjustment type records
SELECT *
FROM online_retail
WHERE Description LIKE '%debt%';

--CHECKING DUPLICATES

--Check for duplicate rows

SELECT *, COUNT(*) AS duplicate_count
FROM online_retail
GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
HAVING COUNT(*) > 1;

--Count duplicates
SELECT COUNT(*) AS duplicate_groups
FROM (SELECT COUNT(*) AS duplicate_count
FROM online_retail
GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
HAVING COUNT(*) > 1);

--Inspect a few and see the patter of duplication
SELECT duplicate_count, COUNT(*) AS number_of_groups
FROM (SELECT COUNT(*) AS duplicate_count
FROM online_retail
GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
HAVING COUNT(*) > 1)
GROUP BY duplicate_count
ORDER BY duplicate_count;

SELECT InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country, COUNT(*) AS duplicate_count
FROM online_retail
GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
HAVING COUNT(*) = 20;

SELECT *
FROM online_retail
WHERE InvoiceNo = '555524'
ORDER BY StockCode;

--INITIAL DATA QUALITY ASSESSMENT

--Dataset structure and completeness were examined before cleaning.

--Key findings:
--  Missing CustomerID values are present and will affect customer level analyses.
--  Negative quantities correspond primarily to returned/cancelled transactions.
--  One negative UnitPrice anomaly was investigated and found to be related to 'adjust bad debt' records rather than retail sales.
--  Exact duplicate records were identified. Investigation of sample invoices showed identical line items repeated multiple times,
--      suggesting duplicate records that will be handled during data cleaning.

