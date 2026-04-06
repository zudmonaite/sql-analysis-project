# 💫 Advanced SQL and Databases Portfolio

This project was completed as part of two tasks (SQL and Databases) at **Turing College**. The main goal is to showcase the SQL skills I gained during my studies, including both **basic** and     **advanced** queries.

**🌱 Skills demonstrated:**

- Writing and structuring SELECT queries with multiple JOINs
- Filtering, ordering, and grouping data efficiently
- Using aggregate functions (COUNT, SUM, AVG)
- Applying window functions and ranking
- Combining multiple tables for business insights and reporting

## 🌍 Table of Contents
1. [About the Project](#about-the-project)
2. [Data Source](#data-source)
3. [Basic SQL](#basic-sql)
   - [Overview of Products](#overview-of-products)
4. [Advanced SQL](#advanced-sql)
   - [Overview of Customers](#overview-of-customers)
   - [Reporting Sales Numbers](#reporting-sales-numbers)
5. [Sample Results](#sample-results)
6. [Technologies](#technologies)
7. [Usage Instructions](#usage-instructions)
8. [Next Steps](#next-steps)

## 1. About the Project

This portfolio demonstrates my SQL abilities across multiple areas:
- **Basic SQL**: SELECT, WHERE, JOIN, GROUP BY, aggregate functions
- **Advanced SQL**: CTEs, Window functions, ranking, cumulative sums, complex business reporting
- Query results were exported from Google Sheets, as I do not have direct access to the full database.

## 2. Data Source

The queries are based on the **AdventureWorks 2005** demo database (Microsoft).
Download the AdventureWorks demo database here: [Microsoft Learn AdventureWorks Samples](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17)

## 3. Basic SQL

This section demonstrates my ability to work with core SQL concepts, including filtering, joining tables, ordering results, and using aggregate functions.

**Key tasks included:**

  1. Product Data Analysis
Retrieved product information from the Product table with relevant subcategory and category details.
Applied filters and ordering to highlight specific products, including the most expensive bikes.

  2. Work Order Analysis
Aggregated data from the WorkOrderRouting table for January 2004.
Calculated totals, unique counts, sums, and averages by LocationId.
Filtered work orders based on cost thresholds for reporting purposes.

## 4. Advanced SQL

This section demonstrates my ability to handle complex SQL queries and business reporting scenarios using advanced techniques.

**Key tasks included:**

  1. Customer Overview
  - Created detailed reports for individual customers, including activity status, order history, and total amounts.
  - Applied filters for top customers and active customers from specific regions.
  - Split and formatted address data for clearer reporting.

  2. Sales Reporting
  - Generated monthly sales reports by country and region.
  - Calculated cumulative totals and rankings using window functions.
  - Incorporated country-level tax details and percentages to enhance reporting accuracy.

## 5. Sample Results

Results are provided in basic-sql/results.md and advanced-sql/results.md.

## 6. Technologies
- SQL Server / T-SQL
- Google Sheets (for exporting results)

## 7. Usage Instructions

- Download the AdventureWorks demo database if you want to run the queries.
- Review SQL queries in basic-sql/queries.sql and advanced-sql/queries.sql.
- Check example results in results.md.

## 8. Next Steps

- Add additional advanced analytics queries (e.g., time series, predictive metrics)
- Integrate visualizations for key insights
- Include a subset of CSV files for demonstration without requiring the full database



