CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

SELECT *
FROM ORDERS
WHERE customer_id = 'C001';
