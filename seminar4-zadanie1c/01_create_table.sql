CREATE TABLE retail_sales(
    invoice_no VARCHAR(20) PRIMARY KEY,
    stock_code VARCHAR(50),
    description VARCHAR(500),
    quantity INT,
    invoice_date DATE,
    unit_price NUMERIC(10,2),
    customer_id INT,
    country VARCHAR(100)
);

SELECT * FROM retail_sales;

