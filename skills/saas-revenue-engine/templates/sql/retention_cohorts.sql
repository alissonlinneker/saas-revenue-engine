-- retention_cohorts.sql
-- Logo and revenue retention by cohort (PostgreSQL 13+). Requires schema.sql.
--
-- Assumptions:
--   * Query 1 (start cohort): cohort = first month with MRR > 0 (first_mrr_month).
--     Month 0 is the start month. Retention is measured at each month-end snapshot.
--       logo_retention         = accounts with MRR > 0 at month k / cohort accounts
--       net_revenue_retention  = cohort MRR at month k / cohort MRR at month 0
--       gross_revenue_retention = sum(min(MRR_k, MRR_0)) / cohort MRR at month 0
--     Reactivated accounts count as retained in the month they pay again.
--   * Query 2 (signup cohort): cohort = month the account was created
--     (accounts.created_at). Shows conversion to paid and paid retention for the
--     whole signup cohort, which is the right lens for product-led funnels.
--   * The current month is in progress; the latest cell of each cohort is immature.
--   * Test accounts are excluded by the view (query 1) and explicitly (query 2).

-- Query 1: start (first paid month) cohorts
WITH base AS (
    SELECT v.account_id,
           v.first_mrr_month AS cohort_month,
           v.month_start,
           ((extract(year FROM v.month_start) - extract(year FROM v.first_mrr_month)) * 12
             + extract(month FROM v.month_start) - extract(month FROM v.first_mrr_month))::int AS months_since_start,
           v.mrr_cents
    FROM v_account_mrr_monthly v
),
start_mrr AS (
    SELECT account_id, mrr_cents AS mrr_0
    FROM base
    WHERE months_since_start = 0
),
cohort_cells AS (
    SELECT b.cohort_month,
           b.months_since_start,
           count(*) FILTER (WHERE b.mrr_cents > 0)  AS retained_accounts,
           sum(b.mrr_cents)                          AS cohort_mrr,
           sum(least(b.mrr_cents, s.mrr_0))          AS cohort_mrr_capped
    FROM base b
    JOIN start_mrr s USING (account_id)
    GROUP BY b.cohort_month, b.months_since_start
),
cohort_size AS (
    SELECT cohort_month,
           retained_accounts AS cohort_accounts,
           cohort_mrr        AS cohort_start_mrr
    FROM cohort_cells
    WHERE months_since_start = 0
)
SELECT c.cohort_month,
       c.months_since_start,
       z.cohort_accounts,
       round(z.cohort_start_mrr / 100.0, 2)                                        AS cohort_start_mrr,
       c.retained_accounts,
       round(c.retained_accounts::numeric / nullif(z.cohort_accounts, 0), 4)       AS logo_retention,
       round(c.cohort_mrr / nullif(z.cohort_start_mrr, 0), 4)                      AS net_revenue_retention,
       round(c.cohort_mrr_capped / nullif(z.cohort_start_mrr, 0), 4)               AS gross_revenue_retention
FROM cohort_cells c
JOIN cohort_size z USING (cohort_month)
ORDER BY c.cohort_month, c.months_since_start;

-- Query 2: signup (account created) cohorts, conversion to paid and paid retention
WITH signup AS (
    SELECT a.account_id,
           date_trunc('month', a.created_at)::date AS signup_month
    FROM accounts a
    WHERE NOT a.is_test
),
months AS (
    SELECT gs::date AS month_start
    FROM generate_series(
             (SELECT min(signup_month) FROM signup),
             date_trunc('month', now())::date,
             interval '1 month') AS gs
),
grid AS (
    SELECT s.account_id,
           s.signup_month,
           m.month_start,
           ((extract(year FROM m.month_start) - extract(year FROM s.signup_month)) * 12
             + extract(month FROM m.month_start) - extract(month FROM s.signup_month))::int AS months_since_signup
    FROM signup s
    JOIN months m ON m.month_start >= s.signup_month
)
SELECT g.signup_month,
       g.months_since_signup,
       count(DISTINCT g.account_id)                                                AS signup_accounts,
       count(DISTINCT g.account_id) FILTER (WHERE v.first_mrr_month <= g.month_start) AS ever_paid_accounts,
       count(DISTINCT g.account_id) FILTER (WHERE v.mrr_cents > 0)                 AS paying_accounts,
       round(count(DISTINCT g.account_id) FILTER (WHERE v.first_mrr_month <= g.month_start)::numeric
             / nullif(count(DISTINCT g.account_id), 0), 4)                         AS cumulative_paid_conversion,
       round(count(DISTINCT g.account_id) FILTER (WHERE v.mrr_cents > 0)::numeric
             / nullif(count(DISTINCT g.account_id), 0), 4)                         AS paying_share_of_signups,
       round(coalesce(sum(v.mrr_cents), 0) / 100.0, 2)                             AS cohort_mrr
FROM grid g
LEFT JOIN v_account_mrr_monthly v
  ON v.account_id = g.account_id
 AND v.month_start = g.month_start
GROUP BY g.signup_month, g.months_since_signup
ORDER BY g.signup_month, g.months_since_signup;
