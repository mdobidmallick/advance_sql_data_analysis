-- total years being in the business --

SELECT 
	DATEDIFF(year, MIN(order_date), MAX(order_date)) AS total_years_of_business -- 4 years
FROM gold.fact_sales;

-- lets analyse revenue, total_orders, total_customers, quantity_sold in these 4 years --

SELECT
	YEAR(order_date) AS years,-- 2010 to 2014
	SUM(sales) AS revenue,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY SUM(sales) DESC;

-- lets check above metrics monthly for each years.

SELECT
	FORMAT(order_date, 'yyyy-MMM') AS year_month,-- 2010 to 2014
	SUM(sales) AS revenue,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY SUM(sales) DESC;
