WITH cte1 AS (
    SELECT *,
        SUM(is_new_session) OVER (ORDER BY user_pseudo_id,event_timestamp) global_session_id	--giving a unique id for each session
    FROM (
        SELECT *,
            CASE WHEN TIMESTAMP_DIFF(event_timestamp, last_event, MINUTE) >30
            OR last_event IS NULL
            THEN 1 ELSE 0 END is_new_session --flagging events where the a new session begins
        FROM (
            SELECT PARSE_DATE('%Y%m%d',event_date) event_date,
                TIMESTAMP_MICROS(event_timestamp) event_timestamp,
                event_name,
                user_pseudo_id,
                event_value_in_usd,
                LAG(TIMESTAMP_MICROS(event_timestamp)) OVER
                (PARTITION BY user_pseudo_id ORDER BY event_timestamp) last_event,
                campaign
            FROM `tc-da-1.turing_data_analytics.raw_events` )))	,

--calculating metrics for each session
cte2 AS (
    SELECT global_session_id,
        MIN(event_timestamp) session_started_at,
        TIMESTAMP_DIFF(MAX(event_timestamp),MIN(event_timestamp), MINUTE) session_time,
        SUM(CASE WHEN event_name='purchase' AND event_value_in_usd>0 THEN 1 ELSE 0 END) purchases_during_session,
        SUM(event_value_in_usd) revenue
    FROM cte1
    GROUP BY 1),

--calculating cost for paid marketing campaigns
cte3 AS (
    SELECT campaign, SUM(cost) cost
    FROM `turing_data_analytics.adsense_monthly`
    GROUP BY 1
)

SELECT a.global_session_id, a.session_started_at, a.session_time,
    a.purchases_during_session, a.revenue,
    INITCAP(TRIM(a.campaign,'()<>')) campaign1,
    CASE WHEN a.campaign IN (SELECT campaign FROM `turing_data_analytics.adsense_monthly`) THEN 'Marketing Campaigns'
    ELSE INITCAP(TRIM(a.campaign,'()<>')) END campaign2,
    cte3.cost
FROM (
        SELECT cte2.*, cte1.campaign,
            ROW_NUMBER() OVER (PARTITION BY cte2.global_session_id ORDER BY cte1.event_timestamp) campaign_sequence
        FROM cte2
        LEFT JOIN cte1 ON cte1.global_session_id=cte2.global_session_id	 AND cte1.campaign IS NOT NULL	)	a
LEFT JOIN cte3 ON cte3.campaign=a.campaign
WHERE a.campaign_sequence=1		--the session is attributed to the first campaign during that session
ORDER BY 1










							
