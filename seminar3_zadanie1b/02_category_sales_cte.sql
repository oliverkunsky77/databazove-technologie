WITH category_sales AS(
    SELECT product_category,
    SUM(total_amount) as total_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT * FROM category_sales ORDER BY total_sales DESC;