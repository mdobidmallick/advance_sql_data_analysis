-- CUSTOMER REPORT --

(a) gather essential fields such as names, ages and transaction details.
(b) segment customers into categories VIP, REGULAR, NEW and age groups.
(c) aggregate customers level metrics: (total_orders, total_sales, quantity_purchased, total_products, lifespan in months)
(d) calculate valuable KPIs: (recency - months since last order, average order value, average monthly spend)


-- buildling the base:

CREATE VIEW gold.customers_report AS

WITH cte AS

(SELECT
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATEDIFF(year, c.birth_date, GETDATE()) AS age,
    DATEDIFF(month, MIN(s.order_date), MAX(s.order_date)) AS lifespan_months,
    COUNT(DISTINCT s.order_number) AS total_orders,
    SUM(s.sales) AS total_sales,
    SUM(s.quantity) AS quantity_purchased,
    COUNT(DISTINCT s.product_key) AS total_products_bought,
	MAX(s.order_date) AS last_ordered_on
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name,
	c.birth_date,
	DATEDIFF(year, c.birth_date, GETDATE()))

-- building final report using base query

SELECT
	customer_key,
	customer_name,
	age,
	CASE	
		WHEN age <= 18 THEN 'Adult'
		WHEN age BETWEEN 19 AND 30 THEN 'Young'
		WHEN age BETWEEN 31 AND 50 THEN 'Mature'
		ELSE 'Senior Citizen'
	END AS age_group,
	CASE
		WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'REGULAR'
		WHEN lifespan_months < 12 THEN 'NEW'
	END AS cx_segment,
	lifespan_months,
	total_orders,
	total_sales,
	quantity_purchased,
	total_products_bought,
	last_ordered_on,
	total_sales/(CASE WHEN total_orders = 0 OR total_orders IS NULL THEN 1 ELSE total_orders END) AS avg_order_value,
	total_sales/(CASE WHEN lifespan_months = 0 OR lifespan_months IS NULL THEN 1 ELSE lifespan_months END) AS avg_monthly_spend,
	DATEDIFF(month, last_ordered_on,GETDATE()) AS recency_in_months
FROM cte;

-- do not forget to create view of this beautiful report genearted by above query so that other team members can acces it. 

SELECT * FROM gold.customers_report  -- yaaayy view has been created and its working fine
	
