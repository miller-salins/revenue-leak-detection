-- 1. Base View: Detecting transactions with revenue leakage
CREATE OR REPLACE VIEW vw_revenue_leaks AS
SELECT 
    payment_id,
    batch_id,
    customer_id,
    payment_date,
    amount_billed,
    amount_paid,
    currency,
    ROUND((amount_billed - amount_paid), 2) AS leaked_amount,
    payment_status,
    source_system
FROM raw_payment_audit
WHERE amount_billed > amount_paid
  AND payment_status NOT IN ('FAILED', 'REFUNDED', 'CANCELLED');


-- 2. View: Summary by currency. Lost revenue by currency
CREATE OR REPLACE VIEW vw_leaks_by_currency AS
SELECT 
    currency,
    COUNT(transaction_id) AS total_leaked_transactions,
    SUM(leaked_amount) AS total_leaked_amount
FROM vw_revenue_leaks
GROUP BY currency;

-- 3. View: Summary by Source System
CREATE OR REPLACE VIEW vw_leaks_by_source_system AS
SELECT
    source_system,
    COUNT(transaction_id) AS total_leaked_transactions,
    SUM(leaked_amount) AS total_leaked_amount,
    ROUND(AVG(leaked_amount), 2) AS avg_leak_impact
FROM vw_revenue_leaks
GROUP BY source_system;


-- 4. View: Top 20 High-Value Recovery Targets (Pareto Principle Efficiency)
CREATE OR REPLACE VIEW vw_leaks_by_customer AS
SELECT 
    customer_id,
    COUNT(transaction_id) AS incident_count,
    SUM(leaked_amount) AS total_to_recover
FROM vw_revenue_leaks
GROUP BY customer_id
ORDER BY total_to_recover DESC
LIMIT 20; -- only the top 20 avoiding to bring the total of possible customers the bussiness would  need to charge.