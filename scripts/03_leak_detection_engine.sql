-- 1. Base View: Detecting transactions with revenue leakage
CREATE OR REPLACE VIEW vw_revenue_leaks AS
SELECT 
    transaction_id,
    batch_id,
    customer_id,
    payment_date,
    amount_billed,
    amount_paid,
    currency,
    (amount_billed - amount_paid) AS leaked_amount,
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
