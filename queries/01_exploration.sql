-- Overall booking summary
SELECT
  hotel,
  COUNT(*) AS total_bookings,
  SUM(is_canceled) AS cancellations,
  ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 1) AS cancel_rate_pct,
  ROUND(AVG(adr), 2) AS avg_daily_rate
FROM hotel_bookings
GROUP BY hotel
ORDER BY total_bookings DESC;

-- Monthly booking trend
SELECT
  arrival_date_year AS year,
  arrival_date_month AS month,
  COUNT(*) AS bookings,
  ROUND(AVG(adr), 2) AS avg_rate
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY year, month
ORDER BY year, bookings DESC;


--Top 10 countries by bookings
SELECT
  country,
  COUNT(*) AS total_bookings,
  SUM(is_canceled) AS cancellations,
  ROUND(AVG(adr), 2) AS avg_daily_rate
FROM hotel_bookings
WHERE country != 'NULL'
GROUP BY country
ORDER BY total_bookings DESC
LIMIT 10;

--Revenue by market segment
SELECT
  market_segment,
  COUNT(*) AS bookings,
  ROUND(AVG(adr), 2) AS avg_rate,
  ROUND(SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)), 2) AS total_revenue
FROM hotel_bookings
WHERE is_canceled = 0
GROUP BY market_segment
HAVING COUNT(*) > 100
ORDER BY total_revenue DESC;
