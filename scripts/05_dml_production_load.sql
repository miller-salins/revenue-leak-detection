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