SELECT e.employee_id, e.first_name, e.last_name,
       COUNT(o.order_id) AS total_orders_processed,
       ROUND(AVG(o.shipped_date - o.order_date), 2) AS avg_processing_days,
       RANK() OVER (ORDER BY AVG(o.shipped_date - o.order_date)) AS speed_rank
FROM employees1 e
LEFT JOIN orders1 o ON e.employee_id = o.employee_id
WHERE o.shipped_date IS NOT NULL AND o.order_date IS NOT NULL
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY avg_processing_days;