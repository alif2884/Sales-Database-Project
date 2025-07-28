SELECT o.order_id, o.customer_id, o.order_date, a.country
FROM orders1 o
JOIN customers1 c ON o.customer_id = c.customer_id
JOIN addresses1 a ON c.address_id = a.address_id
WHERE a.country = 'Germany';