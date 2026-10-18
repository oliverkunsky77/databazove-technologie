WITH monthly_comparison AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    monthly_sales,
    LAG(monthly_sales, 1) OVER (ORDER BY month) AS prev_month_sales,
    LEAD(monthly_sales, 1) OVER (ORDER BY month) AS next_month_sales
FROM monthly_comparison
ORDER BY month;