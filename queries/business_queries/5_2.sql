SELECT p.product_id, p.product_name, s.company_name AS supplier_name, c.category_name,
       ROUND(p.unit_price::NUMERIC, 2) AS unit_price
FROM products1 p
JOIN suppliers1 s ON p.supplier_id = s.supplier_id
JOIN categories1 c ON p.category_id = c.category_id
WHERE p.unit_price > (SELECT AVG(unit_price) FROM products1)
ORDER BY p.unit_price DESC;