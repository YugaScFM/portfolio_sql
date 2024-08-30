SELECT po.pharmacy_name, 
       COUNT(DISTINCT c.customer_id) AS num_customers
FROM pharma_orders po
JOIN customers c ON po.customer_id = c.customer_id
GROUP BY po.pharmacy_name
ORDER BY num_customers DESC;