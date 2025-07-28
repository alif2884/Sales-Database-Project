SELECT e.first_name, e.last_name, COUNT(o.order_id) AS order_count
FROM employees1 e
LEFT JOIN orders1 o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(o.order_id) > 15
ORDER BY order_count DESC;