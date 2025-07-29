# 🗃️ Sales Database Project using PostgreSQL

This project models and analyzes a sales order management system using PostgreSQL.  
It was developed as part of an academic course at Sharif University of Technology.

The goal is to extract data from an existing raw database (`shop.sql`), normalize the structure, and build a cleaner, well-structured schema for analysis.  
We then perform several types of SQL queries — from simple lookups to deeper analytical insights.

---

## 🧠 What This Project Covers

- Extracting data from an existing raw database
- Designing a new normalized schema (based on ERD and logical design)
- Creating tables and inserting normalized data
- Writing different SQL queries:
  - Basic queries (retrieving customers, orders, etc.)
  - Business logic queries (filtering, joins, grouping)
  - Analytical queries (segmentation, time-based performance)

---

## 🧰 Technologies Used

- PostgreSQL
- SQL (DDL, DML, Subqueries, Joins, Aggregates)
- Navicat (for GUI interaction)

---

## ⚙️ How to Use

To run this project locally in PostgreSQL:

1. **Run the raw data file first:**

   This creates the base tables and fills them with raw data.

   ```bash
   \i shop/shop.sql
   ```

2. **Run your normalized schema:**

   This will create new tables based on your ERD and insert data into them.

  ```bash
  \i schema/create_tables.sql
  ```

3. **Run query files (any order):**

   The rest of the .sql files in the queries/ folder can be run independently:

  - basic_queries.sql

  - business_queries.sql

  - analytics_queries.sql

## 📷 Preview
Example ER Diagram:

![Diagram - G5](https://github.com/user-attachments/assets/80568d86-0689-44af-8021-cc55ac7b0a78)

## 🎓 Academic Context
This project was completed in Spring 2025 as part of the Information Technology course
at the Industrial Engineering Department, Sharif University of Technology.

## 🧠 What I Learned
- Working with existing messy databases and restructuring them

- Creating normalized database schemas with PK/FK constraints

- Writing analytical SQL queries directly from a clean schema

## 📎 Notes
- The file shop.sql must be run first before anything else.

- All queries assume that the normalized schema has been successfully created and populated from the reference database.
