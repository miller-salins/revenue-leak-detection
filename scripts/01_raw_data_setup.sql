-- Staging table: a landing zone to receive the data, allowing it to receive the date without data constrains.

CREATE TABLE raw_payments_audits(
    transaction_id TEXT, -- primary key
    customer_id TEXT, -- client ID (will have a client table)
    payment_date TEXT, -- date in text format avoiding errors
    amount_billed TEXT,
    amount_paid TEXT,
    payment_status TEXT, --assuming it will be included in the raw data
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
