-- Create and use project-specific database
IF DB_ID('AML_Banking_Capstone') IS NOT NULL
    DROP DATABASE AML_Banking_Capstone;
GO
CREATE DATABASE AML_Banking_Capstone;
GO
USE AML_Banking_Capstone;
GO

-- 1. Customers
IF OBJECT_ID('customers', 'U') IS NOT NULL DROP TABLE customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    address VARCHAR(255),
    kyc_status VARCHAR(20),
    risk_rating VARCHAR(10), -- low/medium/high
    occupation VARCHAR(100),
    country_code VARCHAR(3)
);

-- 2. Branches
IF OBJECT_ID('branches', 'U') IS NOT NULL DROP TABLE branches;
CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100),
    city VARCHAR(100),
    country_code VARCHAR(3)
);

-- 3. Accounts
IF OBJECT_ID('accounts', 'U') IS NOT NULL DROP TABLE accounts;
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES customers(customer_id),
    account_type VARCHAR(20),
    open_date DATE,
    close_date DATE,
    status VARCHAR(20), -- active/closed/frozen
    branch_id INT FOREIGN KEY REFERENCES branches(branch_id)
);

-- 4. Countries
IF OBJECT_ID('countries', 'U') IS NOT NULL DROP TABLE countries;
CREATE TABLE countries (
    country_code VARCHAR(3) PRIMARY KEY,
    country_name VARCHAR(100),
    is_high_risk BIT
);

-- 5. Transactions
IF OBJECT_ID('transactions', 'U') IS NOT NULL DROP TABLE transactions;
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT FOREIGN KEY REFERENCES accounts(account_id),
    transaction_date DATETIME,
    amount DECIMAL(18,2),
    transaction_type VARCHAR(10), -- credit/debit
    channel VARCHAR(20), -- ATM/branch/online/mobile
    counterparty_account VARCHAR(30),
    counterparty_bank VARCHAR(100),
    currency VARCHAR(10),
    description VARCHAR(255)
);

-- 6. Alerts
IF OBJECT_ID('alerts', 'U') IS NOT NULL DROP TABLE alerts;
CREATE TABLE alerts (
    alert_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES customers(customer_id),
    account_id INT FOREIGN KEY REFERENCES accounts(account_id),
    transaction_id INT FOREIGN KEY REFERENCES transactions(transaction_id),
    alert_date DATETIME,
    alert_type VARCHAR(50),
    status VARCHAR(20), -- open/closed/investigating
    investigator VARCHAR(100)
);

-- 7. KYC Updates
IF OBJECT_ID('kyc_updates', 'U') IS NOT NULL DROP TABLE kyc_updates;
CREATE TABLE kyc_updates (
    kyc_update_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES customers(customer_id),
    update_date DATETIME,
    kyc_status VARCHAR(20),
    updated_by VARCHAR(100)
);
