--removing duplicates, splitting some columns and fixing data types
WITH cleaned_data AS (
  SELECT
    event_time,
    event_type,
    brand,
    SPLIT(category_code, '.')[OFFSET(0)] AS category,
    SPLIT(category_code, '.')[OFFSET(1)] AS subcategory,
    CASE
      WHEN SPLIT(category_code, '.')[SAFE_OFFSET(2)] IS NOT NULL
        THEN SPLIT(category_code, '.')[SAFE_OFFSET(2)]
        ELSE SPLIT(category_code, '.')[OFFSET(1)]
    END AS product_type,
    CAST(product_id AS STRING) AS product_id,
    CASE
      WHEN event_type = 'purchase' THEN price
    END AS purchase_value,
    price AS item_price,
    CAST(user_id AS STRING) AS user_id
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY user_id, event_time, event_type, product_id ORDER BY event_time) AS dup_flag
    FROM `capstone-project-386913.electronics_store.events_table`
  )
  WHERE (dup_flag = 1 AND event_type = 'view') OR event_type IN ('cart','purchase')
  ORDER BY dup_flag DESC
),
--creating order_id and session_id columns
events AS (
  SELECT
    event_time,
    event_type,
    product_id,
    brand,
    category,
    subcategory,
    product_type,
    purchase_value,
    item_price,
    user_id,
    order_id,
    SUM(is_new_session) OVER (ORDER BY user_id, event_time) AS session_id
  FROM (
    SELECT
      *,
      CAST(
        CASE
          WHEN event_type = 'purchase' THEN DENSE_RANK() OVER (ORDER BY event_time, user_id)
        END AS STRING) AS order_id,
      CASE
        WHEN TIMESTAMP_DIFF(event_time,
          LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time), MINUTE) > 30
          OR LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) IS NULL
        THEN 1 ELSE 0
      END AS is_new_session
    FROM cleaned_data
  )
),
--calculating metrics for session analysis
sessions AS (
  SELECT
    session_id,
    MIN(event_time) AS session_started,
    TIMESTAMP_DIFF(MAX(event_time), MIN(event_time), SECOND) AS session_duration,
    TIMESTAMP_DIFF(
      MIN(CASE WHEN event_type = 'cart' THEN event_time END),
      MIN(event_time), SECOND) AS sec_until_first_cart,
    TIMESTAMP_DIFF(
      MIN(CASE WHEN event_type = 'purchase' THEN event_time END),
      MIN(event_time), SECOND) AS sec_until_first_purchase,
    MAX(event_time) AS last_event,
    CASE
      WHEN TIMESTAMP_DIFF(MAX(event_time), MIN(event_time), SECOND) < 1
      THEN 1 ELSE 0
    END AS is_bounce
  FROM events
  GROUP BY session_id
)
--joining both tables to get is_exit and is_bounce flags for all events
SELECT
  e.*,
  CASE WHEN e.event_time = s.last_event THEN 1 ELSE 0 END AS is_exit,
  s.is_bounce
FROM events AS e
LEFT JOIN sessions AS s
  ON s.session_id = e.session_id;
