WITH total_product_sales AS (
    SELECT 
        product_category,
        product_name,
        SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY product_category, product_name
),
category_rank AS (
    SELECT 
        product_category,
        product_name,
        total_product_sales,
        RANK() OVER (
            PARTITION BY product_category 
            ORDER BY total_product_sales DESC
        ) AS category_rank
    FROM total_product_sales
)
SELECT 
    product_category,
    total_product_sales,
    category_rank
FROM category_rank
WHERE category_rank BETWEEN 1 AND 3
ORDER BY product_category ASC, category_rank ASC;