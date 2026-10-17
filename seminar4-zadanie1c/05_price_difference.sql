WITH product_prices AS (
    SELECT 
        stock_code,
        invoice_no,
        invoice_date,
        unit_price AS current_price,
        LAG(unit_price) OVER (
            PARTITION BY stock_code 
            ORDER BY invoice_date
        ) AS previous_price
    FROM 
        retail_sales
)
SELECT 
    stock_code,
    invoice_no,
    invoice_date,
    previous_price,
    current_price,
    (current_price - previous_price) AS price_difference
FROM 
    product_prices
WHERE 
    previous_price IS NOT NULL 
    AND current_price <> previous_price
ORDER BY 
    invoice_date ASC;