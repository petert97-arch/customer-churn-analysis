-- Purpose: Segment customers by revenue

SELECT
customer_name,
total_revenue,
CASE
    WHEN total_revenue > 500000 THEN 'High Value'
    WHEN total_revenue > 100000 THEN 'Medium Value'
    ELSE 'Low Value'
END AS customer_segment
FROM fact_orders_churn;
