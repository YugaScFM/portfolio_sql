/* Выводы из проведенного сравнения: В Санкт-Петербурге продается явно больше лекарств, за исключением лекарств против аллергии, проблем с желудком и 
головной боли (видимо это связано с более высоким ритмом жизни в Москве, перекусами на ходу, загазованностью и общим уровнем шума).*/

WITH moscow_sales AS (
    SELECT 
        EXTRACT(MONTH FROM CAST(report_date AS timestamp)) AS month,
        pharmacy_name,
        drug,
        SUM(price * count) AS total_sales
    FROM Pharma_orders
    WHERE city = 'Москва'
    GROUP BY EXTRACT(MONTH FROM CAST(report_date AS timestamp)), pharmacy_name, drug
),
spb_sales AS (
    SELECT 
        EXTRACT(MONTH FROM CAST(report_date AS timestamp)) AS month,
        pharmacy_name,
        drug,
        SUM(price * count) AS total_sales
    FROM Pharma_orders
    WHERE city = 'Санкт-Петербург'
    GROUP BY EXTRACT(MONTH FROM CAST(report_date AS timestamp)), pharmacy_name, drug
),
combined_sales AS (
    SELECT 
        COALESCE(mos.month, spb.month) AS month,
        COALESCE(mos.pharmacy_name, spb.pharmacy_name) AS pharmacy_name,
        COALESCE(mos.drug, spb.drug) AS drug,
        mos.total_sales AS moscow_sales,
        spb.total_sales AS spb_sales,
        COALESCE(mos.total_sales::NUMERIC, 0) - COALESCE(spb.total_sales::NUMERIC, 0) AS diff,
        CASE 
            WHEN COALESCE(spb.total_sales::NUMERIC, 0) != 0 THEN 
                ROUND(((COALESCE(mos.total_sales::NUMERIC, 0) - COALESCE(spb.total_sales::NUMERIC, 0)) / COALESCE(spb.total_sales::NUMERIC, 0)) * 100, 2)
            ELSE 100
        END AS percentage_diff
    FROM moscow_sales mos
    FULL JOIN spb_sales spb ON mos.month = spb.month AND mos.pharmacy_name = spb.pharmacy_name AND mos.drug = spb.drug
)
SELECT * FROM combined_sales ORDER BY month, pharmacy_name, drug