WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM 
        retail_sales
    WHERE 
        customer_id IS NOT NULL
    GROUP BY 
        customer_id
)
SELECT 
    customer_id,
    total_amount,
    NTILE(4) OVER (ORDER BY total_amount DESC) AS sales_quartile
FROM 
    customer_sales
ORDER BY 
    total_amount DESC;