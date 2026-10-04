-- ==================
-- KPI ANALYSIS
-- SOURCE: clean_retail
-- ==================

-- 1. Total Revenue
SELECT SUM(Quantity * UnitPrice) AS total_revenue
FROM clean_retail;

-- 2. Total Orders
SELECT COUNT(DISTINCT InvoiceNo) AS total_orders
FROM clean_retail;

-- 3. Total Units Sold
SELECT SUM(Quantity) AS total_units_sold
FROM clean_retail;

-- 4. Average Order Value (AOV)
-- On an average how much revenue does an order generate?
SELECT SUM(Quantity * UnitPrice)/ COUNT(DISTINCT InvoiceNo) AS average_order_value
FROM clean_retail;

-- 5. Average Units per Order
-- On an average how many units are are sold per order?
SELECT
SUM(Quantity) * 1.0 / COUNT(DISTINCT InvoiceNo) AS average_units_per_order
FROM clean_retail;
-- Average units per order is high because some orders contain large quantities.
SELECT
    InvoiceNo,
    SUM(Quantity) AS units_in_order
    FROM clean_retail
    GROUP BY InvoiceNo
    ORDER BY units_in_order DESC
    LIMIT 10;

-- 6. Total Customers
SELECT COUNT(DISTINCT CustomerID) AS total_customers
FROM clean_retail;

-- 7. Average orders per customer
SELECT COUNT(DISTINCT InvoiceNo) * 1.0 / COUNT(DISTINCT CustomerID) AS average_orders_per_customer
FROM clean_retail;

-- 8. Average revenue per customer
SELECT SUM(Quantity * UnitPrice) * 1.0 / COUNT(DISTINCT CustomerID) AS average_revenue_per_customer
FROM clean_retail; 

-- GEOGRAPHIC ANALYSIS

-- 9. Total revenue by country
SELECT Country, SUM(Quantity * UnitPrice) AS revenue_by_country
FROM clean_retail
GROUP BY Country
ORDER BY revenue_by_country DESC;

-- 10. Total orders by country
SELECT Country, COUNT(DISTINCT InvoiceNo) AS orders_by_country
FROM clean_retail
GROUP BY Country
ORDER BY orders_by_country DESC;

-- 11. Customer distribution by country
SELECT Country, COUNT(DISTINCT CustomerID) AS customer_by_country
FROM clean_retail
GROUP BY Country
ORDER BY customer_by_country DESC;

-- 12. Average order value by country
SELECT Country, SUM(Quantity * UnitPrice) * 1.0 / COUNT(DISTINCT InvoiceNo) AS aov_by_country
FROM clean_retail
GROUP BY Country
ORDER BY aov_by_country DESC;


-- PRODUCT ANALYSIS

-- 13. Top products by revenue

SELECT StockCode, Description, SUM(Quantity * UnitPrice) AS revenue
FROM clean_retail
GROUP BY StockCode, Description
ORDER BY revenue DESC
LIMIT 10;

-- 14. Top products by units sold

SELECT StockCode, Description, SUM(Quantity) AS units_sold
FROM clean_retail
GROUP BY StockCode, Description
ORDER BY units_sold DESC
LIMIT 10;

-- 15. Top products by number of orders

SELECT StockCode, Description, COUNT(DISTINCT InvoiceNo) AS number_of_orders
FROM clean_retail
GROUP BY StockCode, Description
ORDER BY number_of_orders DESC
LIMIT 10;


-- 16. Products contribution to revenue
WITH overall_revenue AS(
    SELECT SUM(Quantity * UnitPrice) AS total_revenue
    FROM clean_retail
),
prod_rev AS( 
    SELECT StockCode, Description, SUM(Quantity * UnitPrice) AS product_revenue
    FROM clean_retail
    GROUP BY StockCode, Description
)
SELECT 
StockCode, Description, product_revenue, ROUND((product_revenue / total_revenue) * 100, 2) AS contribution_to_revenue
FROM prod_rev
CROSS JOIN overall_revenue
ORDER BY contribution_to_revenue DESC;

-- 17. Cumulative revenue contribution by product
WITH overall_revenue AS(
    SELECT SUM(Quantity * UnitPrice) AS total_revenue
    FROM clean_retail
),
prod_rev AS( 
    SELECT StockCode, Description, SUM(Quantity * UnitPrice) AS product_revenue
    FROM clean_retail
    GROUP BY StockCode, Description
)
SELECT 
StockCode, Description, product_revenue, ROUND((product_revenue / total_revenue) * 100, 2) AS contribution_to_revenue,
    ROUND((SUM(product_revenue) OVER(ORDER BY product_revenue DESC) / total_revenue) * 100, 2) AS cumulative_contribution_to_revenue
FROM prod_rev
CROSS JOIN overall_revenue
ORDER BY product_revenue DESC;


-- TIME ANALYSIS

-- 18. Monthly revenue trend
SELECT strftime('%Y-%m', InvoiceDate) AS month, ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM clean_retail
GROUP BY month
ORDER BY month;

-- 19. Monthly orders trend
SELECT strftime('%Y-%m', InvoiceDate) AS month, COUNT(DISTINCT InvoiceNo) as orders
FROM clean_retail
GROUP BY month
ORDER BY month;

-- 20. Monthly units sold trend
SELECT strftime('%Y-%m', InvoiceDate) AS month, SUM(Quantity) AS units_sold
FROM clean_retail
GROUP BY month
ORDER BY month;

-- 21. Month over month revenue growth
WITH monthly_revenue AS(
    SELECT
    strftime('%Y-%m', InvoiceDate) AS month,
    SUM(Quantity * UnitPrice) AS revenue
    FROM clean_retail
    GROUP BY month
)
SELECT month,
    ROUND(revenue, 2) AS revenue,
    ROUND(((revenue - LAG(revenue) OVER(ORDER BY month)) / LAG(revenue) OVER(ORDER BY month)) * 100, 2) AS revenue_growth_pc
    FROM monthly_revenue
    ORDER BY month;

-- 22. Monthly average order value
SELECT strftime('%Y-%m', InvoiceDate) AS month,
ROUND(SUM(Quantity * UnitPrice) * 1.0 / COUNT(DISTINCT InvoiceNo),2) AS average_order_value
FROM clean_retail
GROUP BY month
ORDER BY month;

-- SANITY TESTING
-- 1. Cleaning sanity check
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity,
    SUM(CASE WHEN UnitPrice <= 0 THEN 1 ELSE 0 END) AS invalid_unit_price,
    SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) AS cancelled_invoices
FROM clean_retail;

-- 2. KPI consistency
SELECT
    SUM(Quantity * UnitPrice) AS revenue,
    COUNT(DISTINCT InvoiceNo) AS orders,
    SUM(Quantity) AS units,
    SUM(Quantity * UnitPrice) * 1.0 / COUNT(DISTINCT InvoiceNo) AS calculated_aov,
    SUM(Quantity) * 1.0 / Count(DISTINCT InvoiceNo) AS units_per_order
FROM clean_retail;

-- 3. Monthly total same as overall
WITH monthly AS(
    SELECT
        strftime('%Y-%m', InvoiceDate) AS month,
        SUM(Quantity * UnitPrice) AS monthly_revenue,
        COUNT(DISTINCT InvoiceNo) AS monthly_orders,
        SUM(Quantity) AS monthly_units
    FROM clean_retail
    GROUP BY month
)
SELECT
    SUM(monthly_revenue) AS revenue,
    SUM(monthly_orders) AS orders,
    SUM(monthly_units) AS units
FROM monthly;




