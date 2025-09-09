-- =====================
-- SAMPLE PROBLEMS & SOLUTIONS (Process Demonstration)
-- =====================

Select *
from transactions as t
	join accounts as a on t.account_id = a.account_id
	join customers as c on a.customer_id = c.customer_id
where c.risk_rating = 'high' and t.amount > 10000;

select count(*) from transactions

-- Sample 1: Find the number of unique occupations among high-risk customers.
--   Process: Shows how to use GROUP BY and COUNT DISTINCT for profiling.
SELECT COUNT(DISTINCT occupation) AS unique_occupations
FROM customers
WHERE risk_rating = 'high';

-- Sample 2: List the top 3 currencies used in transactions by volume.
--   Process: Demonstrates aggregation and ordering for currency analysis.
SELECT TOP 3
	currency, COUNT(*) AS txn_count
FROM transactions
GROUP BY currency
ORDER BY txn_count DESC;

-- Sample 3: Find customers who have both 'verified' and 'failed' KYC statuses in their update history.
--   Process: Shows use of subqueries and set logic for compliance review.
SELECT c.customer_id, c.name
FROM customers c
WHERE EXISTS (
	SELECT 1
	FROM kyc_updates ku
	WHERE ku.customer_id = c.customer_id AND ku.kyc_status = 'verified'
)
	AND EXISTS (
	SELECT 1
	FROM kyc_updates ku
	WHERE ku.customer_id = c.customer_id AND ku.kyc_status = 'failed'
);

-- AML Banking Capstone Project: Problem Statements
-- Each problem is described below as a comment. Add your SQL solution below each as you work through them.

-- =====================
-- EASY LEVEL (1-10)
-- =====================
-- 1. List all customers with 'high' risk rating.
--    Overview: Identify customers flagged as high risk for AML monitoring.
 SELECT *
 FROM customers
 WHERE risk_rating = 'high';


-- 2. Find the top 5 branches by number of accounts.
--    Overview: See which branches have the most customer accounts.
SELECT TOP 5 branch_id, COUNT(account_id) AS account_count
FROM accounts
GROUP BY branch_id
ORDER BY account_count DESC;


-- 3. Show all transactions above $10,000.
--    Overview: Large transactions may require regulatory reporting.

SELECT *
FROM transactions
WHERE amount > 10000
ORDER BY amount DESC;

-- 4. List customers who have not updated their KYC in the last 2 years.
--    Overview: Spot customers overdue for KYC refresh.

SELECT *
FROM customers
WHERE customer_id NOT IN (
	SELECT customer_id
	FROM kyc_updates
	WHERE update_date >= DATEADD(year, -2, GETDATE())
);


-- 5. Count the number of accounts per customer.
--    Overview: Understand customer account distribution.

SELECT customer_id, COUNT(account_id) AS account_count
FROM accounts
GROUP BY customer_id;

-- 6. List all accounts that are currently 'frozen'.
--    Overview: Identify accounts with restricted activity.

SELECT *
FROM accounts
WHERE status = 'frozen';

-- 7. Find the total transaction amount for each account in the last month.
--    Overview: Recent account activity summary.

SELECT account_id, SUM(amount) AS sum_amount
FROM transactions
WHERE transaction_date >= DATEADD(MONTH, -1, GETDATE())
GROUP BY account_id
ORDER BY sum_amount DESC;

-- 8. List all alerts that are still 'open'.
--    Overview: Track unresolved AML alerts.

SELECT *
FROM alerts
WHERE status = 'open';

-- 9. Show all transactions made via 'ATM' channel.
--    Overview: Analyze ATM-based activity.
SELECT *
FROM transactions
WHERE channel = 'ATM';

-- 10. List all countries marked as high risk.
--     Overview: Reference for geographic risk analysis.

SELECT *
FROM countries
WHERE is_high_risk = 1;

-- =====================
-- MEDIUM LEVEL (11-20)
-- =====================
-- 11. Find customers with more than 3 accounts.
--     Overview: Multiple accounts may indicate structuring or layering.

-- 12. List accounts with more than 5 transactions in a single day.
--     Overview: High-frequency activity may be suspicious.

-- 13. Identify customers whose accounts have been closed in the last year.
--     Overview: Track recent account closures for review.

-- 14. Find transactions just below $10,000 (e.g., $9,000-$9,999).
--     Overview: Spot possible structuring to avoid reporting.

-- 15. List customers who have received AML alerts more than once.
--     Overview: Repeat alerts may indicate ongoing risk.

-- 16. Show the average transaction amount per branch.
--     Overview: Compare transaction sizes across branches.

-- 17. Find accounts with both 'credit' and 'debit' transactions on the same day.
--     Overview: Rapid in-and-out movement of funds.

-- 18. List all transactions involving high-risk countries.
--     Overview: Monitor cross-border risk exposure.

-- 19. Identify customers whose KYC status is 'failed' and have active accounts.
--     Overview: Compliance risk from non-verified customers.

-- 20. Find the top 10 customers by total transaction value in the last year.
--     Overview: High-value customers for enhanced due diligence.

-- =====================
-- TOUGH LEVEL (21-30)
-- =====================
-- 21. Detect accounts with frequent deposits just below the reporting threshold over multiple days.
--     Overview: Advanced structuring/smurfing detection.

-- 22. Identify accounts with rapid movement of funds (in and out within 24 hours).
--     Overview: Layering activity to obscure money trail.

-- 23. Find dormant accounts (no activity for 1 year) that suddenly show large transactions.
--     Overview: Dormant account reactivation risk.

-- 24. List customers who have changed their address more than twice in the last 3 years.
--     Overview: Frequent address changes may indicate identity manipulation.

-- 25. Detect accounts with transactions involving multiple high-risk countries.
--     Overview: Complex cross-border laundering.

-- 26. Identify customers with repeated failed KYC updates and recent high-value transactions.
--     Overview: High compliance and AML risk.

-- 27. Find accounts with a high ratio of cash deposits to total deposits.
--     Overview: Cash-intensive activity is a red flag.

-- 28. List customers whose accounts have been frozen after an AML alert.
--     Overview: Link between alerts and account status.

-- 29. Detect possible collusion: customers transferring funds back and forth between their own accounts.
--     Overview: Circular transactions to disguise origins.

-- 30. Identify customers with transactions in multiple currencies and high-risk countries within a short period.
--     Overview: Sophisticated laundering using currency and geography.

-- =====================
-- Add your SQL solutions below each problem as you work through them.
