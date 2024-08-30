WITH ranked_customers AS (
    SELECT c.customer_id,
           c.first_name,
           c.last_name,
           SUM(po.price * po.count) AS total_order_amount,
           ROW_NUMBER() OVER (ORDER BY SUM(po.price * po.count) DESC) AS rnk
    FROM pharma_orders po
    JOIN customers c ON po.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, total_order_amount
FROM ranked_customers
WHERE rnk <= 10;