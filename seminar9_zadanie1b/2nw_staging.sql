BEGIN;

CREATE SCHEMA IF NOT EXISTS silver;

CREATE OR REPLACE VIEW silver.stg_categories AS
SELECT
    categoryid AS category_id,
    BTRIM(categoryname) AS category_name,
    BTRIM(description) AS description
FROM bronze.categories;

CREATE OR REPLACE VIEW silver.stg_customers AS
SELECT
    customerid AS customer_id,
    BTRIM(customername) AS customer_name,
    BTRIM(contactname) AS contact_name,
    BTRIM(address) AS address,
    BTRIM(city) AS city,
    NULLIF(BTRIM(postalcode), '') AS postal_code,
    BTRIM(country) AS country
FROM bronze.customers;

CREATE OR REPLACE VIEW silver.stg_employees AS
SELECT
    employeeid AS employee_id,
    BTRIM(lastname) AS last_name,
    BTRIM(firstname) AS first_name,
    birthdate AS birth_date,
    BTRIM(photo) AS photo,
    BTRIM(notes) AS notes
FROM bronze.employees;

CREATE OR REPLACE VIEW silver.stg_shippers AS
SELECT
    shipperid AS shipper_id,
    BTRIM(shippername) AS shipper_name,
    BTRIM(phone) AS phone
FROM bronze.shippers;

CREATE OR REPLACE VIEW silver.stg_suppliers AS
SELECT
    supplierid AS supplier_id,
    BTRIM(suppliername) AS supplier_name,
    BTRIM(contactname) AS contact_name,
    BTRIM(address) AS address,
    BTRIM(city) AS city,
    BTRIM(postalcode) AS postal_code,
    BTRIM(country) AS country,
    BTRIM(phone) AS phone
FROM bronze.suppliers;

CREATE OR REPLACE VIEW silver.stg_products AS
SELECT
    productid AS product_id,
    BTRIM(productname) AS product_name,
    supplierid AS supplier_id,
    categoryid AS category_id,
    BTRIM(unit) AS product_unit,
    price
FROM bronze.products;

CREATE OR REPLACE VIEW silver.stg_orders AS
SELECT
    orderid AS order_id,
    customerid AS customer_id,
    employeeid AS employee_id,
    orderdate AS order_date,
    shipperid AS shipper_id
FROM bronze.orders;

CREATE OR REPLACE VIEW silver.stg_orderdetails AS
SELECT
    orderdetailid AS order_detail_id,
    orderid AS order_id,
    productid AS product_id,
    quantity
FROM bronze.orderdetails;

COMMIT;
