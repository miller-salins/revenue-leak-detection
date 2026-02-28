
-- Standarize date formats and cleaning blank spaces

-- Cleaning for raw_payment_table

-- you may need to use "SET SQL_SAFE_UPDATES = 0;"" before the next lines
UPDATE raw_payment_audit
SET payment_date = CASE
    WHEN payment_date LIKE '%/%' THEN STR_TO_DATE(payment_date, '%d/%m/%Y')
    WHEN payment_date LIKE '%-%' THEN STR_TO_DATE(payment_date, '%Y-%m-%d')
    ELSE payment_date
END,
payment_status = TRIM(UPPER(payment_status)),
source_system = TRIM(source_system);

ALTER TABLE raw_payment_audit
MODIFY COLUMN payment_date DATE,
MODIFY COLUMN amount_billed DECIMAL(10,2),
MODIFY COLUMN amount_paid DECIMAL(10,2),
MODIFY COLUMN payment_status VARCHAR(50),
MODIFY COLUMN source_system VARCHAR(50);