-- grr_nrr.sql
-- Trailing 12-month cohort GRR and NRR (PostgreSQL 13+). Requires schema.sql.
--
-- Assumptions:
--   * For each measurement month m, the cohort is every account with MRR > 0 at the
--     month-end snapshot of m - 12 months. New logos acquired after that are excluded.
--   * NRR(m) = sum(MRR_i at m) / sum(MRR_i at m-12) over the cohort
--     (includes expansion, contraction, churn; reactivated accounts count at their
--     month m value).
--   * GRR(m) = sum(least(MRR_i at m, MRR_i at m-12)) / sum(MRR_i at m-12)
--     (includes contraction and churn, excludes expansion; never above 1).
--   * Accounts missing from the view at m are treated as 0 MRR (cannot happen after
--     their first paid month because the view keeps zero rows, but guarded anyway).
--   * Change the segment grouping by joining accounts and adding a.segment to the
--     GROUP BY. Report GRR and NRR together, never NRR alone.

WITH start_snap AS (
    SELECT account_id,
           month_start                               AS start_month,
           (month_start + interval '12 months')::date AS measure_month,
           mrr_cents                                 AS start_mrr
    FROM v_account_mrr_monthly
    WHERE mrr_cents > 0
),
paired AS (
    SELECT s.measure_month,
           s.account_id,
           s.start_mrr,
           coalesce(e.mrr_cents, 0) AS end_mrr
    FROM start_snap s
    LEFT JOIN v_account_mrr_monthly e
      ON e.account_id = s.account_id
     AND e.month_start = s.measure_month
    WHERE s.measure_month <= date_trunc('month', now())::date
)
SELECT measure_month,
       count(*)                                                        AS cohort_accounts,
       count(*) FILTER (WHERE end_mrr > 0)                             AS retained_accounts,
       round(count(*) FILTER (WHERE end_mrr > 0)::numeric / count(*), 4) AS logo_retention_12m,
       round(sum(start_mrr) / 100.0, 2)                                AS cohort_start_mrr,
       round(sum(end_mrr) / 100.0, 2)                                  AS cohort_end_mrr,
       round(sum(least(end_mrr, start_mrr)) / nullif(sum(start_mrr), 0), 4) AS grr_12m,
       round(sum(end_mrr) / nullif(sum(start_mrr), 0), 4)              AS nrr_12m,
       round(sum(greatest(end_mrr - start_mrr, 0)) / nullif(sum(start_mrr), 0), 4) AS expansion_rate_12m,
       round(sum(start_mrr) FILTER (WHERE end_mrr = 0) / nullif(sum(start_mrr), 0), 4) AS churned_mrr_share_12m
FROM paired
GROUP BY measure_month
ORDER BY measure_month;
