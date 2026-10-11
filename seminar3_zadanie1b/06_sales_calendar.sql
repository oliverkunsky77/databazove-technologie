WITH RECURSIVE sales_calendar AS (
        SELECT 
        MIN(sale_date) AS calendar_date,
        MAX(sale_date) AS max_date
    FROM flourmills_sales
    
    UNION ALL
    
    SELECT 
        calendar_date + 1,
        max_date
    FROM sales_calendar
    WHERE calendar_date < max_date
)
SELECT calendar_date 
FROM sales_calendar
ORDER BY calendar_date ASC;