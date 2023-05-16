--deduplicating review scores for the same order
with dedup_reviews as (
  select order_id, MIN(review_score) review_score
  from `olist_db.olist_order_reviews_dataset`
  group by 1
)

SELECT oi.order_id, oi.product_id, oi.seller_id, oi.price, oi.freight_value,
      REPLACE (pc.string_field_1, '_',' ') product_category,
      o.order_purchase_timestamp, o.order_approved_at, o.order_delivered_carrier_date,
      o.order_delivered_customer_date,o.order_estimated_delivery_date,
      dr.review_score,
      os.seller_city, os.seller_state,
      c.customer_unique_id, c.customer_city, c.customer_state,
      --calculating values for each order
      MAX(oi.order_item_id) OVER (PARTITION BY oi.order_id) order_items,
      SUM(oi.price) OVER (PARTITION BY oi.order_id) order_price_value,
      SUM(oi.freight_value) OVER (PARTITION BY oi.order_id) order_freight_value,
      SUM(oi.freight_value+oi.price) OVER (PARTITION BY oi.order_id) order_total_value
  FROM `tc-da-1.olist_db.olist_order_items_dataset` oi 
  LEFT JOIN `olist_db.olist_orders_dataset` o
        ON oi.order_id=o.order_id
  LEFT JOIN `olist_db.olist_products_dataset` p 
        ON oi.product_id=p.product_id
  LEFT JOIN `olist_db.product_category_name_translation` pc 
        ON p.product_category_name=pc.string_field_0
  LEFT JOIN dedup_reviews dr
        ON dr.order_id=o.order_id
  LEFT JOIN `olist_db.olist_sellers_dataset` os
        ON os.seller_id=oi.seller_id
  LEFT JOIN `olist_db.olist_customesr_dataset` c
        ON c.customer_id=o.customer_id
  WHERE o.order_purchase_timestamp>'2016-12-31'
