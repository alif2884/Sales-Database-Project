# 🗃️ Sales Database Design & Analysis with PostgreSQL

A comprehensive sales order management system modeled and analyzed using PostgreSQL.  
Developed as part of an academic course at Sharif University of Technology.

---

## 🧠 Overview

This was my first experience designing a full relational database from raw retail data.  
The project involved data extraction, normalization into a clean schema, and writing SQL queries to analyze sales trends, customer behavior, and product categories.

---

## 🔎 Features

- Extraction of raw data from an existing database  
- Designing and implementing a normalized schema based on ER diagrams  
- Creating tables and inserting normalized data  
- Writing SQL queries across various levels:  
  - Basic retrieval queries (customers, orders)  
  - Business logic queries (filtering, joins, grouping)  
  - Analytical queries (segmentation, time-based performance)

---

## 🔧 Technologies / Topics

- PostgreSQL  
- SQL (DDL, DML, Subqueries, Joins, Aggregates)  
- Navicat (GUI tool for database management)

---

## ⚙️ How to Use

To run the project locally in PostgreSQL:

1. Run the raw data script to create and populate base tables:

   ```bash
   \i shop/shop.sql
   ```

2. Run the normalized schema script to create structured tables and insert data:

   ```bash
   \i schema/create_tables.sql
   ```

3. Run query scripts as needed (order does not matter):

   - `basic_queries.sql`  
   - `business_queries.sql`  
   - `analytics_queries.sql`  

---

## 📂 Files

- SQL scripts for schema creation and data loading  
- Sample analytical queries  
- Database diagram / ER model files

---

## 📷 Preview

The ER diagram is available both as an image and as an editable Navicat file.

![ER Diagram](https://github.com/user-attachments/assets/80568d86-0689-44af-8021-cc55ac7b0a78)

---

## 📎 Notes

- The original project documentation, including assignment instructions and explanations, is available in PDF format.  
- Ensure `shop.sql` is executed before running other scripts.  
- All queries assume the normalized schema is properly created and populated.
