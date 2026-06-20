--Room type upgrade analysis
SELECT
  hotel,
  CASE
    WHEN reserved_room_type = assigned_room_type THEN 'Same Room'
    ELSE 'Room Changed'
  END AS room_assignment,
  COUNT(*) AS bookings,
  ROUND(AVG(adr), 2) AS avg_rate,
  ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 1) AS cancel_rate_pct
FROM hotel_bookings
GROUP BY hotel, room_assignment
ORDER BY hotel, room_assignment;

--Guest repeat booking analysis
SELECT
  hotel,
  CASE
    WHEN is_repeated_guest = 1 THEN 'Repeat Guest'
    ELSE 'New Guest'
  END AS guest_type,
  COUNT(*) AS bookings,
  ROUND(AVG(adr), 2) AS avg_daily_rate,
  ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 1) AS cancel_rate_pct,
  ROUND(AVG(
    stays_in_weekend_nights + stays_in_week_nights
  ), 1) AS avg_stay_nights
FROM hotel_bookings
GROUP BY hotel, guest_type
ORDER BY hotel, guest_type;

--Revenue per available room(revpar) 
WITH monthly_stats AS (
  SELECT
    hotel,
    arrival_date_year AS year,
    arrival_date_month AS month,
	TO_DATE(arrival_date_month, 'Month') AS month_num,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN is_canceled = 0 THEN 1 ELSE 0 END) AS stayed,
    ROUND(AVG(CASE WHEN is_canceled = 0
      THEN adr END), 2) AS avg_adr
  FROM hotel_bookings
  GROUP BY hotel, year, month
)
SELECT
  hotel, year, month,
  total_bookings, stayed,
  avg_adr,
  ROUND(stayed * 100.0 / total_bookings, 1) AS occupancy_pct,
  ROUND(avg_adr * (stayed * 1.0 / total_bookings), 2) AS revpar
FROM monthly_stats
ORDER BY hotel, year, month_num, month;