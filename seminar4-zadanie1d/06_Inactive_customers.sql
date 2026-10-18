WITH customer_last_order AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) AS last_order_date,
        MAX(MAX(o.order_date)) OVER () AS latest_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    last_order_date
FROM customer_last_order
WHERE last_order_date < (latest_order_date - INTERVAL '90 days')
ORDER BY last_order_date ASC;