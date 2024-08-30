WITH gorzdrav_customers AS (
    SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, COUNT(po.order_id) AS num_orders
    FROM pharma_orders po
    JOIN customers c ON po.customer_id = c.customer_id
    WHERE po.pharmacy_name = 'Горздрав'
    GROUP BY c.customer_id, full_name
    ORDER BY num_orders DESC
    LIMIT 10
),

zdravcity_customers AS (
    SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, COUNT(po.order_id) AS num_orders
    FROM pharma_orders po
    JOIN customers c ON po.customer_id = c.customer_id
    WHERE po.pharmacy_name = 'Здравсити'
    GROUP BY c.customer_id, full_name
    ORDER BY num_orders DESC
    LIMIT 10
)

SELECT * FROM gorzdrav_customers
UNION
SELECT * FROM zdravcity_customers;