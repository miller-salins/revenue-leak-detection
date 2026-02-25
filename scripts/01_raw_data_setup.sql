-- Staging table for payments: a landing zone to receive the data, allowing it to receive the date without data constrains.

CREATE TABLE raw_payments_audits(
    transaction_id TEXT, -- primary key
    batch_id TEXT, -- Internal load identifier for rollback safety
    customer_id TEXT, -- client ID (will have a client table)
    payment_date TEXT, -- date in text format avoiding errors
    amount_billed TEXT,
    amount_paid TEXT,
    payment_status TEXT, --assuming it will be included in the raw data
    source_system TEXT, --Tracks if data comes from Web, Ios, Android -- is metadata
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- staging table for customers: contains the data of all customers

CREATE TABLE raw_customers(
    customer_id TEXT, -- primary key
    batch_id TEXT, -- Internal load identifier for rollback safety
    customer_name TEXT, --dirty data expected
    email TEXT, -- personal info (may be useful)
    phone_number TEXT, -- personal info (may be useful)
    signup_date TEXT, -- registration date to identify "cohorts"
    plan_type TEXT, -- Current plan assigned to the user
    customer_status TEXT, --Active, churn, or suspended (to define)
    is_active INTEGER DEFAULT 1, -- Soft-delete flag (1=Active, 0=Inactive)
    source_system TEXT, --Tracks if data comes from Web, Ios, Android -- -- is metadata
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


--Staging table for plans: basically the business rules for revenue validation

CREATE TABLE raw_plans (
    plan_id TEXT, -- primary key
    plan_name TEXT, -- Basic, pro, Enterprise (to define)
    monthly_price TEXT, -- expected price (benchmark for leaks)
    currency TEXT, -- in case of international audits
    is_active INTEGER DEFAULT 1, -- To handle deprecated plans without losing history
    source_system TEXT, --Tracks if data comes from Web, Ios, Android -- is metadata
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
