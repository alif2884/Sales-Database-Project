SELECT e.employee_id, e.first_name, e.last_name, p.title
FROM employees1 e
LEFT JOIN positions1 p ON e.employee_id = p.employee_id;