-- mrr_movements.sql
-- Monthly MRR bridge by movement type (PostgreSQL 13+). Requires schema.sql.
--
-- Assumptions:
--   * Source is v_account_mrr_monthly (month-end MRR per account, zero rows included
--     after the first paid month). Amounts are in cents.
--   * Movements are classified per account by comparing month m-1 and month m:
--       new          prev = 0, curr > 0, first paid month
--       reactivation prev = 0, curr > 0, account paid before
--       expansion    prev > 0, curr > prev
--       contraction  prev > 0, 0 < curr < prev   (negative amount)
--       churn        prev > 0, curr = 0          (negative amount)
--   * No reactivation grace window is applied. If your policy treats a return within
--     N days as continuous, merge short gaps upstream in subscription_items.
--   * The final row (current month) is in progress.
--   * reconciliation_diff must be 0 for every month; anything else is a data bug.

WITH account_months AS (
    SELECT account_id,
           month_start,
           first_mrr_month,
           mrr_cents AS curr_mrr,
           coalesce(lag(mrr_cents) OVER (PARTITION BY account_id ORDER BY month_start), 0) AS prev_mrr
    FROM v_account_mrr_monthly
),
classified AS (
    SELECT month_start,
           account_id,
           prev_mrr,
           curr_mrr,
           CASE
               WHEN prev_mrr = 0 AND curr_mrr > 0 AND month_start = first_mrr_month THEN 'new'
               WHEN prev_mrr = 0 AND curr_mrr > 0                                  THEN 'reactivation'
               WHEN prev_mrr > 0 AND curr_mrr > prev_mrr                           THEN 'expansion'
               WHEN prev_mrr > 0 AND curr_mrr > 0 AND curr_mrr < prev_mrr          THEN 'contraction'
               WHEN prev_mrr > 0 AND curr_mrr = 0                                  THEN 'churn'
               ELSE 'unchanged'
           END AS movement_type,
           curr_mrr - prev_mrr AS delta_mrr
    FROM account_months
),
bridge AS (
    SELECT month_start,
           sum(prev_mrr)                                                     AS opening_mrr,
           sum(delta_mrr) FILTER (WHERE movement_type = 'new')               AS new_mrr,
           sum(delta_mrr) FILTER (WHERE movement_type = 'reactivation')      AS reactivation_mrr,
           sum(delta_mrr) FILTER (WHERE movement_type = 'expansion')         AS expansion_mrr,
           sum(delta_mrr) FILTER (WHERE movement_type = 'contraction')       AS contraction_mrr,
           sum(delta_mrr) FILTER (WHERE movement_type = 'churn')             AS churn_mrr,
           sum(curr_mrr)                                                     AS closing_mrr,
           count(*) FILTER (WHERE prev_mrr > 0)                              AS opening_accounts,
           count(*) FILTER (WHERE movement_type = 'new')                     AS new_accounts,
           count(*) FILTER (WHERE movement_type = 'reactivation')            AS reactivated_accounts,
           count(*) FILTER (WHERE movement_type = 'churn')                   AS churned_accounts,
           count(*) FILTER (WHERE curr_mrr > 0)                              AS closing_accounts
    FROM classified
    GROUP BY month_start
)
SELECT month_start,
       round(opening_mrr / 100.0, 2)                          AS opening_mrr,
       round(coalesce(new_mrr, 0) / 100.0, 2)                 AS new_mrr,
       round(coalesce(reactivation_mrr, 0) / 100.0, 2)        AS reactivation_mrr,
       round(coalesce(expansion_mrr, 0) / 100.0, 2)           AS expansion_mrr,
       round(coalesce(contraction_mrr, 0) / 100.0, 2)         AS contraction_mrr,
       round(coalesce(churn_mrr, 0) / 100.0, 2)               AS churn_mrr,
       round((closing_mrr - opening_mrr) / 100.0, 2)          AS net_new_mrr,
       round(closing_mrr / 100.0, 2)                          AS closing_mrr,
       round(closing_mrr * 12 / 100.0, 2)                     AS closing_arr,
       opening_accounts,
       new_accounts,
       reactivated_accounts,
       churned_accounts,
       closing_accounts,
       round(churned_accounts::numeric / nullif(opening_accounts, 0), 4)            AS logo_churn_rate,
       round(-coalesce(churn_mrr, 0) / nullif(opening_mrr, 0), 4)                   AS gross_mrr_churn_rate,
       round((coalesce(expansion_mrr, 0) + coalesce(contraction_mrr, 0) + coalesce(churn_mrr, 0))
             / nullif(opening_mrr, 0), 4)                                           AS net_mrr_change_rate_existing,
       -- Must be 0: opening + movements = closing.
       opening_mrr + coalesce(new_mrr, 0) + coalesce(reactivation_mrr, 0)
         + coalesce(expansion_mrr, 0) + coalesce(contraction_mrr, 0)
         + coalesce(churn_mrr, 0) - closing_mrr                                     AS reconciliation_diff
FROM bridge
ORDER BY month_start;
