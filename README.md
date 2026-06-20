# 🏨 Hotel Booking Demand — SQL Analysis

An in-depth SQL analysis of 119,390 hotel bookings using PostgreSQL, uncovering patterns in cancellations, revenue, guest behavior, and seasonal demand across two hotel types.

---

## 🎯 Project Objective

To analyse **3 years of hotel booking data (2015–2017)** and answer key business questions:
- Why do guests cancel, and which factors predict cancellation risk?
- Which months, countries, and market segments drive the most revenue?
- How does lead time, deposit type, and guest history affect booking behavior?
- What is the hotel's RevPAR (Revenue Per Available Room) — a real industry KPI?

---

## 📁 Repository Structure

```
📂 Hotel-Booking-SQL-Analysis/
├── 📂 queries/
│   ├── 01_exploration.sql        ← Basic SELECT, GROUP BY, WHERE
│   ├── 02_intermediate.sql       ← CASE WHEN, CTEs, subqueries
│   ├── 03_window_functions.sql   ← LAG(), RANK(), SUM() OVER
│   └── 04_advanced.sql           ← RevPAR, guest segmentation
├── 📂 results/
│   ├── q1_summary.png
│   ├── q7_deposit_insight.png
│   └── q13_revpar.png
└── README.md
```

---

## 🗄️ Dataset

**Source:** Kaggle — [Hotel Booking Demand](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand)

| Detail | Info |
|---|---|
| Rows | 119,390 bookings |
| Columns | 32 |
| Period | July 2015 – August 2017 |
| Hotel types | City Hotel, Resort Hotel |
| Tool used | PostgreSQL via pgAdmin 4 |

---

## 🔑 Key Findings

1. **Cancellation rates differ sharply by hotel type** — City Hotel sees a ~41.7% cancellation rate compared to Resort Hotel's ~27.7%, suggesting business travelers cancel more readily than leisure guests.
2. **Non-refundable deposits paradoxically cancel the most** — bookings with a "Non Refund" deposit type show a 99%+ cancellation rate, a pattern consistent with travel agents pre-booking inventory and cancelling unsold rooms.
3. **Longer lead times mean higher cancellation risk** — bookings made 180+ days in advance cancel at roughly double the rate of bookings made within the same week of arrival.
4. **Repeat guests are rare but valuable** — only about 3.2% of bookings come from repeat guests, highlighting a significant loyalty and retention opportunity.
5. **Clear seasonality in revenue** — August consistently posts the highest monthly revenue across all three years, while January is the weakest month, confirming strong summer-driven demand.
6. **RevPAR varies meaningfully by month** — combining occupancy rate with average daily rate reveals which months are truly most profitable, not just busiest.

---

## 🛠️ SQL Skills Demonstrated

| Skill | Where it's used |
|---|---|
| Aggregate functions | `COUNT`, `SUM`, `AVG`, `ROUND` across all queries |
| Filtering | `WHERE`, `HAVING` with aggregate conditions |
| Conditional logic | `CASE WHEN` for cancellation buckets, guest type, room assignment |
| CTEs | `WITH` clauses structuring multi-step logic across all advanced queries |
| Window functions | `LAG() OVER`, `RANK() OVER`, `SUM() OVER` for trend and ranking analysis |
| Date handling | `TO_DATE()` to correctly sort text-based month names chronologically |
| Business KPIs | RevPAR (Revenue Per Available Room) calculation |
| Data cleaning | Handling NULL values in `children` and `country` columns |

---

## 📊 Sample Query — Month-over-Month Revenue Growth

```sql
WITH monthly_rev AS (
  SELECT
    arrival_date_year AS year,
    arrival_date_month AS month,
    TO_DATE(arrival_date_month, 'Month') AS month_num,
    ROUND(SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)), 2) AS revenue
  FROM hotel_bookings
  WHERE is_canceled = 0
  GROUP BY arrival_date_year, arrival_date_month
)
SELECT
  year, month, revenue,
  LAG(revenue) OVER (ORDER BY year, month_num) AS prev_month_rev,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY year, month_num)) * 100.0
    / LAG(revenue) OVER (ORDER BY year, month_num), 1
  ) AS mom_growth_pct
FROM monthly_rev
ORDER BY year, month_num;
```

> Full set of 13 queries available in the `queries/` folder.

---

## 🚀 How to Run This Project

1. Install **PostgreSQL** and **pgAdmin 4**
2. Create a new database: `hotel_analysis`
3. Run the `CREATE TABLE` statement (included in `01_exploration.sql`)
4. Import `hotel_bookings.csv` via pgAdmin's Import/Export Data tool
5. Run the cleanup queries to handle NULLs in `children` and `country`
6. Execute queries from the `queries/` folder in order

---

## 💡 What I Learned

- How to debug a real chronological-sorting bug (text month names sorting alphabetically instead of by calendar order) using `TO_DATE()`
- The difference between using a column alias vs. repeating the aggregate function in `HAVING` — a PostgreSQL-specific SQL standard rule
- How `PARTITION BY` resets window function calculations at group boundaries, and when to use vs. omit it
- How to translate a real hospitality industry KPI (RevPAR) into a working SQL query
- The importance of filtering out cancelled bookings before calculating revenue metrics

---

## 🙋 About

Built by **[Your Name]** as part of a data analyst portfolio project.

- 🔗 LinkedIn: [your-linkedin-url]
- 📧 Email: your@email.com

---

*If you found this useful, please ⭐ star the repository!*
