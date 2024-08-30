SELECT pharmacy_name, SUM(price * count) AS total_sales
FROM pharma_orders
GROUP BY pharmacy_name
HAVING SUM(price * count) > 1800000;