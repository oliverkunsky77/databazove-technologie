WITH monthly_country_sales AS (
    SELECT 
        country,
        DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
        SUM(quantity * unit_price) AS total_amount
    FROM 
        public.retail_sales
    WHERE 
        country IS NOT NULL
    GROUP BY 
        country, 
        DATE_TRUNC('month', invoice_date)
)
SELECT 
    country,
    sales_month AS month,
    total_amount,
    NTILE(4) OVER (
        PARTITION BY country 
        ORDER BY total_amount DESC
    ) AS sales_quartile
FROM 
    monthly_country_sales
ORDER BY 
    country ASC, 
    sales_month ASC;