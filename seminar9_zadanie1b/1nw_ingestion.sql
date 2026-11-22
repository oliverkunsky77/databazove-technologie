BEGIN;

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.categories (
    categoryid INT PRIMARY KEY,
    categoryname TEXT NOT NULL,
    description TEXT NOT NULL,
    _source_file TEXT DEFAULT 'categories.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.customers (
    customerid INT PRIMARY KEY,
    customername TEXT NOT NULL,
    contactname TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    postalcode TEXT,
    country TEXT NOT NULL,
    _source_file TEXT DEFAULT 'customers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.employees (
    employeeid INT PRIMARY KEY,
    lastname TEXT NOT NULL,
    firstname TEXT NOT NULL,
    birthdate DATE NOT NULL,
    photo TEXT NOT NULL,
    notes TEXT NOT NULL,
    _source_file TEXT DEFAULT 'employees.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.shippers (
    shipperid INT PRIMARY KEY,
    shippername TEXT NOT NULL,
    phone TEXT NOT NULL,
    _source_file TEXT DEFAULT 'shippers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.suppliers (
    supplierid INT PRIMARY KEY,
    suppliername TEXT NOT NULL,
    contactname TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    postalcode TEXT NOT NULL,
    country TEXT NOT NULL,
    phone TEXT NOT NULL,
    _source_file TEXT DEFAULT 'suppliers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.products (
    productid INT PRIMARY KEY,
    productname TEXT NOT NULL,
    supplierid INT NOT NULL REFERENCES bronze.suppliers (supplierid),
    categoryid INT NOT NULL REFERENCES bronze.categories (categoryid),
    unit TEXT NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    _source_file TEXT DEFAULT 'products.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.orders (
    orderid INT PRIMARY KEY,
    customerid INT NOT NULL REFERENCES bronze.customers (customerid),
    employeeid INT NOT NULL REFERENCES bronze.employees (employeeid),
    orderdate TIMESTAMP(0) NOT NULL,
    shipperid INT NOT NULL REFERENCES bronze.shippers (shipperid),
    _source_file TEXT DEFAULT 'orders.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.orderdetails (
    orderdetailid INT PRIMARY KEY,
    orderid INT NOT NULL REFERENCES bronze.orders (orderid),
    productid INT NOT NULL REFERENCES bronze.products (productid),
    quantity INT NOT NULL,
    _source_file TEXT DEFAULT 'orderdetails.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

TRUNCATE TABLE
    bronze.orderdetails,
    bronze.orders,
    bronze.products,
    bronze.suppliers,
    bronze.shippers,
    bronze.employees,
    bronze.customers,
    bronze.categories;

COPY bronze.categories (categoryid, categoryname, description)
FROM 'C:/Users/Gabriel/Desktop/northwind/categories.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COPY bronze.customers (customerid, customername, contactname, address, city, postalcode, country)
FROM 'C:/Users/Gabriel/Desktop/northwind/customers.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COPY bronze.employees (employeeid, lastname, firstname, birthdate, photo, notes)
FROM 'C:/Users/Gabriel/Desktop/northwind/employees.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COPY bronze.shippers (shipperid, shippername, phone)
FROM 'C:/Users/Gabriel/Desktop/northwind/shippers.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COPY bronze.suppliers (supplierid, suppliername, contactname, address, city, postalcode, country, phone)
FROM 'C:/Users/Gabriel/Desktop/northwind/suppliers.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COPY bronze.products (productid, productname, supplierid, categoryid, unit, price)
FROM 'C:/Users/Gabriel/Desktop/northwind/products.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COPY bronze.orders (orderid, customerid, employeeid, orderdate, shipperid)
FROM 'C:/Users/Gabriel/Desktop/northwind/orders.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COPY bronze.orderdetails (orderdetailid, orderid, productid, quantity)
FROM 'C:/Users/Gabriel/Desktop/northwind/orderdetails.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', ENCODING 'UTF8');

COMMIT;