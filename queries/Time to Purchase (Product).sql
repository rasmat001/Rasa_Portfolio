--finding first day event for each customer
WITH events AS (
  SELECT PARSE_DATE('%Y%m%d', event_date) AS event_date, 
         user_pseudo_id, 
        MIN(TIMESTAMP_MICROS(event_timestamp)) first_event_that_day
  FROM `tc-da-1.turing_data_analytics.raw_events`
  GROUP BY 1,2),
--finding first day event for each purchase funnel stage
view_item AS (
  SELECT PARSE_DATE('%Y%m%d', event_date) AS event_date, 
         user_pseudo_id, 
         MIN(TIMESTAMP_MICROS(event_timestamp)) first_view_item_that_day
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'view_item'
  GROUP BY 1,2),

add_to_cart AS (
  SELECT PARSE_DATE('%Y%m%d', event_date) AS event_date, 
         user_pseudo_id, 
         MIN(TIMESTAMP_MICROS(event_timestamp)) first_add_to_cart_that_day
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'add_to_cart'
  GROUP BY 1,2),

begin_checkout AS (
  SELECT PARSE_DATE('%Y%m%d', event_date) AS event_date, 
         user_pseudo_id, 
         MIN(TIMESTAMP_MICROS(event_timestamp)) first_begin_checkout_that_day
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'begin_checkout'
  GROUP BY 1,2),

add_payment_info AS (
  SELECT PARSE_DATE('%Y%m%d', event_date) AS event_date, 
         user_pseudo_id, 
         MIN(TIMESTAMP_MICROS(event_timestamp)) first_add_payment_info_that_day
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'add_payment_info'
  GROUP BY 1,2),

add_shipping_info AS (
  SELECT PARSE_DATE('%Y%m%d', event_date) AS event_date, 
         user_pseudo_id, 
         MIN(TIMESTAMP_MICROS(event_timestamp)) first_add_shipping_info_that_day
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'add_shipping_info'
  GROUP BY 1,2),

purchases AS (
  SELECT PARSE_DATE('%Y%m%d', event_date) AS purchase_date, 
         user_pseudo_id, 
         MIN(TIMESTAMP_MICROS(event_timestamp)) first_purchase_that_day
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'purchase' and event_value_in_usd IS NOT NULL
  GROUP BY 1,2)

--querying timestamps and durations to reach each purchase funnel stage
  SELECT  p.purchase_date as events_date, p.user_pseudo_id, 
          e.first_event_that_day, v.first_view_item_that_day, a.first_add_to_cart_that_day,
          b.first_begin_checkout_that_day,ap.first_add_payment_info_that_day, sh.first_add_shipping_info_that_day,
          p.first_purchase_that_day, 
          DATETIME_DIFF(v.first_view_item_that_day, e.first_event_that_day,MINUTE) minutes_until_view_item,
          DATETIME_DIFF(a.first_add_to_cart_that_day, e.first_event_that_day,MINUTE)
          minutes_until_add_to_cart,
          DATETIME_DIFF(b.first_begin_checkout_that_day, e.first_event_that_day,MINUTE)
          minutes_until_begin_checkout,
          DATETIME_DIFF(ap.first_add_payment_info_that_day, e.first_event_that_day,MINUTE)
          minutes_until_add_payment_info,
          DATETIME_DIFF(sh.first_add_shipping_info_that_day, e.first_event_that_day,MINUTE)
          minutes_until_add_shipping_info,
          DATETIME_DIFF(p.first_purchase_that_day, e.first_event_that_day,MINUTE) minutes_until_purchase
FROM purchases p
JOIN events e ON e.event_date=p.purchase_date AND e.user_pseudo_id=p.user_pseudo_id
LEFT JOIN view_item v ON v.event_date=p.purchase_date AND v.user_pseudo_id=p.user_pseudo_id
LEFT JOIN add_to_cart a ON a.event_date=p.purchase_date AND a.user_pseudo_id=p.user_pseudo_id
LEFT JOIN begin_checkout b ON b.event_date=p.purchase_date AND b.user_pseudo_id=p.user_pseudo_id
LEFT JOIN add_payment_info ap ON ap.event_date=p.purchase_date AND ap.user_pseudo_id=p.user_pseudo_id
LEFT JOIN add_shipping_info sh ON sh.event_date=p.purchase_date AND sh.user_pseudo_id=p.user_pseudo_id
