CREATE OR PROCEDURE get_customer_sales(
    p_customer_id VARCHAR(20)
)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_total NUMERIC(10,2);
    v_count INT;
BEGIN
    SELECT SUM(sales) 
    INTO v_total
    FROM orders
    WHERE customer_id = p_customer_id;
    SELECT COUNT(*)
    INTO v_count
    FROM orders
    WHERE customer_id = p_customer_id;
    RAISE NOTICE 'CUSTOMER_ID: %, POCET ZAZNAMOV: %, SALES: %', p_customer_id, v_count, v_total;
END;
$procedure$;

CALL get_customer_sales('C001');