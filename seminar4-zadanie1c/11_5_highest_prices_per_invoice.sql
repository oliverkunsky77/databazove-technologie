WITH ranked_prices AS (
    SELECT 
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        DENSE_RANK() OVER (
            PARTITION BY invoice_no 
            ORDER BY unit_price DESC
        ) AS price_rank
    FROM 
        retail_sales
)
SELECT 
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    price_rank
FROM 
    ranked_prices
WHERE 
    price_rank <=5
ORDER BY 
    invoice_no ASC, 
    price_rank ASC, 
    stock_code ASC;