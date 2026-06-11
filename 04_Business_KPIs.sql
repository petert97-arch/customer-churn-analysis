-- Purpose: Calculate business metrics 


SELECT
COUNT(*) AS total_customers,
SUM(total_revenue) AS total_revenue,
AVG(avg_order_value) AS average_order_value
FROM fact_orders_churn;


SELECT
churn_status,
SUM(total_revenue) AS revenue
FROM fact_orders_churn
GROUP BY churn_status;
