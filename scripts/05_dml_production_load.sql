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
