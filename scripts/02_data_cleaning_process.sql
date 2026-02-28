
-- Standarize date formats and cleaning blank spaces

-- Cleaning for raw_payment_table
UPDATE raw_payment_audit
SET payment_date = STR_TO_DATE(payment_date, '%Y-%M-%D'),
    payment_status = TRIM(UPPER(payment_status)),
    source_system = TRIM(source_system)

ALTER TABLE raw_payment_audit
MODIFY COLUMN payment_date DATE,
MODIFY COLUMN amount_billed DECIMAL(10,2),
MODIFY COLUMN amount_paid DECIMAL(10,2),
MODIFY COLUMN payment_status VARCHAR(50),
MODIFY COLUMN source_system VARCHAR(50),