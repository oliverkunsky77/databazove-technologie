CREATE INDEX idx_orders_region_category
ON orders (customer_id, order_date);
SELECT o.profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_name = 'Customer_25'
  AND c.region = 'West'
  AND o.order_date >= '2024-01-01';
