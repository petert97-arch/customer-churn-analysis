-- Query: Derive Customer KPIs Summary
-- Purpose: Calculate total orders, total revenue, average order value, last purchase date, and churn status for each customer.

CREATE TABLE fact_orders_churn AS
SELECT
dim_customer.customer_name,
COUNT(dim_orders.order_id) AS total_orders,
SUM(fact_order_details.revenue) AS total_revenue,
AVG(fact_order_details.revenue) AS avg_order_value,
MAX(dim_orders.order_date) AS last_purchase_date,
DATEDIFF(day, MAX(dim_orders.order_date), CURRENT_DATE) AS days_since_last_purchase, 
CASE 
WHEN DATEDIFF(day, MAX(dim_orders.order_date), CURRENT_DATE) > 90
THEN 'Churned'
ELSE 'Active'
END AS churn_status
FROM fact_order_details
JOIN dim_orders ON dim_orders.order_id = fact_order_details.order_id
JOIN dim_customer ON dim_customer.customer_key = dim_orders.customer_key
GROUP BY dim_customer.customer_name;




-- Purpose: Structured raw sales data into dimension and fact tables using SQL to support customer churn analysis and business intelligence reporting.


CREATE OR REPLACE TABLE dim_customer AS 
SELECT DISTINCT
   ROW_NUMBER() OVER (ORDER BY customer_name)
   customer_name
   FROM sales;



CREATE OR REPLACE TABLE dim_customer AS 
SELECT 
ROW_NUMBER() OVER (ORDER BY customer_name) AS customer_key,
customer_name
FROM (
SELECT DISTINCT customer_name
FROM sales
WHERE customer_name IS NOT NULL);



CREATE OR REPLACE TABLE dim_product AS 
SELECT DISTINCT
ROW_NUMBER() OVER (ORDER BY product) AS product_id,
product AS product_name
FROM sales
WHERE product_name IS NOT NULL;







CREATE OR REPLACE TABLE fact_order_details AS 
SELECT
od.order_id,
p.product_id,
od.quantity,
s.price AS unit_price,
(od.quantity * price) AS REVENUE
FROM order_details od
JOIN sales s 
 ON od.order_id = s.order_id
JOIN dim_product p 
 ON s.product = p.product_name;



CREATE OR REPLACE TABLE dim_date AS 
SELECT DISTINCT
order_date AS date,
EXTRACT (YEAR FROM order_date) AS year,
EXTRACT (MONTH FROM order_date) AS month,
EXTRACT (QUARTER FROM order_date) AS quarter
FROM sales;




CREATE OR REPLACE TABLE dim_orders AS 
SELECT
s.order_id,
c.customer_key, 
s.order_date
FROM sales s
JOIN dim_customer c 
ON s.customer_name = c.customer_name;
