-- DATA SEGMENTATION --

(a) segment products in to cost ranges and count how mwny products fall into each segment.

SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM
	(SELECT
		CASE	
			WHEN cost <= 250 THEN 'low'
			WHEN cost > 250 AND cost <= 1000 THEN 'medium'
			ELSE 'high'
		END AS cost_range,
		product_key
	FROM gold.dim_products) t
GROUP BY cost_range;

(b) group customers into three segments based on thier spending behaviour.

1. VIP (atleast 12 months on history and spending more than 5000)
2. REGULAR (atleast 12 months on history but spending 5000 or less)
3. NEW (lifespan less than 12 months)
And find the total number of customers by each group.

WITH cx_by_spend AS

(SELECT
	c.customer_key,
	c.first_name,
	DATEDIFF(month,MIN(order_date), MAX(order_date)) AS cx_tenure,
	SUM(s.sales) AS total_spendings
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name),

cx_segment AS

(SELECT
	customer_key,
	first_name,
	total_spendings,
	cx_tenure,
	CASE
		WHEN cx_tenure > 12 AND total_spendings > 5000 THEN 'VIP'
		WHEN cx_tenure > 12 AND total_spendings <= 5000 THEN 'REGULAR'
		WHEN cx_tenure < 12 THEN 'NEW'
	END AS cx_segment
FROM cx_by_spend)

SELECT
	cx_segment,
	COUNT(customer_key) AS total_customers
FROM cx_segment
WHERE cx_segment IS NOT NULL
GROUP BY cx_segment;

