CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    sales_sum NUMERIC (10,2);
BEGIN
    SELECT SUM(sales)
    INTO sales_sum
    FROM orders
    WHERE start_date <= order_date AND end_date >= order_date;

RAISE NOTICE 'ZACIATOK OBDOBIA: % KONIEC OBDOBIA: % PREDAJ: %', start_date, end_date, sales_sum;
END;
$procedure$;
CALL get_sales_between('2024-01-01','2024-03-31')