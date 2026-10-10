CREATE INDEX idx_orders_order_date
ON orders(order_date);

SELECT 
DATE_TRUNC('month', order_date) as order_month, 
SUM(sales) as monthly_sales FROM orders GROUP BY order_month ORDER BY order_month ASC;
