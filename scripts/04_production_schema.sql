-- Final tables to migrate the clean data.

-- Customer Table
CREATE TABLE customer(
    -- 1. Internal Key (For secure relationships within the DB)
    db_customer_id INTEGER PRIMARY KEY AUTO_INCREMENT, 
    -- 2. External Key (The ID coming from Stripe, Apple, etc.)
    source_customer_id VARCHAR(100) NOT NULL, 
    -- 3. Core Business (Standard business columns)
    customer_name VARCHAR(255), 
    email VARCHAR(255), 
    phone_number VARCHAR(50), 
    signup_date DATE, 
    plan_type VARCHAR(50), 
    customer_status VARCHAR(50), 
    is_active TINYINT DEFAULT 1, 
    -- 4. (Unforeseen extra data from external sources)
    metadata JSON, 
    -- 5. Lineage and Audit
    batch_id VARCHAR(50), 
    source_system VARCHAR(50), 
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Performance Optimization Indexes
CREATE INDEX idx_customer_source_id ON customer(source_customer_id);
CREATE INDEX idx_customer_email ON customer(email);


-- PLAN TABLE
CREATE TABLE plan (
    -- 1. Internal Key
    db_plan_id INTEGER PRIMARY KEY AUTO_INCREMENT,
        -- 2. External Key
    source_plan_id VARCHAR(100) NOT NULL,
    -- 3. Core Business Data
    plan_name VARCHAR(255),
    price DECIMAL(18,8), 
    currency VARCHAR(10),
    billing_cycle VARCHAR(50),
    is_active TINYINT DEFAULT 1,
    -- 4. Scalability
    metadata JSON,
    -- 5. Lineage and Audit
    batch_id VARCHAR(50),
    source_system VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Performance Optimization Indexes
CREATE INDEX idx_plan_source_id ON plan(source_plan_id);


-- Payment Table
CREATE TABLE payment(
    -- 1. Internal Key
    db_payment_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- 2. External Key
    source_payment_id VARCHAR(100) NOT NULL,
    -- 3. Core Business Data
    db_customer_id INTEGER NOT NULL,
    db_plan_id INTEGER,
    payment_date TIMESTAMP,
    amount DECIMAL(18,8),
    currency VARCHAR(50),
    payment_status VARCHAR(50),
    -- 4. Scalability
    metadata JSON,
    -- 5. Lineage and Audit
    batch_id VARCHAR(50),
        source_system VARCHAR(50),
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (db_customer_id) REFERENCES customer(db_customer_id),
    FOREIGN KEY (db_plan_id) REFERENCES plan(db_plan_id)
);


-- Performance Optimization Indexes
CREATE INDEX idx_payment_source_id ON payment(source_payment_id);
CREATE INDEX idx_payment_customer ON payment(db_customer_id);
CREATE INDEX idx_payment_status ON payment(payment_status);