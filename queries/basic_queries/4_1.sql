SELECT c.customer_id, c.company_name, a.country
FROM customers1 c
LEFT JOIN addresses1 a ON c.address_id = a.address_id;