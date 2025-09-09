-- Drop tables in correct order to avoid foreign key conflicts
IF OBJECT_ID('alerts', 'U') IS NOT NULL DROP TABLE alerts;
IF OBJECT_ID('kyc_updates', 'U') IS NOT NULL DROP TABLE kyc_updates;
IF OBJECT_ID('transactions', 'U') IS NOT NULL DROP TABLE transactions;
IF OBJECT_ID('accounts', 'U') IS NOT NULL DROP TABLE accounts;
IF OBJECT_ID('customers', 'U') IS NOT NULL DROP TABLE customers;
IF OBJECT_ID('branches', 'U') IS NOT NULL DROP TABLE branches;
IF OBJECT_ID('countries', 'U') IS NOT NULL DROP TABLE countries;
