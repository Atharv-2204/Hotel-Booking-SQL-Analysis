--Monthly revenue with running total
WITH monthly_rev AS (
  SELECT
    arrival_date_year AS year,
    arrival_date_month AS month,
    ROUND(SUM(
      adr * (stays_in_weekend_nights + stays_in_week_nights)
    ), 2) AS monthly_revenue
  FROM hotel_bookings
  WHERE is_canceled = 0
  GROUP BY year, month
)
SELECT
  year, month, monthly_revenue,
  ROUND(SUM(monthly_revenue) OVER (
    ORDER BY year, month
  ), 2) AS running_total
FROM monthly_rev
ORDER BY year, month;

--Month-over-month revenue growth using LAG()
WITH monthly_rev AS (
  SELECT
    arrival_date_year AS year,
    arrival_date_month AS month,
    ROUND(SUM(adr * (stays_in_weekend_nights
      + stays_in_week_nights)), 2) AS revenue
  FROM hotel_bookings
  WHERE is_canceled = 0
  GROUP BY year, month
)
SELECT
  year, month, revenue,
  LAG(revenue) OVER (PARTITION BY year ORDER BY month) AS prev_month_rev,
  ROUND(
    (revenue - LAG(revenue) OVER
      (PARTITION BY year ORDER BY month))
    * 100.0
    / LAG(revenue) OVER
      (PARTITION BY year ORDER BY month),
  1) AS mom_growth_pct
FROM monthly_rev
ORDER BY year, month;

--Rank countries by revenue within each hotel type
WITH country_rev AS (
  SELECT
    hotel, country,
    ROUND(SUM(adr * (stays_in_weekend_nights
      + stays_in_week_nights)), 2) AS revenue,
    COUNT(*) AS bookings
  FROM hotel_bookings
  WHERE is_canceled = 0 AND country != 'Unknown'
  GROUP BY hotel, country
),
ranked AS (
  SELECT *,
    RANK() OVER (
      PARTITION BY hotel
      ORDER BY revenue DESC
    ) AS revenue_rank
  FROM country_rev
)
SELECT * FROM ranked
WHERE revenue_rank <= 5
ORDER BY hotel, revenue_rank;