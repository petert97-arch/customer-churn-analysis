-- Purpose: Identify customers that are risk and/or have churned



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
