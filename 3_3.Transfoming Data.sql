-- add Midwest for mapping
INSERT INTO region1 (region_id, region_name)
SELECT region_id, region_description AS region_name
FROM region
UNION
SELECT 5, 'Midwest';

INSERT INTO categories1 (category_id, category_name, description)
SELECT category_id, category_name, description
FROM categories;

INSERT INTO shippers1 (shipper_id, company_name, phone)
SELECT shipper_id, company_name, phone
FROM shippers;

INSERT INTO suppliers1 (supplier_id, company_name, contact_name, contact_title)
SELECT supplier_id, company_name, contact_name, contact_title
FROM suppliers;

INSERT INTO employees1 (employee_id, last_name, first_name, title, hire_date, reports_to, notes)
SELECT employee_id, last_name, first_name, title, hire_date, reports_to, notes
FROM employees;

INSERT INTO positions1 (employee_id, title)
SELECT employee_id, title
FROM employees;

INSERT INTO territories1 (territory_id, territory_name, region_id)
SELECT territory_id, territory_description AS territory_name, region_id
FROM territories;

INSERT INTO employee_territories1 (employee_id, territory_id)
SELECT employee_id, territory_id
FROM employee_territories;


-- map state_region to region_id
INSERT INTO us_states1 (state_id, state_name, state_region)
SELECT 
    state_id,
    state_name,
    CASE 
        WHEN state_region = 'east' THEN 1
        WHEN state_region = 'west' THEN 2
        WHEN state_region = 'north' THEN 3
        WHEN state_region = 'south' THEN 4
        WHEN state_region = 'midwest' THEN 2
        ELSE 1
    END AS state_region
FROM us_states;

INSERT INTO customers1 (customer_id, company_name, contact_name, contact_title, region_id)
SELECT 
    customer_id,
    company_name,
    contact_name,
    contact_title,
    COALESCE(
        CASE 
            WHEN country = 'USA' THEN 
                (SELECT CASE 
                            WHEN s.state_region = 'east' THEN 1
                            WHEN s.state_region = 'west' THEN 2
                            WHEN s.state_region = 'north' THEN 3
                            WHEN s.state_region = 'south' THEN 4
                            WHEN s.state_region = 'midwest' THEN 2
                         END
                 FROM us_states s 
                 WHERE s.state_name = c.region LIMIT 1)
            ELSE 1
        END,
        1
    ) AS region_id
FROM customers c;

INSERT INTO products1 (product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order)
SELECT 
    product_id,
    product_name,
    supplier_id,
    category_id,
    quantity_per_unit,
    unit_price,
    units_in_stock,
    units_on_order
FROM products
WHERE supplier_id IS NOT NULL AND category_id IS NOT NULL;

INSERT INTO orders1 (order_id, customer_id, employee_id, order_date, required_date, shipped_date, ship_via)
SELECT 
    o.order_id,
    o.customer_id,
    o.employee_id,
    o.order_date,
    o.required_date,
    o.shipped_date,
    o.ship_via
FROM orders o
JOIN customers1 c ON o.customer_id = c.customer_id
JOIN employees1 e ON o.employee_id = e.employee_id
JOIN shippers1 s ON o.ship_via = s.shipper_id
WHERE o.order_date IS NOT NULL;

INSERT INTO order_details1 (order_id, product_id, order_price, order_quantity, order_discount)
SELECT od.order_id, od.product_id, od.unit_price AS order_price, od.quantity AS order_quantity, od.discount AS order_discount
FROM order_details od
JOIN orders1 o ON od.order_id = o.order_id
JOIN products1 p ON od.product_id = p.product_id;


-- Insert addresses
INSERT INTO addresses1 (customer_id, address, city, postal_code, country, region)
SELECT 
    customer_id,
    address,
    city,
    COALESCE(postal_code, 'Unknown') AS postal_code,
    country,
    COALESCE(region, 'Unknown') AS region
FROM customers;

INSERT INTO addresses1 (supplier_id, address, city, postal_code, country, region)
SELECT 
    supplier_id,
    address,
    city,
    COALESCE(postal_code, 'Unknown') AS postal_code,
    country,
    COALESCE(region, 'Unknown') AS region
FROM suppliers;

INSERT INTO addresses1 (employee_id, address, city, postal_code, country, region)
SELECT 
    employee_id,
    address,
    city,
    postal_code,
    country,
    COALESCE(region, 'Unknown') AS region
FROM employees;



-- Insert contacts
INSERT INTO contacts1 (customer_id, phone, fax)
SELECT 
    customer_id,
    phone,
    COALESCE(fax, 'Unknown') AS fax
FROM customers
WHERE phone IS NOT NULL OR fax IS NOT NULL;

INSERT INTO contacts1 (supplier_id, phone, fax)
SELECT 
    supplier_id,
    phone,
    COALESCE(fax, 'Unknown') AS fax
FROM suppliers
WHERE phone IS NOT NULL OR fax IS NOT NULL;

INSERT INTO contacts1 (employee_id, phone, fax)
SELECT 
    employee_id,
    home_phone AS phone,
    COALESCE(NULL, 'Unknown') AS fax
FROM employees
WHERE home_phone IS NOT NULL;

-- Update suppliers1, employees1, and customers1 with address_id and contact_id
UPDATE suppliers1 s
SET 
    address_id = (SELECT address_id FROM addresses1 a WHERE a.supplier_id = s.supplier_id LIMIT 1),
    contact_id = (SELECT contact_id FROM contacts1 c WHERE c.supplier_id = s.supplier_id LIMIT 1);

UPDATE employees1 e
SET 
    address_id = (SELECT address_id FROM addresses1 a WHERE a.employee_id = e.employee_id LIMIT 1),
    contact_id = (SELECT contact_id FROM contacts1 c WHERE c.employee_id = e.employee_id LIMIT 1);

UPDATE customers1 c
SET 
    address_id = (SELECT address_id FROM addresses1 a WHERE a.customer_id = c.customer_id LIMIT 1),
    contact_id = (SELECT contact_id FROM contacts1 con WHERE con.customer_id = c.customer_id LIMIT 1);