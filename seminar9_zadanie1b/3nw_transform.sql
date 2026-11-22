BEGIN;

CREATE SCHEMA IF NOT EXISTS gold;

CREATE TABLE IF NOT EXISTS gold.dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    contact_name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    country TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_product (
    product_id INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    product_unit TEXT NOT NULL,
    supplier_id INT NOT NULL,
    supplier_name TEXT NOT NULL,
    supplier_contact_name TEXT NOT NULL,
    supplier_city TEXT NOT NULL,
    supplier_country TEXT NOT NULL,
    category_id INT NOT NULL,
    category_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_employee (
    employee_id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_shipper (
    shipper_id INT PRIMARY KEY,
    shipper_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_date (
    date_id INT PRIMARY KEY,
    order_date DATE NOT NULL UNIQUE,
    day INT NOT NULL,
    weekday INT NOT NULL,
    year INT NOT NULL,
    iso_year INT NOT NULL,
    week INT NOT NULL,
    month INT NOT NULL,
    month_name TEXT NOT NULL,
    quarter INT NOT NULL,
    quarter_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_time (
    time_id INT PRIMARY KEY,
    order_time TIME(0) NOT NULL UNIQUE,
    second INT NOT NULL,
    minute INT NOT NULL,
    hour INT NOT NULL,
    hour_12 INT NOT NULL,
    am_pm CHAR(2) NOT NULL,
    part_of_day TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.fact_orders (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    quantity INT NOT NULL,
    product_price NUMERIC(10, 2) NOT NULL,
    sales_amount NUMERIC(10, 2) NOT NULL,
    product_id INT NOT NULL REFERENCES gold.dim_product (product_id),
    customer_id INT NOT NULL REFERENCES gold.dim_customer (customer_id),
    employee_id INT NOT NULL REFERENCES gold.dim_employee (employee_id),
    shipper_id INT NOT NULL REFERENCES gold.dim_shipper (shipper_id),
    date_id INT NOT NULL REFERENCES gold.dim_date (date_id),
    time_id INT NOT NULL REFERENCES gold.dim_time (time_id)
);

TRUNCATE TABLE
    gold.fact_orders,
    gold.dim_customer,
    gold.dim_product,
    gold.dim_employee,
    gold.dim_shipper,
    gold.dim_date,
    gold.dim_time;

INSERT INTO gold.dim_customer (
    customer_id, customer_name, contact_name, address, city, country
)
SELECT customer_id, customer_name, contact_name, address, city, country
FROM silver.stg_customers;

INSERT INTO gold.dim_product (
    product_id, product_name, product_unit,
    supplier_id, supplier_name, supplier_contact_name, supplier_city, supplier_country,
    category_id, category_name
)
SELECT
    p.product_id,
    p.product_name,
    p.product_unit,
    s.supplier_id,
    s.supplier_name,
    s.contact_name,
    s.city,
    s.country,
    c.category_id,
    c.category_name
FROM silver.stg_products p
JOIN silver.stg_suppliers s ON s.supplier_id = p.supplier_id
JOIN silver.stg_categories c ON c.category_id = p.category_id;

INSERT INTO gold.dim_employee (employee_id, first_name, last_name, birth_date)
SELECT employee_id, first_name, last_name, birth_date
FROM silver.stg_employees;

INSERT INTO gold.dim_shipper (shipper_id, shipper_name)
SELECT shipper_id, shipper_name
FROM silver.stg_shippers;

INSERT INTO gold.dim_date (
    date_id, order_date, day, weekday, year, iso_year, week,
    month, month_name, quarter, quarter_name
)
SELECT
    TO_CHAR(d.order_date, 'YYYYMMDD')::INT,
    d.order_date,
    EXTRACT(DAY FROM d.order_date)::INT,
    EXTRACT(ISODOW FROM d.order_date)::INT,
    EXTRACT(YEAR FROM d.order_date)::INT,
    EXTRACT(ISOYEAR FROM d.order_date)::INT,
    EXTRACT(WEEK FROM d.order_date)::INT,
    EXTRACT(MONTH FROM d.order_date)::INT,
    TO_CHAR(d.order_date, 'FMMonth'),
    EXTRACT(QUARTER FROM d.order_date)::INT,
    TO_CHAR(d.order_date, '"Q"Q')
FROM (
    SELECT DISTINCT order_date::DATE AS order_date
    FROM silver.stg_orders
) d;

INSERT INTO gold.dim_time (
    time_id, order_time, second, minute, hour, hour_12, am_pm, part_of_day
)
SELECT DISTINCT
    TO_CHAR(o.order_date, 'HH24MISS')::INT,
    o.order_date::TIME(0),
    EXTRACT(SECOND FROM o.order_date)::INT,
    EXTRACT(MINUTE FROM o.order_date)::INT,
    EXTRACT(HOUR FROM o.order_date)::INT,
    TO_CHAR(o.order_date, 'HH12')::INT,
    TO_CHAR(o.order_date, 'AM'),
    CASE
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 5 AND 11 THEN 'MORNING'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 18 AND 21 THEN 'EVENING'
        ELSE 'NIGHT'
    END
FROM silver.stg_orders o;

INSERT INTO gold.fact_orders (
    order_detail_id, order_id, quantity, product_price, sales_amount,
    product_id, customer_id, employee_id, shipper_id, date_id, time_id
)
SELECT
    od.order_detail_id,
    od.order_id,
    od.quantity,
    p.price,
    od.quantity * p.price,
    od.product_id,
    o.customer_id,
    o.employee_id,
    o.shipper_id,
    d.date_id,
    t.time_id
FROM silver.stg_orderdetails od
JOIN silver.stg_orders o ON o.order_id = od.order_id
JOIN silver.stg_products p ON p.product_id = od.product_id
JOIN gold.dim_date d ON d.order_date = o.order_date::DATE
JOIN gold.dim_time t ON t.order_time = o.order_date::TIME(0);

CREATE INDEX IF NOT EXISTS idx_fact_orders_product ON gold.fact_orders (product_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_customer ON gold.fact_orders (customer_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_employee ON gold.fact_orders (employee_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_shipper ON gold.fact_orders (shipper_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_date ON gold.fact_orders (date_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_time ON gold.fact_orders (time_id);

COMMIT;
