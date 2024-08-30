WITH customer_ages AS (
    SELECT 
        customer_id, 
        gender,  
        EXTRACT(YEAR FROM AGE(CAST(date_of_birth AS DATE))) AS customer_age,
        CASE 
            WHEN gender = 'муж' AND EXTRACT(YEAR FROM AGE(CAST(date_of_birth AS DATE))) < 30 THEN 'мужчины младше 30'
            WHEN gender = 'муж' AND EXTRACT(YEAR FROM AGE(CAST(date_of_birth AS DATE))) BETWEEN 30 AND 45 THEN 'мужчины от 30 до 45'
            WHEN gender = 'муж' AND EXTRACT(YEAR FROM AGE(CAST(date_of_birth AS DATE))) > 45 THEN 'мужчины старше 45'
            WHEN gender = 'жен' AND EXTRACT(YEAR FROM AGE(CAST(date_of_birth AS DATE))) < 30 THEN 'женщины младше 30'
            WHEN gender = 'жен' AND EXTRACT(YEAR FROM AGE(CAST(date_of_birth AS DATE))) BETWEEN 30 AND 45 THEN 'женщины от 30 до 45'
            WHEN gender = 'жен' AND EXTRACT(YEAR FROM AGE(CAST(date_of_birth AS DATE))) > 45 THEN 'женщины старше 45'
            ELSE 'другая группа' 
        END AS customer_group
    FROM
        customers
),
customer_groups AS (
    SELECT
        customer_group,
        SUM(price * count) AS cust_gr_amt,  
        COUNT(DISTINCT c_a.customer_id) AS cust_gr_cnt
    FROM customer_ages AS c_a
    INNER JOIN pharma_orders AS p_o USING (customer_id)
    GROUP BY customer_group
),
total_sales AS (
    SELECT SUM(price * count) AS total_sales
    FROM pharma_orders
)
SELECT
    customer_group,
    cust_gr_cnt, 
    cust_gr_amt,
    total_sales,
    round((cust_gr_amt::NUMERIC*100/total_sales::NUMERIC),1) as cust_gr_share_pers
FROM 
    customer_groups
CROSS JOIN total_sales
