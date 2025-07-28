SELECT o.order_id, c.company_name, 
       ROUND(SUM(od.order_price * od.order_quantity * (1 - od.order_discount))::NUMERIC, 2) AS total_value
FROM orders1 o
JOIN customers1 c ON o.customer_id = c.customer_id
JOIN order_details1 od ON o.order_id = od.order_id
GROUP BY o.order_id, c.company_name
ORDER BY total_value DESC
LIMIT 5;