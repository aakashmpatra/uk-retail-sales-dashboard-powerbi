DROP VIEW IF EXISTS clean_retail;

--Create a clean view for sales analysis
CREATE VIEW clean_retail AS
SELECT *
FROM online_retail
WHERE Quantity>0
AND UnitPrice > 0
AND CustomerID IS NOT NULL;

-- See the number of rows after filtering
SELECT COUNT(*) AS cleaned_rows
FROM clean_retail;


-- double check if filters are applied correctly
SELECT COUNT(*) AS total_rows,
        SUM(CASE WHEN Quantity <=0 THEN 1 ELSE 0 END) AS non_positive_quantity,
        SUM(CASE WHEN UnitPrice <=0 THEN 1 ELSE 0 END) AS non_positive_price,
        SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS misssing_id
FROM clean_retail;

-- We havent dealt with duplicate records yet, lets do that next
-- We have 397884 rows in cleaned record. Lets find how are they involved in duplicate groups.

SELECT SUM(duplicate_count) AS rows_in_duplicate_groups
FROM (
    SELECT COUNT(*) AS duplicate_count
    FROM clean_retail
    GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
    HAVING COUNT(*) > 1
);
-- 10001 rows are involved in duplicate groups but we cant delete them all. We need to keep one record from each duplicate group.
-- Extra copies need to be remeoved keeping 1 from each.


SELECT SUM(duplicate_count -1) AS rows_to_remove
FROM (
    SELECT COUNT(*) AS duplicate_count
    FROM clean_retail
    GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
    Having COUNT(*) > 1
);

-- We got a total of 5192 rows to remove leaving 1 instance of each duplicate group.

-- Build a final view with duplicates removed.



CREATE VIEW clean_retail AS
SELECT DISTINCT *
FROM online_retail
WHERE Quantity > 0
    AND UnitPrice > 0
    AND CustomerID IS NOT NULL;

-- validate the cleaned rows count
SELECT COUNT(*) AS cleaned_rows
FROM clean_retail;
-- We have 392692 rows in the final cleaned view.

-- Now we validate the final view to check if all clean.

-- Final row count
SELECT COUNT(*) AS final_rows
FROM clean_retail;

-- Check for missing customer IDs
SELECT COUNT(*) AS missing_ids
FROM clean_retail
WHERE CustomerID IS NULL;

-- Check for invalid quantities
SELECT COUNT(*) AS invalid_quantities
FROM clean_retail
WHERE Quantity <= 0;

-- Check for invalid prices
SELECT COUNT(*) AS invalid_prices
FROM clean_retail
WHERE UnitPrice <= 0;


-- Check for any duplicates remaining
SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
    FROM clean_retail
    GROUP BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
    HAVING COUNT(*) > 1
);

-- FINAL CLEANED SALES VIEW

-- The final cleaned view contains: 
--    Positive quantity transactions
--    Possitive unit price transactions
--    Transactions that have a customer id
--    One copy of each duplicate record group

-- Final number of rows: 392692

-- The original online_retail has not been modified.

-- Negative quantity transactions were excluded in this view beccause
-- we intend to carry out positive sales analysis.
-- These may represent legitimate business transactions and hence cannot be inherently considered invalid.