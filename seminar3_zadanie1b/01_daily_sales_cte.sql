WITH daily_sales AS (
    SELECT 
    sale_date,
    SUM(total_amount) as total_daily_sales
    FROM flourmills_sales
    GROUP BY sale_date
)
SELECT *
FROM daily_sales
WHERE  total_daily_sales > 3000000
ORDER BY total_daily_sales DESC;