WITH customer_sales AS (
    SELECT 
        c.customer_name,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    total_sales,
    NTILE(4) OVER (ORDER BY total_sales DESC) AS quartile
FROM customer_sales
ORDER BY total_sales DESC;