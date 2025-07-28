DROP TABLE IF EXISTS order_details1 CASCADE;
DROP TABLE IF EXISTS orders1 CASCADE;
DROP TABLE IF EXISTS products1 CASCADE;
DROP TABLE IF EXISTS customers1 CASCADE;
DROP TABLE IF EXISTS us_states1 CASCADE;
DROP TABLE IF EXISTS employee_territories1 CASCADE;
DROP TABLE IF EXISTS territories1 CASCADE;
DROP TABLE IF EXISTS employees1 CASCADE;
DROP TABLE IF EXISTS suppliers1 CASCADE;
DROP TABLE IF EXISTS shippers1 CASCADE;
DROP TABLE IF EXISTS categories1 CASCADE;
DROP TABLE IF EXISTS region1 CASCADE;


-- Create independent tables
CREATE TABLE region1 (
    region_id SMALLINT NOT NULL PRIMARY KEY,
    region_name VARCHAR(60) NOT NULL
);

CREATE TABLE categories1 (
    category_id SMALLINT NOT NULL PRIMARY KEY,
    category_name VARCHAR(15) NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE shippers1 (
    shipper_id SMALLINT NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    phone VARCHAR(24) NOT NULL
);

CREATE TABLE suppliers1 (
    supplier_id SMALLINT NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30) NOT NULL,
    contact_title VARCHAR(30) NOT NULL,
    address VARCHAR(60) NOT NULL,
    city VARCHAR(15) NOT NULL,
    region VARCHAR(15),
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(15) NOT NULL,
    phone VARCHAR(24) NOT NULL,
    fax VARCHAR(24) NOT NULL
);

CREATE TABLE employees1 (
    employee_id SMALLINT NOT NULL PRIMARY KEY,
    last_name VARCHAR(20) NOT NULL,
    first_name VARCHAR(10) NOT NULL,
    title VARCHAR(30) NOT NULL,
    hire_date DATE NOT NULL,
    address VARCHAR(60) NOT NULL,
    city VARCHAR(15) NOT NULL,
    region VARCHAR(15),
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(15) NOT NULL,
    phone VARCHAR(24) NOT NULL,
    reports_to SMALLINT,
    notes TEXT NOT NULL
);

-- Create tables with dependencies
CREATE TABLE territories1 (
    territory_id VARCHAR(20) NOT NULL PRIMARY KEY,
    territory_name VARCHAR(60) NOT NULL,
    region_id SMALLINT NOT NULL
);

CREATE TABLE employee_territories1 (
    employee_id SMALLINT NOT NULL,
    territory_id VARCHAR(20) NOT NULL,
    PRIMARY KEY (employee_id, territory_id)
);

CREATE TABLE us_states1 (
    state_id SMALLINT NOT NULL PRIMARY KEY,
    state_name VARCHAR(100) NOT NULL,
    state_region SMALLINT NOT NULL
);

CREATE TABLE customers1 (
    customer_id VARCHAR(5) NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30) NOT NULL,
    contact_title VARCHAR(30) NOT NULL,
    address VARCHAR(60) NOT NULL,
    city VARCHAR(15) NOT NULL,
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15) NOT NULL,
    phone VARCHAR(24) NOT NULL,
    fax VARCHAR(24),
    region_id SMALLINT
);

CREATE TABLE products1 (
    product_id SMALLINT NOT NULL PRIMARY KEY,
    product_name VARCHAR(40) NOT NULL,
    supplier_id SMALLINT NOT NULL,
    category_id SMALLINT NOT NULL,
    quantity_per_unit VARCHAR(20) NOT NULL,
    unit_price FLOAT NOT NULL,
    units_in_stock SMALLINT NOT NULL,
    unit_on_order SMALLINT NOT NULL
);

CREATE TABLE orders1 (
    order_id SMALLINT NOT NULL PRIMARY KEY,
    customer_id VARCHAR(5) NOT NULL,
    employee_id SMALLINT NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date DATE,
    ship_via SMALLINT NOT NULL
);

CREATE TABLE order_details1 (
    order_id SMALLINT NOT NULL,
    product_id SMALLINT NOT NULL,
    order_price FLOAT NOT NULL,
    order_quantity SMALLINT NOT NULL,
    order_discount REAL NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, product_id)
);

-- Add foreign key constraints
ALTER TABLE employees1
    ADD CONSTRAINT fk_employees_reports_to FOREIGN KEY (reports_to) 
    REFERENCES employees1(employee_id);

ALTER TABLE territories1
    ADD CONSTRAINT fk_territories_region FOREIGN KEY (region_id) 
    REFERENCES region1(region_id);

ALTER TABLE employee_territories1
    ADD CONSTRAINT fk_employee_territories_employee FOREIGN KEY (employee_id) 
    REFERENCES employees1(employee_id),
    ADD CONSTRAINT fk_employee_territories_territory FOREIGN KEY (territory_id) 
    REFERENCES territories1(territory_id);

ALTER TABLE us_states1
    ADD CONSTRAINT fk_us_states_state_region FOREIGN KEY (state_region) 
    REFERENCES region1(region_id);

ALTER TABLE customers1
    ADD CONSTRAINT fk_customers_region FOREIGN KEY (region_id) 
    REFERENCES region1(region_id);

ALTER TABLE products1
    ADD CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id) 
    REFERENCES suppliers1(supplier_id),
    ADD CONSTRAINT fk_products_category FOREIGN KEY (category_id) 
    REFERENCES categories1(category_id);

ALTER TABLE orders1
    ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) 
    REFERENCES customers1(customer_id),
    ADD CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id) 
    REFERENCES employees1(employee_id),
    ADD CONSTRAINT fk_orders_shipper FOREIGN KEY (ship_via) 
    REFERENCES shippers1(shipper_id);

ALTER TABLE order_details1
    ADD CONSTRAINT fk_order_details_order FOREIGN KEY (order_id) 
    REFERENCES orders1(order_id),
    ADD CONSTRAINT fk_order_details_product FOREIGN KEY (product_id) 
    REFERENCES products1(product_id);

-- Add constraints
ALTER TABLE customers1 ADD CHECK (company_name <> '' AND contact_name <> '');
ALTER TABLE products1 ADD CHECK (unit_price >= 0 AND units_in_stock >= 0);
ALTER TABLE orders1 ADD CHECK (ship_via > 0);
ALTER TABLE order_details1 ADD CHECK (order_quantity > 0 AND order_discount >= 0 AND order_discount <= 1);