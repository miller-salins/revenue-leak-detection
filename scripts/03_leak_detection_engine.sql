-- 1. Base View: Detecting transactions with revenue leakage
CREATE OR REPLACE VIEW vw_revenue_leaks AS
SELECT 
    p.db_payment_id AS payment_id,
    c.email,
    p.amount AS amount_paid,
    pl.price AS amount_billed,
    ROUND((pl.price - p.amount), 2) AS leaked_amount,
    p.currency,
    p.source_system,
    p.payment_date
FROM payment p
JOIN customer c ON p.db_customer_id = c.db_customer_id
JOIN plan pl ON p.db_plan_id = pl.db_plan_id
WHERE p.amount < pl.price
  AND p.payment_status NOT IN ('FAILED', 'REFUNDED', 'CANCELLED');


-- 2. View: Summary by currency. Lost revenue by currency
CREATE OR REPLACE VIEW vw_leaks_by_currency AS
SELECT 
    currency,
    COUNT(payment_id) AS total_leaked_transactions,
    SUM(leaked_amount) AS total_leaked_amount
FROM vw_revenue_leaks
GROUP BY currency;


-- 3 Summary by source system. Lost revenue by source system
CREATE OR REPLACE VIEW vw_leaks_by_source_system AS
SELECT
    source_system,
    COUNT(payment_id) AS total_leaked_transactions,
    SUM(leaked_amount) AS total_leaked_amount,
    ROUND(AVG(leaked_amount), 2) AS avg_leak_impact
FROM vw_revenue_leaks
GROUP BY source_system;

-- 4 Summary by customer. Top customers who represent the most revenue leak
CREATE OR REPLACE VIEW vw_leaks_by_customer AS
SELECT 
    email,
    COUNT(payment_id) AS frequency,
    SUM(leaked_amount) AS total_leaked_amount,
    MAX(leaked_amount) AS max_single_leak
FROM vw_revenue_leaks
GROUP BY email
ORDER BY total_leaked_amount DESC
LIMIT 20;