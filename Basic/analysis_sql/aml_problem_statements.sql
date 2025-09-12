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
SELECT customer_id, COUNT(account_id) AS account_count
FROM accounts
GROUP BY customer_id
HAVING COUNT(account_id) > 3;


-- 12. List accounts with more than 5 transactions in a single day.
--     Overview: High-frequency activity may be suspicious.

SELECT account_id, transaction_date, COUNT(transaction_id) AS txn_count
FROM transactions
GROUP BY account_id, transaction_date
HAVING COUNT(transaction_id) > 1;

SELECT account_id, transaction_date, COUNT(transaction_date) AS transaction_count
FROM transactions
GROUP BY account_id, transaction_date
HAVING COUNT(transaction_date) > 5
ORDER BY transaction_count DESC;

-- 13. Identify customers whose accounts have been closed in the last year.
--     Overview: Track recent account closures for review.
SELECT *
FROM accounts
WHERE status = 'closed' AND close_date >= DATEADD(year, -1, GETDATE());



-- 14. Find transactions just below $10,000 (e.g., $9,000-$9,999).
--     Overview: Spot possible structuring to avoid reporting.
SELECT *
FROM transactions
WHERE amount >= 9000 AND amount < 10000


-- 15. List customers who have received AML alerts more than once.
--     Overview: Repeat alerts may indicate ongoing risk.

SELECT customer_id, COUNT(alert_id) AS alert_count
FROM alerts
GROUP BY customer_id
HAVING COUNT(alert_id) > 1
ORDER BY alert_count DESC;


-- 16. Show the average transaction amount per branch.
--     Overview: Compare transaction sizes across branches.

SELECT branches.branch_id, AVG(transactions.amount) AS avg_amount
FROM transactions
JOIN accounts
ON transactions.account_id = accounts.account_id
JOIN branches 
ON accounts.branch_id = branches.branch_id
GROUP BY branches.branch_id
ORDER BY avg_amount DESC;

-- 17. Find accounts with both 'credit' and 'debit' transactions on the same day.
--     Overview: Rapid in-and-out movement of funds.
SELECT account_id, transaction_date
FROM transactions	
GROUP BY account_id, transaction_date
HAVING COUNT(DISTINCT transaction_type) = 2
ORDER BY account_id, transaction_date;


-- 18. List all transactions involving high-risk countries.
--     Overview: Monitor cross-border risk exposure.

SELECT t.*
FROM transactions AS t
JOIN customers AS cu ON t.account_id = cu.customer_id
JOIN countries AS c ON cu.country_code= c.country_code
WHERE c.is_high_risk = 1;

-- 19. Identify customers whose KYC status is 'failed' and have active accounts.
--     Overview: Compliance risk from non-verified customers.

SELECT *
FROM customers
WHERE kyc_status = 'failed' AND customer_id IN (
    SELECT DISTINCT customer_id
    FROM accounts
    WHERE status = 'active'
);


-- 20. Find the top 10 customers by total transaction value in the last year.
--     Overview: High-value customers for enhanced due diligence.

SELECT TOP 10 cu.customer_id, SUM(t.amount) AS total_transaction_value
FROM transactions AS t
JOIN customers AS cu ON t.account_id = cu.customer_id
WHERE t.transaction_date >= DATEADD(year, -1, GETDATE())
GROUP BY cu.customer_id
ORDER BY total_transaction_value DESC;

-- =====================
-- TOUGH LEVEL (21-30)
-- =====================
-- 21. Detect accounts with frequent deposits just below the reporting threshold over multiple days.
--     Overview: Advanced structuring/smurfing detection.

SELECT account_id, transaction_date, COUNT(transaction_id) AS txn_count, SUM(amount) AS total_amount
FROM transactions
WHERE amount >= 9000 AND amount < 10000
GROUP BY account_id, transaction_date
HAVING COUNT(transaction_id) > 1;

-- 22. Identify accounts with rapid movement of funds (in and out within 24 hours).
--     Overview: Layering activity to obscure money trail.

SELECT account_id, transaction_date, COUNT(transaction_id) AS txn_count, SUM(amount) AS total_amount
FROM transactions
WHERE amount >= 9000 AND amount < 10000
GROUP BY account_id, transaction_date
HAVING COUNT(transaction_id) > 1;

-- 23. Find dormant accounts (no activity for 1 year) that suddenly show large transactions.
--     Overview: Dormant account reactivation risk.

SELECT a.account_id
FROM accounts AS a
WHERE a.status = 'dormant' AND a.account_id IN (
    SELECT DISTINCT account_id
    FROM transactions
    WHERE transaction_date >= DATEADD(year, -1, GETDATE())
    AND amount > 10000
);
-- 24. List customers who have changed their address more than twice in the last 3 years.
--     Overview: Frequent address changes may indicate identity manipulation.



-- 25. Detect accounts with transactions involving multiple high-risk countries.
--     Overview: Complex cross-border laundering.

SELECT DISTINCT a.account_id
FROM branches AS b
JOIN transactions AS t ON b.branch_name = t.counterparty_bank
JOIN accounts AS a ON t.account_id = a.account_id
JOIN customers AS c ON a.customer_id = c.customer_id
JOIN countries AS co ON c.country_code = co.country_code
WHERE co.is_high_risk = 1


