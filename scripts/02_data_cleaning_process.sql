
-- Standarize date formats and cleaning blank spaces
-- You may need to use "SET SQL_SAFE_UPDATES = 0;"" before the next lines

-- Normalizing dates according detected format
UPDATE raw_payment_audit
SET payment_date = CASE
    WHEN payment_date LIKE '%/%' THEN STR_TO_DATE(payment_date, '%d/%m/%Y')
    WHEN payment_date LIKE '%-%' THEN STR_TO_DATE(payment_date, '%Y-%m-%d')
    ELSE payment_date
END,
payment_status = TRIM(UPPER(payment_status)),
source_system = TRIM(source_system);


-- Extract currencies and clean financial amounts
UPDATE raw_payment_audit
SET 
    -- Isolate non-numeric characters (divisas) into the new column
    currency = NULLIF(TRIM(REGEXP_REPLACE(amount_paid, '[0-9.]', '')), ''),
    -- Clean the amount columns to leave strictly digits and decimals
    amount_billed = REGEXP_REPLACE(amount_billed, '[^0-9.]', ''),
    amount_paid = REGEXP_REPLACE(amount_paid, '[^0-9.]', '');

-- Audit: Counting true remaining inconsistencies (actual system errors/empty values)
SELECT 
    COUNT(CASE WHEN amount_billed NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN 1 END) AS billed_errors,
    COUNT(CASE WHEN amount_paid NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN 1 END) AS paid_errors
FROM raw_payment_audit;


-- Cleaning: Forcing trash to Null value to allow changes
UPDATE raw_payment_audit 
SET amount_billed = CASE WHEN amount_billed REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN amount_billed ELSE NULL END,
    amount_paid = CASE WHEN amount_paid REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN amount_paid ELSE NULL END;

-- Changes
ALTER TABLE raw_payment_audit
MODIFY COLUMN payment_date DATE,
MODIFY COLUMN amount_billed DECIMAL(10,2),
MODIFY COLUMN amount_paid DECIMAL(10,2),
MODIFY COLUMN payment_status VARCHAR(50),
MODIFY COLUMN source_system VARCHAR(50);