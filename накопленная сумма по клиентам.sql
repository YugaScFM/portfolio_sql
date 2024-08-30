SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       SUM(po.price * po.count) AS total_order_amount
FROM pharma_orders po
JOIN customers c ON po.customer_id = c.customer_id
GROUP BY full_name;