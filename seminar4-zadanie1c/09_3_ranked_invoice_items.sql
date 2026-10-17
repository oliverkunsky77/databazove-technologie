WITH ranked_invoice_items AS (
    SELECT 
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        (quantity * unit_price) AS amount,
        ROW_NUMBER() OVER (
            PARTITION BY invoice_no 
            ORDER BY (quantity * unit_price) DESC, stock_code ASC
        ) AS row_num
    FROM 
        retail_sales
)
SELECT 
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    amount,
    row_num
FROM 
    ranked_invoice_items
WHERE 
    row_num <= 3
ORDER BY 
    invoice_no ASC, 
    row_num ASC;