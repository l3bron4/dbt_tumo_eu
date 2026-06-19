{{
    config(
        materialized='view'
    )
}}

WITH ref_lab AS (

    SELECT * FROM {{ ref('stg_tumo_raw_us__LAB_events') }}

)

, user_lab_count_date AS (
    SELECT
      user_id,
      ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY lab_start_date) AS num_lab_count,
      workshop,
      lab_start_date,
      lab_end_date
    FROM ref_lab
  )

, user_lab_date AS (
    SELECT
      b.user_id,
      b.is_closed,
      MIN(b.first_day_date) AS first_day_date,
      MIN(b.path_date) AS path_date,
      MIN(IF(num_lab_count = 1, lab_start_date, NULL)) AS lab_1_start_date,
      MIN(IF(num_lab_count = 1, lab_end_date, NULL)) AS lab_1_end_date,
      MIN(IF(num_lab_count = 2, lab_start_date, NULL)) AS lab_2_start_date,
      MIN(IF(num_lab_count = 2, lab_end_date, NULL)) AS lab_2_end_date,
      MIN(IF(num_lab_count = 3, lab_start_date, NULL)) AS lab_3_start_date,
      MIN(IF(num_lab_count = 3, lab_end_date, NULL)) AS lab_3_end_date,
      MIN(IF(num_lab_count = 4, lab_start_date, NULL)) AS lab_4_start_date,
      MIN(IF(num_lab_count = 4, lab_end_date, NULL)) AS lab_4_end_date,
      MIN(b.churn_date) AS churn_date
    FROM {{ ref('stg_tumo_raw_us__Student_list_info_performance') }} b
    LEFT JOIN user_lab_count_date l
      ON b.user_id = l.user_id
    GROUP BY b.user_id, b.is_closed
  )

, user_lab_date_ready AS (
    SELECT
      *,
      DATE_DIFF(path_date, first_day_date, DAY) AS path_time,
      DATE_DIFF(lab_1_start_date, first_day_date, DAY) AS lab_1_time_since_start,
      DATE_DIFF(lab_1_start_date, path_date, DAY) AS lab_1_time,
      DATE_DIFF(lab_2_start_date, lab_1_end_date, DAY) AS lab_2_time,
      DATE_DIFF(lab_3_start_date, lab_2_end_date, DAY) AS lab_3_time,
      DATE_DIFF(lab_4_start_date, lab_3_end_date, DAY) AS lab_4_time,
      DATE_DIFF(churn_date, first_day_date, DAY) AS tumo_time
    FROM user_lab_date
  )

  SELECT * FROM user_lab_date_ready