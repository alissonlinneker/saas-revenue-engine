-- funnel_conversion.sql
-- Cohort stage conversion and time in stage from lifecycle_stage_transitions
-- (PostgreSQL 13+). Requires schema.sql.
--
-- Assumptions:
--   * Stage order below is the forward funnel. Side and terminal states
--     (disqualified, closed_lost, dormant, churned) have no forward order and are
--     reported only as exits.
--   * Conversion is cohort-based: of entities that entered stage A in month P,
--     the share reaching ANY later forward stage within window_days of entering A.
--     Skips (for example signup straight to customer) count as conversion.
--   * Only the first entry into each stage per entity is used for conversion,
--     so loops do not inflate denominators.
--   * Time in stage uses every entry: next transition time minus entry time.
--     Entries with no next transition are "still open" and excluded from the
--     median but counted in open_entries so survivor bias is visible.
--   * Cohorts younger than window_days are flagged is_mature = false.
--   * Filter entity_type to 'account' or 'user'; do not mix grains in one funnel.

WITH params AS (
    SELECT 'account'::text AS entity_type,
           90              AS window_days
),
stage_order (stage, ordinal) AS (
    VALUES ('visitor', 1), ('lead', 2), ('signup', 2), ('qualified_lead', 3),
           ('opportunity', 4), ('customer', 5), ('onboarded', 6), ('activated', 7),
           ('retained', 8), ('expanded', 9)
),
t AS (
    SELECT l.*
    FROM lifecycle_stage_transitions l
    JOIN params p ON p.entity_type = l.entity_type
),
first_entry AS (
    SELECT t.entity_id, t.to_stage AS stage, so.ordinal, min(t.transitioned_at) AS entered_at
    FROM t
    JOIN stage_order so ON so.stage = t.to_stage
    GROUP BY t.entity_id, t.to_stage, so.ordinal
),
conversion AS (
    SELECT fe.stage,
           fe.ordinal,
           date_trunc('month', fe.entered_at)::date AS cohort_month,
           fe.entity_id,
           fe.entered_at,
           EXISTS (
               SELECT 1
               FROM first_entry nx, params p
               WHERE nx.entity_id = fe.entity_id
                 AND nx.ordinal > fe.ordinal
                 AND nx.entered_at >= fe.entered_at
                 AND nx.entered_at <  fe.entered_at + make_interval(days => p.window_days)
           ) AS converted_in_window
    FROM first_entry fe
),
conversion_summary AS (
    SELECT c.stage,
           c.ordinal,
           c.cohort_month,
           count(*)                                         AS entered,
           count(*) FILTER (WHERE c.converted_in_window)    AS converted,
           round(count(*) FILTER (WHERE c.converted_in_window)::numeric / count(*), 4) AS conversion_rate,
           (c.cohort_month + interval '1 month' + make_interval(days => p.window_days)) <= now() AS is_mature
    FROM conversion c
    CROSS JOIN params p
    GROUP BY c.stage, c.ordinal, c.cohort_month, p.window_days
),
stays AS (
    SELECT t.entity_id,
           t.to_stage AS stage,
           t.transitioned_at AS entered_at,
           lead(t.transitioned_at) OVER w AS exited_at,
           lead(t.to_stage) OVER w        AS next_stage
    FROM t
    WINDOW w AS (PARTITION BY t.entity_id ORDER BY t.transitioned_at, t.transition_id)
),
velocity AS (
    SELECT stage,
           date_trunc('month', entered_at)::date AS cohort_month,
           count(*) FILTER (WHERE exited_at IS NULL) AS open_entries,
           count(*) FILTER (WHERE exited_at IS NOT NULL) AS closed_entries,
           percentile_cont(0.5) WITHIN GROUP (ORDER BY extract(epoch FROM exited_at - entered_at) / 86400.0)
               FILTER (WHERE exited_at IS NOT NULL) AS median_days_in_stage,
           percentile_cont(0.9) WITHIN GROUP (ORDER BY extract(epoch FROM exited_at - entered_at) / 86400.0)
               FILTER (WHERE exited_at IS NOT NULL) AS p90_days_in_stage,
           count(*) FILTER (WHERE next_stage IN ('disqualified', 'closed_lost', 'dormant', 'churned')) AS exits_to_terminal
    FROM stays
    GROUP BY stage, date_trunc('month', entered_at)::date
)
SELECT cs.stage,
       cs.cohort_month,
       cs.entered,
       cs.converted,
       cs.conversion_rate,
       cs.is_mature,
       v.closed_entries,
       v.open_entries,
       round(v.median_days_in_stage::numeric, 1) AS median_days_in_stage,
       round(v.p90_days_in_stage::numeric, 1)    AS p90_days_in_stage,
       v.exits_to_terminal
FROM conversion_summary cs
LEFT JOIN velocity v
  ON v.stage = cs.stage
 AND v.cohort_month = cs.cohort_month
ORDER BY cs.ordinal, cs.stage, cs.cohort_month;
