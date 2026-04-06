# 💫 Advanced SQL and Databases Portfolio

This project was completed as part of two tasks (SQL and Databases) at **Turing College**. The main goal is to showcase the SQL skills I gained during my studies, including both **basic** and     **advanced** queries.

**🌱 Skills demonstrated:**

- Writing and structuring SELECT queries with multiple JOINs
- Filtering, ordering, and grouping data efficiently
- Using aggregate functions (COUNT, SUM, AVG)
- Applying window functions, CTEs, and ranking
- Combining multiple tables for business insights and reporting

**🧱 Structure of Portfolio**

This portfolio is divided into two main sections:

- **Basic SQL** – product and work order analysis  
- **Advanced SQL** – customer insights and sales reporting  

## 🌍 Table of Contents

- [Data Source](##data-source)
- [Basic SQL](##basic-sql)
  - [Overview of Products](##overview-of-products)
- [Advanced SQL](##advanced-sql)
  - [Overview of Customers](##overview-of-customers)
  - [Reporting Sales Numbers](##reporting-sales-numbers)
- [Sample Results](##sample-results)
- [Technologies](##technologies)
- [Usage Instructions](##usage-instructions)
- [Next Steps](##next-steps)

## 🧳 Data Source

The queries are based on the **AdventureWorks 2005** demo database provided by Microsoft.

You can download the dataset here:  
[Microsoft Learn AdventureWorks Samples](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17)

## ⭐ Basic SQL

This section demonstrates my ability to work with core SQL concepts, including filtering, joining tables, ordering results, and using aggregate functions.

**Key tasks included:**

*1. Product Data Analysis*
- Retrieved product information from the Product table with relevant subcategory and category details.
- Applied filters and ordering to highlight specific products, including the most expensive bikes.

*2. Work Order Analysis*
- Aggregated data from the WorkOrderRouting table for January 2004.
- Calculated totals, unique counts, sums, and averages by LocationId.
- Filtered work orders based on cost thresholds for reporting purposes.

## ⭐ Advanced SQL

This section demonstrates my ability to handle complex SQL queries and business reporting scenarios using advanced techniques.

**Key tasks included:**

*1. Customer Overview*
- Created detailed reports for individual customers, including activity status, order history, and total amounts.
- Applied filters for top customers and active customers from specific regions.
- Split and formatted address data for clearer reporting.

*2. Sales Reporting*
- Generated monthly sales reports by country and region.
- Calculated cumulative totals and rankings using window functions.
- Incorporated country-level tax details and percentages to enhance reporting accuracy.

## 📚 Sample Results

Results are available here:
- [Basic SQL Results](basic-sql/results.md)
- [Advanced SQL Results](advanced-sql/results.md)

## 💻 Technologies
- SQL
- Excel (for exporting query results)
- GitHub

## 🔎 Usage Instructions

- Download the AdventureWorks demo database if you want to run the queries.
- Review SQL queries in basic-sql/queries.sql and advanced-sql/queries.sql.
- Check example results in results.md.

## ❔ Next Steps

- Add additional advanced analytics queries (e.g., time series, predictive metrics)
- Integrate visualizations for key insights
- Include a subset of CSV files for demonstration without requiring the full database
