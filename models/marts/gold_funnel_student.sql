{{
    config(
        materialized='table'
    )
}}

WITH start_info AS(
    SELECT
      *,
      'start' AS type,
    FROM(
      SELECT
        is_closed,
        COUNT(*) AS nb,
        0 AS duree,
      FROM {{ ref('int_student_lab_date_waiting_time') }}
      WHERE first_day_date IS NOT NULL
      GROUP BY is_closed
    )
  )

, path_info AS(
    SELECT
      *,
      'path' AS type,
    FROM(
      SELECT
        is_closed,
        COUNT(*) AS nb,
        ROUND(AVG(path_time), 0) AS path_time,
      FROM {{ ref('int_student_lab_date_waiting_time') }}
      WHERE path_date IS NOT NULL
      GROUP BY is_closed  
    )
  )

, lab1_info AS(
    SELECT
      *,
      'lab1' AS type,
    FROM(
      SELECT
        is_closed,
        COUNT(*) AS nb,
        ROUND(AVG(lab_1_time), 0) AS lab_1_time,
      FROM {{ ref('int_student_lab_date_waiting_time') }}
      WHERE lab_1_start_date IS NOT NULL
      GROUP BY is_closed  
    )
  )

, lab2_info AS(
    SELECT
      *,
      'lab2' AS type,
    FROM(
      SELECT
        is_closed,
        COUNT(*) AS nb,
        ROUND(AVG(lab_2_time), 0) AS lab_2_time,
      FROM {{ ref('int_student_lab_date_waiting_time') }}
      WHERE lab_2_start_date IS NOT NULL
      GROUP BY is_closed  
    )
  )

, lab3_info AS(
    SELECT
      *,
      'lab3' AS type,
    FROM(
      SELECT
        is_closed,
        COUNT(*) AS nb,
        ROUND(AVG(lab_2_time), 0) AS lab_3_time,
      FROM {{ ref('int_student_lab_date_waiting_time') }}
      WHERE lab_3_start_date IS NOT NULL
      GROUP BY is_closed  
    )
  )

, lab4_info AS(
    SELECT
      *,
      'lab4+' AS type,
    FROM(
      SELECT
        is_closed,
        COUNT(*) AS nb,
        ROUND(AVG(lab_4_time), 0) AS lab_4_time,
      FROM {{ ref('int_student_lab_date_waiting_time') }}
      WHERE lab_4_start_date IS NOT NULL
      GROUP BY is_closed  
    )
  )

  SELECT * FROM start_info
  UNION ALL
  SELECT * FROM path_info  
  UNION ALL
  SELECT * FROM lab1_info
  UNION ALL
  SELECT * FROM lab2_info
  UNION ALL
  SELECT * FROM lab3_info
  UNION ALL
  SELECT * FROM lab4_info