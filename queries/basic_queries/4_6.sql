SELECT c.customer_id, c.company_name, a.country
FROM customers1 c
JOIN addresses1 a ON c.address_id = a.address_id
WHERE c.company_name LIKE '%A%' AND a.country = 'Germany';