SELECT 
    c.customer_id, 
    c.company_name, 
    ROUND(SUM(od.order_price * od.order_quantity * (1 - od.order_discount))::NUMERIC, 2) AS total_spent
FROM customers1 c
JOIN orders1 o ON c.customer_id = o.customer_id
JOIN order_details1 od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_spent DESC
LIMIT 5;