-- 26. Identify customers with repeated failed KYC updates and recent high-value transactions.
--     Overview: High compliance and AML risk.
SELECT DISTINCT c.customer_id, c.name
FROM customers AS c
JOIN kyc_updates AS k ON c.customer_id = k.customer_id
WHERE k.kyc_status = 'failed' AND k.update_date >= DATEADD(year, -1, GETDATE())
AND c.customer_id IN (
    SELECT DISTINCT account_id
    FROM transactions
    WHERE amount > 10000
);
 

-- 27. Find accounts with a high ratio of cash deposits to total deposits.
--     Overview: Cash-intensive activity is a red flag.



-- 28. List customers whose accounts have been frozen after an AML alert.
--     Overview: Link between alerts and account status.

SELECT DISTINCT a.account_id, a.status
FROM accounts AS a	
JOIN alerts AS al ON a.customer_id = al.customer_id
WHERE a.status = 'frozen' AND al.status = 'closed';


-- 29. Detect possible collusion: customers transferring funds back and forth between their own accounts.
--     Overview: Circular transactions to disguise origins.
SELECT t1.account_id AS from_account, t2.account_id AS to_account, COUNT(*) AS transfer_count
FROM transactions AS t1
JOIN transactions AS t2 ON t1.account_id = t2.account_id AND t1.transaction_id <> t2.transaction_id
WHERE t1.transaction_date = t2.transaction_date
GROUP BY t1.account_id, t2.account_id
HAVING COUNT(*) > 1;

-- 30. Identify customers with transactions in multiple currencies and high-risk countries within a short per iod.
--     Overview: Sophisticated laundering using currency and geography.
SELECT DISTINCT c.customer_id, c.name
FROM customers AS c	
JOIN accounts AS a ON c.customer_id = a.customer_id
JOIN transactions AS t ON a.account_id = t.account_id
JOIN countries AS co ON c.country_code = co.country_code
WHERE co.is_high_risk = 1
AND t.transaction_date >= DATEADD(month, -3, GETDATE());

-- 31. For each customer, find their largest transaction and how it ranks among all customers’ largest transactions.
SELECT
    c.customer_id,
    c.name,
    MAX(t.amount) AS max_transaction,
    RANK() OVER (ORDER BY MAX(t.amount) DESC) AS overall_rank
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name;

-- 32. List accounts whose average transaction amount in the last 6 months is at least twice their overall average.
SELECT
    account_id,
    AVG(CASE WHEN transaction_date >= DATEADD(month, -6, GETDATE()) THEN amount END) AS avg_last_6_months,
    AVG(amount) AS avg_overall
FROM transactions
GROUP BY account_id
HAVING AVG(CASE WHEN transaction_date >= DATEADD(month, -6, GETDATE()) THEN amount END) >= 2 * AVG(amount);

-- 33. Find the top 3 customers per branch by total transaction value in the past year.
SELECT *
FROM (
    SELECT
        b.branch_id,
        c.customer_id,
        c.name,
        SUM(t.amount) AS total_value,
        ROW_NUMBER() OVER (PARTITION BY b.branch_id ORDER BY SUM(t.amount) DESC) AS rn
    FROM branches b
    JOIN accounts a ON b.branch_id = a.branch_id
    JOIN customers c ON a.customer_id = c.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_date >= DATEADD(year, -1, GETDATE())
    GROUP BY b.branch_id, c.customer_id, c.name
) ranked
WHERE rn <= 3;

-- 34. Identify customers whose transaction amounts have increased by more than 50% compared to the previous month.
WITH monthly_totals AS (
    SELECT
        c.customer_id,
        FORMAT(t.transaction_date, 'yyyy-MM') AS txn_month,
        SUM(t.amount) AS month_total
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    GROUP BY c.customer_id, FORMAT(t.transaction_date, 'yyyy-MM')
),
monthly_with_lag AS (
    SELECT
        customer_id,
        txn_month,
        month_total,
        LAG(month_total) OVER (PARTITION BY customer_id ORDER BY txn_month) AS prev_month_total
    FROM monthly_totals
)
SELECT
    customer_id,
    txn_month,
    month_total,
    prev_month_total
FROM monthly_with_lag
WHERE prev_month_total IS NOT NULL
  AND month_total > 1.5 * prev_month_total;

  -- 35. For each account, show the longest streak of consecutive days with at least one transaction.
WITH txn_days AS (
    SELECT
        account_id,
        CAST(transaction_date AS DATE) AS txn_date,
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY CAST(transaction_date AS DATE)) AS rn
    FROM transactions
    GROUP BY account_id, CAST(transaction_date AS DATE)
),
streaks AS (
    SELECT
        account_id,
        txn_date,
        DATEADD(day, -rn, txn_date) AS streak_group
    FROM txn_days
)
SELECT
    account_id, 
    COUNT(*) AS longest_streak
FROM (
    SELECT account_id, streak_group, COUNT(*) AS streak_length
    FROM streaks
    GROUP BY account_id, streak_group
) streak_lengths
GROUP BY account_id
ORDER BY longest_streak DESC;
-- =====================