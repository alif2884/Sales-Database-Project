SELECT p.product_id, p.product_name, s.company_name AS supplier_name, c.category_name
FROM products1 p
LEFT JOIN suppliers1 s ON p.supplier_id = s.supplier_id
LEFT JOIN categories1 c ON p.category_id = c.category_id
ORDER BY p.product_name;