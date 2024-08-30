WITH pharmacy_drag AS (
    SELECT 
        pharmacy_name, 
        drug,
        SUM(price * count) AS order_amt
    FROM pharma_orders
    WHERE LOWER(drug) LIKE '%аква%'
    GROUP BY drug, pharmacy_name
),
pharmacy_total_sales AS (
    SELECT 
        pharmacy_name, 
        SUM(price * count) AS total_pharm_sales
    FROM pharma_orders
    GROUP BY pharmacy_name
)
SELECT 
    pd.pharmacy_name, 
    pd.drug,
    ROW_NUMBER() OVER (PARTITION BY pd.pharmacy_name ORDER BY pd.order_amt DESC) AS drug_rank,
    pd.order_amt,
    pts.total_pharm_sales,
    ROUND((pd.order_amt::NUMERIC * 100 / pts.total_pharm_sales::NUMERIC), 3) AS drag_pharm_share
FROM pharmacy_drag pd
INNER JOIN pharmacy_total_sales pts USING (pharmacy_name)
ORDER BY pd.pharmacy_name, pd.drug, drug_rank DESC;