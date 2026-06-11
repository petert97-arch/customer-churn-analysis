-- Purpose: Exlpore the data and identify patterns

SELECT churn_status, COUNT(*)
FROM fact_orders_churn
GROUP BY churn_status;



SELECT product_name, COUNT(*)
FROM dim_product
JOIN fact_order_details
ON dim_product.product_id = fact_order_details.product_id
GROUP BY product_name
ORDER BY COUNT(*) DESC;
