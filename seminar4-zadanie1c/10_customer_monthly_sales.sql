WITH customer_monthly_sales AS (
    SELECT 
        country,
        DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM 
        public.retail_sales
    WHERE 
        customer_id IS NOT NULL 
        AND country IS NOT NULL
    GROUP BY 
        country, 
        DATE_TRUNC('month', invoice_date), 
        customer_id
),
ranked_customers AS (
    SELECT 
        country,
        sales_month AS month,
        customer_id,
        total_amount,
        DENSE_RANK() OVER (
            PARTITION BY country, sales_month 
            ORDER BY total_amount DESC
        ) AS sales_rank
    FROM 
        customer_monthly_sales
)
SELECT 
    country,
    month,
    customer_id,
    total_amount,
    sales_rank
FROM 
    ranked_customers
WHERE 
    sales_rank BETWEEN 1 AND 5
ORDER BY 
    country ASC, 
    month ASC, 
    sales_rank ASC, 
    customer_id ASC;