# HR ETL Pipeline Project

This repository contains the ETL (Extract, Transform, Load) process for the HR database project, and its purpose is to build a normalized relational database that supports workforce analysis and employee attrition insights for NYTech.co, a fictional company facing employee attrition issues.

## Project Overview

Our team designed a PostgreSQL-based HR database in full compliance with the 3rd Normal Form (3NF). This system allows the company to efficiently store, query, and visualize human resource data, including:

- Demographics
- Education and job roles
- Salary components and compensation
- Work experience and engagement metrics
- Attrition and performance indicators

We used Python for the ETL pipeline and loaded the cleaned data into **PostgreSQL (pgAdmin4)**. The final database supports structured analysis through **SQL queries** and **Metabase dashboards**.

*Specific data information can be found in the kaggle **IBM Employee Dataset:** https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset

---

## Technologies Used

- **Python 3.11.7**
- **Environment conda**
- **Pandas** for data transforming
- **SQLAlchemy / psycopg2** for PostgreSQL connection
- **PostgreSQL (pgAdmin4)** for relational database
- **GitHub** for version control

---
## Reasoning
- Extract: We chose the kaggle IBM employee data because it has many variables and a wide variety.
  
- Transform: We use pandas to process our raw csv data, the steps include setting up unique primary keys, eliminating duplicate lines, mapping, etc., because pandas can handle such csv files very well.
  
- Loading: We use the sqlalchemy package to interact with pgAdmin4 to create the table schema and use its accompanying ‘to.sql’ function to load the data. The reason is that our dataset is highly structured, and PostgreSQL is ideal for storing this data and performing subsequent queries.


