-- comulative analysis (eg: running total of sales by year, moving average of sales by month) --

-- calculate the total sales per month and the running total of sales over time.

SELECT
	*,
	total_sales + COALESCE(prev_month_sales, 0) AS running_total
FROM
	
(SELECT
MONTH(order_date) AS months,
SUM(sales) AS total_sales,
LAG(SUM(sales)) OVER(ORDER BY MONTH(order_date)) AS prev_month_sales
FROM gold.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)) AS t

-- for each months of every year find running total sales and moving average sales

SELECT
	date,
	total_sales,
	avg_sales,
	SUM(total_sales) OVER(ORDER BY date) AS running_total_sales,
	AVG(avg_sales) OVER(ORDER BY date) AS moving_average
FROM
(SELECT
	DATETRUNC(month, order_date) AS date,
	SUM(sales) AS total_sales,
	AVG(sales) AS avg_sales
FROM gold.fact_sales 
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
)t
