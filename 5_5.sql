SELECT c.customer_id, c.company_name, COUNT(DISTINCT a.country) AS country_count
FROM customers1 c
JOIN orders1 o ON c.customer_id = o.customer_id
JOIN addresses1 a ON c.address_id = a.address_id
GROUP BY c.customer_id, c.company_name
HAVING COUNT(DISTINCT a.country) >= 5
ORDER BY country_count DESC;