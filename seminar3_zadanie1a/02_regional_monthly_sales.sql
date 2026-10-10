DROP VIEW regional_monthly_sales;
CREATE VIEW regional_monthly_sales AS
SELECT c.region, DATE_TRUNC('month', o.order_date) as sale_month, SUM(o.sales) AS monthly_sales FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.region, sale_month ORDER BY sale_month;
SELECT * FROM regional_monthly_sales WHERE region = 'West';       
