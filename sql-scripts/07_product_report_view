-- PRODUCT REPORT --

1. gather essential fields such as product_name, category, sub_category, cost.
2. segment products by revenue identify high performers, mid range, or low performers.
3. aggregate product lavel metrics (total_order, total_sales, quantity_sold, total_unique_customer, lifespan_months).
4. calculate valuable KPIs:
	   (a) recency (months since last sale)
	   (b) average order revenue (AOR)
	   (c) average monthly revenue

-- step1: bulding the base

CREATE VIEW gold.product_report AS
	
WITH base_query AS 

(SELECT
	p.product_name,
	p.category,
	p.subcategory,
	SUM(s.sales) AS total_sales,
	COUNT(DISTINCT s.order_number) AS total_orders,
	SUM(s.quantity) AS quantity_sold,
	COUNT(DISTINCT s.customer_key) AS total_unique_customers,
	DATEDIFF(month, p.start_date, GETDATE()) AS product_lifespan_months,
	MAX(s.order_date) AS last_ordered_on
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name,p.category,p.subcategory, 
DATEDIFF(month, p.start_date, GETDATE()))

-- step2: building the final logic for view

SELECT 
	*,
	CASE
		WHEN total_sales BETWEEN 0 AND 100000 THEN 'low performing'
		WHEN total_sales BETWEEN 100001 AND 500000 THEN 'mid range'
		WHEN total_sales > 500000 THEN 'high performing'
	END AS product_segment,
	DATEDIFF(month, last_ordered_on, GETDATE()) AS months_since_last_order,
	total_sales/total_orders AS avg_order_value,
	total_sales/product_lifespan_months AS avg_monhtly_revenue
FROM base_query;

SELECT * FROM gold.product_report; -- yaaayy view has been created and its working fine
	
