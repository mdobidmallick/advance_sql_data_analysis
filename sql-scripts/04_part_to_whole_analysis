-- PART TO WHOLE ANALYSIS --

(a) which categories contribute the most to overall sales.

SELECT
    category,
    total_sales,
    ROUND((CAST(total_sales AS FLOAT) * 100.0) / grand_total, 2) AS pct_of_total_sales
FROM (
    SELECT
        p.category,
        SUM(s.sales) AS total_sales,
        SUM(SUM(s.sales)) OVER () AS grand_total
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.category
) t;
