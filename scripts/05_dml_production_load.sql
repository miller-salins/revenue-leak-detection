INSERT INTO `plan` (source_plan_id, plan_name, price, currency, batch_id, source_system)
SELECT DISTINCT 
    plan_id, 
    plan_name, 
    CAST(price AS DECIMAL(18,8)), 
    currency, 
    batch_id, 
    source_system
FROM raw_plan
WHERE NOT EXISTS (
    SELECT 1 FROM `plan` WHERE `plan`.source_plan_id = raw_plan.plan_id
);


INSERT INTO `customer` (source_customer_id, customer_name, email, phone_number, signup_date, plan_type, customer_status, is_active, batch_id, source_system)
SELECT DISTINCT 
    customer_id, 
    customer_name, 
    email, 
    phone_number, 
    CASE 
        WHEN signup_date LIKE '%/%' THEN STR_TO_DATE(signup_date, '%d/%m/%Y')
        WHEN signup_date LIKE '%-%' THEN STR_TO_DATE(signup_date, '%Y-%m-%d')
        ELSE signup_date 
    END,
    plan_type, 
    customer_status, 
    is_active, 
    batch_id, 
    source_system
FROM raw_customer
WHERE NOT EXISTS (
    SELECT 1 FROM `customer` 
    WHERE `customer`.source_customer_id = raw_customer.customer_id
);


-- You can apply batching to avoid timeouts in case you have more than a million rows in raw_payment_audit.
-- Inserting groups of 250.000 payments will be appropiate   
INSERT INTO `payment` (source_payment_id, db_customer_id, db_plan_id, payment_date, amount, currency, payment_status, batch_id, source_system)
SELECT 
    rp.transaction_id,
    c.db_customer_id, -- Comes from customer table (c)
    p.db_plan_id,          -- Comes from plan table (p)
    rp.payment_date,
    rp.amount_paid,
    rp.currency,
    rp.payment_status,
    rp.batch_id,
    rp.source_system AS source_system
FROM raw_payment_audit AS rp
INNER JOIN `customer` AS c ON rp.customer_id = c.source_customer_id
LEFT JOIN `plan` AS p ON c.plan_type = p.plan_name 
WHERE NOT EXISTS (
    SELECT 1 
    FROM `payment` AS pay
    WHERE pay.source_payment_id = rp.transaction_id
);