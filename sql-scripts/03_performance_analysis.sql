-- PERFORMANCE ANALYSIS [i.e comparing the current value to a target value. Helps measure success and compare performance] --

eg: current_sales - avg_sales, current_year_sales - prev_year_sales, current_sales - lowest_sales etc

(a) analyse the yearly performance of products
   by comparing each product's sales to both 
   its average sales performance and the previous year's sales

WITH yearly_product_sales AS

(SELECT
YEAR(s.order_date) AS years,
p.product_name,
SUM(s.sales) AS total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date),
p.product_name)

SELECT 
	years,
	product_name,
	total_sales,
	AVG(total_sales) OVER(PARTITION BY product_name) AS pr_avg_sales,
	total_sales - AVG(total_sales) OVER(PARTITION BY product_name) AS avg_diff,
	CASE 
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) < 0 THEN 'below avg'
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) > 0 THEN 'above avg'
		ELSE 'no change'
	END AS total_sales_vs_avg_sales_performance,
	COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY years), 0) AS prev_year_sales,
	total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY years), 0) AS yearly_performance,
	CASE
		WHEN total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY years), 0) = total_sales THEN 'no change'
		WHEN total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY years), 0) < 0 THEN 'decrease'
		WHEN total_sales - COALESCE(LAG(total_sales) OVER(PARTITION BY product_name ORDER BY years), 0) > 0 THEN 'increase'
	END AS currentsales_vs_prev_yearsales_performance
FROM yearly_product_sales
ORDER BY product_name, years;
