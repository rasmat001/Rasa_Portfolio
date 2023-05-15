WITH first_visit AS (
      SELECT user_pseudo_id,
        MIN(PARSE_DATE('%Y%m%d',event_date)) first_visit
      FROM `turing_data_analytics.raw_events`
      GROUP BY 1),

main_table AS (
      SELECT r.user_pseudo_id, 
        DATE_TRUNC(f.first_visit, week) cohort_week, 
        PARSE_DATE('%Y%m%d',r.event_date) event_date, 
        r.event_value_in_usd, 
        r.event_name
      FROM `turing_data_analytics.raw_events` r
      JOIN first_visit f ON f.user_pseudo_id=r.user_pseudo_id
      WHERE PARSE_DATE('%Y%m%d',r.event_date) < '2021-01-31' )

SELECT cohort_week, 
       COUNT (DISTINCT user_pseudo_id) users_joined,
       SUM(CASE WHEN event_date >= cohort_week AND event_date < DATE_ADD(cohort_week, INTERVAL 1 week) THEN event_value_in_usd END)  week_0,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 1 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 2 week) THEN event_value_in_usd END)  week_1,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 2 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 3 week) THEN event_value_in_usd END)  week_2,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 3 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 4 week) THEN event_value_in_usd END)  week_3,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 4 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 5 week) THEN event_value_in_usd END)  week_4,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 5 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 6 week) THEN event_value_in_usd END)  week_5,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 6 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 7 week) THEN event_value_in_usd END)  week_6,
        SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 7 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 8 week) THEN event_value_in_usd END)  week_7,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 8 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 9 week) THEN event_value_in_usd END)  week_8,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 9 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 10 week) THEN event_value_in_usd END)  week_9,
        SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 10 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 11 week) THEN event_value_in_usd END)  week_10,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 11 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 12 week) THEN event_value_in_usd END)  week_11,
       SUM(CASE WHEN event_date >= DATE_ADD(cohort_week, INTERVAL 12 week) AND event_date < DATE_ADD(cohort_week, INTERVAL 13 week) THEN event_value_in_usd END)  week_12

FROM main_table
GROUP BY 1
ORDER BY 1
