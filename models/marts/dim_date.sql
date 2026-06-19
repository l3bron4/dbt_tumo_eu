{{
    config(
        materialized='table'
    )
}}

WITH date_range AS (
  SELECT 
    DATE('2022-01-01') AS start_date,
    DATE('2025-12-31') AS end_date
),

all_dates AS (
  SELECT 
    date_day
  FROM date_range,
  UNNEST(GENERATE_DATE_ARRAY(start_date, end_date, INTERVAL 1 DAY)) AS date_day
)

SELECT
  CAST(date_day AS DATE) AS date,
  EXTRACT(YEAR FROM date_day) AS year,
  
  -- Calcul de l'année scolaire
  CASE 
    WHEN EXTRACT(MONTH FROM date_day) >= 9 THEN 
      CONCAT(CAST(EXTRACT(YEAR FROM date_day) AS STRING), '-', CAST(EXTRACT(YEAR FROM date_day) + 1 AS STRING))
    ELSE 
      CONCAT(CAST(EXTRACT(YEAR FROM date_day) - 1 AS STRING), '-', CAST(EXTRACT(YEAR FROM date_day) AS STRING))
  END AS school_year,

  EXTRACT(MONTH FROM date_day) AS month,
  EXTRACT(DAY FROM date_day) AS day,
  EXTRACT(WEEK(MONDAY) FROM date_day) AS week_number,

FROM all_dates