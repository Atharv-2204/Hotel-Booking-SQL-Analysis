--Cancellation risk by lead time
SELECT
  CASE
    WHEN lead_time BETWEEN 0 AND 30   THEN '0–30 days'
    WHEN lead_time BETWEEN 31 AND 90  THEN '31–90 days'
    WHEN lead_time BETWEEN 91 AND 180 THEN '91–180 days'
    ELSE '180+ days'
  END AS lead_time_bucket,
  COUNT(*) AS total_bookings,
  SUM(is_canceled) AS cancellations,
  ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 1) AS cancel_rate_pct
FROM hotel_bookings
GROUP BY lead_time_bucket
ORDER BY cancel_rate_pct DESC;

--Average length of stay by hotel & customer type
WITH stay_data AS (
  SELECT
    hotel,
    customer_type,
    (stays_in_weekend_nights + stays_in_week_nights) AS total_nights,
    adr,
    adr * (stays_in_weekend_nights + stays_in_week_nights) AS booking_revenue
  FROM hotel_bookings
  WHERE is_canceled = 0
    AND (stays_in_weekend_nights + stays_in_week_nights) > 0
)
SELECT
  hotel,
  customer_type,
  COUNT(*) AS bookings,
  ROUND(AVG(total_nights), 1) AS avg_nights,
  ROUND(AVG(adr), 2) AS avg_daily_rate,
  ROUND(SUM(booking_revenue), 2) AS total_revenue
FROM stay_data
GROUP BY hotel, customer_type
ORDER BY total_revenue DESC;


--Deposit type vs cancellation rate
SELECT
  deposit_type,
  COUNT(*) AS total_bookings,
  SUM(is_canceled) AS cancellations,
  ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 1) AS cancel_rate_pct,
  ROUND(AVG(adr), 2) AS avg_daily_rate
FROM hotel_bookings
GROUP BY deposit_type
ORDER BY cancel_rate_pct DESC;
