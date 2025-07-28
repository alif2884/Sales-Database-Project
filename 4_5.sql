SELECT product_id, product_name, ROUND(unit_price::NUMERIC, 2) AS unit_price
FROM products1
WHERE unit_price > 50;