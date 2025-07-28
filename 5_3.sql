SELECT o.order_id, 
       ROUND(SUM(od.order_price * od.order_quantity * (1 - od.order_discount))::NUMERIC, 2) AS total_amount,
       o.order_date,
       o.required_date
FROM orders1 o
JOIN order_details1 od ON o.order_id = od.order_id
GROUP BY o.order_id, o.order_date, o.required_date
ORDER BY o.order_id;