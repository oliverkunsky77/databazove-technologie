WITH RECURSIVE monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS sales_month,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
), 
month_order AS (
    SELECT 
        sales_month, 
        revenue,
        ROW_NUMBER() OVER(ORDER BY sales_month) AS rn
    FROM monthly_revenue
), 
cumulative_target AS (
    SELECT 
        sales_month,
        revenue,
        rn,
        revenue AS cumulative_revenue
    FROM month_order
    WHERE rn = 1

    UNION ALL

    SELECT 
        mo.sales_month,
        mo.revenue,
        mo.rn,
        ct.cumulative_revenue + mo.revenue
    FROM cumulative_target ct
    JOIN month_order mo ON mo.rn = ct.rn + 1
)
SELECT rn,
    sales_month,
    revenue,
    cumulative_revenue
FROM cumulative_target
WHERE cumulative_revenue >= 500000000
ORDER BY rn
LIMIT 1;