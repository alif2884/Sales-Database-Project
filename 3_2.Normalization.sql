DROP TABLE IF EXISTS order_details1 CASCADE;
DROP TABLE IF EXISTS orders1 CASCADE;
DROP TABLE IF EXISTS products1 CASCADE;
DROP TABLE IF EXISTS customers1 CASCADE;
DROP TABLE IF EXISTS us_states1 CASCADE;
DROP TABLE IF EXISTS employee_territories1 CASCADE;
DROP TABLE IF EXISTS territories1 CASCADE;
DROP TABLE IF EXISTS positions1 CASCADE;
DROP TABLE IF EXISTS contacts1 CASCADE;
DROP TABLE IF EXISTS addresses1 CASCADE;
DROP TABLE IF EXISTS employees1 CASCADE;
DROP TABLE IF EXISTS suppliers1 CASCADE;

-- The Region, Shippers, and Categories columns remain unchanged

-- Create tables in order of dependencies

CREATE TABLE suppliers1 (
    supplier_id SMALLINT NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30) NOT NULL,
    contact_title VARCHAR(30) NOT NULL,
    address_id INT,
    contact_id INT
);

CREATE TABLE employees1 (
    employee_id SMALLINT NOT NULL PRIMARY KEY,
    last_name VARCHAR(20) NOT NULL,
    first_name VARCHAR(10) NOT NULL,
    title VARCHAR(30) NOT NULL,
    hire_date DATE NOT NULL,
    reports_to SMALLINT,
    address_id INT,
    contact_id INT,
    notes TEXT NOT NULL
);

-- Positions table (depends on employees1)
CREATE TABLE positions1 (
    position_id SERIAL NOT NULL PRIMARY KEY,
    employee_id SMALLINT NOT NULL,
    title VARCHAR(30) NOT NULL
);

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
    region_id SMALLINT NOT NULL,
    address_id INT,
    contact_id INT
);

-- Addresses table (depends on suppliers1, customers1, and employees1)
CREATE TABLE addresses1 (
    address_id SERIAL NOT NULL PRIMARY KEY,
    supplier_id SMALLINT,
    customer_id VARCHAR(5),
    employee_id SMALLINT,
    address VARCHAR(60) NOT NULL,
    city VARCHAR(15) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(15) NOT NULL,
    region VARCHAR(15)
);

-- Contacts table (depends on suppliers1, customers1, and employees1)
CREATE TABLE contacts1 (
    contact_id SERIAL NOT NULL PRIMARY KEY,
    supplier_id SMALLINT,
    customer_id VARCHAR(5),
    employee_id SMALLINT,
    phone VARCHAR(24) NOT NULL,
    fax VARCHAR(24)
);

CREATE TABLE products1 (
    product_id SMALLINT NOT NULL PRIMARY KEY,
    product_name VARCHAR(40) NOT NULL,
    supplier_id SMALLINT NOT NULL,
    category_id SMALLINT NOT NULL,
    quantity_per_unit VARCHAR(20) NOT NULL,
    unit_price FLOAT NOT NULL,
    units_in_stock SMALLINT NOT NULL,
    units_on_order SMALLINT NOT NULL
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

-- Add FOREIGN KEY constraints
ALTER TABLE employees1
    ADD FOREIGN KEY (reports_to) REFERENCES employees1(employee_id);

ALTER TABLE positions1
    ADD FOREIGN KEY (employee_id) REFERENCES employees1(employee_id);

ALTER TABLE territories1
    ADD FOREIGN KEY (region_id) REFERENCES region1(region_id);

ALTER TABLE employee_territories1
    ADD FOREIGN KEY (employee_id) REFERENCES employees1(employee_id),
    ADD FOREIGN KEY (territory_id) REFERENCES territories1(territory_id);

ALTER TABLE us_states1
    ADD FOREIGN KEY (state_region) REFERENCES region1(region_id);

ALTER TABLE customers1
    ADD FOREIGN KEY (address_id) REFERENCES addresses1(address_id),
    ADD FOREIGN KEY (contact_id) REFERENCES contacts1(contact_id),
    ADD FOREIGN KEY (region_id) REFERENCES region1(region_id);

ALTER TABLE suppliers1
    ADD FOREIGN KEY (address_id) REFERENCES addresses1(address_id),
    ADD FOREIGN KEY (contact_id) REFERENCES contacts1(contact_id);

ALTER TABLE employees1
    ADD FOREIGN KEY (address_id) REFERENCES addresses1(address_id),
    ADD FOREIGN KEY (contact_id) REFERENCES contacts1(contact_id);

ALTER TABLE addresses1
    ADD FOREIGN KEY (supplier_id) REFERENCES suppliers1(supplier_id),
    ADD FOREIGN KEY (customer_id) REFERENCES customers1(customer_id),
    ADD FOREIGN KEY (employee_id) REFERENCES employees1(employee_id);

ALTER TABLE contacts1
    ADD FOREIGN KEY (supplier_id) REFERENCES suppliers1(supplier_id),
    ADD FOREIGN KEY (customer_id) REFERENCES customers1(customer_id),
    ADD FOREIGN KEY (employee_id) REFERENCES employees1(employee_id);

ALTER TABLE products1
    ADD FOREIGN KEY (supplier_id) REFERENCES suppliers1(supplier_id),
    ADD FOREIGN KEY (category_id) REFERENCES categories1(category_id);

ALTER TABLE orders1
    ADD FOREIGN KEY (customer_id) REFERENCES customers1(customer_id),
    ADD FOREIGN KEY (employee_id) REFERENCES employees1(employee_id),
    ADD FOREIGN KEY (ship_via) REFERENCES shippers1(shipper_id);

ALTER TABLE order_details1
    ADD FOREIGN KEY (order_id) REFERENCES orders1(order_id),
    ADD FOREIGN KEY (product_id) REFERENCES products1(product_id);

-- Add constraints
ALTER TABLE addresses1 ADD CHECK (address <> '' AND city <> '' AND postal_code <> '');
ALTER TABLE contacts1 ADD CHECK (phone <> '');
ALTER TABLE positions1 ADD CHECK (title <> '');
ALTER TABLE customers1 ADD CHECK (company_name <> '' AND contact_name <> '');
ALTER TABLE suppliers1 ADD CHECK (company_name <> '' AND contact_name <> '');
ALTER TABLE products1 ADD CHECK (unit_price >= 0 AND units_in_stock >= 0 AND units_on_order >= 0);
ALTER TABLE orders1 ADD CHECK (ship_via > 0);
ALTER TABLE order_details1 ADD CHECK (order_quantity > 0 AND order_discount >= 0 AND order_discount <= 1);