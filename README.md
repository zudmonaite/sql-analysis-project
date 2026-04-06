# Advanced SQL and Databases Portfolio

## Executive Summary

This project was completed as part of two tasks (SQL and Databases) at **Turing College**. The main goal is to showcase the SQL skills I gained during my studies, including both **basic** and **advanced** queries.

## Table of Contents
  1. About the Project
  2. Data Source
  3. Basic SQL
    3.1 Overview of Products
  4. Advanced SQL
    4.1 Overview of Customers
    4.2 Reporting Sales Numbers
  5. Sample Results
  6. Technologies
  7. Usage Instructions
  8. Next Steps

## About the Project

This portfolio demonstrates my SQL abilities across multiple areas:
- **Basic SQL**: SELECT, WHERE, JOIN, GROUP BY, aggregate functions
- **Advanced SQL**: CTEs, Window functions, ranking, cumulative sums, complex business reporting
- Query results were exported from Google Sheets, as I do not have direct access to the full database.

## Data Source

The queries are based on the **AdventureWorks 2005** demo database (Microsoft).
Download the AdventureWorks demo database here: [Microsoft Learn AdventureWorks Samples](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17)

## Basic SQL

This section demonstrates my ability to work with core SQL concepts, including filtering, joining tables, ordering results, and using aggregate functions.

**Key tasks included:**

  1. Product Data Analysis
Retrieved product information from the Product table with relevant subcategory and category details.
Applied filters and ordering to highlight specific products, including the most expensive bikes.

  2. Work Order Analysis
Aggregated data from the WorkOrderRouting table for January 2004.
Calculated totals, unique counts, sums, and averages by LocationId.
Filtered work orders based on cost thresholds for reporting purposes.

**Skills demonstrated:**

- Writing SELECT queries with multiple JOINs
- Applying WHERE filters and ORDER BY clauses
- Using aggregate functions (COUNT, SUM, AVG)
- Structuring queries for clear, reusable results

## Advanced SQL

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

**Skills demonstrated:**

- Using window functions (RANK, SUM OVER)
- Writing complex JOINs and aggregations
- Filtering and grouping with advanced criteria
- Structuring queries for business insights and reporting
- Combining multiple tables to produce enriched datasets

## Sample Results

Results are provided in basic-sql/results.md and advanced-sql/results.md.

# Technologies
- SQL Server / T-SQL
- Google Sheets (for exporting results)

## Usage Instructions

- Download the AdventureWorks demo database if you want to run the queries.
- Review SQL queries in basic-sql/queries.sql and advanced-sql/queries.sql.
- Check example results in results.md.

## Next Steps

- Add additional advanced analytics queries (e.g., time series, predictive metrics)
- Integrate visualizations for key insights
- Include a subset of CSV files for demonstration without requiring the full database



