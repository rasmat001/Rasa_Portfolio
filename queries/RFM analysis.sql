--checking if there are null values

/*
SELECT
column_name,
COUNT(1) AS nulls_count
FROM `tc-da-1.turing_data_analytics.rfm` ,
UNNEST(REGEXP_EXTRACT_ALL( TO_JSON_STRING (`tc-da-1.turing_data_analytics.rfm`) , r'"(\w+)":null')) column_name
GROUP BY column_name
*/

--querying recency, frequency, monetary values for each customer

WITH t1 AS (
    SELECT customerID, DATE_DIFF(CAST ('2011-12-01' AS DATE), DATE(last_purchase), day) recency,
            frequency, monetary
    FROM (
      SELECT customerID, MAX(InvoiceDate) last_purchase, COUNT(DISTINCT InvoiceNo) frequency, 
              SUM(Quantity*UnitPrice) monetary
      FROM `tc-da-1.turing_data_analytics.rfm` 
      WHERE CustomerID IS NOT NULL 
            AND InvoiceDate BETWEEN '2010-12-01' AND '2011-12-02'
            AND Quantity>0 AND UnitPrice <>0
      GROUP BY customerID)),
--finding quantiles and percentiles
t2 AS (
    SELECT t1.*,
      sub.r_percentiles[offset(25)] r25,
      sub.r_percentiles[offset(50)] r50,
      sub.r_percentiles[offset(75)] r75,
      sub.r_percentiles[offset(100)] r100,
      sub.f_percentiles[offset(25)] f25,
      sub.f_percentiles[offset(50)] f50,
      sub.f_percentiles[offset(75)] f75,
      sub.f_percentiles[offset(100)] f100,
      sub.m_percentiles[offset(25)] m25,
      sub.m_percentiles[offset(50)] m50,
      sub.m_percentiles[offset(75)] m75,
      sub.m_percentiles[offset(100)] m100,
    FROM (
        SELECT APPROX_QUANTILES(recency, 100) r_percentiles,
              APPROX_QUANTILES(frequency, 100) f_percentiles,
              APPROX_QUANTILES(monetary, 100) m_percentiles 
        FROM t1) sub, t1),
--creating RFM score
t3 AS (
    SELECT t2.*,
      CASE WHEN recency <= r25     THEN 4
              WHEN recency <= r50  THEN 3 
              WHEN recency <= r75  THEN 2
              WHEN recency <= r100 THEN 1
          END AS r_score,
      CASE WHEN frequency <= f25     THEN 1
              WHEN frequency <= f50  THEN 2 
              WHEN frequency <= f75  THEN 3
              WHEN frequency <= f100 THEN 4
          END AS f_score,
      CASE WHEN monetary <= m25     THEN 1
              WHEN monetary <= m50  THEN 2 
              WHEN monetary <= m75  THEN 3 
              WHEN monetary <= m100 THEN 4
          END AS m_score,
    FROM t2),
t4 AS (
    SELECT t3.*, CONCAT(r_score,f_score,m_score) rfm_score
    FROM t3)

SELECT customerID, recency, frequency,monetary,
   CASE 
            WHEN RegexP_CONTAINS(rfm_score, '444')  THEN 'Best Customers'
            WHEN RegexP_CONTAINS(rfm_score, '[34]4.') THEN 'Loyal Customers'
            WHEN RegexP_CONTAINS(rfm_score, '[34][23].') THEN'Potential Loyalists'
            WHEN RegexP_CONTAINS(rfm_score, '[234].4')  THEN 'Big Spenders'
            WHEN RegexP_CONTAINS(rfm_score, '[34]1.')  THEN 'New Customers'
            WHEN RegexP_CONTAINS(rfm_score, '2..')  THEN 'Almost Lost'
            WHEN RegexP_CONTAINS(rfm_score, '1.[34]') THEN 'Lost Customers'
            WHEN RegexP_CONTAINS(rfm_score, '1.[12]')  THEN 'Lost Cheap Customers'
   END rfm_segment
FROM t4
