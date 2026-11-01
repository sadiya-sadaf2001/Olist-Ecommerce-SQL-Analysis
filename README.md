 Olist E-commerce SQL Data Analysis



Project Overview

This project explores the Olist Brazilian e-commerce marketplace dataset using MySQL. The goal is to analyse order performance, customer behaviour, product sales, payment preferences and delivery operations using SQL.



The project focuses on transforming raw relational data into meaningful business insights.



 Business Questions



This analysis investigates:



1\. What is the distribution of order statuses?

2\. What are the total item and freight values?

3\. Which product categories generate the highest item value?

4\. Which payment methods are most commonly used?

5\. How many customers place repeat orders?

6\. What percentage of delivered orders arrive late?

7\. Is delivery distance associated with late deliveries?

8\. Do delivery outcomes differ across customer states?

9\. Are late deliveries associated with lower customer review scores?



 Dataset



The project uses nine related datasets:



\- Orders

\- Order Items

\- Customers

\- Products

\- Payments

\- Reviews

\- Sellers

\- Geolocation

\- Product Category Translation



The dataset contains historical Brazilian e-commerce transactions.



 Tools and Technologies



\- MySQL

\- SQL

\- MySQL Workbench



 SQL Skills Demonstrated



\- SELECT, WHERE and ORDER BY

\- GROUP BY and HAVING

\- Aggregate functions

\- INNER JOIN and multi-table joins

\- Subqueries

\- CASE expressions

\- DISTINCT and conditional counting

\- Date and time calculations

\- Data validation and quality checks

\- Business KPI calculations

\- Haversine distance calculation using geographic coordinates



 Key Findings



\- 96,478 orders had a delivered status. Delivery calculations used 96,470 valid delivered orders after excluding eight records with invalid delivery dates.

\- The late-delivery rate among valid delivered orders was 8.11%.

\- Total recorded item value was R$13,596,989.

\- Credit cards were the dominant payment method.

\- Health \& Beauty had the highest item value among the analysed product categories.

\- The repeat-customer rate was 3.12%.

\- Longer estimated seller-to-customer distance groups showed higher late-delivery rates.

\- Late deliveries were associated with lower average customer review scores.


 Business Recommendations



\- Investigate customer retention and repeat-purchase opportunities.

\- Review delivery performance across states and distance groups.

\- Examine long-distance logistics and estimated delivery times.

\- Monitor negative customer reviews related to delivery experience.

\- Improve product-category data completeness.

 Data Quality and Limitations



The project includes duplicate checks, missing-value checks, relationship validation and invalid-date handling.



Some ZIP prefixes could not be matched to geolocation records. Geographic distances are estimated using ZIP-prefix average coordinates and do not represent actual road distances.



The dataset is historical, and observed relationships do not establish causation.


 Project Structure



\- `README.md` – Project overview and key findings

\- `SQL\_Queries/` – SQL scripts for validation and business analysis

\- `Olist\_Ecommerce\_SQL\_Project\_Report.pdf` – Detailed project report



 Conclusion



This project demonstrates how SQL can be used to explore a relational e-commerce database, validate data, answer business questions and communicate findings through business insights and recommendations.



Project focus: SQL-based business analysis.

