-- Validate customer dimension mapping
SELECT product, sales.customer_name, price
FROM sales
JOIN dim_customer
ON sales.customer_name = dim_customer.customer_name;

-- Validate fact table to product dimension relationship
SELECT *
FROM fact_order_details
JOIN dim_product
ON fact_order_details.product_id = dim_product.product_id;

-- Check for unmatched records between fact and dimension tables
SELECT *
FROM dim_product
FULL JOIN fact_order_details
ON fact_order_details.product_id = dim_product.product_id;
