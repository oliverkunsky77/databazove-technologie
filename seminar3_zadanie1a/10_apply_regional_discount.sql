CREATE OR REPLACE PROCEDURE apply_regional_discount(
    p_region_name VARCHAR(20),
    p_discount_rate NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE ORDERS
    SET sales = sales * (1 - p_discount_rate)
    WHERE region = p_region_name;



RAISE NOTICE 'REGION:% DISCOUNT:%', p_region_name, p_discount_rate;
END;
$procedure$

CALL apply_regional_discount('West',0.10);
