SELECT pharmacy_name, 
       SUM(price * count) OVER(PARTITION BY pharmacy_name) AS total_sales 
FROM pharma_orders;